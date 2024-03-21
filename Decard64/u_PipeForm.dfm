object PipeForm: TPipeForm
  Left = 0
  Top = 0
  Cursor = crHandPoint
  BorderStyle = bsNone
  Caption = 'PipeForm'
  ClientHeight = 125
  ClientWidth = 214
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseLeave = FormMouseLeave
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 75
    Width = 214
    Height = 50
    Align = alBottom
    Alignment = taLeftJustify
    AutoSize = True
    BorderWidth = 5
    BorderStyle = bsSingle
    Color = clWindow
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitTop = 74
    ExplicitWidth = 141
    object Label1: TLabel
      Left = 6
      Top = 30
      Width = 100
      Height = 12
      Align = alBottom
      Caption = 'Arrows: precise move'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Terminal'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object lblColor: TLabel
      Left = 6
      Top = 6
      Width = 115
      Height = 12
      Align = alBottom
      Caption = '000000: L-Click / Enter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Terminal'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 6
      Top = 18
      Width = 110
      Height = 12
      Align = alBottom
      Caption = 'Cancel: R-Click / Esc '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Terminal'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 213
    Top = 0
    Width = 1
    Height = 75
    Align = alRight
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitLeft = 140
    ExplicitHeight = 72
  end
  object ActionList1: TActionList
    Left = 72
    Top = 8
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 13
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Action2'
      ShortCut = 27
      OnExecute = Action2Execute
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 40
    Top = 8
  end
end
