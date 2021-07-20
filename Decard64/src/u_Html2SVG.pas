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
u_ThreadRender, VCL.Forms, u_MainForm, Winapi.Windows;

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
    ws:WideString;
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


function ParentStyle(ANod:TXML_Nod;aAttr:string;Def:widestring=''):widestring;
var Nod:TXML_Nod;
begin
  Nod := ANod;
  repeat
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
  s,n:string;
  sl,sn, idx:TStringList;
  Prnt:TXML_Nod;
begin

//  sn:=TStringList.Create;
  idx:=TStringList.Create;
  idx.Sorted := True;
  try
    s := txt;

    for i:=1 to row.Count-1 do
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
        n:=AnsiUpperCase(Copy(sn[i], 1, Pos('=', sn[i])-1));


//        n:=AnsiUpperCase(sn.Names[i]);
        if idx.IndexOf(n)=-1 then
        begin
          idx.Add(n);
          if Pos(n, AnsiUpperCase(s)) >0 then
          begin
//             s := StringReplace(s, n, (sn.Values[n] ,[rfReplaceAll, rfIgnoreCase]);
             s := StringReplace(s, n, copy(sn[i],length(n)+2, Length(sn[i])) ,[rfReplaceAll, rfIgnoreCase]);
          end;
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
  nod.Attribute['font-variant'] := ParentStyle(nod,'normal');

  Nod.text := StringReplace(Nod.text,'[p]',' [p] ',[rfReplaceAll, rfIgnoreCase]);
  Nod.text := StringReplace(Nod.text,'  ',' ',[rfReplaceAll, rfIgnoreCase]);

  if Pos('[U]',UpperCase(Nod.text))>0 then
  begin
    s := UpperCase(Nod.text);
    s := StringReplace(s,'&#X','&#x',[rfReplaceAll, rfIgnoreCase]);
    Nod.text := StringReplace(s,'[U]','',[rfReplaceAll, rfIgnoreCase]);
  end;

  if ParentStyle(nod,'font-variant')='small' then
  begin
    s := LowerCase(Nod.text);
    Nod.text := s;
  end;
  if ParentStyle(nod,'font-variant')='caps' then
  begin
    s := UpperCase(Nod.text);
    s := StringReplace(s,'&#X','&#x',[rfReplaceAll, rfIgnoreCase]);
    Nod.text := s;
  end;

  if Pos('[Z]',UpperCase(Nod.text))>0 then
  begin
    Nod.text := StringReplace(Nod.text,'[Z]','',[rfReplaceAll, rfIgnoreCase]);
    DoZoom := True
  end
  else
    DoZoom := false;

  if (Pos('[W]',UpperCase(Nod.text))>0) or (nod.Attribute['textLength']<>'') then
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

      if LowerCase(sl[i]) = '[p]' then
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
        or (LowerCase(sl[i]) = '[p]')
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
  if Pos('[P]',Uppercase(Nod.text))>0 then
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
//    if Pos('[C]',UpperCase(nod.text))=0 then     hgh := 0;
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
      s := AnsiUpperCase(s);
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

  j:=0;
  for i:=ANod.Nodes.Count-1 downto 0 do
  begin
     if (ANod.Nodes[i+j].LocalName='use') or (ANod.Nodes[i+j].LocalName='image')
     then begin
       ANod.Nodes.Move(i+j,0);
       inc(j);
     end
     else
     if ANod.Nodes[i+j].HasChildren then
       AlignImages(ANod.Nodes[i+j]);
  end;
end;

procedure level(nod:TXML_Nod);
var
  i:Integer;
  s:string;

