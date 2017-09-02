object frmRecord: TfrmRecord
  Left = 341
  Top = 112
  Caption = #35270#22270
  ClientHeight = 577
  ClientWidth = 829
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clHotLight
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 829
    Height = 37
    Align = alTop
    Stretch = True
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 37
    Width = 829
    Height = 540
    ActivePage = viewPage
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
      object ListView: TListView
        Left = 0
        Top = 80
        Width = 821
        Height = 426
        Align = alBottom
        Columns = <
          item
            Caption = #35760#24405
            Width = 200
          end
          item
            Caption = #24320#22987#26102#38388
            Width = 298
          end
          item
            Caption = #32467#26463#26102#38388
            Width = 150
          end
          item
            Caption = #25345#32493#26102#38388
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCustomDrawItem = ListViewCustomDrawItem
        OnMouseDown = ListViewMouseDown
      end
      object edtList: TEdit
        Left = 0
        Top = 112
        Width = 201
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
    object viewPage: TTabSheet
      Caption = #35270#22270
      ImageIndex = 2
      object Memo1: TMemo
        Left = 0
        Top = 450
        Width = 821
        Height = 56
        Align = alBottom
        Lines.Strings = (
          'Memo1')
        TabOrder = 0
        Visible = False
      end
    end
  end
end
