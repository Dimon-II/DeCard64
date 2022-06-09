unit u_Html2SVG;

interface

uses Profixxml, System.Classes;

function Processcard(row:TStrings; prefix: string; AXML, Clipart:TXml_Doc; ATempFolder, AClipartName, ARootName:string): string;
function GetSVGSize(const FileName, ID:string):string;
function html2svg(ASvg,DPI,AFilter, TopStyle:string; NOD:TXML_Nod; Clipart:TXML_Doc; AClipartName, ARootName:string):string;
function SvgFloat(d:double):string;
procedure AddClipart(XML, Clipart:TXML_Doc;AClipartName:string);

implementation

{$WARN IMPLICIT_STRING_CAST OFF}

uses system.sysutils, system.strutils, System.Types, system.Math, Vcl.Graphics,
u_ThreadRender, VCL.Forms, u_MainForm, Winapi.Windows, unaRE;

var   FBufXml:TStringList;


function SvgFloat(d:double):string;
begin
  str(d:0:4,result);
end;

function FontSizeConv(const Str: string; OldSize: double; DPI:string): double;
{given a font-size string, return the point size}
var
  DefPointSize,V, PPI: double;
  S1, S2: string;
  I, J: integer;
begin
DefPointSize := StrToIntDef(DPI,14);
PPI := Screen.PixelsPerInch;
Val(Str, V, I);
J := Pos('e', Str);   {'e' would be legal for Val but not for us}
if (J <> 0) and (I > J) then
  I := J;
if I > 0 then
  begin
  S1 := Copy(Str, 1, I-1);
  S2 := Trim(Copy(Str, I, Length(Str)-I+1));
  end
else
  begin
  S1 := Str;
  S2 := '';
  end;
{S1 has the number, S2 the units}
Val(S1, V, I);
if S2 = 'svg' then
else
if S2 = 'in' then
  V := 72.0*V
else if S2 = 'cm' then
  V := 72.0*V/2.54
else if S2 = 'mm' then
  V := 72.0*V/25.4
else if S2 = 'pt' then
else if S2 = 'px' then
  V := V*72.0/PPI
else if S2 = 'pc' then
  V := V*12.0
else if S2 = 'em' then
  V := V*OldSize
else if S2 = 'ex' then
  V := V*OldSize/2.0        {1/2 of em}
else if S2 = '%' then
  V := V*OldSize/100.0
else if S2 = 'smaller' then
  V := 0.75*OldSize
else if S2 = 'larger' then
  V := 1.25*OldSize
else if S2 = 'xx-small' then
  V := DefPointSize/1.5
else if S2 = 'x-small' then
  V := DefPointSize/1.2
else if S2 = 'small' then
  V := DefPointSize
else if S2 = 'medium' then
  V := DefPointSize*1.2
else if S2 = 'large' then
  V := DefPointSize*1.5
else if S2 = 'x-large' then
  V := DefPointSize*2.0
else if S2 = 'xx-large' then
  V := DefPointSize*3.0
else if S1 = '1' then
  V := DefPointSize/1.5
else if S1 = '2' then
  V := DefPointSize
else if S1 = '3'then
  V := DefPointSize*1.2
else if S1 = '4'then
  V := DefPointSize*1.5
else if S1 = '5'then
  V := DefPointSize*2.0
else if S1 = '6'then
  V := DefPointSize*3.0
else if S1 = '7'then
  V := DefPointSize*4.5
else if S2 = '' then
  V := V*72.0/PPI        {pixels by default}
else V := DefPointSize;   {error, return 12pt}
Result := V;
end;


function HtmlLength(s:string):integer;
var i:Integer;
    amp:Boolean;
    ws:string;
begin
  ws:=(s);

  amp:=false;
  Result := 0;
  for i:=1 to Length(ws) do
    if ws[i]='&' then
       amp := True
    else
    if ws[i]=';' then
       amp := False
    else
    if not amp then
      Inc(result);

end;


procedure AddClipart(XML, Clipart:TXML_Doc;AClipartName:string);
var nod:TXML_Nod;
begin
  if Clipart.Nodes.count >0 then
    if Clipart.Nodes.Last.Nodes.count >0 then
    begin
      nod:= XML.Nodes.Last.Add('defs');
      nod.ResetXml(
         StringReplace(StringReplace(Clipart.Node['svg'].xml
         , ' id="',  ' id="clipart',[rfReplaceAll])
         , AClipartName+'#', '#clipart', [rfReplaceAll]));
      nod.LocalName := 'defs';
    end;
end;


function ParentStyle(ANod:TXML_Nod;aAttr:string;Def:string=''):string;
var Nod:TXML_Nod;
begin
  Nod := ANod;
  repeat
     if (aAttr='filter')and(Nod.LocalName='foreignObject') then
       break;
     result := Nod.Attribute[aAttr];
     Nod := Nod.parent;
  until (Result<>'') or (Nod = nil) ;

  if Result='' then Result := Def;

end;


function Processcard(row:TStrings; prefix: string; AXML, Clipart:TXml_Doc; ATempFolder, AClipartName, ARootName:string): string;
var
  s,ss:string;

  xxx: TXml_doc;

  NodeStack,
  ReplStack:TList;




function DoReplace(txt:string;Nod:TXML_Nod):string;
var i:integer;
  s,n,r:string;
  sn, idx:TStringList;
  Prnt:TXML_Nod;
begin

//  sn:=TStringList.Create;
  idx:=TStringList.Create;
  idx.Sorted := True;
  idx.CaseSensitive := True;
  try
    s := txt;

    for i:=0 to row.Count-1 do
      if Pos('['+IntToStr(i)+']',s) >0 then
      begin
        s := StringReplace(s,'['+IntToStr(i)+']', row[i],[rfReplaceAll]);
      end;

    Prnt := Nod;
    while Assigned(Prnt) do
    begin
      if NodeStack.IndexOf(Prnt) = -1 then
      begin
        NodeStack.Add(Prnt);
        ss:= Prnt.Attribute['dekart:replace'];

        if ss <> '' then
        begin
          sn:=TStringList.Create;
          sn.Text := ss;
          ReplStack.Add(sn);
        end
        else
          ReplStack.Add(nil);
      end;

      sn := ReplStack.Items[NodeStack.IndexOf(Prnt)];


//      sn.Sorted := True;
      if sn <> nil then
      for i:=0 to sn.Count-1 do
      if Pos('=', sn[i])>0 then
      begin
        n:=Copy(sn[i], 1, Pos('=', sn[i])-1);


        if idx.IndexOf(n)=-1 then
        begin
          idx.Add(n);


          r := copy(sn[i],length(n)+2, Length(sn[i]));
          if Pos(WideUpperCase(WideString(n)), WideUpperCase(s)) >0 then
          begin
            if copy(r,1,1)='=' then
              s := StringReplace(s, n, copy(r,2,length(r)) ,[rfReplaceAll])
            else
              s := StringReplace(s, n, r ,[rfReplaceAll, rfIgnoreCase]);
          end
          else
          if copy(r,1,1)='$' then
            s := unaRe.replace(s,n,copy(r,2,length(r)),1,True);


        end;

      end;

      Prnt := Prnt.parent;
    end;

    Result := s;

  finally
    idx.Free;
//    sn.Free;
  end;
//  StopAnalitics('Replace');
end;

function SvgFontWidth(Atext, AStyle:string):Integer;
var
  s:string;
  i:Integer;
  z:double;

begin
//  StartAnalitics('Sizing');
{
  i:= MyStack.IndexOf('<' + AStyle +'>'+Atext );
  if i > -1 then
  begin
    Result := integer(MyStack.Objects[i]);
    exit;
  end;
}
  if Trim(Atext)='' then begin
    result:=1;
    exit;
  end;

  s := Atext;
  if LeftStr(s,1)=' ' then s := '.'+s;
  if RightStr(s,1)=' ' then s := Trim(s)+' .';

  FBufXml.Clear;
  FBufXml.Add('<?xml version="1.0" encoding="UTF-8"?>');
  FBufXml.Add('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">');
  FBufXml.Add('<svg xmlns:xlink="http://www.w3.org/1999/xlink" fill="black" font-weight="normal" stroke-width="1"  xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto" width="1" height="1">');
  FBufXml.Add('<text y="50" id="txt" '+AStyle+'>'+ (S) +'</text><rect id="dummy" width="100" height="100"/></svg>');
  s := GetSVGSize(ATempFolder + '###.svg', 'txt');
  Delete(s,1,Pos(',',s));
  Delete(s,1,Pos(',',s));
  Delete(s,1,Pos(',',s));
  Delete(s,Pos(',',s),256);

  val(s,z,i);
  Result := round(z);
//  DeleteFile(Main.edCfgRoot.Text + Main.edCfgTemp.Text + '###.svg');

//  StopAnalitics('Sizing');
end;

procedure FormatText(nod:TXML_Nod);
var ss,s,z:string;
  i,j,sp, err:integer;
  fsp:Double;
  sl,sr :TStringList;
  r1,r2,r3:TRect;
  SzMax,SzTxt, SzLine:TPoint;
  DoZoom, DoWidth:boolean;

  function SizeParse(sz:string):TRect;
  var
    s:string;
    err:Integer;
  begin
    s:=sz;
    Delete(s,1,Pos(',',s));
    Val(Copy(s,1,Pos(',',s)-1), Result.Left,err);
    Delete(s,1,Pos(',',s));
    Val(Copy(s,1,Pos(',',s)-1), Result.Top,err);
    Delete(s,1,Pos(',',s));
    Val(Copy(s,1,Pos(',',s)-1), Result.Right,err);
    Delete(s,1,Pos(',',s));
    Val(s, Result.Bottom,err);

    Result.Right := Result.Right + Result.Left;




  end;


