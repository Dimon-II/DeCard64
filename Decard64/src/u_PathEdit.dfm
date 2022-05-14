object frmPathEdit: TfrmPathEdit
  Left = 0
  Top = 0
  Caption = 'Path Editor'
  ClientHeight = 532
  ClientWidth = 1112
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  object splLeft: TSplitter
    Left = 661
    Top = 0
    Height = 532
    Align = alRight
    ExplicitLeft = 400
    ExplicitTop = 256
    ExplicitHeight = 100
  end
  object pnSVG: TGroupBox
    Left = 664
    Top = 0
    Width = 448
    Height = 532
    Align = alRight
    Caption = 'SVG'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 2
      Top = 242
      Width = 444
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitLeft = -2
      ExplicitTop = 264
    end
    object ToolBar1: TToolBar
      Left = 2
      Top = 43
      Width = 444
      Height = 23
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 38
      Caption = 'ToolBar1'
      EdgeBorders = [ebTop]
      ShowCaptions = True
      TabOrder = 1
      object ToolButton8: TToolButton
        Left = 0
        Top = 0
        Caption = 'Add'
        DropdownMenu = PopupMenu1
        ImageIndex = 5
      end
      object ToolButton10: TToolButton
        Left = 38
        Top = 0
        Caption = 'Delete'
        MenuItem = Delete1
      end
      object ToolButton6: TToolButton
        Left = 76
        Top = 0
        Width = 8
        Caption = 'ToolButton6'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object ToolButton3: TToolButton
        Left = 84
        Top = 0
        Caption = 'Undo'
        ImageIndex = 4
        OnClick = ToolButton3Click
      end
      object ToolButton9: TToolButton
        Left = 122
        Top = 0
        Width = 8
        Caption = 'ToolButton9'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object ToolButton1: TToolButton
        Left = 130
        Top = 0
        Hint = 'Absolute X:Y'
        Caption = 'Abs'
        ImageIndex = 0
        OnClick = ToolButton1Click
      end
      object ToolButton2: TToolButton
        Left = 168
        Top = 0
        Hint = 'Relative X^Y'
        Caption = 'Rel'
        ImageIndex = 1
        OnClick = ToolButton2Click
      end
      object ToolButton11: TToolButton
        Left = 206
        Top = 0
        Caption = 'Flip:H'
        ImageIndex = 4
        OnClick = ToolButton11Click
      end
      object ToolButton12: TToolButton
        Left = 244
        Top = 0
        Caption = 'Flip:V'
        ImageIndex = 5
        OnClick = ToolButton12Click
      end
      object ToolButton5: TToolButton
        Left = 282
        Top = 0
        Width = 8
        Caption = 'ToolButton5'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object ToolButton7: TToolButton
        Left = 290
        Top = 0
        Caption = 'Reset'
        ImageIndex = 3
        OnClick = ToolButton7Click
      end
      object tbApply: TToolButton
        Left = 328
        Top = 0
        Caption = 'Apply'
        ImageIndex = 3
        OnClick = tbApplyClick
      end
    end
    object sgDots: TStringGrid
      Left = 2
      Top = 66
      Width = 444
      Height = 176
      Align = alClient
      ColCount = 9
      DefaultColWidth = 48
      DefaultRowHeight = 18
      DrawingStyle = gdsClassic
      FixedCols = 2
      RowCount = 2
      Options = [goVertLine, goHorzLine, goColSizing, goEditing, goRowSelect]
      PopupMenu = pmPathEdit
      TabOrder = 0
      OnDblClick = sgDotsDblClick
      OnExit = sgDotsExit
      OnKeyPress = sgDotsKeyPress
      OnSelectCell = sgDotsSelectCell
      OnSetEditText = sgDotsSetEditText
    end
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 444
      Height = 28
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Label1: TLabel
        Left = 6
        Top = 3
        Width = 26
        Height = 13
        Caption = 'Zoom'
      end
      object Label2: TLabel
        Left = 93
        Top = 3
        Width = 19
        Height = 13
        Caption = 'Grid'
      end
      object seZoom: TSpinEdit
        Left = 38
        Top = 0
        Width = 49
        Height = 22
        MaxLength = 3
        MaxValue = 128
        MinValue = -16
        TabOrder = 0
        Value = 1
        OnChange = seZoomChange
      end
      object seGrid: TSpinEdit
        Left = 128
        Top = 0
        Width = 49
        Height = 22
        MaxLength = 3
        MaxValue = 64
        MinValue = 1
        TabOrder = 1
        Value = 10
        OnChange = seGridChange
      end
      object chbCard: TCheckBox
        Left = 193
        Top = 2
        Width = 72
        Height = 17
        Caption = 'Card rect'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = chbCardClick
      end
    end
    object UndoList: TListBox
      Left = 2
      Top = 395
      Width = 444
      Height = 104
      Align = alBottom
      ItemHeight = 13
      TabOrder = 3
      Visible = False
    end
    object mePATH: TSynEdit
      Left = 2
      Top = 245
      Width = 444
      Height = 150
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      TabOrder = 4
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Consolas'
      Gutter.Font.Style = []
      Highlighter = SynGeneralSyn1
      Lines.Strings = (
        'M 0,0')
      WordWrap = True
      OnChange = mePATHChange
    end
    object Panel2: TPanel
      Left = 2
      Top = 499
      Width = 444
      Height = 31
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 5
      object btnApply: TButton
        AlignWithMargins = True
        Left = 285
        Top = 3
        Width = 75
        Height = 25
        Align = alRight
        Caption = 'Apply'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ModalResult = 1
        ParentFont = False
        TabOrder = 0
        OnClick = btnApplyClick
      end
      object btnCancel: TButton
        AlignWithMargins = True
        Left = 366
        Top = 3
        Width = 75
        Height = 25
        Align = alRight
        Cancel = True
        Caption = 'Cancel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 661
    Height = 532
    Align = alClient
    BevelOuter = bvLowered
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    object Draw: TPaintBox
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 643
      Height = 514
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      DragCursor = crSizeAll
      PopupMenu = pmPathEdit
      OnDblClick = DrawDblClick
      OnDragOver = shDot1DragOver
      OnMouseDown = DrawMouseDown
      OnMouseMove = DrawMouseMove
      OnPaint = DrawPaint
      OnStartDrag = DrawStartDrag
      ExplicitLeft = 10
      ExplicitTop = 3
      ExplicitWidth = 645
      ExplicitHeight = 516
    end
    object shAng1: TShape
      Left = 80
      Top = 192
      Width = 16
      Height = 16
      Brush.Style = bsClear
      DragCursor = crCross
      DragMode = dmAutomatic
      Pen.Color = clRed
      Shape = stCircle
      OnDragDrop = shAng1DragDrop
      OnDragOver = shDot1DragOver
      OnMouseDown = shDot2MouseDown
    end
    object shDot2: TShape
      Left = 152
      Top = 192
      Width = 16
      Height = 16
      Brush.Style = bsClear
      DragCursor = crCross
      DragMode = dmAutomatic
      Pen.Color = clBlue
      Pen.Width = 2
      Shape = stCircle
      OnDragDrop = shAng1DragDrop
      OnDragOver = shDot1DragOver
      OnMouseDown = shDot2MouseDown
    end
    object shAng2: TShape
      Left = 152
      Top = 256
      Width = 16
      Height = 16
      Brush.Style = bsClear
      DragCursor = crCross
      DragMode = dmAutomatic
      Pen.Color = clRed
      Shape = stCircle
      OnDragDrop = shAng1DragDrop
      OnDragOver = shDot1DragOver
      OnMouseDown = shDot2MouseDown
    end
    object shDot1: TShape
      Left = 80
      Top = 264
      Width = 16
      Height = 16
      Brush.Style = bsClear
      DragCursor = crCross
      DragMode = dmAutomatic
      Pen.Color = clRed
      Shape = stCircle
      Visible = False
      OnDragDrop = shAng1DragDrop
      OnDragOver = shDot1DragOver
      OnMouseDown = shDot2MouseDown
    end
  end
  object pmPathEdit: TPopupMenu
    Left = 372
    Top = 128
    object LineTo1: TMenuItem
      Caption = 'LineTo'
      ShortCut = 76
      OnClick = ZloseZ1Click
    end
    object Curve1: TMenuItem
      Tag = 1
      Caption = 'Curve'
      ShortCut = 67
      OnClick = ZloseZ1Click
    end
    object Curve2: TMenuItem
      Tag = 2
      Caption = 'Curve +'
      ShortCut = 83
      OnClick = ZloseZ1Click
    end
    object Quadratic1: TMenuItem
      Tag = 3
      Caption = 'Quadratic'
      ShortCut = 81
      OnClick = ZloseZ1Click
    end
    object Quadratic2: TMenuItem
      Tag = 4
      Caption = 'Quadratic +'
      ShortCut = 84
      OnClick = ZloseZ1Click
    end
    object Arc1: TMenuItem
      Tag = 5
      Caption = 'Arc'
      ShortCut = 65
      OnClick = ZloseZ1Click
    end
    object Horizontal1: TMenuItem
      Tag = 6
      Caption = 'Horizontal'
      ShortCut = 72
      OnClick = ZloseZ1Click
    end
    object Vertical1: TMenuItem
      Tag = 7
      Caption = 'Vertical'
      ShortCut = 86
      OnClick = ZloseZ1Click
    end
    object MoveTo1: TMenuItem
      Tag = 8
      Caption = 'MoveTo'
      ShortCut = 77
      OnClick = ZloseZ1Click
    end
    object ZloseZ1: TMenuItem
      Tag = 9
      Caption = 'Close'
      ShortCut = 90
      OnClick = ZloseZ1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Abs1: TMenuItem
      Caption = 'Absolute X:Y'
      OnClick = Abs1Click
    end
    object Ref1: TMenuItem
      Caption = 'Relative X:Y'
      OnClick = Ref1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      ShortCut = 16430
      OnClick = Delete1Click
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 283
    Top = 144
  end
  object PopupMenu1: TPopupMenu
    Left = 188
    Top = 152
    object MenuItem1: TMenuItem
      Caption = 'LineTo'
      ShortCut = 76
      OnClick = ZloseZ1Click
    end
    object MenuItem2: TMenuItem
      Tag = 1
      Caption = 'Curve'
      ShortCut = 67
      OnClick = ZloseZ1Click
    end
    object MenuItem3: TMenuItem
      Tag = 2
      Caption = 'Curve +'
      ShortCut = 83
      OnClick = ZloseZ1Click
    end
    object MenuItem4: TMenuItem
      Tag = 3
      Caption = 'Quadratic'
      ShortCut = 81
      OnClick = ZloseZ1Click
    end
    object MenuItem5: TMenuItem
      Tag = 4
      Caption = 'Quadratic +'
      ShortCut = 84
      OnClick = ZloseZ1Click
    end
    object MenuItem6: TMenuItem
      Tag = 5
      Caption = 'Arc'
      ShortCut = 65
      OnClick = ZloseZ1Click
    end
    object MenuItem7: TMenuItem
      Tag = 6
      Caption = 'Horizontal'
      ShortCut = 72
      OnClick = ZloseZ1Click
    end
    object MenuItem8: TMenuItem
      Tag = 7
      Caption = 'Vertical'
      ShortCut = 86
      OnClick = ZloseZ1Click
    end
    object MenuItem9: TMenuItem
      Tag = 8
      Caption = 'MoveTo'
      ShortCut = 77
      OnClick = ZloseZ1Click
    end
    object MenuItem10: TMenuItem
      Tag = 9
      Caption = 'Close'
      ShortCut = 90
      OnClick = ZloseZ1Click
    end
  end
  object SynGeneralSyn1: TSynGeneralSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    DetectPreprocessor = False
    Left = 256
    Top = 352
  end
end
