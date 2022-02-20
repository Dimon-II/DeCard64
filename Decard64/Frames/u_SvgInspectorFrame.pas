unit u_SvgInspectorFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Profixxml, u_SynEditFrame, Vcl.ToolWin,
  system.UITYpes, System.Actions, Vcl.ActnList;

type
  TStringGrid=class(Vcl.Grids.TStringGrid)
  protected
    function CreateEditor: TInplaceEdit; override;
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; override;
  end;

  TSvgInspectorFrame = class(TFrame)
    pcAtrInspector: TPageControl;
    tsAtr: TTabSheet;
    sgAttr: TStringGrid;
    splInspector: TSplitter;
    meHint: TMemo;
    tsReplace: TTabSheet;
    ReplaceFrame: TSynEditFrame;
    alInspector: TActionList;
    aEdit: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    cbAtrShow: TComboBox;
    tbrInspector: TToolBar;
    tbResize: TToolButton;
    tbEdit: TToolButton;
    ToolButton16: TToolButton;
    tbSetColor: TToolButton;
    tbPipe: TToolButton;
    tbFont: TToolButton;
    tbFileXlink: TToolButton;
    ToolButton28: TToolButton;
    procedure sgAttrSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbAtrShowClick(Sender: TObject);
    procedure pcAtrInspectorChange(Sender: TObject);
    procedure tbSetColorClick(Sender: TObject);
    procedure tbFontClick(Sender: TObject);
    procedure tbFileXlinkClick(Sender: TObject);
    procedure sgAttrDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgAttrSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure aEditExecute(Sender: TObject);
    procedure tsAtrResize(Sender: TObject);
    procedure sgAttrTopLeftChanged(Sender: TObject);
    procedure sgAttrKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbPipeClick(Sender: TObject);
  private
    FSVGNode: TXML_Nod;
    FEditNode: TXML_Nod;
    FFocusedNode: TTreeNode;
    AllAtr:TStringList;
    procedure SetSVGNode(const Value: TXML_Nod);
    { Private declarations }
  public
    { Public declarations }
    property FocusedNode:TTreeNode read FFocusedNode write FFocusedNode;
    property SVGNode:TXML_Nod read FSVGNode write SetSVGNode;
    procedure Initialize;
    procedure SetSize(ARect:TRect);

  end;

function HexColor(Color:TColor):string;

implementation

{$R *.dfm}




uses u_MainData, Vcl.Themes, u_XMLEditForm, u_MainForm, u_ThreadRender,
  u_Html2SVG , u_PipeForm;



type
  THackCombo=class(TComboBox);


  THackInplaceEditList=class(TInplaceEditList)
  protected
    procedure DoGetPickListItems; override;
  end;

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

function ColorHex(C:string):TColor;
begin
   if Length(C) = 4 then
     result:=rgb(StrToIntDef('$'+C[2]+'0',0),StrToIntDef('$'+C[3]+'0',0),StrToIntDef('$'+C[4]+'0',0))
   else
   if Length(C) = 7 then
     result:=rgb(StrToIntDef('$'+C[2]+C[3],0),StrToIntDef('$'+C[4]+C[5],0),StrToIntDef('$'+C[6]+C[7],0))
   else
     result:=0;
end;


procedure TSvgInspectorFrame.aEditExecute(Sender: TObject);
var
  s:string;
