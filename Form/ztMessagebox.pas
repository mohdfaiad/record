{
单元名称：ztMessagebox
功能：消息提示窗体的实现
创建日期：2014/08/10
By.王兆阳
}
unit ztMessagebox;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  ExtCtrls, StdCtrls, ImgList,
  Clipbrd, Menus, Math,  jpeg, ztFrmBase;

type
  TMessageType = (MES_NONE, MES_HINT, MES_ERROR, MES_WARNING, MES_SELECT);
  TMessageBox = class(TFrmBase)
    ImageList1: TImageList;
    Panel1: TPanel;
    Panel3: TPanel;
    PaintBox1: TPaintBox;
    Pnl_Context: TPanel;
    Lbl_Context: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    btn_ok: TButton;
    btn_NO: TButton;
    tlbpnl1: TPanel;
    tlbpnl2: TPanel;
    procedure PaintBox1Paint(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    FMessageType: TMessageType;
    procedure SetMessageType(const Value: TMessageType);
  private
    { Private declarations }
    procedure SetContextWidth(sText: string);
    function GetWrapText(sText: string): string;
    function GetTextSize(fontsize: integer; const str: string = '一'): TSize;
    property MessageType: TMessageType read FMessageType write SetMessageType;
  public
    { Public declarations }
  end;

var
  MessageBox: TMessageBox;
function ShowMsg(msg: string; AMessageType: TMessageType): TModalResult;
implementation

const
  MyFontSize = 10;
  MinLblHeight = 48;
  MaxLblWidth = 450;
  MinLblWidth = 305;
  MsgTitle:string = '';
{$R *.dfm}

function ShowMsg(msg: string; AMessageType: TMessageType): TModalResult;
var
  lblHeight: Integer;
  FText: string;
begin
  result := mrNone;
  MessageBox := TMessagebox.Create(nil);
  with MessageBox do
  try
    SetContextWidth(msg);
    FText := GetWrapText(msg);
    MessageType := AMessageType;
    Form_Style := f_dialog;
    Lbl_Context.Font.Size := MyFontSize;
    Lbl_Context.Left := 0;
    Lbl_Context.Width := Pnl_Context.Width;
    Lbl_Context.Caption := FText;
    lblHeight := Lbl_Context.Height;
    if lblHeight > MinLblHeight then
    begin
      Height := Height + (lblHeight - MinLblHeight);
    end;

    Lbl_Context.Top := (Pnl_Context.Height - lblHeight) div 2;
    ShowModal;
    Result := ModalResult;
  finally
    FreeAndNil(MessageBox);
  end;
end;

procedure TMessageBox.PaintBox1Paint(Sender: TObject);
begin
  inherited;
  if FMessageType <> MES_NONE then
    ImageList1.Draw(PaintBox1.Canvas, 10, PaintBox1.Top + (PaintBox1.Height div 2) - 35, Integer(FMessageType));
end;

procedure TMessageBox.SetMessageType(const Value: TMessageType);
begin
  if FMessageType <> Value then
  begin
    FMessageType := Value;
    case FMessageType of
      MES_NONE, MES_HINT, MES_ERROR, MES_WARNING:
        begin
          btn_ok.Left := btn_NO.Left;
          btn_NO.Visible := False;
          btn_ok.ModalResult := mrOk;
          if FMessageType = MES_NONE then lblTitle.Caption := MsgTitle + '消息'
          else if FMessageType = MES_HINT then lblTitle.Caption :=MsgTitle + '提示'
          else if FMessageType = MES_WARNING then lblTitle.Caption := MsgTitle +'警告'
          else if FMessageType = MES_ERROR then lblTitle.Caption :=MsgTitle + '错误';
        end;
      MES_SELECT:
        begin
          lblTitle.Caption := MsgTitle + '询问';
          btn_ok.Caption := '是(&Y)';
          btn_ok.ModalResult := mrYes;
          btn_NO.ModalResult := mrNo;
        end;
    end;
  end;
end;

function TMessageBox.GetTextSize(fontsize: integer; const str: string = '一'): TSize;
begin
  Canvas.Font.Size := MyFontSize;
  Result := Canvas.TextExtent(str);
end;

function TMessageBox.GetWrapText(sText: string): string;
var
  Memo: TMemo;
  maxWidth: Integer;
  i: Integer;
begin
  Result := sText;
  Memo := TMemo.Create(nil);
  Memo.Parent := Self;
  Memo.Font.Size := MyFontSize;

  Memo.Width := Pnl_Context.Width;
  Memo.Lines.Text := sText;
  Memo.Height := (Memo.Lines.Count) * GetTextSize(MyFontSize).cy;
  with TStringList.Create do
  begin
    Append('');
    for i := 0 to Memo.Lines.Count - 1 do
    begin
      Append(Memo.Lines[i]);
    end;
    Result := Text;

    free;
  end;
  Memo.Free;
end;

procedure TMessageBox.N1Click(Sender: TObject);
begin
  inherited;
  Clipboard.Clear;
  Clipboard.AsText := Lbl_Context.Caption;
end;

procedure TMessageBox.SetContextWidth(sText: string);
var
  LblWidth: Integer;
  i: Integer;
begin
  LblWidth := MinLblWidth; //MaxLblWidth
  with TStringList.Create do
  try
    Text := sText;
    for i := 0 to Count - 1 do
    begin
      LblWidth := Max(LblWidth, GetTextSize(MyFontSize, Strings[i]).cx + 7);
      if LblWidth >= MaxLblWidth then
      begin
        LblWidth := MaxLblWidth;
        Break;
      end;
    end;
  finally
    Free;
  end;
  if LblWidth + paintbox1.Width > MinLblWidth then
  begin
    Width := LblWidth + paintbox1.Width + 25;
    Pnl_Context.Width := LblWidth;
  end;
end;


end.