begin
  nod.Attribute['text-anchor'] := ParentStyle(nod,'text-anchor');
  nod.Attribute['font-size'] := ParentStyle(nod,'font-size');
  nod.Attribute['font-family'] := ParentStyle(nod,'font-family');
  nod.Attribute['font-weight'] := ParentStyle(nod,'font-weight');
  nod.Attribute['font-style'] := ParentStyle(nod,'font-style');
  nod.Attribute['letter-spacing'] := ParentStyle(nod,'letter-spacing','0');
  nod.Attribute['font-variant'] := ParentStyle(nod,'font-variant');

  Nod.text := StringReplace(Nod.text,'[p]',' [p] ',[rfReplaceAll, rfIgnoreCase]);
  Nod.text := StringReplace(Nod.text,'  ',' ',[rfReplaceAll, rfIgnoreCase]);

  if Pos(WideString('[U]'),WideUpperCase(Nod.text))>0 then
  begin
    s := WideUpperCase(Nod.text);
    s := StringReplace(s,'&#X','&#x',[rfReplaceAll, rfIgnoreCase]);
    Nod.text := StringReplace(s,'[U]','',[rfReplaceAll, rfIgnoreCase]);
  end;

  if ParentStyle(nod,'font-variant')='small' then
    Nod.text := WideLowerCase(Nod.text)
  else
  if ParentStyle(nod,'font-variant')='caps' then
    Nod.text := StringReplace(WideUpperCase(Nod.text),'&#X','&#x',[rfReplaceAll, rfIgnoreCase])
  else
  if ParentStyle(nod,'font-variant')='first' then
    Nod.text := WideUpperCase(copy(Nod.text,1,1)) + WideLowerCase(copy(Nod.text,2,length(Nod.text)-1));

  if Pos(WideString('[Z]'),WideUpperCase(Nod.text))>0 then
  begin
    Nod.text := StringReplace(Nod.text,'[Z]','',[rfReplaceAll, rfIgnoreCase]);
    DoZoom := True
  end
  else
    DoZoom := false;

  if (Pos(WideString('[W]'),WideUpperCase(Nod.text))>0) or (nod.Attribute['textLength']<>'') then
  begin
    Nod.text := StringReplace(Nod.text,'[W]','',[rfReplaceAll, rfIgnoreCase]);
    DoWidth := True
  end
  else
    DoWidth := false;


  if trim(Nod.text)='' then exit;

  if Assigned(nod.Nodes.ByName('rect')) or (nod.Attribute['textLength']<>'')  then
  begin
    sl:=TStringList.Create;
    sr:=TStringList.Create;
  try

    s := StringReplace(Trim(Nod.text),'  ', ' ', [rfReplaceAll]) + ' ';
    s := StringReplace(s, '<', '&lt;', [rfReplaceAll]) ;
    s := StringReplace(s, '>', '&gt;', [rfReplaceAll]) ;
    while Pos(' ',s)>0 do
    begin
      sl.Add(Copy(s,1,Pos(' ', s+' ' )-1));
      s := copy(s,Pos(' ', s+' ' )+1,length(s));


    end;

    if Assigned(nod.Nodes.ByName('rect'))  then
    begin
      SzMax.X := StrToIntDef(nod.Node['rect'].Attribute['width'],0);
      SzMax.Y := StrToIntDef(nod.Node['rect'].Attribute['height'],0);
    end
    else
    begin
      SzMax.X := StrToIntDef(nod.Attribute['textLength'],64);
      SzMax.Y := 0;
    end;
   repeat
    z:='';
    FBufXml.Clear;
    FBufXml.Add('<?xml version="1.0" encoding="UTF-8"?>');
    FBufXml.Add('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">');
    FBufXml.Add('<svg xmlns:xlink="http://www.w3.org/1999/xlink" fill="black" font-weight="normal" stroke-width="1"  xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto" width="1" height="1">');
    FBufXml.Add('<g font-size="'+nod.Attribute['font-size']
              +'" font-family="'+nod.Attribute['font-family']
              +'" letter-spacing="'+nod.Attribute['letter-spacing']
              +'" font-weight="'+ nod.Attribute['font-weight']
              +'" font-style="'+ nod.Attribute['font-style']+'">');
    for i:=0 to sl.Count-1 do
    begin
      FBufXml.Add('<text y="50" id="line'+IntToStr(i+1)+'" >'+ (sl[i]) +'</text>');
      z:=z + 'line'+IntToStr(i+1)+',';

      if i < sl.Count-1 then begin
        FBufXml.Add('<text y="50" id="line'+IntToStr(i+1)+'Z" >'+ (sl[i]+' '+sl[i+1]) +'</text>');
        z:=z + 'line'+IntToStr(i+1)+'Z,'
      end;
    end;
    FBufXml.Add('<rect id="dummy" width="100" height="100"/>');
    z:=z + 'dummy';
    FBufXml.Add('</g></svg>');

    sr.text := GetSVGSize(ATempFolder + '###.svg', z);


    SzTxt.X := 0;
    SzTxt.Y := StrToIntDef(nod.Attribute['font-size'],0);
    SzLine.X := 0;
    SzLine.Y := 0;

    nod.Nodes.Clear;
    nod.text :='';
    nod.Add('tspan');
    for i := 0 to sl.Count-1 do
    begin

      r1:= SizeParse(sr[i*2]);
      if i = sl.Count-1 then
        r2:=r1
      else
        r2:= SizeParse(sr[i*2+1]);

      if i < sl.Count-1 then
        r3:= SizeParse(sr[i*2+2])
      else
        r3.Right := 0;

      if WideLowerCase(sl[i]) = '[p]' then
      begin
         SzTxt.X := Max(SzTxt.X, SzLine.X);
         SzLine.X := 0;
         with nod.Add('tspan') do
         begin
           Attribute['x'] :=IntToStr(StrToIntDef(Nod.Attribute['x'] ,0));
           Attribute['y'] :=  IntToStr(SzTxt.Y + StrToIntDef(Nod.Attribute['y'] ,0));
         end;
         SzTxt.Y := SzTxt.Y + StrToIntDef(nod.Attribute['font-size'],0);
         Continue;
      end;

      nod.Nodes.Last.text := nod.Nodes.Last.text + sl[i];


      if (i = sl.Count-1)
        or ((SzMax.X = 0) xor (SzMax.Y = 0))
        or ((SzMax.X >= SzLine.X + r2.Right))
        or (WideLowerCase(sl[i]) = '[p]')
        then
      begin
        nod.Nodes.Last.text := nod.Nodes.Last.text + ' ';
        SzLine.X := SzLine.X  + r2.Right - r3.Right;
        SzTxt.X := Max(SzTxt.X, SzLine.X);
      end
      else
      begin
{
         if SzLine.X = 0 then
         begin
           SzLine.X := r2.Right - r3.Right;
           SzTxt.X := Max(SzTxt.X, r2.Right);
         end;
}

         if DoWidth and (SzMax.X <= SzLine.X + r2.Right) and (trim(nod.Nodes.Last.text)<>'') then
         begin
           s := trim(nod.Nodes.Last.text);

           SzLine.X := SzLine.X  + r2.Right - r3.Right;

           if nod.Attribute['lengthAdjust'] = 'spacing' then
           begin
             sp:=0;
             for j:=1 to Length(s) do
               if s[j]=' ' then inc(sp);
             if sp >0 then
             begin
//                SzLine.X-W_txt
                str((SzMax.X - SzLine.X) / sp:0:2,z);//&#0160;
//                str((SzMax.X - W_txt) / sp:0:2,z);//&#0160;
                while True do
                begin
                  nod.Nodes.Last.text := copy(s,1,Pos(' ',s+ ' ')-1);
                  s:= Copy(s, Pos(' ',s + ' ')+1, Length(s));

                  if s='' then Break;
                  nod.Add('tspan');
                  nod.Nodes.Last.Attribute['dx'] := z;
                end;

//                s := '<tspan>' +  StringReplace(s,' ','</tspan><tspan dx="'+z+'">',[rfReplaceAll]) + '</tspan>';
//                nod.Nodes.Last.text := '';

//                nod.Nodes.Last.add('tspan').xml := s ;

             end;
           end
           else
           begin

             Val(nod.Nodes.Last.Attribute['letter-spacing'],fsp,err);
             ss:=(s);
             if length(ss)>1 then
               str(fsp + (SzMax.X - SzLine.X) / ((length(ss)-1)):0:2,z)
              else
                z := '0';
//             nod.Nodes.Last.Attribute['letter-spacing']:=  IntToStr(nod.Nodes.Last.Attribute['letter-spacing']  + z);
             nod.Nodes.Last.Attribute['letter-spacing'] := z
           end;
        end
        else begin
        SzLine.X := SzLine.X  + r2.Right - r3.Right;
        SzTxt.X := Max(SzTxt.X, SzLine.X);
        end;


         SzLine.X := 0;
         with nod.Add('tspan') do
         begin
           Attribute['x'] :=IntToStr(StrToIntDef(Nod.Attribute['x'] ,0));
           Attribute['y'] :=  IntToStr(SzTxt.Y + StrToIntDef(Nod.Attribute['y'] ,0));
         end;
         SzTxt.Y := SzTxt.Y + StrToIntDef(nod.Attribute['font-size'],0);
      end;
    end;

    if DoZoom and (StrToIntDef(nod.Attribute['font-size'],0) >10) and
       (((SzMax.Y > 0) and (SzMax.Y < SzTxt.Y)) or
        ((SzMax.X > 0) and (SzMax.X < SzTxt.X)))
    then
    begin
      if (SzMax.Y > 0) and (SzMax.Y < SzTxt.Y) then
        i := round(StrToIntDef(nod.Attribute['font-size'],0) - StrToIntDef(nod.Attribute['font-size'],0) / SzTxt.Y * SzMax.Y + 1) div 2
      else
        i := 1;

      if i<1 then i := 1;

      if (SzMax.X>0) and (SzMax.X < SzTxt.X) then
        j := round(StrToIntDef(nod.Attribute['font-size'],0) - StrToIntDef(nod.Attribute['font-size'],0) / SzTxt.X * SzMax.X + 1) div 2
      else
        j := 1;

      if j<1 then j := 1;

      nod.Attribute['font-size'] := IntToStr(StrToIntDef(nod.Attribute['font-size'],0)-max(i,j));
      nod.Attribute['y'] := IntToStr(StrToIntDef(nod.Attribute['y'],0)-round(max(i,j)/1.4));
    end
    else
       DoZoom := False;

   until not DoZoom;


   if nod.Attribute['decard-format']<>'' then
   begin
