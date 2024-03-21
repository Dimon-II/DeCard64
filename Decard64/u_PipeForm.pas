unit u_PipeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ExtCtrls, Vcl.StdCtrls, system.types;

type
  TPipeForm = class(TForm)
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    Timer1: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    lblColor: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    dc: HDC;
    oCanvas: TCanvas;
    { Private declarations }
    procedure Track;
  public
    { Public declarations }
    AColor:TColor;
  end;

var
  PipeForm: TPipeForm;

implementation

{$R *.dfm}

procedure TPipeForm.Action1Execute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TPipeForm.Action2Execute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPipeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  ShowCursor(True);
end;

function GetWineAvail: boolean;
var H: cardinal;
begin
 Result := False;
 H := LoadLibrary('ntdll.dll');
 if H > 0 then
 begin
   Result := Assigned(GetProcAddress(H, 'wine_get_version'));
   FreeLibrary(H);
 end;
end;

procedure TPipeForm.FormCreate(Sender: TObject);
var
  ap: array [1..4] of TPoint;
  r: hRGN;
begin
  try
//    SetWindowRgn (Handle, r, TRUE);
  finally
    DeleteObject (r);
  end;
  oCanvas:=TCanvas.Create;
end;

procedure TPipeForm.FormDestroy(Sender: TObject);
begin
  oCanvas.free;
end;

procedure TPipeForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_LEFT: SetCursorPos(Mouse.CursorPos.x-1, Mouse.CursorPos.y);
    VK_RIGHT: SetCursorPos(Mouse.CursorPos.x+1, Mouse.CursorPos.y);
    VK_UP: SetCursorPos(Mouse.CursorPos.x, Mouse.CursorPos.y-1);
    VK_DOWN: SetCursorPos(Mouse.CursorPos.x, Mouse.CursorPos.y+1);
  end;
end;

procedure TPipeForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Mouse.Capture := 0;
  if Button = mbLeft then
    ModalResult := mrOk
  else
    ModalResult := mrCancel;
end;

procedure TPipeForm.FormMouseLeave(Sender: TObject);
begin
  Track;
end;

procedure TPipeForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Track;
end;

procedure TPipeForm.FormPaint(Sender: TObject);
function HexColor(Color:TColor):string;
var
  C: Longint;
  r, g, b: Byte;
begin
    C := ColorToRGB(Color);
    r := C;
    g := C shr 8;
    b := C shr 16;
    Result := IntToHex(r,2)+IntToHex(g ,2)+ IntToHex(b ,2);
end;


begin

  with Canvas do
  begin
    Acolor := Color;
    pen.Color := rgb(0,0,0);
    pen.Width:=1;
    pen.Style := psSolid;
    Brush.Style := bsSolid;
    Brush.Color := Acolor;
    Polygon([Point(0, 0),Point(width-1, 0),Point(width-1,height-1),Point (0, height-1)]);
    Brush.Color := rgb(255,255,255);
    Polygon([Point(0, 0),Point(28, 29),Point(13,26),Point (4, 32)]);
  end;
  LblColor.Caption := HexColor(Acolor) + ': L-Click / Enter';

end;

procedure TPipeForm.FormShow(Sender: TObject);
begin
{
  if GetWineAvail then
    DC := GetWindowDC(Application.MainForm.Handle)
  else
}
    DC := GetWindowDC(0)
;
  ocanvas.Handle:=dc;

//  Mouse.Capture := Handle;
  Timer1.Enabled := true;
    ShowCursor(False);
//  Cursor := crCross;
end;

procedure TPipeForm.Timer1Timer(Sender: TObject);
begin
 if (Left <> Mouse.CursorPos.X) or (Top <> Mouse.CursorPos.Y) then
     Track;
end;

procedure TPipeForm.Track;
begin
  Timer1.Enabled := False;
  Application.ProcessMessages;
{
  Left := Mouse.CursorPos.X-8;
  Top := Mouse.CursorPos.Y-17;

  Color := ocanvas.Pixels[Mouse.CursorPos.X-9, Mouse.CursorPos.Y-18];
  Invalidate;
}
  Left := Mouse.CursorPos.X-1;
  Top := Mouse.CursorPos.Y-1;

  Color := ocanvas.Pixels[Mouse.CursorPos.X-2, Mouse.CursorPos.Y-2];
  Invalidate;

  Timer1.Enabled := True;

end;

end.
