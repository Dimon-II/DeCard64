unit u_CellEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, u_SynEditFrame,
  Vcl.ExtCtrls, Vcl.Grids, Profixxml, Vcl.Buttons, System.Actions,
  Vcl.ActnList, System.UITypes, Vcl.ComCtrls, SynEdit, Vcl.Menus, Vcl.ToolWin,
  Vcl.Samples.Spin;

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
    tsWrap: TTabSheet;
    seWrap: TSynEdit;
    cbHelper: TComboBox;
    aHelper: TAction;
    aAddCommon: TAction;
    pmCommon: TPopupMenu;
    Add1: TMenuItem;
    Del1: TMenuItem;
    Clear1: TMenuItem;
    FillbyCol1: TMenuItem;
    N1: TMenuItem;
    lbSelector: TListBox;
    lbFiltered: TListBox;
    tsTranslate: TTabSheet;
    splRevers: TSplitter;
    tbrTranslate: TToolBar;
    tbMerge: TToolButton;
    tbApply: TToolButton;
    seTranslate: TSynEdit;
    SynEdit1: TSynEdit;
    N2: TMenuItem;
    miOpenFile: TMenuItem;
    miSaveFile: TMenuItem;
    Distinctfill1: TMenuItem;
    miPaste1: TMenuItem;
    pmText: TPopupMenu;
    pmiAddToDictionary: TMenuItem;
    pmiSuggestions: TMenuItem;
    pmiMisspelling: TMenuItem;
    pmiSelectLanguage: TMenuItem;
    pmiNoSpellcheck: TMenuItem;
    N3: TMenuItem;
    pmiRemove: TMenuItem;
    tsReplace: TTabSheet;
    pnButtons: TPanel;
    btnReplaceAll: TButton;
    btnReplace: TButton;
    btnFind: TButton;
    btnFindUp: TButton;
    pnReplace: TPanel;
    gbOptions: TGroupBox;
    chbColumn: TCheckBox;
    chbPromt: TCheckBox;
    chbMatchCase: TCheckBox;
    chbWholeCell: TCheckBox;
    pbReplaceText: TPanel;
    lblFind: TLabel;
    lblReplace: TLabel;
    edFind: TComboBox;
    edReplace: TComboBox;
    chbFindBack: TCheckBox;
    aGridFindNext: TAction;
    aGridFindPrev: TAction;
    aGridReplace: TAction;
    tsTransform: TTabSheet;
    lblStep: TLabel;
    sbMinusDX: TSpeedButton;
    sbMinusDY: TSpeedButton;
    sbPlusDY: TSpeedButton;
    sbPlusDX: TSpeedButton;
    seStep: TSpinEdit;
    lblDX: TLabel;
    seDX: TSpinEdit;
    lblDY: TLabel;
    seDY: TSpinEdit;
    aMinusDX: TAction;
    aPlusDX: TAction;
    aMinusDY: TAction;
    aPlusDY: TAction;
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
    procedure lbCommonDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lbCommonDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbCommonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aAddCommonExecute(Sender: TObject);
    procedure CellEditFrameSynEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Del1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure FillbyCol1Click(Sender: TObject);
    procedure lbSelectorClick(Sender: TObject);
    procedure tbMergeClick(Sender: TObject);
    procedure seTranslateGutterGetText(Sender: TObject; aLine: Integer;
      var aText: string);
    procedure seTranslateChange(Sender: TObject);
    procedure tbApplyClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CellEditFrameSynEditorGutterGetText(Sender: TObject;
      aLine: Integer; var aText: string);
    procedure miOpenFileClick(Sender: TObject);
    procedure miSaveFileClick(Sender: TObject);
    procedure Distinctfill1Click(Sender: TObject);
    procedure miPaste1Click(Sender: TObject);
    procedure pmiAddToDictionaryClick(Sender: TObject);
    procedure pmiMisspellingClick(Sender: TObject);
    procedure pmiNoSpellcheckClick(Sender: TObject);
    procedure SelectDictLangClick(Sender: TObject);
    procedure pmTextPopup(Sender: TObject);
    procedure SuggestionOnClick(Sender: TObject);
    procedure pmiRemoveClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure aGridFindNextExecute(Sender: TObject);
    procedure aGridFindPrevExecute(Sender: TObject);
    procedure aGridReplaceExecute(Sender: TObject);
    procedure aGridFindNextUpdate(Sender: TObject);
    procedure aGridFindPrevUpdate(Sender: TObject);
    procedure aGridReplaceUpdate(Sender: TObject);
    procedure seStepChange(Sender: TObject);
    procedure seDXChange(Sender: TObject);
    procedure aMinusDYExecute(Sender: TObject);
    procedure aPlusDYExecute(Sender: TObject);
    procedure aPlusDXExecute(Sender: TObject);
    procedure aMinusDXExecute(Sender: TObject);
  private
    FOldText:string;
    FGrid: TStringGrid;
    FRow: integer;
    FRepl:TStringList;
    FNodeName: string;
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetGrid(const Value: TStringGrid);
    procedure ResetCombo;
    procedure PrepareCombo;
    procedure SetNodeName(const Value: string);
    function Compare(txt: string; var i: integer): Boolean;
    procedure SelectReplace;
    { Private declarations }
  public
    { Public declarations }
    StartingPoint : TPoint;
    Doing:string;
    RowDisplay: integer;
    miSuggest,
    miMisspelling,
    miRemove,
    miAddWord:TMenuItem;
    LockTransrform:Boolean;
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

