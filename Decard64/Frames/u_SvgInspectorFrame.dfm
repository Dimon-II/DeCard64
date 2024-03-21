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
    ActivePage = tsReplace
    Align = alClient
    TabOrder = 0
    OnChange = pcAtrInspectorChange
    object tsAtr: TTabSheet
      Caption = 'Inspector'
      OnResize = tsAtrResize
      object splInspector: TSplitter
        Left = 0
        Top = 427
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
        Height = 391
        Align = alClient
        BevelInner = bvNone
        ColCount = 4
        Ctl3D = False
        DefaultColWidth = 120
        DefaultRowHeight = 19
        DrawingStyle = gdsClassic
        RowCount = 2
        Options = [goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goAlwaysShowEditor, goFixedColClick]
        ParentCtl3D = False
        TabOrder = 0
        OnDblClick = aEditExecute
        OnDrawCell = sgAttrDrawCell
        OnKeyDown = sgAttrKeyDown
        OnSelectCell = sgAttrSelectCell
        OnSetEditText = sgAttrSetEditText
        OnTopLeftChanged = sgAttrTopLeftChanged
      end
      object meHint: TMemo
        Left = 0
        Top = 433
        Width = 610
        Height = 98
        Align = alBottom
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clInfoBk
        Ctl3D = False
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
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 610
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 88
          Height = 36
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object cbAtrShow: TComboBox
            Left = 3
            Top = 6
            Width = 80
            Height = 23
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 0
            Text = 'All'
            OnClick = cbAtrShowClick
            Items.Strings = (
              'All'
              'Non empty')
          end
        end
        object tbrInspector: TToolBar
          Left = 88
          Top = 0
          Width = 522
          Height = 36
          Align = alClient
          AutoSize = True
          ButtonHeight = 38
          ButtonWidth = 36
          Caption = 'tbrInspector'
          Images = MainData.ilHelper
          ShowCaptions = True
          TabOrder = 1
          Wrapable = False
          object tbResize: TToolButton
            Left = 0
            Top = 0
            Caption = 'Size'
            ImageIndex = 22
          end
          object tbEdit: TToolButton
            Left = 36
            Top = 0
            Action = aEdit
          end
          object ToolButton16: TToolButton
            Left = 72
            Top = 0
            Width = 8
            Caption = 'ToolButton16'
            ImageIndex = 11
            Style = tbsSeparator
          end
          object tbSetColor: TToolButton
            Left = 80
            Top = 0
            Caption = 'Color'
            ImageIndex = 12
            OnClick = tbSetColorClick
          end
          object tbPipe: TToolButton
            Left = 116
            Top = 0
            Hint = 'Color picker'
            Caption = 'Pike'
            ImageIndex = 30
            Style = tbsCheck
            OnClick = tbPipeClick
          end
          object tbFont: TToolButton
            Left = 152
            Top = 0
            Caption = 'Font'
            ImageIndex = 19
            OnClick = tbFontClick
          end
          object tbFileXlink: TToolButton
            Left = 188
            Top = 0
            Caption = 'File'
            ImageIndex = 18
            OnClick = tbFileXlinkClick
          end
          object ToolButton28: TToolButton
            Left = 224
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
        Height = 448
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 610
        ExplicitHeight = 456
        inherited SynEditor: TSynEdit
          Width = 610
          Height = 420
          ReadOnly = True
          WordWrap = False
          ExplicitWidth = 610
          ExplicitHeight = 428
        end
        inherited pscrSysEdit: TPageScroller
          Width = 610
          ExplicitWidth = 610
        end
      end
      object meReplaceHint: TMemo
        Left = 0
        Top = 448
        Width = 610
        Height = 83
        Align = alBottom
        BorderStyle = bsNone
        Color = clInfoBk
        Ctl3D = False
        Lines.Strings = (
          'REPLACEMENT SYNTAX:'
          '[Caption] Beginning of named block'
          'macro=value (case insensitive)'
          'Macros==value (case sensitive)'
          'macro=$regexp'
          'Escape character "=" with \=  to use in macro name')
        ParentCtl3D = False
        ReadOnly = True
        TabOrder = 1
      end
    end
    object tsLangPack: TTabSheet
      Caption = 'LangPack'
      ImageIndex = 2
      object SynEditor: TSynEdit
        Left = 0
        Top = 0
        Width = 610
        Height = 320
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        CodeFolding.ShowCollapsedLine = True
        UseCodeFolding = False
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.Font.Quality = fqClearTypeNatural
        Gutter.ShowLineNumbers = True
        Highlighter = SynIniSyn1
        Options = [eoAutoIndent, eoDragDropEditing, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
        SearchEngine = ReplaceFrame.SynEditSearch1
        OnChange = SynEditorChange
        RemovedKeystrokes = <
          item
            Command = ecLineBreak
            ShortCut = 8205
          end
          item
            Command = ecContextHelp
            ShortCut = 112
          end>
        AddedKeystrokes = <>
      end
      object meLangHint: TMemo
        Left = 0
        Top = 320
        Width = 610
        Height = 211
        Align = alBottom
        BorderStyle = bsNone
        Color = clInfoBk
        Ctl3D = False
        Lines.Strings = (
          'SUPPORT FOR MULTIPLE LANGUAGES IN ONE TEMPLATE:'
          
            'On the first line, enter the identifier of the base language tha' +
            't is used in the template and list the numbers of '
          
            'the columns containing text data, which are used in the template' +
            '.'
          
            'If you have text in 2 or more languages, add lines here with the' +
            ' language identifier and column numbers in that '
          'language that correspond to the columns in the first line.'
          'The choice of language is made on the top right corner.'
          ''
          'Example:'
          '[en]=15,16,17,18'
          '[ru]=22,23,24,25'
          '[es]=26,27,28,29'
          ''
          
            'In this example, there are 3 languages (English used in the temp' +
            'late and additional Russian and Spanish), 4 '
          
            'columns each. That is, when choosing the Russian language, colum' +
            'ns [15],[16],[17],[18] are not used, and data '
          'from [22],[23],'
          '[24],[25] are substituted instead.')
        ParentCtl3D = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
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
  object SynIniSyn1: TSynIniSyn
    Left = 204
    Top = 306
  end
end
