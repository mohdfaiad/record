object frmClasstype: TfrmClasstype
  Left = 340
  Top = 151
  BorderIcons = [biSystemMenu]
  Caption = #25552#37266
  ClientHeight = 422
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 80
    Width = 73
    Height = 17
    AutoSize = False
    Caption = #24320#22987#26102#38388'*'
  end
  object Label2: TLabel
    Left = 8
    Top = 112
    Width = 73
    Height = 17
    AutoSize = False
    Caption = #32467#26463#26102#38388'*'
  end
  object Label3: TLabel
    Left = 8
    Top = 168
    Width = 57
    Height = 17
    AutoSize = False
    Caption = #25552#37266#20869#23481
  end
  object Label4: TLabel
    Left = 8
    Top = 48
    Width = 57
    Height = 17
    AutoSize = False
    Caption = #22320#28857
  end
  object Label5: TLabel
    Left = 8
    Top = 16
    Width = 57
    Height = 17
    AutoSize = False
    Caption = #20027#39064'*'
  end
  object mmContent: TMemo
    Left = 72
    Top = 160
    Width = 385
    Height = 217
    Lines.Strings = (
      '')
    TabOrder = 0
  end
  object edtTitle: TEdit
    Left = 72
    Top = 16
    Width = 385
    Height = 21
    TabOrder = 1
  end
  object edtLocation: TEdit
    Left = 72
    Top = 48
    Width = 385
    Height = 21
    TabOrder = 2
  end
  object Button1: TButton
    Left = 199
    Top = 389
    Width = 75
    Height = 25
    Caption = #30830#35748
    TabOrder = 3
    OnClick = Button1Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 72
    Top = 80
    Width = 186
    Height = 21
    Date = 42713.418684745370000000
    Time = 42713.418684745370000000
    TabOrder = 4
  end
  object DateTimePicker2: TDateTimePicker
    Left = 72
    Top = 112
    Width = 186
    Height = 21
    Date = 42713.418684745370000000
    Time = 42713.418684745370000000
    TabOrder = 5
  end
  object SpinEdit1: TSpinEdit
    Left = 264
    Top = 80
    Width = 97
    Height = 22
    MaxValue = 24
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 367
    Top = 80
    Width = 97
    Height = 22
    MaxValue = 60
    MinValue = 0
    TabOrder = 7
    Value = 0
  end
  object SpinEdit3: TSpinEdit
    Left = 264
    Top = 108
    Width = 97
    Height = 22
    MaxValue = 24
    MinValue = 0
    TabOrder = 8
    Value = 0
  end
  object SpinEdit4: TSpinEdit
    Left = 367
    Top = 108
    Width = 97
    Height = 22
    MaxValue = 60
    MinValue = 0
    TabOrder = 9
    Value = 0
  end
end