uses u_MainData, u_MainForm, u_XMLEditForm, Clipbrd, u_TraceReplace,
SynEditSpell, SynEditHighlighter;

{ TCellEditForm }

procedure TCellEditForm.aAddCommonExecute(Sender: TObject);
var sl,s2: TstringList;
  i: integer;
begin
  try
    sl := TstringList.Create;
    s2 := TstringList.Create;
    s2.CaseSensitive := True;
    s2.AddStrings(lbCommon.Items);


    if CellEditFrame.SynEditor.SelText<>'' then
      sl.Text := CellEditFrame.SynEditor.SelText
    else
      sl.Text := clipboard.astext;
    for i:= 0 to sl.count-1 do
      if sl[i]<>'' then
      begin
        if s2.IndexOf(sl[i])>-1 then
          s2.Delete(s2.IndexOf(sl[i]));
        s2.Insert(0,sl[i]);
      end;

    lbCommon.Items.Assign(s2)
  finally
    sl.Free;
  end;
end;

procedure TCellEditForm.aChkReplExecute(Sender: TObject);
var
  r,n,s:string;
  i:integer;
begin
  s := CellEditFrame.SynEditor.Text;

  TraceReplForm.seRepl.Lines.Assign(FRepl);
  TraceReplForm.seCell.Lines.Text := CellEditFrame.SynEditor.Text;
  TraceReplForm.aTraceAll.Execute;
  TraceReplForm.ShowModal;
end;

procedure TCellEditForm.aGridReplaceExecute(Sender: TObject);
begin
  btnReplaceClick(nil)
end;

procedure TCellEditForm.aGridReplaceUpdate(Sender: TObject);
begin
  aGridReplace.Enabled := (edFind.Text<>'') and (edFind.Text<>edReplace.text);
  btnReplaceAll.Enabled := (edFind.Text<>'') and (edFind.Text<>edReplace.text);
end;

procedure TCellEditForm.Action1Execute(Sender: TObject);
begin
  if lbCommon.Count > TAction(Sender).tag + lbCommon.TopIndex-1 then
  begin
    lbCommon.ItemIndex := TAction(Sender).tag + lbCommon.TopIndex-1;
    lbCommonDblClick(nil);
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

procedure TCellEditForm.aGridFindNextExecute(Sender: TObject);
begin
  btnFindClick(btnFind);
end;

procedure TCellEditForm.aGridFindNextUpdate(Sender: TObject);
begin
  aGridFindNext.Enabled := edFind.Text <> '';
end;

procedure TCellEditForm.aGridFindPrevExecute(Sender: TObject);
begin
  btnFindClick(btnFindUp);
end;

procedure TCellEditForm.aGridFindPrevUpdate(Sender: TObject);
begin
  aGridFindPrev.Enabled := edFind.Text <> '';
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
      SetLength(MainForm.LangSet, Grid.ColCount);
      MainForm.LangSet[Grid.ColCount-1]:=Grid.ColCount-1;
    end;
  Grid.Col :=Grid.Col+1;

end;