//  valign="top | middle | bottom | baseline"
     if pos('valign:top', nod.Attribute['decard-format'])> 0 then
     begin
       // ничего не делать
     end
     else
     if pos('valign:middle', nod.Attribute['decard-format'])> 0 then
     begin
      s:=nod.Attribute['id'];
      nod.Attribute['id']:='';
      nod.ResetXml('<g id="'+s+'" transform="translate(0,'+IntToStr((SzMax.Y - SzTxt.Y) div 2)+')">'+ nod.XML +'</g>');
     end
     else
     if pos('valign:bottom', nod.Attribute['decard-format'])> 0 then
     begin
      s:=nod.Attribute['id'];
      nod.Attribute['id']:='';
      nod.ResetXml('<g id="'+s+'" transform="translate(0,'+IntToStr(SzMax.Y - SzTxt.Y) +')">'+ nod.XML +'</g>');
     end
   end
   else
    if (SzMax.Y > 0) then
    begin
      s:=nod.Attribute['id'];
      nod.Attribute['id']:='';
      nod.ResetXml('<g id="'+s+'" transform="translate(0,'+IntToStr((SzMax.Y - SzTxt.Y) div 2)+')">'+ nod.XML +'</g>');
    end;

  finally
    sr.free;
    sl.free;
  end
  end
  else
  if Pos(WideString('[P]'),WideUpperCase(Nod.text))>0 then
  begin
     s:= StringReplace(Nod.text,'[p][p]','[p]&#x2007;[p]',[rfReplaceAll,rfIgnoreCase]);
     s := '<tspan>' + StringReplace(s ,'[p]','</tspan><tspan x="'+IntToStr(StrToIntDef(Nod.Attribute['x'] ,0))
     +'" dy="'+ IntToStr(StrToIntDef(Nod.Attribute['font-size'] ,0))+'">',[rfReplaceAll,rfIgnoreCase])+'</tspan>';
     Nod.text := '';
     nod.Nodes.Clear;
     nod.Add('tspan').xml := s;
  end;
end;

procedure FormatText1(nod:TXML_Nod);
var n1:TXML_Nod;
  s, anc, rst, AStyle :string;
  fnt1,fnt2:string;
  i, wdt,hgh, z, sp,calcH,calcW, ifnt1:Integer;
  Cnv:TCanvas;
  zm:Boolean;
