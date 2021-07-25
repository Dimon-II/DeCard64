unit u_MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, ProfixXML, u_SvgTreeFrame,
  SynEdit, SynEditHighlighter, SynHighlighterXML, Vcl.Grids, Vcl.Menus,
  u_SvgInspectorFrame, System.Math, Vcl.Imaging.jpeg, System.Actions, Vcl.ActnList,
  Vcl.ColorGrd, System.UITypes, System.Types, StrUtils;

type
  TMainForm = class(TForm)
    pcMain: TPageControl;
    tsProject: TTabSheet;
    tsDesigner: TTabSheet;
    tsClipart: TTabSheet;
    tsPreview: TTabSheet;
    tbrProject: TToolBar;
    tbOpenProject: TToolButton;
    tbSaveProject: TToolButton;
    ToolButton33: TToolButton;
    btnProcess: TToolButton;
    btnStop: TToolButton;
    Rendering1: TPanel;
    gbProjectFolders: TGroupBox;
    lblCfgRoot: TLabel;
    lblCfgTemp: TLabel;
    lblCfgImages: TLabel;
    lblCfgResult: TLabel;
    sbOpenRoot: TSpeedButton;
    sbCfgTemp: TSpeedButton;
    sbCfgImg: TSpeedButton;
    sbCfgResult: TSpeedButton;
    lblCfgTTF: TLabel;
    sbCfgTTF: TSpeedButton;
    lblCfgTemplate: TLabel;
    sbOpenTemplate: TSpeedButton;
    lblCfgText: TLabel;
    sbOpenText: TSpeedButton;
    lblCfgClipart: TLabel;
    sbOpenClipart: TSpeedButton;
    lblCfgBack: TLabel;
    SpeedButton7: TSpeedButton;
    lblEncoding: TLabel;
    edCfgRoot: TEdit;
    edCfgTemp: TEdit;
    edCfgImg: TEdit;
    edCfgResult: TEdit;
    edCfgTTF: TEdit;
    edCfgPropotype: TEdit;
    edCfgCardsFile: TEdit;
    edCfgClipart: TEdit;
    edBackTemplate: TEdit;
    Panel1: TPanel;
    pnProjectSize: TPanel;
    gbCardSize: TGroupBox;
    lblCardWidth: TLabel;
    lblCardHeight: TLabel;
    lblDPI: TLabel;
    lblCardPreset: TLabel;
    lblCard: TLabel;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    cbDPI: TComboBox;
    cbPreset: TComboBox;
    chbLOCK: TCheckBox;
    Panel7: TPanel;
    gbPageSetup: TGroupBox;
    Label3: TLabel;
    lblResult: TLabel;
    lblPaper: TLabel;
    lblCardsXY: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lblCalcX: TLabel;
    lblCalcY: TLabel;
    lblUnits: TLabel;
    lblBleed: TLabel;
    lblOutline: TLabel;
    seCountX: TSpinEdit;
    seCountY: TSpinEdit;
    cbOutFormat: TComboBox;
    cbPaper: TComboBox;
    sePaperX: TEdit;
    sePaperY: TEdit;
    cbUnits: TComboBox;
    edBleed: TEdit;
    edOutline: TEdit;
    chkJPEG: TCheckBox;
    seForce: TSpinEdit;
    bgProcessing: TGroupBox;
    Label6: TLabel;
    lblCount: TLabel;
    lblResultFile: TLabel;
    lblFileSfx: TLabel;
    lblPageLimit: TLabel;
    lblScale: TLabel;
    Label29: TLabel;
    lblScaleSize: TLabel;
    chbMirror: TCheckBox;
    seFrom: TSpinEdit;
    seTo: TSpinEdit;
    chbRange: TCheckBox;
    btnAll: TButton;
    cbCount: TComboBox;
    cbFileName: TComboBox;
    cbFileSfx: TComboBox;
    edPageLimit: TEdit;
    seScale1: TSpinEdit;
    seScale2: TSpinEdit;
    gbSheet: TGroupBox;
    imgSheet: TImage;
    Panel6: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    gbRendering: TGroupBox;
    lblEngine: TLabel;
    chbSaveTemp: TCheckBox;
    btnResetlog: TButton;
    cbEngine: TComboBox;
    meAnalitics: TMemo;
    meLog: TMemo;
    gbTemplate: TGroupBox;
    Splitter1: TSplitter;
    InspectorFrame: TSvgInspectorFrame;
    Splitter2: TSplitter;
    gbPreview: TGroupBox;
    Panel3: TPanel;
    scrlPreview: TScrollBox;
    imgPreview: TImage;
    cbZoom: TComboBox;
    seFrame: TSpinEdit;
    seGridX: TSpinEdit;
    seGridY: TSpinEdit;
    PaintBox: TPaintBox;
    shpSelection: TShape;
    Splitter3: TSplitter;
    dlgTextFind: TFindDialog;
    pmFileText: TPopupMenu;
    File2: TMenuItem;
    Reloadtable1: TMenuItem;
    Load2: TMenuItem;
    Save2: TMenuItem;
    N7: TMenuItem;
    Createcontent1: TMenuItem;
    SVGFrame: TSvgTreeFrame;
    ClipartFrame: TSvgTreeFrame;
    Splitter4: TSplitter;
    ClipartInspectorFrame: TSvgInspectorFrame;
    pnGridDown: TPanel;
    sgText: TStringGrid;
    pnGridRight: TPanel;
    Splitter5: TSplitter;
    alCells: TActionList;
    aShow: TAction;
    aNext: TAction;
    aPrev: TAction;
    aFind: TAction;
    Rendering2: TPanel;
    tmrRender: TTimer;
    shpBkg: TShape;
    ImportSVG1: TMenuItem;
    N1: TMenuItem;
    pnClipartPreview: TPanel;
    aClipartPreview: TAction;
    pnTopClipartPreview: TPanel;
    sbPreview: TSpeedButton;
    GroupBox7: TGroupBox;
    seGrid: TSpinEdit;
    ColorGrid1: TColorGrid;
    scrlClipart: TScrollBox;
    Shape1: TShape;
    imgClipart: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblCellSize: TLabel;
    ToolBar1: TToolBar;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    pscrCellGrid: TPageScroller;
    tbrCellGrid: TToolBar;
    ToolButton30: TToolButton;
    ToolButton1: TToolButton;
    tbCellEdit: TToolButton;
    tbAutoWidth: TToolButton;
    tbFindText: TToolButton;
    ToolButton3: TToolButton;
    btnPreview: TToolButton;
    tbRenderPrev: TToolButton;
    tbRenderNext: TToolButton;
    Panel4: TPanel;
    scrlPreview1: TScrollBox;
    shpPreview: TShape;
    imgRender: TImage;
    ToolBar2: TToolBar;
    tbPreviewOpen: TToolButton;
    tbPreviewSave: TToolButton;
    tbPreviewRefresh: TToolButton;
    ToolButton7: TToolButton;
    tbRreview100: TToolButton;
    tbPreview2x: TToolButton;
    tbPreview05: TToolButton;
    tbPreviewToScreen: TToolButton;
    tbPreviewMM: TToolButton;
    Rendering3: TPanel;
    miTableHead: TMenuItem;
    procedure sbOpenRootClick(Sender: TObject);
    procedure sbOpenTextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbOpenTemplateClick(Sender: TObject);
    procedure SvgTreeFrame1treeTemplateChange(Sender: TObject; Node: TTreeNode);
    procedure atrCellEditDblClick(Sender: TObject);
    procedure cbAtrShowChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbZoomChange(Sender: TObject);
    procedure seFrameEnter(Sender: TObject);
    procedure seFrameChange(Sender: TObject);
    procedure seGridXEnter(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure seGridXChange(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure seGridXExit(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edCfgRootDblClick(Sender: TObject);
    procedure sbCfgTempClick(Sender: TObject);
    procedure sbCfgImgClick(Sender: TObject);
    procedure sbCfgResultClick(Sender: TObject);
    procedure sbCfgTTFClick(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
    procedure cbPresetChange(Sender: TObject);
    procedure cbDPIChange(Sender: TObject);
    procedure cbPaperChange(Sender: TObject);
    procedure cbUnitsChange(Sender: TObject);
    procedure seCountXChange(Sender: TObject);
    procedure sePaperXChange(Sender: TObject);
    procedure sePaperYChange(Sender: TObject);
    procedure chbMirrorClick(Sender: TObject);
    procedure ThreadRender(AImage:TImage; ASvgFile, ASvg, AResultFile:string; AZoom:Double; ADPI:integer; ID:TStringList=nil);
    procedure chbSaveTempClick(Sender: TObject);
    procedure btnResetlogClick(Sender: TObject);
    procedure tbOpenProjectClick(Sender: TObject);
    procedure sbOpenClipartClick(Sender: TObject);
    procedure chbLOCKClick(Sender: TObject);
    procedure tbAutoWidthClick(Sender: TObject);
    procedure dlgTextFindFind(Sender: TObject);
    procedure dlgTextFindClose(Sender: TObject);
    procedure tbCellEditClick(Sender: TObject);
    procedure sgTextSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure InspectorFrametbResizeClick(Sender: TObject);
    procedure sgTextDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure seHeightExit(Sender: TObject);
    procedure pcMainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure ClipartFrametreeTemplateChange(Sender: TObject; Node: TTreeNode);
    procedure btnAllClick(Sender: TObject);
    procedure chbRangeClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure aShowExecute(Sender: TObject);
    procedure aPrevExecute(Sender: TObject);
    procedure aNextExecute(Sender: TObject);
    procedure aFindExecute(Sender: TObject);
    procedure tbRreview100Click(Sender: TObject);
    procedure tbPreview2xClick(Sender: TObject);
    procedure tbPreview05Click(Sender: TObject);
    procedure tbPreviewMMClick(Sender: TObject);
    procedure tbPreviewToScreenClick(Sender: TObject);
    procedure tbPreviewOpenClick(Sender: TObject);
    procedure tbPreviewRefreshClick(Sender: TObject);
    procedure tbPreviewSaveClick(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tmrRenderTimer(Sender: TObject);
    procedure edCfgTTFExit(Sender: TObject);
    procedure seFromChange(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure tbSaveProjectClick(Sender: TObject);
    procedure Reloadtable1Click(Sender: TObject);
    procedure Save2Click(Sender: TObject);
    procedure SVGFrameSave1Click(Sender: TObject);
    procedure ClipartFrameSave1Click(Sender: TObject);
    procedure ImportSVG1Click(Sender: TObject);
    procedure aClipartPreviewExecute(Sender: TObject);
    procedure ClipartInspectorFramepcAtrInspectorChange(Sender: TObject);
    procedure Createcontent1Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SVGFrametreeTemplateExit(Sender: TObject);
    procedure miTableHeadClick(Sender: TObject);
    procedure sgTextKeyPress(Sender: TObject; var Key: Char);
    procedure sgTextFixedCellClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FSel:TRect;
    FSelCel:TRect;
    NoTempStyle :boolean;
    fBufPreview:boolean;
  public
    { Public declarations }
    SVG:TXML_Doc;
    Clipart: TXML_Doc;
    Config:TXML_Doc;
    ZoomFactor:double;
    ZoomPreview:double;
    Cell:TPointFloat;
    PageSize, CardsSize:TPoint;
    FBufXml:TStringList;
    RenderSize:TStringList;
    StopFlag:Boolean;
    fProtoFile:string;
    RenderReq:integer;
    FStartRender:TDateTime;
    GridMouse:boolean;
    procedure PrepareAtr(ANod: TXML_Nod);
    procedure ReadGrid(AFilename:string);
    procedure DrawSheet;
    procedure PrepareXML;
    procedure PrepareClipart;
    function ResultName(S:string;Cnt,Npp,N:integer):string;
    procedure ShowRendering(AFlag:boolean);
    procedure SaveTable(AFileName:string);
    procedure ChildDraw(ANod:TXML_Nod);
  end;


type TJpegDPI=class(TJPEGImage)
  private
    FDPI:Word;
  public
    property DPI:Word read FDPI write FDPI;
    procedure SaveToStream(Stream: TStream);override;
end;


var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses u_MainData, vcl.FileCtrl, u_XMLEditForm, Vcl.Imaging.pngimage, ShellAPI,
  u_ThreadRender, System.DateUtils, resvg, u_Html2SVG, u_CellEditForm, SynPdf, u_CalcSVG;

type
  THackGrid=class(TStringGrid);


function Zero(AEdit: TSpinEdit): integer;
begin
  result := 0;
  if AEdit.Text = '' then
    Abort
  else
    Result := AEdit.Value;
end;

const
 Base64Nil :Char = '=';
 Base64Encode: array [0..63] of char = (
   'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
   'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
   'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
   'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
   '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/');
 Base64Decode: array[0..255] of byte = (
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 64, 99, 99, 64, 99, 99, //"64" for #10,#13
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, //"99" for not Base64 codes
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63, //"62" for "+", "63" for "/"
   52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
   99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
   15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
   99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
   41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
   99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99);

function EncodeBase64(const StringToEncode: string): string; overload;
var
 len, ch0, ch1: integer;
 p, q: pChar;
begin;
 p:=pointer(StringToEncode);
 len:=length(StringToEncode);
 ch0:=((len+2) div 3) * 4;
 Setlength(Result,ch0);
 if ch0>0 then begin;
   q:=pointer(Result);
   pInteger(@q[ch0-4])^:=ord(Base64Nil)*$01010101;
   repeat;
     ch0:=Ord(p[0]);
     q[0]:=Base64Encode[ch0 shr 2];
     ch0:=(ch0 and $03) shl 4;
     if len<=1 then
       q[1]:=Base64Encode[ch0]
     else begin;
       ch1:=Ord(p[1]);
       q[1]:=Base64Encode[ch0 + (ch1 shr 4)];
       ch1:=(ch1 and $0F); ch1:=ch1+ch1; ch1:=ch1+ch1;
       if len<=2 then
         q[2]:=Base64Encode[ch1]
       else begin;
         ch0:=Ord(p[2]);
         q[2]:=Base64Encode[ch1 + (ch0 shr 6)];
         q[3]:=Base64Encode[ch0 and $3F];
         end;
       end;
     len:=len-3;
     p:=p+3;
     q:=q+4;
     until len<=0;
   end;
 end;



function WinExecAndWait32(FileName: string; Visibility: integer): integer;
var

  zAppName: array[0..512] of char;
  zCurDir: array[0..255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  rst: cardinal;
begin
//  MainForm.StartAnalitics('Rendering+');
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);

  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, { указатель командной строки }
    nil, { указатель на процесс атрибутов безопасности }
    nil, { указатель на поток атрибутов безопасности }
    false, { флаг родительского обработчика }
//    CREATE_NEW_CONSOLE or { флаг создания }
    NORMAL_PRIORITY_CLASS,
    nil, { указатель на новую среду процесса }
    nil, { указатель на имя текущей директории }
    StartupInfo, { указатель на STARTUPINFO }
    ProcessInfo) then
    Result := -1 { указатель на PROCESS_INF }

  else
  begin                                            //infinite

    while WaitforSingleObject(ProcessInfo.hProcess, 20)=WAIT_TIMEOUT	do
    begin
         if MilliSecondOf(time) < 500 then
           MainForm.Rendering1.Font.Color := clNavy
         else
           MainForm.Rendering1.Font.Color := clHighlight;

//         Main.Rendering2.Font.Color := Main.Rendering1.Font.Color;
//         Main.Rendering3.Font.Color := Main.Rendering1.Font.Color;
      Application.ProcessMessages;
      if MainForm.StopFlag then
        TerminateProcess(ProcessInfo.hProcess, 0);
    end;

    GetExitCodeProcess(ProcessInfo.hProcess, rst);
//    if rst=0 then raise Exception.Create( SysErrorMessage(GetLastError));
    Result := rst;
  end;
//  MainForm.StopAnalitics('Rendering+');
end;



procedure TMainForm.aClipartPreviewExecute(Sender: TObject);
var
   s1:string;
begin
  imgClipart.Visible := false;
  if ClipartFrame.SVGNode.LocalName='svg' then exit;
  if ClipartFrame.SVGNode.LocalName='defs' then exit;
  if ClipartFrame.SVGNode.Attribute['id']='' then exit;
  imgClipart.Visible := True;
  try
  if (ClipartFrame.SVGNode.LocalName='linearGradient')or
     (ClipartFrame.SVGNode.LocalName='radialGradient')
  then
    s1:='<rect width="'+IntToStr(seGrid.Value*5)
           +'" height="'+IntToStr(seGrid.Value*5)
           +'" fill="url(#'+ClipartFrame.SVGNode.Attribute['id']+')"/> ';

  if (ClipartFrame.SVGNode.LocalName='mask')  then
    s1:='<rect width="100%" height="100%" fill="black" '
           +' mask="url(#'+ClipartFrame.SVGNode.Attribute['id']+')"/> ';

  if (ClipartFrame.SVGNode.LocalName='clipPath')  then
    s1:='<rect width="100%" height="100%" fill="black" '
           +' clip-path="url(#'+ClipartFrame.SVGNode.Attribute['id']+')"/> ';

 if (ClipartFrame.SVGNode.LocalName='filter')  then
    s1:='<text x="100" y="100" font-size="100" fill="none" stroke-width="1" stroke="#000">'
           +' <tspan filter="url(#'+ClipartFrame.SVGNode.Attribute['id']+')">Filter</tspan> '
           +'<tspan x="100" y="200">No Filter</tspan></text> ';



  FBufXml.Clear;
  FBufXml.Add('<?xml version="1.0" encoding="UTF-8"?>');
  FBufXml.Add('<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">');
  FBufXml.Add('<svg width="'+IntToStr(seWidth.Value+2*seGrid.Value)+'" height="'+IntToStr(seHeight.Value+2*seGrid.Value)+'" fill-opacity="1" xmlns:xlink="http://www.w3.org/1999/xlink" color-rendering="auto" '
    +'color-interpolation="auto" text-rendering="auto" stroke="black" '
    +'stroke-linecap="square" stroke-miterlimit="10" shape-rendering="auto" stroke-opacity="1" '
    +'fill="black" stroke-dasharray="none" font-weight="normal" stroke-width="1" '
    +'xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" '
    +'xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto">');
  if seGrid.value >0 then
  FBufXml.Add('<defs><pattern id="globalback" patternUnits="userSpaceOnUse" x="0" y="0" width="'+IntToStr(seGrid.value)+'" height="'+IntToStr(seGrid.value)+'"> '
    +' <rect x="-1" y="-1" width="'+IntToStr(seGrid.value+1)+'" height="'+IntToStr(seGrid.value+1)+'" fill="none" stroke="#'+HexColor(ColorGrid1.ForegroundColor)+'" />	</pattern> '
    + ClipartFrame.SVGNode.xml
    +'</defs> '
    +'	<rect fill="#'+HexColor(ColorGrid1.BackgroundColor)+'" width="100%" height="100%"/>'
    +'	<rect fill="url(#globalback)" width="100%" height="100%"/>'+
'<g transform="translate('+seGrid.text+','+seGrid.text+')"> '
    + s1
    +'	<rect fill="none" stroke="black" stroke-width="1" '
//    +'x="' + IntToStr(Zero(seBorder)) +'" y="'+ IntToStr(Zero(seBorder))+'" '
    +' width="'+IntToStr(Zero(seWidth)-2*Zero(seFrame))
    +'" height="'+IntToStr(Zero(seHeight) -2*Zero(seFrame))+'"/>');

  FBufXml.Add('<use x="0" y="0" width="100%" height="100%" xlink:href="#'+ClipartFrame.SVGNode.Attribute['id']+'"/>');

  FBufXml.Add('</g></svg>');

  ThreadRender(imgClipart, edCfgRoot.text +'cliptemp.svg', FBufXml.Text, '', 1, 300);
  imgClipart.Width := imgClipart.Picture.Width;
  imgClipart.Height := imgClipart.Picture.Height;


{
  GetImgFromXml(Image1,  edCfgRoot.text+ 'cliptemp.svg',
    ExtractFilePath(ParamStr(0)),
    edCfgRoot.text + edCfgTemp.Text + 'cliptemp.png',clWhite,1,'','');
}
//  OpenPictureDialog1.FileName := edCfgRoot.text+ 'cliptemp.svg';
//  pcMain.ActivePage := tsPreview;
//  pcMainChange(nil)
  finally
//     Rendering1.Visible :=  False;
//     Rendering2.Visible := False;
//     Rendering3.Visible := False;

  end;
  fBufPreview := True;
end;

procedure TMainForm.aFindExecute(Sender: TObject);
begin
  dlgTextFind.Execute()
end;

procedure TMainForm.aNextExecute(Sender: TObject);
begin
  if sgText.Row<sgText.RowCount-1 then
  begin
    sgText.Row:=sgText.Row+1;
    btnPreview.Click
  end;

end;

procedure TMainForm.aPrevExecute(Sender: TObject);
begin
  if sgText.Row>1 then
  begin
    sgText.Row:=sgText.Row-1;
    btnPreview.Click
  end;
end;

procedure TMainForm.aShowExecute(Sender: TObject);
var
  rndr:integer;
begin
  RenderReq:=sgText.Row;

  if Rendering1.Visible then exit;

  InspectorFrame.ReplaceFrame.Apply;

  repeat
  rndr:=RenderReq;
  try
     ShowRendering(True);;
//     Rendering2.Visible := True;
//     Rendering3.Visible := True;



//  StartAnalitics('Preview');
  StopFlag:=False;

  ForceDirectories(edCfgRoot.text + edCfgTemp.Text);
  ChDir(edCfgRoot.text);


  //FBufXml.Text :=   Processcard(sgText.Row, '',XML);
//  row:=TStringList.Create;
//  row.Assign(sgText.Rows[sgText.Row]);

  FBufXml.Text :=   Processcard(
    sgText.Rows[sgText.Row],
    '',
    SVG,
    Clipart,
    edCfgRoot.Text + edCfgTemp.Text,
    edCfgClipart.Text,
    edCfgRoot.Text);
//    row.free;
{
  if chbSaveTemp.Checked then
    FBufXml.SaveToFile(edCfgRoot.Text +'temp.svg');
 }
  RenderSize.Clear;


  ThreadRender(imgPreview, edCfgRoot.Text +'temp.svg', FBufXml.Text, '', 1, 300, RenderSize);
  cbZoomChange(nil);
  imgRender.Picture.Assign(imgPreview.Picture);
  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);


  //OpenPictureDialog1.FileName := edCfgRoot.Text +'temp.svg';

//  Image1.Picture.Bitmap.Assign(imgRender.Picture.Bitmap);

  //StopAnalitics('Preview');
//  ShowAnalitics;
  finally
     ShowRendering(False);
//     Rendering2.Visible := False;
//     Rendering3.Visible := False;
  end;
  fBufPreview := True;
  until RenderReq=rndr;

end;

procedure TMainForm.atrCellEditDblClick(Sender: TObject);
begin
 ShowMessage('!');
end;

procedure TMainForm.btnAllClick(Sender: TObject);
begin
  seFrom.Value := 1;
  seTo.Value := sgText.RowCount-1;
  chbRange.Checked := False;
end;

procedure TMainForm.btnProcessClick(Sender: TObject);
var i,j,cnt,n, w, h:Integer;
  x1,x2:TXML_Doc;
  s,sx1,sxb1, fmt, fn, DPI,ZM :string;
  f:TFileStream;
  dlt, dltBK:TPoint;

procedure EmbedImg(Nod:TXML_NOD);
var
   i:Integer;
   fn,s:string;

begin
  if (Nod.LocalName='image') and
     (Nod.Attribute['xlink:href']<>'') and
     (Pos('data:image',Nod.Attribute['xlink:href'])<>1) and
     FileExists(Nod.Attribute['xlink:href'])
  then begin
    fn:=Nod.Attribute['xlink:href'];
    with TFileStream.Create(fn,fmOpenRead	) do
    try
      SetLength(s, Size);
      Read(s[1], Size);
    finally
      free;
    end;

    fn := LowerCase(StringReplace(ExtractFileExt(fn),'.','',[]));
    if fn='jpg' then fn:='jpeg';

    Nod.Attribute['xlink:href']:= 'data:image/'+fn+';base64,'+ encodebase64(s);
  end;

  for i := 0 to nod.Nodes.Count-1 do
    EmbedImg(nod.Nodes[i]);
end;


var
 Bleed, PdfPages: integer;
 BackXml, x1bk, x2bk:TXML_Doc;
 lPdf   : TPdfDocument;
 lPage  : TPdfPage;
 Box: TPdfBox;
 PrevFile:string;
 AbsIndex:integer;

 function CheckNewFile(AName:string):string;
 var i:integer;
 begin
   result := AName;
   i:=1;
   while pos('['+result+']',PrevFile)>0 do
   begin
     inc(i);
     result := StringReplace(AName, '.', '['+IntToStr(i)+'].', []);
   end;

   PrevFile := PrevFile + '['+result+']';
 end;
begin
  PrevFile:='';

  if (SVG.Nodes.Count=0) then
    Raise Exception.Create('Template is empty');

  if (cbOutFormat.text<>'PDF') and (edBackTemplate.Text<>'') and (cbFileSfx.Text='')
  then
    Raise Exception.Create('Prevent overwrite: back file suffix is empty');


  if (cbOutFormat.text='PDF') then
  begin
    lPdf := TPdfDocument.Create;
    lPdf.Info.Author        := 'Unknown pirate';
    lPdf.Info.CreationDate  := Now;
    lPdf.Info.Creator       := 'DeCard';
    lPdf.DefaultPaperSize   := psUserDefined;
    lPdf.ScreenLogPixels := StrToIntDef(cbDPI.Text,300);
    lPdf.DefaultPageWidth := PdfCoord(25.4*PageSize.X/StrToIntDef(cbDPI.Text,300));
    lPdf.DefaultPageHeight := PdfCoord(25.4*PageSize.Y/StrToIntDef(cbDPI.Text,300));
    PdfPages := 0;
  end;


 btnProcess.Enabled := False;
 StopFlag := False;
 btnStop.Enabled := True;
 BackXml := TXML_Doc.Create;
 x1bk := TXML_Doc.Create;
 x2bk := TXML_Doc.Create;
 gbCardSize.Enabled := false;
 gbPageSetup.Enabled := false;

   gbCardSize.font.Color := clBtnShadow;
   gbPageSetup.font.Color := gbCardSize.font.Color;

 try
  ShowRendering(True);
//  Rendering2.Visible := True;
//  Rendering3.Visible := True;
  ForceDirectories(edCfgRoot.text + edCfgResult.Text);
  ChDir(edCfgRoot.text);
  PdfPages := 0;


  ProgressBar1.Max := sgText.RowCount;
  ProgressBar1.Position := 0;
  ProgressBar1.Visible := True;
  x1:=TXML_Doc.Create;
  x2:=TXML_Doc.Create;
  x1.xml := SVG.xml;

  x1.Nodes.Last.Nodes.Clear;

  s:=x1.Nodes.Last.Attribute['width'];

  Bleed := StrToIntDef(edBleed.Text,0);

  dlt.X := (PageSize.X - CardsSize.X) div 2+Bleed;
  dlt.Y := (PageSize.Y - CardsSize.Y) div 2+Bleed;

//  DPI:=x1.Nodes.Last.Attribute['DPI'];
  DPI:=cbDPI.Text;
  if (DPI='') or (DPI='0') then DPI:='300';
  str(0.24 * 300 / StrToIntDef(DPI,300):0:5, ZM);


  for i:=Length(s) downto 1 do
    if Pos(s[i],'0123456789') = 0 then
      delete(s,i,1);
  w := StrToInt(s)*seScale1.Value div seScale2.Value + Bleed*2;

  s:= x1.Nodes.Last.Attribute['height'];
  for i:=Length(s) downto 1 do
    if Pos(s[i],'0123456789') = 0 then
      delete(s,i,1);
  h := StrToInt(s)*seScale1.Value div seScale2.Value + Bleed*2;

//  x1.Nodes.Last.Attribute['width'] := IntToStr(w * seCountX.value)  ;
//  x1.Nodes.Last.Attribute['height'] := IntToStr(h * seCountY.value)  ;
  x1.Nodes.Last.Attribute['width'] := IntToStr(PageSize.x)+'px';
  x1.Nodes.Last.Attribute['height'] := IntToStr(PageSize.y)+'px';
  x1.Nodes.Last.Attribute['viewBox'] := '';
//  x1.Nodes.Last.Attribute['transform'] := 'scale('+SvgFloat(seScale1.Value/seScale2.Value)+ ')';

  with x1.Nodes.Last.Add('rect') do
  begin
    Attribute['stroke'] := 'none';
    Attribute['fill'] := '#FFFFFF';
    Attribute['width'] := '100%';
    Attribute['height'] := '100%';
  end;

//  AddBack(x1,0);

  s := x1.Nodes.Last.Attribute['fill'];
  if s <> '' then
  with x1.Nodes.Last.Add('rect') do
  begin
    Attribute['stroke'] := 'none';
    Attribute['fill'] := s;
    if edOutline.Text <> '' then
    begin
      Attribute['x'] := IntTostr(dlt.X-Bleed-StrToIntDef(edOutline.Text,0));
      Attribute['y'] := IntTostr(dlt.Y-Bleed-StrToIntDef(edOutline.Text,0));
      Attribute['width'] := IntTostr(CardsSize.X+2*StrToIntDef(edOutline.Text,0));
      Attribute['height'] := IntTostr(CardsSize.Y+2*StrToIntDef(edOutline.Text,0));
    end
//    index := 1;
  end;

  if edBackTemplate.Text <> '' then
  begin
    if uppercase(ExtractFileExt(edBackTemplate.Text))='.SVG' then
      BackXml.LoadFromFile(edCfgRoot.text + edBackTemplate.Text)
    else
      BackXml.xml := '<?xml version="1.0" encoding="UTF-8"?>'
        + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">'
        + '<svg xmlns:xlink="http://www.w3.org/1999/xlink" fill="white" font-weight="normal" stroke-width="1"  xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto" '
        + ' width="'+IntToStr(seWidth.Value + 2*StrToIntDef(edBleed.Text,0)*seScale2.Value div seScale1.Value )+'" '
        + ' height="'+IntToStr(seHeight.Value + 2*StrToIntDef(edBleed.Text,0)*seScale2.Value div seScale1.Value)+'">'
        + '<image dekart:xlink_href="'+edBackTemplate.Text+'" '
        + ' width="'+IntToStr(seWidth.Value + 2*StrToIntDef(edBleed.Text,0)*seScale2.Value div seScale1.Value )+'" '
        + ' height="'+IntToStr(seHeight.Value + 2*StrToIntDef(edBleed.Text,0)*seScale2.Value div seScale1.Value)+'"></svg>';

    x1bk.xml := BackXml.xml;

    dltbk.x := (w-StrToInt(BackXml.Nodes.Last.Attribute['width'])*seScale1.Value div seScale2.Value ) div 2-Bleed;
    dltbk.y := (h-StrToInt(BackXml.Nodes.Last.Attribute['height'])*seScale1.Value div seScale2.Value ) div 2-Bleed;

    x1bk.Nodes.Last.Attribute['width'] := IntToStr(PageSize.x)+'px';
    x1bk.Nodes.Last.Attribute['height'] := IntToStr(PageSize.y)+'px';
//    x1bk.Nodes.Last.Attribute['transform'] := 'scale('+SvgFloat(seScale1.Value/seScale2.Value)+ ')';

    x1bk.Nodes.Last.Nodes.Clear;
    with x1bk.Nodes.Last.Add('rect') do
    begin
      Attribute['stroke'] := 'none';
      Attribute['fill'] := '#FFFFFF';
      Attribute['width'] := '100%';
      Attribute['height'] := '100%';
    end;
    s := x1bk.Nodes.Last.Attribute['fill'];
    if s <> '' then
    with x1bk.Nodes.Last.Add('rect') do
    begin
      Attribute['stroke'] := 'none';
      Attribute['fill'] := s;
      if edOutline.Text<>'' then
      begin
        Attribute['x'] := IntTostr(dlt.X-StrToIntDef(edOutline.Text,0)-Bleed );
        Attribute['y'] := IntTostr(dlt.Y-StrToIntDef(edOutline.Text,0)-Bleed);
        Attribute['width'] := IntTostr(CardsSize.X + StrToIntDef(edOutline.Text,0)*2);
        Attribute['height'] := IntTostr(CardsSize.Y + StrToIntDef(edOutline.Text,0)*2);
      end
      else
      begin
        Attribute['width'] := '100%';
        Attribute['height'] := '100%';
      end;
  end;


    sxb1 := x1bk.xml;
 end;


  sx1 := x1.xml;
  n:=0;
  fmt := Stringofchar('0', Length(IntToStr(sgText.RowCount)));
  for i:=1 to sgText.RowCount-1 do
  begin
    Application.ProcessMessages;

    if chbRange.Checked and ((i < seFrom.Value) or (i> seTo.Value)) then
      Continue;
    if StopFlag then Abort;
//    StartAnalitics('Process');
    Inc(AbsIndex);

    ProgressBar1.Position := i;
    sgText.Row := i;
    Application.ProcessMessages;

    x2.xml:= Processcard(sgText.Rows[i],
      'N'+FormatFloat(fmt,i)+'-',
       SVG,
       Clipart,
       edCfgRoot.Text + edCfgTemp.Text,
       edCfgClipart.Text,
       edCfgRoot.Text);

    x2.Nodes.Last.Attributes.Clear;
    x2.Nodes.Last.LocalName := 'g';

    if edBackTemplate.Text <> '' then
    begin
      x2bk.xml:= Processcard(
         sgText.Rows[i],
         'N'+FormatFloat(fmt,i)+'-',
          BackXml,
          Clipart,
          edCfgRoot.Text + edCfgTemp.Text,
          edCfgClipart.Text,
          edCfgRoot.Text);

      x2bk.Nodes.Last.Attributes.Clear;
      x2bk.Nodes.Last.LocalName := 'g';
    end;


    if (cbCount.Text <> '') then
    begin
      s := cbCount.Text;
      s := Copy(s,Pos('[',s+'[')+1,Length(s));
      s := Copy(s,1,Pos(']',s+']')-1);

      cnt := StrToIntDef(s ,-1);
      if cnt > 0 then
        cnt := StrToIntDef(sgText.Cells[cnt,i],1)
      else
        cnt := 1;
    end
    else
      cnt := 1;


    for j:=1 to cnt do
    begin


      if chbMirror.Checked then
        x2.Nodes.Last.Attribute['transform']:='translate('+IntToStr(dlt.X+ (seCountX.value-1 - n mod seCountX.value) * w)+','+IntToStr(dlt.Y+(n div seCountX.value) * h)+')'
      else
        x2.Nodes.Last.Attribute['transform']:='translate('+IntToStr(dlt.X+(n mod seCountX.value) * w)+','+IntToStr(dlt.Y+(n div seCountX.value) * h)+')';

      x2.Nodes.Last.Attribute['transform']:= x2.Nodes.Last.Attribute['transform'] + ' scale('+SvgFloat(seScale1.Value / seScale2.Value) +')';

      if edBackTemplate.Text <> '' then
      begin
        x2bk.Nodes.Last.Attribute['transform']:='translate('+IntToStr(dlt.X+dltbk.X+ (seCountX.value-1 - n mod seCountX.value) * w)+','+IntToStr(dlt.Y +dltbk.Y+(n div seCountX.value) * h)+')  scale('+SvgFloat(seScale1.Value / seScale2.Value) +')';
        x1bk.Nodes.Last.Add('g').xml := x2bk.Nodes.Last.xml;
      end;

      x1.Nodes.Last.Add('g').xml := x2.Nodes.Last.xml;
      inc(n);
      if (n =  seCountX.value * seCountY.value)
        or ((i=sgText.RowCount-1)and (j=cnt))
        or( chbRange.Checked and (i = seTo.Value) and (j=cnt) ) then
      begin

//      XML.Node[1].Attribute['dekart:background']
//      AddBack( +++,x1);

        fn := ResultName(cbFileName.Text, sgText.RowCount-1, i, j)+'.SVG';

        AddClipart(x1,Clipart, edCfgClipart.Text);

        if edBackTemplate.Text <> '' then
           AddClipart(x1bk,Clipart, edCfgClipart.Text);

        if chbSaveTemp.Checked then
        begin
          f:=TFileStream.Create(edCfgRoot.text + edCfgTemp.Text + fn, fmCreate);
          try
//            s := AnsiToUtf8Ex(x1.xml,CP_ACP);
            s := x1.xml;
            f.Write(s[1],Length(s));
          finally
            f.Destroy;
          end;
        end;

        if (cbOutFormat.text='SVG') then
          EmbedImg(x1.Node['svg']);

//        FBufXml.Text := AnsiToUtf8Ex(x1.xml,CP_ACP);
        FBufXml.Text := x1.xml;

//        StartAnalitics('Thread');
        if (cbOutFormat.text='PDF') then
        begin
           ThreadRender(imgRender, edCfgRoot.Text +'temp.svg', FBufXml.Text, '', 1, StrToIntDef(DPI,300));
//            Image1.Picture.Bitmap.Assign(imgRender.Picture.Bitmap);
           imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
           imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);


          lPage := lPDF.AddPage;
          Inc(PdfPages);

          Box.Left := 0;
          Box.Top := 0;
          Box.Width :=lPdf.DefaultPageWidth;
          Box.Height := lPdf.DefaultPageHeight;
          if chkJPEG.Checked then
            lPDF.ForceJPEGCompression := StrToIntDef(seForce.Text,0);

          lPDF.CreateOrGetImage(imgRender.Picture.Bitmap, @Box);



          if edBackTemplate.Text <> '' then
          begin
//            FBufXml.Text := AnsiToUtf8Ex(x1bk.xml,CP_ACP);
            FBufXml.Text := x1bk.xml;
            ThreadRender(imgRender, edCfgRoot.Text +'temp.svg', FBufXml.Text, '', 1, StrToIntDef(DPI,300));
            imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
            imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);
//            Image1.Picture.Bitmap.Assign(imgRender.Picture.Bitmap);
            lPDF.AddPage;
            Inc(PdfPages);

            Box.Left := 0;
            Box.Top := 0;
            Box.Width :=lPdf.DefaultPageWidth;
            Box.Height := lPdf.DefaultPageHeight;

            lPDF.CreateOrGetImage(imgRender.Picture.Bitmap, @Box);
          end;

          if (StrToIntDef(edPageLimit.Text,0)>0) and (StrToIntDef(edPageLimit.Text,0)=PdfPages) then
          begin
            lPdf.SaveToFile(edCfgRoot.text + edCfgResult.Text + CheckNewFile(ChangeFileExt(fn,'.'+cbOutFormat.text)));

            lPdf.Free;
            begin
              lPdf := TPdfDocument.Create;
              lPdf.Info.Author        := 'Unknown pirate';
              lPdf.Info.CreationDate  := Now;
              lPdf.Info.Creator       := 'DeCard';
              lPdf.DefaultPaperSize   := psUserDefined;
              lPdf.ScreenLogPixels := StrToIntDef(cbDPI.Text,300);
              lPdf.DefaultPageWidth := PdfCoord(25.4*PageSize.X/StrToIntDef(cbDPI.Text,300));
              lPdf.DefaultPageHeight := PdfCoord(25.4*PageSize.Y/StrToIntDef(cbDPI.Text,300));
              PdfPages := 0;
            end;
          end;


        end
        else
        if (cbOutFormat.text='SVG') then
        begin
          FBufXml.SaveToFile(edCfgRoot.text + edCfgResult.Text + CheckNewFile(ChangeFileExt(fn,'.'+cbOutFormat.text)));
          if edBackTemplate.Text <> '' then
          begin
            FBufXml.Text := x1bk.xml;
            FBufXml.SaveToFile(edCfgRoot.text + edCfgResult.Text + CheckNewFile(ChangeFileExt(fn,cbFileSfx.text+'.'+cbOutFormat.text)))
          end
        end
        else
        begin
          ThreadRender(imgRender, edCfgRoot.text + fn, FBufXml.Text,
            edCfgRoot.text + edCfgResult.Text + CheckNewFile(ChangeFileExt(fn,'.'+cbOutFormat.text)),
            1, StrToIntDef(DPI,300));
          imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
          imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);

          if edBackTemplate.Text <> '' then
          begin
            FBufXml.Text := x1bk.xml;
              ThreadRender(imgRender, edCfgRoot.text + fn, FBufXml.Text,
              edCfgRoot.text + edCfgResult.Text + CheckNewFile(ChangeFileExt(fn,cbFileSfx.text+'.'+cbOutFormat.text)),
              1, StrToIntDef(DPI,300));

            imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
            imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);
