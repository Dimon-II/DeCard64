unit resvg;

interface

const

{$IFDEF WIN32}
  resvgdll='resvg32.dll'; {Setup as you need}
{$ENDIF WIN32}

{$IFDEF WIN64}
  resvgdll='resvg64.dll'; {Setup as you need}
{$ENDIF WIN64}


const
  RESVG_MAJOR_VERSION = 0;
  RESVG_MINOR_VERSION = 15;
  RESVG_PATCH_VERSION = 0;
  RESVG_VERSION = '0.15.0';

type

  resvg_error = (
    RESVG_OK,
    RESVG_ERROR_NOT_AN_UTF8_STR,
    RESVG_ERROR_FILE_OPEN_FAILED,
    RESVG_ERROR_FILE_WRITE_FAILED,
    RESVG_ERROR_INVALID_FILE_SUFFIX,
    RESVG_ERROR_MALFORMED_GZIP,
    RESVG_ERROR_INVALID_SIZE,
    RESVG_ERROR_PARSING_FAILED,
    RESVG_ERROR_NO_CANVAS);

  resvg_color = record
    r: byte;
    g: byte;
    b: byte;
  end;

  resvg_fit_to_type = (
    RESVG_FIT_TO_ORIGINAL,
    RESVG_FIT_TO_WIDTH,
    RESVG_FIT_TO_HEIGHT,
    RESVG_FIT_TO_ZOOM);

  resvg_fit_to = record
    _type: resvg_fit_to_type;
    value: single;
   end;


  resvg_shape_rendering = (RESVG_SHAPE_RENDERING_OPTIMIZE_SPEED,
   RESVG_SHAPE_RENDERING_CRISP_EDGES,RESVG_SHAPE_RENDERING_GEOMETRIC_PRECISION
   );

  resvg_text_rendering = (RESVG_TEXT_RENDERING_OPTIMIZE_SPEED,
   RESVG_TEXT_RENDERING_OPTIMIZE_LEGIBILITY,
   RESVG_TEXT_RENDERING_GEOMETRIC_PRECISION
   );


  resvg_image_rendering = (RESVG_IMAGE_RENDERING_OPTIMIZE_QUALITY,
   RESVG_IMAGE_RENDERING_OPTIMIZE_SPEED
   );

  resvg_rect = record
    x: double;
    y: double;
    width: double;
    height: double;
   end;

  resvg_size = record
    width: double;
    height: double;
   end;

  resvg_transform = record
    a: double;
    b: double;
    c: double;
    d: double;
    e: double;
    f: double;
   end;

Type
  Pcairo_t = pointer;
  Presvg_options = pointer;
  Presvg_rect = ^resvg_rect;
  Presvg_render_tree = pointer;
  Presvg_transform = ^resvg_transform;
  Presvg_image = pointer;


 procedure resvg_init_log; cdecl; external resvgdll;
 function resvg_parse_tree_from_data(data:Pchar; len:longword; opt:Presvg_options; tree:Presvg_render_tree):longint; cdecl; external resvgdll;
 function resvg_get_image_viewbox(tree:Presvg_render_tree):resvg_rect; cdecl; external resvgdll;
 function resvg_node_exists(tree:Presvg_render_tree; id:PAnsiChar):boolean; cdecl; external resvgdll;
 function resvg_get_node_bbox(tree:Presvg_render_tree; id:PAnsiChar; bbox:Presvg_rect):boolean; cdecl; external resvgdll;
 procedure resvg_tree_destroy(tree:Presvg_render_tree); cdecl; external resvgdll;
 procedure resvg_render(tree:Presvg_render_tree; fit_to:resvg_fit_to; width, height:integer; Img:Pchar); cdecl; external resvgdll;

 procedure resvg_options_load_system_fonts(opt:Presvg_options); cdecl; external resvgdll;
 function resvg_options_create():Presvg_options; cdecl; external resvgdll;
 procedure resvg_options_destroy(opt:Presvg_options); cdecl; external resvgdll;
 procedure resvg_options_set_resources_dir(opt:Presvg_options; file_path:PAnsiChar); cdecl; external resvgdll;
 procedure resvg_options_set_dpi(opt:Presvg_options; dpi: double); cdecl; external resvgdll;
 procedure resvg_options_set_keep_named_groups(opt:Presvg_options; keep:boolean);cdecl; external resvgdll;
 procedure resvg_options_set_shape_rendering_mode(opt:Presvg_options;  mode:resvg_shape_rendering );cdecl; external resvgdll;
 procedure resvg_options_set_text_rendering_mode(opt:Presvg_options;  mode:resvg_text_rendering );cdecl; external resvgdll;
 procedure resvg_options_set_image_rendering_mode(opt:Presvg_options;  mode:resvg_image_rendering );cdecl; external resvgdll;
 function resvg_options_load_font_file(opt:Presvg_options; file_path:PAnsiChar):Integer ;cdecl; external resvgdll;


implementation


end.