begin
{
  for i := 0 to NOD.Attributes.Count-1 do
    if (Pos('dekart:', NOD.Attributes[i].name)=0)
      and (NOD.Attribute['dekart:'+ StringReplace(NOD.Attributes[i].name,':','_',[rfReplaceAll])] <>'')
    then
      NOD.Attributes[i].value := DoReplace(NOD.Attribute['dekart:'+StringReplace(NOD.Attributes[i].name,':','_',[rfReplaceAll])], NOD);
}
  for i := 0 to NOD.Attributes.Count-1 do
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
  if (nod.LocalName='text')and Assigned(nod.Nodes.ByName('rect'))
  then begin
    level(nod.Nodes.ByName('rect'));
    if nod.text <> '' then
      FormatText(nod);
  end
  else
  if (nod.LocalName='text') and (Pos('[P]',UpperCase(nod.text))>0)
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
    else // Не работает с русскими
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
//  Result := GetSVGSize1(FileName, ID);

  if ID='' then Exit;
  sl:=TStringList.Create;

  sl.CommaText := ID;
//    Main.StartAnalitics('Sizing');
//  NonThread(Nil, FileName, FBufXml.Text,'','', 1, 300, sl);


  CairoThread :=  TSkiaThread.Create(Nil, FileName, FBufXml.Text,'','', 1, 300, sl, 100);

  try

//    while  WaitForSingleObject(CairoThread.Handle, 100)=WAIT_TIMEOUT	 do
    repeat
{
         if MilliSecondOf(time)< 500 then
           Main.Rendering1.Font.Color := clNavy
         else
           Main.Rendering1.Font.Color := clHighlight;

         Main.Rendering2.Font.Color := Main.Rendering1.Font.Color;
         Main.Rendering3.Font.Color := Main.Rendering1.Font.Color;
         Main.Rendering3.Invalidate;
 }
      Application.ProcessMessages;
      if MainForm.StopFlag then CairoThread.Terminate;
    until WaitForSingleObject(CairoThread.Handle, 10) <> WAIT_TIMEOUT



  finally
    CairoThread.Destroy;
//    Main.StopAnalitics('Sizing');
    Result := sl.Text;
    sl.Free;
//    ShowAnalitics;
  end;


end;

function html2svg(ASvg,DPI,AFilter, TopStyle:string; NOD:TXML_Nod; Clipart:TXML_Doc; AClipartName, ARootName:string):string;
var
  XML,xn,n1,n2, RST, Bkg, MainSVG:TXML_Nod;
  s,s1:String;
  i,j,err,npp:Integer;
  Z:Char;
  sz:Double;
  sl:TStringList;
  w4, zz:string;
  w1, w2, w3, w5, w_dy, hgh:Integer;
  ZoomValue,r, WordSpacing:double;





  function SizeParse(id:string):TRect;
  var
    s:string;
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


  procedure ResetRow(Align:boolean);
  var i, x, dl, err:integer;
     w,sp: Double;
     s: String;

  begin
    dl:=0;
    while (n1.Nodes.Count > 0) and (n1.Nodes.Last.Attribute['class']='space') do
      n1.Nodes.Delete(n1.Nodes.Count-1);

    if (ParentStyle(n1,'line-height','normal')='normal')or(Pos('%',ParentStyle(n1,'line-height','normal'))>0) then
    begin
      if n1.Attribute['height'] = '0' then
        n1.Attribute['height'] := w4;

      if StrToIntDef(n1.Attribute['height'],0) < w_dy then
        dl := w_dy - StrToIntDef(n1.Attribute['height'],0);
    end
    else
    begin
      n1.Attribute['height'] := ParentStyle(n1,'line-height','');
    end;

    hgh := hgh + StrToIntDef(n1.Attribute['height'],0);

    x := StrToIntDef(nod.Attribute['x'],0);

    if n1.Attribute['align']='right' then
      x := x + round(StrToIntDef(nod.Attribute['width'],0)/ZoomValue) - StrToIntDef(n1.Attribute['width'],0)
    else
    if n1.Attribute['align']='center' then
      x := x + (round(StrToIntDef(nod.Attribute['width'],0)/ZoomValue) - StrToIntDef(n1.Attribute['width'],0)) div 2
    else
    if Align and (n1.Attribute['align']='width')  then
    begin
      if nod.Attribute['lengthAdjust'] = 'spacing' then
      begin
        if n1.Nodes.Count > 1 then
        begin
           w := (round(StrToIntDef(nod.Attribute['width'],0)/ZoomValue) - StrToIntDef(n1.Attribute['width'],0)) / (n1.Nodes.Count-1);
           for i := 1 to n1.Nodes.Count-1 do

             n1.Nodes[i].Attribute['x'] := IntToStr(Round(StrToIntDef(n1.Nodes[i].Attribute['x'],0) + i*w));

        end;

      end else
      begin
