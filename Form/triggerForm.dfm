object triggerForms: TtriggerForms
  Left = 0
  Top = 0
  Caption = 'triggerForms'
  ClientHeight = 562
  ClientWidth = 607
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 7
    Width = 85
    Height = 21
    Caption = #35302#21457#26465#20214#65306' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object ComboBox1: TComboBox
    Left = 120
    Top = 7
    Width = 479
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ItemHeight = 13
    ItemIndex = 0
    ParentFont = False
    TabOrder = 0
    Text = #26102#38388
    Items.Strings = (
      #26102#38388
      #20854#20182)
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 34
    Width = 588
    Height = 383
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #26102#38388
      object Label2: TLabel
        Left = 93
        Top = 3
        Width = 85
        Height = 21
        Caption = #24320#22987#26102#38388#65306' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 68
        Height = 296
        TabOrder = 0
        object PNGButton1: TPNGButton
          Left = 0
          Top = 75
          Width = 63
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ButtonLayout = pbsImageAbove
          Caption = #25353#22825
          ButtonStyle = pbsDefault
          Space = 0
          OnClick = PNGButton1Click
        end
        object PNGButton2: TPNGButton
          Left = 0
          Top = 115
          Width = 63
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ButtonLayout = pbsImageAbove
          Caption = #25353#21608
          ButtonStyle = pbsDefault
          Space = 0
          OnClick = PNGButton2Click
        end
        object PNGButton3: TPNGButton
          Left = -1
          Top = 157
          Width = 63
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ButtonLayout = pbsImageAbove
          Caption = #25353#26376
          ButtonStyle = pbsDefault
          Space = 0
          OnClick = PNGButton3Click
        end
        object PNGButton4: TPNGButton
          Left = 0
          Top = 194
          Width = 63
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ButtonLayout = pbsImageAbove
          Caption = #25353#24180
          ButtonStyle = pbsDefault
          Space = 0
          OnClick = PNGButton4Click
        end
        object PNGButton5: TPNGButton
          Left = 0
          Top = 30
          Width = 63
          Height = 23
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ButtonLayout = pbsImageAbove
          Caption = #19968#27425
          ButtonStyle = pbsDefault
          Space = 0
          OnClick = PNGButton5Click
        end
      end
      object Panel2: TPanel
        Left = 68
        Top = 30
        Width = 509
        Height = 266
        Caption = 'Panel1'
        TabOrder = 1
        object PageControl2: TPageControl
          Left = 1
          Top = 1
          Width = 507
          Height = 264
          ActivePage = TabSheet7
          Align = alClient
          MultiLine = True
          TabOrder = 0
          TabPosition = tpLeft
          object TabSheet3: TTabSheet
            Caption = #26085
            object Label3: TLabel
              Left = 32
              Top = 55
              Width = 53
              Height = 21
              Caption = #27599#38548#65306' '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label4: TLabel
              Left = 267
              Top = 55
              Width = 80
              Height = 21
              Caption = #22825#25191#34892#19968#27425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object SpinEdit1: TSpinEdit
              Left = 91
              Top = 58
              Width = 159
              Height = 22
              MaxValue = 366
              MinValue = 1
              TabOrder = 0
              Value = 1
            end
          end
          object TabSheet4: TTabSheet
            Caption = #21608
            ImageIndex = 1
            object Label5: TLabel
              Left = 267
              Top = 31
              Width = 80
              Height = 21
              Caption = #21608#25191#34892#19968#27425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label6: TLabel
              Left = 32
              Top = 31
              Width = 53
              Height = 21
              Caption = #27599#38548#65306' '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object SpinEdit2: TSpinEdit
              Left = 91
              Top = 34
              Width = 159
              Height = 22
              MaxValue = 366
              MinValue = 1
              TabOrder = 0
              Value = 1
            end
            object CheckBox1: TCheckBox
              Left = 16
              Top = 80
              Width = 69
              Height = 17
              Caption = #26143#26399#19968
              TabOrder = 1
            end
            object CheckBox2: TCheckBox
              Left = 91
              Top = 80
              Width = 69
              Height = 17
              Caption = #26143#26399#20108
              TabOrder = 2
            end
            object CheckBox3: TCheckBox
              Left = 181
              Top = 80
              Width = 69
              Height = 17
              Caption = #26143#26399#19977
              TabOrder = 3
            end
            object CheckBox4: TCheckBox
              Left = 16
              Top = 120
              Width = 69
              Height = 17
              Caption = #26143#26399#20116
              TabOrder = 4
            end
            object CheckBox5: TCheckBox
              Left = 91
              Top = 120
              Width = 69
              Height = 17
              Caption = #26143#26399#20845
              TabOrder = 5
            end
            object CheckBox6: TCheckBox
              Left = 181
              Top = 120
              Width = 69
              Height = 17
              Caption = #26143#26399#26085
              TabOrder = 6
            end
            object CheckBox7: TCheckBox
              Left = 267
              Top = 80
              Width = 69
              Height = 17
              Caption = #26143#26399#22235
              TabOrder = 7
            end
          end
          object TabSheet5: TTabSheet
            Caption = #26376
            ImageIndex = 2
            object Label7: TLabel
              Left = 52
              Top = 42
              Width = 16
              Height = 21
              Caption = #27599
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label8: TLabel
              Left = 434
              Top = 42
              Width = 16
              Height = 21
              Caption = #22825
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label9: TLabel
              Left = 202
              Top = 42
              Width = 64
              Height = 21
              Caption = #20010#26376#30340#31532
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object SpinEdit3: TSpinEdit
              Left = 91
              Top = 45
              Width = 105
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 0
              Value = 0
            end
            object SpinEdit4: TSpinEdit
              Left = 272
              Top = 45
              Width = 142
              Height = 22
              MaxValue = 0
              MinValue = 0
              TabOrder = 1
              Value = 0
            end
          end
          object TabSheet6: TTabSheet
            Caption = #19968#27425
            ImageIndex = 3
          end
          object TabSheet7: TTabSheet
            Caption = #24180
            ImageIndex = 4
            object Label10: TLabel
              Left = 32
              Top = 31
              Width = 53
              Height = 21
              Caption = #27599#38548#65306' '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label11: TLabel
              Left = 267
              Top = 31
              Width = 80
              Height = 21
              Caption = #24180#25191#34892#19968#27425
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object Label12: TLabel
              Left = 421
              Top = 83
              Width = 16
              Height = 21
              Caption = #21495
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object SpinEdit6: TSpinEdit
              Left = 91
              Top = 34
              Width = 159
              Height = 22
              MaxValue = 366
              MinValue = 1
              TabOrder = 0
              Value = 1
            end
            object RadioButton1: TRadioButton
              Left = 15
              Top = 86
              Width = 53
              Height = 17
              Caption = #26102#38388
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #24494#36719#38597#40657
              Font.Style = []
              ParentFont = False
              TabOrder = 1
            end
            object ComboBox2: TComboBox
              Left = 91
              Top = 86
              Width = 159
              Height = 21
              ItemHeight = 13
              ItemIndex = 0
              TabOrder = 2
              Text = #19968#26376
              Items.Strings = (
                #19968#26376
                #20108#26376
                #19977#26376
                #22235#26376
                #20116#26376
                #20845#26376
                #19971#26376
                #20843#26376
                #20061#26376
                #21313#26376
                #21313#19968#26376
                #21313#20108#26376)
            end
            object SpinEdit7: TSpinEdit
              Left = 267
              Top = 86
              Width = 142
              Height = 22
              MaxValue = 31
              MinValue = 1
              TabOrder = 3
              Value = 1
            end
          end
        end
      end
      object DateTimePicker1: TDateTimePicker
        Left = 184
        Top = 3
        Width = 159
        Height = 21
        Date = 42723.568734363430000000
        Time = 42723.568734363430000000
        TabOrder = 2
      end
      object DateTimePicker2: TDateTimePicker
        Left = 365
        Top = 3
        Width = 140
        Height = 21
        Date = 42723.568734363430000000
        Time = 42723.568734363430000000
        Kind = dtkTime
        TabOrder = 3
      end
      object Button1: TButton
        Left = 124
        Top = 311
        Width = 93
        Height = 25
        Caption = #30830#23450
        TabOrder = 4
      end
      object Button2: TButton
        Left = 389
        Top = 311
        Width = 93
        Height = 25
        Caption = #21462#28040
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20854#20182
      ImageIndex = 1
      object Button4: TButton
        Left = 99
        Top = 231
        Width = 75
        Height = 25
        Caption = #32534#36753
        TabOrder = 0
      end
      object Button5: TButton
        Left = 195
        Top = 231
        Width = 75
        Height = 25
        Caption = #21024#38500
        TabOrder = 1
      end
    end
  end
end
