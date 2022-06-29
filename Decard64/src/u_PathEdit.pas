unit u_PathEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.Grids, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Samples.Spin,
  Vcl.Menus, Vcl.ExtDlgs, SynEdit, SynEditHighlighter, SynHighlighterGeneral;

type
  TStringGrid = class(Vcl.Grids.TStringGrid);

  TfrmPathEdit = class(TForm)
    pnSVG: TGroupBox;
    splLeft: TSplitter;
    sgDots: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    pmPathEdit: TPopupMenu;
    ZloseZ1: TMenuItem;
    MoveTo1: TMenuItem;
    LineTo1: TMenuItem;
    Arc1: TMenuItem;
    Quadratic1: TMenuItem;
    Curve1: TMenuItem;
    Horizontal1: TMenuItem;
    Vertical1: TMenuItem;
    Curve2: TMenuItem;
    Quadratic2: TMenuItem;
    N1: TMenuItem;
    Delete1: TMenuItem;
    tbApply: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    Abs1: TMenuItem;
    Timer1: TTimer;
    ToolButton3: TToolButton;
    Splitter1: TSplitter;
    Panel1: TPanel;
    seZoom: TSpinEdit;
    seGrid: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    ToolButton10: TToolButton;
    UndoList: TListBox;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    SynGeneralSyn1: TSynGeneralSyn;
    mePATH: TSynEdit;
    chbCard: TCheckBox;
    Panel2: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    Panel3: TPanel;
    Draw: TPaintBox;
    shAng1: TShape;
    shDot2: TShape;
    shAng2: TShape;
    shDot1: TShape;
    sePrcY: TSpinEdit;
    sePrcX: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    N2: TMenuItem;
    procedure DrawPaint(Sender: TObject);
    procedure shDot1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure sgDotsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure mePATHChange(Sender: TObject);
    procedure seZoomChange(Sender: TObject);
    procedure sgDotsExit(Sender: TObject);
    procedure sgDotsDblClick(Sender: TObject);
    procedure sgDotsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure shDot2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Delete1Click(Sender: TObject);
    procedure ZloseZ1Click(Sender: TObject);
    procedure DrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbApplyClick(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure Abs1Click(Sender: TObject);
    procedure Ref1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure shAng1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure chbCardClick(Sender: TObject);
    procedure sgDotsKeyPress(Sender: TObject; var Key: Char);
    procedure btnApplyClick(Sender: TObject);
    procedure DrawStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure seGridChange(Sender: TObject);
    procedure DrawDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    zm:double;
    AltDraw:boolean;
    MouseStart, ZeroXY:TPoint;
    CardSize:TPoint;
    FrameSize:Integer;
    ResetZero:boolean;
    procedure ParsePath(APath:string);
    procedure PathAbs(Idx:integer);
    procedure PathRel(Idx:integer);
    procedure PathFlip(Idx:integer;HV:Boolean);
    procedure ResetCaption(ARow:integer);
    function CurrentPath:string;
    procedure SvgArcTo(Curr:TPoint; rx,ry:Integer; ax:double; fa, fs:boolean; x,y:integer; Canvas:TCanvas);
    procedure DeltaPolyBezierTo(const Points: array of TPoint);
    function StrToXY(s:string;Def:integer):double;
  end;

var
  frmPathEdit: TfrmPathEdit;

implementation

{$R *.dfm}
uses math;

type
  TSvgPoint=record
    X,Y:Double;
  end;
  PSvgPoint=^TSvgPoint;

function CtrlDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Control] and 128) <> 0);
end;

function AltDown : Boolean;
var
  State : TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Menu] and 128) <> 0);
end;

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


procedure TfrmPathEdit.DeltaPolyBezierTo(const Points: array of TPoint);
var p: array of TPoint;
  i:integer;
begin
   SetLength(p,length(Points));
    for i := 0 to length(Points)-1 do
    begin
      p[i].x := Points[i].x - ZeroXY.x;
      p[i].y := Points[i].y - ZeroXY.y;
    end;
    Draw.Canvas.PolyBezierTo(p);
end;


function TfrmPathEdit.StrToXY(s: string; Def:Integer): double;
begin
  if pos('%x',s)>0 then
    Result := Roundto(sePrcX.Value /100 * StrToFloatDef(copy(s,1,Length(s)-2),Def),-3)
  else
  if pos('%y',s)>0 then
    Result := Roundto(sePrcY.Value /100 * StrToFloatDef(copy(s,1,Length(s)-2),Def),-3)
  else
    Result := roundto(StrToFloatDef(s,Def),-4)
end;


procedure TfrmPathEdit.SvgArcTo(Curr:TPoint; rx,ry:Integer; ax:double; fa, fs:boolean; x,y:integer; Canvas:TCanvas);
var
  p:array[1..3]of TPoint;
  n_segs,I:integer;
  x0,y0,x1,y1,d,sq,sf,x2,y2,x3,y3,t:Extended;
  xc,yc,ang_0,ang_1,ang_arc,ang0,ang1,ang_demi:Extended;
  P1,P2,P3,r,_t0,_t1:TSvgPoint;
  ang,_sin,_cos:Extended;
begin
    r.X := abs(rx);
    r.y := abs(ry);
    ang:=ax*Pi/180;
    P1.X:=x;
    P1.y:=y;
    if (r.X = 0) or (r.Y = 0) then
    begin
        Exit;
    end;
    _sin:=sin(ang);
    _cos:=cos(ang);
    _t0.X := (_cos * (Curr.X - P1.X) + _sin * (Curr.Y - P1.Y)) * 0.5;
    _t0.Y := (_cos * (Curr.Y - P1.Y) - _sin * (Curr.X - P1.X)) * 0.5;
    d := Sqr(_t0.X/r.X) + Sqr(_t0.Y/r.Y);
    if d > 1.0 then
    begin
       r.x:=r.X*sqrt(d);
       r.y:=r.Y*sqrt(d);
    end;

    _t0.x := _cos / r.X;
    _t0.y := _cos / r.Y;
    _t1.x := _sin / r.X;
    _t1.y := _sin / r.Y;
    x0 :=  _t0.X * Curr.X + _t1.X * Curr.Y;
    y0 := -_t1.Y * Curr.X + _t0.Y * Curr.Y;
    x1 :=  _t0.X * P1.X  + _t1.X * P1.Y;
    y1 := -_t1.Y * P1.X  + _t0.Y * P1.Y;
    d := Sqr(x1 - x0) + Sqr(y1 - y0);
    if d > 0.0 then
        sq := 1.0 / d - 0.25
    else
        sq := -0.25;

    if sq < 0.0 then
        sq := 0.0;

    sf :=sqrt(sq);
    if fs = fa then
        sf := -sf;
    xc := 0.5 * (x0 + x1) - sf * (y1 - y0);
    yc := 0.5 * (y0 + y1) + sf * (x1 - x0);
    ang_0 := arctan2(y0 - yc, x0 - xc);
    ang_1 := arctan2(y1 - yc, x1 - xc);
    ang_arc := ang_1 - ang_0;

    if (ang_arc < 0.0) and fs then
        ang_arc :=ang_arc+ 2.0 * pi
    else if (ang_arc > 0.0) and not fs then
        ang_arc :=ang_arc- 2.0 * pi;
    n_segs := ceil(abs(ang_arc * 2.0 / (pi * 0.5 + 0.001)));