//        if n1.Attribute['id']='ROW14' then
//          ShowMessage('1');
        Val(n1.Attribute['letter-spacing'],sp,err);
        err:=0;
        for i := 0 to n1.Nodes.Count-1 do
          if n1.Nodes[i].LocalName='text' then
             err:= err + HTMLLength(n1.Nodes[i].text)
          else
             err:= err + 1;

        if err> 1 then
          err:= err - 1;

        sp := sp + (round(StrToIntDef(nod.Attribute['width'],0)/ZoomValue) - StrToIntDef(n1.Attribute['width'],0))/(err);
        Str(sp:0:3,s);
        n1.Attribute['letter-spacing'] := s;
        err := 0;
        for i := 0 to n1.Nodes.Count-1 do
        begin
          if i > 0 then
            n1.Nodes[i].Attribute['x'] := IntToStr(Round(StrToIntDef(n1.Nodes[i].Attribute['x'],0) + sp * (err) ));

          if (n1.Nodes[i].LocalName='text')  then
            err := err + HTMLLength(n1.Nodes[i].text)
          else
            err:= err + 1;
        end;

        if n1.Nodes.Last.LocalName='text' then
        begin
//            n1.Nodes.Last.Attribute['x'] := IntToStr(Round(StrToIntDef( nod.Attribute['width'],0) - sp*( ) ));
//          n1.Nodes.Last.Attribute['text-anchor'] := 'end'
        end;

      end;


    end;

    n1.Attribute['transform'] := 'translate('+IntToStr(x)+','+IntToStr(hgh+StrToIntDef(nod.Attribute['y'],0))+')';
    hgh := hgh + dl;


  end;


  procedure NewRow(Align:boolean; dx,dy:Integer);
  var indent:Integer;
  begin
    if n1 <> nil then
      ResetRow(Align);
    inc(npp);
    n1 := rst.Add('g');
    n1.Attribute['id'] := 'ROW'+IntToStr(npp);
    n1.Attribute['align'] := ParentStyle(xn,'align','left');
    n1.Attribute['letter-spacing'] := ParentStyle(xn,'letter-spacing','0');
    n1.Attribute['line-height'] := ParentStyle(xn,'line-height','');

    indent :=  StrToIntDef(ParentStyle(xn,'text-indent','0'), 0);

    if Align and (indent>=0) then
      n1.Attribute['width'] := IntToStr(dx)
    else
    if NOT Align and (indent<=0) then
      n1.Attribute['width'] := IntToStr(dx)
    else
      n1.Attribute['width'] := IntToStr(Abs(indent) + dx);


    n1.Attribute['height'] := '0';
    w3 := 0;
    w5 := 0;
    w_dy := 0;

    hgh := hgh + dy;
  end;

 procedure SvgUseWidth(Atext:string; SVG:TXML_Nod; Clipart:TXML_Doc; var H,V:integer);
 var
  s:string;
  i:Integer;
 begin
    H:=0;
    V:=0;
  if Atext = '' then
    Exit;