//              imgRender.Picture.Bitmap.Assign(imgRender.Picture.Bitmap);
          end
        end;
//        StopAnalitics('Thread');

//        DeleteFile(pchar(edCfgRoot.text + edCfgTemp.Text + fn));
//        MoveFile(pchar(edCfgRoot.text + fn), pchar(edCfgRoot.text + edCfgTemp.Text + fn));

        x1.xml := sx1;
        x1bk.xml := sxb1;
        n:=0;
      end;
    end;



//    StopAnalitics('Process');

//     ShowAnalitics;
  end;
  x1.free;
  x2.free;
    if (cbOutFormat.text='PDF') and (PdfPages>0) then
    try
      lPdf.SaveToFile(edCfgRoot.text + edCfgResult.Text + CheckNewFile(ChangeFileExt(fn,'.'+cbOutFormat.text)));
    finally
      lPdf.Free;
    end;

 finally
   ProgressBar1.Visible := False;
   btnStop.Enabled := False;
   ShowRendering(False);
//   Rendering2.Visible := False;
//   Rendering3.Visible := False;
   btnProcess.Enabled := True;
   BackXml.Free;
   x2bk.Free;
   x1bk.Free;
   gbCardSize.Enabled := True;
   gbPageSetup.Enabled := True;
   gbCardSize.font.Color := clWindowText;
   gbPageSetup.font.Color := gbCardSize.font.Color;


 end;
