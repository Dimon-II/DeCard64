unit u_SvgTreeFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, profixxml, Vcl.ComCtrls,
  Vcl.ToolWin, Vcl.Menus, System.UITypes, Vcl.ExtCtrls;

type
  TSvgTreeFrame = class(TFrame)
    pmAddTag: TPopupMenu;
    miPasteTag: TMenuItem;
    N9: TMenuItem;
    miRect: TMenuItem;
    miEllipse: TMenuItem;
    miImage: TMenuItem;
    miUse: TMenuItem;
    miText: TMenuItem;
    mig: TMenuItem;
    misymbol: TMenuItem;
    N2: TMenuItem;
    midefs: TMenuItem;
    mimask: TMenuItem;
    clipPath1: TMenuItem;
    milinearGradient: TMenuItem;
    miradialGradient: TMenuItem;
    mistop: TMenuItem;
    mifilter: TMenuItem;
    miShadow: TMenuItem;
    miGlowing: TMenuItem;
    miGlowcolor: TMenuItem;
    miTurbulence: TMenuItem;
    N1: TMenuItem;
    miforeignObject: TMenuItem;
    N8: TMenuItem;
    micutting: TMenuItem;
    miOuterCross: TMenuItem;
    miInnerCrss: TMenuItem;
    pmFileSVG: TPopupMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Clear1: TMenuItem;
    treeTemplate: TTreeView;
    svgFindDialog: TFindDialog;
    miPattert: TMenuItem;
    pscrTemplate: TPageScroller;
    tbrTemplate: TToolBar;
    ToolButton37: TToolButton;
    ToolButton3: TToolButton;
    btnNewObject: TToolButton;
    tbCopyTag: TToolButton;
    btn10: TToolButton;
    btnUp: TToolButton;
    btnDown: TToolButton;
    btnSearch1: TToolButton;
    tbXML: TToolButton;
    pnFindRemind: TPanel;
    pnRemindDialog: TPanel;
    procedure treeTemplateCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure tbXMLClick(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure btnSearch1Click(Sender: TObject);
    procedure svgFindDialogFind(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure svgFindDialogClose(Sender: TObject);
    procedure tbCopyTagClick(Sender: TObject);
    procedure pmAddTagPopup(Sender: TObject);
    procedure miPasteTagClick(Sender: TObject);
    procedure miRectClick(Sender: TObject);
    procedure miEllipseClick(Sender: TObject);
    procedure miImageClick(Sender: TObject);
    procedure miUseClick(Sender: TObject);
    procedure miTextClick(Sender: TObject);
    procedure migClick(Sender: TObject);
    procedure misymbolClick(Sender: TObject);
    procedure midefsClick(Sender: TObject);
    procedure mimaskClick(Sender: TObject);
    procedure clipPath1Click(Sender: TObject);
    procedure milinearGradientClick(Sender: TObject);
    procedure miradialGradientClick(Sender: TObject);
    procedure mistopClick(Sender: TObject);
    procedure miforeignObjectClick(Sender: TObject);
    procedure miShadowClick(Sender: TObject);
    procedure miGlowingClick(Sender: TObject);
    procedure miGlowcolorClick(Sender: TObject);
    procedure miTurbulenceClick(Sender: TObject);
    procedure miOuterCrossClick(Sender: TObject);
    procedure miInnerCrssClick(Sender: TObject);
    procedure miPattertClick(Sender: TObject);
    procedure svgFindDialogShow(Sender: TObject);
  private
    { Private declarations }
    FSVG: TXML_Doc;
    FFindAttr: string;
    FOnResizeClick: TNotifyEvent;
    FFrameSize: integer;
    procedure SetSVG(const Value: TXML_Doc);
    procedure SetFocusedNode(const Value: TTreeNode);
    procedure SetSVGNode(const Value: TXML_Nod);
    function GetFocusedNode: TTreeNode;
    function GetSVGNode: TXML_Nod;
    procedure SetFrameSize(const Value: integer);
  public
    { Public declarations }
    Findcaption: string;
    procedure ResetSvg(ANode:TXML_Nod; AItem:TTreeNode);
    property SVG: TXML_Doc read FSVG write SetSVG;
    property FocusedNode:TTreeNode read GetFocusedNode write SetFocusedNode;
    property SVGNode:TXML_Nod read GetSVGNode write SetSVGNode;
    property FindAttr:string read FFindAttr write FFindAttr;
    property OnResizeClick: TNotifyEvent read FOnResizeClick write FOnResizeClick;
    property FrameSize:integer read FFrameSize write SetFrameSize;
    procedure InsertTag(AXML:string);
  published

  end;

implementation

{$R *.dfm}

uses u_MainData, u_XMLEditForm;

var
  StoredTag:string;
  StoredCaption:string;

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

{ TSvgTreeFrame }


procedure TSvgTreeFrame.btn10Click(Sender: TObject);
var
  nod,n1:TTreeNode;
begin
  nod := treeTemplate.Selected;
  if nod = nil then exit;
  if nod.Level = 0 then exit;
  if MessageDlg('Delete <'+  nod.Text+'> ('+IntToStr(nod.Count)+ ' childs)?',
               mtConfirmation, [mbYes, mbNo], 0) <> mrYes
  then Exit;

  n1 := nod.GetNext;
  if n1=nil then
    n1 := nod.GetPrev;
  n1.Focused := True;
  n1.Selected := True;
  TXML_Nod(nod.Data).Destroy;
  nod.Free;
end;

procedure TSvgTreeFrame.btnDownClick(Sender: TObject);
var
  nod,n1:TTreeNode;
  localname :string;
  nx:TXML_Nod;
begin

  nod := treeTemplate.Selected;
  if nod = nil then exit;
  if nod.Level = 0 then exit;

  if (nod.GetNext = nil)  then
  begin
    if (nod.Level>1) then
    begin
      nod.MoveTo(nod.Parent.Parent, naAddChild);
      TXML_Nod(nod.Data).parent := TXML_Nod(nod.Parent.Data);
      TXML_Nod(nod.Data).index := nod.Index;
    end;
    exit;
  end;

  localname := TXML_Nod(nod.Data).LocalName;
  n1 := nod.GetNext;

  while (n1.GetNext<> nil) and (n1.Level>nod.Level) do
    n1 := n1.GetNext;

  if (n1.Level>nod.Level) then
  begin
    if (nod.Level>1) then
    begin
      nod.MoveTo(nod.Parent.Parent, naAddChild);
      TXML_Nod(nod.Data).parent := TXML_Nod(nod.Parent.Data);
      TXML_Nod(nod.Data).index := nod.Index;
    end;
    exit;
  end;

  nx:= TXML_Nod(n1.data);

  if (n1.level = nod.Level)
    and (n1.Expanded or not n1.HasChildren)
    and ((nx.LocalName='g')
          or (nx.LocalName='symbol')
          or (nx.LocalName='defs')
          or (nx.LocalName='clipPath')
          or (nx.LocalName='mask')
          or (nx.LocalName='pattern')
          or (nx.LocalName='filter')
          or ((nx.LocalName='linearGradient') and (localname='stop'))
          or ((nx.LocalName='radialGradient') and (localname='stop'))
          or ((nx.LocalName='text') and ((localname='tspan')or(localname='textpath')or(localname='rect')))
        )
  then
    nod.MoveTo(n1, naAddChildFirst)
  else
  if n1.Level = nod.Level  then
  begin begin
    n1.MoveTo(nod, naInsert);
    TXML_Nod(n1.Data).parent := TXML_Nod(n1.Parent.Data);
    TXML_Nod(n1.Data).index := n1.Index;
  end
  end
  else begin
    nod.MoveTo(nod.Parent, naAdd);
    nod.MoveTo(n1, naInsert);
  end;

  TXML_Nod(nod.Data).parent := TXML_Nod(nod.Parent.Data);
  TXML_Nod(nod.Data).index := nod.Index;
end;

procedure TSvgTreeFrame.btnSearch1Click(Sender: TObject);
begin
  svgFindDialog.Execute(treeTemplate.Handle);

  pnFindRemind.Visible := True;
  pnRemindDialog.Visible := True;
  pnRemindDialog.Parent := pnFindRemind;
  pnRemindDialog.Top :=0;
  Winapi.Windows.SetParent(pnRemindDialog.handle, svgFindDialog.Handle);
end;

procedure TSvgTreeFrame.btnUpClick(Sender: TObject);
var localname:string;
  row,prw:TTreeNode;
begin
  if (treeTemplate.Selected = Nil) then exit;

  if (treeTemplate.Selected.AbsoluteIndex <2) then exit;

  row := treeTemplate.Selected;
  prw := treeTemplate.Selected.GetPrev;
  localname := TXML_Nod(row.Data).LocalName;

  while (prw.AbsoluteIndex >1) and (prw.Level>row.Level) do
    prw := prw.GetPrev;

  if prw.Level<row.Level then
     row.MoveTo(prw, naInsert)
  else
  if (prw.Level=row.Level) and (prw.Expanded) then
    row.MoveTo(prw, naAddChild)
  else
    row.MoveTo(prw, naInsert);


  TXML_Nod(row.Data).parent := TXML_Nod(row.Parent.Data);
  TXML_Nod(row.Data).index := row.Index;
end;

procedure TSvgTreeFrame.Clear1Click(Sender: TObject);
begin
  if SVG.Nodes.ByName('svg') <> nil then
    if SVG.Node['svg'].Nodes.Count>0 then
      if MessageDlg('Clear template>?',mtConfirmation	,
        [mbYes, mbNo], 0) <> mrYes then Exit;
  SVG.xml := '<?xml version="1.0" encoding="UTF-8"?>'^M
    + '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">'^M
    + '<svg fill-opacity="1" xmlns:xlink="http://www.w3.org/1999/xlink" color-rendering="auto" '
    + 'color-interpolation="auto" text-rendering="auto" stroke="black" '
    + 'stroke-linecap="square" stroke-miterlimit="10" shape-rendering="auto" stroke-opacity="1" '
    + 'fill="white" stroke-dasharray="none" font-weight="normal" stroke-width="1" '
    + 'xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" '
    + 'xmlns:template="127.0.0.1" xmlns:dekart="127.0.0.1" '
    + 'xmlns="http://www.w3.org/2000/svg" font-size="12" image-rendering="auto" width="525" height="744">'
    + '</svg>';
  SVG := SVG;
end;

procedure TSvgTreeFrame.clipPath1Click(Sender: TObject);
begin
  InsertTag('<clipPath/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

function TSvgTreeFrame.GetFocusedNode: TTreeNode;
begin
  Result := treeTemplate.Selected
end;

function TSvgTreeFrame.GetSVGNode: TXML_Nod;
begin
  if FocusedNode<>nil then
    Result := FocusedNode.Data
  else
    Result := nil;
end;

procedure TSvgTreeFrame.InsertTag(AXML: string);
var
  nod:TXML_Nod;
  TreNod:TTreeNode;
begin
  if  (SVGNode.LocalName='svg')
   or ((SVGNode.LocalName='linearGradient')and (pos('<stop', AXML)=1))
   or ((SVGNode.LocalName='radialGradient')and (pos('<stop', AXML)=1))
   or ((SVGNode.LocalName='filter') and (pos('<fe', AXML)=1))
  then begin
    TreNod := treeTemplate.Items.AddChild(FocusedNode,'');
    nod:=SVGNode.Add;
  end
  else
  begin
    nod := SVGNode.parent.Add;
    nod.index := SVGNode.index;
    TreNod := treeTemplate.Items.Add(FocusedNode,'');
    TreNod.MoveTo(FocusedNode,naInsert);
  end;
  nod.ResetXml(AXML);
  //nod.xml := AXML;
  ResetSvg(nod, TreNod);

  TreNod.Selected := True;
  TreNod.Focused := True;
  TreNod.MakeVisible;

end;

procedure TSvgTreeFrame.midefsClick(Sender: TObject);
begin
  InsertTag('<defs/>');

end;

procedure TSvgTreeFrame.miEllipseClick(Sender: TObject);
begin
  InsertTag('<ellipse/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.miforeignObjectClick(Sender: TObject);
begin
  InsertTag('<foreignObject/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.migClick(Sender: TObject);
begin
  InsertTag('<g/>');

end;

procedure TSvgTreeFrame.miGlowcolorClick(Sender: TObject);
begin
  if MainData.dlgColor.Execute then
  begin
    InsertTag('<filter id="fltGlowColor">'
			+ '<feFlood result="flood" flood-color="#'+HexColor(MainData.dlgColor.Color)+'" flood-opacity="0.8"/>'
			+ '<feComposite in="flood" result="mask" in2="SourceGraphic" operator="in"/>'
			+ '<feMorphology in="mask" result="dilated" operator="dilate" radius="2"/>'
			+ '<feGaussianBlur in="dilated" result="blurred" stdDeviation="2.5"/>'
			+ '<feMerge><feMergeNode in="blurred"/><feMergeNode in="SourceGraphic"/></feMerge>'
      + '</filter>');
  end;

end;

procedure TSvgTreeFrame.miGlowingClick(Sender: TObject);
begin
  InsertTag('<filter id="fltGlowing">'
    + '<feGaussianBlur stdDeviation="2.5" result="coloredBlur"/>'
    + '<feMerge><feMergeNode in="coloredBlur"/><feMergeNode in="SourceGraphic"/></feMerge>'
    + '</filter>');
end;

procedure TSvgTreeFrame.miImageClick(Sender: TObject);
begin
  InsertTag('<image/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.miInnerCrssClick(Sender: TObject);
begin
  if MainData.dlgColor.Execute then
  begin
    SVGNode := SVG.Node['svg'];
    InsertTag('<g id="Cutting1" stroke="#'+HexColor(MainData.dlgColor.Color)+'" stroke-width="2">'
    + '<symbol id="cut-cross"><line x1="0" x2="0" y1="-30" y2="30"/><line x1="-30" x2="30" y1="0" y2="0"/></symbol>'
	  + '<use xlink:href="#cut-cross" x="'+IntToStr(FFrameSize)+'" y="'+IntToStr(FFrameSize)+'"/>'
    + '<use xlink:href="#cut-cross" x="'+IntToStr(StrToIntDef(SVG.Node['svg'].Attribute['width'],100)-FFrameSize)+'" y="'+IntToStr(FFrameSize)+'"/>'
	  + '<use xlink:href="#cut-cross" x="'+IntToStr(FFrameSize)+'" y="'+IntToStr(StrToIntDef(SVG.Node['svg'].Attribute['height'],100)-FFrameSize)+'"/>'
		+ '<use xlink:href="#cut-cross" x="'+IntToStr(StrToIntDef(SVG.Node['svg'].Attribute['width'],100)-FFrameSize)+'" y="'+IntToStr(StrToIntDef(SVG.Node['svg'].Attribute['height'],100)-FFrameSize)+'"/></g>');
  end;
end;

procedure TSvgTreeFrame.milinearGradientClick(Sender: TObject);
begin
  InsertTag('<linearGradient><stop/></linearGradient>');
end;

procedure TSvgTreeFrame.mimaskClick(Sender: TObject);
begin
  InsertTag('<mask/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.miOuterCrossClick(Sender: TObject);
begin
  if MainData.dlgColor.Execute then
  begin
    SVGNode := SVG.Node['svg'];
    InsertTag('<g id="Cutting1" stroke="#'+HexColor(MainData.dlgColor.Color)+'" stroke-width="2">'
    + '<symbol id="cut-cross"><line x1="0" x2="0" y1="-30" y2="30"/><line x1="-30" x2="30" y1="0" y2="0"/></symbol>'
		+ '<use xlink:href="#cut-cross" x="0" y="0"/>'
		+ '<use xlink:href="#cut-cross" x="'+SVG.Node['svg'].Attribute['width']+'" y="0"/>'
		+ '<use xlink:href="#cut-cross" x="0" y="'+SVG.Node['svg'].Attribute['height']+'"/>'
		+ '<use xlink:href="#cut-cross" x="'+SVG.Node['svg'].Attribute['width']+'" y="'+SVG.Node['svg'].Attribute['height']+'"/></g>');
  end;
end;

procedure TSvgTreeFrame.miPasteTagClick(Sender: TObject);
begin
  if StoredTag<>'' then
    InsertTag(StoredTag);
end;

procedure TSvgTreeFrame.miPattertClick(Sender: TObject);
begin
  InsertTag('<clipPath/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.miradialGradientClick(Sender: TObject);
begin
  InsertTag('<radialGradient><stop/></radialGradient>');

end;

procedure TSvgTreeFrame.miRectClick(Sender: TObject);
begin
  InsertTag('<rect/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);

end;

procedure TSvgTreeFrame.miShadowClick(Sender: TObject);
begin
  InsertTag('<filter id="fltShadow" x="0" y="0" width="200%" height="200%">'
		+ '	<feOffset result="offOut" in="SourceAlpha" dx="3" dy="3"/>'
		+ '	<feGaussianBlur result="blurOut" in="offOut" stdDeviation="2.5"/>'
		+ '	<feBlend in="SourceGraphic" in2="blurOut" mode="normal"/>'
    + '</filter>');
end;

procedure TSvgTreeFrame.miTurbulenceClick(Sender: TObject);
begin
  InsertTag('<filter id="fltTurbulence">'
    + '<feTurbulence type="turbulence" baseFrequency="0.02" numOctaves="3" result="turbulence"/>'
    + '<feDisplacementMap in2="turbulence" in="SourceGraphic" scale="50" xChannelSelector="R" yChannelSelector="G"/>'
    + '</filter>')
end;

procedure TSvgTreeFrame.mistopClick(Sender: TObject);
begin
  InsertTag('<stop/>');

end;

procedure TSvgTreeFrame.misymbolClick(Sender: TObject);
begin
  InsertTag('<symbol/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.miTextClick(Sender: TObject);
begin
  InsertTag('<text/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.miUseClick(Sender: TObject);
begin
  InsertTag('<use/>');
  if @FOnResizeClick<>nil then
    OnResizeClick(Sender);
end;

procedure TSvgTreeFrame.pmAddTagPopup(Sender: TObject);
begin
   miPasteTag.Caption := 'Paste: '+StoredCaption;
   miPasteTag.OnClick :=  miPasteTagClick;
end;

procedure TSvgTreeFrame.ResetSvg(ANode: TXML_Nod; AItem: TTreeNode);
var
  i:integer;
begin
  AItem.Text := ANode.Attribute['id']+': '+ANode.LocalName;
  AItem.Data := ANode;
  AItem.DeleteChildren;
//  ShowMessage(IntToStr(ANode.Nodes.count));
  for i := 0 to ANode.Nodes.Count-1 do
     ResetSvg(ANode.Nodes[i], treeTemplate.Items.AddChild(AItem,''))


end;

procedure TSvgTreeFrame.SetFocusedNode(const Value: TTreeNode);
begin
  treeTemplate.Selected := Value;
  if treeTemplate.Selected<>nil then
    treeTemplate.Selected.MakeVisible;
end;

procedure TSvgTreeFrame.SetFrameSize(const Value: integer);
begin
  FFrameSize := Value;
end;

procedure TSvgTreeFrame.SetSVG(const Value: TXML_Doc);
begin
  FSVG := Value;
  if SVG.Nodes.ByName('svg') = nil then
    Clear1Click(nil);
  treeTemplate.Items.Clear;
  ResetSvg(FSVG.Node['svg'], treeTemplate.Items.AddFirst(nil,''));
  treeTemplate.Items[0].Expand(False);

  treeTemplate.Items[0].Selected := True;
  treeTemplate.Items[0].Focused := True;

end;

procedure TSvgTreeFrame.SetSVGNode(const Value: TXML_Nod);
var nod:TTreeNode;
begin
  nod := treeTemplate.Items.GetFirstNode;
  while Assigned(nod) do
  begin
    if nod.Data = Value then break;
    nod := nod.GetNext;
  end;

  if Nod<>nil then
     FocusedNode := Nod;
end;

procedure TSvgTreeFrame.svgFindDialogClose(Sender: TObject);
begin
  FFindAttr := '';
  Application.MainForm.SetFocus;
  pnFindRemind.Visible := False;
end;

procedure TSvgTreeFrame.svgFindDialogFind(Sender: TObject);
var
   Nod:TTreeNode;
   XML:TXML_Nod;
   i:integer;

   function Compare(txt:string):Boolean;
   var
     s1,s2:string;
   begin
     if (frMatchCase in svgFindDialog.Options) then
     begin
       s1 := svgFindDialog.FindText;
       s2 := txt;
     end
     else
     begin
       s1 := WideUpperCase(svgFindDialog.FindText);
       s2 := WideUpperCase(txt);
     end;
     if frWholeWord in svgFindDialog.Options then
       result := s1 = s2
     else
       result := pos(s1,s2)>0;

     if result then
     begin
       Nod.Selected := True;
       Nod.Focused := True;
       Nod.MakeVisible;
       abort;
     end;
   end;

begin
  Nod := treeTemplate.Selected;
  if (Nod = nil) then
    Nod := treeTemplate.Items[0];

  while True do
  begin
    if frDown in svgFindDialog.Options then
      Nod := Nod.GetNext
    else
      Nod := Nod.GetPrev;

    if Nod = nil then break;

    XML:=Nod.Data;

    Compare(XML.LocalName);
    FFindAttr := 'text';

    Compare(XML.Text);

    for i := 0 to XML.Attributes.Count-1 do
    begin
      FFindAttr := XML.Attributes[i].name;
      Compare(XML.Attributes[i].value);
    end;
    FFindAttr := '';
  end;
end;

procedure TSvgTreeFrame.svgFindDialogShow(Sender: TObject);
var
  Buffer: array[0..255] of Char;
begin
  GetWindowText(svgFindDialog.Handle, Buffer, SizeOf(Buffer));
  SetWindowText(svgFindDialog.Handle, PChar(@Buffer)+FindCaption);
end;

procedure TSvgTreeFrame.tbXMLClick(Sender: TObject);
begin
  XMLEditForm.XML := SVGNode.xml;
  XMLEditForm.seTags.Visible := False;
  XMLEditForm.splTags.Visible := False;
  if XMLEditForm.ShowModal=mrOk then
  begin
    SVGNode.ResetXml(XMLEditForm.XML);
    ResetSvg(SVGNode, FocusedNode);
    FocusedNode.Expand(False);
    treeTemplate.OnChange(treeTemplate, FocusedNode);
  end;
end;

procedure TSvgTreeFrame.tbCopyTagClick(Sender: TObject);
begin
  StoredTag := SVGNode.xml;
  StoredCaption := '<'+SVGNode.LocalName+' id="'+SVGNode.Attribute['id']+'"/>';
end;

procedure TSvgTreeFrame.treeTemplateCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  AllowCollapse := Node.Level>0;
end;

initialization

  StoredCaption := '---';


end.