//  Main.StartAnalitics('Sizing');
  s := SVG.xml;


  if Clipart.Nodes.count >0 then
    s := SVG.xml +
         StringReplace(StringReplace(Clipart.Nodes.Last.xml
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
  FBufXml.Add('<use y="0" id="txt" xlink:href="'
     + StringReplace(Atext, AClipartName +'#', '#clipart', [rfReplaceAll, rfIgnoreCase])+'"/>');
  FBufXml.Add(S);

  FBufXml.Add('<rect id="dummy" width="100" height="100"/></svg>');


  s := GetSVGSize(ARootName + '###.svg','txt');

  Delete(s,1,Pos(',',s));
  Delete(s,1,Pos(',',s));
  Delete(s,1,Pos(',',s));

  val(Copy(s,1,Pos(',',s)-1),h,i);
  val(Copy(s,Pos(',',s)+1,Length(s)),v,i);


//  DeleteFile(Main.edCfgRoot.Text + Main.edCfgTemp.Text + '###.svg');
//  DeleteFile(Main.edCfgRoot.Text + Main.edCfgTemp.Text + '###.txt');
//  Main.StopAnalitics('Sizing');
 end;

var
  DoZoom:boolean;
  nodx,nody:integer;
  AddZoom :Double;
  ImgRect: TRect;
begin
bkg := nil;
//  if Pos('БЛАГО', ASVG)> 0 then
//    ShowMessage('1');
  MainSVG := NOD;
  while MainSVG.LocalName <> 'svg' do MainSVG:=MainSVG.parent;

  WordSpacing := StrToFloat(ParentStyle(NOD, 'word-spacing', '0'));
  ZoomValue:=1;
  nodx:= StrToIntDef(NOD.Attribute['x'],0);
  nody:= StrToIntDef(NOD.Attribute['y'],0);


  nod.Attribute['x'] := '0';
  nod.Attribute['y'] := '0';
//  nod_width := StrToIntDef(NOD.Attribute['width'],0);
//  nod_height := StrToIntDef(NOD.Attribute['height'],0);


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

    XML.ResetXml(RST.xml);

    RST.Attribute['id'] := NOD.Attribute['id'];
    RST.Attribute['x'] := '0';
    RST.Attribute['y'] := '0';
//    RST.Attribute['x'] := NOD.Attribute['x'];
//    RST.Attribute['y'] := NOD.Attribute['y'];
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
          if ParentStyle(NOD, 'font-variant')='caps' then
            xn.Add('text').text := StringReplace(UpperCase(Copy(s,j,i-j)),'&#X','&#x',[rfReplaceAll])
          else
          if ParentStyle(NOD, 'font-variant')='small' then
            xn.Add('text').text := LowerCase(Copy(s,j,i-j))
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
          xn.Add('tag').ResetXml(Copy(s,j,i-j+1))
        else begin
           xn := xn.Add('tag');
           xn.ResetXml(Copy(s,j,i-j)+'/>');
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
//               xn.Attributes.ByName('size').Free;

             end;
             if xn.Attribute['color'] <> '' then
             begin
               xn.Attribute['fill'] := xn.Attribute['color'];
               xn.Attribute['stroke'] := xn.Attribute['color'];
//               xn.Attributes.ByName('color').Free;
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

          if ParentStyle(NOD, 'font-variant')='caps' then
            xn.Add('text').text := StringReplace(UpperCase(Copy(s,j,i-j)),'&#X','&#x',[rfReplaceAll])
          else
          if ParentStyle(NOD, 'font-variant')='small' then
            xn.Add('text').text := LowerCase(Copy(s,j,i-j))
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
    n1:=nil;
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


    addzoom := 1;
    repeat
      DoZoom:=True;

      n1 := nil;
      xn := XML;
      rst.Nodes.Clear;

      npp:=0;
      w4 := ParentStyle(nod,'font-size');
      w3 := 0;
      hgh := 0;

      repeat

        if xn.LocalName='br' then
        begin
          NewRow(true, StrToIntDef(xn.Attribute['dx'],0), StrToIntDef(xn.Attribute['dy'],0));
        end;

        if xn.LocalName='p' then
          NewRow(false,StrToIntDef(xn.Attribute['dx'],0),StrToIntDef(xn.Attribute['dy'],0));

        if (xn.LocalName='div') then
          NewRow(false, StrToIntDef(xn.Attribute['dx'],0),StrToIntDef(xn.Attribute['dy'],0));

        if (xn.LocalName='space')and (n1<>nil) then
        begin
          n1.Add('use').Attribute['class']:='space';
          w5 := w3;
        end;

        if xn.LocalName='bkg' then
        begin
          if (xn.Attribute['img'] <> '') then
          begin
            bkg := rst.Add('image');
            bkg.Attribute['xlink:href'] := xn.Attribute['img'];
            bkg.index := 0;
          end
          else
          if (xn.Attribute['src'] <> '') then
          begin
             bkg := rst.Add('use');
             bkg.Attribute['xlink:href'] := xn.Attribute['src'];
             bkg.index := 0;
          end
          else
             bkg := rst.Add('rect');
          bkg.index := 0;

          bkg.Attribute['width'] := Nod.Attribute['width'];
          bkg.Attribute['height'] := Nod.Attribute['height'];
          bkg.Attribute['x'] := Nod.Attribute['x'];
          bkg.Attribute['y'] := Nod.Attribute['y'];

          for i := 0 to xn.Attributes.Count-1 do
          if (xn.Attributes.Items[i].name<>'src') and (xn.Attributes.Items[i].name<>'img') then
             bkg.Attribute[xn.Attributes.Items[i].name] := xn.Attributes.Items[i].value;


        end;

        if xn.LocalName='text' then
        begin
          if n1= nil then NewRow(false, 0,0);

//           w5 := w5 - SizeParse(xn.Attribute['id']).Left;

//           w1 := SizeParse(xn.Attribute['id']).Right;
//           w2 := SizeParse(xn.Attribute['id']+'Z').Right;

           w1 := SizeParse(xn.Attribute['id']).Right+SizeParse(xn.Attribute['id']).Left;;
           w2 := SizeParse(xn.Attribute['id']+'Z').Right+SizeParse(xn.Attribute['id']+'Z').Left;
           w2 := round(w2 + (w2-2*w1)* WordSpacing);

           if {(n1.Attribute['width'] = '0') and} (w1 > (StrToIntDef(RST.Attribute['width'],0)/ZoomValue)) then
              addzoom := min(addzoom,StrToIntDef(RST.Attribute['width'],0)/ZoomValue / w1);

           if (n1.Attribute['width'] <> '0') and
              (StrToIntDef(n1.Attribute['width'],0) + w5 + w1 > StrToIntDef(RST.Attribute['width'],0)/ZoomValue)
           then NewRow(True, 0,0);
           w5 := w5 - SizeParse(xn.Attribute['id']).Left;


           n2 := n1.Add('text');
           n2.ResetXml(xn.xml);

           n2.Attribute['font-size'] := ParentStyle(xn, 'font-size');
           n2.Attribute['font-family'] := ParentStyle(xn, 'font-family');
           n2.Attribute['font-weight'] := ParentStyle(xn, 'font-weight');
//         n2.Attribute['letter-spacing'] := ParentStyle(xn, 'letter-spacing');
           n2.Attribute['text-decoration'] := ParentStyle(xn, 'text-decoration');
           n2.Attribute['font-style'] := ParentStyle(xn, 'font-style');
           n2.Attribute['fill'] := ParentStyle(xn, 'fill');
           n2.Attribute['stroke'] := ParentStyle(xn, 'stroke');

           n2.Attribute['stroke-width'] := ParentStyle(xn, 'stroke-width');


           n2.Attribute['width'] := IntToStr(w1);



           n2.Attribute['x'] := IntToStr(StrToIntDef(n1.Attribute['width'],0) + w5);

           n2.Attribute['height'] := ParentStyle(xn,'font-size');

           if pos('%', ParentStyle(xn,'line-height',''))>0 then
           begin
             Val(ParentStyle(xn,'line-height',''),r,err);
             if r=0 then
               r:=100;
             n2.Attribute['height'] := IntToStr( Round(StrToIntDef(n2.Attribute['height'],0) / 100 * r)) ;
           end;

           n1.Attribute['width'] := IntToStr(StrToIntDef(n1.Attribute['width'],0) + w5 + w1);
           n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),StrToIntDef(n2.Attribute['height'],0)) );

           w3 := w2-2*w1;
           w5 := 0;
        end;

        if xn.LocalName='img' then
        begin
          if n1= nil then NewRow(False, 0,0);
            w1 := StrToIntDef(xn.Attribute['width'],0);

          if {(n1.Attribute['width'] = '0') and} (w1 > (StrToIntDef(RST.Attribute['width'],0)/ZoomValue)) then
            addzoom := min(addzoom,StrToIntDef(RST.Attribute['width'],0)/ZoomValue / w1);


          if (n1.Attribute['width'] <> '0') and
            (StrToIntDef(n1.Attribute['width'],0) + w5 + w1 > StrToIntDef(RST.Attribute['width'],0)/ZoomValue)
          then NewRow(True, 0,0);

          n2 := n1.Add('image');


          n2.Attribute['width'] := xn.Attribute['width'];
          n2.Attribute['height'] := xn.Attribute['height'];
          n2.Attribute['x'] := IntToStr(StrToIntDef(n1.Attribute['width'],0) + w5  + StrToIntDef(xn.Attribute['dx'],0));
          n2.Attribute['y'] := IntToStr(-StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));


          n2.Attribute['xlink:href'] := xn.Attribute['src'];
          n1.Attribute['width'] := IntToStr(StrToIntDef(n1.Attribute['width'],0) + w5 + w1+ StrToIntDef(xn.Attribute['dx'],0));
