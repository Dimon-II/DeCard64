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
  end;

var
  MainData: TMainData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TMainData.DataModuleCreate(Sender: TObject);
begin
  XSD:=TXML_Doc.Create;
  XSD.LoadFromFile('SVG.xsd');

  HLP:=TXML_Doc.Create;
  HLP.LoadFromFile('svg-help.xml');
end;

procedure TMainData.DataModuleDestroy(Sender: TObject);
begin
  HLP.Free;
  XSD.Free;
end;

end.