begin
  if sgAttr.Col < 2 then exit;
  if (sgAttr.Col = 3) and (sgAttr.Cells[0,sgAttr.Row]='id') then exit;
  if (sgAttr.Col = 2) and (sgAttr.Cells[0,sgAttr.Row]='body') then exit;

  s := sgAttr.Cells[0,sgAttr.Row];
  if sgAttr.Col=3 then
    s:='dekard:'+s;


  if sgAttr.Cells[0,sgAttr.Row]='body' then
  begin
    XMLEditForm.seTags.Visible := True;
    XMLEditForm.splTags.Visible := True;
    XMLEditForm.splTags.top :=1;
    XMLEditForm.TEXT := sgAttr.Cells[sgAttr.Col,sgAttr.Row];
  end
  else
  begin
    XMLEditForm.seTags.Visible := False;
    XMLEditForm.splTags.Visible := False;
    XMLEditForm.SynEditFrame.SynEditor.Text := sgAttr.Cells[sgAttr.Col,sgAttr.Row];
  end;


  XMLEditForm.Caption := '<'+SVGNode.LocalName+'>.'+s;
  if XMLEditForm.ShowModal=mrOk then
  begin
    if sgAttr.Cells[0,sgAttr.Row]='body' then
      sgAttr.Cells[sgAttr.Col,sgAttr.Row] := XMLEditForm.TEXT
    else
      sgAttr.Cells[sgAttr.Col,sgAttr.Row] := StringReplace(XMLEditForm.XML,#13#10,'',[rfReplaceAll]);
    sgAttrSetEditText(sgAttr,sgAttr.Col, sgAttr.Row,sgAttr.Cells[sgAttr.Col,sgAttr.Row] );
  end;
end;

procedure TSvgInspectorFrame.cbAtrShowClick(Sender: TObject);
var
  s:string;
  tp:integer;
begin
  s := sgAttr.Cells[0,sgAttr.Row];
  tp:=sgAttr.TopRow;
  SetSVGNode(SVGNode);
  if tp<sgAttr.RowCount-1 then
    sgAttr.TopRow := tp;
  tp := sgAttr.Cols[0].IndexOf(s);
  if tp<>-1 then
    sgAttr.Row := tp;

end;

procedure TSvgInspectorFrame.Initialize;
var i:integer;
begin
  sgAttr.Rows[0].CommaText := '"  NAME","  PARENT","  VALUE","  OVERRIDE"';
  sgAttr.ColWidths[0]:=120;
  sgAttr.ColWidths[1]:=60;
  sgAttr.ColWidths[2]:=100;
  sgAttr.ColWidths[3]:=150;
  sgAttr.Rows[1].Text := '';
  AllAtr:=TStringList.Create;
  AllAtr.Sorted := True;

  for i := 0  to MainData.HLP.Node['config'].Node['grouping'].Nodes.Count-1 do
    cbAtrShow.Items.Add(MainData.HLP.Node['config'].Node['grouping'].Nodes[i].LocalName);
  cbAtrShow.ItemIndex := 2;
end;

procedure TSvgInspectorFrame.pcAtrInspectorChange(Sender: TObject);
begin
//    tsReplace.SetText(SVGNode.Attribute['dekart:replace'], False);
  ReplaceFrame.SynEditor.ReadOnly := pcAtrInspector.ActivePage<>tsReplace;
end;


procedure TSvgInspectorFrame.tbPipeClick(Sender: TObject);
var dkr:string;
begin
  tbPipe.Down := True;
  PipeForm.ShowModal;
  tbPipe.Down := False;
  SetForegroundWindow(Application.MainForm.Handle);
  if PipeForm.Modalresult<>mrOk then exit;

  if sgAttr.col=3 then
    dkr:='dekart:'
  else
    dkr:='';

  MainData.dlgColor.Color := PipeForm.AColor;

  if MainData.dlgColor.Execute then
  begin
    if (SVGNode.LocalName='feFlood')or(sgAttr.Cells[0,sgAttr.Row]='flood-color') then
      SVGNode.Attribute[dkr + 'flood-color'] := '#'+HexColor(MainData.dlgColor.Color)
    else
    if  SVGNode.LocalName='stop' then
      SVGNode.Attribute[dkr + 'stop-color'] := '#'+HexColor(MainData.dlgColor.Color)
    else
    if sgAttr.Cells[0,sgAttr.Row]='stroke' then
      SVGNode.Attribute[dkr + 'stroke'] := '#'+HexColor(MainData.dlgColor.Color)
    else
      SVGNode.Attribute[dkr + 'fill'] := '#'+HexColor(MainData.dlgColor.Color);

    cbAtrShowClick(nil);
  end;
end;

procedure TSvgInspectorFrame.SetSize(ARect: TRect);
begin
   if SVGNode.LocalName='svg' then exit;

   if SVGNode.LocalName='text' then
   begin


     SVGNode.Attribute['y']:= IntToStr(Round(ARect.Top+(StrToIntDEf(SVGNode.Attribute['font-size'],10)*0.8)));

     if SVGNode.Attribute['text-anchor']='end' then
        SVGNode.Attribute['x']:= IntToStr(ARect.Right)
     else
     if SVGNode.Attribute['text-anchor']='middle' then
        SVGNode.Attribute['x']:= IntToStr(ARect.Left+ARect.Width div 2)
     else
        SVGNode.Attribute['x']:= IntToStr(ARect.Left);
   end
   else
   with SVGNode do begin

     if SVGNode.LocalName='ellipse' then
     begin
       SVGNode.Attribute['rx']:= IntToStr(ARect.Width div 2);
       SVGNode.Attribute['ry']:= IntToStr(ARect.Height div 2);
     end;


     if AllAtr.IndexOf('x') >-1
        then Attribute['x']:= IntToStr(ARect.Left);

     if AllAtr.IndexOf('y') >-1
        then Attribute['y']:= IntToStr(ARect.Top);

     if AllAtr.IndexOf('width') >-1
        then Attribute['width']:= IntToStr(ARect.Width);

     if AllAtr.IndexOf('height') >-1
        then Attribute['height']:= IntToStr(ARect.Height);

     if AllAtr.IndexOf('cx') >-1
        then Attribute['cx']:= IntToStr(ARect.Left+ARect.Width div 2);

     if AllAtr.IndexOf('cy') >-1
        then Attribute['cy']:= IntToStr(ARect.Top+ARect.Height div 2);

     if AllAtr.IndexOf('x1') >-1
        then Attribute['x1']:= IntToStr(ARect.Left);

     if AllAtr.IndexOf('y1') >-1
        then Attribute['y1']:= IntToStr(ARect.Top);


     if AllAtr.IndexOf('x2') >-1
        then Attribute['x2']:= IntToStr(ARect.Right);

     if AllAtr.IndexOf('y2') >-1
        then Attribute['y2']:= IntToStr(ARect.Bottom);
   end;
   cbAtrShowClick(nil)
end;

procedure TSvgInspectorFrame.SetSVGNode(const Value: TXML_Nod);

  function UrlList(ALocalName:string;AHeap:string=''):string;
  var Nod:TXML_Nod;
  begin
    result := AHeap;
    Nod := SVGNode;
    while Nod.parent <> nil do
      Nod:= Nod.parent;
    repeat
      if (nod.LocalName=ALocalName)and(nod.Attribute['id']<>'') then
      begin
        if result <>'' then
          result := result +',';
        result := result +'url(#'+nod.Attribute['id']+')';
      end;
      nod:=Nod.Next;
    until Nod=nil;
  end;


  procedure AddAtr(Aname, Atype, LocalName:string;nod:TXML_Nod=nil);
  var i,idx1,idx2:integer;
      en,s:string;
  begin
    if Atype='svg:ScriptType' then exit;

    AllAtr.Add(Aname);

    if LocalName<>'svg' then
      if MainData.HLP.Node['config'].Node['exclude'].Nodes.ByName(Aname)<>nil then exit;

    if (Aname='id') then
    begin
    end
    else
    if (LocalName<>'stop') and ((Aname='stop-color')or(Aname='stop-opacity'))  then
      exit
    else

    if (cbAtrShow.ItemIndex=0) then
    begin
    end
    else
    if (cbAtrShow.ItemIndex=1) then
    begin
      if (Aname <> 'text') and
         (Aname <> 'body') and
         (SVGNode.Attribute[Aname]='') and
         (SVGNode.Attribute['dekart:'+StringReplace(Aname,':','_',[rfReplaceall])]='')
      then exit;
    end
    else
    if MainData.HLP.Node['config'].Node['grouping'].Node[cbAtrShow.Text].Nodes.ByName(Aname)=nil then
    exit;

    en := '';

    if Aname = 'preserveAspectRatio' then
      en := 'xMidYMid meet,xMinYMid meet,xMaxYMid meet,xMidYMin slice,xMidYMid slice,xMidYMax slice,xMidYMin meet,xMidYMid meet,xMidYMax meet,xMinYMid slice,xMidYMid slice,xMaxYMid slice,none';

    if Aname = 'decard-baseline' then
      en := '80%,100%';

    if nod <> nil then
    begin
      for i:=0 to nod.Nodes.Count-1 do
        if nod.Nodes[i].LocalName='enumeration' then
        begin
            en := en + s + nod.Nodes[i].Attribute['value'];
            s:=','
        end;
    end;


    if (Aname='fill')or (Aname='stroke') then
      en:=UrlList('linearGradient',UrlList('radialGradient',UrlList('pattern',en)))
    else
    if (Aname='clip-path') then
      en:=UrlList('clipPath',en)
    else
    if (Aname='mask') then
      en:=UrlList('mask',en)
    else
    if (Aname='filter') then
      en:=UrlList('filter',en);





    if sgAttr.Cells[0,sgAttr.RowCount-1]<>'' then
        sgAttr.RowCount := sgAttr.RowCount+1;

    sgAttr.Cells[0,sgAttr.RowCount-1] := AName;
    sgAttr.Cells[1,sgAttr.RowCount-1] := '';
    sgAttr.Cells[2,sgAttr.RowCount-1] := '';
    sgAttr.Cells[3,sgAttr.RowCount-1] := '';
    sgAttr.Cells[4,sgAttr.RowCount-1] := en;


    if MainData.HLP.Node['config'].Node['sorting'].Nodes.ByName(Aname)<>nil then
      idx1 := MainData.HLP.Node['config'].Node['sorting'].Nodes.ByName(Aname).index
    else
      idx1 := MainData.HLP.Node['config'].Node['sorting'].Nodes.Count +    AllAtr.IndexOf(Aname);
    for I := 1 to sgAttr.RowCount-1 do
    begin
      if MainData.HLP.Node['config'].Node['sorting'].Nodes.ByName(sgAttr.Cells[0,i])<>nil then
        idx2 := MainData.HLP.Node['config'].Node['sorting'].Nodes.ByName(sgAttr.Cells[0,i]).index
      else
        idx2 := MainData.HLP.Node['config'].Node['sorting'].Nodes.Count +    AllAtr.IndexOf(sgAttr.Cells[0,i]);
      if Idx1<Idx2 then
          begin
            sgAttr.MoveRow(sgAttr.RowCount-1, i);
            break;
          end;
    end;
  end;

  procedure FillAttr(XSDref, LocalName:string);
  var i,j:Integer;
  begin
  for i := 0 to MainData.XSD.Node['schema'].Nodes.Count-1 do
    if ((MainData.XSD.Node['schema'].Nodes[i].LocalName = 'complexType')
     or (MainData.XSD.Node['schema'].Nodes[i].LocalName = 'attributeGroup'))
      and ('svg:'+MainData.XSD.Node['schema'].Nodes[i].Attribute['name'] = XSDref) then
    begin
       for j := 0 to MainData.XSD.Node['schema'].Nodes[i].Nodes.Count-1 do
         if (MainData.XSD.Node['schema'].Nodes[i].Nodes[j].LocalName = 'attribute') and
            (MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['ref'] = 'xlink:href')
         then
           AddAtr('xlink:href', 'xlink:hrefType', LocalName)
         else
         if (MainData.XSD.Node['schema'].Nodes[i].Nodes[j].LocalName = 'attribute') and
            (MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['name'] <> '')
         then begin
           if MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['type'] <> '' then
             AddAtr(MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['name'], MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['type'], LocalName)
           else if MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Nodes.ByName('simpleType')<>nil then
             AddAtr(MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['name'], MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Node['simpleType'].Node['restriction'].Attribute['base'],LocalName,MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Node['simpleType'].Node['restriction']);
         end
         else
         if MainData.XSD.Node['schema'].Nodes[i].Nodes[j].LocalName = 'attributeGroup' then

          FillAttr(MainData.XSD.Node['schema'].Nodes[i].Nodes[j].Attribute['ref'],LocalName);
       exit;
    end;

  for i := 0 to MainData.XSD.Nodes.Count-1 do
    if ((MainData.XSD.Nodes[i].LocalName = 'complexType') or (MainData.XSD.Nodes[i].LocalName = 'attributeGroup'))
      and ('svg:'+MainData.XSD.Nodes[i].Attribute['name'] = XSDref) then
    begin
       for j := 0 to MainData.XSD.Nodes[i].Nodes.Count-1 do
         if (MainData.XSD.Nodes[i].Nodes[j].LocalName = 'attribute') and
            (MainData.XSD.Nodes[i].Nodes[j].Attribute['ref'] = 'xlink:href')
         then
           AddAtr('xlink:href', 'xlink:hrefType',LocalName)
         else
         if (MainData.XSD.Nodes[i].Nodes[j].LocalName = 'attribute') and
            (MainData.XSD.Nodes[i].Nodes[j].Attribute['name']<>'')
         then begin
           if MainData.XSD.Nodes[i].Nodes[j].Attribute['type'] <> '' then
             AddAtr(MainData.XSD.Nodes[i].Nodes[j].Attribute['name'], MainData.XSD.Nodes[i].Nodes[j].Attribute['type'],LocalName)
           else if MainData.XSD.Nodes[i].Nodes[j].Nodes.ByName('simpleType')<>nil then
             AddAtr(MainData.XSD.Nodes[i].Nodes[j].Attribute['name'], MainData.XSD.Nodes[i].Nodes[j].Node['simpleType'].Node['restriction'].Attribute['base'],LocalName, MainData.XSD.Nodes[i].Nodes[j].Node['simpleType'].Node['restriction'])
         end
         else
         if MainData.XSD.Nodes[i].Nodes[j].LocalName = 'attributeGroup' then
           FillAttr(MainData.XSD.Nodes[i].Nodes[j].Attribute['ref'], LocalName);
       exit;
    end;
  end;
var
  i,j:integer;
  prnt:TXML_Nod;
  s:string;
  tp:integer;
begin
  s := sgAttr.Cells[0,sgAttr.Row];
  tp:=sgAttr.TopRow;



  FSVGNode := Value;
  ReplaceFrame.SVGNode := SVGNode;
  sgAttr.RowCount := 2;
  sgAttr.Rows[1].Text :='';
  AllAtr.Clear;
  if SVGNode=nil then exit;

   for i := 0 to MainData.XSD.Nodes.Count-1 do
    if (MainData.XSD.Nodes[i].LocalName = 'element') and (MainData.XSD.Nodes[i].Attribute['name'] = SVGNode.LocalName) then
    begin
      FillAttr(MainData.XSD.Nodes[i].Attribute['type'],SVGNode.LocalName);
      break;
    end;

   if (SVGNode.LocalName='image') or (SVGNode.LocalName='use') then
   begin
      AddAtr('preserveAspectRatio','', SVGNode.LocalName)
   end;
   if (SVGNode.LocalName='text') or (SVGNode.LocalName='tspan')or (SVGNode.LocalName='textPath') then
   begin
      AddAtr('text','', SVGNode.LocalName)
   end;
   if (SVGNode.LocalName='foreignObject') then
   begin
      AddAtr('body','', SVGNode.LocalName)
   end;
   if (SVGNode.LocalName='svg') then
   begin
      AddAtr('decard-baseline','', SVGNode.LocalName);
   end;

   for i := 1 to sgAttr.RowCount-1 do
   begin
     prnt := SVGNode.parent;
     while prnt<>nil do
       if prnt.Attribute[sgAttr.Cells[0,i]]<>'' then
       begin
         sgAttr.Cells[1,i] := prnt.Attribute[sgAttr.Cells[0,i]];
         break;
       end
       else prnt := prnt.parent;

     if sgAttr.Cells[0,i]='text' then
       sgAttr.Cells[2,i] := SVGNode.text
     else
       sgAttr.Cells[2,i] := SVGNode.Attribute[sgAttr.Cells[0,i]];
     sgAttr.Cells[3,i] := SVGNode.Attribute['dekart:'+ StringReplace(sgAttr.Cells[0,i],':','_',[rfReplaceall])];
   end;
//SetXML;

  for i:= 0 to sgAttr.ColCount-1 do
  begin
    sgAttr.ColWidths[i] := 40;
    for j:=0 to sgAttr.RowCount-1 do
    begin
      if sgAttr.ColWidths[i] < sgAttr.Canvas.TextWidth(sgAttr.cells[i,j])+10 then
        sgAttr.ColWidths[i] := sgAttr.Canvas.TextWidth(sgAttr.cells[i,j])+10;
      if sgAttr.ColWidths[i] > 200 then
        sgAttr.ColWidths[i] := 200;
    end
  end;
  tsAtrResize(tsAtr);

  if tp<sgAttr.RowCount-1 then
    sgAttr.TopRow := tp;
  tp := sgAttr.Cols[0].IndexOf(s);
  if tp<>-1 then
    sgAttr.Row := tp;
end;


procedure TSvgInspectorFrame.sgAttrDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with (Sender as TStringGrid) do
  if ARow=Row then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := clBlue;
    Canvas.Pen.Width := 2;
    Canvas.Rectangle(sgAttr.CellRect(Acol,Arow));
//    Canvas.Rectangle(Rect.Left-5, Rect.Top, Rect.Right+1, Rect.Bottom);
  end;
end;

procedure TSvgInspectorFrame.sgAttrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=13) and (ssCtrl in Shift) then
    if NOT assigned(sgAttr.InplaceEditor)
     or not (THackInplaceEditList(sgAttr.InplaceEditor).EditStyle=esPickList) then
    begin
      aEdit.Execute;
      Key :=0
    end;

