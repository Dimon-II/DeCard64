unit u_TraceReplace;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.ExtCtrls,
  SynEditHighlighter, SynHighlighterXML, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls,
  System.Actions, Vcl.ActnList;

type
  TTraceReplForm = class(TForm)
    seResult: TSynEdit;
    SynXMLSyn1: TSynXMLSyn;
    seCell: TSynEdit;
    seRepl: TSynEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    tbrTrace: TToolBar;
    tbTraceTo: TToolButton;
    tbTraceNext: TToolButton;
    tbTraceAll: TToolButton;
    alTrace: TActionList;
    aTraceTo: TAction;
    aTraceNext: TAction;
    aTraceAll: TAction;
    procedure seReplSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure aTraceAllExecute(Sender: TObject);
    procedure aTraceNextExecute(Sender: TObject);
    procedure aTraceToExecute(Sender: TObject);
    procedure seReplGutterGetText(Sender: TObject; aLine: Integer;
      var aText: string);
  private
    { Private declarations }
  public
    { Public declarations }
    Traced:Integer;
    Doing:string;
    procedure Trace(nn:Integer);
  end;

var
  TraceReplForm: TTraceReplForm;

implementation

{$R *.dfm}

uses RegularExpressions;

{ TTraceReplForm }

procedure TTraceReplForm.aTraceAllExecute(Sender: TObject);
begin
  Trace(seRepl.Lines.Count-1)
end;

procedure TTraceReplForm.aTraceNextExecute(Sender: TObject);
begin
  seRepl.CaretY := seRepl.CaretY+1;
  Trace(seRepl.CaretY-1);
end;

procedure TTraceReplForm.aTraceToExecute(Sender: TObject);
begin
  Trace(seRepl.CaretY-1);
end;

procedure TTraceReplForm.seReplGutterGetText(Sender: TObject; aLine: Integer;
  var aText: string);
begin
  if pos('('+IntToStr(Aline)+')',Doing)>0 then
    aText :='>>'+aText;

end;

procedure TTraceReplForm.seReplSpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
begin
  if Line=Traced then
  begin
    Special:=true;
    bg := clHighlight;
  end;
end;

procedure TTraceReplForm.Trace(nn: Integer);
var
  r,n,s,s0,z:string;
  i,deep:integer;
begin
  try
  s := seCell.Text;
  s0 := s;
  Doing := '';
  for i:=0 to nn do
    if Pos('=', seRepl.Lines[i])>0 then
    begin
      n:=Copy(seRepl.Lines[i], 1, Pos('=', seRepl.Lines[i])-1);
      r := copy(seRepl.Lines[i],length(n)+2, Length(seRepl.Lines[i]));
      deep:=0;
      if Pos(WideUpperCase(WideString(n)), WideUpperCase(s)) >0 then
      begin
        if copy(r,1,1)='=' then
          s := StringReplace(s, n, copy(r,2,length(r)) ,[rfReplaceAll])
        else
          s := StringReplace(s, n, r ,[rfReplaceAll, rfIgnoreCase]);
        end
      else
      if copy(r,1,1)='$' then
      repeat
        z:=s;
        InC(deep);
        s := TRegEx.replace(s,n,copy(r,2,length(r)));
      until (z=s)or(deep=32);
      if s0<>s then
        Doing := Doing + '('+IntToStr(i+1)+')';
      s0 := s;
    end;
  s := StringReplace(s, '>', '>'#13#10 ,[rfReplaceAll, rfIgnoreCase]);
//  ToolButton5.Visible := seResult.Text <> s;
  seResult.Text :=s;
  Traced:=nn+1;
  seRepl.Invalidate
  except
    on e:Exception do begin
      seRepl.CaretY := i+1;
      Traced:=i+1;
      MessageDlg('Regex exception row '+IntToStr(i+1)+':'^M +  e.Message,mtError,[mbOk],0);
    end;
  end;
end;

end.
