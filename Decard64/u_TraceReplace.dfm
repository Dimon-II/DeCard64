object TraceReplForm: TTraceReplForm
  Left = 0
  Top = 0
  Caption = 'Trace replaces'
  ClientHeight = 578
  ClientWidth = 901
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 641
    Top = 21
    Height = 557
    ExplicitLeft = 832
    ExplicitTop = 240
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 257
    Top = 21
    Height = 557
    ExplicitLeft = 296
    ExplicitTop = 8
    ExplicitHeight = 578
  end
  object seResult: TSynEdit
    Left = 644
    Top = 21
    Width = 257
    Height = 557
    Align = alClient
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 0
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = True
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.Font.Quality = fqClearTypeNatural
    Gutter.ShowLineNumbers = True
    Highlighter = SynXMLSyn1
    Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoShowSpecialChars, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    ReadOnly = True
    FontSmoothing = fsmNone
  end
  object seCell: TSynEdit
    Left = 260
    Top = 21
    Width = 381
    Height = 557
    Align = alLeft
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 1
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = True
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.Font.Quality = fqClearTypeNatural
    Gutter.ShowLineNumbers = True
    Highlighter = SynXMLSyn1
    Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoShowSpecialChars, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    FontSmoothing = fsmNone
  end
  object seRepl: TSynEdit
    Left = 0
    Top = 21
    Width = 257
    Height = 557
    Align = alLeft
    Color = clCream
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 2
    CodeFolding.GutterShapeSize = 11
    CodeFolding.CollapsedLineColor = clGrayText
    CodeFolding.FolderBarLinesColor = clGrayText
    CodeFolding.IndentGuidesColor = clGray
    CodeFolding.IndentGuides = True
    CodeFolding.ShowCollapsedLine = True
    CodeFolding.ShowHintMark = True
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.Font.Quality = fqClearTypeNatural
    Gutter.ShowLineNumbers = True
    Highlighter = SynXMLSyn1
    Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoShowSpecialChars, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    OnGutterGetText = seReplGutterGetText
    OnSpecialLineColors = seReplSpecialLineColors
    FontSmoothing = fsmNone
  end
  object tbrTrace: TToolBar
    Left = 0
    Top = 0
    Width = 901
    Height = 21
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 47
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 3
    object tbTraceTo: TToolButton
      Left = 0
      Top = 0
      Action = aTraceTo
    end
    object tbTraceNext: TToolButton
      Left = 47
      Top = 0
      Action = aTraceNext
    end
    object tbTraceAll: TToolButton
      Left = 94
      Top = 0
      Action = aTraceAll
    end
  end
  object SynXMLSyn1: TSynXMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    WantBracesParsed = False
    Left = 272
    Top = 56
  end
  object alTrace: TActionList
    Left = 392
    Top = 112
    object aTraceTo: TAction
      Caption = 'Trace to'#13#10
      Hint = 'Trace to line'
      ShortCut = 116
      OnExecute = aTraceToExecute
    end
    object aTraceNext: TAction
      Caption = '...next'
      Hint = 'Trace next line'
      ShortCut = 118
      OnExecute = aTraceNextExecute
    end
    object aTraceAll: TAction
      Caption = '...All'
      Hint = 'Trace all'
      ShortCut = 120
      OnExecute = aTraceAllExecute
    end
  end
end