begin
  Cnv:=TCanvas.Create;

  anc := ParentStyle(nod,'text-anchor');
  wdt := 0;

  fnt1 := ParentStyle(nod,'font-size');
  ifnt1 := StrToIntDef(StringReplace(fnt1,'px','',[rfReplaceAll]),8);
  fnt2 := AnsiDequotedStr(ParentStyle(nod,'font-family'),#39);
  hgh := 0;

  if Assigned(nod.Nodes.ByName('rect')) then
  begin
    n1 := nod.Node['rect'];
    Val(n1.Attribute['width'],wdt,z);
    Val(n1.Attribute['height'],hgh,z);
//    if Pos('[C]',WideUpperCase(nod.text))=0 then     hgh := 0;
    nod.Node['rect'].free;
  end
  else
  begin
    n1 := nod;

    while assigned(n1) and (wdt = 0) do
    begin
      if wdt = 0 then
      begin
        Val(n1.Attribute['width'],wdt,z);
        Val(n1.Attribute['height'],hgh,z);
      end;
      if n1.index > 0 then
        n1 := n1.parent.Nodes[n1.index-1]
      else
        n1 := n1.parent;
     end;

  end;

//  Cnv.Font.size := -Round(ifnt1 * Screen.PixelsPerInch / 72);
  if fnt2 <> '' then
    Cnv.Font.Name := fnt2;

  Cnv.Font.Height := -ifnt1 ;
  if Pos('[Z]',Nod.text)>0 then
    zm:= true
  else
    zm:= False;

  while True do
  begin
    AStyle := 'font-family="'+fnt2+'"'#$D#$A
            + 'font-size="'+IntToStr(-Cnv.Font.Height)+'"'#$D#$A
            + 'letter-spacing="'+ParentStyle(nod,'letter-spacing','0')+'"'#$D#$A
            + 'style=" font-style:'+ParentStyle(nod,'font-style','normal')
            + ';  font-weight:'+ParentStyle(nod,'font-weight','normal')
            + ';  text-decoration:'+ParentStyle(nod,'text-decoration','none')+'; "'#$D#$A;
    s := StringReplace(Nod.text,'[P]',#13#10,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'[C]','',[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'[Z]','',[rfReplaceAll, rfIgnoreCase]);
    if Pos('[U]',Nod.text)>0 then
      s := WideUpperCase(s);
    s := StringReplace(s,'[U]','',[rfReplaceAll, rfIgnoreCase]);
    rst := s;

    z := SvgFontWidth(trim(s), AStyle);
    if pos(#13, s)=0 then
    begin
      calcH := Cnv.TextHeight(s);
      if z <= wdt then Break;
    end;

    calcH := 0;
    calcW := 0;

    rst := '';
    while Length(s) >0 do
    begin
      sp := Length(s);

      z := SvgFontWidth(s, AStyle);
      i:=Length(s);


      if (z > wdt-10) and (Pos(' ',s)>0) then

      for i:=Length(s) downto 1 do
      begin
        if Copy(s,i,1)=' ' then sp := i else Continue;
        z := SvgFontWidth(trim(Copy(s,1,i)), AStyle);
        if (z <= wdt-10)or (i=1) then break;
      end;

      if Pos(#13,Copy(s,1,i)) > 0 then
        i:= Pos(#13,Copy(s,1,i))
      else
      if i < Length(s) then
      begin
        z:=i;
        while (z>0) and (Copy(s,z+1,1)<>' ') do
          Dec(z);
        if z>0 then i := z
        else i := sp;
      end;

      if rst = '' then
        rst := '<tspan font-size="'+IntToStr(-Cnv.Font.Height)+'">' + Copy(s,1,i)+'</tspan>'
      else
        rst := rst + #13#10 + '<tspan x="'+nod.Attribute['x']+'" dy="'
          +IntToStr(Cnv.TextHeight(trim(Copy(s,1,i))))
          +'px" font-size="'+IntToStr(-Cnv.Font.Height)+'">' + Copy(s,1,i) +'</tspan>';
      calcH := calcH + Cnv.TextHeight(trim(Copy(s,1,i))) {div 5 * 6};
      calcW := max(calcW,SvgFontWidth(trim(Copy(s,1,i)), AStyle));

      s:=Trim(Copy(s,i+1,Length(s)));
    end;

    if not zm then Break;

    if ((calcH <= hgh)and(calcW < wdt)) or ((hgh = 0)and not zm)  then
      break
    else
    begin
{      if (calcW <> 0) and (calcH <>0) then
        Cnv.Font.Height := round(Cnv.Font.Height  * min( wdt/calcW, hgh/calcH ))
      else}
        Cnv.Font.Height := Cnv.Font.Height +1;
    end;

  end;

  if (hgh > 0) then
    rst := '<tspan dy="'+IntToStr(-calcH div 2 - round(0.8*Cnv.Font.Height)) +'">'+rst+'</tspan>';
//  Nod.text := stringreplace(stringreplace(rst,#13'<','<',[rfReplaceAll]),#13#10,'',[rfReplaceAll]);
  Nod.text := rst;
  if zm then
  begin
    Nod.Attribute['font-size']:=IntToStr(-Cnv.Font.Height);
    nod.Attribute['y'] := IntToStr(
      StrToIntDef(nod.Attribute['y'],0) - (ifnt1 +Cnv.Font.Height) div 2 );


  end;
  cnv.Free;
end;

procedure SetNewAttr(Attr:string; NOD:TXML_Nod);
var sl:TStringList;
  i:Integer;
  s:string;
begin
  sl:=TStringList.Create;
  try
    s := Attr;
    for i:=1 to row.Count-1 do
      s := StringReplace(s,'['+IntToStr(i)+']', row[i],[rfReplaceAll]);
    sl.CommaText := s;
    for i:=0 to sl.Count-1 do
      if sl.Names[i] <> '' then
        NOD.Attribute[sl.Names[i] ] :=sl.Values[sl.Names[i]];
  finally
    sl.free;
  end;
end;

procedure AlignImages(Anod:TXML_Nod);
var
  i, j: Integer;
begin
{
  j:=0;
  for i:=ANod.Nodes.Count-1 downto 0 do
  begin
     if (ANod.Nodes[i+j].LocalName='use') or (ANod.Nodes[i+j].LocalName='image')or (ANod.Nodes[i+j].LocalName='rect')
     then begin
       ANod.Nodes.Move(i+j,0);
       inc(j);
     end
     else
     if ANod.Nodes[i+j].HasChildren then
       AlignImages(ANod.Nodes[i+j]);
  end;
}
end;


procedure level(nod:TXML_Nod);
var
  i:Integer;
  s:string;
  r,g,b:byte;

begin
{
  for i := 0 to NOD.Attributes.Count-1 do
    if (Pos('dekart:', NOD.Attributes[i].name)=0)
      and (NOD.Attribute['dekart:'+ StringReplace(NOD.Attributes[i].name,':','_',[rfReplaceAll])] <>'')
    then
      NOD.Attributes[i].value := DoReplace(NOD.Attribute['dekart:'+StringReplace(NOD.Attributes[i].name,':','_',[rfReplaceAll])], NOD);
}
  for i := NOD.Attributes.Count-1 downto 0 do
  begin
    if (Pos('dekart:', NOD.Attributes[i].name)=1) then
    begin
      s := StringReplace(Copy(NOD.Attributes[i].name,8,256),'_',':',[rfReplaceAll]);

      if (s='attr') or (s='text') or (s='body') or (s='replace') or (s='background')
      then Continue;


      NOD.Attribute[s] := DoReplace(NOD.Attributes[i].value, NOD);


      if (s = 'visibility') and (NOD.Attribute[s] <> 'hidden') and (NOD.Attribute[s] <> 'visible')  then
      begin

         if (NOD.Attribute[s] = '') or (ParentStyle(NOD.parent, 'visibility')='hidden') then
           NOD.Attribute[s] := 'hidden'
         else
           NOD.Attribute[s] := 'visible';
      end;

      if NOD.Attribute[s]='' then continue;

    end;

    if (NOD.Attributes[i].name='fill') or
       (NOD.Attributes[i].name='stroke') or
       (NOD.Attributes[i].name='stop-color') or
       (NOD.Attributes[i].name='flood-color')
    then
    begin
      s := NOD.Attributes[i].value;

      if copy(s,1,4)='rgb(' then
      begin
        s:=copy(s,pos('(',s)+1,length(s));
        r := StrToIntDef(copy(s,1,pos(',',s)-1),0);
        s:=copy(s,pos(',',s)+1,length(s));
        g := StrToIntDef(copy(s,1,pos(',',s)-1),0);
        s:=copy(s,pos(',',s)+1,length(s));
        b := StrToIntDef(copy(s,1,pos(')',s)-1),0);
        NOD.Attributes[i].value := '#'+IntToHex(r,2)+IntToHex(g ,2)+ IntToHex(b ,2);
      end;

      if copy(s,1,5)='rgba(' then
      begin
        s:=copy(s,pos('(',s)+1,length(s));
        r := StrToIntDef(copy(s,1,pos(',',s)-1),0);
        s:=copy(s,pos(',',s)+1,length(s));
        g := StrToIntDef(copy(s,1,pos(',',s)-1),0);
        s:=copy(s,pos(',',s)+1,length(s));
        b := StrToIntDef(copy(s,1,pos(',',s)-1),0);

        NOD.Attributes[i].value := '#'+IntToHex(r,2)+IntToHex(g ,2)+ IntToHex(b ,2);

        s:=copy(s,pos(',',s)+1,length(s));
        s:=copy(s,1, pos(')',s)-1);
        NOD.Attribute[NOD.Attributes[i].name+'-opacity'] := s;

      end;

    end;

  end;

  if NOD.Attribute['visibility'] = 'hidden' then
     NOD.Attribute['display'] := 'none';

  if NOD.Attribute['dekart:attr'] <> '' then
  begin
    SetNewAttr(NOD.Attribute['dekart:attr'], NOD)
  end;

  if NOD.Attribute['dekart:text'] <> '' then
  begin
    NOD.Text := DoReplace(NOD.Attribute['dekart:text'], NOD);
  end;
{
  if  NOD.Attribute['dekart:xlink'] <> '' then
    NOD.Attribute['xlink:href'] := DoReplace(NOD.Attribute['dekart:xlink'], NOD);

  if NOD.Attribute['dekart:absref']<> '' then
    NOD.Attribute['sodipodi:absref'] := DoReplace(NOD.Attribute['dekart:absref'], NOD);
}
  if (NOD.LocalName = 'foreignObject') and (NOD.Attribute['dekart:body']<> '')  then
  begin
    NOD.Nodes.Clear;
    with  NOD.Add('body') do
    begin
//      Attribute['xmlns']:='http://www.w3.org/1999/xhtml';
      text := DoReplace(NOD.Attribute['dekart:body'], NOD);
    end;
{
    NOD.Node['body'].Nodes.Clear;
    NOD.Node['body'].text := DoReplace(NOD.Attribute['dekart:body'], NOD);
}
    begin
      if NOD.Attributes.ByName('requiredExtensions')<> nil then
        NOD.Attributes.ByName('requiredExtensions').Destroy;
//      CellEditor.seBody.Text := NOD.Nodes.xml;
      s:= html2svg(NOD.xml, ParentStyle(NOD, 'font-size'),NOD.Attribute['dekart:filter'],
             ' font-family:' + QuotedStr(ParentStyle(NOD, 'font-family'))
      +'; font-size:'+ParentStyle(NOD, 'font-size')
//      +'; fill:'+ParentStyle(NOD, 'fill')
      +'; letter-spacing:'+ParentStyle(NOD, 'letter-spacing')
      +'; fill:'+ParentStyle(NOD, 'stroke') +' ', nod, Clipart, AClipartName, ARootName)+'; ';
      nod.Nodes.Clear;
      nod.text := s;
      nod.LocalName:='g';
      s := nod.xml;
      nod.Nodes.Clear;
      nod.text := '';
      nod.xml := s;
      AlignImages(nod);
    end
  end
  else
  if  (NOD.Attribute['dekart:body']<> '')  then
  begin
    NOD.Nodes.Clear;
    NOD.xml := DoReplace(NOD.Attribute['dekart:body'], NOD);
  end
  else
  if (nod.LocalName='text')
  then begin
    for i:=0 to nod.Nodes.Count-1 do
      level(nod.Nodes[i]);

    if nod.text <> '' then
      FormatText(nod);
  end
  else
  if (nod.LocalName='text') and (Pos(WideString('[P]'),WideUpperCase(nod.text))>0)
  then
    FormatText(nod)
  else
  for i:=0 to nod.Nodes.Count-1 do
    level(nod.Nodes[i]);

  for i:=nod.Attributes.Count-1 downto 0 do
  begin
    if (pos('dekart:',nod.Attributes[i].name)=1)
     or(pos('template:',nod.Attributes[i].name)=1)
    then
      nod.Attributes[i].Free
{
    else // Ќе работает с русскими
    if (nod.Attributes[i].name = 'xlink:href')
      and (nod.LocalName='image')
      and (Pos('data:image', nod.Attribute['xlink:href'])<>1)
      and not FileExists(nod.Attributes[i].value)
      then
      nod.Attributes[i].Free;
}
  end;

end;
var i:integer;

begin
  xxx:=TXml_doc.create;

  NodeStack:=Tlist.Create;
  ReplStack:=Tlist.Create;

  try
    xxx.xml := AXML.xml;
{
    if prefix = '' then
      AddBack(xxx,sgText.Row);
}
    level(xxx.Nodes.Last);


    if prefix = '' then
      AddClipart(xxx, Clipart, AClipartName);

    s:= xxx.xml;
    s := StringReplace(s,'xlink:href="#"','',[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'xlink:href="#"','',[rfReplaceAll, rfIgnoreCase]);

    s := StringReplace(s,'id="','id="'+prefix,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'url(#','url(#'+prefix,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s,'href="#','href="#'+prefix,[rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(s, AClipartName+'#', '#clipart', [rfReplaceAll, rfIgnoreCase]);
    Result := s;
  finally
    NodeStack.Free;
    for i := 0 to ReplStack.count-1 do
      if ReplStack.Items[i]<> nil then
        TStringList(ReplStack.Items[i]).Free;

    ReplStack.Free;
    xxx.free;
  end;
end;

function GetSVGSize(const FileName, ID: string): string;
var CairoThread:TSkiaThread;
  sl:TStringList;
begin
  if ID='' then Exit;
  sl:=TStringList.Create;
  sl.CommaText := ID;
  CairoThread :=  TSkiaThread.Create(Nil, FileName, FBufXml.Text,'','', 1, 300, sl, 100);
  try
    repeat
      Application.ProcessMessages;
      if MainForm.StopFlag then CairoThread.Terminate;
    until WaitForSingleObject(CairoThread.Handle, 10) <> WAIT_TIMEOUT
  finally
    CairoThread.Destroy;
    Result := sl.Text;
    sl.Free;
  end;
end;

function html2svg(ASvg,DPI,AFilter, TopStyle:string; NOD:TXML_Nod; Clipart:TXML_Doc; AClipartName, ARootName:string):string;

var
  sl:TStringList;
  XML, rst, MainSVG, xn:TXML_Nod;
  i,j, nodx,nody, npp, err:integer;
  WordSpacing, SZ:double;
  s, s1,zz:string;
  Z:Char;
  RootSize:TPoint;
{
  XML,xn,n1,n2, RST, Bkg, MainSVG:TXML_Nod;
  s,s1:String;
  i,j,err,npp,Row1:Integer;
  Z:Char;
  sz:Double;
  w4, zz:string;
  w1, w2, w3, w5, w_dy, hgh, RowFont:Integer;
  ZoomValue,r, WordSpacing:double;

  LineUp, LineDn: integer;
}

  function SizeParse(id:string):TRect;
  var s:string;
    err:Integer;
  begin
    s:='';
    for err:=0 to sl.Count-1 do
      if Pos(id+',', sl[err])=1 then
      begin
        s:=sl[err];
        break;
      end;
    Delete(s,1,Pos(',',s));
    Val(Copy(s,1,Pos(',',s)-1), Result.Left,err);
    Delete(s,1,Pos(',',s));
    Val(Copy(s,1,Pos(',',s)-1), Result.Top,err);
    Delete(s,1,Pos(',',s));
    Val(Copy(s,1,Pos(',',s)-1), Result.Right,err);
    Delete(s,1,Pos(',',s));
    Val(s, Result.Bottom,err);
  end;


  procedure SvgUseWidth(Atext:string; SVG:TXML_Nod; Clipart:TXML_Doc; var H,V:integer);
  var s:string;
      i:Integer;
  begin
    H:=0;
    V:=0;
    if Atext = '' then  Exit;
    s := SVG.xml;

    if Clipart.Nodes.count > 0 then
      s := SVG.xml + StringReplace(StringReplace(Clipart.Nodes.Last.xml
         , ' id="',  ' id="clipart',[rfReplaceAll])
         , AClipartName+'#', '#clipart', [rfReplaceAll])
    else
      s := SVG.xml;

    s := StringReplace(s, AClipartName+'#', '#clipart', [rfReplaceAll, rfIgnoreCase]);
    s := StringReplace(StringReplace(s, '</svg>','</defs>', [rfReplaceAll]), '<svg','<defs', [rfReplaceAll]);


    FBufXml.Clear;
    FBufXml.Add('<?xml version="1.0" encoding="UTF-8"?>');
    FBufXml.Add('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">');
    FBufXml.Add('<svg xmlns:template="127.0.0.1" xmlns:dekart="http://127.0.0.1"  xmlns:xlink="http://www.w3.org/1999/xlink" fill="black" font-weight="normal" stroke-width="1"  xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto" width="1" height="1">');
    FBufXml.Add('<use y="0" id="txt" xlink:href="' + StringReplace(Atext, AClipartName +'#', '#clipart', [rfReplaceAll, rfIgnoreCase])+'"/>');
    FBufXml.Add(S);
    FBufXml.Add('<rect id="dummy" width="100" height="100"/></svg>');

    s := GetSVGSize(ARootName + '###.svg','txt');

    Delete(s,1,Pos(',',s));
    Delete(s,1,Pos(',',s));
    Delete(s,1,Pos(',',s));
    val(Copy(s,1,Pos(',',s)-1),h,i);
    val(Copy(s,Pos(',',s)+1,Length(s)),v,i);
  end;


function ParseHtml(NOD, XML:TXML_Nod; nodx,nody, lvl:integer; zm:double):string;
var
  ZoomValue: double;
  npp, hgh, Row1, w_dy,
  w1, w2, w3, w5, RowFont, dx,

  LineUp, LineDn: integer;
  w4:string;
  n1, n2, Bkg, rst:TXML_Nod;

  function ParentStyle(ANod:TXML_Nod;aAttr:string;Def:string=''):string;
  var Nod:TXML_Nod;
  begin
    Nod := ANod;
    if (lvl=1)or(aAttr<>'right') then

    repeat
       result := Nod.Attribute[aAttr];
       Nod := Nod.parent;
    until (Result<>'') or (Nod = nil) ;

    if Result='' then Result := Def;

  end;

  function ParentRight(ANod:TXML_Nod;Def:string=''):string;
  var Nod:TXML_Nod;
  begin
    Nod := ANod;
    repeat
       result := Nod.Attribute['right'];
       Nod := Nod.parent;
    until (Result<>'') or (Nod = nil) ;

    if Result='' then Result := Def;
  end;



//  Percent Width * zoom
  function PercentWidth(AVal: string; ADef: integer):Integer;
  begin
    if pos('%', AVal) > 0 then
    begin
      Result := Round(RootSize.X / 100 * StrToIntDef(StringReplace(AVal,'%','',[]), ADef));

      if (xn = nil) and (Result>RootSize.X) then
        Result := RootSize.X
      else
      if (xn<>nil) and (Result>StrToFloatDef(ParentRight(xn),RootSize.X)) then
          Result := Round(StrToFloatDef(ParentRight(xn),RootSize.X));

      Result := Round(Result / ZoomValue /zm);
    end
    else
      Result := Round(StrToFloatDef(AVal, ADef))
  end;

// no-zoom  Percent Width
  function PercentWidth0(AVal: string; ADef: integer):Integer;
  begin
    if pos('%', AVal) > 0 then
    begin
      Result := Round(RootSize.X / 100 * StrToIntDef(StringReplace(AVal,'%','',[]), ADef));
      if (xn = nil) and (Result>RootSize.X) then
        Result := RootSize.X
      else
      if (xn<>nil) and (Result>StrToFloatDef(ParentRight(xn),RootSize.X)) then
          Result := Round(StrToFloatDef(ParentRight(xn),RootSize.X));
      Result := Round(Result / zm);
    end
    else
      Result := Round(StrToFloatDef(AVal, ADef))
  end;

  procedure ResetRow(Align:boolean);
  var i, x, dl, err:integer;
      w, sp: Double;
      s: String;
  begin
    if (npp=1) then
    begin
     if (hgh = StrToIntDef(NOD.Attribute['font-size'],0)) then
      Row1 := Round(StrToIntDef(NOD.Attribute['font-size'],0)*0.2);
    end;

    dl:=0;
    if (LineDn=0)and(LineUp=0) then
      LineDn := StrToIntDef(w4,0);

    while (n1.Nodes.Count > 0) and (n1.Nodes.Last.Attribute['class']='space') do
      n1.Nodes.Delete(n1.Nodes.Count-1);

    if (ParentStyle(n1,'line-height','normal')='normal')or(Pos('%',ParentStyle(n1,'line-height','normal'))>0) then
    begin
      if n1.Attribute['height'] = '0' then
        n1.Attribute['height'] := w4;

      if (ParentStyle(NOD, 'decard-baseline','80%')<>'100%')  then
      begin
        if StrToIntDef(n1.Attribute['height'],0) <= LineDn-LineUp  then
          dl := LineDn;
      end
      else
        if StrToIntDef(n1.Attribute['height'],0) < w_dy then
          dl := w_dy - StrToIntDef(n1.Attribute['height'],0);
    end
    else
    begin
      n1.Attribute['height'] := ParentStyle(n1,'line-height','');
      LineUp := round(-StrToIntDef(n1.Attribute['height'],0)) ;
      LineDn := 0;
    end;

    if (ParentStyle(NOD, 'decard-baseline','80%')<>'100%')  then
      hgh := hgh  - LineUp
    else
      hgh := hgh + StrToIntDef(n1.Attribute['height'],0);

    x := StrToIntDef(nod.Attribute['x'],0);

    if n1.Attribute['align']='right' then
      x := x + round(PercentWidth0(ParentStyle(n1,'right', nod.Attribute['width']),0)/ZoomValue) - PercentWidth(n1.Attribute['width'],0)
    else
    if n1.Attribute['align']='center' then
      x := x + (round(PercentWidth0(ParentStyle(n1,'right', nod.Attribute['width']),0)/ZoomValue) - PercentWidth(n1.Attribute['width'],0)) div 2
    else
    if Align and (n1.Attribute['align']='width')  then
    begin
      if nod.Attribute['lengthAdjust'] = 'spacing' then
      begin
        if n1.Nodes.Count > 1 then
        begin
           w := (round(PercentWidth0(ParentStyle(n1,'right', nod.Attribute['width']),0)/ZoomValue) - PercentWidth(n1.Attribute['width'],0)) / (n1.Nodes.Count-1);
           for i := 1 to n1.Nodes.Count-1 do

             n1.Nodes[i].Attribute['x'] := IntToStr(Round(StrToIntDef(n1.Nodes[i].Attribute['x'],0) + i*w));

        end;

      end else
      begin
        Val(n1.Attribute['letter-spacing'],sp,err);
        err:=0;
        for i := 0 to n1.Nodes.Count-1 do
          if n1.Nodes[i].LocalName='text' then
             err:= err + HTMLLength(n1.Nodes[i].text)
          else
             err:= err + 1;

        if err> 1 then
          err:= err - 1;

        sp := sp + (round(PercentWidth0(ParentStyle(n1,'right', nod.Attribute['width']),0)/ZoomValue) - PercentWidth(n1.Attribute['width'],0))/(err);
        Str(sp:0:3,s);
        n1.Attribute['letter-spacing'] := s;
        err := 0;
        for i := 0 to n1.Nodes.Count-1 do
        begin
          if i > 0 then
            n1.Nodes[i].Attribute['x'] := IntToStr(Round(StrToIntDef(n1.Nodes[i].Attribute['x'],0) + sp * (err) ));

          if (n1.Nodes[i].LocalName='g')  then
             n1.Nodes[i].Attribute['transform'] := 'translate('+n1.Nodes[i].Attribute['x']+','+n1.Nodes[i].Attribute['y']+')';

          if (n1.Nodes[i].LocalName='text')  then
            err := err + HTMLLength(n1.Nodes[i].text)
          else
            err:= err + 1;
        end;
      end;
    end;

    n1.Attribute['transform'] := 'translate('+IntToStr(x)+','+IntToStr(hgh+StrToIntDef(nod.Attribute['y'],0))+')';
    hgh := hgh + dl;
  end;


  procedure NewRow(Align:boolean; dx,dy:Integer);
  var indent, Left:Integer;
     s:string;
  begin
    if n1 <> nil then
      ResetRow(Align);
    inc(npp);

    n1 := rst.Add('g');
    n1.Attribute['id'] := 'ROW'+IntToStr(npp);
    n1.Attribute['align'] := ParentStyle(xn,'align','left');
    n1.Attribute['letter-spacing'] := ParentStyle(xn,'letter-spacing','0');
    n1.Attribute['line-height'] := ParentStyle(xn,'line-height','');

    if lvl=1 then
      n1.Attribute['right'] := ParentStyle(xn,'right','')
    else
      n1.Attribute['right'] := ParentStyle(xn,'width','');

    indent :=  PercentWidth(ParentStyle(xn,'text-indent','0'), 0);

    s:= ParentStyle(xn,'left','0');
    if Pos('%',s)>0 then
      Left :=  PercentWidth(s,0)
    else
      Left := Round(StrToFloatDef(s,0) / ZoomValue / ZM);

    if Align and (indent>=0) then
      n1.Attribute['width'] := IntToStr(dx + Left)
    else
    if NOT Align and (indent<=0) then
      n1.Attribute['width'] := IntToStr(dx + Left)
    else
      n1.Attribute['width'] := IntToStr(Abs(indent) + dx + Left);


    n1.Attribute['height'] := '0';
    w3 := 0;
    w5 := 0;
    w_dy := 0;
    RowFont := 0;

    LineUp:=0;
    LineDn:=0;

    hgh := hgh + dy;
  end;

var
  DoZoom:boolean;
  AddZoom, r :Double;
  ImgRect: TRect;
  i,si:integer;
  fmt:string;

begin
  bkg := nil;
  RST:=TXML_Nod.Create(nil);
  try
    ZoomValue := 1;
    fmt := nod.Attribute['decard-format'];
    if (lvl>1) and (fmt='') then
      fmt := 'valign:middle;zoom';

    addzoom := 1;
    repeat
      DoZoom:=True;

      n1 := nil;
      xn := XML;
      rst.Nodes.Clear;

    RST.Attribute['font-size'] := ParentStyle(NOD, 'font-size');
    RST.Attribute['font-family'] := ParentStyle(NOD, 'font-family');
    RST.Attribute['font-weight'] := ParentStyle(NOD, 'font-weight');
    RST.Attribute['text-decoration'] := ParentStyle(NOD, 'text-decoration');
    RST.Attribute['fill'] := ParentStyle(NOD, 'fill');
    RST.Attribute['stroke'] := ParentStyle(NOD, 'stroke');
    RST.Attribute['lengthAdjust'] := ParentStyle(NOD, 'lengthAdjust');
    RST.Attribute['letter-spacing'] := ParentStyle(NOD, 'letter-spacing','0');
    RST.Attribute['font-variant'] := ParentStyle(NOD, 'font-variant','normal');
    RST.Attribute['id'] := NOD.Attribute['id'];
    RST.Attribute['x'] := '0';
    RST.Attribute['y'] := '0';
    RST.Attribute['width'] :=  NOD.Attribute['width'];
    RST.Attribute['height'] := NOD.Attribute['height'];
    RST.Attribute['transform'] := NOD.Attribute['transform'];

      w4 := ParentStyle(nod,'font-size');
      w3 := 0;
      hgh := 0;
      LineUp:=0;
      LineDn:=0;
      if lvl>1 then
        NewRow(false, 0, 0);



      repeat

        if xn.LocalName='br' then
        begin
          NewRow(true, PercentWidth(xn.Attribute['dx'],0), StrToIntDef(xn.Attribute['dy'],0));
        end;

        if xn.LocalName='p' then
          NewRow(false,PercentWidth(xn.Attribute['dx'],0),StrToIntDef(xn.Attribute['dy'],0));

        if (xn.LocalName='div') then
          NewRow(false, PercentWidth(xn.Attribute['dx'],0),StrToIntDef(xn.Attribute['dy'],0));

        if (xn.LocalName='space')and (n1<>nil) then
        begin
          n1.Add('use').Attribute['class']:='space';
          w5 := w3;
        end;

        if xn.LocalName='bkg' then
        begin
          bkg := TXML_Nod.Create(nil);

          for i := 0 to xn.Attributes.Count-1 do
            if (xn.Attributes.Items[i].name<>'src') and (xn.Attributes.Items[i].name<>'img') then
               bkg.Attribute[xn.Attributes.Items[i].name] := xn.Attributes.Items[i].value;

          bkg.Attribute['width'] := IntToStr(StrToIntDef(Nod.Attribute['width'],0)+2*StrToIntDef(xn.Attribute['outline'],0));
          bkg.Attribute['height'] := IntToStr(StrToIntDef(Nod.Attribute['height'],0)+2*StrToIntDef(xn.Attribute['outline'],0));
          bkg.Attribute['x'] := IntToStr(StrToIntDef(Nod.Attribute['x'],0)-StrToIntDef(xn.Attribute['outline'],0));
          bkg.Attribute['y'] := IntToStr(StrToIntDef(Nod.Attribute['y'],0)-StrToIntDef(xn.Attribute['outline'],0));
          if (xn.Attribute['patch'] <> '') then
          begin
            bkg.ResetXml(xn.xml);
            bkg.LocalName :='g';
            bkg.Attribute['width'] := IntToStr(StrToIntDef(Nod.Attribute['width'],0)+2*StrToIntDef(xn.Attribute['outline'],0));
            bkg.Attribute['height'] := IntToStr(StrToIntDef(Nod.Attribute['height'],0)+2*StrToIntDef(xn.Attribute['outline'],0));
            bkg.Attribute['x'] := IntToStr(StrToIntDef(Nod.Attribute['x'],0)-StrToIntDef(xn.Attribute['outline'],0));
            bkg.Attribute['y'] := IntToStr(StrToIntDef(Nod.Attribute['y'],0)-StrToIntDef(xn.Attribute['outline'],0));

            n2:=mainSvg;
            while n2<>nil do
            begin
              if '#'+n2.Attribute['id']=xn.Attribute['patch'] then
              begin
                if xn.Attribute['outline']<>'' then
                with bkg.Add('g') do
                begin
                  Attribute['transform']:='translate(-'+xn.Attribute['outline']+',-'+xn.Attribute['outline']+')';
                  add.ResetXml(n2.xml);
                end
                else
                  bkg.add.ResetXml(n2.xml);
                break
              end;
              n2 := n2.Next;
            end;
            n2 := bkg;
            while n2<>nil do
            begin
              for i := 0 to n2.Attributes.Count-1 do
              begin
                while pos('%x', n2.Attributes[i].value)>0 do
                begin
                  s := n2.Attributes[i].value;
                  s := copy(s,1,pos('%',s)-1);
                  for si:= Length(s)-1 downto 1 do
                    if not (s[si] in ['0'..'9','-','.']) then
                       break;
                  s := Copy(s,si+1,Length(s));

                  n2.Attributes[i].value := StringReplace(n2.Attributes[i].value, s+'%x',
                    IntToStr(round(StrToFloatDef(bkg.Attribute['width'],0) / 100 * StrToFloatDef(s,0))),  [rfReplaceAll])
                end;
                while pos('%y', n2.Attributes[i].value)>0 do
                begin
                  s := n2.Attributes[i].value;
                  s := copy(s,1,pos('%',s)-1);
                  for si:= Length(s)-1 downto 1 do
                    if not (s[si] in ['0'..'9','-','.']) then
                       break;
                  s := Copy(s,si+1,Length(s));
                  n2.Attributes[i].value := StringReplace(n2.Attributes[i].value, s+'%y',
                    IntToStr(round(StrToFloatDef(bkg.Attribute['height'],0) / 100 * StrToFloatDef(s,0))),  [rfReplaceAll])
                end;

              end;               n2 := n2.Next;
            end;
          end
          else
          if (xn.Attribute['img'] <> '') then
          begin
            bkg.LocalName:='image';
            bkg.Attribute['xlink:href'] := xn.Attribute['img'];
            bkg.index := 0;
          end
          else
          if (xn.Attribute['src'] <> '') then
          begin
             bkg.LocalName:='use';
             bkg.Attribute['xlink:href'] := xn.Attribute['src'];
             bkg.index := 0;
          end
          else
            bkg.LocalName:='rect';
          bkg.index := 0;



        end;

        if xn.LocalName='text' then
        begin
          if n1= nil then NewRow(false, 0,0);


           w1 := SizeParse(xn.Attribute['id']).Right+SizeParse(xn.Attribute['id']).Left;;
           w2 := SizeParse(xn.Attribute['id']+'Z').Right+SizeParse(xn.Attribute['id']+'Z').Left;
           w2 := round(w2 + (w2-2*w1)* WordSpacing);

           if (w1 > (PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)) then
              addzoom := min(addzoom,PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue / w1);

           if (n1.Attribute['width'] <> '0') and
              (PercentWidth(n1.Attribute['width'],0) + w5 + w1 > PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
           then NewRow(True, 0,0);
           w5 := w5 - SizeParse(xn.Attribute['id']).Left;

           n2 := n1.Add('text');
           n2.ResetXml(xn.xml);

           n2.Attribute['font-size'] := ParentStyle(xn, 'font-size');
           n2.Attribute['font-family'] := ParentStyle(xn, 'font-family');
           n2.Attribute['font-weight'] := ParentStyle(xn, 'font-weight');
           if ParentStyle(xn, 'align')<>'width' then
             n2.Attribute['letter-spacing'] := ParentStyle(xn, 'letter-spacing');
           n2.Attribute['text-decoration'] := ParentStyle(xn, 'text-decoration');
           n2.Attribute['font-style'] := ParentStyle(xn, 'font-style');
           n2.Attribute['fill'] := ParentStyle(xn, 'fill');
           n2.Attribute['stroke'] := ParentStyle(xn, 'stroke');
           n2.Attribute['stroke-width'] := ParentStyle(xn, 'stroke-width');
           n2.Attribute['width'] := IntToStr(w1);

           n2.Attribute['x'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5);

           n2.Attribute['height'] := ParentStyle(xn,'font-size');
           n2.Attribute['dy'] := ParentStyle(xn, 'baseline-shift');
           n2.Attribute['filter'] := ParentStyle(xn, 'filter');

           if pos('%', ParentStyle(xn,'line-height',''))>0 then
           begin
             Val(ParentStyle(xn,'line-height',''),r,err);
             if r=0 then
               r:=100;
             n2.Attribute['height'] := IntToStr( Round(StrToIntDef(n2.Attribute['height'],0) / 100 * r)) ;
           end;

           n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + w1);

           if StrToIntDef(n2.Attribute['y'],0)>0 then
             n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),StrToIntDef(n2.Attribute['height'],0)-StrToIntDef(n2.Attribute['y'],0)) )
           else
             n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),StrToIntDef(n2.Attribute['height'],0)) );

           w3 := w2-2*w1;
           w5 := 0;

           LineUp:=Min(LineUp, -round(StrToIntDef(n2.Attribute['height'],12)*0.8) + StrToIntDef(n2.Attribute['y'],0));
           LineDn:=Max(LineDn, round(StrToIntDef(n2.Attribute['height'],12)*0.2 - StrToIntDef(n2.Attribute['y'],0)));
        end;

        if xn.LocalName='rect' then
        begin
          if n1= nil then NewRow(False, 0,0);
            w1 := PercentWidth(xn.Attribute['width'],0);
            dx := PercentWidth(xn.Attribute['dx'],0);


          if (w1+dx > (PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)) then
            addzoom := min(addzoom,PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue / w1);


          if (n1.Attribute['width'] <> '0') and
            (PercentWidth(n1.Attribute['width'],0) + w5 + w1 +dx > PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
          then NewRow(True, 0,0);

          n2 := n1.Add('rect');
          n2.ResetXml(xn.xml);

          n2.Attribute['x'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5  + PercentWidth(xn.Attribute['dx'],0));
          n2.Attribute['y'] := IntToStr(-StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));


          n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + w1 + PercentWidth(xn.Attribute['dx'],0));
          n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),
            StrToIntDef(n2.Attribute['height'],0) - abs(StrToIntDef(xn.Attribute['dy'],0))));

          w_dy := Max(w_dy, StrToIntDef(xn.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));

          w5 := 0;


          LineUp:=Min(LineUp, -StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
          LineDn:=Max(LineDn, StrToIntDef(xn.Attribute['dy'],0));


          if w3 =0 then
          begin
            Val(w4, w3, err);
            w3 := w3 div 3;
          end;
        end;

        if xn.LocalName='img' then
        begin
          if n1= nil then NewRow(False, 0,0);
            w1 := PercentWidth(xn.Attribute['width'],0);
            dx := PercentWidth(xn.Attribute['dx'],0);

          if (w1 + dx > (PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)) then
            addzoom := min(addzoom,PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue / w1);


          if (n1.Attribute['width'] <> '0') and
            (PercentWidth(n1.Attribute['width'],0) + w5 + w1 + dx> PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
          then NewRow(True, 0,0);

          n2 := n1.Add('image');


          n2.Attribute['filter'] := xn.Attribute['filter'];
          n2.Attribute['width'] := xn.Attribute['width'];
          n2.Attribute['height'] := xn.Attribute['height'];
          n2.Attribute['x'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5  + PercentWidth(xn.Attribute['dx'],0));
          n2.Attribute['y'] := IntToStr(-StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));


          n2.Attribute['xlink:href'] := xn.Attribute['src'];
          n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + w1+ PercentWidth(xn.Attribute['dx'],0));
          n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),
          StrToIntDef(n2.Attribute['height'],0) - abs(StrToIntDef(xn.Attribute['dy'],0))));

          w_dy := Max(w_dy, StrToIntDef(xn.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));

          w5 := 0;

          ImgRect.Left := StrToIntDef(xn.Attribute['x1'],0);
          ImgRect.Top := StrToIntDef(xn.Attribute['y1'],0);
          if xn.Attribute['x2']='' then
            ImgRect.Right := PercentWidth(n2.Attribute['width'],0) + ImgRect.Left
          else
            ImgRect.Right := StrToIntDef(xn.Attribute['x2'],0);

          if xn.Attribute['y2']='' then
            ImgRect.Bottom := StrToIntDef(xn.Attribute['height'],0) + ImgRect.Top
          else
            ImgRect.Bottom := StrToIntDef(xn.Attribute['y2'],0);

          n2.Attribute['x'] := IntToStr(StrToIntDef(n2.Attribute['x'],0) + ImgRect.Left);
          n2.Attribute['y'] := IntToStr(StrToIntDef(n2.Attribute['y'],0) + ImgRect.Top);
          n2.Attribute['width'] := IntToStr( ImgRect.Right - ImgRect.Left);
          n2.Attribute['height'] := IntToStr(ImgRect.Bottom - ImgRect.Top);

          LineUp:=Min(LineUp, -StrToIntDef(xn.Attribute['height'],0));
          LineDn:=Max(LineDn, 0);


          if w3 =0 then
          begin
            Val(w4, w3, err);
            w3 := w3 div 3;
          end;

        end;

        if xn.LocalName='use' then
        begin
          if n1= nil then NewRow(False, 0,0);

           w1 := PercentWidth(xn.Attribute['width'],0);
           w2 := StrToIntDef(xn.Attribute['height'],0);
           dx := PercentWidth(xn.Attribute['dx'],0);

           if (xn.Attribute['width']='')or(xn.Attribute['height']='') then
           begin
             SvgUseWidth(xn.Attribute['src'], MainSvg, Clipart, w1, w2);
             w1 := Round(w1 * StrToFloatDef(xn.Attribute['scale'],1));
             w2 := Round(w2 * StrToFloatDef(xn.Attribute['scale'],1));
           end;

           if (w1 > (PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)) then
              addzoom := min(addzoom, PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue / w1);

           if (n1.Attribute['width'] <> '0') and
              (PercentWidth(n1.Attribute['width'],0) + w5 + w1 +dx> PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
           then NewRow(True, 0,0);

           n2 := n1.Add('use');

           if (xn.Attribute['width']='') then
             n2.Attribute['width'] := IntToStr(w1)
           else
             n2.Attribute['width'] := xn.Attribute['width'];

           if xn.Attribute['height']='' then
             n2.Attribute['height'] := IntToStr(w2)
           else
             n2.Attribute['height'] := xn.Attribute['height'];

           n2.Attribute['filter'] := xn.Attribute['filter'];

           w1 := PercentWidth(n2.Attribute['width'],0);

           if (n1.Attribute['width'] <> '0') and
              (PercentWidth(n1.Attribute['width'],0) + w5 + w1 +dx> PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
           then NewRow(True, 0,0);


           n2.Attribute['x'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + PercentWidth(xn.Attribute['dx'],0));
           n2.Attribute['y'] := IntToStr(-StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
           n2.Attribute['filter'] := ParentStyle(xn, 'filter');

           n2.Attribute['xlink:href'] := xn.Attribute['src'];
           n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + w1 + PercentWidth(xn.Attribute['dx'],0));
           n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),
           StrToIntDef(n2.Attribute['height'],0) - abs(StrToIntDef(xn.Attribute['dy'],0))));


           w_dy := Max(w_dy, StrToIntDef(xn.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
           w5 := 0;

          if w3 =0 then
          begin
            Val(w4, w3, err);
            w3 := w3 div 3;
          end;

          LineUp:=Min(LineUp, -StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
          LineDn:=Max(LineDn, StrToIntDef(xn.Attribute['dy'],0));

           if xn.Attribute['scale']<>'' then
           begin
             n2.Attribute['transform'] := 'translate(' +n2.Attribute['x'] +','+n2.Attribute['y']+ ') '
                                         +'scale('+xn.Attribute['scale']+')';
             n2.Attribute['x'] := '';
             n2.Attribute['y'] := '';
             if n2.Attribute['filter']<>'' then
             begin
               n2.Attribute['filter'] := '';
               n2.ResetXml('<g>'+n2.xml+'</g>');
               n2.Attribute['filter'] := ParentStyle(xn, 'filter');
             end;
           end
           else
             n2.Attribute['transform'] := xn.Attribute['transform'];

        end;


        if xn.LocalName='html' then
        begin

          if n1= nil then NewRow(False, 0,0);

           w1 := PercentWidth(xn.Attribute['width'],0);
           w2 := StrToIntDef(xn.Attribute['height'],0);
           dx := PercentWidth(xn.Attribute['dx'],0);

           if (w1+dx > (PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)) then
              addzoom := min(addzoom, PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue / w1);

           if (n1.Attribute['width'] <> '0') and
              (PercentWidth(n1.Attribute['width'],0) + w5 + w1+dx> PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
           then NewRow(True, 0,0);

           n2 := n1.Add('g');

           for i:= 0 to xn.Attributes.Count-1 do
             n2.Attribute[xn.Attributes[i].Name] := xn.Attributes[i].value;

           if (xn.Attribute['width']='') then
             n2.Attribute['width'] := IntToStr(w1)
           else
             n2.Attribute['width'] := xn.Attribute['width'];

           if xn.Attribute['height']='' then
             n2.Attribute['height'] := IntToStr(w2)
           else
             n2.Attribute['height'] := xn.Attribute['height'];

           n2.Attribute['filter'] := xn.Attribute['filter'];

           w1 := PercentWidth(n2.Attribute['width'],0);

           if (n1.Attribute['width'] <> '0') and
              (PercentWidth(n1.Attribute['width'],0) + w5 + w1 + dx> PercentWidth0(ParentStyle(xn, 'right', RST.Attribute['width']),0)/ZoomValue)
           then NewRow(True, 0,0);

           n2.Attribute['x'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + PercentWidth(xn.Attribute['dx'],0));
           n2.Attribute['y'] := IntToStr(-StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
           n2.Attribute['transform']:='translate(' + n2.Attribute['x']+','+n2.Attribute['y']+')';


           n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0) + w5 + w1 + PercentWidth(xn.Attribute['dx'],0));


           n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),
           StrToIntDef(n2.Attribute['height'],0) - abs(StrToIntDef(xn.Attribute['dy'],0))));

           w_dy := Max(w_dy, StrToIntDef(xn.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
           w5 := 0;

          if w3 =0 then
          begin
            Val(w4, w3, err);
            w3 := w3 div 3;
          end;

          LineUp:=Min(LineUp, -StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
          LineDn:=Max(LineDn, StrToIntDef(xn.Attribute['dy'],0));
          n2.add('g').ResetXml(ParseHtml(xn, xn.Next, 0,0,lvl+1, ZoomValue));
          n2.Attribute['right'] := IntToStr(w1);
        end
        else
          xn := xn.Next;

      until (xn = nil) or (xn.Level < XML.Level);

      if n1 <> nil then
        ResetRow(False);

      if (Bkg <> nil)and(lvl=1) then
      begin
        if (hgh > StrToIntDef(NOD.Attribute['height'],0)) then
          Bkg.Attribute['height'] := IntToStr(StrToIntDef(Bkg.Attribute['height'],0) +  hgh - StrToIntDef(NOD.Attribute['height'],0))
        else
        if (hgh > StrToIntDef(Bkg.Attribute['height'],0)) then
          Bkg.Attribute['height'] := IntToStr(StrToIntDef(Bkg.Attribute['height'],0) +  hgh);
      end;


      if pos('zoom', fmt)> 0 then
      begin
        if (AddZoom > 0) and (AddZoom < 1) then
        begin
          ZoomValue := ZoomValue * AddZoom;
          DoZoom := False;
          addzoom := 1;
        end
        else
        if (StrToIntDef(NOD.Attribute['height'],0)>0)
          and (StrToIntDef(NOD.Attribute['height'],0)+1 < hgh * ZoomValue)
        then begin
          err := round(StrToIntDef(NOD.Attribute['height'],0) * ZoomValue);
          ZoomValue := ZoomValue * 0.98;
          DoZoom := err*100 = round(StrToIntDef(NOD.Attribute['height'],0) * ZoomValue*100);
        end;

      end;

    until DoZoom;

{
    if (bkg<>nil) and (ZoomValue<>1)and (ZoomValue<>0) then
        Bkg.Attribute['width'] := IntToStr(Round(StrToIntDef(Bkg.Attribute['width'],0)/ZoomValue ));
}
    if (ParentStyle(NOD, 'decard-baseline','80%')<>'100%')  then
      nody:= nody - Round(Row1*ZoomValue);

    n1 := RST;

    while n1<>nil do
    begin
      if pos('%', n1.Attribute['width'])>0 then
      begin
        if (ZoomValue<>1)and (ZoomValue<>0) then
          n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0))
        else
          n1.Attribute['width'] := IntToStr(PercentWidth(n1.Attribute['width'],0));
      end;
      n1 := n1.Next;
    end;


    if pos('valign:',fmt)>0 then
    begin
//  valign="top | middle | bottom | baseline"

       if pos('valign:top', fmt)> 0 then
       begin
           Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody)+') scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
       end
       else
       if pos('valign:middle', fmt)> 0 then
       begin
         Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody+(StrToIntDef(NOD.Attribute['height'],0)-round(hgh*ZoomValue)) div 2)+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
       end
       else
       if pos('valign:bottom', fmt)> 0 then
       begin
        Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody+(StrToIntDef(NOD.Attribute['height'],0)-round(hgh*ZoomValue)) )+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
       end
    end
    else
    if  round(hgh*ZoomValue) > StrToIntDef(NOD.Attribute['height'],hgh) then
      Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody+(StrToIntDef(NOD.Attribute['height'],0)-round(hgh*ZoomValue)) div 2)+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
    else
      Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody)+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>';

    if Bkg<>nil then
     begin