end;

procedure TSvgInspectorFrame.sgAttrSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  s:string;
  HelpNod:TXML_Nod;
begin
  if SVGNode = nil then exit;

  s:= '<' + SVGNode.LocalName+'>';
  HelpNod := MainData.HLP.Node['help'].Node['elements'].Nodes.ByName(SVGNode.LocalName);
  if HelpNod <> nil then
    s:= s +HelpNod.Node['documentation'].text;

  if TStringGrid(Sender).Cells[0, ARow]<>'' then
  begin
    if (HelpNod <> nil ) and (HelpNod.Nodes.ByName(TStringGrid(Sender).Cells[0, ARow])<> nil) then
        s:= s + #13#10#13#10 + TStringGrid(Sender).Cells[0, ARow]+': '+

        HelpNod.Nodes.ByName(TStringGrid(Sender).Cells[0, ARow]).text
      else
      if MainData.HLP.Node['help'].Node['attributes'].Nodes.ByName(TStringGrid(Sender).Cells[0, ARow])<> nil then
        s:= s + #13#10#13#10 + TStringGrid(Sender).Cells[0, ARow]+': '+MainData.Hlp.Node['help'].Node['attributes'].Nodes.ByName(sgAttr.Cells[0, ARow]).text;
  end;
  meHint.Text := s;
  TControl(Sender).Invalidate;
