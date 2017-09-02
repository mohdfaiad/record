{
单元名称：ztFrmwaiting
功能：等待操作的窗体
创建日期：2014/08/13
By.王兆阳
}
unit UFrmwaiting;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,
  Forms, ExtCtrls, StdCtrls, ImgList;

const
  WM_UPDATE = WM_USER + 101;

type

  TTimerThead = class(TThread)
  private
    FormHandle: Cardinal;
    FTimeOut: Integer; //超时 默认为60 秒
  protected
    procedure Execute; override;
  public
    constructor Create(TimeOut: Integer; Handle: Cardinal);
  end;


  TFrmwaiting = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    lblWaitingTitle: TLabel;
    ImageList: TImageList;
    lblWaitingTime: TLabel;
    procedure pmiCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ImgIndex: Integer;
    WaitTimeOut: Integer;
    FTimerThead: TTimerThead;
    FTag1, FTag2: Integer;
    function ClacTimeStr(mSec: Integer): string;
    procedure On_WM_UPDATE(var msg: TMessage); message WM_UPDATE;
  public
    { Public declarations }
    TaskName: string;
  end;

var
  Frmwaiting: TFrmwaiting;
  Showed:Boolean;
function Showwait(const lblWaitingTitle: string = '请求数据中'):Boolean;
procedure HideWait;
implementation

{$R *.dfm}

procedure HideWait;
begin
  if Assigned(Frmwaiting) then
  begin
    Frmwaiting.Close;
    FreeAndNil(Frmwaiting);
    Showed := False;;
  end;
end;

function  Showwait(const lblWaitingTitle: string = '请求数据中'):Boolean;
begin
  Result := True;
  if Showed then
  begin
     Result := False;;
     Exit;
  end;
  Showed := True;
  if not Assigned(Frmwaiting) then
    Frmwaiting := TFrmwaiting.Create(nil);
  Frmwaiting.lblWaitingTitle.Caption := lblWaitingTitle+'，请稍等……';
  Frmwaiting.Show;
  Frmwaiting.Invalidate;
  Frmwaiting.BringToFront;
  Application.ProcessMessages;

end;


procedure TFrmwaiting.pmiCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmwaiting.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  ImgIndex := 0;
  WaitTimeOut := 60 * 60 * 1000;
  FTimerThead := TTimerThead.Create(1000 * 60 * 60, Self.Handle);
end;

procedure TFrmwaiting.FormShow(Sender: TObject);
begin
  lblWaitingTime.Left := lblWaitingTitle.Left + lblWaitingTitle.Width + 10;
  Width := lblWaitingTime.Left +40;
  FTimerThead.Resume;
end;


function TFrmwaiting.ClacTimeStr(mSec: Integer): string;
var
  Second, Minute: Integer;
begin
  Second := mSec; //div 1000;
  Minute := Second div 60;
  Second := Second mod 60;
  Result := IntToStr(Second) + '秒';
  if Minute > 0 then
    Result := IntToStr(Minute) + '分' + Result;
end;

{ TTimerThead }

constructor TTimerThead.Create(TimeOut: Integer; Handle: Cardinal);
begin

  FTimeOut := TimeOut;
  FreeOnTerminate := True;
  FormHandle := Handle;
  inherited create(True);
end;

procedure TTimerThead.Execute;
var
  h: HWND;
  FStartTime: Cardinal;
begin
  inherited;
  FStartTime := GetTickCount;
  while not Terminated do
  begin
    Sleep(10);
    if Terminated then Exit;
    if (GetTickCount - FStartTime) >= FTimeOut then //超时
    begin
      PostMessage(FormHandle, WM_UPDATE, 0, -2);
      Terminate;
    end;
    if Terminated then Exit;
    PostMessage(FormHandle, WM_UPDATE, 0, GetTickCount - FStartTime);
  end;
end;


procedure TFrmwaiting.On_WM_UPDATE(var msg: TMessage);
begin
  if msg.lParam < 0 then
  begin
    HideWait;
  end
  else
  begin
    if Trunc(msg.lParam / 100) > FTag1 then
    begin
      FTag1 := FTag1 + 1;
      ImgIndex := ImgIndex mod 12;
      ImageList.Draw(self.Canvas, 30, 20, ImgIndex);
      Inc(ImgIndex);
      Application.ProcessMessages;
    end;
    if Trunc(msg.lParam / 1000) > FTag2 then
    begin
      FTag2 := Trunc(msg.lParam / 1000);
      lblWaitingTime.Caption := '用时' + ClacTimeStr(FTag2);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TFrmwaiting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FTimerThead) then
  begin
    FTimerThead.Terminate;
    FTimerThead := nil;
  end;
end;

initialization
  Showed := False;
finalization

end.