//         n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),-StrToIntDef(n2.Attribute['y'],0)) )
          n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),
          StrToIntDef(n2.Attribute['height'],0) - abs(StrToIntDef(xn.Attribute['dy'],0))));

          w_dy := Max(w_dy, StrToIntDef(xn.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));

          w5 := 0;
{
         if xn.Attribute['img-width']<> '' then
           n2.Attribute['width'] := xn.Attribute['img-width'];
         if xn.Attribute['img-height']<> '' then
           n2.Attribute['height'] := xn.Attribute['img-height'];
}
          ImgRect.Left := StrToIntDef(xn.Attribute['x1'],0);
          ImgRect.Top := StrToIntDef(xn.Attribute['y1'],0);
          if xn.Attribute['x2']='' then
            ImgRect.Right := StrToIntDef(n2.Attribute['width'],0) + ImgRect.Left
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


          if w3 =0 then
          begin
            Val(w4, w3, err);
            w3 := w3 div 3;
          end;

        end;

        if xn.LocalName='use' then
        begin
          if n1= nil then NewRow(False, 0,0);

           w1 := StrToIntDef(xn.Attribute['width'],0);
           w2 := StrToIntDef(xn.Attribute['height'],0);

           if (xn.Attribute['width']='')or(xn.Attribute['height']='') then
             SvgUseWidth(xn.Attribute['src'], MainSvg, Clipart, w1, w2);

           if {(n1.Attribute['width'] = '0') and} (w1 > (StrToIntDef(RST.Attribute['width'],0)/ZoomValue)) then
              addzoom := min(addzoom, StrToIntDef(RST.Attribute['width'],0)/ZoomValue / w1);


           if (n1.Attribute['width'] <> '0') and
              (StrToIntDef(n1.Attribute['width'],0) + w5 + w1 > StrToIntDef(RST.Attribute['width'],0)/ZoomValue)
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

           w1 := StrToIntDef(n2.Attribute['width'],0);

           if (n1.Attribute['width'] <> '0') and
              (StrToIntDef(n1.Attribute['width'],0) + w5 + w1 > StrToIntDef(RST.Attribute['width'],0)/ZoomValue)
           then NewRow(True, 0,0);


           n2.Attribute['x'] := IntToStr(StrToIntDef(n1.Attribute['width'],0) + w5 + StrToIntDef(xn.Attribute['dx'],0));
           n2.Attribute['y'] := IntToStr(-StrToIntDef(n2.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));

           n2.Attribute['xlink:href'] := xn.Attribute['src'];
           n1.Attribute['width'] := IntToStr(StrToIntDef(n1.Attribute['width'],0) + w5 + w1 + StrToIntDef(xn.Attribute['dx'],0));