end;

procedure TMainForm.btnResetlogClick(Sender: TObject);
begin
  FreeConsole();
  AllocConsole();
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
 StopFlag := True;
end;

procedure TMainForm.cbAtrShowChange(Sender: TObject);
begin
  PrepareAtr( SVGFrame.SVGNode);
end;

procedure TMainForm.cbDPIChange(Sender: TObject);
begin
   cbPresetChange(nil);
   cbPaperChange(nil);
end;

procedure TMainForm.cbPaperChange(Sender: TObject);
var ou:Integer;
begin
  if StrToIntDef(edOutline.Text,0)>StrToIntDef(edBleed.Text,0) then
    ou:= StrToIntDef(edOutline.Text,0)- StrToIntDef(edBleed.Text,0)
  else
    ou:= 0;

  case cbPaper.ItemIndex of
    0:begin
        PageSize.X := CardsSize.X+ 2*ou;
        PageSize.Y := CardsSize.Y+ 2*ou;
      end;
    3:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 29.7/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 21.0/2.54);
      end;
    2:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 21.0/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 29.7/2.54);
      end;
    5:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 42.0/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 29.7/2.54);
      end;
    4:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 29.7/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 42.0/2.54);
      end;
    7:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 45.0/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 32.0/2.54);
      end;
    6:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 32.0/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 45.0/2.54);
      end;
    8:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 8.5);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 11);
      end;
    9:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 11);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 8.5);
      end;

    10:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 17);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 11);
      end;
    11:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 11);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 17);
      end;

    12:begin
        PageSize.X := Round(StrToIntDef(cbDPI.Text,300)* 14.8/2.54);
        PageSize.Y := Round(StrToIntDef(cbDPI.Text,300)* 21.0/2.54);
      end;
  end;
  cbUnits.OnChange(nil);
  DrawSheet;
end;

procedure TMainForm.cbPresetChange(Sender: TObject);
var s:string;
  x,y:real;
  err:Integer;
begin
  s := cbPreset.text;
  if Pos('|',s)> 0 then
  begin
    Val(Trim(copy(s,1,Pos('X',s)-1)), x, err);
    seWidth.Value := Round(x * StrToIntDef(cbDPI.Text,300) / 25.4  );

    Val(Trim(copy(s,Pos('X',s)+2,3)), y, err);
    seHeight.Value := Round(y * StrToIntDef(cbDPI.Text,300) / 25.4  );

   CardsSize.X :=(StrToIntDef(seWidth.Text,0) * seScale1.Value div seScale2.Value + 2*StrToIntDef(edBleed.Text,0)) * StrToIntDef(seCountX.Text,0) ;
   CardsSize.Y :=(StrToIntDef(seHeight.Text,0)* seScale1.Value div seScale2.Value + 2*StrToIntDef(edBleed.Text,0)) * StrToIntDef(seCountY.Text,0) ;
  end;
end;

procedure TMainForm.cbUnitsChange(Sender: TObject);
var dpi:integer;