//       Bkg.Attribute['transform'] := 'translate('+IntToStr(nodx)+','+IntToStr(nody)+') scale('+SvgFloat(ZoomValue)+')';
       Bkg.Attribute['transform'] := 'translate('+IntToStr(nodx)+','+IntToStr(nody)+')';
       Result := '<g>' +  bkg.xml + Result + '</g>';
       Bkg.Free;
     end;


  finally
    RST.Free;
  end;
end;


begin
  npp:=0;
  MainSVG := NOD;
  while MainSVG.LocalName <> 'svg' do MainSVG:=MainSVG.parent;

  WordSpacing := StrToFloat(ParentStyle(NOD, 'word-spacing', '0'));
  nodx:= StrToIntDef(NOD.Attribute['x'],0);
  nody:= StrToIntDef(NOD.Attribute['y'],0);

  nod.Attribute['x'] := '0';
  nod.Attribute['y'] := '0';
  RootSize.X :=StrToIntDef(NOD.Attribute['width'],0);
  RootSize.Y :=StrToIntDef(NOD.Attribute['height'],0);

  XML:=TXML_Nod.Create(nil);
  RST:=TXML_Nod.Create(nil);
  sl:=TStringList.Create;
  try
    RST.LocalName := 'g';

    RST.Attribute['font-size'] := ParentStyle(NOD, 'font-size');
    RST.Attribute['font-family'] := ParentStyle(NOD, 'font-family');
    RST.Attribute['font-weight'] := ParentStyle(NOD, 'font-weight');
    RST.Attribute['text-decoration'] := ParentStyle(NOD, 'text-decoration');
    RST.Attribute['fill'] := ParentStyle(NOD, 'fill');
    RST.Attribute['stroke'] := ParentStyle(NOD, 'stroke');
    RST.Attribute['lengthAdjust'] := ParentStyle(NOD, 'lengthAdjust');
    RST.Attribute['letter-spacing'] := ParentStyle(NOD, 'letter-spacing','0');
    RST.Attribute['font-variant'] := ParentStyle(NOD, 'font-variant','normal');
