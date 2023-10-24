unit u_MainData;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  Vcl.ExtDlgs, Vcl.Dialogs, Profixxml;

type
  TMainData = class(TDataModule)
    ilDecard: TImageList;
    dlgOpenSVG: TOpenDialog;
    dlgOpenText: TOpenTextFileDialog;
    ilTags: TImageList;
    ilEditor: TImageList;
    dlgOpenXML: TOpenDialog;
    ilHelper: TImageList;
    ilNavigate: TImageList;
    dlgFont: TFontDialog;
    dlgColor: TColorDialog;
    dlgOpenPicture: TOpenPictureDialog;
    dlgSavePicture: TSavePictureDialog;
    dlgSaveXML: TSaveDialog;
    dlgSaveContent: TSaveTextFileDialog;
    dlgSaveSVG: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    XSD, HLP: TXML_Doc;
    HyphenNod:TXML_Nod;
   function Hyphenation(s: string; sl:TStringList):boolean;
  end;

var
  MainData: TMainData;

implementation

{$R *.dfm}


procedure TMainData.DataModuleCreate(Sender: TObject);
begin
  XSD:=TXML_Doc.Create;

  XSD.LoadFromFile(ExtractFilePath(paramstr(0))+'SVG.xsd');

  HLP:=TXML_Doc.Create;
  HLP.LoadFromFile(ExtractFilePath(paramstr(0))+'svg-help.xml');

  HyphenNod := HLP.Node['Hyphenation'].Nodes[0];

end;

procedure TMainData.DataModuleDestroy(Sender: TObject);
begin
  HLP.Free;
  XSD.Free;
end;

function TMainData.Hyphenation(s: string; sl:TStringList):boolean;
var
  i,j,n:Integer;
  Src,Rst,Ptr,Idx,Tmp:string;
begin
  result := False;
  sl.clear;

  if Length(Trim(s)) < 5 then Exit;

  Src := AnsiLowerCase(' '+s+' ');
  for i:= 1 to Length(Src) do
    if Src[i]<>'''' then
      if  AnsiUpperCase(Src[i]) = AnsiLowerCase(Src[i]) then
        Src[i] := ' ';

  Rst := StringOfChar('0',Length(Src));
  for i := 0 to HyphenNod.Nodes.Count-1 do
  begin
    Tmp := StringReplace(HyphenNod.Nodes[i].text,'.',' ',[rfReplaceAll]);
    Ptr := '';
    Idx := '0';

    for j := 1 to length(Tmp) do
    begin
      if tmp[j] in ['0'..'9'] then
        Idx[Length(Idx)] := tmp[j]
      else begin
        Ptr := Ptr + tmp[j];
        Idx := Idx + '0';
      end;
    end;
    n:=Pos(Ptr,Src);
    while n>0 do
    begin
      for j := 1 to Length(Idx) do
        if n+j < Length(Rst) then

        if Rst[n+j-1] < Idx[j] then
           Rst[n+j-1] := Idx[j];
      n:=Pos(Ptr,Src,n+1);
    end;
  end;
  Tmp := '';

  for i := 1 to length(s) do
  begin
    Tmp := Tmp + s[i];

    if (i>2)and (i<length(Trim(Src))-2) then
      if Rst[i+2] in ['1','3','5','7','9'] then
      begin
        sl.Insert(0,Tmp);
        result := True;
      end;
  end;

end;



end.