//   p[0] := Curr;
   for I:=0 to n_segs-1 do
    begin
        ang0 := ang_0 + i * ang_arc / n_segs;
        ang1 := ang_0 + (i + 1) * ang_arc / n_segs;
        ang_demi := 0.25 * (ang1 - ang0);
        t := 2.66666 * sin(ang_demi) * sin(ang_demi) / sin(ang_demi * 2.0);
        x1 := xc + cos(ang0) - t * sin(ang0);
        y1 := yc + sin(ang0) + t * cos(ang0);
        x2 := xc + cos(ang1);
        y2 := yc + sin(ang1);
        x3 := x2 + t * sin(ang1);
        y3 := y2 - t * cos(ang1);
        P1.X:= _cos * r.X * x1 + -_sin * r.Y * y1;
        P1.Y:= _sin * r.X * x1 +  _cos * r.Y * y1;
        P2.X:= _cos * r.X * x3 + -_sin * r.Y * y3;
        P2.Y:= _sin * r.X * x3 +  _cos * r.Y * y3;
        P3.X:= _cos * r.X * x2 + -_sin * r.Y * y2;
        P3.Y:= _sin * r.X * x2 +  _cos * r.Y * y2;
        p[1].X := Round(p1.x);
        p[1].y := Round(p1.y);
        p[2].X := Round(p2.x);
        p[2].y := Round(p2.y);
        p[3].X := Round(p3.x);
        p[3].y := Round(p3.y);

        DeltaPolyBezierTo(p);

  //      p[0] := p[3];
   end;
end;



procedure TfrmPathEdit.Abs1Click(Sender: TObject);
begin
  if UpperCase(sgDots.cells[1,sgDots.Row])=sgDots.cells[1,sgDots.Row] then
    PathRel(sgDots.Row)
  else
    PathAbs(sgDots.Row);
end;

procedure TfrmPathEdit.btnApplyClick(Sender: TObject);
begin
  tbApply.Click;
end;

procedure TfrmPathEdit.chbCardClick(Sender: TObject);
begin
  Draw.Invalidate;
end;

function TfrmPathEdit.CurrentPath: string;
var i, j: Integer;
begin
  Result := '';
  for i := 1 to sgDots.RowCount-1 do
    for j := 1 to 8 do
      if sgDots.Cells[j,i]<>'' then
        Result := Result + sgDots.Cells[j,i] + ' ';
  Result := Trim(Result);
end;

procedure TfrmPathEdit.Delete1Click(Sender: TObject);
var i, j, k:Integer;
begin
  sgDots.BeginUpdate;
  j := sgDots.Row;
  k := sgDots.TopRow;
  if sgDots.RowCount=2 then
    sgDots.Rows[1].CommaText:='1,M,0,0'
  else
    sgDots.DeleteRow(sgDots.Row);

  if j<sgDots.RowCount then
    sgDots.Row := j;
  for i := 1 to sgDots.RowCount-1 do
    sgDots.cells[0,i]:=IntToStr(i);
  if k<=j then
    sgDots.TopRow := k;

  sgDots.EndUpdate;
  Draw.Invalidate;

end;

procedure TfrmPathEdit.DrawDblClick(Sender: TObject);
begin
  ResetZero := True;
  Draw.Invalidate;
end;

procedure TfrmPathEdit.DrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j,l,d:Integer;
begin
  if (ssRight in Shift)  then
    Draw.BeginDrag(True)
  else
  if Button = mbLeft then
  begin
    sgDots.SetFocus;
    for i:= 1 to sgDots.RowCount-1 do
    begin
      d :=  Round(Sqrt(sqr(x-8 + ZeroXY.x  - zm * StrToXY(sgDots.Cells[11,i],0))  +sqr(y-8  + ZeroXY.y- zm * StrToXY(sgDots.Cells[12,i],0))));
      if (i=1) or (d<l) then
      begin
        l := d;
        j := i;
      end;
    end;
    sgDots.Row := j;
    Draw.Invalidate;
  end
end;

procedure TfrmPathEdit.DrawPaint(Sender: TObject);
var
  p:array of TPoint;
  i,j:Integer;
  p0, p1, pz, pq, mx, MinXY: tpoint;
  Rx, Ry: double;
