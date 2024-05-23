object SynEditFrame: TSynEditFrame
  Left = 0
  Top = 0
  Width = 667
  Height = 573
  TabOrder = 0
  object SynEditor: TSynEdit
    Left = 0
    Top = 28
    Width = 667
    Height = 545
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 0
    OnExit = SynEditorExit
    OnKeyPress = SynEditorKeyPress
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
    Options = [eoAutoIndent, eoDragDropEditing, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
    SearchEngine = SynEditSearch1
    WordWrap = True
    FontSmoothing = fsmNone
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
  object pscrSysEdit: TPageScroller
    Left = 0
    Top = 0
    Width = 667
    Height = 28
    Align = alTop
    ButtonSize = 16
    Control = tbrEditor
    TabOrder = 1
    object tbrEditor: TToolBar
      Left = 0
      Top = 0
      Width = 440
      Height = 28
      Align = alLeft
      AutoSize = True
      ButtonHeight = 28
      ButtonWidth = 32
      Caption = 'tbrEditor'
      Images = MainData.ilEditor
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      object tbUndo: TToolButton
        Left = 0
        Top = 0
        Action = actEditUndo
      end
      object tbRedo: TToolButton
        Left = 32
        Top = 0
        Action = actEditRedo
      end
      object tbSep1: TToolButton
        Left = 64
        Top = 0
        Width = 8
        Caption = 'tbSep1'
        Enabled = False
        ImageIndex = 5
        Style = tbsSeparator
      end
      object tbCut: TToolButton
        Left = 72
        Top = 0
        Action = actEditCut
      end
      object tbCopy: TToolButton
        Left = 104
        Top = 0
        Action = actEditCopy
      end
      object tbPaste: TToolButton
        Left = 136
        Top = 0
        Action = actEditPaste
      end
      object ToolButton1: TToolButton
        Left = 168
        Top = 0
        Width = 8
        Caption = 'tbSep2'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object tbSearch: TToolButton
        Left = 176
        Top = 0
        Action = actSearchFind
      end
      object tbNext: TToolButton
        Left = 208
        Top = 0
        Action = actSearchFindNext
      end
      object tbRepl: TToolButton
        Left = 240
        Top = 0
        Action = actSearchReplace
      end
      object tbColorDialog: TToolButton
        Left = 272
        Top = 0
        Hint = 'Color dialog'
        Caption = 'tbColorDialog'
        ImageIndex = 53
        OnClick = tbColorDialogClick
      end
      object btnPipe: TToolButton
        Left = 304
        Top = 0
        Hint = 'Color picker'
        Caption = 'btnPipe'
        ImageIndex = 52
        OnClick = btnPipeClick
      end
      object ToolButton2: TToolButton
        Left = 336
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object tbSpec: TToolButton
        Left = 344
        Top = 0
        Hint = 'Show special chars'
        Caption = 'tbSpec'
        ImageIndex = 51
        Style = tbsCheck
        OnClick = tbSpecClick
      end
      object tbGlyph: TToolButton
        Left = 376
        Top = 0
        Hint = 'Choose glyph'
        Caption = 'Glyph'
        ImageIndex = 10
        OnClick = tbGlyphClick
      end
      object ToolButton3: TToolButton
        Left = 408
        Top = 0
        Caption = 'ToolButton3'
        ImageIndex = 22
        Visible = False
      end
    end
  end
  object actlMain: TActionList
    Left = 164
    Top = 56
    object actEditCut: TAction
      Category = 'Edit'
      Caption = 'Cu&t'
      Enabled = False
      Hint = 'Cut'
      ImageIndex = 0
      OnExecute = actEditCutExecute
      OnUpdate = actEditCutUpdate
    end
    object actEditCopy: TAction
      Category = 'Edit'
      Caption = '&Copy'
      Enabled = False
      Hint = 'Copy'
      ImageIndex = 1
      OnExecute = actEditCopyExecute
      OnUpdate = actEditCopyUpdate
    end
    object actEditPaste: TAction
      Category = 'Edit'
      Caption = '&Paste'
      Enabled = False
      Hint = 'Paste'
      ImageIndex = 2
      OnExecute = actEditPasteExecute
      OnUpdate = actEditPasteUpdate
    end
    object actEditDelete: TAction
      Category = 'Edit'
      Caption = 'De&lete'
      Enabled = False
      Hint = 'Delete'
      OnExecute = actEditDeleteExecute
      OnUpdate = actEditDeleteUpdate
    end
    object actEditUndo: TAction
      Category = 'Edit'
      Caption = '&Undo'
      Enabled = False
      Hint = 'Undo'
      ImageIndex = 3
      ShortCut = 16474
      OnExecute = actEditUndoExecute
      OnUpdate = actEditUndoUpdate
    end
    object actEditRedo: TAction
      Category = 'Edit'
      Caption = '&Redo'
      Enabled = False
      Hint = 'Dedo'
      ImageIndex = 4
      ShortCut = 24666
      OnExecute = actEditRedoExecute
      OnUpdate = actEditRedoUpdate
    end
    object actEditSelectAll: TAction
      Category = 'Edit'
      Caption = 'Select &All'
      Enabled = False
      Hint = 'Select all'
      ShortCut = 16449
      OnExecute = actEditSelectAllExecute
      OnUpdate = actEditSelectAllUpdate
    end
    object actSearchFind: TAction
      Category = 'Search'
      Caption = '&Find...'
      Enabled = False
      Hint = 'Find'
      ImageIndex = 12
      OnExecute = actSearchFindExecute
      OnUpdate = actSearchFindUpdate
    end
    object actSearchFindNext: TAction
      Category = 'Search'
      Caption = '&Next'
      Enabled = False
      Hint = 'Find next'
      ImageIndex = 9
      ShortCut = 114
      OnExecute = actSearchFindNextExecute
      OnUpdate = actSearchFindNextUpdate
    end
    object actSearchFindPrev: TAction
      Category = 'Search'
      Caption = 'Find &Previous'
      Enabled = False
      Hint = 'Find prev'
      ShortCut = 8306
      OnExecute = actSearchFindPrevExecute
      OnUpdate = actSearchFindPrevUpdate
    end
    object actSearchReplace: TAction
      Category = 'Search'
      Caption = '&Replace...'
      Enabled = False
      Hint = 'Replace'
      ImageIndex = 13
      ShortCut = 16456
      OnExecute = actSearchReplaceExecute
      OnUpdate = actSearchReplaceUpdate
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
  object SynEditSearch1: TSynEditSearch
    Left = 372
    Top = 56
  end
  object ReplaceDialog: TReplaceDialog
    OnClose = FindDialogClose
    OnShow = ReplaceDialogShow
    OnFind = ReplaceDialogFind
    OnReplace = ReplaceDialogReplace
    Left = 216
    Top = 128
  end
  object FindDialog: TFindDialog
    OnClose = FindDialogClose
    OnShow = FindDialogShow
    OnFind = FindDialogFind
    Left = 88
    Top = 128
  end
end
