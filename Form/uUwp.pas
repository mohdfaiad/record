unit uUwp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, RzTabs, dxGDIPlusClasses;

type
  TRectInfo = record
    background: TColor;
    img: TImage;
    rect: TRect;
  end;

  TfrmUwp = class(TForm)
    imgBottom: TImage;
    imgRight: TImage;
    pgcntrlMenu: TRzPageControl;
    MenuTab1: TRzTabSheet;
    MenuTab2: TRzTabSheet;
    pnlLeft: TPanel;
    pgcntrlClient: TRzPageControl;
    MainTab1: TRzTabSheet;
    MainTab2: TRzTabSheet;
    lblTitle: TLabel;
    pnlTop: TPanel;
    imgClose: TImage;
    imgMin: TImage;
    imgMax: TImage;
    imgMenu: TImage;
    imgTitleBack: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure WMNCHITTEST(var Msg: TWMNCHITTEST); message WM_NCHITTEST;
    procedure FormResize(Sender: TObject);
    procedure FormMatchColor(rectInfo: TRectInfo);
    procedure btnQueryClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure imgMaxClick(Sender: TObject);
    procedure imgMinClick(Sender: TObject);
    procedure pnlTopMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgMenuClick(Sender: TObject);
    procedure imgTitleBackClick(Sender: TObject);
  private
    procedure FormInit();
  public
    { Public declarations }
  end;

var
  frmUwp: TfrmUwp;
  hisTabIndex: Integer;

implementation

{$R *.dfm}

procedure TfrmUwp.FormShow(Sender: TObject);
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

procedure TfrmUwp.imgCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUwp.imgMaxClick(Sender: TObject);
begin
  if Self.WindowState = wsMaximized then
  begin
    Self.WindowState := wsNormal;

  end
  else
  begin
    Self.WindowState := wsMaximized;
  end;
  Repaint;
end;

procedure TfrmUwp.imgMenuClick(Sender: TObject);
var
  i: Integer;
begin
  pgcntrlMenu.Visible := not pgcntrlMenu.Visible;
  for i := 0 to pgcntrlMenu.PageCount - 1 do
  begin
    pgcntrlMenu.Pages[i].TabVisible := False;
  end;
  if Self.pgcntrlMenu.ActivePageIndex = -1 then
    Self.pgcntrlMenu.ActivePageIndex := 0;
end;

procedure TfrmUwp.imgMinClick(Sender: TObject);
begin
  Self.WindowState := wsMinimized;
end;

procedure TfrmUwp.imgTitleBackClick(Sender: TObject);
begin
  if pgcntrlClient.ActivePageIndex = 0 then
    pgcntrlClient.ActivePageIndex := 1
  else
    pgcntrlClient.ActivePageIndex := 0;
end;

procedure TfrmUwp.pnlTopMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, $F017, 0);
end;

procedure TfrmUwp.WMNCHITTEST(var Msg: TWMNCHITTEST);
const
  cOffset = 10;
var
  vPoint: TPoint;
begin
  inherited;
  vPoint := ScreenToClient(Point(Msg.XPos, Msg.YPos));
  if PtInRect(Rect(0, 0, cOffset, cOffset), vPoint) then
    Msg.Result := HTTOPLEFT
  else if PtInRect(Rect(Width - cOffset, Height - cOffset, Width, Height), vPoint) then
    Msg.Result := HTBOTTOMRIGHT
  else if PtInRect(Rect(Width - cOffset, 0, Width, cOffset), vPoint) then
    Msg.Result := HTTOPRIGHT
  else if PtInRect(Rect(0, Height - cOffset, cOffset, Height), vPoint) then
    Msg.Result := HTBOTTOMLEFT
  else if PtInRect(Rect(cOffset, 0, Width - cOffset, cOffset), vPoint) then
    Msg.Result := HTTOP
  else if PtInRect(Rect(0, cOffset, cOffset, Height - cOffset), vPoint) then
    Msg.Result := HTLEFT
  else if PtInRect(Rect(Width - cOffset, cOffset, Width, Height - cOffset), vPoint) then
    Msg.Result := HTRIGHT
  else if PtInRect(Rect(cOffset, Height - cOffset, Width - cOffset, Height), vPoint) then
    Msg.Result := HTBOTTOM;
end;

procedure TfrmUwp.btnQueryClick(Sender: TObject);
begin
  Self.pgcntrlMenu.Visible := True;
  Self.pgcntrlMenu.ActivePageIndex := 1;
end;

procedure TfrmUwp.FormCreate(Sender: TObject);
begin
  FormInit;

end;

procedure TfrmUwp.FormInit;
var
  i: Integer;
  rectInfo: TRectInfo;
begin
  hisTabIndex := 0;
  Self.Color := clWhite;
  Self.pgcntrlMenu.Visible := False;

  pnlLeft.Width := Self.Height div 20;
  imgRight.Width := 10;
  pnlTop.Height := Self.Height div 18;
  pnlTop.Color := RGB(68, 81, 98);
  imgBottom.Height := 10;

  Self.MenuTab1.Color := RGB(43, 43, 43);

  Self.pgcntrlMenu.Color := RGB(43, 43, 43);
  for i := 0 to pgcntrlClient.PageCount - 1 do
  begin
    pgcntrlClient.Pages[i].TabVisible := False;
  end;
  for i := 0 to pgcntrlMenu.PageCount - 1 do
  begin
    pgcntrlMenu.Pages[i].TabVisible := False;
  end;
  // title pngbutton

  // match color

end;

procedure TfrmUwp.FormMatchColor(rectInfo: TRectInfo);
begin
  rectInfo.img.Canvas.Brush.Color := rectInfo.background;
  rectInfo.img.Canvas.FillRect(rectInfo.rect);
end;

procedure TfrmUwp.FormResize(Sender: TObject);
begin
  Repaint;
end;

end.

