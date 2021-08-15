unit u_CellEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, u_SynEditFrame,
  Vcl.ExtCtrls, Vcl.Grids, Profixxml, Vcl.Buttons, System.Actions,
  Vcl.ActnList, System.UITypes;

type
  TCellEditForm = class(TForm)
    pnBottom: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    CellEditFrame: TSynEditFrame;
    pnRight: TPanel;
    gbMacros: TGroupBox;
    lbMacros: TListBox;
    gbCommon: TGroupBox;
    lbCommon: TListBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    sbaLeftCell: TSpeedButton;
    sbNextLine: TSpeedButton;
    sbPrewLine: TSpeedButton;
    sbaRightCell: TSpeedButton;
    alGrid: TActionList;
    aGidLeft: TAction;
    aGridRight: TAction;
    aGridUp: TAction;
    aGridDown: TAction;
    aPreview: TAction;
    sbPreview: TSpeedButton;
    chbScrollPreview: TCheckBox;
    sbChkRepl: TSpeedButton;
    aChkRepl: TAction;
    procedure FormCreate(Sender: TObject);
    procedure CellEditFrameSynEditorChange(Sender: TObject);
    procedure lbMacrosDblClick(Sender: TObject);
    procedure lbCommonDblClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure aGidLeftUpdate(Sender: TObject);
    procedure aGridUpUpdate(Sender: TObject);
    procedure aGidLeftExecute(Sender: TObject);
    procedure aGridUpExecute(Sender: TObject);
    procedure aGridRightExecute(Sender: TObject);
    procedure aGridDownExecute(Sender: TObject);
    procedure CellEditFrameToolButton3Click(Sender: TObject);
    procedure aPreviewUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aChkReplExecute(Sender: TObject);
  private
    FOldText:string;
    FGrid: TStringGrid;
    FRow,RowDisplay: integer;
    FRepl:TStringList;
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetGrid(const Value: TStringGrid);
    { Private declarations }
  public
    { Public declarations }
    procedure PrepareMacro(ANod:TXML_Nod);
    procedure btnCancelClick(Sender: TObject);
    property Text:string read GetText write SetText;
    property Grid:TStringGrid read FGrid write SetGrid;
    property Row: integer read FRow write FRow;

  end;

var
  CellEditForm: TCellEditForm;

implementation

{$R *.dfm}

uses u_MainData, u_MainForm, u_XMLEditForm;

{ TCellEditForm }

procedure TCellEditForm.aChkReplExecute(Sender: TObject);
var
  r,n,s:string;
  i:integer;
