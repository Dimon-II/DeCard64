unit ProfixXML;

interface

uses system.classes, system.types;

type
  TXML_Atr = class;
  TXML_Nod = class;
  TXML_Doc = class;
  TXML_AtrList = class;
  TXML_NodList = class;

  TXML_Atr = class
  private
    Fvalue: string;
    Fname: string;
    Fparent: TXML_Nod;
    procedure Setindex(const Value: integer);
    procedure Setname(const Value: string);
    procedure Setparent(const Value: TXML_Nod);
    procedure Setvalue(const Value: string);
    function Getvalue:string;
    function GetIndex:integer;
  public
    property parent: TXML_Nod read Fparent write Setparent;
    property index: integer read GetIndex write Setindex;
    property name: string read Fname write Setname;
    property value: string read Getvalue write Setvalue;
    constructor Create(parent: TXML_Nod);
    destructor Destroy;override;
  end;

  TXML_Nod = class
  private
    Fdata: string;
    Fname: string;
    Ftext: string;
    FAttributes: TXML_AtrList;
    Fparent: TXML_Nod;
    FNodes: TXML_NodList;
    FSystem:boolean;
    procedure Setdata(const Value: string);
    procedure Setindex(const Value: integer);
    procedure Setname(const Value: string);
    procedure Setparent(const Value: TXML_Nod);
    procedure Settext(const Value: string);
    function Gettext: string;
    procedure Setxml(const Value: string);
    function GetLevel:integer;
    function Getxml: string;
    function GetItems(Index: string): TXML_Nod;
    function GetIndex:integer;
  public
    function GetAttribute(index: string): string;
    procedure SetAttribute(index: string; const Value: string);
  public
    property System:boolean read fSystem write fSystem;
    property parent: TXML_Nod read Fparent write Setparent;
    property index: integer read GetIndex write Setindex;
    property LocalName: string read Fname write Setname;
    property xml: string read Getxml write Setxml;
    property text: string read GetText write Settext;
    property data: string read Fdata write Setdata;
    property Attribute[index: string]: string read GetAttribute write SetAttribute;
    property Attributes: TXML_AtrList read FAttributes;
    property Node[index: string]: TXML_Nod read GetItems; default;
    property Nodes: TXML_NodList read FNodes;
    property Level:integer read GetLevel;
    function HasChildren:boolean;
    function HasAttribute(Name: string):boolean;
    constructor Create(parent: TXML_Nod);
    destructor Destroy;override;
    function Add(name: string='new'): TXML_Nod;
    procedure ResetXml(aXml: string);
    function Next: TXML_Nod;

  end;

  TXML_Doc = class(TXML_Nod)
  private
  public
    constructor Create;
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    procedure LoadFromStream(Stream:TStream);
    procedure SaveToStream(Stream:TStream);
    function FindByHRef(Href:string): TXML_Nod;
  end;

  TXML_AtrList = class(TList)
  private
    Fparent: TXML_Nod;
    function GetItems(Index: integer): TXML_Atr;
//    function GetFirst: TXML_Atr;
//    function GetLast: TXML_Atr;
  public
//    property Last: TXML_Atr read GetLast;
//    property First: TXML_Atr read GetFirst;
    property Items[Index: integer]: TXML_Atr read GetItems; default;
    function Add: TXML_Atr;
    function Last: TXML_Atr;
    function First: TXML_Atr;
    constructor Create(parent: TXML_Nod);
    function ByName(Name: string):TXML_Atr;
  end;

  TXML_NodList = class(TList)
  private
    Fparent: TXML_Nod;
    function GetItems(Index: integer): TXML_Nod;
    function GetXml: string;
    procedure SetXml(const Value: string);
//    function GetFirst: TXML_Nod;
//    function GetLast: TXML_Nod;
  public
//    property Last: TXML_Nod read GetLast;
//    property First: TXML_Nod read GetFirst;
    property Items[Index: integer]: TXML_Nod read GetItems; default;
    function Add: TXML_Nod;
    function Last: TXML_Nod;
    function First: TXML_Nod;
    constructor Create(parent: TXML_Nod);
    function ByName(Name: string):TXML_Nod;
    function ByID(ID: string):TXML_Nod;
    property xml: string read GetXml write SetXml;
  end;

procedure ParseXML(root:TXML_Nod;XML: string);
function FormatXML(root:TXML_Nod;level:integer=0):string;
procedure PreProcessXML(aList:Tstrings);
function SpecialEntities(src:string;Entities:boolean):string;