//    RST.Attribute['stroke-width'] := ParentStyle(NOD, 'stroke-width','0');

    XML.ResetXml(RST.xml);

    RST.Attribute['id'] := NOD.Attribute['id'];
    RST.Attribute['x'] := '0';
    RST.Attribute['y'] := '0';
    RST.Attribute['width'] := NOD.Attribute['width'];
    RST.Attribute['height'] := NOD.Attribute['height'];
    RST.Attribute['transform'] := NOD.Attribute['transform'];

    xn := xml;

    s := trim(NOD.text) + NOD.Nodes.xml;
    for i:=1 to Length(s) do
      if s[i] < ' ' then s[i] := ' ';
    s := StringReplace(s, '  ',' ', [rfReplaceAll]);
    s := StringReplace(s, ' </div>','</div>', [rfReplaceAll]);
    s := StringReplace(s, ' </br>','</br>', [rfReplaceAll]);

    z:=' ';
    j:=1;

    for i:=1 to Length(s) do
    begin
      if (s[i]='<') then
      begin
        z:='>';
        if i > j then
        begin
          if ParentStyle(NOD, 'font-variant')='first' then
            xn.Add('text').text := WideUpperCase(Copy(s,j,1)) + WideLowerCase(Copy(s,j+1,i-j-1))
          else
          if ParentStyle(NOD, 'font-variant')='caps' then
            xn.Add('text').text := StringReplace(WideUpperCase(Copy(s,j,i-j)),'&#X','&#x',[rfReplaceAll])
          else
          if ParentStyle(NOD, 'font-variant')='small' then
            xn.Add('text').text := WideLowerCase(Copy(s,j,i-j))
          else
            xn.Add('text').text := Copy(s,j,i-j);
          xn.Nodes.Last.Attribute['id']:='txt'+IntToStr(npp);
          Inc(npp)
        end;
        j:=i;
      end
      else
      if (z='>')and(s[i]=z) then
      begin
        if s[j+1]='/' then
        begin
          if xn <> xml then
            xn := xn.parent
        end
        else
        if s[i-1]='/' then
        begin
          xn.Add('tag').ResetXml(Copy(s,j,i-j+1));
        end
        else begin
           xn := xn.Add('tag');
           xn.ResetXml(Copy(s,j,i-j)+'/>');

           if xn.Attribute['html-width']<>'' then
             xn.Attribute['right']:=xn.Attribute['html-width'];


           if xn.LocalName='b' then
             xn.ResetXml('<g font-weight="bold"/>');
           if xn.LocalName='i' then
             xn.ResetXml('<g font-style="italic"/>');
           if xn.LocalName='u' then
             xn.ResetXml('<g text-decoration="underline"/>');
           if xn.LocalName='font' then
           begin
             xn.LocalName:='g';


             if xn.Attribute['face'] <> '' then
             begin
               xn.Attribute['font-family'] := xn.Attribute['face'];
               xn.Attributes.ByName('face').Free;
             end;

             if xn.Attribute['size'] <> '' then
             begin
               val(ParentStyle(xn, 'font-size', '14'), sz,err);
               Str(FontSizeConv(xn.Attribute['size'], sz, DPI):0:0,s1);
               xn.Attribute['font-size'] := s1;
             end;
             if xn.Attribute['color'] <> '' then
             begin
               xn.Attribute['fill'] := xn.Attribute['color'];
               xn.Attribute['stroke'] := xn.Attribute['color'];
             end;
           end;
        end;
        j:=i+1;
        z:=' ';
      end
      else
      if (z=' ')and(s[i]=z) then
      begin
        if i > j then
        begin
          if ParentStyle(NOD, 'font-variant')='first' then
            xn.Add('text').text := WideUpperCase(Copy(s,j,1)) + WideLowerCase(Copy(s,j+1,i-j-1))
          else
          if ParentStyle(NOD, 'font-variant')='caps' then
            xn.Add('text').text := StringReplace(WideUpperCase(Copy(s,j,i-j)),'&#X','&#x',[rfReplaceAll])
          else
          if ParentStyle(NOD, 'font-variant')='small' then
            xn.Add('text').text := WideLowerCase(Copy(s,j,i-j))
          else
            xn.Add('text').text := Copy(s,j,i-j);
          xn.Nodes.Last.Attribute['id']:='txt'+IntToStr(npp);
          Inc(npp)
        end;

        xn.Add('space');
        j:=i+1;
      end;
    end;

    FBufXml.Clear;

    FBufXml.Add('<?xml version="1.0" encoding="UTF-8"?>');
    FBufXml.Add('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">');
    FBufXml.Add('<svg xmlns:xlink="http://www.w3.org/1999/xlink" fill="black" font-weight="normal" stroke-width="1"  xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto" width="1" height="1">');
