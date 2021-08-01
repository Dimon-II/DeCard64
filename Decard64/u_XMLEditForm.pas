unit u_XMLEditForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, u_SvgTreeFrame, u_SynEditFrame,
  Vcl.StdCtrls, Vcl.ExtCtrls, SynEdit, SynMemo;

type
  TXMLEditForm = class(TForm)
    pnBottom: TPanel;
    btnApply: TButton;
    btnCancel: TButton;
    pnEdit: TPanel;
    SynEditFrame: TSynEditFrame;
    seTags: TSynMemo;
    splTags: TSplitter;
    procedure FormCreate(Sender: TObject);
  private
    procedure SetXML(const Value: string);
    function GetXML: string;
    function GetText: string;
    procedure SetText(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property XML:string read GetXML write SetXML;
    property TEXT:string read GetText write SetText;
  end;

var
  XMLEditForm: TXMLEditForm;

implementation

{$R *.dfm}

{ TXMLEditForm }

procedure TXMLEditForm.FormCreate(Sender: TObject);
begin
  SynEditFrame.FindCaption := ': SVG/XML '
end;

function TXMLEditForm.GetText: string;
begin
  Result := StringReplace(SynEditFrame.SynEditor.Text, #13#10,'',[rfReplaceAll]);
  Result := StringReplace(Result, '  ',' ',[rfReplaceAll]) ;
end;

function TXMLEditForm.GetXML: string;
begin
  result := trim(SynEditFrame.SynEditor.Text);
end;

procedure TXMLEditForm.SetText(const Value: string);
var s: string;
begin

  s := StringReplace(Value, '<br/>', #13#10'<br/>',[rfreplaceall]);
  s := StringReplace(s, '<br ', #13#10'<br ',[rfreplaceall]);
  s := StringReplace(s, '<p/>', #13#10'<p/>',[rfreplaceall]);
  s := StringReplace(s, '<p ', #13#10'<p ',[rfreplaceall]);
  s := StringReplace(s, '&#47;', '/',[rfreplaceall]);
  SynEditFrame.SynEditor.Text := s;
end;

procedure TXMLEditForm.SetXML(const Value: string);
var i:integer;
  s,s1,sp:string;
  sl:TStringList;
  AWrap:Boolean;
begin
  sl := TStringList.create;
  AWrap := false;
  sl.text := Value;
  for i := sl.Count-1 downto 0 do
  begin
    s:=sl[i];
    if (Copy(Trim(s), 1, 1)='<') and (Copy(Trim(s), 2, 1)<>'/') then
    begin
      sp := Copy(s,1,Pos('<',s)-1) + StringOfChar(' ',Pos(' ', Trim(s) ));
      s1 := Copy(s,Pos('>', s+'>')+1,Length(s));
      s := Copy(s,1, Pos('>', s+'>'));

      sl[i] := StringReplace(s,'" ','"'#13#10+sp,[rfReplaceAll]) + s1;

    end;
    if Length(sl[i])>1024 then AWrap  := True;
  end;
  SynEditFrame.SynEditor.WordWrap := AWrap;
  SynEditFrame.SynEditor.Text := sl.Text;
  sl.free;
end;

end.