end;

procedure TSvgInspectorFrame.sgAttrSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  i:integer;
begin
  with (Sender as TStringGrid) do
  begin
//    Cells[ACol,ARow] := Value;
    if ACol=2 then
    begin
      if Cells[0,ARow]='text' then
        SVGNode.text := Value
      else
        SVGNode.Attribute[Cells[0,ARow]] := Value
    end
    else
    if ACol=3 then
      SVGNode.Attribute['dekart:'+StringReplace(Cells[0,ARow],':','_',[rfReplaceall])] := Value;

    if (ACol=2)and(Cells[0,ARow]='id') then
      FocusedNode.Text := SVGNode.Attribute['id']+': '+SVGNode.LocalName;

    for i := SVGNode.Attributes.Count-1 downto 0 do
      if SVGNode.Attributes[i].value='' then
        SVGNode.Attributes[i].Destroy;
  end;
end;

procedure TSvgInspectorFrame.sgAttrTopLeftChanged(Sender: TObject);
begin
  sgAttr.Invalidate;
end;

procedure TSvgInspectorFrame.tbSetColorClick(Sender: TObject);
var dkr:string;
begin
  if sgAttr.col=3 then
    dkr:='dekart:'
  else
    dkr:='';

  if (SVGNode.LocalName='feFlood')or(sgAttr.Cells[0,sgAttr.Row]='flood-color') then
    MainData.dlgColor.Color := ColorHex(SVGNode.Attribute[dkr + 'flood-color'])
  else
  if SVGNode.LocalName='stop' then
    MainData.dlgColor.Color := ColorHex(SVGNode.Attribute[dkr + 'stop-color'])
  else
  if sgAttr.Cells[0,sgAttr.Row]='stroke' then
    MainData.dlgColor.Color := ColorHex(SVGNode.Attribute[dkr + 'stroke'])
  else
    MainData.dlgColor.Color := ColorHex(SVGNode.Attribute[dkr + 'fill']);


  if MainData.dlgColor.Execute then
  begin
    if (SVGNode.LocalName='feFlood')or(sgAttr.Cells[0,sgAttr.Row]='flood-color') then
      SVGNode.Attribute[dkr + 'flood-color'] := '#'+HexColor(MainData.dlgColor.Color)
    else
    if  SVGNode.LocalName='stop' then
      SVGNode.Attribute[dkr + 'stop-color'] := '#'+HexColor(MainData.dlgColor.Color)
    else
    if sgAttr.Cells[0,sgAttr.Row]='stroke' then
      SVGNode.Attribute[dkr + 'stroke'] := '#'+HexColor(MainData.dlgColor.Color)
    else
      SVGNode.Attribute[dkr + 'fill'] := '#'+HexColor(MainData.dlgColor.Color);

    cbAtrShowClick(nil);
  end;
