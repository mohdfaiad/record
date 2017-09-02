{
单元名称：ztFrmBase
创建日期：2014/08/07
功能：窗体的基类
By.王兆阳
}
unit ztFrmBase;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, jpeg, ExtCtrls,
   StdCtrls, Graphics;

type
  TForm_Style = (F_Normal, F_Dialog);
  TFrmBase = class(TForm)
    Image8: TImage;
    lbltitle: TLabel;
    procedure Image8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMaxMnuClick(Sender: TObject);
    procedure btnMinMnuClick(Sender: TObject);
    procedure btnCloseMnuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FShowFormTimer: TTimer;
    FForm_Style: TForm_Style;
    procedure SetForm_Style(const Value: TForm_Style);
    procedure OnShowFormTimer(sender: TObject);
    procedure WMGetMinMaxInfo(var mes: TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMPosChange(var Message: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
     { Private declarations }
  protected
    procedure AfterShowForm; virtual; //0表示第一次onshow
  //  procedure FlickerButton(btn: Trzbutton; const count: Integer = 1);
  public
    AfterShowTag: Integer;
    property Form_Style: TForm_Style read FForm_Style write SetForm_Style;
    { Public declarations }
  end;

var
  FrmBase: TFrmBase;

implementation
{$R *.dfm}


procedure TFrmBase.Image8MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture();
    Perform(WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TFrmBase.SetForm_Style(const Value: TForm_Style);
begin
  if FForm_Style <> Value then
  begin
    FForm_Style := Value;
    if FForm_Style = F_Normal then
    begin
     // btnMinMnu.Visible := True;
     // btnMaxMnu.Visible := True;
    end
    else
    begin
     // btnMinMnu.Visible := False;
     // btnMaxMnu.Visible := False;
    end;
  end;
end;

procedure TFrmBase.WMGetMinMaxInfo(var mes: TWMGetMinMaxInfo);
begin
  mes.MinMaxInfo.ptMinTrackSize.X := Constraints.MinWidth;
  mes.MinMaxInfo.ptMinTrackSize.y := Constraints.MinHeight;
  mes.MinMaxInfo.ptMaxSize.X := Screen.Width;
  mes.MinMaxInfo.ptMaxSize.Y := Screen.WorkAreaHeight;
  mes.MinMaxInfo.ptMaxPosition.X := 0;
  mes.MinMaxInfo.ptMaxPosition.Y := 0;
  mes.Result := 0;
  inherited;
end;

procedure TFrmBase.btnMaxMnuClick(Sender: TObject);
begin
  if WindowState = wsMaximized then
  begin
    WindowState := wsNormal;
    if Left <> Trunc((Screen.Width - Width) / 2) then
      Left := Trunc((Screen.Width - Width) / 2);
    Top := Trunc((Screen.Height - Height) / 2);
  end
  else
    WindowState := wsMaximized;
end;

procedure TFrmBase.btnMinMnuClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TFrmBase.btnCloseMnuClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBase.WMPosChange(var Message: TWMWINDOWPOSCHANGING);
begin
  if (AfterShowTag <> 0) and (FForm_Style = F_Dialog) then
    PWindowPos(TMessage(Message).lParam).Flags := PWindowPos(TMessage(Message).lParam).Flags or SWP_NOSIZE;
end;

procedure TFrmBase.FormCreate(Sender: TObject);
begin
  AfterShowTag := 0;
  FShowFormTimer := TTimer.Create(Self);
  FShowFormTimer.OnTimer := OnShowFormTimer;
  FShowFormTimer.Enabled := False;
  FShowFormTimer.Tag := 0;
  FShowFormTimer.Interval := 500;
end;


procedure TFrmBase.btn_closeClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBase.OnShowFormTimer(sender: TObject);
begin
  FShowFormTimer.Enabled := False;
  try
    AfterShowForm;
  finally
    Inc(AfterShowTag);
  end;
end;

procedure TFrmBase.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FShowFormTimer);
end;

procedure TFrmBase.AfterShowForm;
begin
  SetForegroundWindow(Handle);
end;

procedure TFrmBase.FormShow(Sender: TObject);
begin
  //
  FShowFormTimer.Enabled := True;
end;

{
procedure TFrmBase.FlickerButton(btn: Trzbutton; const count: Integer = 1);
var
  oldbtncolor: TColor;
  oldfontcolor: TColor;
  i: Integer;
begin
  if AfterShowTag = 0 then Exit;
  oldbtncolor := btn.Color;
  oldfontcolor := btn.Font.Color;
  for i := 0 to count - 1 do
  begin
    btn.Color := clBlack;
    btn.Font.Color := clWhite;
    btn.Repaint;
    Sleep(80);
    btn.Color := clWhite;
    btn.Font.Color := clBlack;
    btn.Repaint;
    Sleep(100);
  end;
  btn.Color := oldbtncolor;
  btn.Font.Color := oldfontcolor;
  btn.Repaint;
end;
 }

end.

