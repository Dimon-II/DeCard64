unit u_SynEditFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEditHighlighter,
  SynHighlighterXML, System.Actions, Vcl.ActnList, SynEditMiscClasses,
  SynEditSearch, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin, SynEdit,  SynHighlighterIni, ProfixXML,
  SynEditCodeFolding;
type
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
    pmnuEditor: TPopupMenu;
    lmiEditUndo: TMenuItem;
    lmiEditRedo: TMenuItem;
    N2: TMenuItem;
    lmiEditCut: TMenuItem;
    lmiEditCopy: TMenuItem;
    lmiEditPaste: TMenuItem;
    lmiEditDelete: TMenuItem;
    N1: TMenuItem;
    lmiEditSelectAll: TMenuItem;
    SynEditSearch1: TSynEditSearch;
    ReplaceDialog: TReplaceDialog;
    FindDialog: TFindDialog;
    tbGlyph: TToolButton;
    ToolButton3: TToolButton;
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
  private
    gsSearchText: string;
    gsReplaceText: string;
    FSVGNode: TXML_Nod;
    procedure SetSVGNode(const Value: TXML_Nod);
  public
    procedure Apply;
    property SVGNode: TXML_Nod read FSVGNode write SetSVGNode;

  end;


implementation

{$R *.DFM}

uses
   u_MainData, SynEditTypes, frmGlyph, u_ThreadRender;

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
begin
  SynEditor.PasteFromClipboard
end;

procedure TSynEditFrame.actEditPasteUpdate(Sender: TObject);
begin
  actEditPaste.Enabled := SynEditor.CanPaste;
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

  if frMatchCase in DlgOptions then
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

end.

