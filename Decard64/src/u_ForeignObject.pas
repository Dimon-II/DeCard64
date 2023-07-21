unit u_ForeignObject;

interface

uses
  profixxml;

procedure ParseHTML(Root:TXML_Nod);



implementation

{ TForeignObject }

procedure ParseHTML(Root:TXML_Nod);
var
  i:integer;
begin

   for i := 0 to Root.Nodes.Count-1 do
   begin
//     tstringlist
   end;

end;

end.