end;


procedure TSvgInspectorFrame.tsAtrResize(Sender: TObject);
var w:integer;
begin
  w := sgAttr.ClientWidth - sgAttr.CellRect(sgAttr.ColCount-1,1).Left;
  if w>80 then
    sgAttr.ColWidths[sgAttr.ColCount-1] := w;
end;

procedure TSvgInspectorFrame.tbFileXlinkClick(Sender: TObject);
var atr:string;
begin
  if sgAttr.col=3 then
    atr := 'dekart:xlink_href'
  else
    atr := 'xlink:href';
  MainData.dlgOpenPicture.InitialDir := MainForm.edCfgRoot.Text;
  MainData.dlgOpenPicture.FileName := SVGNode.Attribute[atr];
  if MainData.dlgOpenPicture.Execute then
  begin
    SVGNode.Attribute[atr] := ExtractRelativePath(MainForm.edCfgRoot.Text,MainData.dlgOpenPicture.FileName);
    cbAtrShowClick(nil);
  end;
end;

procedure TSvgInspectorFrame.tbFontClick(Sender: TObject);
var
   dkr:string;
begin
  if sgAttr.col=3 then
    dkr:='dekart:'
  else
    dkr:='';

  MainData.dlgFont.Font.Height := -StrToIntDef(SVGNode.Attribute[dkr + 'font-size'],16);
  if SVGNode.Attribute[dkr + 'font-style']='italic' then
    MainData.dlgFont.Font.Style := MainData.dlgFont.Font.Style + [fsItalic]
  else
    MainData.dlgFont.Font.Style := MainData.dlgFont.Font.Style - [fsItalic];

  if SVGNode.Attribute[dkr + 'font-weight']='bold' then
    MainData.dlgFont.Font.Style := MainData.dlgFont.Font.Style + [fsbold]
  else
    MainData.dlgFont.Font.Style := MainData.dlgFont.Font.Style - [fsbold];
  MainData.dlgFont.Font.Name := SVGNode.Attribute[dkr + 'font-family'];

  if MainData.dlgFont.Execute then
  begin

    SVGNode.Attribute[dkr + 'font-family'] := MainData.dlgFont.Font.Name;
    SVGNode.Attribute[dkr + 'font-size'] := IntToStr(-MainData.dlgFont.Font.Height);

    if fsbold in  MainData.dlgFont.Font.Style then
      SVGNode.Attribute[dkr + 'font-weight'] := 'bold'
    else
      SVGNode.Attribute[dkr + 'font-weight'] := '';

    if fsItalic in  MainData.dlgFont.Font.Style then
      SVGNode.Attribute[dkr + 'font-style'] := 'italic'
    else
      SVGNode.Attribute[dkr + 'font-style'] := '';


    cbAtrShowClick(nil);
  end;
