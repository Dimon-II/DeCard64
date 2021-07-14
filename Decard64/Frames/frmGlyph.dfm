object formGlyph: TformGlyph
  Left = 192
  Top = 171
  Caption = 'Glyph font'
  ClientHeight = 441
  ClientWidth = 811
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object Image1: TImage
    Left = 131
    Top = 131
    Width = 131
    Height = 131
  end
  object Grid: TDrawGrid
    Left = 0
    Top = 47
    Width = 811
    Height = 394
    Align = alClient
    ColCount = 16
    Ctl3D = False
    DefaultColWidth = 24
    DefaultRowHeight = 36
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
    ParentCtl3D = False
    PopupMenu = pmCopy
    TabOrder = 0
    OnDblClick = miCopyCharClick
    OnDrawCell = GridDrawCell
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 811
    Height = 47
    Align = alTop
    TabOrder = 1
    object cbFont: TComboBox
      Left = 115
      Top = 10
      Width = 357
      Height = 25
      TabOrder = 0
      OnChange = cbFontChange
    end
    object BitBtn1: TBitBtn
      Left = 8
      Top = 7
      Width = 98
      Height = 32
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
      Left = 481
      Top = 7
      Width = 126
      Height = 32
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
      Left = 616
      Top = 7
      Width = 125
      Height = 32
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
