object SvgInspectorFrame: TSvgInspectorFrame
  Left = 0
  Top = 0
  Width = 618
  Height = 561
  TabOrder = 0
  object pcAtrInspector: TPageControl
    Left = 0
    Top = 0
    Width = 618
    Height = 561
    ActivePage = tsAtr
    Align = alClient
    TabOrder = 0
    OnChange = pcAtrInspectorChange
    object tsAtr: TTabSheet
      Caption = 'Inspector'
      OnResize = tsAtrResize
      object splInspector: TSplitter
        Left = 0
        Top = 429
        Width = 610
        Height = 6
        Cursor = crVSplit
        Align = alBottom
        Beveled = True
        ExplicitTop = 430
      end
      object sgAttr: TStringGrid
        Left = 0
        Top = 36
        Width = 610
        Height = 393
        Align = alClient
        BevelInner = bvNone
        ColCount = 4
        Ctl3D = False
        DefaultColWidth = 80
        DefaultRowHeight = 19
        DrawingStyle = gdsClassic
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goAlwaysShowEditor, goFixedColClick]
        ParentCtl3D = False
        TabOrder = 0
        OnDrawCell = sgAttrDrawCell
        OnKeyDown = sgAttrKeyDown
        OnSelectCell = sgAttrSelectCell
        OnSetEditText = sgAttrSetEditText
        OnTopLeftChanged = sgAttrTopLeftChanged
      end
      object meHint: TMemo
        Left = 0
        Top = 435
        Width = 610
        Height = 98
        Align = alBottom
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object pscrInspector: TPageScroller
        Left = 0
        Top = 0
        Width = 610
        Height = 36
        Align = alTop
        Control = tbrInspector
        TabOrder = 2
        object tbrInspector: TToolBar
          Left = 0
          Top = 0
          Width = 280
          Height = 36
          Align = alNone
          AutoSize = True
          ButtonHeight = 36
          ButtonWidth = 32
          Caption = 'tbrInspector'
          Images = MainData.ilHelper
          ShowCaptions = True
          TabOrder = 0
          Wrapable = False
          object cbAtrShow: TComboBox
            Left = 0
            Top = 0
            Width = 80
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = 'All'
            OnClick = cbAtrShowClick
            Items.Strings = (
              'All'
              'Non empty')
          end
          object tbResize: TToolButton
            Left = 80
            Top = 0
            Caption = 'Size'
            ImageIndex = 22
          end
          object tbEdit: TToolButton
            Left = 112
            Top = 0
            Action = aEdit
          end
          object ToolButton16: TToolButton
            Left = 144
            Top = 0
            Width = 8
            Caption = 'ToolButton16'
            ImageIndex = 11
            Style = tbsSeparator
          end
          object tbSetColor: TToolButton
            Left = 152
            Top = 0
            Caption = 'Color'
            ImageIndex = 12
            OnClick = tbSetColorClick
          end
          object tbFont: TToolButton
            Left = 184
            Top = 0
            Caption = 'Font'
            ImageIndex = 19
            OnClick = tbFontClick
          end
          object tbFileXlink: TToolButton
            Left = 216
            Top = 0
            Caption = 'File'
            ImageIndex = 18
            OnClick = tbFileXlinkClick
          end
          object ToolButton28: TToolButton
            Left = 248
            Top = 0
            Caption = 'Defs'
            ImageIndex = 21
            Visible = False
          end
        end
      end
    end
    object tsReplace: TTabSheet
      Caption = 'Replace'
      ImageIndex = 1
      inline ReplaceFrame: TSynEditFrame
        Left = 0
        Top = 0
        Width = 610
        Height = 533
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 610
        ExplicitHeight = 533
        inherited SynEditor: TSynEdit
          Width = 610
          Height = 505
          ReadOnly = True
          WordWrap = False
          ExplicitWidth = 610
          ExplicitHeight = 505
        end
        inherited pscrSysEdit: TPageScroller
          Width = 610
          ExplicitWidth = 610
        end
      end
    end
  end
  object alInspector: TActionList
    Images = MainData.ilHelper
    Left = 164
    Top = 168
    object aEdit: TAction
      Caption = 'Edit'
      ImageIndex = 15
      OnExecute = aEditExecute
    end
  end
end
