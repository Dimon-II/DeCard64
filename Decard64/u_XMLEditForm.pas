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
  private
    procedure SetXML(const Value: string);
    function GetXML: string;
    { Private declarations }
  public
    { Public declarations }
    property XML:string read GetXML write SetXML;
  end;

var
  XMLEditForm: TXMLEditForm;

implementation

{$R *.dfm}

{ TXMLEditForm }

function TXMLEditForm.GetXML: string;
begin
  result := trim(SynEditFrame.SynEditor.Text);

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
