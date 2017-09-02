object acountBook: TacountBook
  Left = 341
  Top = 112
  Caption = #35760#36134#26412
  ClientHeight = 517
  ClientWidth = 826
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clHotLight
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 696
    Top = 48
    Width = 75
    Height = 25
    Caption = #27979#35797
    TabOrder = 1
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 498
    Width = 826
    Height = 19
    Panels = <>
    Visible = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 826
    Height = 498
    ActivePage = pageEat
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = 0
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Style = tsButtons
    TabOrder = 0
    object pageEat: TTabSheet
      Caption = #31185#30446
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 0
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 818
        Height = 464
        Align = alClient
        Columns = <
          item
            Caption = #31185#30446
            Width = 200
          end
          item
            Caption = #25551#36848
            Width = 298
          end
          item
            Caption = #21512#35745
            Width = 150
          end
          item
            AutoSize = True
            Caption = #26085#26399
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        RowSelect = True
        ParentFont = False
        PopupMenu = listPopMenu
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCustomDrawItem = ListView1CustomDrawItem
        OnMouseDown = ListView1MouseDown
      end
      object edtList: TEdit
        Left = 0
        Top = 32
        Width = 153
        Height = 29
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Visible = False
        OnChange = edtListChange
        OnKeyDown = edtListKeyDown
      end
    end
    object formPage: TTabSheet
      Caption = #34920#21333#39029
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 184
        Top = 16
        Width = 57
        Height = 25
        AutoSize = False
        Caption = #31185#30446#21517#31216
      end
      object Label2: TLabel
        Left = 8
        Top = 80
        Width = 57
        Height = 25
        AutoSize = False
        Caption = #21333#20301
      end
      object Label3: TLabel
        Left = 224
        Top = 80
        Width = 57
        Height = 25
        AutoSize = False
        Caption = #21333#20215
      end
      object Label4: TLabel
        Left = 256
        Top = 256
        Width = 57
        Height = 25
        AutoSize = False
        Caption = #24635#20215'*'
      end
      object Label5: TLabel
        Left = 456
        Top = 80
        Width = 57
        Height = 25
        AutoSize = False
        Caption = #25968#37327
      end
      object Label6: TLabel
        Left = 8
        Top = 136
        Width = 33
        Height = 13
        AutoSize = False
        Caption = #35814#24773'*'
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 818
        Height = 464
        Align = alClient
        TabOrder = 0
        Visible = False
      end
      object Button2: TButton
        Left = 134
        Top = 320
        Width = 75
        Height = 25
        Caption = #25552#20132
        TabOrder = 1
        OnClick = Button2Click
      end
      object ComboBox1: TComboBox
        Left = 72
        Top = 80
        Width = 137
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          #26020
          #20004)
      end
      object Edit2: TEdit
        Left = 288
        Top = 80
        Width = 137
        Height = 21
        TabOrder = 3
      end
      object Edit3: TEdit
        Left = 344
        Top = 248
        Width = 137
        Height = 21
        TabOrder = 4
      end
      object Edit4: TEdit
        Left = 528
        Top = 80
        Width = 137
        Height = 21
        TabOrder = 5
      end
      object Memo1: TMemo
        Left = 72
        Top = 128
        Width = 593
        Height = 89
        ScrollBars = ssVertical
        TabOrder = 6
      end
      object Button5: TButton
        Left = 456
        Top = 320
        Width = 75
        Height = 25
        Caption = #21462#28040
        TabOrder = 7
        OnClick = Button5Click
      end
      object chooseItem: TComboBox
        Left = 288
        Top = 16
        Width = 225
        Height = 21
        ItemHeight = 13
        TabOrder = 8
        Text = #39135#21697#31867
        Items.Strings = (
          #39135#21697#31867
          #26085#24120#29992#21697#31867
          #38024#32442#26381#39280#31867
          #29983#27963#26381#21153#31867
          #20854#20182#31867)
      end
    end
    object viewPage: TTabSheet
      Caption = #35270#22270
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 818
        Height = 464
        Align = alClient
        ExplicitWidth = 846
        ExplicitHeight = 427
      end
    end
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=E:\soft\work\accoun' +
      'tBookPC\Data\myPrivate.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from TaskList')
    Left = 192
    Top = 64
  end
  object DataSource1: TDataSource
    DataSet = ADOQuery1
    Left = 848
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 936
    Top = 16
    object N1: TMenuItem
      Caption = #25991#20214
      object N5: TMenuItem
        Caption = #26032#24314#31185#30446
        OnClick = N5Click
      end
    end
    object N2: TMenuItem
      Caption = #32534#36753
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #26597#35810
      object N8: TMenuItem
        Caption = #36817#26399#35760#24405
        object N13: TMenuItem
          Caption = #24403#26085
          OnClick = N13Click
        end
        object N71: TMenuItem
          Caption = #26368#36817'7'#22825
          OnClick = N71Click
        end
        object N14: TMenuItem
          Caption = #26368#36817#19968#20010#26376
          OnClick = N14Click
        end
      end
      object N9: TMenuItem
        Caption = #20998#31867#26597#35810
        object N15: TMenuItem
          Caption = #39135#21697#31867
          OnClick = N15Click
        end
        object N16: TMenuItem
          Caption = #26085#24120#29992#21697#31867
          OnClick = N16Click
        end
        object N17: TMenuItem
          Caption = #38024#32442#26381#39280#31867
          OnClick = N17Click
        end
        object N18: TMenuItem
          Caption = #29983#27963#26381#21153#31867
          OnClick = N18Click
        end
        object N19: TMenuItem
          Caption = #20854#20182#31867
          OnClick = N19Click
        end
      end
      object N10: TMenuItem
        Caption = #26597#35810#35760#24405
        OnClick = N10Click
      end
    end
    object N4: TMenuItem
      Caption = #35270#22270
      object N20: TMenuItem
        Caption = #31867#21035#35270#22270
        OnClick = N20Click
      end
    end
    object N6: TMenuItem
      Caption = #24037#20855
      object N7: TMenuItem
        Caption = #35745#31639#22120
        object N11: TMenuItem
          Caption = #31639#26415#34920#36798#24335
        end
        object N12: TMenuItem
          Caption = #31995#32479#35745#31639#22120
          OnClick = N12Click
        end
      end
    end
  end
  object listPopMenu: TPopupMenu
    Left = 160
    Top = 64
    object N21: TMenuItem
      Caption = #21024#38500#35760#24405
      OnClick = N21Click
    end
  end
end
