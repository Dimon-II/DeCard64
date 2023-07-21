object formGlyph: TformGlyph
  Left = 192
  Top = 171
  Caption = 'Glyph font'
  ClientHeight = 352
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Image1: TImage
    Left = 105
    Top = 105
    Width = 105
    Height = 105
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
  end
  object Grid: TDrawGrid
    Left = 0
    Top = 38
    Width = 648
    Height = 314
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    ColCount = 16
    Ctl3D = False
    DefaultColWidth = 19
    DefaultRowHeight = 29
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
    ParentCtl3D = False
    PopupMenu = pmCopy
    TabOrder = 0
    OnDblClick = miCopyCharClick
    OnDrawCell = GridDrawCell
    ExplicitWidth = 652
    ExplicitHeight = 315
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 648
    Height = 38
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 652
    object cbFont: TComboBox
      Left = 92
      Top = 8
      Width = 286
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 0
      OnChange = cbFontChange
    end
    object BitBtn1: TBitBtn
      Left = 6
      Top = 6
      Width = 79
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Font'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFFFFF00000FF444FFFFFF00000FFF4FFFFFFFF000FFFF4FFFFFFFF000FFFF
        4FFFFFFFF000FFFF4FFFFFFFF000FFFF4FFFFFFFF000F4FF4FF4FFFFF000F444
        4444FFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFFFFFFFFFFF000FFFF
        FFFF00FFF000FFF00FFF0000000000000FFF0000000000000FFF}
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 385
      Top = 6
      Width = 101
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Copy &&-code '
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DD44444444DD
        DDDDD4444444444DDDDDD44444FFFFFFFFDDD4444FCCCCCCCCFDD444FCCCCCCC
        CCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFD444FCCCCCCC
        CCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFDD44FCCCCCCC
        CCCFDDDDFCCCCCCCCCCFDDDDFCCCCCCCCCCFDDDDDFCCCCCCCCFD}
      TabOrder = 2
      OnClick = miCopyCharClick
    end
    object BitBtn3: TBitBtn
      Left = 493
      Top = 6
      Width = 100
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Copy <tag/>'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DD44444444DD
        DDDDD4444444444DDDDDD44444FFFFFFFFDDD4444FCCCCCCCCFDD444FCCCCCCC
        CCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFD444FCCCCCCC
        CCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFD444FCCCCCCCCCCFDD44FCCCCCCC
        CCCFDDDDFCCCCCCCCCCFDDDDFCCCCCCCCCCFDDDDDFCCCCCCCCFD}
      TabOrder = 3
      OnClick = miCopyTagClick
    end
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    MinFontSize = 24
    MaxFontSize = 24
    Options = [fdEffects, fdNoSizeSel]
    Left = 40
    Top = 48
  end
  object pmCopy: TPopupMenu
    Left = 296
    Top = 104
    object miCopyChar: TMenuItem
      Caption = 'Copy &&-code'
      OnClick = miCopyCharClick
    end
    object miCopyTag: TMenuItem
      Caption = 'Copy tag <font...'
      OnClick = miCopyTagClick
    end
    object miCopyUnicode: TMenuItem
      Caption = 'Copy unicode'
      OnClick = miCopyUnicodeClick
    end
  end
end