//    n1:=nil;
    xn := XML;
    zz:='';
    repeat
      if xn.LocalName='text' then
      begin
          FBufXml.Add('<text y="50" id="'+xn.attribute['id']+'"'
            +' font-size="'+ ParentStyle(xn,'font-size')+'"'
            +' font-family="'+ ParentStyle(xn,'font-family')+'"'
            +' font-weight="'+ ParentStyle(xn,'font-weight')+'"'
            +' font-style="'+ ParentStyle(xn,'font-style')+'"'
            +' letter-spacing="'+ ParentStyle(xn,'letter-spacing','0')+'"'
            +' text-decoration="'+ ParentStyle(xn,'text-decoration')+'">'+ (xn.text) +'</text>');
          zz := zz  + xn.attribute['id']+',';
          FBufXml.Add('<text y="50" id="'+xn.attribute['id']+'Z"'
            +' font-size="'+ ParentStyle(xn,'font-size')+'"'
            +' font-family="'+ ParentStyle(xn,'font-family')+'"'
            +' font-weight="'+ ParentStyle(xn,'font-weight')+'"'
            +' font-style="'+ ParentStyle(xn,'font-style')+'"'
            +' letter-spacing="'+ ParentStyle(xn,'letter-spacing','0')+'"'
            +' text-decoration="'+ ParentStyle(xn,'text-decoration')+'">'+(xn.text)+ ' ' + (xn.text) +'</text>');
          zz := zz  + xn.attribute['id']+'Z,';
      end;
      xn := xn.Next
    until xn = nil;
    FBufXml.Add('<rect id="dummy" width="100" height="100"/>');
    zz := zz + 'dummy';
    FBufXml.Add('</svg>');


    sl.text := GetSVGSize(ARootName + '###.svg',zz);

    Result := ParseHtml(nod, xml, nodx, nody,1,1);

  finally
    sl.free;
    RST.Free;
    XML.Free;
  end;
end;

initialization
  FBufXml:=TStringList.create;

end.