begin
  s := CellEditFrame.SynEditor.Text;

  for i:=0 to FRepl.Count-1 do
    if Pos('=', FRepl[i])>0 then
    begin
        n:=Copy(FRepl[i], 1, Pos('=', FRepl[i])-1);

        if Pos(WideUpperCase(WideString(n)), WideUpperCase(s)) >0 then
        begin
          r := copy(FRepl[i],length(n)+2, Length(FRepl[i]));
          if copy(r,1,1)='=' then
            s := StringReplace(s, n, copy(r,2,length(r)) ,[rfReplaceAll])
          else
            s := StringReplace(s, n, r ,[rfReplaceAll, rfIgnoreCase]);
        end;
    end;
  s := StringReplace(s, '>', '>'#13#10 ,[rfReplaceAll, rfIgnoreCase]);
  XMLEditForm.XML := s;
  XMLEditForm.seTags.Visible := False;
  XMLEditForm.splTags.Visible := False;
  XMLEditForm.ShowModal;
end;

procedure TCellEditForm.aGidLeftExecute(Sender: TObject);
begin
  Grid.Col := Grid.Col -1;
end;

procedure TCellEditForm.aGidLeftUpdate(Sender: TObject);
begin
  aGidLeft.Enabled := (Grid<>nil) and (Grid.Col >1);
end;

procedure TCellEditForm.aGridDownExecute(Sender: TObject);
begin
  if Grid.Row=Grid.RowCount-1 then
    if MessageDlg('Add row?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then Exit
    else begin
      Grid.RowCount := Grid.RowCount+1;
      Grid.Cells[0, Grid.RowCount-1] := IntToStr(Grid.RowCount-1);
    end;
  Grid.Row :=Grid.Row+1;
{
  if chbScrollPreview.Checked then
     aPreview.Execute
}
end;

procedure TCellEditForm.aGridRightExecute(Sender: TObject);
begin
  if Grid.Col=Grid.ColCount-1 then
    if MessageDlg('Add column?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then Exit
    else
    begin
      Grid.ColCount := Grid.ColCount+1;
      Grid.Cells[Grid.ColCount-1, 0] := '['+IntToStr(Grid.ColCount-1)+']';
    end;
  Grid.Col :=Grid.Col+1;

end;

procedure TCellEditForm.aGridUpExecute(Sender: TObject);
begin
  Grid.Row := Grid.Row -1;
{
  if chbScrollPreview.Checked then
     aPreview.Execute
}
end;

procedure TCellEditForm.aGridUpUpdate(Sender: TObject);
begin
  aGridUp.Enabled := (Grid<>nil) and (Grid.Row >1);
end;

procedure TCellEditForm.aPreviewUpdate(Sender: TObject);
begin
  if (FRow <> RowDisplay) and chbScrollPreview.Checked then
  begin
    RowDisplay := FRow;
    MainForm.RenderRow(RowDisplay);
  end;
end;

procedure TCellEditForm.btnApplyClick(Sender: TObject);
begin
  FOldText := Grid.Cells[Grid.Col, Grid.Row];
end;

procedure TCellEditForm.btnCancelClick(Sender: TObject);
begin
  if Grid.Cells[Grid.Col, Grid.Row] <> FOldText then
  begin
    if MessageDlg('Discard changes?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then Exit;

    Grid.Cells[Grid.Col, Grid.Row] := FOldText;
  end;
  Close;
end;

procedure TCellEditForm.CellEditFrameSynEditorChange(Sender: TObject);
begin
  Grid.Cells[Grid.Col, Grid.Row] := GetText;
end;

procedure TCellEditForm.CellEditFrameToolButton3Click(Sender: TObject);
begin
  if CellEditFrame.SynEditor.SelText<>'' then
  begin
    if lbCommon.Items.IndexOf(CellEditFrame.SynEditor.SelText)>-1 then
      lbCommon.Items.Delete(lbCommon.Items.IndexOf(CellEditFrame.SynEditor.SelText));
    lbCommon.Items.Insert(0,CellEditFrame.SynEditor.SelText);
  end;

end;

procedure TCellEditForm.FormCreate(Sender: TObject);
begin
  btnCancel.OnClick := btnCancelClick;
  CellEditFrame.FindCaption := ': Edited Text [table cell]';
  FRepl := TStringList.Create;

end;

procedure TCellEditForm.FormDestroy(Sender: TObject);
begin
  FRepl.Free;
end;

function TCellEditForm.GetText: string;
begin
  Result := StringReplace(CellEditFrame.SynEditor.Text, #13#10,'',[rfReplaceAll]);
  Result := StringReplace(Result, '  ',' ',[rfReplaceAll]) ;
end;

procedure TCellEditForm.lbCommonDblClick(Sender: TObject);
var
  s:string;
begin
  s := lbCommon.Items[lbCommon.ItemIndex];
  if lbCommon.ItemIndex >0 then
  begin
    lbCommon.Items.Delete(lbCommon.ItemIndex);
    lbCommon.Items.Insert(0,s);
    lbCommon.ItemIndex := 0;
  end;

  if (s = '<br/>')or(s = '<p/>')
    or (copy(s,1,4) = '<br ')or(copy(s,1,3) = '<p ')
  then
    s :=  ^M+s;
  CellEditFrame.SynEditor.SelText := s;
  CellEditFrame.SynEditor.SetFocus;
  SetCursorPos(Mouse.CursorPos.x, lbCommon.ClientToScreen(point(0,10)).y);

end;

procedure TCellEditForm.lbMacrosDblClick(Sender: TObject);
var
  s:string;
begin
  s := lbMacros.Items[lbMacros.ItemIndex];
  if lbCommon.Items.IndexOf(s)>-1 then
    lbCommon.Items.Delete(lbCommon.Items.IndexOf(s));
  lbCommon.Items.Insert(0,s);

  if (s = '<br/>')or(s = '<p/>') then
  s := s + ^M;
  CellEditFrame.SynEditor.SelText := s;
  CellEditFrame.SynEditor.SetFocus;
end;

procedure TCellEditForm.PrepareMacro(ANod: TXML_Nod);
var
  i:integer;
  Nod: TXML_Nod;
  sl:TStrings;
begin

  Nod := ANod;
  sl:=TStringList.Create;
  lbMacros.Clear;
  FRepl.Clear;

  lbMacros.Items.Add('<br/>');
  lbMacros.Items.Add('<p/>');
  lbMacros.Items.Add('<b>');
  lbMacros.Items.Add('<i>');

  repeat
    sl.Text := Nod.Attribute['dekart:replace'];
    FRepl.AddStrings(sl);
    for i := 0 to sl.Count-1 do
      if (sl.Names[i]<>'') and (lbMacros.Items.IndexOf(sl.Names[i])=-1) then
        lbMacros.Items.Add(sl.Names[i]);
    Nod := Nod.parent;
  until Nod = Nil;
  sl.Free;
end;

procedure TCellEditForm.SetGrid(const Value: TStringGrid);
begin
  FGrid := Value;
end;

procedure TCellEditForm.SetText(const Value: string);
var s: string;
begin
  FOldText := Value;

  s := StringReplace(Value, '<br/>', #13#10'<br/>',[rfreplaceall]);
  s := StringReplace(s, '<br ', #13#10'<br ',[rfreplaceall]);
  s := StringReplace(s, '<p/>', #13#10'<p/>',[rfreplaceall]);
  s := StringReplace(s, '<p ', #13#10'<p ',[rfreplaceall]);
  s := StringReplace(s, '&#47;', '/',[rfreplaceall]);
  CellEditFrame.SynEditor.Text := s;
end;

end.
