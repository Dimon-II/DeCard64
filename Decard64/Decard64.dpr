program Decard64;

uses
  Vcl.Forms,
  profixxml in 'src\profixxml.pas',
  {$IFDEF WIN32}
  resvg in 'src32\resvg.pas',
  {$ELSE}
  resvg in 'src\resvg.pas',
  u_ThreadRender in 'src\u_ThreadRender.pas',
  {$ENDIF WIN32}
  u_Html2SVG in 'src\u_Html2SVG.pas',
  u_MainData in 'u_MainData.pas' {MainData: TDataModule},
  u_SvgTreeFrame in 'Frames\u_SvgTreeFrame.pas' {SvgTreeFrame: TFrame},
  u_SynEditFrame in 'Frames\u_SynEditFrame.pas' {SynEditFrame: TFrame},
  u_SvgInspectorFrame in 'Frames\u_SvgInspectorFrame.pas' {SvgInspectorFrame: TFrame},
  u_MainForm in 'u_MainForm.pas' {MainForm},
  u_CellEditForm in 'u_CellEditForm.pas' {CellEditForm},
  u_XMLEditForm in 'u_XMLEditForm.pas' {XMLEditForm},
  SynPdf in 'SynPDF\SynPdf.pas',
  frmGlyph in 'Frames\frmGlyph.pas' {formGlyph},
  u_CalcSVG in 'src\u_CalcSVG.pas',
  UMatrix in 'src\UMatrix.pas',
  u_PipeForm in 'u_PipeForm.pas' {PipeForm},
  u_PathEdit in 'src\u_PathEdit.pas' {frmPathEdit},
  u_ForeignObject in 'src\u_ForeignObject.pas',
  u_TraceReplace in 'u_TraceReplace.pas' {TraceReplForm},
  HunSpellLib in 'HunSpell\HunSpellLib.pas',
  SynEditSpell in 'HunSpell\SynEditSpell.pas',
  u_GridSearch in 'u_GridSearch.pas' {GridSearch};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainData, MainData);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCellEditForm, CellEditForm);
  Application.CreateForm(TXMLEditForm, XMLEditForm);
  Application.CreateForm(TformGlyph, formGlyph);
  Application.CreateForm(TPipeForm, PipeForm);
  Application.CreateForm(TfrmPathEdit, frmPathEdit);
  Application.CreateForm(TTraceReplForm, TraceReplForm);
  Application.CreateForm(TGridSearch, GridSearch);
  Application.Run;
end.
