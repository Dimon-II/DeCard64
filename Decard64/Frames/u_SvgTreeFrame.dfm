object SvgTreeFrame: TSvgTreeFrame
  Left = 0
  Top = 0
  Width = 444
  Height = 420
  TabOrder = 0
  object treeTemplate: TTreeView
    Left = 0
    Top = 49
    Width = 444
    Height = 371
    Align = alClient
    HideSelection = False
    Indent = 14
    ReadOnly = True
    ShowRoot = False
    TabOrder = 0
    OnCollapsing = treeTemplateCollapsing
  end
  object pscrTemplate: TPageScroller
    Left = 0
    Top = 0
    Width = 444
    Height = 44
    Align = alTop
    ButtonSize = 16
    Control = tbrTemplate
    TabOrder = 1
    object tbrTemplate: TToolBar
      Left = 0
      Top = 0
      Width = 288
      Height = 48
      Align = alNone
      AutoSize = True
      ButtonHeight = 46
      ButtonWidth = 35
      Caption = 'tbrTemplate'
      EdgeBorders = [ebBottom]
      Images = MainData.ilDecard
      ShowCaptions = True
      TabOrder = 0
      Wrapable = False
      object ToolButton37: TToolButton
        Left = 0
        Top = 0
        Hint = 'File operations'
        Caption = 'File'
        ImageIndex = 34
        MenuItem = File1
      end
      object ToolButton3: TToolButton
        Left = 35
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 15
        Style = tbsSeparator
      end
      object btnNewObject: TToolButton
        Left = 43
        Top = 0
        Hint = 'Add new object'
        Caption = ' Add '
        DropdownMenu = pmAddTag
        ImageIndex = 42
      end
      object tbCopyTag: TToolButton
        Left = 78
        Top = 0
        Hint = 'Remember selected object'
        Caption = 'Copy'
        ImageIndex = 46
        OnClick = tbCopyTagClick
      end
      object btn10: TToolButton
        Left = 113
        Top = 0
        Hint = 'Delete object'
        Caption = 'Del'
        ImageIndex = 41
        OnClick = btn10Click
      end
      object btnUp: TToolButton
        Left = 148
        Top = 0
        Hint = 'Move up (Z-order)'
        Caption = 'Up'
        ImageIndex = 43
        OnClick = btnUpClick
      end
      object btnDown: TToolButton
        Left = 183
        Top = 0
        Hint = 'Move down (Z-order)'
        Caption = 'Dn'
        ImageIndex = 44
        OnClick = btnDownClick
      end
      object btnSearch1: TToolButton
        Left = 218
        Top = 0
        Hint = 'Search element'
        Caption = 'Find'
        ImageIndex = 47
        OnClick = btnSearch1Click
      end
      object tbXML: TToolButton
        Left = 253
        Top = 0
        Hint = 'XML-SVG editor'
        Caption = 'XML'
        ImageIndex = 27
        OnClick = tbXMLClick
      end
    end
  end
  object pnFindRemind: TPanel
    Left = 0
    Top = 44
    Width = 444
    Height = 5
    Align = alTop
    BevelOuter = bvNone
    Color = clAqua
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 2
    Visible = False
    object pnRemindDialog: TPanel
      Left = 0
      Top = 44
      Width = 600
      Height = 5
      BevelOuter = bvNone
      Color = clAqua
      Ctl3D = False
      ParentBackground = False
      ParentCtl3D = False
      TabOrder = 0
      Visible = False
    end
  end
  object pmAddTag: TPopupMenu
    Images = MainData.ilTags
    OnPopup = pmAddTagPopup
    Left = 41
    Top = 72
    object miPasteTag: TMenuItem
      Caption = 'Paste'
      OnClick = miPasteTagClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object miRect: TMenuItem
      Caption = '&Rectangle <rect/>'
      ImageIndex = 0
      OnClick = miRectClick
    end
    object miEllipse: TMenuItem
      Caption = '&Ellipse <ellipse/>'
      ImageIndex = 1
      OnClick = miEllipseClick
    end
    object miImage: TMenuItem
      Caption = 'Picture <&image/>'
      ImageIndex = 2
      OnClick = miImageClick
    end
    object Pathpathd1: TMenuItem
      Caption = 'Path <path d="..."/>'
      ImageIndex = 1
      OnClick = Pathpathd1Click
    end
    object miUse: TMenuItem
      Caption = 'Linked object <&use/>'
      ImageIndex = 3
      OnClick = miUseClick
    end
    object miText: TMenuItem
      Caption = 'Text <&text>...</text>'
      ImageIndex = 4
      OnClick = miTextClick
    end
    object mig: TMenuItem
      Caption = 'Group <g> '
      ImageIndex = 6
      OnClick = migClick
    end
    object misymbol: TMenuItem
      Caption = 'Invisible group <symbol/> '
      OnClick = misymbolClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object midefs: TMenuItem
      Caption = 'Internal clipart <defs/>'
      OnClick = midefsClick
    end
    object mimask: TMenuItem
      Caption = 'Mask <mask/>'
      OnClick = mimaskClick
    end
    object clipPath1: TMenuItem
      Caption = 'Crop area <clipPath/>'
      OnClick = clipPath1Click
    end
    object miPattert: TMenuItem
      Caption = 'Feeling pattern <pattern/>'
      OnClick = miPattertClick
    end
    object milinearGradient: TMenuItem
      Caption = 'Gradient [||] <linearGradient/>'
      OnClick = milinearGradientClick
    end
    object miradialGradient: TMenuItem
      Caption = 'Gradient (()) <radialGradient/> '
      OnClick = miradialGradientClick
    end
    object mistop: TMenuItem
      Caption = 'Gradient'#39's color <stop/> '
      OnClick = mistopClick
    end
    object mifilter: TMenuItem
      Caption = 'Preset filters <filter/>'
      object miShadow: TMenuItem
        Caption = 'Shadow'
        ImageIndex = 8
        OnClick = miShadowClick
      end
      object miGlowing: TMenuItem
        Caption = 'Glowing'
        ImageIndex = 9
        OnClick = miGlowingClick
      end
      object miGlowcolor: TMenuItem
        Caption = 'Glow color'
        ImageIndex = 10
        OnClick = miGlowcolorClick
      end
      object miTurbulence: TMenuItem
        Caption = 'Turbulence'
        ImageIndex = 11
        OnClick = miTurbulenceClick
      end
      object Embossing1: TMenuItem
        Caption = 'Embossing'
        ImageIndex = 12
        OnClick = Embossing1Click
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miforeignObject: TMenuItem
      Caption = 'HTML <foreignObject> Browser'
      OnClick = miforeignObjectClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object micutting: TMenuItem
      Caption = 'Cutting mark'
      ImageIndex = 7
      object miOuterCross: TMenuItem
        Caption = 'Outer cross <g><line ...>'
        OnClick = miOuterCrossClick
      end
      object miInnerCrss: TMenuItem
        Caption = 'Inner cross <g><line ...>'
        OnClick = miInnerCrssClick
      end
    end
  end
  object pmFileSVG: TPopupMenu
    Images = MainData.ilDecard
    Left = 134
    Top = 71
    object File1: TMenuItem
      Caption = 'File'
      Hint = 'File operations'
      ImageIndex = 34
      object Load1: TMenuItem
        Caption = 'Load template'
        ImageIndex = 35
      end
      object Save1: TMenuItem
        Caption = 'Save template'
        ImageIndex = 34
      end
      object Clear1: TMenuItem
        Caption = 'Clear template'
        ImageIndex = 17
        OnClick = Clear1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Export1: TMenuItem
        Caption = 'Export'
        ImageIndex = 6
        object Exportbranch1: TMenuItem
          Caption = 'Export branch'
          ImageIndex = 34
          OnClick = Exportbranch1Click
        end
        object Exportheader1: TMenuItem
          Caption = 'Export header'
          ImageIndex = 27
          OnClick = Exportheader1Click
        end
      end
    end
  end
  object svgFindDialog: TFindDialog
    OnClose = svgFindDialogClose
    OnShow = svgFindDialogShow
    OnFind = svgFindDialogFind
    Left = 216
    Top = 72
  end
end