procedure TCellEditForm.aGridUpExecute(Sender: TObject);
begin
  Grid.Row := Grid.Row -1;
{
  if chbScrollPreview.Checked then
     a•Preview.Execute
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


procedure TCellEditForm.aMinusDXExecute(Sender: TObject);
begin
 seDX.Value := seDX.Value - seStep.Value;

end;

procedure TCellEditForm.aMinusDYExecute(Sender: TObject);
begin
  seDY.Value := seDY.Value - seStep.Value;
end;

procedure TCellEditForm.aPlusDXExecute(Sender: TObject);
begin
 seDX.Value := seDX.Value + seStep.Value;

end;

procedure TCellEditForm.aPlusDYExecute(Sender: TObject);
begin
 seDY.Value := seDY.Value + seStep.Value;

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

procedure TCellEditForm.btnFindClick(Sender: TObject);
var i,j,step:integer;
   s1,s2,txt:string;
begin
  if edFind.Items.IndexOf(edFind.Text)=-1 then
    edFind.Items.Insert(0,edFind.Text);


  if chbColumn.Checked then
     step := Grid.ColCount
  else
     step := 1;

  if chbFindBack.Checked XOR  (Sender = btnFindUp) then
     step := -step;

  if not chbWholeCell.Checked then
  begin
    txt := CellEditFrame.SynEditor.text;
    if chbMatchCase.Checked then
    begin
      s1 := edFind.Text;
      s2 :=txt;
    end
    else
    begin
      s1 := WideUpperCase(edFind.Text);
      s2 := WideUpperCase(txt);
    end;

    if step >0 then
      j := pos(s1, s2, CellEditFrame.SynEditor.SelStart+CellEditFrame.SynEditor.SelLength+1)
    else
    for i := CellEditFrame.SynEditor.SelStart downto 0 do
    begin
      j := pos(s1, s2, i);
      if (j>0) and (j<CellEditFrame.SynEditor.SelStart) then
        Break
      else
        j := 0;
    end;
    if j > 0 then
    begin
      CellEditFrame.SynEditor.SelStart := j-1;
      CellEditFrame.SynEditor.SelLength := Length(edFind.text);
      exit;
    end;

  end;


  i:=(Grid.Row) * Grid.ColCount + Grid.Col;
  while True do
  begin
    inc(i,step);
    if i<Grid.ColCount then exit;
    if i >= Grid.ColCount * Grid.RowCount then exit;
    Compare(Grid.Cells[i mod Grid.ColCount, i div Grid.ColCount],i)
  end;
end;

procedure TCellEditForm.btnReplaceAllClick(Sender: TObject);
var acol,arow,qry:Integer;

begin
  if edReplace.Items.IndexOf(edReplace.Text)=-1 then
    edReplace.Items.Insert(0,edReplace.Text);

  if MessageDlg('Replace ALL '''+edFind.Text+''' to '''+edReplace.text+'''?', mtConfirmation, [mbYes, mbNo],0)=mrNo then exit;


  qry := mrYes;
  if edFind.Text<> edReplace.text then
  repeat
    while (CellEditFrame.SynEditor.SelLength=Length(edFind.Text)) do
    begin
      if chbPromt.Checked and (qry <> mrAll)then
       qry := MessageDlg('Replace selected to '''+edReplace.text+'''?', mtConfirmation, [mbYes, mbNo, mbAbort, mbAll],0);
      if qry=mrAbort then Abort;

      if not chbWholeCell.Checked or (Length(CellEditFrame.SynEditor.Text)=Length(edFind.Text)) then
      if (CellEditFrame.SynEditor.SelLength=Length(edFind.Text)) and (qry in [mrYes,mrAll]) then
        CellEditFrame.SynEditor.SelText :=edReplace.Text
       else
        CellEditFrame.SynEditor.SelStart := CellEditFrame.SynEditor.SelStart+Length(edFind.Text);
      SelectReplace
    end;



    acol:=Grid.Col;
    arow:=Grid.Row;
    try
      btnFindClick(nil);
    except

    end;
   SelectReplace;
  until (acol=Grid.Col) and (arow=Grid.Row);

end;

procedure TCellEditForm.btnReplaceClick(Sender: TObject);
begin
  if edReplace.Items.IndexOf(edReplace.Text)=-1 then
    edReplace.Items.Insert(0,edReplace.Text);

  if not chbWholeCell.Checked or (Length(CellEditFrame.SynEditor.Text)=Length(edFind.Text)) then
  if (CellEditFrame.SynEditor.SelLength=Length(edFind.Text)) and
     (not chbPromt.Checked or (MessageDlg('Replace selected to '''+edReplace.text+'''?', mtConfirmation, [mbYes,mbNo],0)=mrYes)) then
     begin
       CellEditFrame.SynEditor.SelText :=edReplace.Text;
     end
   else CellEditFrame.SynEditor.SelStart := CellEditFrame.SynEditor.SelStart+Length(edFind.Text);
   SelectReplace
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

//  if pcHelpher.ActivePage = tsReplace then
//    SelectReplace;





end;

procedure TCellEditForm.CellEditFrameSynEditorGutterGetText(Sender: TObject;
  aLine: Integer; var aText: string);
var i: integer;
  s,rs: string;
begin
  s := TSynEdit(Sender).Lines[aLine-1];
  rs :='';
  for i := 1 to  length(s) do
    if s[i] in ['(',')'] then
      rs := StringReplace(rs+s[i],'()','',[rfReplaceAll]);
  aText := rs + atext;
end;

procedure TCellEditForm.CellEditFrameSynEditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  If (ssCtrl in Shift) and (Key = ord('0')) Then
    aAddCommon.Execute
end;


procedure TCellEditForm.Clear1Click(Sender: TObject);
begin
 lbCommon.Clear;
end;

procedure TCellEditForm.Del1Click(Sender: TObject);
begin
 if lbCommon.ItemIndex<>-1 then
   lbCommon.Items.Delete(lbCommon.ItemIndex);
end;

procedure TCellEditForm.Distinctfill1Click(Sender: TObject);
var i:integer;
begin
  for i := 1 to  Grid.RowCount-1 do
    if Trim(Grid.Cells[Grid.Col, i])<>'' then
      if lbCommon.Items.IndexOf(Grid.Cells[Grid.Col, i])=-1 then
      begin
        lbCommon.Items.Add(Grid.Cells[Grid.Col, i]);
        if lbCommon.Items.Count mod 10 = 0 then
          if MessageDlg(IntToStr(lbCommon.Items.Count)+' list items, Continue scanning?', mtConfirmation,[mbYes, mbNo],0) = mrNo then
            Abort
      end;
  lbCommon.Sorted := true;
  lbCommon.Sorted := False;

end;

procedure TCellEditForm.FillbyCol1Click(Sender: TObject);
var i,j:Integer;
begin
  for i := 1 to  Grid.RowCount-1 do
    for j:= 0 to lbMacros.Count-1 do
      if (Pos(lbMacros.Items[j], Grid.Cells[Grid.Col, i])>0) and
         (lbCommon.Items.IndexOf(lbMacros.Items[j])=-1)
       then
         lbCommon.Items.Add(lbMacros.Items[j]);
end;

procedure TCellEditForm.FormCreate(Sender: TObject);

procedure MergeMenus(SrcMenu, DstMenu: TPopupMenu);
var
  i, i2, i3: Integer;
  Menu, SubMenu  : TMenuItem;
begin
  DstMenu.OnPopup :=SrcMenu.OnPopup;
  for i := 0 to SrcMenu.Items.Count - 1 do
  begin
          Menu := TMenuItem.Create(DstMenu.Owner);
          // copy another properties if necessery
          Menu.Name := SrcMenu.Items[i].Name;
          Menu.Caption := SrcMenu.Items[i].Caption;
          Menu.ShortCut := SrcMenu.Items[i].ShortCut;
          Menu.OnClick := SrcMenu.Items[i].OnClick;
          Menu.RadioItem:=SrcMenu.Items[i].RadioItem;
          Menu.Tag:=SrcMenu.Items[i].Tag;
          Menu.Enabled := SrcMenu.Items[i].Enabled;
          Menu.Visible := SrcMenu.Items[i].Visible;
          Menu.GroupIndex:=SrcMenu.Items[i].GroupIndex;

          if SrcMenu.Items[i] = pmiSuggestions then
            miSuggest := Menu;
          if SrcMenu.Items[i] = pmiAddToDictionary then
            miAddWord := Menu;
          if SrcMenu.Items[i] = pmiMisspelling then
            miMisspelling := Menu;
          if SrcMenu.Items[i] = pmiRemove then
            miRemove := Menu;



          DstMenu.Items.Add(Menu);
        for i3 := 0 to SrcMenu.Items[i].Count - 1 do
        begin
          SubMenu := TMenuItem.Create(DstMenu.Owner);
          // copy another properties if necessery
          SubMenu.Name := SrcMenu.Items[i].Items[i3].Name;
          SubMenu.Caption := SrcMenu.Items[i].Items[i3].Caption;
          SubMenu.ShortCut := SrcMenu.Items[i].Items[i3].ShortCut;
          SubMenu.OnClick := SrcMenu.Items[i].Items[i3].OnClick;
          SubMenu.RadioItem:=SrcMenu.Items[i].Items[i3].RadioItem;
          SubMenu.Tag:=SrcMenu.Items[i].Items[i3].Tag;
          SubMenu.GroupIndex:=SrcMenu.Items[i].Items[i3].GroupIndex;
          SubMenu.Checked:=SrcMenu.Items[i].Items[i3].Checked;

          Menu.Add(SubMenu);
        end;
      end;
end;
var
  mi      : TMenuItem;
  i       : integer;

begin
  btnCancel.OnClick := btnCancelClick;
  CellEditFrame.FindCaption := ': Edited Text [table cell]';
  FRepl := TStringList.Create;

  with MainData.DictLangList do
    for i:=0 to Count-1 do
    begin
        mi:=TMenuItem.Create(Self);
        with mi do begin
          Caption:=Strings[i];
          GroupIndex:=82;
          RadioItem:=true;
          Tag:=integer(Objects[i]);
          OnClick:=SelectDictLangClick;
          end;
        pmiSelectLanguage.Add(mi);
    end;
  TDrawAutoSpellCheckPlugin.Create(CellEditFrame.SynEditor,MainData.SynEditSpellCheck);
  CellEditFrame.SynEditor.Tag:=0;
  CellEditFrame.SynEditor.Highlighter.AdditionalWordBreakChars:=['«', '»', '“', '”'];
  CellEditFrame.SynEditor.AdditionalWordBreakChars:=['«', '»', '“', '”'];
  CellEditFrame.SynEditor.Highlighter.AdditionalIdentChars:=['[',']'];

  MergeMenus(pmText, CellEditFrame.SynEditor.PopupMenu);
end;

procedure TCellEditForm.FormDeactivate(Sender: TObject);
begin
  cbHelper.Visible := False;
end;

procedure TCellEditForm.FormDestroy(Sender: TObject);
begin
  FRepl.Free;
end;

procedure TCellEditForm.FormResize(Sender: TObject);
begin
 if pcHelpher.Width > Width /2 then
   pcHelpher.Width := Width div 2;

end;

function TCellEditForm.GetText: string;
begin
  Result := StringReplace(CellEditFrame.SynEditor.Text, #13#10,' ',[rfReplaceAll]);
  Result := StringReplace(Result, #9, ' ',[rfReplaceAll]) ;
  Result := StringReplace(Result, '  ',' ',[rfReplaceAll]) ;
end;

procedure TCellEditForm.lbCommonDblClick(Sender: TObject);
var
  s:string;
begin
  s := lbCommon.Items[lbCommon.ItemIndex];
  if seWrap.Lines.IndexOf(s)>-1 then
    s :=  ^M + s;
  CellEditFrame.SynEditor.SelText := StringReplace(s,'[selected]',CellEditFrame.SynEditor.SelText,[]);
  CellEditFrame.SynEditor.SetFocus;
end;

procedure TCellEditForm.lbCommonDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    DropPosition, StartPosition: Integer;
    DropPoint: TPoint;
begin
    DropPoint.X := X;
    DropPoint.Y := Y;
    with Source as TListBox do
    begin
      StartPosition := ItemAtPos(StartingPoint,True) ;
      DropPosition := ItemAtPos(DropPoint,True);
      if (StartPosition<>-1) and (DropPosition<>-1) then
        Items.Move(StartPosition, DropPosition) ;
    end;
end;

procedure TCellEditForm.lbCommonDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   Accept := Source = lbCommon;
end;

procedure TCellEditForm.lbCommonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StartingPoint.X := X;
  StartingPoint.Y := Y;
end;

procedure TCellEditForm.lbMacrosDblClick(Sender: TObject);
var
  s:string;
begin
  s := lbFiltered.Items[lbFiltered.ItemIndex];

  if (Sender<>nil)and(lbCommon.Items.IndexOf(s)=-1) then
    lbCommon.Items.Add(s);

  if seWrap.Lines.IndexOf(s)>-1 then
    s :=  ^M + s;

  CellEditFrame.SynEditor.SelText := StringReplace(s,'[selected]',CellEditFrame.SynEditor.SelText,[]);
  CellEditFrame.SynEditor.SetFocus;
end;

procedure TCellEditForm.lbSelectorClick(Sender: TObject);
var i,j:Integer;
begin
  if lbSelector.ItemIndex<1 then
    lbFiltered.Items.Assign(lbMacros.Items)
  else begin
    lbFiltered.Items.Clear;
    if lbSelector.Items.count = lbSelector.ItemIndex+1 then
      j := lbMacros.Items.count
    else
      j := Integer(lbSelector.Items.Objects[lbSelector.ItemIndex+1]);

    for i := Integer(lbSelector.Items.Objects[lbSelector.ItemIndex]) to J-1 do
       lbFiltered.Items.Add(lbMacros.Items[i])

  end;
end;

procedure TCellEditForm.miOpenFileClick(Sender: TObject);
begin
  if MainData.dlgOpenCommon.execute then
  begin
    if MainData.dlgOpenCommon.Encodings[MainData.dlgOpenCommon.encodingindex] ='UTF-8' then
      lbCommon.Items.LoadFromFile(MainData.dlgOpenCommon.filename, TEncoding.UTF8)
    else
      lbCommon.Items.LoadFromFile(MainData.dlgOpenCommon.filename);
    MainData.dlgSaveCommon.filename := MainData.dlgOpenCommon.filename;
  end;
end;

procedure TCellEditForm.miPaste1Click(Sender: TObject);
var sl:TStringList;
    i:Integer;
begin
  sl:=TStringList.Create;
  sl.Text := Clipboard.AsText;
   for i:= 0 to sl.Count-1 do
     if Trim(sl[i])<>''  then
       if lbCommon.Items.IndexOf(sl[i])=-1 then
         lbCommon.Items.Add(sl[i]);
  sl.free;
end;

procedure TCellEditForm.miSaveFileClick(Sender: TObject);
begin
  if MainData.dlgSaveCommon.execute then
  begin
    if MainData.dlgOpenCommon.Encodings[MainData.dlgOpenCommon.encodingindex] ='UTF-8' then
      lbCommon.Items.SaveToFile(MainData.dlgSaveCommon.filename, TEncoding.UTF8)
    else
      lbCommon.Items.SaveToFile(MainData.dlgSaveCommon.filename);
  end;

end;

procedure TCellEditForm.pmiAddToDictionaryClick(Sender: TObject);
var
  xy : TBufferCoord;
begin
  with CellEditFrame.SynEditor do
  begin
    xy:=CaretXY;
    MainData.SynEditSpellCheck.AddDictWord(GetWordAtRowCol(xy));
    CaretXY:=xy;
    Invalidate;
    MainData.SynEditSpellCheck.Modified := False;
  end;
end;

procedure TCellEditForm.pmiMisspellingClick(Sender: TObject);
var
  sWord,sToken : string;
  PosXY : TBufferCoord;
  Attri : TSynHighlighterAttributes;
  fnd   : boolean;
begin
  with CellEditFrame.SynEditor do
  begin
    fnd:=false; PosXY:=CaretXY;
    repeat
      PosXY:=NextWordPosEx(PosXY);
      if PosXY.Char>0 then begin
        sWord:=GetWordAtRowCol(PosXY);
        with MainData.SynEditSpellCheck do if Highlighter = nil then fnd:=not CheckWord(sWord)
        else begin
          if not GetHighlighterAttriAtRowCol(PosXY,sToken,Attri) then
            Attri:=Highlighter.WhitespaceAttribute;
          fnd:=Assigned(Attri) and CheckHighlighterAttribute(Attri.Name) and
            not CheckWord(sWord);
          end;
        end;
      until fnd or (PosXY.Line>Lines.Count) or (PosXY=NextWordPosEx(PosXY));
    if fnd then CaretXY:=PosXY
    else begin
      Beep;
//      ShowMessage('No more misspellings found!');
      end;
  end;
end;

procedure TCellEditForm.pmiNoSpellcheckClick(Sender: TObject);
begin
  SelectDictLangClick(Sender);
  CellEditFrame.SynEditor.Highlighter.AdditionalIdentChars:=['[',']'];
  miMisspelling.Enabled := False;
end;

procedure TCellEditForm.pmiRemoveClick(Sender: TObject);
var i:Integer;
begin
  MainData.SynEditSpellCheck.EraseDictWord(MainData.SynEditSpellCheck.UserDict[miRemove.Tag]);
  MainData.SynEditSpellCheck.Modified := False;
  CellEditFrame.SynEditor.Invalidate;
end;

type TMyMenu=class(TPopupMenu) end;

procedure TCellEditForm.pmTextPopup(Sender: TObject);
var
  sword : string;
  mnu   : TMenuItem;
  i     : Integer;
  suggList: TStringList;
  p:tpoint;
  p1:TDisplayCoord;
begin

  p1 := CellEditFrame.SynEditor.DisplayXY;
  p1.row := p1.row+1;
  p := CellEditFrame.SynEditor.ClientToScreen(CellEditFrame.SynEditor.RowColumnToPixels(p1));

  with CellEditFrame.SynEditor do
    sword:=GetWordAtRowCol(CaretXY);

    miAddWord.Visible:=(not MainData.SynEditSpellCheck.CheckWord(sword)) and (Trim(sword) <> '');
    miAddWord.Caption :=  '&Add word ''' +trim(sword) + ''' to dictionary';

    miRemove.tag := MainData.SynEditSpellCheck.UserDict.IndexOf(trim(sword));
    miRemove.Visible :=miRemove.tag > -1;
    miRemove.Caption :=  '&Erase ''' +trim(sword) + ''' from dictionary';

    with miSuggest do begin
      while Count>0 do Items[Count-1].Free;
      Visible:=false;
      end;
    if length(Trim(sword))=0 then Exit;
    suggList := TStringList.Create;
    if miAddWord.Visible and (MainData.SynEditSpellCheck.GetSuggestions(sword,suggList)>0) then
    begin
      mnu := TMenuItem.Create(Self);
      mnu.Caption:='( '+sword+ ' )';
      mnu.Enabled := False;

      miSuggest.Add(mnu);
      mnu := TMenuItem.Create(Self);
      mnu.Caption:='-';
      miSuggest.Add(mnu);
      for i := 0 to suggList.Count-1 do begin
        mnu := TMenuItem.Create(Self);
        if suggList.Strings[i]<>sword then begin
          mnu.Caption:=suggList.Strings[i];
          mnu.OnClick:=SuggestionOnClick;
          miSuggest.Add(mnu);
          end
        else mnu.Free;
        end;
      miSuggest.Visible:=miSuggest.Count>2;
    end;
    suggList.Free;

//    TMyMenu(sender).SetPopupPoint(p);
//    Mouse.CursorPos := p;

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
      if copy(s,CellEditFrame.SynEditor.CaretX,1)=' ' then
        Delete(s,CellEditFrame.SynEditor.CaretX,Length(s));


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
  i,j:integer;
  s, s1,s2,s3, ls:string;
  Nod: TXML_Nod;
  sl:TStringList;
begin

  Nod := ANod;
  sl:=TStringList.Create;
  sl.CaseSensitive :=True;

  lbMacros.Clear;
  FRepl.Clear;

  lbMacros.Items.Add('<br/>');
  lbMacros.Items.Add('<p/>');
  if lbSelector.ItemIndex>-1 then
  ls := lbSelector.Items[lbSelector.ItemIndex];
  lbSelector.Items.Text := 'All';


  repeat
    sl.Text := Nod.Attribute['dekart:replace'];
    FRepl.AddStrings(sl);
    for i := 0 to sl.Count-1 do
      if (sl.Names[i]<>'') then
      begin

        if Pos('=$',sl[i])>0 then
        begin
          s := sl.Names[i];
          s1:='';
          s2:='';
          while s<>'' do
          begin
            if s[1]='\' then
            begin
              s1 := s1 + s[2];
              delete(s,1,2);
              Continue
            end;
            if (s[1]='(') then s2:=')';
            if (s[1]='[') then s2:=']';
            if s2<>'' then
            begin
              while (s<>'') and (s2<>'') do
              begin
                if s[i]='\' then
                  delete(s,1,1)
                else
                if s[1]=s2 then
                  s2 := '';
                 delete(s,1,1)
              end;
              Continue
            end;
            s1 := s1 + s[1];
            delete(s,1,1);
          end;
          lbMacros.Items.Add(s1);
        end
        else
          lbMacros.Items.Add(sl.Names[i]);
      end
      else
      if (trim(sl[i])<>'') then
      begin
        s := trim(sl[i]);
        if (s[1]='[')and(s[Length(s)]=']') then
          lbSelector.Items.AddObject(Copy(s,2,Length(s)-2),Pointer(lbMacros.Items.Count));
      end;
    Nod := Nod.parent;
  until Nod = Nil;
  sl.Free;
  if lbSelector.Items.IndexOf(ls)=-1 then
    lbSelector.ItemIndex := 0
  else
  lbSelector.ItemIndex := lbSelector.Items.IndexOf(ls);
  lbSelectorClick(lbSelector);
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

procedure TCellEditForm.seDXChange(Sender: TObject);
var s:string;
begin
  if LockTransrform then exit;
  if pcHelpher.ActivePage = tsTransform then
  begin
    s := '';

    if seDY.Value <> 0 then
      s := ','+IntToStr(seDY.Value);
    if (s <> '') or (seDX.Value <> 0) then
      s := IntToStr(seDX.Value) + s;

    CellEditFrame.SynEditor.Text := s;
    CellEditFrameSynEditorChange(Sender);
    MainForm.aShow.Execute;
  end;
end;

procedure TCellEditForm.SetGrid(const Value: TStringGrid);
begin
  FGrid := Value;
end;

procedure TCellEditForm.SetNodeName(const Value: string);
begin
  FNodeName := Value;
  tsTransform.TabVisible := (MainForm.InspectorFrame.SVGNode <> nil)
    and (Pos('['+IntToStr(Grid.col)+']', MainForm.InspectorFrame.SVGNode.Attribute['decard:transform'])>0)
end;

procedure TCellEditForm.seTranslateChange(Sender: TObject);
begin
   Doing := '';
end;

procedure TCellEditForm.seTranslateGutterGetText(Sender: TObject;
  aLine: Integer; var aText: string);
begin
  if pos('('+IntToStr(Aline)+')',Doing)>0 then
    aText :='>>'+aText;
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

  CellEditFrame.SynEditor.OnChange := Nil;
  CellEditFrame.SynEditor.Text := s;
  CellEditFrame.SynEditor.OnChange := CellEditFrameSynEditorChange;

  tsTransform.TabVisible := (MainForm.InspectorFrame.SVGNode <> nil)
    and (Pos('['+IntToStr(Grid.col)+']', MainForm.InspectorFrame.SVGNode.Attribute['dekart:transform'])>0);

  if tsTransform.TabVisible then
  begin
    LockTransrform := True;
    seDX.Value := StrToIntDef(Copy(s,1,pos(',', s+',')-1),0);
    seDY.Value := StrToIntDef(Copy(s,pos(',', s+',')+1,Length(s)),0);
    LockTransrform := False;
  end;
end;



procedure TCellEditForm.SuggestionOnClick(Sender: TObject);
begin
  with CellEditFrame.SynEditor do
  begin
    BlockBegin:=WordStartEx(CaretXY);
    BlockEnd:=WordEndEx(CaretXY);
    SelText:=StringReplace(TMenuItem(Sender).Caption,'&','',[]);
  end;
end;

procedure TCellEditForm.tbApplyClick(Sender: TObject);
begin
  text := StringReplace(seTranslate.Lines.text, #13#10,'',[rfReplaceAll]);
  Grid.Cells[Grid.Col, Grid.Row] := GetText;
end;

procedure TCellEditForm.tbMergeClick(Sender: TObject);
var
  list1, list2:TStringList;
  i, j, k: Integer;
  cnt1, cnt2 :Integer;
  s,z:string;
  m: TSynEditMark;

  procedure ParseLang(AText:string; AList:TStringList; AStart,AStop:string);
  var
    s, z : string;
    i, j, k: integer;
  begin
    AList.Clear;
    AList.Add('');
    s := StringReplace(AText,#13#10,'',[rfReplaceAll]);
    i := 0;
    while i<Length(s) do
    begin
      Inc(i);

      // 1 word after (
      if (i<Length(s)) and (s[i]='(')and(Pos(s[i+1],'0123456789_-')=0)  then
      begin
        for j := i+1 to Length(s) do
          if (WideUpperCase(WideString(s[j]))=WideLowerCase(WideString(s[j]))) and (Pos(s[j],'0123456789_-')=0)
          then Break;
        if s[j]=')' then
        begin
          AList.Add(Copy(s,i, j-i+1));
          AList.Objects[AList.Count-1] := AList;
          AList.Add('');
          i := j;
          Continue;
        end;
      end;

      // regex function name like qwerty(
      if s[i]='(' then
      begin
        z:='(';
        k:=1;
{
        if (pos('(', AStart)>0) and (i>1) and (s[i-1]=' ') then
          k:=2;
}
        for j := i-k downto 1 do
          if (WideUpperCase(WideString(s[j]))=WideLowerCase(WideString(s[j]))) and (Pos(s[j],'0123456789_-')=0)
          then Break
          else z := s[j] + z;

        if j<i-1 then
          if WideUpperCase(WideString(z[1]))<>WideLowerCase(WideString(z[1])) then
          begin
            AList[AList.Count-1] := Copy(AList[AList.Count-1],1,Length(AList[AList.Count-1])-Length(z));
            AList.Add(z);
            AList.Objects[AList.Count-1] := AList;
            AList.Add('');
            Continue;
          end;
      end;

      // text between  AStart/AStop, contains no extra starting letter
      j:=pos(s[i],AStart);
      if j>0 then
      begin
        j := pos(Copy(AStop,j,1), s, i+1);
        z := Copy(s,i, j-i+1);

        if Pos(s[i],z,2)>0 then j:=0;

        if (j>0) then
        begin
          AList.Add(z);
          AList.Objects[AList.Count-1] := AList;
          AList.Add('');
          i := j;
          Continue;
        end;
      end;

      if s[i]='(' then
      begin
        j := pos(')', s, i+1);
        z := Copy(s,i, j-i+1);

        if Pos(s[i],z,2)>0 then j:=0;

        if (j>0) then
        begin
          AList.Add(z);
          AList.Add('');
          i := j;
          Continue;
        end;
      end;


      AList[AList.Count-1] := AList[AList.Count-1] + s[i]
    end;

    for i := Alist.Count-1 downto 0 do
     if Alist[i]='' then Alist.Delete(i);
  end;
begin
  list1:=TStringList.Create;
  list2:=TStringList.Create;
  try
    ParseLang(Text, list1,'<{[','>}]');
    i:=0;
    s := seTranslate.Lines.Text;
    z := Text;
    repeat
      i:=Pos('(',z,i+1);
      j:=Pos('(',s,j+1);

      if (i>1)and(j>1)and(z[i-1]<>' ')and(s[j-1]=' ')  then
        delete(s,j-1,1);
    until i=0;

    ParseLang(s, list2,'<{[(','>}])');

    cnt1:=0;
    Doing := '';
    seTranslate.Lines.Assign(list2);
    seTranslate.Marks.Clear;

    for i:= 0 to list1.Count-1 do
    begin
      for k:=1 to length(list1[i]) do
        if Pos(list1[i][k],'<[{(')>0 then Inc(cnt1);

      if list1.Objects[i]<> nil then
      begin
       cnt2 := 0;
       for j:= 0 to list2.Count-1 do
       begin
         for k:=1 to length(list2[j]) do
           if Pos(list2[j][k],'<[{(')>0 then Inc(cnt2);
         if (cnt1=cnt2) then
         begin
           if (list2[j] <> list1[i]) then
           begin
             list2[j] := list1[i];
             seTranslate.Lines[j] := list1[i];

             m := TSynEditMark.Create(seTranslate);
             m.Line := j+1;
             m.ImageIndex := 0;
             if seTranslate.Marks.Count<10 then
              m.ImageIndex := seTranslate.Marks.Count+1;


             m.Visible := true;
             seTranslate.Marks.Add(m);
             Doing := Doing + '('+IntToStr(j+1)+')';
           end;
           break;
         end;
       end;

      end;
    end;


  finally
    list1.Free;
    list2.Free;
  end;
end;

procedure TCellEditForm.SelectDictLangClick(Sender: TObject);
var
  lid : word;
  i: integer;
begin
  with Sender as TMenuItem do
  begin
    lid:=Tag;
    Checked:=true;
  end;

  with TStringList.Create do
  try
    CommaText := MainData.SynEditSpellCheck.UserDict.CommaText;
    MainData.SynEditSpellCheck.SelectDictionary(lid);
    for i:=0 to Count-1 do
      MainData.SynEditSpellCheck.AddDictWord(Strings[i]);
  finally
    Free;
  end;

  MainData.SynEditSpellCheck.Modified := False;

  with CellEditFrame.SynEditor do
  begin
    Tag:=lid;
    Invalidate;
  end;
  CellEditFrame.SynEditor.Highlighter.AdditionalIdentChars:=[];
  miMisspelling.Enabled := lid > 0;
  CellEditFrame.SynEditor.Highlighter.AdditionalWordBreakChars:=['«', '»', '“', '”'];
end;

function TCellEditForm.Compare(txt:string; var i:integer):Boolean;
var
  s1,s2:string;
begin
  if chbMatchCase.Checked then
  begin
    s1 := edFind.Text;
    s2 := txt;
  end
  else
  begin
    s1 := WideUpperCase(edFind.Text);
    s2 := WideUpperCase(txt);
  end;
  if chbWholeCell.Checked then
    result := s1 = s2
  else
    result := pos(s1,s2)>0;

  if result then
  begin
    Grid.Row := i div Grid.ColCount;
    Grid.Col := i mod Grid.ColCount;
    CellEditFrame.SynEditor.SelStart :=1;
    SelectReplace;
    abort;
  end;
end;

procedure TCellEditForm.SelectReplace;
var
  s1,s2:string;
  bl:Boolean;
begin
  if chbMatchCase.Checked then
  begin
    s1 := edFind.Text;
    s2 := CellEditFrame.SynEditor.Text;
  end
  else
  begin
    s1 := WideUpperCase(edFind.Text);
    s2 := WideUpperCase(CellEditFrame.SynEditor.Text);
  end;

  if (chbWholeCell.Checked and (s1 = s2))
  or (not chbWholeCell.Checked and (pos(s1,s2)>0))
  then
    if   pos(s1, s2, CellEditFrame.SynEditor.SelStart)>0 then
  begin
    CellEditFrame.SynEditor.SelStart := pos(s1, s2, CellEditFrame.SynEditor.SelStart)-1;
    CellEditFrame.SynEditor.SelLength := Length(s1);
  end;

{
  if CellEditFrame.SynEditor.Modified then
  begin
    sgText.Cells[sgText.Col, sgText.Row] := SynEditor.Text;
    sgText.OnSelectCell(sgText, sgText.Col, sgText.Row,bl);
  end;
}

end;


procedure TCellEditForm.seStepChange(Sender: TObject);
begin
   seDX.Increment := seStep.Value;
   seDY.Increment := seStep.Value;
end;

end.
