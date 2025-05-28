object FormPacman: TFormPacman
  Left = 0
  Top = 0
  Caption = 'FormPacman'
  ClientHeight = 871
  ClientWidth = 699
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object imgGame: TImage
    Left = 0
    Top = 0
    Width = 699
    Height = 871
    Align = alClient
    ExplicitLeft = 232
    ExplicitTop = 112
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object tmrGameLoop: TTimer
    Interval = 16
    OnTimer = tmrGameLoopTimer
    Left = 488
    Top = 160
  end
end