implementation

uses system.Sysutils;

{ TXML_Doc }

function SpecialEntities(src:string;Entities:boolean):string;
var s:string;
begin
  s := src;
  if Entities then
  begin
    s := StringReplace(s, '"','&quot;',[rfReplaceAll]) ;  
    s := StringReplace(s, '<', '&lt;', [rfReplaceAll]) ;
    s := StringReplace(s, '>', '&gt;', [rfReplaceAll]) ;
    s := StringReplace(s, #13#10,'^M', [rfReplaceAll]) ;
  end
  else
  begin
    s := StringReplace(s,'&quot;','"',[rfReplaceAll]) ;
    s := StringReplace(s, '&lt;', '<',[rfReplaceAll]) ;
    s := StringReplace(s, '&gt;', '>',[rfReplaceAll]) ;
    s := StringReplace(s, '^M', #13#10, [rfReplaceAll]) ;
  end;

  result := s;
end;

constructor TXML_Doc.Create;
begin
  inherited create(nil);
  LocalName:='';
end;

function TXML_Doc.FindByHRef(Href: string): TXML_Nod;
begin
  Result := Node['svg'];
  while Result <>nil do
  begin
    if (HRef = '#' + Result.Attribute['id']) or
       (HRef = 'url(#' + Result.Attribute['id'] + ')')
    then break;

    Result := Result.Next
  end;

end;

procedure TXML_Doc.LoadFromFile(FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXML_Doc.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  S: utf8string;
begin
  Size := Stream.Size - Stream.Position;
  SetString(S, nil, Size);
  Stream.Read(Pointer(S)^, Size);
  xml:=UTF8ToWideString(S);
end;

procedure TXML_Doc.SaveToFile(FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TXML_Doc.SaveToStream(Stream: TStream);
var
  S: utf8string;
begin
  S := UTF8Encode(XML);
  Stream.WriteBuffer(Pointer(S)^, Length(S));
end;

{ TXML_NodList }

function TXML_NodList.Add: TXML_Nod;
begin
  Result:=TXML_Nod.Create(fparent);
  Result.LocalName:='new';
  inherited Add(Result);
end;

constructor TXML_NodList.Create(parent: TXML_Nod);
begin
  inherited Create;
  fparent:=parent;
end;

function TXML_NodList.First: TXML_Nod;
begin
  result:=inherited First;
end;

function TXML_NodList.GetItems(Index: integer): TXML_Nod;
begin
  result:=inherited Items[Index];
end;

function TXML_NodList.Last: TXML_Nod;
begin
  result:=inherited Last;
end;


function TXML_NodList.ByName(Name: string):TXML_Nod;
var i:integer;
begin
  result:=nil;
  for i:=1 to count do
    if Items[i-1].LocalName=name then Begin
      result:=Items[i-1];
      break;
    End;
end;

function TXML_NodList.ByID(ID: string): TXML_Nod;
var i:integer;
begin
  result:=nil;
  for i:=1 to count do
    if Items[i-1].Attribute['id']=ID then Begin
      result:=Items[i-1];
      break;
    End;
end;

function TXML_NodList.GetXml: string;
var i:Integer;
begin
  result := '';
  for i:= 0 to Count-1 do
    result := result + Items[i].XML;
end;

procedure TXML_NodList.SetXml(const Value: string);
begin
  ParseXML(Fparent, Value);

end;

{ TXML_Atr }

constructor TXML_Atr.Create(parent: TXML_Nod);
begin
  inherited Create;
  Fparent:=parent;
end;

destructor TXML_Atr.Destroy;
begin
  if assigned(parent) then
    parent.Attributes.Delete(Index);
  inherited Destroy;
end;

function TXML_Atr.GetIndex: integer;
begin
  result:=-1;
  if assigned(parent) then
    result:=parent.Attributes.IndexOf(self);
end;

procedure TXML_Atr.Setindex(const Value: integer);
begin
  if assigned(parent) then
    parent.Attributes.Move(Index,value);
end;

procedure TXML_Atr.Setname(const Value: string);
begin
  Fname:=Value;
end;

procedure TXML_Atr.Setparent(const Value: TXML_Nod);
begin
  if assigned(parent) then
    parent.Attributes.Extract(self);
  if assigned(Value) then
    Value.Attributes.Insert(Value.Attributes.Count,self);
  Fparent:=Value;
end;

procedure TXML_Atr.Setvalue(const Value: string);
begin
  Fvalue:=SpecialEntities(Value,true);
  if (Value='') then Destroy;

end;

function TXML_Atr.Getvalue: string;
begin
  result := SpecialEntities(fValue,false);
end;

{ TXML_Nod }

constructor TXML_Nod.Create(parent: TXML_Nod);
begin
  inherited Create;
  Fparent:=parent;
  System:=False;
  FAttributes:=TXML_AtrList.Create(self);
  FNodes:=TXML_NodList.Create(self);
end;

destructor TXML_Nod.Destroy;
begin
  if assigned(parent) then
    parent.Nodes.Delete(Index);
  while Attributes.Count>0 do
    Attributes[Attributes.Count-1].Destroy;
  while Nodes.Count>0 do
    Nodes[Nodes.Count-1].Destroy;
  FAttributes.Free;
  FNodes.Free;
  inherited Destroy;
end;

function TXML_Nod.Add(name: string='new'): TXML_Nod;
Begin
  result:=Nodes.Add;
  result.Fname:=name
End;

function TXML_Nod.GetAttribute(index: string): string;
var
  atrib:TXML_Atr;
begin
  atrib:=Attributes.byname(index);
  if assigned(atrib) then
    result:=atrib.value
  else
    result:='';
end;

function TXML_Nod.GetLevel: integer;
begin
  if assigned(parent) then
    result:=parent.GetLevel+1
  else
    result:=0;
end;

function TXML_Nod.Getxml: string;
Begin
  result:=FormatXML(self);
End;

function TXML_Nod.GetItems(Index: string): TXML_Nod;
Begin
  result:=Nodes.ByName(Index);
  if result=nil then
    Raise exception.Create('Node '+trim(self.Fname+' '+Index)+' not exists');
End;


function TXML_Nod.HasAttribute(Name: string): boolean;
begin
  result:=assigned(Attributes.ByName(Name));
end;

function TXML_Nod.HasChildren: boolean;
begin
  result:=Nodes.Count>0;
end;

procedure TXML_Nod.SetAttribute(index: string; const Value: string);
var
  atrib:TXML_Atr;
begin
  atrib:=Attributes.byname(index);
  if not assigned(atrib) then Begin
    atrib:=Attributes.Add;
    atrib.name:=index;
  End;
  atrib.value:=value;
end;

procedure TXML_Nod.Setdata(const Value: string);
begin
  Fdata:=Value;
end;

procedure TXML_Nod.Setindex(const Value: integer);
begin
  if assigned(parent) then
    parent.Nodes.Move(Index,value);
end;

procedure TXML_Nod.Setname(const Value: string);
begin
  fname:=Value;
end;

procedure TXML_Nod.Setparent(const Value: TXML_Nod);
begin
  if assigned(parent) then
    parent.Nodes.Extract(self);
  if assigned(Value) then
    Value.Nodes.Insert(Value.Nodes.Count,self);
  Fparent:=Value;
end;

procedure TXML_Nod.Settext(const Value: string);
begin
  Ftext:=SpecialEntities(Value, True);
end;

procedure TXML_Nod.Setxml(const Value: string);
begin
  while Attributes.Count>0 do
    Attributes[0].Destroy;
  while Nodes.Count>0 do
    Nodes[0].Destroy;

  ParseXML(self, Value);
end;

function TXML_Nod.GetIndex: integer;
begin
  result:=-1;
  if assigned(parent) then
    result:=parent.Nodes.IndexOf(self);
end;

function TXML_Nod.Gettext: string;
begin
   Result := SpecialEntities(Ftext, false)
end;

procedure TXML_Nod.ResetXml(aXml: string);
var
  n:TXML_Nod;
  i:Integer;
  s:string;

begin
  n := TXML_Nod.Create(nil);
  try
    n.xml := aXml;

    while Attributes.Count>0 do
      Attributes[0].Destroy;
    while Nodes.Count>0 do
      Nodes[0].Destroy;
    s:='';
    for i:=0 to n.Nodes[0].Nodes.Count-1 do
      s:=s+n.Nodes[0].Nodes[i].xml;
    xml := s;

    for i:=0 to n.Nodes[0].Attributes.Count-1 do
       Attribute[n.Nodes[0].Attributes[i].name] := n.Nodes[0].Attributes[i].value;
    data := n.Nodes[0].data;
    text := n.Nodes[0].text;

    s := copy(aXml, Pos('<',aXml)+1, 128);
    Delete(s,Pos('>',s+'>'),128);
    Delete(s,Pos('/',s+'/'),128);
    Delete(s,Pos(' ',s+' '),128);
    LocalName := s;

  finally
    n.Destroy;
  end;

end;

function TXML_Nod.Next: TXML_Nod;
begin
   Result := self;
   if Result.Nodes.Count >0 then
     Result := Result.Nodes.First
   else begin

   while (Result.parent <> nil) and (Result.index = Result.parent.Nodes.Count-1) do
     Result := Result.parent;

   if Result.index = -1 then
     Result := nil
   else

     Result := Result.parent.Nodes.Items[Result.Index+1];
   end;
end;

{ TXML_AtrList }

function TXML_AtrList.Add: TXML_Atr;
begin
  Result:=TXML_Atr.Create(fparent);
  Result.Name:='new';
  inherited Add(Result);
end;

constructor TXML_AtrList.Create(parent: TXML_Nod);
begin
  inherited Create;
  fparent:=parent;
end;

function TXML_AtrList.First: TXML_Atr;
begin
  result:=items[0];
end;

function TXML_AtrList.GetItems(Index: integer): TXML_Atr;
begin
  result:=inherited Items[Index];
end;

function TXML_AtrList.Last: TXML_Atr;
begin
  result:=items[count-1];
end;

function TXML_AtrList.ByName(Name: string):TXML_Atr;
var i:integer;
begin
  result:=nil;
  for i:=1 to count do
    if Items[i-1].name=name then Begin
      result:=Items[i-1];
      break;
    End;
end;

const
  cr = chr(13)+chr(10);
  tab = chr(9);






procedure PreProcessXML(aList:Tstrings);
const
  crlf  = chr(13)+chr(10);
  tab = chr(9);
var oList:TStringlist;
    s,xTag,xText,xData:string;
    p1,p2,c:integer;
    aLevel:integer;

    function clean(aText: string):string;
    begin
      result:=stringreplace(aText,crlf,' ',[rfreplaceall]);
      result:=stringreplace(result,tab,' ',[rfreplaceall]);
      result:=trim(result);
    end;

    function cleanCDATA(aText: string):string;
    begin
      result:=stringreplace(aText,crlf,'\n ',[rfreplaceall]);
      result:=stringreplace(result,tab,'\t ',[rfreplaceall]);
    end;

    function spc:string;
    begin
      if alevel<1 then
        result:=''
      else
        result:=stringofchar(' ',2*aLevel);
    end;
begin
  oList:=TStringlist.create;
  s:=aList.text;
  xText:='';
  xTag:='';
  p1:=1;
  c:=length(s);
  aLevel:=0;
  repeat
    p2:=pos('<',s,p1);
    if p2>0 then begin
      xText:=trim(copy(s,p1,p2-p1));
      if xText<>'' then begin
        oList.Append('TX:'+clean(xText));
      end;
      p1:=p2;
      // check for CDATA
      if uppercase(copy(s,p1,9))='<![CDATA[' then begin
        p2:=pos(']]>',s,p1);
        xData:=copy(s,p1+9,p2-p1-9);
        oList.Append('CD:'+cleanCDATA(xData));
        p1:=p2+2;
      end
      else
      if uppercase(copy(s,p1,2))='<?' then begin
        p2:=pos('?>',s,p1);
        xData:=copy(s,p1+2,p2-p1-2);
        oList.Append('SY:'+xData);
        p1:=p2+2;
      end
      else
      if uppercase(copy(s,p1,2))='<!' then begin
        p2:=pos('>',s,p1);
        xData:=copy(s,p1+2,p2-p1-2);
        oList.Append('RM:'+xData);
        p1:=p2+2;
      end
      else begin
        p2:=pos('>',s,p1);
        if p2>0 then begin
          xTag:=copy(s,p1+1,p2-p1-1);
          p1:=p2;
          if Length(xTag)=0 then begin
            oList.Append('CT:'+clean(xTag));
            dec(aLevel);
          end else
          if xTag[1]='/' then begin
            delete(xTag,1,1);
            oList.Append('CT:'+clean(xTag));
            dec(aLevel);
          end
          else if xtag[length(xTag)]='/' then begin
            oList.Append('ET:'+clean(xTag));
          end
          else begin
            inc(aLevel);
            oList.Append('OT:'+clean(xTag));
          end
        end
      end
    end
    else begin
      xText:=trim(copy(s,p1,length(s)));
      if xText<>'' then begin
        oList.Append('TX:'+clean(xText));
      end;
      p1:=c;
    end;
    inc(p1);
  until p1>c;
  alist.assign(oList);
  oList.free;
end;


procedure ParseXML(root:TXML_Nod;XML: string);
var sl:TStringList;
  i:integer;
  nod:TXML_Nod;
  typ,dat:string;

procedure AddAttributes(ats:string;al:TXML_AtrList);
var s,nam,val:string;
Begin
  s:=ats;
  while pos('=',s)>0 do Begin
    nam:=trim( copy(s,1, pos('=',s)-1) );
    system.delete(s,1,pos('=',s));
    while pos(#32,nam)>0 do system.delete(nam,1,pos(#32,nam));
    system.delete(s,1,pos('"',s));
    val:=copy(s,1,pos('"',s)-1);
    system.delete(s,1,pos('"',s));
    with al.Add do Begin
     name:= nam;
     value:= StringReplace(val,'&quot;','"',[rfReplaceAll]) ;
    end;
  End;
End;
    function ExpandCDATA(aValue: string):string;
    begin
      result:=stringreplace(aValue,'\n ',cr,[rfreplaceall]);
      result:=stringreplace(result,'\t ',tab,[rfreplaceall]);
    end;

Begin
  nod:=root;
  sl:=TStringList.Create;
  sl.text:=XML;
  PreProcessXML(sl);
  for i:=0 to sl.Count-1 do begin
    typ:=COPY(sl[i],1,3);
    dat:=COPY(sl[i],4,length(sl[i]));
    if copy(dat,length(dat),1)='/' then
      system.delete(dat,length(dat),1);

    if typ='SY:' then Begin
      // Системный TAG
      with nod.add do begin
        LocalName:=copy(dat,1,pos(#32,dat+#32)-1);
        AddAttributes(copy(dat,pos(#32,dat)+1,Length(dat)),Attributes);
        System:=true;
      end;
    End else
    if typ='RM:' then Begin
      // Комментарий TAG
      with nod.add do begin
        LocalName:='!'+dat;
//        System:=true;
      end;
    End else
    if typ='ET:' then Begin
      // Однострочный TAG
      with nod.add do begin
        LocalName:=copy(dat,1,pos(#32,dat+#32)-1);
        AddAttributes(copy(dat,pos(#32,dat)+1,Length(dat)),Attributes);
      end;
    End else
    if typ='OT:' then Begin
      // Начало TAG
      nod:=nod.add;
      with nod do begin
        LocalName:=copy(dat,1,pos(#32,dat+#32)-1);
        AddAttributes(copy(dat,pos(#32,dat)+1,Length(dat)),Attributes);
      end;
    End else
    if typ='CT:' then Begin
      // Конец TAG
      nod:=nod.parent;
    End else
    if typ='TX:' then Begin
      // Текст
      if nod.text=EmptyStr then
        nod.text:=dat
      else
        nod.text:=#13#10+dat;
    End else
    if typ='CD:' then Begin
      //Данные
      nod.data:=ExpandCDATA(dat);
    End //else
  End;
  sl.free;
End;

function FormatXML(root:TXML_Nod;level:integer=0):string;
var i:integer;
   lft:string;
Begin
  result:='';
  if root.LocalName=EmptyStr then
    for i:=1 to root.Nodes.Count do
      result:=result+FormatXML(root.nodes[i-1])+#13#10
  else Begin

  result:=root.LocalName;
  lft:=StringOfChar(#9,level);
  for i:=1 to root.Attributes.Count do
    result:=result+' '+root.Attributes[i-1].name+'="'+SpecialEntities(root.Attributes[i-1].value,true) +'"';
  if root.system then
    result:='?'+result+'?'
  else if Copy(root.LocalName,1,1)='!' then
    result:=result
  else if (root.Nodes.Count=0)and(root.fdata=EmptyStr)and(root.text=EmptyStr) then
    result:=result+'/'
  else Begin
    result:=result+'>';
    result:=result+root.text;
    if root.data<>EmptyStr then
      result:=result+#13#10+lft+'<![CDATA['+root.fdata+']]>';
    for i:=1 to root.Nodes.Count do
      result:=result+#13#10+FormatXML(root.nodes[i-1],level+1);

    if root.Nodes.Count=0 then
      result:=result+'</'+root.LocalName
    else
      result:=result+#13#10+lft+'</'+root.LocalName;
  End;

  result:=lft+'<'+result+'>';
end;
End;



end.

