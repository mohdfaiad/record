object frmSetClass: TfrmSetClass
  Left = 0
  Top = 0
  Caption = 'frmSetClass'
  ClientHeight = 377
  ClientWidth = 402
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 89
    Width = 57
    Height = 17
    AutoSize = False
    Caption = #20869#23481
  end
  object Label4: TLabel
    Left = 8
    Top = 48
    Width = 57
    Height = 17
    AutoSize = False
    Caption = #31867#22411
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 57
    Height = 17
    AutoSize = False
    Caption = #35760#24405'*'
  end
  object Button1: TButton
    Left = 167
    Top = 326
    Width = 75
    Height = 25
    Caption = #35774#32622
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtClass: TEdit
    Left = 71
    Top = 45
    Width = 145
    Height = 21
    TabOrder = 1
  end
  object edtTitle: TEdit
    Left = 71
    Top = 8
    Width = 296
    Height = 21
    TabOrder = 2
  end
  object mmContent: TMemo
    Left = 71
    Top = 86
    Width = 296
    Height = 217
    Lines.Strings = (
      '')
    TabOrder = 3
  end
  object cbbClass: TComboBox
    Left = 216
    Top = 45
    Width = 151
    Height = 21
    ItemIndex = 0
    TabOrder = 4
    Text = #24037#20316
    Items.Strings = (
      #24037#20316
      #23089#20048
      #20854#20182)
  end
end
