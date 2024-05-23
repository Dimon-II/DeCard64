unit u_SynEditFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEditHighlighter,
  SynHighlighterXML, System.Actions, Vcl.ActnList, SynEditMiscClasses,
  SynEditSearch, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin, SynEdit,  SynHighlighterIni, ProfixXML,
  SynEditCodeFolding, Vcl.ExtCtrls;
type

  TSynXMLSyn=class(SynHighlighterXML.TSynXMLSyn)
  public
    function IsIdentChar(AChar: WideChar): Boolean;override;
  end;

  TSynEdit = class(SynEdit.TSynEdit)
  private
    FActnList: TActionList;
    FPopupMenu : TPopupMenu;
    procedure CreateActns;
    procedure FillPopupMenu(APopupMenu : TPopupMenu);
    procedure CutExecute(Sender: TObject);
    procedure CutUpdate(Sender: TObject);
    procedure CopyExecute(Sender: TObject);
    procedure CopyUpdate(Sender: TObject);
    procedure PasteExecute(Sender: TObject);
    procedure PasteUpdate(Sender: TObject);
    procedure DeleteExecute(Sender: TObject);
    procedure DeleteUpdate(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure SelectAllUpdate(Sender: TObject);
    procedure RedoExecute(Sender: TObject);
    procedure RedoUpdate(Sender: TObject);
    procedure UndoExecute(Sender: TObject);
    procedure UndoUpdate(Sender: TObject);
    procedure SetPopupMenu_(const Value: TPopupMenu);
    function  GetPopupMenu_: TPopupMenu;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PopupMenu: TPopupMenu read GetPopupMenu_ write SetPopupMenu_;
  end;



  TSynEditFrame = class(TFrame)
    actlMain: TActionList;
    actEditCut: TAction;
    actEditCopy: TAction;
    actEditPaste: TAction;
    actEditDelete: TAction;
    actEditUndo: TAction;
    actEditRedo: TAction;
    actEditSelectAll: TAction;
    actSearchFind: TAction;
    actSearchFindNext: TAction;
    actSearchFindPrev: TAction;
    actSearchReplace: TAction;
    SynEditor: TSynEdit;
    SynXMLSyn1: TSynXMLSyn;
    SynEditSearch1: TSynEditSearch;
    ReplaceDialog: TReplaceDialog;
    FindDialog: TFindDialog;
    pscrSysEdit: TPageScroller;
    tbrEditor: TToolBar;
    tbUndo: TToolButton;
    tbRedo: TToolButton;
    tbSep1: TToolButton;
    tbCut: TToolButton;
    tbCopy: TToolButton;
    tbPaste: TToolButton;
    ToolButton1: TToolButton;
    tbSearch: TToolButton;
    tbNext: TToolButton;
    tbRepl: TToolButton;
    ToolButton2: TToolButton;
    tbSpec: TToolButton;
    tbGlyph: TToolButton;
    ToolButton3: TToolButton;
    tbColorDialog: TToolButton;
    btnPipe: TToolButton;
    procedure actEditCutExecute(Sender: TObject);
    procedure actEditCutUpdate(Sender: TObject);
    procedure actEditCopyExecute(Sender: TObject);
    procedure actEditCopyUpdate(Sender: TObject);
    procedure actEditPasteExecute(Sender: TObject);
    procedure actEditPasteUpdate(Sender: TObject);
    procedure actEditDeleteExecute(Sender: TObject);
    procedure actEditDeleteUpdate(Sender: TObject);
    procedure actEditSelectAllExecute(Sender: TObject);
    procedure actEditSelectAllUpdate(Sender: TObject);
    procedure actEditRedoExecute(Sender: TObject);
    procedure actEditRedoUpdate(Sender: TObject);
    procedure actEditUndoExecute(Sender: TObject);
    procedure actEditUndoUpdate(Sender: TObject);
    procedure actSearchFindExecute(Sender: TObject);
    procedure actSearchFindUpdate(Sender: TObject);
    procedure actSearchFindNextExecute(Sender: TObject);
    procedure actSearchFindNextUpdate(Sender: TObject);
    procedure actSearchFindPrevExecute(Sender: TObject);
    procedure actSearchFindPrevUpdate(Sender: TObject);
    procedure actSearchReplaceExecute(Sender: TObject);
    procedure actSearchReplaceUpdate(Sender: TObject);
    procedure DoSearchReplaceText(AReplace: boolean;  ABackwards: boolean);
    procedure ShowSearchReplaceDialog(AReplace: boolean);
    procedure FindDialogFind(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure tbSpecClick(Sender: TObject);
    procedure ReplaceDialogFind(Sender: TObject);
    procedure SynEditorExit(Sender: TObject);
    procedure FindDialogClose(Sender: TObject);
    procedure tbGlyphClick(Sender: TObject);
    procedure FindDialogShow(Sender: TObject);
    procedure ReplaceDialogShow(Sender: TObject);
    procedure tbColorDialogClick(Sender: TObject);
    procedure btnPipeClick(Sender: TObject);
    procedure SynEditorKeyPress(Sender: TObject; var Key: Char);
    procedure ToolButton4Click(Sender: TObject);
  private
    gsSearchText: string;
    gsReplaceText: string;
    FSVGNode: TXML_Nod;
    procedure SetSVGNode(const Value: TXML_Nod);
  public
    FindCaption:string;
    procedure Apply;
    property SVGNode: TXML_Nod read FSVGNode write SetSVGNode;
    procedure Reset;

  end;


implementation

{$R *.DFM}

uses
   u_MainData, SynEditTypes, frmGlyph, u_ThreadRender, u_PipeForm;

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



{ TSynEditFrame }


// implementation

procedure TSynEditFrame.actEditCutExecute(Sender: TObject);
begin
  SynEditor.CutToClipboard;
end;

procedure TSynEditFrame.actEditCutUpdate(Sender: TObject);
begin
  actEditCut.Enabled := SynEditor.SelAvail and not SynEditor.ReadOnly;
end;

procedure TSynEditFrame.actEditCopyExecute(Sender: TObject);
begin
  SynEditor.CopyToClipboard;
end;

procedure TSynEditFrame.actEditCopyUpdate(Sender: TObject);
begin
  actEditCopy.Enabled := SynEditor.SelAvail;
end;

procedure TSynEditFrame.actEditPasteExecute(Sender: TObject);
var
  Data: THandle;
  TextData: string;
begin
  OpenClipboard(0);
  try
    Data := GetClipboardData(50070);
  finally
    CloseClipboard;
  end;
    if Data <> 0 then
    begin
      try
        SynEditor.Seltext := Utf8Decode(Copy(PAnsiChar(GlobalLock(Data)),1, LocalSize(Data)));
      finally
        GlobalUnlock(Data);
      end;
    end
    else
     SynEditor.PasteFromClipboard;
end;

procedure TSynEditFrame.actEditPasteUpdate(Sender: TObject);
var buf:array[0..255] of Char;
begin
  actEditPaste.Enabled := SynEditor.CanPaste or (GetClipboardFormatName(50070,@buf,256)>0);
end;

procedure TSynEditFrame.actEditDeleteExecute(Sender: TObject);
begin
  SynEditor.SelText := '';
end;

procedure TSynEditFrame.actEditDeleteUpdate(Sender: TObject);
begin
  actEditDelete.Enabled := SynEditor.SelAvail and not SynEditor.ReadOnly;
end;

procedure TSynEditFrame.actEditSelectAllExecute(Sender: TObject);
begin
  SynEditor.SelectAll;
end;

procedure TSynEditFrame.actEditSelectAllUpdate(Sender: TObject);
begin
  actEditSelectAll.Enabled := True;
end;

procedure TSynEditFrame.actEditRedoExecute(Sender: TObject);
begin
  SynEditor.Redo;
end;

procedure TSynEditFrame.actEditRedoUpdate(Sender: TObject);
begin
  actEditRedo.Enabled := SynEditor.CanRedo;
end;

procedure TSynEditFrame.actEditUndoExecute(Sender: TObject);
begin
  SynEditor.Undo;
end;

procedure TSynEditFrame.actEditUndoUpdate(Sender: TObject);
begin
  actEditUndo.Enabled := SynEditor.CanUndo;
end;

procedure TSynEditFrame.actSearchFindExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(False);
end;

procedure TSynEditFrame.actSearchFindUpdate(Sender: TObject);
begin
  actSearchFind.Enabled := True;
end;

procedure TSynEditFrame.actSearchFindNextExecute(Sender: TObject);
begin
  DoSearchReplaceText(False,False);
end;

procedure TSynEditFrame.actSearchFindNextUpdate(Sender: TObject);
begin

  actSearchFindNext.Enabled := gsSearchText<>'';
end;

procedure TSynEditFrame.actSearchFindPrevExecute(Sender: TObject);
begin
  DoSearchReplaceText(False,True);
end;

procedure TSynEditFrame.actSearchFindPrevUpdate(Sender: TObject);
begin
  actSearchFindNext.Enabled := gsSearchText<>'';
end;

procedure TSynEditFrame.actSearchReplaceExecute(Sender: TObject);
begin
  ShowSearchReplaceDialog(True);
end;

procedure TSynEditFrame.actSearchReplaceUpdate(Sender: TObject);
begin
  actSearchReplace.Enabled := not SynEditor.ReadOnly;
end;

procedure TSynEditFrame.Apply;
begin
  if (SVGNode <> nil)and(SynEditor.Modified) then
    SVGNode.Attribute['dekart:replace'] := SynEditor.Text
End;

procedure TSynEditFrame.btnPipeClick(Sender: TObject);
begin
  btnPipe.Down := True;
  if PipeForm.ShowModal=mrOk then
    SynEditor.SelText := '#'+HexColor(PipeForm.AColor);
  SetForegroundWindow(Application.MainForm.Handle);
  btnPipe.Down := False;
end;

procedure TSynEditFrame.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
  DlgOptions: TFindOptions;
begin
  if AReplace then
  begin
    Options := [ssoPrompt, ssoReplace];
    DlgOptions := ReplaceDialog.Options;
  end
  else begin
    Options := [];
    DlgOptions := FindDialog.Options;
  end;
  if frReplaceAll in DlgOptions then
    Include(Options, ssoReplaceAll);
  if ABackwards then
    Include(Options, ssoBackwards);
  if  (frMatchCase in DlgOptions) then
    Include(Options, ssoMatchCase);
  if frWholeWord in DlgOptions then
    Include(Options, ssoWholeWord);
//  if not fSearchFromCaret then
//    Include(Options, ssoEntireScope);
//  if gbSearchSelectionOnly then
 //   Include(Options, ssoSelectedOnly);
  if frWholeWord in DlgOptions  then
    Include(Options, ssoWholeWord);
  if SynEditor.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    if ssoBackwards in Options then
      SynEditor.BlockEnd := SynEditor.BlockBegin
    else
      SynEditor.BlockBegin := SynEditor.BlockEnd;
    SynEditor.CaretXY := SynEditor.BlockBegin;
  end;
end;

procedure TSynEditFrame.FindDialogClose(Sender: TObject);
begin
  Application.MainForm.SetFocus;
end;

procedure TSynEditFrame.FindDialogFind(Sender: TObject);
begin
  gsSearchText:=FindDialog.FindText;
  DoSearchReplaceText(False, not (frDown in FindDialog.Options));
end;

procedure TSynEditFrame.FindDialogShow(Sender: TObject);
var
  Buffer: array[0..255] of Char;
begin
  GetWindowText(FindDialog.Handle, Buffer, SizeOf(Buffer));
  SetWindowText(FindDialog.Handle, PChar(@Buffer)+Findcaption);
end;


procedure TSynEditFrame.ReplaceDialogFind(Sender: TObject);
begin
  gsSearchText:=ReplaceDialog.FindText;
  DoSearchReplaceText(False, False);
end;

procedure TSynEditFrame.ReplaceDialogReplace(Sender: TObject);
begin
  gsSearchText:=ReplaceDialog.FindText;
  gsReplaceText:=ReplaceDialog.ReplaceText;
  DoSearchReplaceText(True, not (frDown in ReplaceDialog.Options));
end;

procedure TSynEditFrame.ReplaceDialogShow(Sender: TObject);
var
  Buffer: array[0..255] of Char;
begin
  GetWindowText(ReplaceDialog.Handle, Buffer, SizeOf(Buffer));
  SetWindowText(ReplaceDialog.Handle, PChar(@Buffer)+Findcaption);
end;

procedure TSynEditFrame.Reset;
begin
  FSVGNode := Nil;
end;

procedure TSynEditFrame.SetSVGNode(const Value: TXML_Nod);
begin
  Apply;
  FSVGNode := Value;
  if SVGNode<>nil then
    SynEditor.Text := SVGNode.Attribute['dekart:replace']
  else
    SynEditor.Text := ''
end;

procedure TSynEditFrame.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TFindDialog;
begin
  if AReplace then
    dlg := ReplaceDialog
  else
    dlg := FindDialog;
  dlg.FindText := gsSearchText;
  ReplaceDialog.ReplaceText := gsReplaceText;
  dlg.Execute();
end;
procedure TSynEditFrame.SynEditorExit(Sender: TObject);
begin
  Apply;
end;

procedure TSynEditFrame.SynEditorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key < #32 then Key:=#0;
  
end;

procedure TSynEditFrame.tbColorDialogClick(Sender: TObject);
begin
  if MainData.dlgColor.Execute then
    SynEditor.SelText := '#'+HexColor(MainData.dlgColor.Color)
end;


procedure TSynEditFrame.tbGlyphClick(Sender: TObject);
begin
  formGlyph.Show;
  formGlyph.cbFont.Items.Text :=
  StringReplace(StringReplace(LocalFonts+FontList,',',^M,[rfReplaceAll]),'"','',[rfReplaceAll]);
  formGlyph.BringToFront;
end;

procedure TSynEditFrame.tbSpecClick(Sender: TObject);
begin
  if tbSpec.Down then
    SynEditor.Options := SynEditor.Options + [eoShowSpecialChars]
  else
    SynEditor.Options := SynEditor.Options - [eoShowSpecialChars]
end;


procedure TSynEditFrame.ToolButton4Click(Sender: TObject);
begin
 if MainData.dlgFont.Execute() then
    SynEditor.Font.Name := MainData.dlgFont.Font.Name
end;

{ TSynXMLSyn }

function TSynXMLSyn.IsIdentChar(AChar: WideChar): Boolean;
begin
  Result := AChar > #32;
end;
const
 MenuName='uSynEditPopupMenu';

procedure TSynEdit.CopyExecute(Sender: TObject);
begin
  Self.CopyToClipboard;
end;

procedure TSynEdit.CopyUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=Self.SelAvail;
end;

procedure TSynEdit.CutExecute(Sender: TObject);
begin
  Self.CutToClipboard;
end;

procedure TSynEdit.CutUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=Self.SelAvail and not Self.ReadOnly;
end;

procedure TSynEdit.DeleteExecute(Sender: TObject);
begin
  Self.SelText := '';
end;

procedure TSynEdit.DeleteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled :=Self.SelAvail and not Self.ReadOnly;
end;

procedure TSynEdit.PasteExecute(Sender: TObject);
begin
 Self.PasteFromClipboard;
end;

procedure TSynEdit.PasteUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.CanPaste;
end;

procedure TSynEdit.RedoExecute(Sender: TObject);
begin
 Self.Redo;
end;

procedure TSynEdit.RedoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.CanRedo;
end;

procedure TSynEdit.SelectAllExecute(Sender: TObject);
begin
 Self.SelectAll;
end;

procedure TSynEdit.SelectAllUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.Lines.Text<>'';
end;

procedure TSynEdit.UndoExecute(Sender: TObject);
begin
 Self.Undo;
end;

procedure TSynEdit.UndoUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled :=Self.CanUndo;
end;

constructor TSynEdit.Create(AOwner: TComponent);
begin
  inherited;
  FActnList:=TActionList.Create(Self);
  FPopupMenu:=TPopupMenu.Create(Self);
  FPopupMenu.Name:=MenuName;
  CreateActns;
  FillPopupMenu(FPopupMenu);
  PopupMenu:=FPopupMenu;
end;

procedure TSynEdit.CreateActns;

 procedure AddActItem(const AText:string;AShortCut : TShortCut;AEnabled:Boolean;OnExecute,OnUpdate:TNotifyEvent);
 Var
    ActionItem  : TAction;
  begin
    ActionItem:=TAction.Create(FActnList);
    ActionItem.ActionList:=FActnList;
    ActionItem.Caption:=AText;
    ActionItem.ShortCut:=AShortCut;
    ActionItem.Enabled :=AEnabled;
    ActionItem.OnExecute :=OnExecute;
    ActionItem.OnUpdate  :=OnUpdate;
  end;

begin
  AddActItem('&Undo',ShortCut(Word('Z'), [ssCtrl]),False,UndoExecute, UndoUpdate);
  AddActItem('&Redo',ShortCut(Word('Z'), [ssCtrl,ssShift]),False,RedoExecute, RedoUpdate);
  AddActItem('-',0,False,nil,nil);
  AddActItem('Cu&t',ShortCut(Word('X'), [ssCtrl]),False,CutExecute, CutUpdate);
  AddActItem('&Copy',ShortCut(Word('C'), [ssCtrl]),False,CopyExecute, CopyUpdate);
  AddActItem('&Paste',ShortCut(Word('V'), [ssCtrl]),False,PasteExecute, PasteUpdate);
  AddActItem('De&lete',0,False,DeleteExecute, DeleteUpdate);
  AddActItem('-',0,False,nil,nil);
  AddActItem('Select &All',ShortCut(Word('A'), [ssCtrl]),False,SelectAllExecute, SelectAllUpdate);
end;

procedure TSynEdit.SetPopupMenu_(const Value: TPopupMenu);
Var
  MenuItem : TMenuItem;
begin
  SynEdit.TSynEdit(Self).PopupMenu:=Value;
  if CompareText(MenuName,Value.Name)<>0 then
  begin
   MenuItem:=TMenuItem.Create(Value);
   MenuItem.Caption:='-';
   Value.Items.Add(MenuItem);
   FillPopupMenu(Value);
  end;
end;

function TSynEdit.GetPopupMenu_: TPopupMenu;
begin
  Result:=SynEdit.TSynEdit(Self).PopupMenu;
end;

destructor TSynEdit.Destroy;
begin
  FPopupMenu.Free;
  FActnList.Free;
  inherited;
end;

procedure TSynEdit.FillPopupMenu(APopupMenu : TPopupMenu);
var
  i        : integer;
  MenuItem : TMenuItem;
begin
  if Assigned(FActnList) then
  for i := 0 to FActnList.ActionCount-1 do
  begin
    MenuItem:=TMenuItem.Create(APopupMenu);
    MenuItem.Action  :=FActnList.Actions[i];
    APopupMenu.Items.Add(MenuItem);
  end;
end;

end.

