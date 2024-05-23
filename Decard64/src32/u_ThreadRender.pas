unit u_ThreadRender;

interface

uses
  system.Classes, vcl.Forms, vcl.ExtCtrls, Windows, system.sysutils, vcl.Graphics, resvg, Vcl.Imaging.pngimage,
  vcl.dialogs;

type

  TSkiaThread = class(TThread)
  private
    { Private declarations }
    Svg: RawByteString;
    FImage: TImage;
    FZoom: double;
    FSvgFile: string;
    FResultFile: string;
    FRenderOptions: string;
    sz: resvg_size;
    Img: array of char;
    Ftree: ^presvg_render_tree;
    FQJPEG, DPI: Integer;
    FIdObject: TStringList;
    BMP: TPNGImage;
    LogText: string;
  public
    constructor Create(AImage: TImage; ASvgFile, ASvg, AResultFile,
      ARenderingOptions: string; AZoom: double; ADPI: Integer;
      AIdObject: TStringList; QJPEG: Integer);

    procedure Execute; override;
    procedure Apply;
    procedure ApplyRenderingOptions(opt: presvg_options);
    destructor Destroy; override;
    procedure LogError;
  end;

var
  FBufXml, FFonts: TStringList;
  opt: presvg_options;
  LocalFonts: string;
  FontList:string;

procedure ResetFonts(APath: string);

implementation

uses
  u_MainForm, Vcl.Imaging.jpeg, system.Math, Messages, FontsNameFunc;;

procedure TSkiaThread.ApplyRenderingOptions(opt: presvg_options);
begin
  if Pos('--shape-rendering geometricPrecision', FRenderOptions) > 0 then
    resvg_options_set_shape_rendering_mode(opt,
      RESVG_SHAPE_RENDERING_GEOMETRIC_PRECISION);
  if Pos('--shape-rendering optimizeSpeed', FRenderOptions) > 0 then
    resvg_options_set_shape_rendering_mode(opt,
      RESVG_SHAPE_RENDERING_OPTIMIZE_SPEED);
  if Pos('--shape-rendering crispEdges', FRenderOptions) > 0 then
    resvg_options_set_shape_rendering_mode(opt,
      RESVG_SHAPE_RENDERING_CRISP_EDGES);
  if Pos('--text-rendering optimizeLegibility', FRenderOptions) > 0

  then
    resvg_options_set_text_rendering_mode(opt,
      RESVG_TEXT_RENDERING_OPTIMIZE_LEGIBILITY);
  if Pos('--text-rendering optimizeSpeed', FRenderOptions) > 0

  then
    resvg_options_set_text_rendering_mode(opt,
      RESVG_TEXT_RENDERING_OPTIMIZE_SPEED);

  if Pos('--text-rendering geometricPrecision', FRenderOptions) > 0 then
    resvg_options_set_text_rendering_mode(opt,
      RESVG_TEXT_RENDERING_GEOMETRIC_PRECISION);
  if Pos('--image-rendering optimizeQuality', FRenderOptions) > 0 then
    resvg_options_set_image_rendering_mode(opt,
      RESVG_IMAGE_RENDERING_OPTIMIZE_QUALITY);

  if Pos('--image-rendering optimizeSpeed', FRenderOptions) > 0 then
    resvg_options_set_image_rendering_mode(opt,
      RESVG_IMAGE_RENDERING_OPTIMIZE_SPEED);
end;

function Zero(z: double): double;
begin
  if IsInfinite(z) or IsNan(z) then
    result := 0
  else
    result := z;
end;

constructor TSkiaThread.Create(AImage: TImage; ASvgFile, ASvg, AResultFile,
  ARenderingOptions: string; AZoom: double; ADPI: Integer;
  AIdObject: TStringList; QJPEG: Integer);
var
  i, j: Integer;
  s: string;
begin
 SetExceptionMask(exAllArithmeticExceptions);
  FImage := AImage;
  FSvgFile := ASvgFile;
  FResultFile := AResultFile;
  FRenderOptions := ARenderingOptions;
  FIdObject := AIdObject;
  BMP := Nil;

  s := ASvg;
  s := StringReplace(s, '<use class="space"/>', '', [rfReplaceAll]);

  i := Pos('=""', s);
  while i > 0 do
  begin
    for j := i downto 1 do
      if s[j] = ' ' then
        break;
    delete(s, j, i - j + 3);
    i := Pos('=""', s);
  end;

  Svg := UTF8Encode(s);

  FZoom := AZoom;
  DPI := ADPI;
  FQJPEG := QJPEG;
  inherited Create(false);
end;

procedure TSkiaThread.Execute;
var

  fmt: string;

  fit_to: resvg_fit_to;
  tree: ^presvg_render_tree;
  pth: utf8String;

begin
  fmt := LowerCase(StringReplace(ExtractFileExt(FResultFile), '.', '', []));
  pth :=  ExtractFilePath(FSvgFile);
  resvg_options_set_resources_dir(opt, PChar(pth));
  resvg_options_set_dpi(opt, DPI);

  resvg_options_set_keep_named_groups(opt, FIdObject <> nil);

  // fit_to._type := RESVG_FIT_TO_ZOOM;
  // fit_to.value := fzoom;
  fit_to._type := RESVG_FIT_TO_ORIGINAL;

  ApplyRenderingOptions(opt);

  tree := nil;

  resvg_parse_tree_from_data(@Svg[1], length(Svg), opt, @tree);

  if tree = nil then
    raise Exception.Create('SVG parsing error');

  Ftree := Pointer(tree);

  if (fmt <> '') or (FImage <> nil) then

  begin

    sz.width := Round(resvg_get_image_viewbox(tree).width);

    sz.height := Round(resvg_get_image_viewbox(tree).height);

    SetLength(Img, Round(sz.width * sz.height * 4));

    try

      resvg_render(tree, fit_to, Round(sz.width), Round(sz.height), @(Img[0]));

    except

      on e: Exception do
      begin

        LogText := e.message;

        Synchronize(LogError);

      end;

    end;

