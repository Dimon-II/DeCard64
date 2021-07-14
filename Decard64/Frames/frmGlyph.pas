unit frmGlyph;

interface

uses
  Windows, Messages, system.SysUtils, system.Variants, system.Classes, vcl.Graphics, vcl.Controls, vcl.Forms,
  vcl.Dialogs, vcl.ExtCtrls, vcl.StdCtrls, SynEdit, vcl.Grids, SynUnicode, SynMemo, vcl.Buttons, vcl.Clipbrd,
  vcl.Menus;

type
  TformGlyph = class(TForm)
    Image1: TImage;
    dlgFont: TFontDialog;
    Grid: TDrawGrid;
    Panel1: TPanel;
    cbFont: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    pmCopy: TPopupMenu;
    miCopyChar: TMenuItem;
    miCopyTag: TMenuItem;
    miCopyUnicode: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbFontChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure miCopyCharClick(Sender: TObject);
    procedure miCopyTagClick(Sender: TObject);
    procedure miCopyUnicodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ChrMap:TStringList;
  end;

var
  formGlyph: TformGlyph;

implementation

{$R *.dfm}

procedure TformGlyph.FormCreate(Sender: TObject);
begin
   ChrMap:=TStringList.Create;
end;


procedure TformGlyph.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var wc:WideString;
 ws:WideString;
 sz:TSize;
begin
  if (ChrMap.Count>ARow)then
  begin
  ws:= ChrMap[ARow];
  if Length(ws)>ACol then
    wc:=copy(ws,ACol+1,1)
  else
    wc:=' ';
  sz:=GetTextSize(Grid.Canvas.Handle, PWideChar(wc),1);

  if Grid.ColWidths[acol]<sz.cx+3 then
    Grid.ColWidths[acol]:=sz.cx+3;

  if Grid.RowHeights[arow]<sz.cy+3 then
    Grid.RowHeights[arow]:=sz.cy+3;

  TextOutW(Grid.Canvas.Handle, Rect.Left + Grid.ColWidths[acol] div 2 - sz.cx div 2+1, Rect.Top+1, PWideChar(wc),1);

  end;

end;

procedure TformGlyph.cbFontChange(Sender: TObject);
var GS:PGlyphSet;
    GSSize:LongWord;
    rng:TWCRange;
    i, j, cnt:Integer;
    wc:WideChar;
    ws:WideString;

type
  TWCRangeArray = array [0..(MaxInt div SizeOf(TWCRange))-1] of TWCRange;
  PWCRangeArray = ^TWCRangeArray;
begin
  dlgFont.Font.Name := cbFont.Text;
  cnt:=0;

  ChrMap.Clear;
  Image1.Picture.Bitmap.Canvas.Font := dlgFont.Font;

  Grid.Font := dlgFont.Font;
  Grid.Font.Size := 24;
  GSSize := GetFontUnicodeRanges(Image1.Picture.Bitmap.Canvas.Handle, nil);
  GetMem(Pointer(GS), GSSize);
    GS.cbThis:=GSSize;
    GS.flAccel:=0;
    GS.cGlyphsSupported:=0;
    GS.cRanges:=0;
    if GetFontUnicodeRanges(Image1.Picture.Bitmap.Canvas.Handle, GS)<>0 then begin

      ws:='';

      for i:=0 to GS.cRanges-1 do begin
        inc(cnt, GS.ranges[i].cGlyphs);
        if (GS.ranges[i].cGlyphs >15) then
        begin
          if ws <> '' then
            ChrMap.Add(ws);
          ws:='';
        end;

        wc:=GS.ranges[i].wcLow;

        for j:=0 to GS.ranges[i].cGlyphs-1 do
        begin
          ws:= ws + wc;
          inc(wc);
          if Length(ws)=16 then
          begin
            ChrMap.Add(ws);
            ws:='';
          end;

        end;
        if (GS.ranges[i].cGlyphs >15) then
        begin
          if ws <> '' then
            ChrMap.Add(ws);
          ws:='';
        end;
      end;
      if ws <> '' then
         ChrMap.Add(ws);
    end;
   Grid.RowCount := 1+ ChrMap.Count;
 FreeMem(GS);
 Caption := 'Glyph font: '+IntToStr(cnt);
end;

procedure TformGlyph.BitBtn1Click(Sender: TObject);
begin
  if dlgFont.Execute then begin
    Grid.Font := dlgFont.Font;

    cbFont.Text := dlgFont.Font.Name;
    cbFontChange(cbFont);
  end;
end;


procedure TformGlyph.miCopyCharClick(Sender: TObject);
var ws:WideString;
begin
  if (ChrMap.Count>Grid.Row)then
  begin
  ws:= ChrMap[Grid.Row];
  if Length(ws)>Grid.Col then
  Clipboard.AsText := '&#x'+Format('%x',[Cardinal(ws[Grid.Col+1])])+';'
  end;
end;

procedure TformGlyph.miCopyTagClick(Sender: TObject);
var ws:WideString;
begin
  if (ChrMap.Count>Grid.Row)then
  begin
  ws:= ChrMap[Grid.Row];
  if Length(ws)>Grid.Col then
     Clipboard.AsText := '<font face="'+dlgFont.Font.Name+'">&#x'+Format('%x',[Cardinal(ws[Grid.Col+1])])+';</font>'
  end;
end;

procedure SetClipboardText(const Text: WideString);
var
  Count: Integer;
  Handle: HGLOBAL;
  Ptr: Pointer;
begin
  Count := (Length(Text)+1)*SizeOf(WideChar);
  Handle := GlobalAlloc(GMEM_MOVEABLE, Count);
  Try
    Win32Check(Handle<>0);
    Ptr := GlobalLock(Handle);
    Win32Check(Assigned(Ptr));
    Move(PWideChar(Text)^, Ptr^, Count);
    GlobalUnlock(Handle);
    Clipboard.SetAsHandle(CF_UNICODETEXT, Handle);
  Except
    GlobalFree(Handle);
    raise;
  End;
end;

procedure TformGlyph.miCopyUnicodeClick(Sender: TObject);
var ws:WideString;
begin
  if (ChrMap.Count>Grid.Row)then
  begin
  ws:= ChrMap[Grid.Row];
  if Length(ws)>Grid.Col then
    SetClipboardText(ws[Grid.Col+1])

//    Clipboard.AsText := ws[Grid.Col+1];
  end;
end;

end.