begin
  dpi := StrToIntDef(cbDPI.Text,300);
  if dpi < 72 then dpi:=72;

  if (CardsSize.X > PageSize.X) and (PageSize.X>0) then
    lblCalcX.Font.Color := clRed
  else
    lblCalcX.Font.Color := clWindowText;

  if (CardsSize.Y > PageSize.Y) and (PageSize.Y >0) then
    lblCalcY.Font.Color := clRed
  else
    lblCalcY.Font.Color := clWindowText;

  if cbUnits <> nil then
  case cbUnits.ItemIndex of
    0:begin
        lblCalcX.Caption := FormatFloat('0',CardsSize.X) +' px';
        lblCalcY.Caption := FormatFloat('0',CardsSize.Y) +' px';
        sePaperX.Text := FormatFloat('0',PageSize.X);
        sePaperY.Text := FormatFloat('0',PageSize.Y);

        lblScaleSize.Caption := 'Card size: '
          + FormatFloat('0',seWidth.Value * seScale1.Value / seScale2.Value) +' x '
          + FormatFloat('0',seHeight.Value * seScale1.Value / seScale2.Value) + ' px';

        lblCard.Caption := 'Size: '
          + FormatFloat('0.0',seWidth.Value  /dpi*25.4) +' x '
          + FormatFloat('0.0',seHeight.Value  /dpi*25.4) +' mm';

      end;
    1:begin
        lblCalcX.Caption := FormatFloat('0.0',CardsSize.X/dpi*25.4)+' mm';
        lblCalcY.Caption := FormatFloat('0.0',CardsSize.Y/dpi*25.4)+' mm';
        sePaperX.Text := FormatFloat('0.0',PageSize.X/dpi*25.4);
        sePaperY.Text := FormatFloat('0.0',PageSize.Y/dpi*25.4);

        lblScaleSize.Caption := 'Card size: '
          + FormatFloat('0.0',seWidth.Value * seScale1.Value / seScale2.Value /dpi*25.4) +' x '
          + FormatFloat('0.0',seHeight.Value * seScale1.Value / seScale2.Value /dpi*25.4) +' mm';

        lblCard.Caption := 'Size: '
          + FormatFloat('0.0',seWidth.Value  /dpi*25.4) +' x '
          + FormatFloat('0.0',seHeight.Value  /dpi*25.4) +' mm';

      end;
    2:begin
        lblCalcX.Caption := FormatFloat('0.00',CardsSize.X/dpi)+' in';
        lblCalcY.Caption := FormatFloat('0.00',CardsSize.Y/dpi)+' in';
        sePaperX.Text := FormatFloat('0.00',PageSize.X/dpi);
        sePaperY.Text := FormatFloat('0.00',PageSize.Y/dpi);

        lblScaleSize.Caption := 'Card size: '
          + FormatFloat('0.00',seWidth.Value * seScale1.Value / seScale2.Value /dpi) +' x '
          + FormatFloat('0.00',seHeight.Value * seScale1.Value / seScale2.Value /dpi) +' in';

        lblCard.Caption := 'Size: '
          + FormatFloat('0.00',seWidth.Value  /dpi) +' x '
          + FormatFloat('0.00',seHeight.Value /dpi) +' in';

      end;
  end;

  DrawSheet;

end;

procedure TMainForm.cbZoomChange(Sender: TObject);
begin
  case cbZoom.ItemIndex of
    0:ZoomFactor:=1/4;
    1:ZoomFactor:=1/2;
    2:ZoomFactor:=1;
    3:ZoomFactor:=2;
  end;

  imgPreview.Width := round(imgPreview.Picture.Width * ZoomFactor) ;
  imgPreview.Height := round(imgPreview.Picture.Height * ZoomFactor);

//  PaintBox.Width := round((imgPreview.Picture.Width - seFrame.Value ) * ZoomFactor) ;
//  PaintBox.Height := round((imgPreview.Picture.Height - seFrame.Value) * ZoomFactor);
  PaintBox.Width := round((imgPreview.Picture.Width  ) * ZoomFactor) ;
  PaintBox.Height := round((imgPreview.Picture.Height ) * ZoomFactor);

  shpSelection.Left :=  imgPreview.Left + Round(FSel.Left * ZoomFactor);
  shpSelection.Top :=  imgPreview.top +  Round(FSel.Top * ZoomFactor);
  shpSelection.Width := Round(FSel.Width * ZoomFactor);
  shpSelection.Height := Round(FSel.Height * ZoomFactor);

end;

procedure TMainForm.chbLOCKClick(Sender: TObject);
begin
  seWidth.ReadOnly := chbLOCK.Checked;
  seHeight.ReadOnly := chbLOCK.Checked;
  cbPreset.Enabled := not chbLOCK.Checked;
end;

procedure TMainForm.chbMirrorClick(Sender: TObject);
begin
   DrawSheet;
end;

procedure TMainForm.chbRangeClick(Sender: TObject);
begin
  seFrom.Enabled := chbRange.Checked;
  seTo.Enabled := chbRange.Checked;
end;

procedure TMainForm.chbSaveTempClick(Sender: TObject);
begin
  if chbSaveTemp.Checked then
  begin
    resvg_init_log();
    chbSaveTemp.Enabled := False;
    btnResetlog.Click;
  end;
end;


procedure TMainForm.ChildDraw(ANod: TXML_Nod);
var i:integer;
   r:TTetra;
begin
  if ANod.LocalName='svg' then exit;
  FontCanvas := PaintBox.Canvas;


  r:= NodeRect(ANod);

  PaintBox.Canvas.Pen.Color := rgb(0,204,255);
  if SVGFrame.treeTemplate.Focused then
  begin
    PaintBox.Canvas.Brush.Style := bsFDiagonal;
    PaintBox.Canvas.Brush.Color := clWhite;
  end
  else
  begin
    PaintBox.Canvas.Brush.Style := bsClear;
  end;

  for i:=0 to 3 do
  begin
    r[i].X := round(r[i].X * ZoomFactor);
    r[i].Y := round(r[i].Y * ZoomFactor);
  end;


  PaintBox.Canvas.Polygon([r[0],r[1],r[2],r[3]]);

  if (ANod.LocalName='g')or(ANod.LocalName='symbol')or(ANod.LocalName='mask')or(ANod.LocalName='clipPath') then
    for i:=0 to ANod.Nodes.Count-1 do
      ChildDraw(ANod.Nodes[i])
end;

procedure TMainForm.ClipartFrameSave1Click(Sender: TObject);
begin
  MainData.dlgSaveSVG.Title := 'Save SVG-clipart';
  chdir(edCfgRoot.Text);
  MainData.dlgSaveSVG.InitialDir := edCfgRoot.Text;
  MainData.dlgSaveSVG.FileName := edCfgClipart.Text;
  if MainData.dlgSaveSVG.Execute then
  begin
    Clipart.Node['svg'].Attribute['xmlns:dekart']:='http://127.0.0.1';
    edCfgClipart.Text := ExtractRelativePath(edCfgRoot.Text, MainData.dlgSaveSVG.FileName);
    Clipart.SaveToFile(MainData.dlgSaveSVG.FileName);
  end;

end;

procedure TMainForm.ClipartFrametreeTemplateChange(Sender: TObject;
  Node: TTreeNode);
begin
  ClipartInspectorFrame.FocusedNode := Node;
  ClipartInspectorFrame.SVGNode := Node.Data;
  if (ClipartInspectorFrame.pcAtrInspector.Activepageindex=1) then
    aClipartPreview.Execute;
end;

procedure TMainForm.ClipartInspectorFramepcAtrInspectorChange(Sender: TObject);
begin
  ClipartInspectorFrame.pcAtrInspectorChange(Sender);

  if ClipartInspectorFrame.pcAtrInspector.Activepageindex=1 then
    aClipartPreview.Execute;
end;

procedure TMainForm.Createcontent1Click(Sender: TObject);
var
  sr: TSearchRec;
  s:string;
  pic:TPicture;
  i:Integer;
begin
  pic:=nil;
  if MessageDlg('Create new project from images folder?',mtConfirmation,[mbOk, mbCancel],0) <> mrOk then Exit;
  with sgText do
  try
   pic:=TPicture.Create;

    RowCount := 2;
    ColCount := 6;
    sgText.Rows[0].CommaText:='Content,[1]File,[2]Width,[3]Height,[4]Size,[5]Count';

    i:=0;

    if FindFirst(edCfgRoot.Text+edCfgImg.Text+'*.*', faAnyFile	, sr) = 0 then

    begin
      repeat
        s := UpperCase(ExtractFileExt(sr.Name));
        if (s='.PNG')or(s='.JPG')or(s='.JPEG')  then
        begin
          inc(i);
          if RowCount < i+1 then
            RowCount := i+1;
          Cells[0,RowCount-1] := IntToStr(i);
          Cells[1,RowCount-1] := sr.Name;
          pic.LoadFromFile(edCfgRoot.Text+edCfgImg.Text+sr.Name);
          Cells[2,RowCount-1] := IntToStr(pic.Graphic.Width);
          Cells[3,RowCount-1] := IntToStr(pic.Graphic.Height);
          Cells[4,RowCount-1] := IntToStr(sr.Size);
          Cells[5,RowCount-1] := '1';
          Row := i;
          Application.ProcessMessages;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;

    if (pic.Graphic<> nil) {and ((nxSVG.RowCount =0)or(nxSVG.Items[0].Count =0))}  then
    begin
      if FileExists(edCfgRoot.Text + edCfgPropotype.Text) then
        edCfgPropotype.Text := 'cardfolder.svg';
      edCfgCardsFile.Text := 'cardfolder.txt';


      SVG.xml := '<?xml version="1.0" encoding="UTF-8"?>'
      +'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">'
      +'<svg id="CardFolder" fill-opacity="1" xmlns:xlink="http://www.w3.org/1999/xlink" color-rendering="auto" '
        +'color-interpolation="auto" text-rendering="auto" stroke="black" '
        +'stroke-linecap="square" stroke-miterlimit="10" shape-rendering="auto" stroke-opacity="1" '
        +'fill="black" stroke-dasharray="none" font-weight="normal" stroke-width="1" '
        +'xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" '
        +'xmlns:template="127.0.0.1" xmlns:dekart="127.0.0.1" '
        +'xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto">'
        +  '</svg>';

      with SVG.Node['svg'] do
      begin
        Attribute['width']:= IntToStr(pic.Graphic.Width) ;
        Attribute['height']:=IntToStr(pic.Graphic.Height);
        with Add('image') do begin
          Attribute['id']:='Card';
          Attribute['width']:= IntToStr(pic.Graphic.Width);
          Attribute['height']:=IntToStr(pic.Graphic.Height);
          Attribute['xlink:href']:=edCfgImg.Text+Cells[1,RowCount-1];
          Attribute['dekart:xlink_href']:=edCfgImg.Text+'[1]';
        end;
        with Add('g') do
        begin
          Attribute['id']:='Cutting';
          Attribute['stroke']:='#000';
          Attribute['stroke-width']:='2';
          with Add('g')do
          begin
            Attribute['id']:='cut-cross';
            with Add('line') do
            begin
              Attribute['x1']:='0';
              Attribute['x2']:='0';
              Attribute['y1']:='-30';
              Attribute['y2']:='30';
            end;
            with Add('line') do
            begin
              Attribute['x1']:='-30';
              Attribute['x2']:='30';
              Attribute['y1']:='0';
              Attribute['y2']:='0';
            end;
          end;
          with Add('use') do
          begin
            Attribute['xlink:href']:='#cut-cross';
            Attribute['x']:=IntToStr(pic.Graphic.Width);
          end;
          with Add('use') do
          begin
            Attribute['xlink:href']:='#cut-cross';
            Attribute['y']:=IntToStr(pic.Graphic.Height);
          end;
          with Add('use') do
          begin
            Attribute['xlink:href']:='#cut-cross';
            Attribute['x']:=IntToStr(pic.Graphic.Width);
            Attribute['y']:=IntToStr(pic.Graphic.Height);
          end;
        end;
      end;
      SVGFrame.ResetSvg(SVG.Node['svg'],SVGFrame.treeTemplate.Items[0] );
      SVGFrame.treeTemplate.Items[0].Expand(False);
      seWidth.Value := pic.Graphic.Width + seFrame.Value * 2;
      seHeight.Value := pic.Graphic.Height + seFrame.Value * 2;
      seGridXChange(nil);
    end;

  finally
      pic.Free;
  end;
  cbCount.Items.Clear;
  cbCount.Text := '[5]';
  for i:=1 to sgText.ColCount-1 do
    cbCount.Items.Add('[' + IntToStr(i)+']');
  seTo.MaxValue := sgText.RowCount-1;
  seTo.Value := sgText.RowCount-1;
end;

procedure TMainForm.dlgTextFindClose(Sender: TObject);
begin
  Application.MainForm.SetFocus;
end;

procedure TMainForm.dlgTextFindFind(Sender: TObject);
var i:integer;



   function Compare(txt:string):Boolean;
   var
     s1,s2:string;
   begin
     if  (frMatchCase in dlgTextFind.Options) then
     begin
       s1 := dlgTextFind.FindText;
       s2 := txt;
     end
     else
     begin
       s1 := WideUpperCase(dlgTextFind.FindText);
       s2 := WideUpperCase(txt);
     end;
     if frWholeWord in dlgTextFind.Options then
       result := s1 = s2
     else
       result := pos(s1,s2)>0;

     if result then
     begin
       sgText.Row := i div sgText.ColCount;
       sgText.Col := i mod sgText.ColCount;
       abort;
     end;
   end;


begin
  i:=(sgText.Row) * sgText.ColCount + sgText.Col;
  while True do
  begin
    if frDown in dlgTextFind.Options then
      inc(i)
    else
      dec(i);
    if i<sgText.ColCount then exit;
    if i >= sgText.ColCount*sgText.RowCount then exit;
    Compare(sgText.Cells[i mod sgText.ColCount, i div sgText.ColCount])
  end;
end;

procedure TMainForm.edCfgRootDblClick(Sender: TObject);
begin
  ShellExecute(Application.Handle,
    nil,
    'explorer.exe',

    PChar(TEdit(Sender).text), //wherever you want the window to open to
    nil,
    SW_NORMAL     //see other possibilities by ctrl+clicking on SW_NORMAL
    );
end;

procedure TMainForm.edCfgTTFExit(Sender: TObject);
begin
  if edCfgTTF.Modified then
  begin
    edCfgTTF.Modified := false;
    ResetFonts(edCfgRoot.Text + edCfgTTF.Text);
  end;

end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageDlg('Exit program?', mtConfirmation, [mbYes, mbNo], 0)= mrYes;
  StopFlag := CanClose;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SVG:=TXML_Doc.Create;
  Clipart:=TXML_Doc.Create;
  Config:=TXML_Doc.Create;
  FBufXml:=TStringList.Create;
  RenderSize:=TStringList.Create;

  ZoomFactor := 1;
  ZoomPreview:= 1;

  sgText.cells[0,0]:='№';
  sgText.cells[1,0]:='[1]';
  sgText.cells[0,1]:='1';
  sgText.ColWidths[0]:=40;

  sgText.col := 1;
  sgText.row := 1;

  edCfgRoot.Text := ExtractFilePath(paramstr(0));
  NoTempStyle := true;

  pcMain.ActivePage := tsProject;
  SVGFrame.OnResizeClick:= InspectorFrametbResizeClick;

  imgPreview.Picture.Bitmap.Width := Zero(seWidth);
  imgPreview.Picture.Bitmap.Height := Zero(seHeight);
  FSel.Top:=0;
  FSel.Left:=0;
  FSel.Width:=imgPreview.Picture.Bitmap.Width;
  FSel.Height:=imgPreview.Picture.Bitmap.Height;
  cbZoomChange(nil);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SVG.Free;
end;


procedure TMainForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

var
  LTopLeft, LTopRight, LBottomLeft, LBottomRight: SmallInt;
  LPoint: TPoint;
  ScrollBox: TScrollBox;
  CursorPos:TPoint;
  ctr:TControl;
  nod:TTreeNode;
begin
  GetCursorPos(CursorPos);

  CursorPos:=  pcMain.ActivePage.ScreenToClient(CursorPos);

  ctr := pcMain.ActivePage.ControlAtPos(CursorPos,  False,True);
  if ctr = nil  then exit;

