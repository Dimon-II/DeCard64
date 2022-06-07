unit u_CellEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, u_SynEditFrame,
  Vcl.ExtCtrls, Vcl.Grids, Profixxml, Vcl.Buttons, System.Actions,
  Vcl.ActnList, System.UITypes, Vcl.ComCtrls, SynEdit;

type

  TSynEdit = class(u_SynEditFrame.TSynEdit);

  TCellEditForm = class(TForm)
    pnBottom: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    CellEditFrame: TSynEditFrame;
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
    pcHelpher: TPageControl;
    tsCommon: TTabSheet;
    tsMacros: TTabSheet;
    tsHTMS: TTabSheet;
    lbCommon: TListBox;
    lbMacros: TListBox;
    seTags: TSynEdit;
    lbCommonIdx: TListBox;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    lbMacrosIdx: TListBox;
    tsWrap: TTabSheet;
    seWrap: TSynEdit;
    cbHelper: TComboBox;
    aHelper: TAction;
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
    procedure Action1Execute(Sender: TObject);
    procedure cbHelperExit(Sender: TObject);
    procedure aHelperExecute(Sender: TObject);
    procedure cbHelperKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbHelperKeyPress(Sender: TObject; var Key: Char);
    procedure cbHelperChange(Sender: TObject);
    procedure cbHelperCloseUp(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    FOldText:string;
    FGrid: TStringGrid;
    FRow,RowDisplay: integer;
    FRepl:TStringList;
    FNodeName: string;
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetGrid(const Value: TStringGrid);
    procedure ResetCombo;
    procedure PrepareCombo;
    procedure SetNodeName(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    procedure PrepareMacro(ANod:TXML_Nod);
    procedure btnCancelClick(Sender: TObject);
    property Text:string read GetText write SetText;
    property Grid:TStringGrid read FGrid write SetGrid;
    property Row: integer read FRow write FRow;
    property NodeName:string read FNodeName write SetNodeName;

  end;


var
  CellEditForm: TCellEditForm;

implementation

{$R *.dfm}

uses u_MainData, u_MainForm, u_XMLEditForm, Clipbrd, unaRe;

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
      r := copy(FRepl[i],length(n)+2, Length(FRepl[i]));
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
  s := StringReplace(s, '>', '>'#13#10 ,[rfReplaceAll, rfIgnoreCase]);
  XMLEditForm.XML := s;
  XMLEditForm.seTags.Visible := False;
  XMLEditForm.splTags.Visible := False;
  XMLEditForm.ShowModal;
end;

procedure TCellEditForm.Action1Execute(Sender: TObject);
begin
  case pcHelpher.ActivePageIndex of
    0: if lbCommon.Count > TAction(Sender).tag + lbCommon.TopIndex-1 then
       begin
         lbCommon.ItemIndex := TAction(Sender).tag + lbCommon.TopIndex-1;
         lbCommonDblClick(nil);
       end;
    1: if lbMacros.Count > TAction(Sender).tag + lbMacros.TopIndex-1 then
       begin
         lbMacros.ItemIndex := TAction(Sender).tag + lbMacros.TopIndex-1;
         lbMacrosDblClick(nil);
       end;
  end;

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

procedure TCellEditForm.aHelperExecute(Sender: TObject);
var p:tpoint;
    p1:TDisplayCoord;
begin
  cbHelper.Parent := CellEditFrame.SynEditor;
  PrepareCombo;
  p1 := CellEditFrame.SynEditor.DisplayXY;
//  p1.Column := p1.Column - cbHelper.tag;
  p1.row := p1.row+1;

  p := CellEditFrame.SynEditor.RowColumnToPixels(p1);
//  Inc(p.y, CellEditFrame.SynEditor.LineHeight);
  cbHelper.Top :=p.y;
  cbHelper.Left :=p.x;
  if cbHelper.Left+cbHelper.Width>CellEditFrame.SynEditor.ClientWidth then
    cbHelper.Left := CellEditFrame.SynEditor.ClientWidth - cbHelper.Width;

  cbHelper.Visible:=True;
  cbHelper.SetFocus;
  cbHelper.DroppedDown := True;
//  cbHelper.ClearSelection;
  cbHelper.SelStart:=cbHelper.tag;
  cbHelper.SelLength:=0;
  ResetCombo;
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

procedure TCellEditForm.cbHelperChange(Sender: TObject);
begin
  if cbHelper.ItemIndex=-1 then
    ResetCombo;
end;

procedure TCellEditForm.cbHelperCloseUp(Sender: TObject);
begin
//  if not (FindControl(GetForegroundWindow()) <> nil) then
//     cbHelper.Visible := False;
 {
 if cbHelper.Visible then
   if (FindControl(GetForegroundWindow()) <> nil) then
     cbHelper.DroppedDown := cbHelper.Visible
   else
     cbHelper.Visible := False;
}
end;

procedure TCellEditForm.cbHelperExit(Sender: TObject);
begin
  cbHelper.Visible := False;
end;

procedure TCellEditForm.cbHelperKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#27 then
  begin
     key:=#0;
     cbHelper.Visible := False;
     CellEditFrame.SynEditor.SetFocus;
  end;
  if key=#13 then
  begin
     key:=#0;
     cbHelper.Visible := False;
     CellEditFrame.SynEditor.SelText := cbHelper.Text;
     CellEditFrame.SynEditor.SetFocus;
  end;

end;

procedure TCellEditForm.cbHelperKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key=VK_LEFT) or (Key=VK_RIGHT) or (Key=VK_HOME) or (Key=VK_END))
  then ResetCombo;
end;

procedure TCellEditForm.CellEditFrameSynEditorChange(Sender: TObject);
begin
  Grid.Cells[Grid.Col, Grid.Row] := GetText;
end;

procedure TCellEditForm.CellEditFrameToolButton3Click(Sender: TObject);
var sl: TstringList;
  i: integer;
begin
  try
    sl := TstringList.Create;
    if CellEditFrame.SynEditor.SelText<>'' then
      sl.Text := CellEditFrame.SynEditor.SelText
    else
      sl.Text := clipboard.astext;
    for i:= 0 to sl.count-1 do
      if sl[i]<>'' then
      begin
        if lbCommon.Items.IndexOf(sl[i])>-1 then
          lbCommon.Items.Delete(lbCommon.Items.IndexOf(sl[i]));
        lbCommon.Items.Insert(0,sl[i]);
      end;
  finally
    sl.Free;
  end;

end;

procedure TCellEditForm.FormCreate(Sender: TObject);
begin
  btnCancel.OnClick := btnCancelClick;
  CellEditFrame.FindCaption := ': Edited Text [table cell]';
  FRepl := TStringList.Create;
end;

procedure TCellEditForm.FormDeactivate(Sender: TObject);
begin
  cbHelper.Visible := False;
end;

procedure TCellEditForm.FormDestroy(Sender: TObject);
begin
  FRepl.Free;
end;

function TCellEditForm.GetText: string;
begin
  Result := StringReplace(CellEditFrame.SynEditor.Text, #13#10,'',[rfReplaceAll]);
  Result := StringReplace(Result, #9, ' ',[rfReplaceAll]) ;
  Result := StringReplace(Result, '  ',' ',[rfReplaceAll]) ;
end;

procedure TCellEditForm.lbCommonDblClick(Sender: TObject);
var
  s:string;
begin
  s := lbCommon.Items[lbCommon.ItemIndex];
  if Sender <> nil then
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

  if Sender<>nil then
  begin
    if lbCommon.Items.IndexOf(s)>-1 then
       lbCommon.Items.Delete(lbCommon.Items.IndexOf(s));
    lbCommon.Items.Insert(0,s);
  end;

  if (s = '<br/>')or(s = '<p/>') then
  s := s + ^M;
  CellEditFrame.SynEditor.SelText := s;
  CellEditFrame.SynEditor.SetFocus;
end;

procedure TCellEditForm.PrepareCombo;
var i,j,k,n1,n2:integer;
    s,z, CurrentInput:string;
begin
  if CellEditFrame.SynEditor.SelText<>'' then
  begin
    CurrentInput := CellEditFrame.SynEditor.SelText;
  end
  else
  begin
    if CellEditFrame.SynEditor.CaretX<1 then
    begin
      s := CellEditFrame.SynEditor.Lines[CellEditFrame.SynEditor.CaretY-1];
      CurrentInput := '';

      for i:= 1 to Length(s) do
        for j := 0 to lbMacros.Items.Count-1 do
          if Pos(WideUpperCase(copy(s,1,i)), WideUpperCase(lbMacros.Items[j]))=1 then
          begin
            CellEditFrame.SynEditor.CaretX := i;
            CurrentInput := copy(s,1,i);
            break;
          end;
    end
    else
    begin
      CurrentInput := '';
      k := CellEditFrame.SynEditor.CaretX;
      n2 := CellEditFrame.SynEditor.CaretX;;
      s := CellEditFrame.SynEditor.Lines[CellEditFrame.SynEditor.CaretY-1];

      for i := CellEditFrame.SynEditor.CaretX-1 downto 1 do
      begin
        z:=copy(s,i,n2-i+1);
        for j := 0 to lbMacros.Items.Count-1 do
          if Pos(WideUpperCase(z), WideUpperCase(lbMacros.Items[j]))=1 then
          begin
            k := i;
            CurrentInput := z;
            break;
          end;
      end;
      n1:=Length(CurrentInput);

      for i := CellEditFrame.SynEditor.CaretX to Length(s) do
      begin
        z:=copy(s,k,i-k+1);
        for j := 0 to lbMacros.Items.Count-1 do
          if Pos(WideUpperCase(z), WideUpperCase(lbMacros.Items[j]))=1 then
          begin
            CellEditFrame.SynEditor.CaretX := i+1;
            CurrentInput := z;
            break;
          end;
      end;
    end;

    CellEditFrame.SynEditor.SelStart := CellEditFrame.SynEditor.RowColToCharIndex(CellEditFrame.SynEditor.CaretXY)-Length(CurrentInput);
    CellEditFrame.SynEditor.SelEnd := CellEditFrame.SynEditor.SelStart +Length(CurrentInput);
  end;
  cbHelper.Text := CurrentInput;
//  ResetCombo;
  cbHelper.Tag :=  n1;
//  CellEditFrame.SynEditor.RowColToCharIndex(CellEditFrame.SynEditor.CaretXY)-n1;
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
      if (sl.Names[i]<>'') and
         (lbMacros.Items.IndexOf(sl.Names[i])=-1) and
         (Pos('=$',sl[i])=0)
      then
        lbMacros.Items.Add(sl.Names[i]);
    Nod := Nod.parent;
  until Nod = Nil;
  sl.Free;
end;

procedure TCellEditForm.ResetCombo;
var i,s1,s2:Integer;
begin
  s1 := cbHelper.SelStart;
  s2 := cbHelper.SelLength;
  if cbHelper.text<>'' then
    if cbHelper.Hint = Copy(cbHelper.text,1,s1+s2) then exit;

  cbHelper.Items.BeginUpdate;
  cbHelper.Items.Clear;
  cbHelper.Hint := Copy(cbHelper.text,1,s1+s2);
//  cbHelper.Items.Add(cbHelper.text);
  for i:= 0 to lbMacros.Items.Count-1 do
  begin
    if (cbHelper.text='')or(s1+s2=0) or (pos(AnsiUpperCase(Copy(cbHelper.text,1,s1+s2)), AnsiUpperCase(lbMacros.Items[i]))=1) then
      cbHelper.Items.Add(lbMacros.Items[i]);
  end;
  if cbHelper.Items.Count<7 then
     cbHelper.DropDownCount := cbHelper.Items.Count+1
  else
    cbHelper.DropDownCount := 8;
  cbHelper.DroppedDown := True;
  cbHelper.SelStart := s1;
  cbHelper.SelLength := s2;
  cbHelper.Items.EndUpdate;
end;

procedure TCellEditForm.SetGrid(const Value: TStringGrid);
begin
  FGrid := Value;
end;

procedure TCellEditForm.SetNodeName(const Value: string);
begin
  FNodeName := Value;
end;

procedure TCellEditForm.SetText(const Value: string);
var s: string;
    i: integer;
begin
  FOldText := Value;
  s := StringReplace(Value, '&#47;', '/',[rfreplaceall]);
  for i:= 0 to seWrap.Lines.Count do
    if trim(seWrap.Lines[i])<>'' then
      s := StringReplace(s, seWrap.Lines[i], #13#10+seWrap.Lines[i],[rfreplaceall]);


 {
  s := StringReplace(Value, '<br/>', #13#10'<br/>',[rfreplaceall]);
  s := StringReplace(s, '<br ', #13#10'<br ',[rfreplaceall]);
  s := StringReplace(s, '<p/>', #13#10'<p/>',[rfreplaceall]);
  s := StringReplace(s, '<p ', #13#10'<p ',[rfreplaceall]);
}
  CellEditFrame.SynEditor.OnChange := Nil;
  CellEditFrame.SynEditor.Text := s;
  CellEditFrame.SynEditor.OnChange := CellEditFrameSynEditorChange;
end;



end.
