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
  private
    FOldText:string;
    FGrid: TStringGrid;
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

  end;

var
  CellEditForm: TCellEditForm;

implementation

{$R *.dfm}

uses u_MainData;

{ TCellEditForm }

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
  if chbScrollPreview.Checked then
     aPreview.Execute
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
  if chbScrollPreview.Checked then
     aPreview.Execute
end;

procedure TCellEditForm.aGridUpUpdate(Sender: TObject);
begin
  aGridUp.Enabled := (Grid<>nil) and (Grid.Row >1);
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
end;

function TCellEditForm.GetText: string;
begin
  Result := StringReplace(CellEditFrame.SynEditor.Text, #13#10,'',[rfReplaceAll]);
  Result := StringReplace(Result, '  ',' ',[rfReplaceAll]) ;
  Result := StringReplace(Result, '/>','\>',[rfReplaceAll]) ;
  Result := StringReplace(Result, '</','<\',[rfReplaceAll]) ;
  Result := StringReplace(Result, '/','&#47;',[rfReplaceAll]) ;
  Result := StringReplace(Result, '\>','/>',[rfReplaceAll]) ;
  Result := StringReplace(Result, '<\','</',[rfReplaceAll]) ;
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
  end;

  if (s = '<br/>')or(s = '<p/>') then
  s := s + ^M;
  CellEditFrame.SynEditor.SelText := s;
  CellEditFrame.SynEditor.SetFocus;

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

  lbMacros.Items.Add('<br/>');
  lbMacros.Items.Add('<p/>');
  lbMacros.Items.Add('<b>');
  lbMacros.Items.Add('<i>');

  repeat
    sl.Text := Nod.Attribute['dekart:replace'];
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
  s := StringReplace(Value, '<br/>', '<br/>'#13#10,[rfreplaceall]);
  s := StringReplace(s, '<p/>', #13#10'<p/>',[rfreplaceall]);
  s := StringReplace(s, '&#47;', '/',[rfreplaceall]);
  s := StringReplace(s, '[p]', '[p]'#13#10,[rfreplaceall]);
  s := StringReplace(s, '[P]', '[P]'#13#10,[rfreplaceall]);
  CellEditFrame.SynEditor.Text := s;
end;

end.
