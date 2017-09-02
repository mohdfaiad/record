object frmUsDatabase: TfrmUsDatabase
  Left = 0
  Top = 0
  Caption = 'frmUsDatabase'
  ClientHeight = 396
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 266
    Top = 68
    Width = 36
    Height = 13
    Caption = #23494#30721#21517
  end
  object Label2: TLabel
    Left = 266
    Top = 95
    Width = 24
    Height = 13
    Caption = #34920#21517
  end
  object dbgrd: TDBGrid
    Left = 0
    Top = 0
    Width = 137
    Height = 239
    Align = alLeft
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 512
    Top = 0
    Width = 89
    Height = 25
    Caption = #26174#31034#23448#26041'demo'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 328
    Width = 603
    Height = 68
    Align = alBottom
    Lines.Strings = (
      #20449#24687
      '')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Button2: TButton
    Left = 512
    Top = 94
    Width = 75
    Height = 25
    Caption = #20462#25913#23494#30721
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 353
    Top = 65
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Button3: TButton
    Left = 528
    Top = 208
    Width = 75
    Height = 25
    Caption = #26597#35810
    TabOrder = 5
    OnClick = Button3Click
  end
  object Memo2: TMemo
    Left = 0
    Top = 239
    Width = 603
    Height = 89
    Align = alBottom
    Lines.Strings = (
      #35831#36755#20837'sql'#35821#21477
      '')
    TabOrder = 6
  end
  object Button4: TButton
    Left = 401
    Top = 208
    Width = 121
    Height = 25
    Caption = #25191#34892'sql'
    TabOrder = 7
  end
  object Button6: TButton
    Left = 512
    Top = 63
    Width = 75
    Height = 25
    Caption = #21019#24314#34920#21333
    TabOrder = 8
    OnClick = Button3Click
  end
  object Edit2: TEdit
    Left = 353
    Top = 92
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object Button5: TButton
    Left = 512
    Top = 31
    Width = 75
    Height = 25
    Caption = #25171#24320#25968#25454#24211
    TabOrder = 10
    OnClick = Button5Click
  end
  object fdCon: TFDConnection
    Params.Strings = (
      'Database=D:\work\windows\delphi\demo\FD'#25968#25454#24211'\fddemo.sdb'
      'DriverID=SQLite')
    OnError = fdConError
    Left = 272
    Top = 65528
  end
  object fdqry: TFDQuery
    Connection = fdCon
    Left = 232
    Top = 65528
  end
  object ds: TDataSource
    Left = 192
  end
  object fdmtbl: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 152
  end
  object OpenDialog1: TOpenDialog
    Left = 152
    Top = 64
  end
end
