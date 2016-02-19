object ScreenForm: TScreenForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'ScreenForm'
  ClientHeight = 240
  ClientWidth = 256
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Display: TPaintBox
    Left = 0
    Top = 0
    Width = 256
    Height = 240
    Align = alClient
    OnPaint = DisplayPaint
    ExplicitLeft = 232
    ExplicitTop = 112
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object RenderTimer: TTimer
    Interval = 20
    OnTimer = RenderTimerTimer
    Left = 456
    Top = 232
  end
end
