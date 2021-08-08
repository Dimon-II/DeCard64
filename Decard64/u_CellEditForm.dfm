object CellEditForm: TCellEditForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'CellEditForm'
  ClientHeight = 280
  ClientWidth = 622
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 434
    Top = 0
    Height = 238
    Align = alRight
    ExplicitLeft = 8
    ExplicitTop = 49
    ExplicitHeight = 199
  end
  object pnBottom: TPanel
    Left = 0
    Top = 238
    Width = 622
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      622
      42)
    object sbaLeftCell: TSpeedButton
      Left = 3
      Top = 12
      Width = 23
      Height = 24
      Action = aGidLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -33
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object sbNextLine: TSpeedButton
      Left = 27
      Top = 20
      Width = 25
      Height = 22
      Action = aGridDown
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Layout = blGlyphTop
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object sbPrewLine: TSpeedButton
      Left = 27
      Top = 0
      Width = 25
      Height = 22
      Action = aGridUp
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Layout = blGlyphBottom
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object sbaRightCell: TSpeedButton
      Left = 53
      Top = 12
      Width = 23
      Height = 24
      Action = aGridRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -33
      Font.Name = 'Tahoma'
      Font.Style = []
      Layout = blGlyphRight
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object sbPreview: TSpeedButton
      Left = 185
      Top = 8
      Width = 110
      Height = 27
      Action = aPreview
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Glyph.Data = {
        36090000424D3609000000000000360000002800000018000000180000000100
        2000000000000009000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00B8B8B900ABABAB00A7A7A700A7A7A700A7A7A700A7A7
        A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A8A8A800ACACAC00BBBB
        BC00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BEBEBF0098959200837565007F6F5E007F6F5E007F6F5E007F6F
        5E007F6F5E007F6F5E007F6F5E007F6F5E007F6F5E007F705E00867A6C00A4A3
        A200FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BEBEBE008B7E7100DDC8B000ECDFD100EBDFD100EBDFD100ECDF
        D100EBDFD100ECDFD100EBDFD100EBDFD100EBDFD100ECDFD100CEB191009490
        8C00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BEBEBE00897B6C00ECDFD100C1CDFA00C2D3F800C4DAF800C7E1
        F900C8E7F900C8E7F900C6E0F900C5D9F800C2D3F800CFD7FB00D9C0A400928E
        8900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BEBEBE00897B6C00ECE0D1001844F0001957EE002070F000298F
        F30030A6F5002FA6F5002989F3002170F0001756EE004263F300DAC0A300928E
        8900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BEBEBE00897B6C00ECE0D1002C53F100356AF0002B76F1003393
        F3003AA6F50039A7F500338EF3002C77F100245EEF004568F300DAC1A300928E
        8900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00BEBEBE00897B6C00ECE0CF00274BF1004976F1004984F300388C
        F3003594F4003292F4002F82F200296FF1002157EF004464F200DAC1A2008782
        7C00A7A7A700A7A7A700A7A7A700A8A8A800ACACAC00BBBCBB00FF00FF00FF00
        FF00FF00FF00BEBEBF00897C6C00ECE0CE002040EF004169F0005383F2005D96
        F4005397F4004790F4003A7EF2002E69F0001C4CED00415CF100D9C0A000866E
        55007F6F5E007F6F5E007F6F5E007F705E00867A6C00A4A3A200FF00FF00FF00
        FF00FF00FF00BEBEBF00897C6C00ECE0CD001832EE003A5CEF004A75F1005B8B
        F3006898F4006E9DF500729AF5007596F4007089F4008795F600D8BD9B00DDC6
        AD00ECDFD100EBDFD100EBDFD100ECDFD100CEB1910094908C00C0BFBF00BEBD
        BD00BCBCBD00B9B9BA00887A6900ECE0CE000E20ED002F4AED004061F0005177
        F2005C84F300678CF4007391F4007C92F4008290F40098A0F700DABC9A00C2D3
        BC00C6EEE300C4ECE100C1EADF00CFEDE400D9C0A400928E8900B9B8B8009F9E
        9D0098959100979592008A766100ECE0CF000910EB00283AEC003950EE004865
        F0005472F1005F7BF2006B81F3007484F3007B85F3009699F600DFBD9C004AB8
        8B0024C096001EB88C0013B0840040BB9700DAC0A400928E89009D9B99009C7F
        5F00A27C5300A07B5300A77D4C00ECDFD0000406EA001C24EB002D3CEC003E51
        EE00495EF0005567F1006170F1006B74F2007376F2009493F700E1BD9F0050B9
        8D002FC39B0029BB92001EB48A0041BD9B00DBC0A500928E8900928E8A00D9C0
        A500FEFEFE00FFFFFF00D7BD9F00EBDECD003F3FEC004243EC004C50ED005A62
        EF00636DF0006D75F100777EF1007F83F1008787F100A9A8F700E1BD9F004BB4
        88002BBF970027B98F001DB2870040BC9A00DAC0A400928E8900928E8900D9C0
        A400FAD8AC00F9CF9600DBAD7300D0B18A00D7BF9A00D7BF9900D7BF9900D8C0
        9B00D7BF9B00D8BF9A00D9BF9700DCBF9700DEBF9700DEBE9800C9A67B0056BA
        920035C099002AB8900017AE83003FB99600DAC0A400928E8900928E8900D9C0
        A500F6B96800F5A73C00F3AC4D00E0A55B00DFA96500DFAA6800DEA65F00DCA0
        5400DA9B4A00D9933900DBBDA0009092610070A67B007EAA80007BB893006BCE
        B0006FD0B40072CEB3006ECBAF0086D2BD00DAC0A400928E8900928E8A00D9C0
        A500F6BA6A00F6B35800F7B45800FAB95F00FEC27000FEC37400FCBD6900FAB4
        5600F6AB4500F49E2900EFDFD100709B6E0033BC99004AC2A20057C7A80064CA
        AD0070CDB10079CFB5007FCFB70096D8C600DAC0A500928E8900928E8A00D9C0
        A500F5B76400F5B25800F7BC6A00F9BD6E00FABD6A00FABA6500F9B65E00F7B0
        5000F4A74100F19A2500EFDED1006D9869002EB48F0044BB990050C09F005BC5
        A50067C8AB0070CAAF0078CCB20093D6C400D9BFA400928E8900928E8A00D9C0
        A500F3B55D00F4AD4F00F7B96600F8C27900FAC78200F9C47B00F9BC6D00F6B1
        5400F3A53D00F0951A00EFDED1006694650022AD870038B5900045BA980050BE
        9E005DC2A40066C5A8006FC6AC0091D5C200D9BFA400928E8900928E8A00D9C0
        A500F3B05500F3A94400F5B25900F7BB6B00F9C47B00F9C88500F9CB8C00F9CE
        9300F8CF9400F7C98800EEDED0007D9A6E0045B9990054BF9F005FC3A60068C8
        AA0074CBB0007CCDB40084CFB700A6DECC00DAC0A400938F8B00928E8A00D9C1
        A600F2AC4C00F1A33900F3AD4E00F5B55E00F7BD6E00F7C17800F7C47F00F7C7
        8500F7C88700F6C47E00EBDED000C69F7500DAC1A200DAC1A000DAC09F00DAC0
        9F00DAC09F00D9C09E00D9BF9E00DAC09F00C6A57E00AAACA600928E8A00D9C1
        A600F0A74300EF9C2B00F2A64100F3AF5200F5B76200F5BC6B00F6BE7300F6C2
        7A00F6C47E00F6C17800EBDFD1008B776000B3B1A700BBBBAF00B9BBB000B8BB
        B100B6BBB100B4BAB100B5BCB300B6BCB300B8BDB600BEC0BF00928E8A00D9C1
        A600EEA03F00ED921500EF9C2B00F1A43B00F3AD4D00F4B25800F4B66000F5BA
        6900F4BC6E00F5BB6D00ECDFD200887B6C00BFBFBE00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0094918C00D9C1
        A500F6CD9E00F5C48100F6C98B00F7CD9300F8D29B00F8D5A100F9D7A500F9D9
        AA00F9DBAC00F9DBAD00ECDFCF00897D6E00BFBFBF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00B9B1A700BD99
        7000C6A27900C6A27A00C5A17A00C5A17900C6A27900C5A17800C5A17800C6A2
        7700C5A17700C6A17700C29D7400B4AA9800FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      ParentFont = False
    end
    object btnApply: TButton
      Left = 458
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
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
      Left = 539
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
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
    object chbScrollPreview: TCheckBox
      Left = 82
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Preview'#9660#9650
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  inline CellEditFrame: TSynEditFrame
    Left = 0
    Top = 0
    Width = 434
    Height = 238
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 434
    ExplicitHeight = 238
    inherited SynEditor: TSynEdit
      Width = 434
      Height = 210
      OnChange = CellEditFrameSynEditorChange
      ExplicitWidth = 434
      ExplicitHeight = 210
    end
    inherited pscrSysEdit: TPageScroller
      Width = 434
      ExplicitWidth = 434
      inherited tbrEditor: TToolBar
        inherited ToolButton3: TToolButton
          Hint = 'Add selected to [Common]'
          Visible = True
          OnClick = CellEditFrameToolButton3Click
        end
      end
    end
  end
  object pnRight: TPanel
    Left = 437
    Top = 0
    Width = 185
    Height = 238
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 0
      Top = 129
      Width = 185
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 0
      ExplicitWidth = 93
    end
    object gbMacros: TGroupBox
      Left = 0
      Top = 132
      Width = 185
      Height = 106
      Align = alBottom
      Caption = 'Macros'
      TabOrder = 0
      object lbMacros: TListBox
        Left = 2
        Top = 15
        Width = 181
        Height = 89
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = lbMacrosDblClick
      end
    end
    object gbCommon: TGroupBox
      Left = 0
      Top = 0
      Width = 185
      Height = 129
      Align = alClient
      Caption = 'Common'
      TabOrder = 1
      object lbCommon: TListBox
        Left = 2
        Top = 15
        Width = 181
        Height = 112
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = lbCommonDblClick
      end
    end
  end
  object alGrid: TActionList
    Images = MainData.ilNavigate
    Left = 16
    Top = 176
    object aGidLeft: TAction
      Hint = 'Left cell'
      ImageIndex = 3
      ShortCut = 32805
      OnExecute = aGidLeftExecute
      OnUpdate = aGidLeftUpdate
    end
    object aGridRight: TAction
      Hint = 'Right cell'
      ImageIndex = 1
      ShortCut = 32807
      OnExecute = aGridRightExecute
    end
    object aGridUp: TAction
      Hint = 'Up cell'
      ImageIndex = 0
      ShortCut = 32806
      OnExecute = aGridUpExecute
      OnUpdate = aGridUpUpdate
    end
    object aGridDown: TAction
      Hint = 'Diwn cell'
      ImageIndex = 2
      ShortCut = 32808
      OnExecute = aGridDownExecute
    end
    object aPreview: TAction
      Caption = 'Preview F5'
      ShortCut = 116
      OnUpdate = aPreviewUpdate
    end
  end
end