begin

  mx:=point(0,0);
  MinXY:=point(0,0);
  AltDraw := AltDown;

 with Draw.Canvas do
 begin
   if seGrid.Value > 3 then
   begin

     Brush.Bitmap:=TBitmap.Create;
     Brush.Bitmap.Width :=seGrid.Value;
     Brush.Bitmap.Height :=seGrid.Value;
     Brush.Bitmap.Canvas.Brush.Color := clWhite;
     Brush.Bitmap.Canvas.Pen.color := clWhite;
     Brush.Bitmap.Canvas.Brush.Style := bsSolid;
     Brush.Bitmap.Canvas.Rectangle(0,0,seGrid.Value, seGrid.Value);
     p0.x := -ZeroXY.x mod seGrid.Value;
     p0.y := -ZeroXY.y mod seGrid.Value;

     p0.x:= (9 + 2*seGrid.Value + p0.x) mod seGrid.Value;
     p0.y:= (9 + 2*seGrid.Value + p0.y) mod seGrid.Value;

     Brush.Bitmap.Canvas.Pixels[p0.x,p0.y]:=$FF0000;

     Pen.Style := psClear;
     Rectangle(0,0, Self.Draw.Width, Self.Draw.Height);


     Brush.Bitmap.Free;



   end;

  Pen.Color := $80;
  Pen.Style := psDash;

  MoveTo(0, -ZeroXY.y);
  LineTo(self.Draw.width, -ZeroXY.y);
  MoveTo(-ZeroXY.x,0);
  LineTo(-ZeroXY.x, self.Draw.Height);

  SetLength(p,3);
  p0:=Point(0,0);
  if seZoom.Value=0 then
    zm := 1
  else
  if seZoom.Value>0 then
    zm := seZoom.Value
  else
    zm := -1 / seZoom.Value;
  MoveTo(-ZeroXY.x,-ZeroXY.y);

  if chbCard.Checked then
  begin
    Brush.Style := bsClear;
    RoundRect(-ZeroXY.x, -ZeroXY.y,  Round(zm * CardSize.x)-ZeroXY.x, Round(zm * CardSize.y)-ZeroXY.y, Round(zm * CardSize.x / 20), Round(zm * CardSize.x / 20));
    if FrameSize >0 then
      Rectangle(-ZeroXY.x + Round(zm * FrameSize), -ZeroXY.y + Round(zm * FrameSize), -ZeroXY.x +Round(zm*(CardSize.x - FrameSize)), -ZeroXY.y + Round(zm*(CardSize.y-FrameSize)));
    Brush.Style := bsSolid;
  end;

  Pen.Style := psSolid;

  for i := 1 to sgDots.RowCount-1 do
  begin
     sgDots.Cells[9,i] := FloatToStr(RoundTo(p0.x/zm,-3));
     sgDots.Cells[10,i] := FloatToStr(RoundTo(p0.y/zm,-3));

     if i=sgDots.Row then
     begin
       Pen.Color := $FF0000;
       Pen.Width := 3;
       shDot1.top :=  p0.Y - ZeroXY.y;
       shDot1.left :=  p0.X - ZeroXY.x;
     end
     else
     begin
       Pen.Color := $000000;
       Pen.Width := 1;
     end;

     if sgDots.Cells[1,i]='M' then
     begin
        p0.X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p0.Y := Round(zm*StrToXY(sgDots.Cells[3,i],0));
        pz:=p0;
        if i=sgDots.Row then
        begin
         Pen.Color := $ff;
         Brush.Style := bsClear;
         Pen.Width := 1;
         Pen.Style := psDot;
         LineTo(p0.x-ZeroXY.x,p0.y-ZeroXY.y);
         Pen.Style := psSolid;
         Brush.Style := bsSolid
        end
        else
          MoveTo(p0.X-ZeroXY.x,p0.Y-ZeroXY.y);
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='m' then
     begin
        p0.X := p0.X + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p0.Y := p0.Y + Round(zm*StrToXY(sgDots.Cells[3,i],0));
        pz:=p0;
        if i=sgDots.Row then
        begin
         Pen.Color := $ff;
         Brush.Style := bsClear;
         Pen.Width := 1;
         Pen.Style := psDot;
         LineTo(p0.x-ZeroXY.x,p0.y-ZeroXY.y);
         Pen.Style := psSolid;
         Brush.Style := bsSolid
        end
        else
          MoveTo(p0.X - ZeroXY.x ,p0.Y- ZeroXY.y);
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='L' then
     begin
        p1.X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p1.Y := Round(zm*StrToXY(sgDots.Cells[3,i],0));
        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p0:=p1;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='l' then
     begin
        p1.X := p0.x + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[3,i],0));
        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p0:=p1;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='H' then
     begin
        p1.X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p1.Y := p0.Y;
        LineTo(p1.X-ZeroXY.x, p1.Y-ZeroXY.y);
        p0:=p1;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='h' then
     begin
        p1.X := p0.x + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p1.Y := p0.Y;
        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p0:=p1;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='V' then
     begin
        p1.X := p0.X;
        p1.Y := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p0:=p1;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='v' then
     begin
        p1.X := p0.X;
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        LineTo(p1.X-ZeroXY.x, p1.Y-ZeroXY.y);
        p0:=p1;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='Z' then
     begin
        LineTo(pz.X-ZeroXY.x,pz.Y-ZeroXY.y);
        p0:=pz;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='z' then
     begin
        LineTo(pz.X-ZeroXY.x,pz.Y-ZeroXY.y);
        p0:=pz;
        p[1]:=p0;
     end;
     if sgDots.Cells[1,i]='C' then
     begin
        p[0].X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p[0].Y := Round(zm*StrToXY(sgDots.Cells[3,i],0));
        p[1].X := Round(zm*StrToXY(sgDots.Cells[4,i],0));
        p[1].Y := Round(zm*StrToXY(sgDots.Cells[5,i],0));

        p1.X := Round(zm*StrToXY(sgDots.Cells[6,i],0));
        p1.Y := Round(zm*StrToXY(sgDots.Cells[7,i],0));
//        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p[2] := p1;
        DeltaPolyBezierTo(p);
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='c' then
     begin
        p[0].X := p0.x + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p[0].Y := p0.y + Round(zm*StrToXY(sgDots.Cells[3,i],0));
        p[1].X := p0.x + Round(zm*StrToXY(sgDots.Cells[4,i],0));
        p[1].Y := p0.y + Round(zm*StrToXY(sgDots.Cells[5,i],0));

        p1.X := p0.x + Round(zm*StrToXY(sgDots.Cells[6,i],0));
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[7,i],0));
//        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p[2] := p1;
        DeltaPolyBezierTo(p);
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='S' then
     begin
        p[0].X := 2 * p0.x - p[1].X;
        p[0].Y := 2 * p0.y - p[1].Y;
        p[1].X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p[1].Y := Round(zm*StrToXY(sgDots.Cells[3,i],0));

        p1.X := Round(zm*StrToXY(sgDots.Cells[4,i],0));
        p1.Y := Round(zm*StrToXY(sgDots.Cells[5,i],0));
