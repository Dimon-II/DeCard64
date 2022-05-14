program Decard64;

uses
  Vcl.Forms,
  profixxml in 'src\profixxml.pas',
  resvg in 'src\resvg.pas',
  u_Html2SVG in 'src\u_Html2SVG.pas',
  u_MainData in 'u_MainData.pas' {MainData: TDataModule},
  u_SvgTreeFrame in 'Frames\u_SvgTreeFrame.pas' {SvgTreeFrame: TFrame},
  u_SynEditFrame in 'Frames\u_SynEditFrame.pas' {SynEditFrame: TFrame},
  u_ThreadRender in 'src\u_ThreadRender.pas',
  u_SvgInspectorFrame in 'Frames\u_SvgInspectorFrame.pas' {SvgInspectorFrame: TFrame},
  u_MainForm in 'u_MainForm.pas' {MainForm},
  u_CellEditForm in 'u_CellEditForm.pas' {CellEditForm},
  u_XMLEditForm in 'u_XMLEditForm.pas' {XMLEditForm},
  SynPdf in 'SynPDF\SynPdf.pas',
  frmGlyph in 'Frames\frmGlyph.pas' {formGlyph},
  u_CalcSVG in 'src\u_CalcSVG.pas',
  UMatrix in 'src\UMatrix.pas',
  u_PipeForm in 'u_PipeForm.pas' {PipeForm},
  u_PathEdit in 'src\u_PathEdit.pas' {frmPathEdit};

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
  Application.CreateForm(TfrmPathEdit, frmPathEdit);
  Application.Run;
end.