//--    ADPI := DPI;

    BMP := TPNGImage.CreateBlank(COLOR_RGB, 8, Round(sz.width),
      Round(sz.height));

    BmpGRBA(BMP, Img)

  end;

end;



procedure ResetFonts(APath: string);
var
  sr: TSearchRec;
  s: string;
  fn: UTF8String;
  FontsCount: Integer;
  ll:byte;
begin
  try
    LocalFonts := '';

    resvg_options_destroy(opt);
    if APath = '<>' then
      exit;

    opt := resvg_options_create();
    resvg_options_load_system_fonts(opt);

    if FindFirst(APath + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        fn := APath + sr.Name;
        if (LowerCase(ExtractFileExt(sr.Name)) = '.ttf') or
          (LowerCase(ExtractFileExt(sr.Name)) = '.otf') then
          begin
            if resvg_options_load_font_file(opt, PChar(fn))=0 then
            begin
              s :=   GetFontNameFromFile(APath + sr.Name);
              if Pos(','+s+',', ','+LocalFonts+',') = 0 then
                LocalFonts := LocalFonts + s + ',';
            end;
          end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
  end;
end;

destructor TSkiaThread.Destroy;
begin
  Apply;
  if Ftree <> nil then
    resvg_tree_destroy(Ftree);
  if BMP <> nil then
    BMP.free;

  inherited;

end;

procedure TSkiaThread.LogError;
begin
  MainForm.meLog.Lines.Add(LogText)
end;

procedure TSkiaThread.Apply;
var
  i: Integer;
  bbox: resvg_rect;
  fmt: string;
  b2: TBitmap;
  b3: TJpegDPI;
  ss: UTF8String;
  s: String;
begin
  fmt := LowerCase(StringReplace(ExtractFileExt(FResultFile), '.', '', []));

  if Img <> nil then
  begin
    if FImage <> nil then
    begin
      FImage.Picture.Bitmap.Assign(BMP);
    end;

    if fmt = 'jpg' then
    begin
      b3 := TJpegDPI.Create;
      b2 := TBitmap.Create;
      try
        b2.Assign(BMP);
        b3.CompressionQuality := FQJPEG;
        b3.Assign(b2);
        b3.DPI := DPI;
        b3.SaveToFile(FResultFile);
      finally
        b2.free;
        b3.free;
      end;
    end;

    if fmt = 'png' then
      with BMP do
        try
          i := Round(DPI / 0.0254);
          PixelInformation.PPUnitX := i;
          PixelInformation.PPUnitY := i;
          PixelInformation.UnitType := utMeter;
          SaveToFile(FResultFile);
        finally
          // Free;
        end;
  end;

  if (FIdObject <> nil) and (Ftree <> nil) then
    for i := 0 to FIdObject.count - 1 do
      try
        ss := FIdObject[i];
        if resvg_node_exists(Ftree, PChar(ss)) then
          if resvg_get_node_bbox(Ftree, PChar(ss), @bbox) then
          begin
            bbox.width := Zero(bbox.width);
            bbox.height := Zero(bbox.height);
            bbox.x := Zero(bbox.x);
            bbox.y := Zero(bbox.y);
            s := ',' + IntToStr(Round(bbox.x)) + ','
              + IntToStr(Round(bbox.y)) + ','
              + IntToStr(Round(bbox.width)) + ','
              + IntToStr(Round(bbox.height));
            FIdObject[i] := FIdObject[i] + s;
            // LogText := FIdObject[i];
            // Synchronize(LogError);

          end

      except

      end;

end;

Function MyFontEnumProc(lpelfe : PEnumLogFontEx; P : Pointer; FontType,LParam : Integer) : Integer; stdcall;
var
  s:string;
Begin
  If (FontType = TrueType_FontType) Then
  begin
    s:= StrPas(lpelfe^.elfLogFont.lfFaceName);
    if (Pos(',"'+s+'",', FontList+',')=0)and(Pos('@',s)=0) then
      FontList := FontList +',"'+s+'"';
  end;
  Result := 1;
End;

procedure SysFontList;
Var
  DC   : hDC;
  LF   : TLogFont;
begin
  FontList := '';
  With LF do Begin
    lfCharSet := Default_CharSet;
    lfFaceName := '';
    lfPitchAndFamily := 0;
  End;

  DC := GetDC(0);
  EnumFontFamiliesEx(DC,LF,@MyFontEnumProc,0,0);
  ReleaseDC(0,DC);
  with TStringList.Create do
  begin
    Duplicates := dupIgnore;
    Sorted := True;
    CommaText := FontList;
    Delete(0);
    FontList := ',inherit,'+CommaText;
    Free;
  end;

end;


initialization




FFonts := TStringList.Create;
opt := resvg_options_create();
resvg_options_load_system_fonts(opt);
/// Set8087CW($133f); { Disable all fpu exceptions }
SysFontList;

finalization

ResetFonts('<>');
FFonts.free;

end.
