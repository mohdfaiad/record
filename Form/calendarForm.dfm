object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 347
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Scheduler: TcxScheduler
    Left = 0
    Top = 0
    Width = 585
    Height = 347
    DateNavigator.RowCount = 2
    ViewDay.Active = True
    ViewDay.TimeRulerMinutes = True
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = True
    LookAndFeel.SkinName = 'Blue'
    OptionsView.AdditionalTimeZoneLabel = #20013#25991#13#10#33521#25991#13#10
    ResourceNavigator.CustomButtons = <
      item
      end
      item
      end
      item
      end>
    TabOrder = 0
    Splitters = {
      B9010000FB0000004802000000010000B401000001000000B90100005A010000}
    StoredClientBounds = {0100000001000000480200005A010000}
    object pnlControls: TPanel
      Left = 0
      Top = 0
      Width = 143
      Height = 224
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 1
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 143
        Height = 224
        Align = alClient
        BorderStyle = bsNone
        Lines.Strings = (
          'Your controls can be placed '
          'here')
        TabOrder = 0
      end
    end
  end
  object cxSchedulerStorage1: TcxSchedulerStorage
    CustomFields = <>
    Resources.Items = <>
    Left = 24
    Top = 24
  end
end
