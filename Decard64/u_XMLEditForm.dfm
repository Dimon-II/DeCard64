object XMLEditForm: TXMLEditForm
  Left = 0
  Top = 0
  Caption = 'XML-Edit '
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 399
    ExplicitWidth = 620
    DesignSize = (
      624
      41)
    object btnApply: TButton
      Left = 460
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 456
    end
    object btnCancel: TButton
      Left = 541
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 537
    end
  end
  object pnEdit: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 400
    Align = alClient
    TabOrder = 1
    object splTags: TSplitter
      Left = 1
      Top = 244
      Width = 622
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Beveled = True
      ExplicitTop = 246
    end
    inline SynEditFrame: TSynEditFrame
      Left = 1
      Top = 1
      Width = 622
      Height = 243
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 622
      ExplicitHeight = 243
      inherited SynEditor: TSynEdit
        Width = 622
        Height = 215
        ExplicitWidth = 618
        ExplicitHeight = 214
      end
      inherited pscrSysEdit: TPageScroller
        Width = 622
        ExplicitWidth = 622
      end
    end
    object seTags: TSynEdit
      Left = 1
      Top = 249
      Width = 622
      Height = 150
      Align = alBottom
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      TabOrder = 1
      CodeFolding.ShowCollapsedLine = True
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.Font.Quality = fqClearTypeNatural
      Gutter.Bands = <
        item
          Kind = gbkMarks
          Width = 13
        end
        item
          Kind = gbkLineNumbers
        end
        item
          Kind = gbkFold
        end
        item
          Kind = gbkTrackChanges
        end
        item
          Kind = gbkMargin
          Width = 3
        end>
      Highlighter = SynEditFrame.SynXMLSyn1
      Lines.Strings = (
        'Known tags:'
        '<b>...</b> <i>...</i> <u>...</u>'
        '<p>...</p> <br/> <hr/>'
        
          '<div align="left / center/ right / width" line-height="normal / ' +
          'pixels / %" html-width='#39'pixels'#39'>...</div>'
        
          '<font size="1..7" face="Arial / Comic Sans MS / ..." color="" te' +
          'xt-indent="">...</font>'
        '<img src="bitmap file" width="xxx" height="yyy" dy='#39'...'#39'/>'
        '<use src="#defs ref" width="xxx" height="yyy"  dy='#39'...'#39'/>'
        '<use src="clipart.svg#ref" width="xxx" height="yyy"  dy='#39'...'#39'/>'
        '<bkg src="bitmap file" or any rect attributes />')
      ReadOnly = True
      SelectedColor.Alpha = 0.400000005960464500
      ExplicitTop = 248
      ExplicitWidth = 618
    end
  end
end
