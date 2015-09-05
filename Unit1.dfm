object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 242
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 48
    Top = 72
    Width = 425
    Height = 145
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=IB'
      'Database=C:\Sistemas\NESTOR\MOBI.GDB'
      'Password=PARCERIA'
      'Server=LOCALHOST'
      'User_Name=SYSDBA')
    Connected = True
    LoginPrompt = False
    Left = 304
    Top = 8
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 400
    Top = 8
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 208
    Top = 16
  end
end