end;



{ Hack TStringGrid }
type TPickList=class(TCustomListbox);

function TStringGrid.CreateEditor: TInplaceEdit;
begin
  Result := THackInplaceEditList.Create(Self);
  THackInplaceEditList(Result).OnEditButtonClick := OnDblClick;
  Result.Brush.Color := rgb(200,220,255);
end;


function TStringGrid.GetEditStyle(ACol, ARow: Longint): TEditStyle;
begin
  if (ACol>1) and ((Cells[4,ARow]<>'') or (Cells[0, ARow]='font-family'))
  then
    result := esPickList
  else
  if (ACol>2) and (Cells[0, ARow]='body')or(Cells[0, ARow]='text') then
    result := esEllipsis
  else
    result := esSimple;
  if InplaceEditor<>nil then
    THackInplaceEditList(InplaceEditor).ReadOnly := (ACol<2) or
      ((Cells[0, ARow]='id')and(ACol<>2)) or
      ((Cells[0, ARow]='body')and(ACol<>3));
end;

{ THackInplaceEditList }

procedure THackInplaceEditList.DoGetPickListItems;
begin
  if (TStringGrid(Grid).Col>1) then
  with Grid as TStringGrid do
  begin
    if (Cells[0, Row]='font-family') then
      PickList.Items.Text := StringReplace(StringReplace(LocalFonts,',',^M,[rfReplaceAll]),'"','',[rfReplaceAll])
    else
    if (Cells[4,Row]<>'')  then
      PickList.Items.Text := StringReplace(','+Cells[4, Row],',',#13,[rfReplaceAll]);
  end

end;

end.
