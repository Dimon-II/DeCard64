unit u_CellEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, u_SynEditFrame,
  Vcl.ExtCtrls, Vcl.Grids, Profixxml, Vcl.Buttons, System.Actions,
  Vcl.ActnList, System.UITypes, Vcl.ComCtrls, SynEdit, Vcl.Menus, Vcl.ToolWin;

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
    StartingPoint : TPoint;
    Doing:string;
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

uses u_MainData, u_MainForm, u_XMLEditForm, Clipbrd, u_TraceReplace;

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

procedure TCellEditForm.FormResize(Sender: TObject);
begin
 if pcHelpher.Width > Width /2 then
   pcHelpher.Width := Width div 2;

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
  if seWrap.Lines.IndexOf(s)>-1 then
    s :=  ^M + s;
  CellEditFrame.SynEditor.SelText := s;
  CellEditFrame.SynEditor.SetFocus;
  SetCursorPos(Mouse.CursorPos.x, lbCommon.ClientToScreen(point(0,10)).y);

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
      DropPosition := ItemAtPos(DropPoint,True) ;

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

  CellEditFrame.SynEditor.SelText := s;
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

procedure TCellEditForm.SetGrid(const Value: TStringGrid);
begin
  FGrid := Value;
end;

procedure TCellEditForm.SetNodeName(const Value: string);
begin
  FNodeName := Value;
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
      i:=Pos('(',z,i);
      j:=Pos('(',s,j);

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
         if (cnt1=cnt2)and(seTranslate.Lines[j] <> list1[i]) then
         begin
           list2[j] := list1[i];
           seTranslate.Lines[j] := list1[i];

           m := TSynEditMark.Create(seTranslate);
           m.Line := j+1;
//           m.ImageList := ImageList1;
           m.ImageIndex := 0;
           if seTranslate.Marks.Count<10 then
             m.ImageIndex := seTranslate.Marks.Count+1;


           m.Visible := true;
           seTranslate.Marks.Add(m);
           Doing := Doing + '('+IntToStr(j+1)+')';
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

end.