//--ctr :=pointer(Sender);
  if ((ctr=pnGridDown) or (ctr=pnGridRight)) and (ssShift in Shift) then
  begin
    if (WheelDelta>0) and (sgText.Col>1) then
      sgText.Col := sgText.Col-1
    else
    if (WheelDelta<0) and (sgText.Col<sgText.ColCount-1 )then
      sgText.Col := sgText.Col+1;

     Handled := True;
  end;

  if ctr=gbTemplate then
  begin
    nod := SVGFrame.FocusedNode;
    if WheelDelta>0 then
      nod:=nod.GetPrevVisible
    else
    if WheelDelta<0 then
      nod:=nod.GetNextVisible;

    if nod<> nil then
    begin
      nod.Selected := True;
      nod.Focused := True;
      nod.MakeVisible;
    end;
    Handled := True;
    exit;
  end;
  if ctr=ClipartFrame then
  begin
    nod:=ClipartFrame.FocusedNode;
    if WheelDelta>0 then
      nod:=nod.GetPrevVisible
    else
    if WheelDelta<0 then
      nod:=nod.GetNextVisible;

    if nod<> nil then
    begin
      nod.Selected := True;
      nod.Focused := True;
      nod.MakeVisible;
    end;

    Handled := True;
    exit;
  end;

  if ctr is TScrollBox then
    ScrollBox := TScrollBox(ctr)
  else
  if ctr=gbPreview then
    ScrollBox := scrlPreview
  else
    ScrollBox := Nil;


  if ScrollBox = nil then exit;

  LPoint := ScrollBox.ClientToScreen(Point(0,0));
  LTopLeft := LPoint.X;
  LTopRight := LTopLeft + ScrollBox.ClientWidth;
  LBottomLeft := LPoint.Y;
  LBottomRight := LBottomLeft + ScrollBox.ClientWidth;
  if (MousePos.X >= LTopLeft) and
    (MousePos.X <= LTopRight) and
    (MousePos.Y >= LBottomLeft) and
    (MousePos.Y <= LBottomRight) then
  begin
    if ssShift in Shift then
      ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position - WheelDelta
    else
      ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - WheelDelta;
    Handled := True;
  end;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  InspectorFrame.Initialize;
  ClipartInspectorFrame.Initialize;
  ClipartInspectorFrame.sgAttr.ColCount := 3;
  SVGFrame.SVG := SVG;
  ClipartFrame.SVG := Clipart;
  seWidthChange(nil);
  ClipartInspectorFrame.tsReplace.Caption := 'Preview';
  ClipartInspectorFrame.ReplaceFrame.Visible := False;
  pnClipartPreview.SetParentComponent(ClipartInspectorFrame.tsReplace);
  pnClipartPreview.Align :=alClient;


end;


procedure TMainForm.ImportSVG1Click(Sender: TObject);
var TMP:TXML_Doc;
  i:integer;
begin
  MainData.dlgOpenSVG.Title := 'Add SVG-files to clipart';
  ChDir(edCfgRoot.text);
  MainData.dlgOpenSVG.InitialDir := edCfgRoot.text;
  MainData.dlgOpenSVG.FileName := '';
  MainData.dlgOpenSVG.Options :=  MainData.dlgOpenSVG.Options+ [ofAllowMultiSelect];
  if MainData.dlgOpenSVG.Execute then
  begin
    TMP:=TXML_Doc.Create;
    try
      for i:=1 to MainData.dlgOpenSVG.Files.Count do
      begin
        TMP.LoadFromFile(MainData.dlgOpenSVG.Files[i-1]);
        with TMP.Node['svg'] do
        begin
          Attributes.Clear;
          LocalName :='g';
          Attribute['id'] := ChangeFileExt(ExtractFileName(MainData.dlgOpenSVG.Files[i-1]),'');
          ClipartFrame.InsertTag(xml);
        end;
      end;


    finally
      TMP.Free;
    end;
  end;
  MainData.dlgOpenSVG.Options := MainData.dlgOpenSVG.Options -[ofAllowMultiSelect];
end;

procedure TMainForm.InspectorFrametbResizeClick(Sender: TObject);
Var n:integer;
begin
  shpSelection.Visible := True;

  if FSel.Left > FSel.Right then
  begin
    n:=FSel.Right;
    FSel.Right := FSel.Left;
    FSel.Left := n;
  end;

  if FSel.Top > FSel.Bottom then
  begin
    n:=FSel.Bottom;
    FSel.Bottom := FSel.Top;
    FSel.Top := n;
  end;
  InspectorFrame.SetSize(FSel);
end;

procedure TMainForm.miTableHeadClick(Sender: TObject);
var i:integer;
begin
  for I := 0 to sgText.ColCount-1 do
  begin
    sgText.Cells[i,0]:=Stringreplace(sgText.Cells[i,0], '^[','[',[rfReplaceAll]);
    sgText.Cells[i,0]:=Stringreplace(sgText.Cells[i,0], 'v[','[',[rfReplaceAll]);
  end;

  XMLEditForm.XML := sgText.Rows[0].Text;
  XMLEditForm.seTags.Visible := False;
  XMLEditForm.splTags.Visible := False;
  XMLEditForm.SynEditFrame.SynEditor.Lines.Delete(0);
  if XMLEditForm.ShowModal=mrOk then
  begin
    sgText.Rows[0].Text := Trim('№'^M+XMLEditForm.SynEditFrame.SynEditor.Text);
    for i := 1 to sgText.ColCount-1 do
    begin
      if (pos('[', sgText.Cells[i,0])=1) and (pos(']', sgText.Cells[i,0])<6) then
         sgText.Cells[i,0] := copy(sgText.Cells[i,0], pos(']', sgText.Cells[i,0])+1, Length(sgText.Cells[i,0]));
      sgText.Cells[i,0] := '['+IntToStr(i)+'] ' + Trim(sgText.Cells[i,0]);
    end;


  end;

end;

procedure TMainForm.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBox.Visible := True;
  GridMouse := True;

  shpSelection.Visible := (ssLeft in Shift);

  if ((seGridX.Value=0) and (seGridY.Value=0)) then
  begin
    FSel.Left :=  Round(x /  ZoomFactor) ;
    FSel.Top :=  Round(y /  ZoomFactor) ;

    FSel.Width := 10;
    FSel.Height := 10;
    if FSel.Left > imgPreview.Picture.Width-2*seFrame.Value then
       FSel.Left := seFrame.Value + imgPreview.Picture.Width-2*seFrame.Value;
    if FSel.top > imgPreview.Picture.Height-2*seFrame.Value then
       FSel.top := imgPreview.Picture.Height-2*seFrame.Value

  end
  else  begin
    FSelCel.Left := trunc( (X / ZoomFactor - seFrame.Value) / Cell.x);
    FSelCel.Top := trunc( (y / ZoomFactor- seFrame.Value) / Cell.y);
    FSelCel.Width := 0;
    FSelCel.Height := 0;




    FSel.Left := Round(( Round(ZoomFactor
      * (seFrame.Value + Cell.x * FSelCel.Left))) / ZoomFactor);

    FSel.Top := Round((Round(ZoomFactor
      * (seFrame.Value + Cell.y * FSelCel.Top))) / ZoomFactor);

    FSel.Width := Round(Cell.x);
    FSel.Height := Round(Cell.y);

    if FSel.Left > imgPreview.Picture.Width-seFrame.Value-Cell.x/2 then
       FSel.Left := seFrame.Value + round(Cell.x * Trunc((imgPreview.Picture.Width-2*seFrame.Value - 5) / Cell.x));
    if FSel.top > imgPreview.Picture.Height-seFrame.Value-Cell.y/2 then
       FSel.top := seFrame.Value + round(Cell.y * Trunc((imgPreview.Picture.Height-2*seFrame.Value - 5) / Cell.x));
  end;

  if FSel.Left < seFrame.Value then
    FSel.Left := seFrame.Value;

  if FSel.Top < seFrame.Value then
    FSel.Top := seFrame.Value;




  if (FSel.Right > imgPreview.Picture.Width-seFrame.Value)
    or (FSelCel.Right+1= seGridX.Value)
  then
     FSel.Right := imgPreview.Picture.Width-seFrame.Value;

  if (FSel.Bottom > imgPreview.Picture.Height-seFrame.Value)
    or (FSelCel.Bottom+1= seGridY.Value)
  then
     FSel.Bottom := imgPreview.Picture.Height-seFrame.Value;

  shpSelection.Left :=  imgPreview.Left + Round(FSel.Left * ZoomFactor);
  shpSelection.Top :=  imgPreview.top +  Round(FSel.Top * ZoomFactor);
  shpSelection.Width := Round(FSel.Width * ZoomFactor);
  shpSelection.Height := Round(FSel.Height * ZoomFactor);
end;

procedure TMainForm.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

  if not (ssLeft in Shift) then exit;

  if ((seGridX.Value=0) and (seGridY.Value=0)) then
  begin
    FSel.Width := Round(x/ZoomFactor) - FSel.Left ;
    FSel.Height := Round(y/ZoomFactor) - FSel.Top;
  end
  else
  begin
    FSelCel.Right := trunc( (X / ZoomFactor - seFrame.Value) / Cell.x);
    FSelCel.Bottom := trunc( (Y / ZoomFactor - seFrame.Value) / Cell.y);

    FSel.Left := Round(min(FSelCel.Left,FSelCel.Right)  * Cell.x + seFrame.Value);
    FSel.Top := Round(min(FSelCel.Top,FSelCel.Bottom) * Cell.y + seFrame.Value);
    FSel.Width :=  Round(Cell.x * (abs(FSelCel.Width) +1));
    FSel.Height := Round(Cell.y * (abs(FSelCel.Height)+1));
  end;


  if FSel.Left < seFrame.Value then
    FSel.Left := seFrame.Value;

  if FSel.Top < seFrame.Value then
    FSel.Top := seFrame.Value;

  if (FSel.Right > imgPreview.Picture.Width-seFrame.Value)
    or (FSelCel.Right+1= seGridX.Value)
  then
     FSel.Right := imgPreview.Picture.Width-seFrame.Value;

  if (FSel.Bottom > imgPreview.Picture.Height-seFrame.Value)
    or (FSelCel.Bottom+1= seGridY.Value)
  then
     FSel.Bottom := imgPreview.Picture.Height-seFrame.Value;

  if FSel.Right < seFrame.Value then
    FSel.Right := seFrame.Value;

  if FSel.Bottom < seFrame.Value then
    FSel.Bottom := seFrame.Value;



  if FSel.Width<0 then
    shpSelection.Left   := imgPreview.Left + Round(FSel.Right * ZoomFactor)
  else
    shpSelection.Left   := imgPreview.Left + Round(FSel.Left * ZoomFactor);
  if FSel.Height<0 then
    shpSelection.Top    := imgPreview.top + Round(FSel.Bottom * ZoomFactor)
  else
    shpSelection.Top    := imgPreview.top + Round(FSel.Top * ZoomFactor);


  shpSelection.Width  := Abs(Round(FSel.Width * ZoomFactor));
  shpSelection.Height := Abs(Round(FSel.Height * ZoomFactor));
end;

procedure TMainForm.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    GridMouse := False;
    PaintBox.Visible := False;
end;

procedure TMainForm.PaintBoxPaint(Sender: TObject);
var
  i,j:integer;

Function ButtonIsDown(Button:TMousebutton):Boolean;
var Swap :Boolean;
    State:short;
begin
State:=0;
Swap:= GetSystemMetrics(SM_SWAPBUTTON)<>0;
if Swap then
   case button of
   mbLeft :State:=getAsyncKeystate(VK_RBUTTON);
   mbRight:State:=getAsyncKeystate(VK_LBUTTON);
   end
else
   case button of
   mbLeft :State:=getAsyncKeystate(VK_LBUTTON);
   mbRight:State:=getAsyncKeystate(VK_RBUTTON);
   end;
Result:= (State < 0);
end;
begin
  Cell.X := imgPreview.Picture.Width-seFrame.Value*2;
  Cell.Y := imgPreview.Picture.Height-seFrame.Value*2;


  PaintBox.Canvas.Brush.Style := bsClear;
  PaintBox.Canvas.Pen.Color := clLime;


//  PaintBox.Canvas.Rectangle();

  if (seGridX.Value=0) and (seGridY.Value=0) then
  begin
  if Not SVGFrame.treeTemplate.Focused or GridMouse then
  PaintBox.Canvas.Rectangle(
    Round(seFrame.Value * ZoomFactor),
    Round(seFrame.Value * ZoomFactor),
    Round((imgPreview.Picture.Width-seFrame.Value*1) * ZoomFactor),
    Round((imgPreview.Picture.Height-seFrame.Value*1) * ZoomFactor));
  end
  else
  begin
    if seGridX.Value>0 then
      Cell.X := Cell.X / seGridX.Value;

    if seGridY.Value>0 then
      Cell.Y := Cell.Y / seGridY.Value;

    if (seGridX.Value=0) then
      Cell.X := Cell.Y;

    if  (seGridY.Value=0) then
      Cell.Y := Cell.X;

    if Not SVGFrame.treeTemplate.Focused or GridMouse then
    begin
      for I := 0 to round((imgPreview.Picture.Width-seFrame.Value*2)/Cell.X)+1 do
      begin
        PaintBox.Canvas.MoveTo(Round(Min((seFrame.Value + i * Cell.X),imgPreview.Picture.Width-seFrame.Value)*ZoomFactor),
          round(seFrame.Value*ZoomFactor) );
        PaintBox.Canvas.LineTo(Round(Min((seFrame.Value + i * Cell.X),imgPreview.Picture.Width-seFrame.Value)*ZoomFactor),
           round((imgPreview.Picture.Height - seFrame.Value)*ZoomFactor) );
      end;
      for j := 0 to round((imgPreview.Picture.Height-seFrame.Value*2)/Cell.Y)+1 do
      begin
        PaintBox.Canvas.MoveTo(round(seFrame.Value*ZoomFactor) ,
          Round(Min((seFrame.Value + j * Cell.Y),imgPreview.Picture.Height-seFrame.Value)*ZoomFactor));
        PaintBox.Canvas.LineTo(round((imgPreview.Picture.Width - seFrame.Value)*ZoomFactor),
          Round(Min((seFrame.Value + j * Cell.Y),imgPreview.Picture.Height-seFrame.Value)*ZoomFactor));
      end;

{
      for j := 0 to round((imgPreview.Picture.Height-seFrame.Value*2)/Cell.Y) do
      begin
        PaintBox.Canvas.Rectangle(
         Round(Min((seFrame.Value + i * Cell.X),imgPreview.Picture.Width-seFrame.Value)*ZoomFactor),
         Round(Min((seFrame.Value + j * Cell.Y),imgPreview.Picture.Height-seFrame.Value)*ZoomFactor),
         Round(Min((seFrame.Value + (i+1)* Cell.X), imgPreview.Picture.Width-seFrame.Value) * ZoomFactor+1),
         Round(Min((seFrame.Value + (j+1)* Cell.Y), imgPreview.Picture.Height-seFrame.Value) * ZoomFactor)+1);
      end;
}
    end
  end;

  ChildDraw(SVGFrame.SVGNode);

end;

procedure TMainForm.pcMainChange(Sender: TObject);
begin
  if pcMain.ActivePageIndex=1 then
  begin
    sgText.SetParentComponent(pnGridDown);
    pscrCellGrid.SetParentComponent(gbTemplate);
    pscrCellGrid.Align := alBottom;
  end;
  if pcMain.ActivePageIndex=3 then
  begin
    pscrCellGrid.SetParentComponent(pnGridRight);
    pscrCellGrid.Align := alTop;
    sgText.SetParentComponent(pnGridRight);
  end;

end;

procedure TMainForm.pcMainChanging(Sender: TObject; var AllowChange: Boolean);
begin
//   InspectorFrame.SVGNode := InspectorFrame.SVGNode;
end;

procedure TMainForm.PrepareAtr(ANod: TXML_Nod);
begin
end;

procedure TMainForm.PrepareClipart;
begin
  Clipart.Node['svg'].Attribute['id'] := ExtractFileName(edCfgClipart.Text);
  ClipartFrame.SVG := Clipart;
end;

procedure TMainForm.PrepareXML;
begin
  SVG.Node['svg'].Attribute['id'] := ExtractFileName(edCfgPropotype.Text);
  SvgFrame.SVG := SVG;
  NoTempStyle := False;
  seHeight.Value := StrToIntDef(SVG.Node['svg'].Attribute['height'], seHeight.Value);
  seWidth.Value := StrToIntDef(SVG.Node['svg'].Attribute['width'], seWidth.Value);
  NoTempStyle := true;
