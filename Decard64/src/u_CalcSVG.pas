unit u_CalcSVG;

interface

uses Profixxml, System.Classes, System.Types, vcl.graphics;

type TTetra = array [0..3] of TPoint;
function NodeRect(Anod:TXML_Nod):TTetra;

var FontCanvas:TCanvas;

implementation

uses UMatrix, Math, System.SysUtils;

function StrToFloat(S:string):extended;
var err:integer;
begin
  val(s,result,err);
end;


function SVGTransformTranslate(Params:TStrings):TMatrix;
var
 tx,ty:Extended;
begin
  tx:= StrToFloat(Params[0]);
  ty:=0.0;
  if Params.Count > 1 then
     ty:=StrToFloat(Params[1]);
  Result := IdentityMatrix;
  Result.A[2, 0] := tx;
  Result.A[2, 1] := ty;
end;

function SVGTransformScale(Params:TStrings):TMatrix;
var
 sx,sy:Extended;
begin
  sx:= StrToFloat(Params[0]);
  if Params.Count > 1 then
     sy:=StrToFloat(Params[1])
  else
     sy:=sx;
  Result := IdentityMatrix;
  Result.A[0, 0] := sx;
  Result.A[1, 1] := sy;
end;

function SVGTransformSkewX(Params:TStrings):TMatrix;
var
 ang:Extended;
begin
  ang:= StrToFloat(Params[0])*PI/180;
  Result := IdentityMatrix;
  Result.A[1, 0]  := Tan(ang);
end;

function SVGTransformSkewY(Params:TStrings):TMatrix;
var
 ang:Extended;
begin
  ang:= StrToFloat(Params[0])*pi/180;
  Result := IdentityMatrix;
  Result.A[0, 1]  :=  Tan(ang);
end;

function SVGTransformRotate(Params:TStrings):TMatrix;
var
 ang,cx,cy:Extended;
 tm,rm,t:TMatrix;
begin
  ang:= -StrToFloat(Params[0])*pi/180;
  cx:=0;
  cy:=0;
  if Params.Count >=3 then
  begin
     cx:=StrToFloat(Params[1]);
     cy:=StrToFloat(Params[2]);
  end;
  tm:=TransMx(cx,cy);
  rm:=RotMx(ang);
  t:=MulMx(tm,rm);
  tm:=TransMx(-cx,-cy);
  Result:=MulMx(t,tm);
end;

function SVGTransformMatrix(Params:TStrings):TMatrix;
var
 a,b,c,d,e,f:Extended;
begin
   a:=StrToFloat(Params[0]);
   b:=StrToFloat(Params[1]);
   c:=StrToFloat(Params[2]);
   d:=StrToFloat(Params[3]);
   e:=StrToFloat(Params[4]);
   f:=StrToFloat(Params[5]);
   FillMx(a,b,c,d,e,f,Result);
end;



function SVGParseTransform(const AStr:string):TMatrix;
var
  mPos,mLen:integer;
  procedure SynCheck(ARaise:boolean=true);
  begin
     if ARaise then
        Abort;
  end;
  function GetArgs():string;
  var
    d,I,N:integer;
  begin
       Result:='';
       if mPos >= mLen then
          Exit;
       while AStr[mPos]=' ' do
         inc(mPos);
       d:=mPos;
       SynCheck(AStr[mPos]<>'(');
       N:=-1;
       for I:=mPos to mLen do
          if AStr[I]=')' then
          begin
             N:=I;
             break;
          end;
       SynCheck(N=-1);
       mPos:=N;
       Result:=Copy(AStr,d+1,mPos-1-d);
  end;
  function GetTrans():string;
  var
    d:integer;
  begin
       Result:='';
       if mPos >= mLen then
          Exit;
       inc(mPos);
       while AStr[mPos]=' ' do
         inc(mPos);
       d:=mPos;
       while AStr[mPos]in['A'..'Z','a'..'z'] do
         inc(mPos);
       Result:=Copy(AStr,d,mPos-d);
  end;
var
  S,Args:string;
  List:TStringList;
  M:TMatrix;