//        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p[2] := p1;
        DeltaPolyBezierTo(p);
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='s' then
     begin
        p[0].X := 2 * p0.x - p[1].X;
        p[0].Y := 2 * p0.y - p[1].Y;
        p[1].X := p0.x + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p[1].Y := p0.y + Round(zm*StrToXY(sgDots.Cells[3,i],0));

        p1.X := p0.x + Round(zm*StrToXY(sgDots.Cells[4,i],0));
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[5,i],0));
//        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        p[2] := p1;
        DeltaPolyBezierTo(p);
        p0:=p1;
     end;

     if sgDots.Cells[1,i]='Q' then
     begin
        pq.X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        pq.Y := Round(zm*StrToXY(sgDots.Cells[3,i],0));
        p1.X := Round(zm*StrToXY(sgDots.Cells[4,i],0));
        p1.Y := Round(zm*StrToXY(sgDots.Cells[5,i],0));

        p[0].X := round(p0.x + 2/3 *(pq.X - p0.x));
        p[0].Y := round(p0.y + 2/3 *(pq.y - p0.y));
        p[1].x := round(p1.x + 2/3 *(pq.X - p1.x));
        p[1].y := round(p1.y + 2/3 *(pq.y - p1.y));
        p[2] := p1;

        DeltaPolyBezierTo(p);
        p[0] := pq;
        p[1] := pq;
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='q' then
     begin
        pq.X := p0.x + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        pq.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[3,i],0));
        p1.X := p0.x + Round(zm*StrToXY(sgDots.Cells[4,i],0));
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[5,i],0));

        p[0].X := round(p0.x + 2/3 *(pq.X - p0.x));
        p[0].Y := round(p0.y + 2/3 *(pq.y - p0.y));
        p[1].x := round(p1.x + 2/3 *(pq.X - p1.x));
        p[1].y := round(p1.y + 2/3 *(pq.y - p1.y));
        p[2] := p1;

        DeltaPolyBezierTo(p);
        p[0] := pq;
        p[1] := pq;
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='T' then
     begin
        pq.X := 2 * p0.x - pq.X;
        pq.Y := 2 * p0.y - pq.Y;
        p1.X := Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p1.Y := Round(zm*StrToXY(sgDots.Cells[3,i],0));

        p[0].X := round(p0.x + 2/3 *(pq.X - p0.x));
        p[0].Y := round(p0.y + 2/3 *(pq.y - p0.y));
        p[1].x := round(p1.x + 2/3 *(pq.X - p1.x));
        p[1].y := round(p1.y + 2/3 *(pq.y - p1.y));
        p[2] := p1;

        DeltaPolyBezierTo(p);
        p[0] := pq;
        p[1] := pq;
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='t' then
     begin
        pq.X := 2 * p0.x - pq.X;
        pq.Y := 2 * p0.y - pq.Y;
        p1.X := p0.x + Round(zm*StrToXY(sgDots.Cells[2,i],0));
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[3,i],0));

        p[0].X := round(p0.x + 2/3 *(pq.X - p0.x));
        p[0].Y := round(p0.y + 2/3 *(pq.y - p0.y));
        p[1].x := round(p1.x + 2/3 *(pq.X - p1.x));
        p[1].y := round(p1.y + 2/3 *(pq.y - p1.y));
        p[2] := p1;

        DeltaPolyBezierTo(p);
        p[0] := pq;
        p[1] := pq;
        p0:=p1;
     end;

     if sgDots.Cells[1,i]='A' then
     begin
        p1.X := Round(zm*StrToXY(sgDots.Cells[7,i],0));
        p1.Y := Round(zm*StrToXY(sgDots.Cells[8,i],0));

        Rx:=zm*StrToXY(sgDots.Cells[2,i],0);
        Ry:=zm*StrToXY(sgDots.Cells[3,i],0);
 {
        if sqr(Rx) + sqr(Ry) < sqr(p0.x - p1.x)+sqr(p0.y - p1.y)  then
        begin
          Rx := sqrt(sqr(p0.x - p1.x)+sqr(p0.y - p1.y))/2;
          Ry:=Rx;
        end;
}
        if sgDots.Cells[5,i]='0' then
          Rx := -Rx;
        if sgDots.Cells[6,i]='0' then
          Ry := -Ry;

        p[0].x := Round(p0.X + Cos(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Rx);
        p[0].y := Round(p0.y + Sin(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Rx);
        p[1].x := Round(p0.X - Sin(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Ry);
        p[1].y := Round(p0.y - Cos(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Ry);

//        Pen.Style := psDot;
        SvgArcTo(p0,
           Round(zm*StrToXY(sgDots.Cells[2,i],0)),
           Round(zm*StrToXY(sgDots.Cells[3,i],0)),
           Round(StrToXY(sgDots.Cells[4,i],0)),
           (sgDots.Cells[5,i]='1'),
           (sgDots.Cells[6,i]='1'),
           p1.X, p1.Y, frmPathEdit.Draw.Canvas);
//        LineTo(p1.X-ZeroXY.x,p1.Y-ZeroXY.y);
        if i=sgDots.Row then
        begin
         Pen.Color := $444444;
         Pen.Width := 1;
         Pen.Style := psDot;
         MoveTo(p0.x - ZeroXY.x,p0.y- ZeroXY.y);
        SvgArcTo(p0,
           Round(zm*StrToXY(sgDots.Cells[2,i],0)),
           Round(zm*StrToXY(sgDots.Cells[3,i],0)),
           Round(StrToXY(sgDots.Cells[4,i],0)),
           (sgDots.Cells[5,i]='0'),
           (sgDots.Cells[6,i]='0'),
           p1.X, p1.Y, frmPathEdit.Draw.Canvas);

         Pen.Style := psSolid;
        end;




  //      Pen.Style := psSolid;
        p0:=p1;
     end;
     if sgDots.Cells[1,i]='a' then
     begin
        p1.X := p0.X + Round(zm*StrToXY(sgDots.Cells[7,i],0));
        p1.Y := p0.y + Round(zm*StrToXY(sgDots.Cells[8,i],0));

        Rx:=zm*StrToXY(sgDots.Cells[2,i],0);
        Ry:=zm*StrToXY(sgDots.Cells[3,i],0);
{
        if sqr(Rx) + sqr(Ry) < sqr(p0.x - p1.x)+sqr(p0.y - p1.y)  then
        begin
          Rx := sqrt(sqr(p0.x - p1.x)+sqr(p0.y - p1.y))/2;
          Ry:=Rx;
        end;
}
        if sgDots.Cells[5,i]='0' then
          Rx := -Rx;
        if sgDots.Cells[6,i]='0' then
          Ry := -Ry;

        p[0].x := Round(p0.X + Cos(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Rx);
        p[0].y := Round(p0.y + Sin(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Rx);
        p[1].x := Round(p0.X - Sin(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Ry);
        p[1].y := Round(p0.y - Cos(pi/180  * StrToXY(sgDots.Cells[4,i],0))*Ry);

        SvgArcTo(p0,
           Round(zm*StrToXY(sgDots.Cells[2,i],0)),
           Round(zm*StrToXY(sgDots.Cells[3,i],0)),
           Round(StrToXY(sgDots.Cells[4,i],0)),
           (sgDots.Cells[5,i]='1'),
           (sgDots.Cells[6,i]='1'),
           p1.X, p1.Y, frmPathEdit.Draw.Canvas);
        if i=sgDots.Row then
        begin
         Pen.Color := $444444;
         Pen.Width := 1;
         Pen.Style := psDot;
         MoveTo(p0.x- ZeroXY.x,p0.y- ZeroXY.y);

        SvgArcTo(p0,
           Round(zm*StrToXY(sgDots.Cells[2,i],0)),
           Round(zm*StrToXY(sgDots.Cells[3,i],0)),
           Round(StrToXY(sgDots.Cells[4,i],0)),
           (sgDots.Cells[5,i]='0'),
           (sgDots.Cells[6,i]='0'),
           p1.X, p1.Y, frmPathEdit.Draw.Canvas);

         Pen.Style := psSolid;
        end;

        p0:=p1;

     end;
     if (mx.x < p0.x) or (i=1) then mx.x := p0.x;
     if (mx.y < p0.y)  or (i=1) then mx.y := p0.y;

     if MinXY.x > p0.x then MinXY.x := p0.x;
     if MinXY.y > p0.y then MinXY.y := p0.y;



     if i=sgDots.Row then
     begin

       shAng1.left :=  p[0].x - ZeroXY.x;
       shAng1.top := p[0].y - ZeroXY.y;
       shAng2.left :=p[1].x - ZeroXY.x;
       shAng2.top := p[1].y - ZeroXY.y;
       shDot2.left := p0.X - ZeroXY.x;
       shDot2.top := p0.y - ZeroXY.y;

//       shDot1.Visible := Pos(sgDots.Cells[1,i],'AaLVHCSQTZmlvhcsqtz')>0;
       shAng1.Visible := Pos(sgDots.Cells[1,i],'CcAa')>0;
       shAng2.Visible := Pos(sgDots.Cells[1,i],'CSQcsqAa')>0;

       Pen.Color := $FF;
       Pen.Width:=1;
       MoveTo(shDot1.left, shDot1.Top);

       if Pos(sgDots.Cells[1,i],'CcTtSsQqAa')>0 then
         LineTo(p[0].x-ZeroXY.x ,p[0].y-ZeroXY.y);
       MoveTo(shDot1.left, shDot1.Top);
       if Pos(sgDots.Cells[1,i],'Aa')>0 then
         LineTo(p[1].x-ZeroXY.x ,p[1].y-ZeroXY.y);

       MoveTo(p[1].x-ZeroXY.x,p[1].y-ZeroXY.y);
       if Pos(sgDots.Cells[1,i],'CSQTcsqt')>0 then
         LineTo(p0.x-ZeroXY.x,p0.y-ZeroXY.y);
       MoveTo(p0.x-ZeroXY.x,p0.y-ZeroXY.y);

     end;
     sgDots.Cells[11,i] := FloatToStr(RoundTo(p0.x/zm,-3));
     sgDots.Cells[12,i] := FloatToStr(RoundTo(p0.y/zm,-3));

     if AltDraw then
     begin
       Pen.Color := $FF;
       Pen.Width := 1;
       Ellipse(p0.x-5-ZeroXY.x,p0.y-5-ZeroXY.y,p0.x+5-ZeroXY.x,p0.y+5-ZeroXY.y);
     end;

  end;
 end;



  if ResetZero then
  begin
    ResetZero:=False;
    ZeroXY.x :=Min(MinXY.x,0);
    ZeroXY.y :=Min(MinXY.y,0);
    Draw.Invalidate

  end;

end;


procedure TfrmPathEdit.seGridChange(Sender: TObject);
begin
  Draw.Invalidate;
end;

procedure TfrmPathEdit.seZoomChange(Sender: TObject);
begin
  Draw.Invalidate;
end;


procedure TfrmPathEdit.sgDotsDblClick(Sender: TObject);
begin
  sgDots.Options := sgDots.Options - [goRowSelect];
  sgDots.Options := sgDots.Options + [goEditing, goAlwaysShowEditor];
end;

procedure TfrmPathEdit.sgDotsExit(Sender: TObject);
begin
  sgDots.Options := sgDots.Options + [goRowSelect];
  sgDots.Options := sgDots.Options - [goEditing, goAlwaysShowEditor];
end;

procedure TfrmPathEdit.sgDotsKeyPress(Sender: TObject; var Key: Char);
begin
//
end;

procedure TfrmPathEdit.sgDotsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  s:string;
begin
  CanSelect := not Mouse.IsDragging;
  if NOT CanSelect then exit;


  ResetCaption(ARow);
  if not (goRowSelect in sgDots.Options) then
  begin
    if (sgDots.Cells[Acol,0]<>'') then
      sgDots.Options := sgDots.Options+[goEditing]
    else
      sgDots.Options := sgDots.Options-[goEditing]+[goRowSelect];

  end;

//  CanSelect := (sgDots.Cells[Acol,0]<>'') or (goRowSelect in sgDots.Options) ;
  Draw.Invalidate;

  s := CurrentPath;
  if (UndoList.Items.Count=0) or (UndoList.Items[UndoList.Items.Count-1]<>s)
  then
    UndoList.Items.Add(s);
end;

procedure TfrmPathEdit.sgDotsSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  Draw.Invalidate;
end;

procedure TfrmPathEdit.shAng1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  s:string;
begin
  s := CurrentPath;
  if (UndoList.Items.Count=0) or (UndoList.Items[UndoList.Items.Count-1]<>s)
  then
    UndoList.Items.Add(s);
end;

procedure TfrmPathEdit.shDot1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  pnt:TPoint;
  i,n:Integer;
  zm :double;
  p0, p1, pz, pq: tpoint;

begin
  sgDots.SetFocus;
  if seZoom.Value=0 then
    zm := 1
  else
  if seZoom.Value>0 then
    zm := seZoom.Value
  else
    zm := -1 / seZoom.Value;

  pnt := TControl(Source).ScreenToClient(TControl(Sender).ClientToScreen(Point(x,y)));
  if Source is TShape then
  begin
    if Pos('%', sgDots.Rows[sgDots.Row].text )>0 then exit;

    pnt.x := TShape(Source).Left+pnt.x-8 + ZeroXY.x ;
    pnt.y := TShape(Source).Top+pnt.y-8 + ZeroXY.y ;

    if CtrlDown then
    begin end
    else
    if AltDown then
    begin
      n:=-1;
      for i := 1 to sgDots.RowCount-1 do
        if (i<>sgDots.Row) then
        begin
          p1.x := Round(StrToXY(sgDots.Cells[11,i],0)*zm);
          p1.y := Round(StrToXY(sgDots.Cells[12,i],0)*zm);
          if (n=-1) then
          begin
            p0:=P1;
            n:=i;
          end;
          if sqr(p1.x - pnt.x)+sqr(p1.y - pnt.y)<sqr(p0.x - pnt.x)+sqr(p0.y - pnt.y)  then
            p0:=P1;
        end;
        if sqr(p0.x - pnt.x)+sqr(p0.y - pnt.y) <= Sqr(seGrid.Value) then
           pnt := p0;
      end
    else
    begin
      pnt.x := (pnt.x + seGrid.Value div 2) div seGrid.Value * seGrid.Value;
      pnt.y := (pnt.y + seGrid.Value div 2) div seGrid.Value * seGrid.Value;

    end;


    if (TShape(Source).Left <> pnt.x) or (TShape(Source).Top <> pnt.y) then
    begin
//      TShape(Source).Left := pnt.x;
//      TShape(Source).Top := pnt.y;

      if Pos(sgDots.Cells[1,sgDots.Row], 'mlvhcsqta')>0 then
      begin
        pnt.x := Round(pnt.x - StrToXY(sgDots.Cells[9,sgDots.Row],0)*zm);
        pnt.y := Round(pnt.y - StrToXY(sgDots.Cells[10,sgDots.Row],0)*zm);
      end;

      if Source=shDot2 then
      case sgDots.Cells[1,sgDots.Row][1] of
        'M','m','L','l','T','t':
        Begin
          sgDots.Cells[2,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[3,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
        'H','h':
        Begin
          sgDots.Cells[2,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
        End;
        'V','v':
        Begin
          sgDots.Cells[2,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
        'C','c':
        Begin
          sgDots.Cells[6,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[7,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
        'A','a':
        Begin
          sgDots.Cells[7,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[8,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
        'S','s','Q','q':
        Begin
          sgDots.Cells[4,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[5,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
      end;

      if Source=shAng2 then
      case sgDots.Cells[1,sgDots.Row][1] of
        'A','a':
        Begin
//          sgDots.Cells[3,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
        End;

        'C','c':
        Begin
          sgDots.Cells[4,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[5,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
        'S','s','Q','q':
        Begin
          sgDots.Cells[2,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[3,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
      end;

      if Source=shAng1 then
      case sgDots.Cells[1,sgDots.Row][1] of
        'C','c':
        Begin
          sgDots.Cells[2,sgDots.Row]:=FloatToStr(RoundTo(pnt.x/zm, -3));
          sgDots.Cells[3,sgDots.Row]:=FloatToStr(RoundTo(pnt.y/zm, -3));
        End;
      end;

      Draw.Invalidate;
      sgDots.Invalidate;
    end;
  end
  else
  if Source is TPaintBox then
  begin
    ZeroXY.x := ZeroXY.x + MouseStart.x - Mouse.CursorPos.x;
    ZeroXY.y := ZeroXY.y + MouseStart.y - Mouse.CursorPos.y;
    MouseStart := Mouse.CursorPos;
    Draw.Invalidate
  end;

  Accept := True;
end;




procedure TfrmPathEdit.shDot2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p:TPoint;
begin
  p := TControl(Sender).ClientToScreen(Point(x,y));

  if ssRight in Shift then pmPathEdit.Popup(p.x,p.y);

end;

procedure TfrmPathEdit.Timer1Timer(Sender: TObject);
begin


  if AltDraw <> AltDown then
    Draw.Invalidate;

end;

procedure TfrmPathEdit.ToolButton11Click(Sender: TObject);
var i:Integer;
begin
  ToolButton1Click(nil);
  for i:= 1 to sgDots.RowCount-1 do
    PathFlip(i,True);
  ResetCaption(sgDots.Row);
  ResetZero:=True;
  Draw.Invalidate;
  UndoList.Items.Add(CurrentPath);

end;

procedure TfrmPathEdit.ToolButton12Click(Sender: TObject);
var i:Integer;
begin
  ToolButton1Click(nil);
  for i:= 1 to sgDots.RowCount-1 do
    PathFlip(i,False);
  ResetCaption(sgDots.Row);
  ResetZero:=True;
  Draw.Invalidate;
  UndoList.Items.Add(CurrentPath);
end;

procedure TfrmPathEdit.ToolButton1Click(Sender: TObject);
var i:Integer;
 s:string;
begin
//  ZeroXY := Point(0,0);
  for i:= 1 to sgDots.RowCount-1 do
    PathAbs(i);
  ResetCaption(sgDots.Row);
  Draw.Invalidate;

  if Sender <> nil then
  begin
    s := CurrentPath;
    if (UndoList.Items.Count=0) or (UndoList.Items[UndoList.Items.Count-1]<>s)
    then
      UndoList.Items.Add(s);
  end;

end;

procedure TfrmPathEdit.ToolButton2Click(Sender: TObject);
var i:Integer;
s:string;
begin
//  ZeroXY := Point(0,0);
  for i:= 1 to sgDots.RowCount-1 do
    PathRel(i);
  ResetCaption(sgDots.Row);
  Draw.Invalidate;

  if Sender <> nil then
  begin
    s := CurrentPath;
    if (UndoList.Items.Count=0) or (UndoList.Items[UndoList.Items.Count-1]<>s)
    then
      UndoList.Items.Add(s);
  end;

end;

procedure TfrmPathEdit.ToolButton3Click(Sender: TObject);
begin
  if UndoList.Items.Count>1 then
    UndoList.Items.Delete(UndoList.Items.Count-1);
  if UndoList.Items.Count>0 then
    ParsePath(UndoList.Items[UndoList.Items.Count-1]);
    Draw.Invalidate;
end;

procedure TfrmPathEdit.tbApplyClick(Sender: TObject);
var
  s:string;
  i,j:integer;
begin
  s:='';
  for i := 1 to sgDots.RowCount-1 do
    for j := 1 to 8 do
      if sgDots.Cells[j,i]<>'' then
        s:=s + sgDots.Cells[j,i] + ' ';
  mePATH.Lines.Text := trim(s);
end;

procedure TfrmPathEdit.ToolButton7Click(Sender: TObject);
begin
  ResetZero:=True;
  ParsePath(mePATH.Lines.Text);
  Draw.Invalidate;
end;

procedure TfrmPathEdit.ZloseZ1Click(Sender: TObject);
var
  s,a:string;
  i:integer;
begin
  s:= ',' + sgDots.Cells[11,sgDots.Row]+','+sgDots.Cells[12,sgDots.Row];

  if (sgDots.Cells[1,sgDots.Row]='A') or (sgDots.Cells[1,sgDots.Row]='a') then
    a:=sgDots.Cells[5,sgDots.Row]+','+sgDots.Cells[6,sgDots.Row]
  else
    a:='0,0';

  case TMenuItem(sender).tag of
   0: s := 'L' + s;
   1: s := 'C,' + sgDots.Cells[9,sgDots.Row]+','+sgDots.Cells[10,sgDots.Row] + s + s;
   2: s := 'S' + s +s;
   3: s := 'Q' + s + s;
   4: s := 'T' + s;
   5: s := 'A, 10,10,0,'+ a + s;
   6: s := 'H,' + sgDots.Cells[11,sgDots.Row];
   7: s := 'V,' + sgDots.Cells[12,sgDots.Row];
   8: s := 'M' + s;
   9: s := 'Z';
  end;

  sgDots.RowCount := sgDots.RowCount + 1;
  sgDots.Rows[sgDots.RowCount-1].CommaText := '0,'+s;
  sgDots.MoveRow(sgDots.RowCount-1, sgDots.Row+1);
  sgDots.Row := sgDots.Row+1;
  for i := 1 to sgDots.RowCount-1 do
    sgDots.cells[0,i]:=IntToStr(i);
  Draw.Invalidate;
end;

procedure TfrmPathEdit.FormCreate(Sender: TObject);
var i:integer;
begin
  ZeroXY:=Point(0,0);
  ResetZero:=False;
  FormatSettings.DecimalSeparator := '.';
  sgDots.ColAlignments[0]:=taRightJustify;
  for i := 1 to sgDots.ColCount-1 do
    sgDots.ColAlignments[i]:=taCenter;
  sgDots.ColWidths[1] := 24;
  sgDots.Rows[0].CommaText := '¹,Cmd';

  ParsePath(mePATH.Lines.Text);
end;

procedure TfrmPathEdit.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if Mouse.IsDragging then Exit;

  if (sgDots.Width > MousePos.x)
  and (sgDots.Top < MousePos.y)
  and (sgDots.Top+sgDots.Height > MousePos.y)
  then exit;

  if WheelDelta<0 then
     seZoom.Value := seZoom.Value +  seZoom.Increment
  else
     seZoom.Value := seZoom.Value -  seZoom.Increment;

  Handled:=True;
end;

procedure TfrmPathEdit.mePATHChange(Sender: TObject);
begin
  ParsePath(mePATH.Lines.Text);
  Draw.Invalidate;
end;

procedure TfrmPathEdit.DrawStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  MouseStart := Mouse.CursorPos;
end;

procedure TfrmPathEdit.ParsePath(APath: string);
var i,j,n:Integer;
  s:string;
  r:double;
begin
  s:=APath;
  for i := 1 to Length(s) do
    if s[i]<#33 then
       s[i]:=#32;
  s:=StringReplace(s,',',' ',[rfReplaceAll]);
  s:=trim(StringReplace(s,'-',' -',[rfReplaceAll]));
  s:=trim(StringReplace(s,'E -','E-',[rfReplaceAll]));
  s:=trim(StringReplace(s,'e -','E-',[rfReplaceAll]));
  while pos('  ', s)>0 do
    s:=StringReplace(s,'  ',' ',[rfReplaceAll]);

  n:=0;
  for i := 1 to Length(s) do
  begin
    if Pos(s[i], 'MLVHCSQTAZmlvhcsqtaz')>0 then
    begin
      inc(n);
      j:=2;
      sgDots.Rows[n].text := IntToStr(n);
      sgDots.Cells[1,n]:=s[i];
      continue;
    end
    else
    if (s[i]=#32)or(s[i]=',') then
    begin
      if sgDots.Cells[j,n]<>'' then
        inc(j);
      continue;
    end
    else
    if (s[i]='.')and(pos('.',sgDots.Cells[j,n],Pos('E',sgDots.Cells[j,n])+1)>0) then
      inc(j)
    else
    if (s[i]='-')and(sgDots.Cells[j,n]<>'')and(s[i-1]<>'E') then
      inc(j);

    if (((sgDots.Cells[1,n]='C')or(sgDots.Cells[1,n]='c'))and (j=8))
    or (((sgDots.Cells[1,n]='L')or(sgDots.Cells[1,n]='l'))and (j=4))
    or (((sgDots.Cells[1,n]='H')or(sgDots.Cells[1,n]='h'))and (j=3))
    or (((sgDots.Cells[1,n]='V')or(sgDots.Cells[1,n]='v'))and (j=3))
    or (((sgDots.Cells[1,n]='S')or(sgDots.Cells[1,n]='s'))and (j=6))
    or (((sgDots.Cells[1,n]='Q')or(sgDots.Cells[1,n]='q'))and (j=6))
    or (((sgDots.Cells[1,n]='T')or(sgDots.Cells[1,n]='t'))and (j=4))
    or (((sgDots.Cells[1,n]='A')or(sgDots.Cells[1,n]='a'))and (j=9))
    then
    begin
      j:=2;
      inc(n);
      sgDots.Rows[n].text := IntToStr(n);
      sgDots.Cells[1,n]:=sgDots.Cells[1,n-1];
    end;

    if ((sgDots.Cells[1,n]='A')or(sgDots.Cells[1,n]='a'))and (j in [5,6]) and (sgDots.Cells[j,n]<>'')
    then
      inc(j);

    if (sgDots.Cells[1,n]='M') and (j=4)
    then
    begin
      j:=2;
      inc(n);
      sgDots.Rows[n].text := IntToStr(n);
      sgDots.Cells[1,n]:='L';
    end;
    if (sgDots.Cells[1,n]='m') and (j=4)
    then
    begin
      j:=2;
      inc(n);
      sgDots.Rows[n].text := IntToStr(n);
      sgDots.Cells[1,n]:='l';
    end;

    sgDots.Cells[j,n]:=sgDots.Cells[j,n]+s[i];
  end;
  if n=0 then
    sgDots.RowCount:=2
  else
    sgDots.RowCount:=n+1;

  for i := 1 to sgDots.RowCount-1 do
    for j := 1 to sgDots.ColCount-1 do
      if pos('.',sgDots.Cells[j,i])>0 then
      begin
        s := sgDots.Cells[j,i];
        r := StrToFloatDef(s,0);
        r := RoundTo(r,-3);
        s := FloatToStr(r);
        sgDots.Cells[j,i] := s;
      end;



  sgDots.FixedRows := 1;
  ResetCaption(sgDots.Row);

end;

procedure TfrmPathEdit.PathAbs(Idx: integer);
var i,n1,n2:Integer;
  xy:array [0..1] of double;
begin
  if Pos('%', sgDots.Rows[Idx].text )>0 then
  begin
    sgDots.Cells[1,Idx] := UpperCase(sgDots.Cells[1,Idx]);
    Exit;
  end;

  n1:=2;
  n2:=-1;
  xy[0]:=StrToXY(sgDots.Cells[9,idx],0);
  xy[1]:=StrToXY(sgDots.Cells[10,idx],0);
  case sgDots.Cells[1,Idx][1] of
    'm','l','t': n2:=1;
    'h': n2:=0;
    'v': sgDots.Cells[2,Idx]:=FloatToStr(RoundTo(StrToXY(sgDots.Cells[2,Idx], 0)+xy[1],-3));
    'c': n2:=5;
    's','q': n2:=3;
    'a': begin n1:=7; n2:=1; end;
  end;
  sgDots.Cells[1,Idx] := UpperCase(sgDots.Cells[1,Idx]);
  for i := 0 to n2 do
    sgDots.Cells[n1+i,Idx]:=FloatToStr(RoundTo(StrToXY(sgDots.Cells[n1+i,Idx], 0)+xy[i mod 2],-3));

end;

procedure TfrmPathEdit.PathFlip(Idx: integer; HV: Boolean);
var i,n1,n2:Integer;
  xy:array [0..1] of double;
  k:array [0..1] of double;
begin
  n1:=2;
  n2:=-1;
  xy[0]:=StrToXY(sgDots.Cells[9,idx],0);
  xy[1]:=StrToXY(sgDots.Cells[10,idx],0);
  if HV then
    k[0]:=-1
  else
    k[0]:=1;
  k[1]:=-k[0];
  case sgDots.Cells[1,Idx][1] of
    'M','L','T': n2:=1;
    'H': n2:=0;
    'V': sgDots.Cells[2,Idx]:=FloatToStr(k[1] * RoundTo(StrToXY(sgDots.Cells[2,Idx], 0)-xy[1],-3));
    'C': n2:=5;
    'S','Q': n2:=3;
    'A': begin n1:=7; n2:=1; end;
  end;
  sgDots.Cells[1,Idx] := LowerCase(sgDots.Cells[1,Idx]);
  for i := 0 to n2 do
    sgDots.Cells[n1+i,Idx]:=FloatToStr(k[i mod 2] * RoundTo(StrToXY(sgDots.Cells[n1+i,Idx], 0)-xy[i mod 2],-3));

end;

procedure TfrmPathEdit.PathRel(Idx: integer);
var i,n1,n2:Integer;
  xy:array [0..1] of double;
begin
  if Pos('%', sgDots.Rows[Idx].text )>0 then
  begin
    sgDots.Cells[1,Idx] := LowerCase(sgDots.Cells[1,Idx]);
    Exit;
  end;

  n1:=2;
  n2:=-1;
  xy[0]:=StrToXY(sgDots.Cells[9,idx],0);
  xy[1]:=StrToXY(sgDots.Cells[10,idx],0);
  case sgDots.Cells[1,Idx][1] of
    'M','L','T': n2:=1;
    'H': n2:=0;
    'V': sgDots.Cells[2,Idx]:=FloatToStr(RoundTo(StrToXY(sgDots.Cells[2,Idx], 0)-xy[1],-3));
    'C': n2:=5;
    'S','Q': n2:=3;
    'A': begin n1:=7; n2:=1; end;
  end;
  sgDots.Cells[1,Idx] := LowerCase(sgDots.Cells[1,Idx]);
  for i := 0 to n2 do
    sgDots.Cells[n1+i,Idx]:=FloatToStr(RoundTo(StrToXY(sgDots.Cells[n1+i,Idx], 0)-xy[i mod 2],-3));

end;

procedure TfrmPathEdit.Ref1Click(Sender: TObject);
begin
  PathRel(sgDots.Row)

end;

procedure TfrmPathEdit.ResetCaption;
begin
  case sgDots.Cells[1,Arow][1] of
    'M': sgDots.Rows[0].CommaText := '¹,Cmd,x,y';
    'L': sgDots.Rows[0].CommaText := '¹,Cmd,x,y';
    'V': sgDots.Rows[0].CommaText := '¹,Cmd,y';
    'H': sgDots.Rows[0].CommaText := '¹,Cmd,x';
    'C': sgDots.Rows[0].CommaText := '¹,Cmd,x1,y1,x2,y2,x,y';
    'S': sgDots.Rows[0].CommaText := '¹,Cmd,x2,y2,x,y';
    'Q': sgDots.Rows[0].CommaText := '¹,Cmd,x1,y1,x,y';
    'T': sgDots.Rows[0].CommaText := '¹,Cmd,x,y';
    'A': sgDots.Rows[0].CommaText := '¹,Cmd,rx,ry,ax,(C,(/),x,y';
    'Z': sgDots.Rows[0].CommaText := '¹,Cmd';
    'm': sgDots.Rows[0].CommaText := '¹,Cmd,dx,dy';
    'l': sgDots.Rows[0].CommaText := '¹,Cmd,dx,dy';
    'v': sgDots.Rows[0].CommaText := '¹,Cmd,dy';
    'h': sgDots.Rows[0].CommaText := '¹,Cmd,dx';
    'c': sgDots.Rows[0].CommaText := '¹,Cmd,dx1,dy1,dx2,dy2,dx,dy';
    's': sgDots.Rows[0].CommaText := '¹,Cmd,dx2,dy2,dx,dy';
    'q': sgDots.Rows[0].CommaText := '¹,Cmd,dx1,dy1,dx,dy';
    't': sgDots.Rows[0].CommaText := '¹,Cmd,dx,dy';
    'a': sgDots.Rows[0].CommaText := '¹,Cmd,rx,ry,ax,(C,(/),dx,dy';
    'z': sgDots.Rows[0].CommaText := '¹,Cmd';
  end;
  sgDots.Invalidate;
end;

end.