end;

procedure TMainForm.ReadGrid(AFilename: string);
var sl:TStringList;
  ws: string;
  s,ff:string;
  i,j:integer;
  arow,acol:integer;


  begin

  ff := UpperCase(ExtractFileExt(AFilename));

  arow := sgText.row;
  sl:=TStringList.Create;
  if arow<0 then arow := 0;
    acol := sgText.Col;
  if acol<1 then acol := 1;

  try


    if lblEncoding.Caption ='UTF-8' then
      sl.LoadFromFile(AFilename, TEncoding.UTF8)
    else
      sl.LoadFromFile(AFilename);


    seFrom.MaxValue := sl.Count;
    seTo.MaxValue := sl.Count;
    seTo.Value := sl.Count;
    sgText.RowCount:=2;
    sgText.ColCount:=2;
    if copy(sl[0],1,3)='[1]' then
    begin
      j:=0;
      s:=sl[0];
      while s<>'' do
      begin
        inc(j);
        if sgText.ColCount < j+1 then
        begin
          sgText.ColCount := j+1;
          sgText.Cells[sgText.ColCount-1,0] := '['+IntToStr(J)+']'
        end;
        ws:=Copy(s,1,Pos(#9,s+#9)-1);
        if pos('['+IntToStr(J)+']',ws)<>1 then
          sgText.Cells[j,0]:='['+IntToStr(J)+']' + ws
        else
          sgText.Cells[j,0]:= ws;
        delete(s,1,Pos(#9,s+#9));
      end;

      sl.Delete(0);
    end;
    sgText.RowCount := sl.Count+1;
    sgText.Cells[0,0] := '№';
    sgText.Cells[0,1] := '1';

    for i:=1 to sl.Count do
    begin
//      sgText.Cells[0,i+1]:=IntToStr(I+1);
      sgText.Rows[i+1].Text:=IntToStr(I+1);
      s:=sl[i-1];
      j:=0;
      while s<>'' do
      begin
        inc(j);
        if sgText.ColCount < j+1 then
        begin
          sgText.ColCount := j+1;
          sgText.Cells[sgText.ColCount-1,0] := '['+IntToStr(J)+']'
        end;
        ws:=Copy(s,1,Pos(#9,s+#9)-1);

//          ws := Utf8ToAnsiEx(ws,GetACP);
//          ws := Utf8ToHtml(ws);
        sgText.Cells[j,i]:=(ws);
        delete(s,1,Pos(#9,s+#9));

      end;
    end;
  finally
    if arow>=sgText.RowCount then arow := sgText.RowCount-1;
    if acol>=sgText.colCount then acol := sgText.ColCount-1;
    sgText.Col := acol;
    sgText.row := arow;
    sgText.Invalidate;

    sl.Free;
  end;

  cbCount.Items.Clear;
  for i:=1 to sgText.ColCount-1 do
    cbCount.Items.Add('[' + IntToStr(i)+']');

  cbFileName.Items.Assign(cbCount.Items);
  cbFileName.Items.Insert(0, ChangeFileExt(edCfgPropotype.Text,'')+'[count]x[npp]' );


//  fCellChanged:=False;
end;

procedure TMainForm.Reloadtable1Click(Sender: TObject);
begin
  if MessageDlg('Discard changes, reload table?', mtConfirmation, [mbYes, mbNo], 0)=mrYes  then
    ReadGrid(MainData.dlgOpenText.FileName);
end;

function TMainForm.ResultName(S: string; Cnt, Npp, N: integer): string;
var i:integer;
begin

  result:=ChangeFileExt(s,'');

  for i:=0 to sgText.ColCount-1 do
    result := StringReplace(result, '[' + IntToStr(i)+']', sgText.Cells[i, Npp], [rfReplaceAll, rfIgnoreCase]);

  result := StringReplace(result, '[count]', IntToStr(Cnt), [rfReplaceAll, rfIgnoreCase]);
  if N > 1 then
    result := StringReplace(result, '[npp]', FormatFloat(Stringofchar('0', Length(IntToStr(Cnt))), Npp)+ '_'+IntToStr(n), [rfReplaceAll, rfIgnoreCase])
  else
    result := StringReplace(result, '[npp]', FormatFloat(Stringofchar('0', Length(IntToStr(Cnt))), Npp), [rfReplaceAll, rfIgnoreCase]);

  if result='' then
    result := 'CARD' + IntToStr(Cnt) + 'x'+ FormatFloat(Stringofchar('0', Length(IntToStr(Cnt))), Npp);

end;

procedure TMainForm.Save2Click(Sender: TObject);

begin
  chdir(edCfgRoot.Text);
  MainData.dlgSaveContent.DefaultExt := ExtractFileExt(edCfgCardsFile.Text);
  MainData.dlgSaveContent.InitialDir := edCfgRoot.Text;
  MainData.dlgSaveContent.FileName := edCfgRoot.Text + edCfgCardsFile.Text;

  if  MainData.dlgSaveContent.Execute then
  begin
    if MainData.dlgSaveContent.FilterIndex=1 then
      MainData.dlgSaveContent.FileName := ChangeFileExt(MainData.dlgSaveContent.FileName, '.TSV')
    else
    if MainData.dlgSaveContent.FilterIndex=2 then
      MainData.dlgSaveContent.FileName := ChangeFileExt(MainData.dlgSaveContent.FileName, '.TXT');


    if MainData.dlgSaveContent.Encodings[MainData.dlgSaveContent.EncodingIndex]='default' then
    begin
      if  UpperCase(ExtractFileExt(MainData.dlgSaveContent.FileName))='.TXT' then
        lblEncoding.Caption := 'ANSI'
      else
        lblEncoding.Caption := 'UTF-8'
    end
    else
      lblEncoding.Caption := MainData.dlgSaveContent.Encodings[MainData.dlgSaveContent.EncodingIndex];

    edCfgCardsFile.Text := ExtractRelativePath(edCfgRoot.Text, MainData.dlgSaveContent.FileName);

    SaveTable(edCfgRoot.Text+edCfgCardsFile.Text);
  end;
end;

procedure TMainForm.SaveTable(AFileName: string);
var i,j:Integer;
  s: string;
begin
  sgTextFixedCellClick(nil,0,-1);
  with TStringList.Create do
  try
    for i := 0 to sgText.RowCount-1 do
    begin
      s:=sgText.cells[1,i];
      for j := 2 to sgText.ColCount-1 do
        s := s + #9 + sgText.cells[j,i];
      Add(s);
    end;

    if lblEncoding.Caption = 'UTF-8' then
      SaveToFile(AFileName, Encoding.UTF8)
    else
      SaveToFile(AFileName, Encoding.ANSI);
  finally
    Free;
  end;

end;

procedure TMainForm.sbOpenClipartClick(Sender: TObject);
begin
  MainData.dlgOpenSVG.Title := 'Open SVG-clipart';
  ChDir(edCfgRoot.text);
  MainData.dlgOpenSVG.InitialDir := edCfgRoot.text;
  MainData.dlgOpenSVG.FileName := edCfgClipart.Text;
  if MainData.dlgOpenSVG.Execute then
  begin
    edCfgClipart.Text := ExtractRelativePath(edCfgRoot.Text, MainData.dlgOpenSVG.FileName);
    Clipart.LoadFromFile(MainData.dlgOpenSVG.FileName);
    PrepareClipart;
  end;

end;

procedure TMainForm.sbOpenRootClick(Sender: TObject);
var s:string;
begin
  s := edCfgRoot.Text;
  if SelectDirectory('Project root','.' ,s, [sdNewUI, sdNewFolder,sdShowEdit]) then
    edCfgRoot.Text := s+'\';
  ChDir(edCfgRoot.text);
end;


procedure TMainForm.seCountXChange(Sender: TObject);
begin
   if (StrToIntDef(seScale1.Text,0)=0)
     or (StrToIntDef(seScale2.Text,0)=0)
     or (StrToIntDef(seCountX.Text,0)=0)
     or (StrToIntDef(seCountY.Text,0)=0)
     or (StrToIntDef(seWidth.Text,0)=0)
     or (StrToIntDef(seHeight.Text,0)=0)
   then exit;

   CardsSize.X :=(StrToIntDef(seWidth.Text,0)   * seScale1.Value div seScale2.Value
     + 2*StrToIntDef(edBleed.Text,0))  * StrToIntDef(seCountX.Text,0);
   CardsSize.Y :=(StrToIntDef(seHeight.Text,0)   * seScale1.Value div seScale2.Value
     + 2*StrToIntDef(edBleed.Text,0))* StrToIntDef(seCountY.Text,0);
   cbPaperChange(nil);
end;

procedure TMainForm.seFrameChange(Sender: TObject);
begin
  PaintBox.Width :=  Round(ZoomFactor * (imgPreview.Picture.Width));
  PaintBox.Height := Round(ZoomFactor * (imgPreview.Picture.Height));
  SVGFrame.FrameSize := seFrame.Value;
  lblCellSize.Caption := IntToStr(Round(Cell.X))+' : '+IntToStr(Round(Cell.Y));
  PaintBox.Invalidate;

end;

procedure TMainForm.seFrameEnter(Sender: TObject);
begin
  shpSelection.Visible := False;
  PaintBox.Visible := True;
  seFrameChange(Sender)
end;

procedure TMainForm.seFromChange(Sender: TObject);
begin
  seTo.MinValue := seFrom.Value;
end;

procedure TMainForm.seGridXChange(Sender: TObject);
begin
  shpSelection.Visible := False;
  PaintBox.Visible := True;
  PaintBox.Repaint;
  lblCellSize.Caption := IntToStr(Round(Cell.X))+' : '+IntToStr(Round(Cell.Y));
end;

procedure TMainForm.seGridXEnter(Sender: TObject);
begin
  seGridXChange(seGridX);
end;

procedure TMainForm.seGridXExit(Sender: TObject);
begin
  PaintBox.Visible := False;
end;

procedure TMainForm.seHeightExit(Sender: TObject);
begin
   imgPreview.Picture.Bitmap.Width := Zero(seWidth);
   imgPreview.Picture.Bitmap.Height := Zero(seHeight);
   InspectorFrame.SVGNode := InspectorFrame.SVGNode;
end;

procedure TMainForm.sePaperXChange(Sender: TObject);
begin
  if sePaperX.Focused then
  case cbUnits.ItemIndex of
    0:PageSize.X := StrToIntDef(sePaperX.Text,0);
    1:PageSize.X := Round(StrToFloatDef(sePaperX.Text,0) * StrToIntDef(cbDPI.Text,300) * 25.4);
    2:PageSize.X := Round(StrToFloatDef(sePaperX.Text,0) * StrToIntDef(cbDPI.Text,300) );
  end;
//  cbUnitsChange(nil)
DrawSheet;
end;

procedure TMainForm.sePaperYChange(Sender: TObject);
begin
  if sePaperY.Focused then
  case cbUnits.ItemIndex of
    0:PageSize.Y := StrToIntDef(sePaperY.Text,0);
    1:PageSize.Y := Round(StrToFloatDef(sePaperY.Text,0) * StrToIntDef(cbDPI.Text,300) * 25.4);
    2:PageSize.Y := Round(StrToFloatDef(sePaperY.Text,0) * StrToIntDef(cbDPI.Text,300)) ;
  end;
//  cbUnitsChange(nil)
DrawSheet;
end;

procedure TMainForm.seWidthChange(Sender: TObject);
begin
  if not NoTempStyle then Exit;


   SVG.Node['svg'].Attribute['width'] := IntToStr(seWidth.Value);
   SVG.Node['svg'].Attribute['height'] := IntToStr(seHeight.Value);

   seFrame.OnChange(nil);

   CardsSize.X := (seWidth.Value + 2*StrToIntDef(edBleed.Text,0)) * seCountX.Value;
   CardsSize.Y := (seHeight.Value + 2*StrToIntDef(edBleed.Text,0)) * seCountY.Value;

   cbUnits.OnChange(nil);
   cbPaper.OnChange(nil);
   cbDPI.OnChange(nil);

end;

procedure TMainForm.sgTextDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ACol=0)and (Arow>0) then
    sgText.Canvas.TextRect(Rect,Rect.Left,Rect.Top, IntToStr(Arow));

  if ARow=sgText.Row then
  begin


    sgText.Canvas.Brush.Style := bsClear;
    sgText.Canvas.Pen.Color := clBlue;
    sgText.Canvas.Rectangle(sgText.CellRect(ACol,ARow));

//    sgText.Canvas.Rectangle(Rect.Left-5, Rect.Top, Rect.Right+1, Rect.Bottom);
  end;

end;

procedure TMainForm.sgTextFixedCellClick(Sender: TObject; ACol, ARow: Integer);
var
  i,j:integer;
  sl:TStringList;
  s:string;
  Srt:boolean;

begin
  if Arow=0 then
  begin
     sl:=TStringList.Create;
     sl.Sorted := True;
     sl.Duplicates := dupAccept;
     Srt := True;

     if (ARow=-1)or(ACol=0) then
       Srt := True
     else
       Srt := copy(sgText.Cells[Acol,0],1,1)<>'^';



     for I := 0 to sgText.ColCount-1 do
     begin
       sgText.Cells[i,0]:=Stringreplace(sgText.Cells[i,0], '^[','[',[rfReplaceAll]);
       sgText.Cells[i,0]:=Stringreplace(sgText.Cells[i,0], 'v[','[',[rfReplaceAll]);
       sgText.Cells[i,0]:=Stringreplace(sgText.Cells[i,0], '^№','№',[rfReplaceAll]);
       sgText.Cells[i,0]:=Stringreplace(sgText.Cells[i,0], 'v№','№',[rfReplaceAll]);
     end;

     if Srt then
     begin
       for I := 1 to sgText.RowCount-1 do
       begin
         s:=sgText.Cells[Acol,i];
         if ACol=0 then
           s:=RightStr('00000'+s,5);
         j := sl.Add(s);
         while (j<sl.Count-1) and (sl[j]=sl[j+1]) do inc(j);

         if j+1 <> i then
           THackGrid(sgText).MoveRow(i, j+1);
       end;
       if (ARow<>-1)and(ACol<>0) then
        sgText.Cells[Acol,0] := '^'+sgText.Cells[Acol,0];
     end
     else
     begin
       for I := sgText.RowCount-1 downto 1 do
       begin
         s:=sgText.Cells[Acol,i];
         if ACol=0 then
           s:=RightStr('00000'+s,5);
         j := sl.Add(s);
//         while (j<sl.Count-1) and (sl[j]=sl[j+1]) do inc(j);

         if sgText.RowCount -j-1 <> i then
           THackGrid(sgText).MoveRow(i, sgText.RowCount-j-1);
       end;
       if (ACol<>0) then
         sgText.Cells[Acol,0] := 'v'+sgText.Cells[Acol,0];
     end;

     if sgText.Row  <sgText.TopRow then
       sgText.TopRow := sgText.Row;
     if sgText.Row > sgText.TopRow+sgText.VisibleRowCount  then
       sgText.TopRow := sgText.Row-sgText.VisibleRowCount+1;



     sl.Destroy;
  end;
end;

procedure TMainForm.sgTextKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    tbCellEditClick(self);
    key:=#0;
  end;
end;

procedure TMainForm.sgTextSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if CellEditForm.Visible then
  begin
    CellEditForm.Text := sgText.Cells[ACol,ARow];
    CellEditForm.Caption := 'Cell['+IntToStr(ACol)+':'+ IntToStr(ARow)+'] <'
      + ExtractFileName(edCfgCardsFile.Text) +'>'
  end;
  sgText.Invalidate;
end;

procedure TMainForm.ShowRendering(AFlag: boolean);
begin
  Rendering1.Visible := AFlag;
  Rendering2.Visible := AFlag;
  Rendering3.Visible := AFlag;
  FStartRender:=Now;
  tmrRender.Enabled := AFlag;
  Rendering1.Caption:='Rendering...';
  Rendering2.Caption:=Rendering1.Caption;
  Rendering3.Caption:=Rendering1.Caption;
end;

procedure TMainForm.shpSelectionMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   shpSelection.Visible := False;

end;

procedure TMainForm.sbCfgTempClick(Sender: TObject);
var s:string;
begin
  s := edCfgRoot.Text + edCfgTemp.Text;
  if SelectDirectory('Project temporary folder',edCfgRoot.Text ,  s, [sdNewUI, sdNewFolder,sdShowEdit]) then
    edCfgTemp.Text := ExtractRelativePath(edCfgRoot.text, s)+'\';
end;

procedure TMainForm.sbCfgImgClick(Sender: TObject);
var s:string;
begin
  s := edCfgRoot.Text + edCfgImg.Text;
  if SelectDirectory('Project images folder',edCfgRoot.Text ,s, [sdNewUI, sdNewFolder,sdShowEdit]) then
    edCfgImg.Text := ExtractRelativePath(edCfgRoot.text, s)+'\';
end;

procedure TMainForm.sbCfgResultClick(Sender: TObject);
var s:string;
begin
  s := edCfgRoot.Text + edCfgResult.Text;
  if SelectDirectory('Result folder',edCfgRoot.Text ,s, [sdNewUI, sdNewFolder,sdShowEdit]) then
    edCfgResult.Text := ExtractRelativePath(edCfgRoot.text, s)+'\';
end;

procedure TMainForm.sbOpenTextClick(Sender: TObject);
var ext:string;
begin
  ChDir(edCfgRoot.text);
  MainData.dlgOpenText.InitialDir := edCfgRoot.Text;
  MainData.dlgOpenText.FileName := edCfgRoot.Text + edCfgCardsFile.Text;
  ext := uppercase(ExtractFileExt(MainData.dlgOpenText.FileName));
  if MainData.dlgOpenText.Execute then
  begin
    if MainData.dlgOpenText.Encodings[MainData.dlgOpenText.EncodingIndex]='default' then
    begin
      if  UpperCase(ExtractFileExt(MainData.dlgOpenText.FileName))='.TXT' then
        lblEncoding.Caption := 'ANSI'
      else
        lblEncoding.Caption := 'UTF-8'

    end
    else
      lblEncoding.Caption := MainData.dlgOpenText.Encodings[MainData.dlgOpenText.EncodingIndex];


    edCfgCardsFile.Text := ExtractRelativePath(edCfgRoot.Text, MainData.dlgOpenText.FileName);
    ReadGrid(MainData.dlgOpenText.FileName);
  end;
end;

procedure TMainForm.sbOpenTemplateClick(Sender: TObject);
begin
  MainData.dlgOpenSVG.Title := 'Open SVG-template';
  ChDir(edCfgRoot.text);
  MainData.dlgOpenSVG.InitialDir := edCfgRoot.text;
  MainData.dlgOpenSVG.FileName := edCfgPropotype.Text;
  if MainData.dlgOpenSVG.Execute then
  begin
    edCfgPropotype.Text := ExtractRelativePath(edCfgRoot.Text, MainData.dlgOpenSVG.FileName);
    SVG.LoadFromFile(MainData.dlgOpenSVG.FileName);
    PrepareXML;
  end;
end;


procedure TMainForm.sbCfgTTFClick(Sender: TObject);
var s:string;
begin
  s := edCfgRoot.Text + edCfgTTF.Text;
  if SelectDirectory('Local fonts folder',edCfgRoot.Text ,s, [sdNewUI, sdNewFolder,sdShowEdit]) then
  begin
    edCfgTTF.Text := ExtractRelativePath(edCfgRoot.text, s)+'\';
    ResetFonts(edCfgRoot.Text + edCfgTTF.Text);
  end;
end;


procedure TMainForm.SpeedButton7Click(Sender: TObject);
begin
  ChDir(edCfgRoot.text);
  MainData.dlgOpenPicture.InitialDir := edCfgRoot.Text;
  MainData.dlgOpenPicture.FileName := edBackTemplate.Text;
  if MainData.dlgOpenPicture.Execute then
  begin
    edBackTemplate.Text := ExtractRelativePath(edCfgRoot.text, MainData.dlgOpenPicture.FileName);
  end;
end;

procedure TMainForm.SVGFrameSave1Click(Sender: TObject);
begin
  MainData.dlgSaveSVG.Title := 'Save SVG-template';
  chdir(edCfgRoot.Text);
  MainData.dlgSaveSVG.InitialDir := edCfgRoot.Text;
  MainData.dlgSaveSVG.FileName := edCfgPropotype.Text;
  if MainData.dlgSaveSVG.Execute then
  begin
    SVG.Node['svg'].Attribute['xmlns:dekart']:='http://127.0.0.1';
    edCfgPropotype.Text := ExtractRelativePath(edCfgRoot.Text, MainData.dlgSaveSVG.FileName);
    SVG.SaveToFile(MainData.dlgSaveSVG.FileName);
  end;
end;

procedure TMainForm.SVGFrametreeTemplateExit(Sender: TObject);
begin
  PaintBox.Visible := False;
end;

procedure TMainForm.SvgTreeFrame1treeTemplateChange(Sender: TObject;
  Node: TTreeNode);
begin
//  PrepareAtr(TXML_Nod(Node.Data));
  InspectorFrame.FocusedNode := Node;
  InspectorFrame.SVGNode := Node.Data;
  if CellEditForm.Visible then
    CellEditForm.PrepareMacro(SVGFrame.SVGNode);
  PaintBox.Visible := True;
  PaintBox.Invalidate;
end;

procedure TMainForm.ThreadRender(AImage: TImage; ASvgFile, ASvg,
  AResultFile: string; AZoom: Double; ADPI: integer; ID: TStringList);
var SkiaThread: TSkiaThread;
//    CairoThread: TCairoThread;
    s,fmt:string;
    grap :TPNGImage;
  b2:TBitmap;
  b3:TJpegDPI;
begin
  grap := Nil;

//  MainForm.StartAnalitics('Rendering');

  case cbEngine.ItemIndex of
   0:
     begin
     SkiaThread :=  TSkiaThread.Create(AImage, ASvgFile, ASvg, AResultFile, '', AZoom, ADPI, ID, seForce.Value );
     try

       repeat
{
         if MilliSecondOf(time) < 500 then
           Rendering1.Font.Color := clNavy
         else
           Rendering1.Font.Color := clHighlight;
}
//         Main.Rendering2.Font.Color := Main.Rendering1.Font.Color;
//         Main.Rendering3.Font.Color := Main.Rendering1.Font.Color;
         Application.ProcessMessages;

//         if Main.StopFlag then
//           SkiaThread.Terminate;
      if StopFlag then
        TerminateProcess(SkiaThread.Handle, 0);


       until WaitForSingleObject(SkiaThread.Handle, 100) <> WAIT_TIMEOUT
     finally
//       StartAnalitics('Rendering+');
//       SetAnalitics('Rendering+', SkiaThread.RenderTime);
       SkiaThread.Free;
//       Main.StopAnalitics('Rendering');
//       ShowAnalitics;
     end;
     end;
   1:
       if AImage<> nil then
       try
         grap := TPNGImage.Create;
         if AResultFile='' then
           writeln('Rendering: Card[', sgText.Row, ']' )
         else
           writeln('Rendering: ',AResultFile);
         With TFileStream.Create(edCfgRoot.Text+ edCfgTemp.Text+ 'temp.svg', fmCreate	) do
         try
           Write(ASVG[1],length(ASVG));
         finally
           free
          end;



         s:= ' --background #FFF --resources-dir "'+ExcludeTrailingPathDelimiter(edCfgRoot.Text) +'"  ';

         if not chbSaveTemp.Checked then
            s := s + ' --quiet ';

         if edCfgTTF.Text<>'' then
             s:= s + ' --use-fonts-dir "'+ExcludeTrailingPathDelimiter(edCfgRoot.Text + edCfgTTF.text) +'"';


         WinExecAndWait32('"'+ExtractFilePath(ParamStr(0))+'resvg.exe" "'+edCfgRoot.Text + edCfgTemp.Text + 'temp.svg" "'+edCfgRoot.Text +edCfgTemp.Text+'temp.png"'+s,0);
         DeleteFile(edCfgRoot.Text + edCfgTemp.Text+'temp.svg');

         grap.LoadFromFile(edCfgRoot.Text +edCfgTemp.Text+'temp.png');

         AImage.Picture.Bitmap.Width := 1;
         AImage.Picture.Bitmap.Height := 1;
         AImage.Picture.Bitmap.Assign(grap);

         DeleteFile(edCfgRoot.Text +edCfgTemp.Text+'temp.png');

         fmt := LowerCase(StringReplace(ExtractFileExt(AResultFile),'.','',[]));

         if fmt='jpg' then
         begin
           b3:=TJpegDPI.create;
           b2:=TBitmap.Create;
           try
             b2.Assign(grap);
             b3.CompressionQuality := seForce.Value;
             b3.Assign(b2);
             b3.DPI := ADPI;
             b3.SaveToFile(AResultFile);
           finally
             b2.Free;
             b3.Free;
           end;
         end;

         if fmt='png' then
         with grap do
         begin
           PixelInformation.PPUnitX := Round(ADPI / 0.0254);
           PixelInformation.PPUnitY := Round(ADPI / 0.0254);
           PixelInformation.UnitType := utMeter;
            SaveToFile(AResultFile);
         end;

       finally
         grap.Free;
//         StopAnalitics('Rendering');
//         ShowAnalitics;
       end
       else
       begin
         SkiaThread :=  TSkiaThread.Create(AImage, ASvgFile, ASvg, AResultFile, '', AZoom, ADPI, ID, seForce.Value );
         try

           repeat

             if MilliSecondOf(time) < 500 then
               Rendering1.Font.Color := clNavy
             else
               Rendering1.Font.Color := clHighlight;

//             Main.Rendering2.Font.Color := Main.Rendering1.Font.Color;
//             Main.Rendering3.Font.Color := Main.Rendering1.Font.Color;
             Application.ProcessMessages;

             if MainForm.StopFlag then
               SkiaThread.Terminate;
           until WaitForSingleObject(SkiaThread.Handle, 100) <> WAIT_TIMEOUT;

         finally
//           StartAnalitics('Rendering+');
//           SetAnalitics('Rendering+', SkiaThread.RenderTime);
           SkiaThread.Free;
//         StopAnalitics('Rendering');
//         ShowAnalitics;
         end;
       end;
{
   2:
     try
       CairoThread :=  TCairoThread.Create(AImage, ASvgFile, ASvg, AResultFile, edRenderOptions.text, AZoom, ADPI, ID, seForce.Value );

       repeat

         if MilliSecondOf(time) < 500 then
           Main.Rendering1.Font.Color := clNavy
         else
           Main.Rendering1.Font.Color := clHighlight;

         Main.Rendering2.Font.Color := Main.Rendering1.Font.Color;
         Main.Rendering3.Font.Color := Main.Rendering1.Font.Color;
         Timer1Timer(nil);
         Application.ProcessMessages;

         if Main.StopFlag then
           CairoThread.Terminate;
       until WaitForSingleObject(CairoThread.Handle, 100) <> WAIT_TIMEOUT
     finally
//       Main.StartAnalitics('Rendering+');
//       Main.SetAnalitics('Rendering+', CairoThread.RenderTime);
       CairoThread.Free;
       Main.StopAnalitics('Rendering');
       ShowAnalitics;
     end;
}
  end;

end;

procedure TMainForm.tmrRenderTimer(Sender: TObject);
begin
  Rendering1.Caption:='Rendering: '+FormatDateTime('n:ss', now-FStartRender);
  Rendering2.Caption := Rendering1.Caption;
  Rendering3.Caption := Rendering1.Caption;
end;

procedure TMainForm.tbPreviewToScreenClick(Sender: TObject);
begin
  ZoomPreview := scrlPreview1.Height / imgRender.Picture.Height;
  if imgRender.Picture.Width*ZoomPreview> scrlPreview1.Width then
  ZoomPreview := scrlPreview1.Width / imgRender.Picture.Width;

  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);
end;

procedure TMainForm.tbAutoWidthClick(Sender: TObject);
var i,j:Integer;
begin
  for i:= 0 to sgText.ColCount-1 do
  begin
    sgText.ColWidths[i] := 40;
    for j:=0 to sgText.RowCount-1 do
    begin
      if sgText.ColWidths[i] < sgText.Canvas.TextWidth(sgText.cells[i,j])+10 then
        sgText.ColWidths[i] := sgText.Canvas.TextWidth(sgText.cells[i,j])+10;
      if sgText.ColWidths[i] > 600 then
        sgText.ColWidths[i] := 600;
    end;
  end;
end;

procedure TMainForm.tbCellEditClick(Sender: TObject);
begin
  CellEditForm.Grid := sgText;
  CellEditForm.PrepareMacro(SVGFrame.SVGNode);
  CellEditForm.Text := sgText.Cells[sgText.Col,sgText.Row];
  CellEditForm.Caption := 'Cell['+IntToStr(sgText.Col)+':'+ IntToStr(sgText.Row)+'] <'
    + ExtractFileName(edCfgCardsFile.Text) +'>';
  CellEditForm.aPreview.OnExecute := aShowExecute;
  CellEditForm.Show;
end;

procedure TMainForm.tbOpenProjectClick(Sender: TObject);
begin
{$I-}
  ChDir(edCfgRoot.Text);
{$I+}
  MainData.dlgOpenXML.InitialDir := edCfgRoot.Text;
  if MainData.dlgOpenXML.Execute then
  begin
    Config.LoadFromFile(MainData.dlgOpenXML.FileName);
    with Config.Node['CONFIG'] do
    begin
      edCfgPropotype.Text := Attribute['Propotype'] ;
      edCfgCardsFile.Text := Attribute['CardsFile'] ;
      edCfgRoot.Text := ExtractFilePath(MainData.dlgOpenXML.FileName);
      edCfgTemp.Text := Attribute['Temp'];
      edCfgImg.Text := Attribute['Img'] ;
      edCfgResult.Text := Attribute['Result'];
      edCfgClipart.Text := Attribute['Clipart'];
      edCfgTTF.Text := Attribute['LocalFonts'];
      ResetFonts(edCfgRoot.Text + edCfgTTF.Text);

      seCountX.Value := StrToIntDef(Attribute['SizeX'],1);
      seCountY.Value := StrToIntDef(Attribute['SizeY'],1);

      edBackTemplate.Text := Attribute['BackTemplate'];
      edBleed.Text := Attribute['Bleed'];
      edOutline.Text := Attribute['Outline'];
      if Attribute['FileSfx'] <> '' then
      cbFileSfx.Text := Attribute['FileSfx'];
      cbFileName.Text := Attribute['FileName'];
      cbCount.Text := Attribute['Count'];
      edPageLimit.Text := Attribute['PageLimit'];


      cbCount.Text := Attribute['CntColumn'];
      cbPaper.ItemIndex := StrToIntDef(Attribute['Paper'],0);
      cbDPI.Text :=Attribute['DPI'];


      if cbDPI.Text='' then cbDPI.Text := '300';
//      cbEngine.ItemIndex := StrToIntDef(Attribute['Engine'],0);
      lblEncoding.Caption := Attribute['encoding'];

    end;
    if lblEncoding.Caption = 'UTF8' then
        lblEncoding.Caption := 'UTF-8';

    if lblEncoding.Caption = '' then
    begin
      if UpperCase(ExtractFileExt(edCfgCardsFile.Text))='.TSV' then
        lblEncoding.Caption := 'UTF-8'
      else
        lblEncoding.Caption := 'ANSI';
    end;


    {$I-}
    ChDir(edCfgRoot.Text);
    {$I+}

    MainData.dlgOpenSVG.FileName := edCfgPropotype.Text;
    fProtoFile:=MainData.dlgOpenSVG.FileName;
//    sePrototype.Lines.LoadFromFile(dlgOpenSVG.FileName);
//    sePrototype.Lines.text := Utf8ToAnsiEx(sePrototype.Lines.text,CP_ACP);
    SVG.LoadFromFile(fProtoFile);
    PrepareXML;

    chbLOCK.Checked := True;

    MainData.dlgOpenText.FileName := edCfgCardsFile.Text;

    ReadGrid(edCfgCardsFile.Text);

    btnAll.Click;

    if FileExists(edCfgRoot.Text + edCfgClipart.Text) then
    begin
      Clipart.LoadFromFile(edCfgRoot.Text + edCfgClipart.Text);
      PrepareClipart;
    end;

    cbPaperChange(Sender);
    seCountXChange(Sender);

    ResetFonts(edCfgRoot.Text + edCfgTTF.Text);

    imgPreview.Picture.Bitmap.Width := Zero(seWidth);
    imgPreview.Picture.Bitmap.Height := Zero(seHeight);
    FSel.Top:=0;
    FSel.Left:=0;
    FSel.Width:=imgPreview.Picture.Bitmap.Width;
    FSel.Height:=imgPreview.Picture.Bitmap.Height;
    cbZoomChange(nil);

    aShow.Execute

  end;


end;

procedure TMainForm.tbPreview05Click(Sender: TObject);
begin
  if ZoomPreview>1/16 then
    ZoomPreview := ZoomPreview/2;
  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);

end;

procedure TMainForm.tbPreview2xClick(Sender: TObject);
begin
  if ZoomPreview<16 then
    ZoomPreview := ZoomPreview *2;
  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);
end;

procedure TMainForm.tbPreviewMMClick(Sender: TObject);
begin
  ZoomPreview := PixelsPerInch / StrToIntDef(cbDPI.Text,300);
  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);
end;

procedure TMainForm.tbPreviewOpenClick(Sender: TObject);
begin
  if MainData.dlgOpenPicture.Execute then
  begin
    ZoomPreview := 1;
    fBufPreview := False;
    tbPreviewRefresh.Click;
  end;
end;

procedure TMainForm.tbPreviewRefreshClick(Sender: TObject);
var s:string;
begin


  s := UpperCase(ExtractFileExt(MainData.dlgOpenPicture.FileName));
  if (s='.SVG')or fBufPreview then
  try
    ShowRendering(True);;
//    Rendering2.Visible := True;
//    Rendering3.Visible := True;
    ForceDirectories(edCfgRoot.text + edCfgTemp.Text);
    if not fBufPreview then
    begin
      FBufXml.LoadFromFile(MainData.dlgOpenPicture.FileName,  TEncoding.UTF8);

    end;


    ThreadRender(imgRender, edCfgRoot.text +'cliptemp.svg', FBufXml.Text, '', ZoomPreview, 300);
    imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
    imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);

    exit;
  finally
     ShowRendering(False);
//     Rendering2.Visible := false;
//     Rendering3.Visible := false;

  end;
  imgRender.Picture.LoadFromFile(MainData.dlgOpenPicture.FileName);
  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);

{
  if s='.PNG' then
    grap := TPNGObject.Create
  else
  if (s='.JPG') or (s='.JPEG') then
    grap := TJPEGImage.Create
  else
  if s='.BMP' then
    grap := TBitmap.Create
  else
    Exit;

  grap.LoadFromFile(MainData.dlgOpenPicture.FileName);
  imgRender.Picture.Bitmap.Assign(grap);
  grap.Free;
 }
end;

procedure TMainForm.tbPreviewSaveClick(Sender: TObject);
var ext:string;
    Rst:TGraphic;
begin
 ext:=UpperCase(ExtractFileExt(MainData.dlgOpenPicture.FileName));
 rst := nil;

 if not fBufPreview and (MainData.dlgOpenPicture.FileName <> '') then
   MainData.dlgSavePicture.FileName := MainData.dlgOpenPicture.FileName
 else
   MainData.dlgSavePicture.FileName :=  ResultName(cbFileName.Text, sgText.RowCount-1, sgText.Row, 0)+'.PNG';

 if fBufPreview or (ext = '.SVG') then
   MainData.dlgSavePicture.Filter := 'Portable Network Graphics (*.png)|*.png|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Scalable Vector Graphics(*.SVG)|*.SVG'
 else
   MainData.dlgSavePicture.Filter := 'Portable Network Graphics (*.png)|*.png|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg';

 if MainData.dlgSavePicture.Execute then
 begin
   case MainData.dlgSavePicture.FilterIndex of
     1: ext := '.PNG';
     2: ext := '.JPG';
     3: ext := '.JPEG';
     4: ext := '.SVG';
     else ext := ExtractFileExt(MainData.dlgSavePicture.FileName)
   end;

   MainData.dlgSavePicture.FileName :=  ChangeFileExt(MainData.dlgSavePicture.FileName, ext);
   ext := UpperCase(ext);


  if ext='.SVG' then
    FBufXml.SaveToFile(MainData.dlgSavePicture.FileName,  TEncoding.UTF8)
  else
  try
    if ext='.PNG' then
      Rst := TPngImage.create
    else
    if (ext='.JPG')or(ext='.JPEG') then
      Rst := TJpegDPI.create
    else
      Rst := TBitmap.create;

    Rst.assign(imgRender.Picture.Bitmap);

    if ext='.PNG' then
    begin
      TPngImage(Rst).PixelInformation.PPUnitX := Round(StrToIntDef(cbDPI.Text,300) / 0.0254);
      TPngImage(Rst).PixelInformation.PPUnitY := Round(StrToIntDef(cbDPI.Text,300) / 0.0254);
      TPngImage(Rst).PixelInformation.UnitType := utMeter;
    end
    else
    if (ext='.JPG')or(ext='.JPEG') then
      TJpegDPI(Rst).DPI := StrToIntDef(cbDPI.Text,300);

    Rst.SaveToFile(MainData.dlgSavePicture.FileName);

  finally
    Rst.free;
  end;

  end;
end;

procedure TMainForm.tbRreview100Click(Sender: TObject);
begin
  ZoomPreview := 1;
  imgRender.Width := Round(imgRender.Picture.Width*ZoomPreview);
  imgRender.Height := Round(imgRender.Picture.Height*ZoomPreview);
end;

procedure TMainForm.tbSaveProjectClick(Sender: TObject);
begin
  MainData.dlgSaveXML.InitialDir := edCfgRoot.Text;
  MainData.dlgSaveXML.FileName := ExtractFileName(MainData.dlgOpenXML.FileName);
  if MainData.dlgSaveXML.Execute then
  begin
    Config.xml:='';
    with Config.Add('CONFIG') do
    begin
      Attribute['Propotype'] := edCfgPropotype.Text;
      Attribute['CardsFile'] := edCfgCardsFile.Text;
      Attribute['encoding'] := lblEncoding.Caption;

      if (edCfgRoot.Text = '') or (ExtractFilePath(MainData.dlgSaveXML.FileName) = edCfgRoot.Text) then
        Attribute['Root'] := ''
      else
        Attribute['Root'] := edCfgRoot.Text;
      Attribute['Temp'] := edCfgTemp.Text;
      Attribute['Img'] := edCfgImg.Text;
      Attribute['Result'] := edCfgResult.Text;
      Attribute['Clipart'] := edCfgClipart.Text;
      Attribute['SizeX'] := IntToStr(seCountX.Value);
      Attribute['SizeY'] := IntToStr(seCountY.Value) ;
//      Attribute['RenderOptions'] := edRenderOptions.Text;
      Attribute['CntColumn'] := cbCount.Text;
      Attribute['Paper'] := IntToStr(cbPaper.ItemIndex);
      Attribute['DPI'] := cbDPI.Text;

      Attribute['BackTemplate'] := edBackTemplate.Text;
      Attribute['Bleed'] := edBleed.Text;
      Attribute['Outline'] := edOutline.Text;
      Attribute['FileSfx'] := cbFileSfx.Text;
      Attribute['FileName'] := cbFileName.Text;
      Attribute['Count'] := cbCount.Text;
      Attribute['PageLimit'] := edPageLimit.Text;
      Attribute['LocalFonts'] := edCfgTTF.Text;
      Attribute['Engine'] :=  IntToStr(cbEngine.ItemIndex);

    end;

    Config.SaveToFile(MainData.dlgSaveXML.FileName);

    if MainData.dlgSaveXML.FilterIndex=1 then
    begin
      if (sgText.ColCount>2)or(sgText.RowCount>2)or(sgText.Cells[1,1]<>'') then
        SaveTable(edCfgRoot.Text+edCfgCardsFile.Text);

      SVG.Node['svg'].Attribute['xmlns:dekart']:='http://127.0.0.1';
      if SVG.Node['svg'].Nodes.Count>0 then
        SVG.SaveToFile(edCfgRoot.Text+edCfgPropotype.text);

      Clipart.Node['svg'].Attribute['xmlns:dekart']:='http://127.0.0.1';
      if (Clipart.Node['svg'].Nodes.Count>0) and (edCfgClipart.text<>'') then
        Clipart.SaveToFile(edCfgRoot.Text+edCfgClipart.text);
    end;
  end;
end;

procedure TMainForm.DrawSheet;
var k:double;
   S0, S1, S2:TPoint;
   R1, R2: TRect;
   c:Tcolor;
   i,j, ou:integer;
   s:string;
begin
  if StrToIntDef(edOutline.Text,0)>StrToIntDef(edBleed.Text,0) then
    ou:= StrToIntDef(edOutline.Text,0)- StrToIntDef(edBleed.Text,0)
  else
    ou:= 0;

  S1.x := (seWidth.Value * seScale1.Value div seScale2.Value + 2 * StrToIntDef(edBleed.text,0))*seCountX.Value + 2 * ou;
  S1.y := (seHeight.Value * seScale1.Value div seScale2.Value + 2 * StrToIntDef(edBleed.text,0))*seCountY.Value + 2 * ou;

//  S1.x := (seWidth.Value * seScale1.Value div seScale2.Value + 2 * StrToIntDef(edBleed.text,0))*seCountX.Value + 2 * StrToIntDef(edOutline.Text,0);
//  S1.y := (seHeight.Value * seScale1.Value div seScale2.Value + 2 * StrToIntDef(edBleed.text,0))*seCountY.Value + 2 * StrToIntDef(edOutline.Text,0);
  if (PageSize.X=0) or (PageSize.Y=0) then
  begin
    S2.x := S1.x;
    S2.y := S1.y;
  end
  else
  begin
    S2.x := PageSize.x;
    S2.y := PageSize.y;
  end;

  s0.X := Max(s1.x, s2.X);
  s0.y := Max(s1.y, s2.y);

  k :=  imgSheet.Height / s0.y;

//  kf:= s0.X / s0.y;
  r1.Left :=0;
  r2.Left :=0;
  r1.Top :=0;
  r2.Top :=0;

  c:=clBlack;
  if s1.X <= s2.X then
    r1.Left := (s2.X - s1.X) div 2
  else begin
    r2.Left := (s1.X - s2.X) div 2;
    if (PageSize.X<>0) and (PageSize.Y<>0) then
      c:=clRed;
  end;

  if s1.y <= s2.y then
    r1.Top :=(s2.y - s1.y) div 2
  else begin
    r2.Top := (s1.y - s2.y) div 2;
    if (PageSize.X<>0) and (PageSize.Y<>0) then
      c:=clRed;
  end;

  r1.Right := r1.Left + s1.X;
  r1.Bottom := r1.Top + s1.Y;

  r2.Right := r2.Left + s2.X;
  r2.Bottom := r2.Top + s2.Y;

  imgSheet.Picture.Bitmap.Width := trunc(s0.X*k);
  imgSheet.Picture.Bitmap.Height := imgSheet.Height;

  imgSheet.Width := imgSheet.Picture.Bitmap.Width;
  imgSheet.Height := imgSheet.Picture.Bitmap.Height;
  with imgSheet.Picture.Bitmap.Canvas do
  begin
    Brush.style:=bsSolid;
    Brush.Style := bsSolid;
    Brush.Color := clBtnFace;
    Pen.Color := clBtnFace;
    Rectangle(0,0,imgSheet.Width, imgSheet.Height);
    Brush.Style := bsFDiagonal;
    Brush.Color := clSilver;
    Rectangle(0,0,imgSheet.Width, imgSheet.Height);
    Brush.Style := bsSolid;

    Pen.Width := 1;
    Brush.Color := clWhite;
    Pen.Color := clBlack;
    Rectangle(trunc(r2.Left *k) , trunc(r2.Top *k),trunc(r2.Right *k),trunc(r2.Bottom *k));

    Brush.Style := bsClear;
    Pen.Color := c;
    if StrToIntDef(edOutline.Text,0)<> 0 then
      Rectangle(trunc(r1.Left *k) , trunc(r1.Top *k),trunc(r1.Right *k),trunc(r1.Bottom *k));

//    Brush.Color := clSilver;

    r2.Left:= R1.Left + StrToIntDef(edBleed.text,0)+ ou;
    r2.Top:= R1.Top + StrToIntDef(edBleed.text,0)+ ou;
    r2.Right := r2.Left + seWidth.Value * seScale1.Value div seScale2.Value;
    r2.Bottom := r2.Top + seHeight.Value * seScale1.Value div seScale2.Value;

    for i:=0 to seCountX.Value-1 do
      for j:=0 to seCountY.Value-1 do
      begin
         if chbMirror.Checked then
           s:= IntToStr(seCountX.Value - i)+':'+IntToStr(j+1)
         else
           s:= IntToStr(i+1)+':'+IntToStr(j+1);
         TextOut(
           trunc((r2.Left    + i * (seWidth.Value* seScale1.Value div seScale2.Value + 2*StrToIntDef(edBleed.text,0))) *k),
           trunc((r2.Top     + j * (seHeight.Value* seScale1.Value div seScale2.Value+ 2*StrToIntDef(edBleed.text,0))) *k),
           s);

         Rectangle(
           trunc((r2.Left    + i * (seWidth.Value* seScale1.Value div seScale2.Value + 2*StrToIntDef(edBleed.text,0))) *k),
           trunc((r2.Top     + j * (seHeight.Value* seScale1.Value div seScale2.Value+ 2*StrToIntDef(edBleed.text,0))) *k),
           trunc((r2.Right   + i * (seWidth.Value* seScale1.Value div seScale2.Value + 2*StrToIntDef(edBleed.text,0))) *k),
           trunc((r2.Bottom  + j * (seHeight.Value* seScale1.Value div seScale2.Value+ 2*StrToIntDef(edBleed.text,0))) *k))
       end;


  end;
end;
procedure TJpegDPI.SaveToStream(Stream: TStream);
var b:byte;
   w:word;
begin
  inherited SaveToStream(Stream);
  b:=1;
  w:=swap(dpi);
  Stream.Seek(13, soFromBeginning);
  Stream.Write(b,1);
  Stream.Write(w,2);
  Stream.Write(w,2);
end;

end.