//         n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),-StrToIntDef(n2.Attribute['y'],0)))
           n1.Attribute['height'] := IntToStr(Max(StrToIntDef(n1.Attribute['height'],0),
           StrToIntDef(n2.Attribute['height'],0) - abs(StrToIntDef(xn.Attribute['dy'],0))));

           w_dy := Max(w_dy, StrToIntDef(xn.Attribute['height'],0) + StrToIntDef(xn.Attribute['dy'],0));
           w5 := 0;

          if w3 =0 then
          begin
            Val(w4, w3, err);
            w3 := w3 div 3;
          end;

        end;

        xn := xn.Next
      until xn = nil;

      if n1<> nil then
        ResetRow(False);

      if (Bkg <> nil) then
      begin
        if (hgh > StrToIntDef(NOD.Attribute['height'],0)) then
          Bkg.Attribute['height'] := IntToStr(StrToIntDef(Bkg.Attribute['height'],0) +  hgh - StrToIntDef(NOD.Attribute['height'],0))
        else
        if (hgh > StrToIntDef(Bkg.Attribute['height'],0)) then
          Bkg.Attribute['height'] := IntToStr(StrToIntDef(Bkg.Attribute['height'],0) +  hgh);
      end;

      if pos('zoom', nod.Attribute['decard-format'])> 0 then
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
//          ZoomValue := ZoomValue * Sqrt(StrToIntDef(NOD.Attribute['height'],0) / (hgh * ZoomValue) );
          DoZoom := err*100 = round(StrToIntDef(NOD.Attribute['height'],0) * ZoomValue*100);
        end;

      end;

    until DoZoom;


    if (bkg<>nil) and (ZoomValue<>1)and (ZoomValue<>0) then
        Bkg.Attribute['width'] := IntToStr(Round(StrToIntDef(Bkg.Attribute['width'],0)/ZoomValue ));

  if ParentStyle(NOD, 'decard-baseline','80%')<>'100%' then
    nody:= nody - round(StrToIntDef(NOD.Attribute['font-size'],0)*0.2*ZoomValue);


    if pos('valign:',nod.Attribute['decard-format'])>0 then
    begin
//  valign="top | middle | bottom | baseline"

       if pos('valign:top', nod.Attribute['decard-format'])> 0 then
       begin
           Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody)+') scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
       end
       else
       if pos('valign:middle', nod.Attribute['decard-format'])> 0 then
       begin
         Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody+(StrToIntDef(NOD.Attribute['height'],0)-round(hgh*ZoomValue)) div 2)+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
       end
       else
       if pos('valign:bottom', nod.Attribute['decard-format'])> 0 then
       begin
        Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody+(StrToIntDef(NOD.Attribute['height'],0)-round(hgh*ZoomValue)) )+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
       end
    end
    else
    if  round(hgh*ZoomValue) > StrToIntDef(NOD.Attribute['height'],hgh) then
      Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody+(StrToIntDef(NOD.Attribute['height'],0)-round(hgh*ZoomValue)) div 2)+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
    else
      Result := '<g transform="translate('+IntToStr(nodx)+','+IntToStr(nody)+')  scale('+SvgFloat(ZoomValue)+')">' + RST.Nodes.xml + '</g>'
  finally
    sl.free;
//    CellEditor.seBody.Text := nod.xml;
    RST.Free;
    XML.Free;
  end;
end;

initialization
  FBufXml:=TStringList.create;

end.