begin
   mPos:=0;
   mLen:=Length(AStr);
   List:=TStringList.Create;
   try
     Result:=IdentityMatrix;
     repeat
        Args:='';
        S:=LowerCase(GetTrans());
        if S<>'' then
        begin
           Args:= GetArgs();
           Args :=StringReplace(Args,',',' ',[rfReplaceAll]);
           Args :=StringReplace(Args,'-',' -',[rfReplaceAll]);
           Args :=StringReplace(Args,'e -','e-',[rfReplaceAll]);
           List.DelimitedText:=Args;
           SynCheck(List.Count=0);
           if S='translate' then
              M:= SVGTransformTranslate(List)
           else if S='rotate' then
              M:= SVGTransformRotate(List)
           else if S='scale' then
              M:= SVGTransformScale(List)
           else if S='skewx' then
              M:= SVGTransformSkewX(List)
           else if S='skewy' then
              M:= SVGTransformSkewY(List)
           else if S='matrix' then
              M:= SVGTransformMatrix(List)
           else
              SynCheck();
           Result:= MulMx(Result,M);
        end;
     until mPos >= mLen;
   finally
     List.Free;
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

function NodeRect(Anod:TXML_Nod):TTetra;
var
  x,y,width,height, zx,zy,
  rx,ry :Extended;
  trn: TMatrix;
  prnt:TXML_Nod;
  err:integer;
begin

  if Anod.LocalName='ellipse' then
  begin
    val(Anod.Attribute['cx'],x,err);
    val(Anod.Attribute['cy'],y,err);
    val(Anod.Attribute['rx'],rx,err);
    val(Anod.Attribute['ry'],ry,err);
    x := x - rx;
    y := y - ry;
    width := 2*rx;
    height := 2*ry;
  end
  else
  if Anod.LocalName='circle' then
  begin
    val(Anod.Attribute['cx'],x,err);
    val(Anod.Attribute['cy'],y,err);
    val(Anod.Attribute['rx'],rx,err);
    x := x - rx;
    y := y - rx;
    width := 2*rx;
    height := 2*rx;
  end
  else
  begin
    val(Anod.Attribute['x'],x,err);
    val(Anod.Attribute['y'],y,err);
    val(Anod.Attribute['width'],width,err);
    val(Anod.Attribute['height'],height,err);
  end;

  if (Anod.LocalName='text') then
  begin
    if (Anod.Nodes.ByName('rect')<>nil) then
    begin
      val(Anod.Node['rect'].Attribute['width'],width,err);
      val(Anod.Node['rect'].Attribute['height'],height,err);
    end
    else
    with FontCanvas do
    begin
      font.Name := ParentStyle(Anod,'font-family','');
      font.Height := StrToIntDef(ParentStyle(Anod,'font-size','8'),8);
      width := TextExtent(Anod.text).Width;
      height := TextExtent(Anod.text).Height;

    end;

    if height = 0 then
      val(Anod.Attribute['font-size'],height,err);

    y := y - round(StrToIntDef(ParentStyle(Anod,'font-size','8'),8)*0.8);


    if width = 0 then
      width := height;



    if Anod.Attribute['text-anchor']='middle' then
      x := x-width/2;
    if Anod.Attribute['text-anchor']='end' then
      x := x-width;

  end;

  trn := IdentityMatrix;
  prnt := ANod;
  while prnt<> nil do
  begin
    try
    if prnt.Attribute['transform']<> '' then
         trn := MulMx(trn,SVGParseTransform(prnt.Attribute['transform']));
    except
    end;
    prnt := prnt.parent;
  end;



  TransFormVal(trn, x + width, y , zx,zy);
  result[1].x:=round(zx);
  result[1].y:=round(zy);

  TransFormVal(trn, x + width, y + height, zx,zy);
  result[2].x:=round(zx);
  result[2].y:=round(zy);

  TransFormVal(trn, x , y + height, zx,zy);
  result[3].x:=round(zx);
  result[3].y:=round(zy);

  TransFormVal(trn, x, y, zx,zy);
  result[0].X:=round(zx);
  result[0].Y:=round(zy);
end;


end.
