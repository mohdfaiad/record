unit MainUnit;

interface

uses
  Windows, Messages, ExtCtrls, SysUtils, Menus, StdCtrls, Classes, Controls,
  Graphics, Forms, Dialogs, ShellAPI, Variants, config, ComCtrls, uUDID, uTask,
  qworker, uConst, jpeg, RzDTP, urecord, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client;

const
  MI_ICONEVENT = WM_USER + 1;
  MessageID = WM_User + 100;

type
  TMainForm = class(TForm)
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Image8: TImage;
    Label3: TLabel;
    N4: TMenuItem;
    RzDateTimePicker1: TRzDateTimePicker;
    RzDateTimePicker2: TRzDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    FDConnection1: TFDConnection;
    Button3: TButton;
    FDManager1: TFDManager;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure PNGButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PNGButton2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FError: TError;
    function SetupIcon: Integer;                //�������а�װͼ��
    procedure FreeIcon; //���������ͷ�ͼ��
    function InitIcon(): TError; // ��ʼ������ͼ��
    procedure IconOnClick(var Msg: TMessage); message MI_ICONEVENT; //����ͼ�����¼�
    function ChangeIcon(s: Boolean): Integer;                      //�ı������е�ͼ��
    procedure WMPowerBroadcast(var AMessage: TMessage); message WM_POWERBROADCAST;
  public
    { Public declarations }
    //���Ժ���
    function testJobdata1(): integer;
    procedure testJobdata(AJob: PQJob);
    procedure TestUtf8();
  end;

var
  MainForm: TMainForm;
  NormalIcon, DisabledIcon: TIcon; //������ʧЧ����µ�ͼ��
  Status: Boolean; //��־�ǡ�ʹ��״̬�����ǡ�����״̬��

implementation

uses
  ShowUnit, taskForms, Log;
{$R *.DFM}
            //���崴��

procedure TMainForm.FormCreate(Sender: TObject);
var
  errorS: string;
begin
  myTask := TTask.Create(self.handle);
  FError := myTask.GetLastError;
  if FError.errorCode <> 0 then
  begin
    PostQuitMessage(0);
    exit;
  end;
  FError := InitIcon;
  if FError.errorCode < 0 then
  begin
    errorS := Format('create icon fail : reaMsg%s, resCode%d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
    PostQuitMessage(0);
    exit;
  end;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

procedure TMainForm.FreeIcon;
begin
  NormalIcon.Free;
  DisabledIcon.Free;
end;

procedure TMainForm.IconOnClick(var Msg: TMessage);
var
  pt: TPoint;
begin
  if (Msg.LParam = WM_LBUTTONDOWN) and (Status = True) then
    ShowForm.Show;
  if (Msg.LParam = WM_RBUTTONDOWN) then
  begin
    GetCursorPos(pt);
    PopupMenu1.Popup(pt.x, pt.y);
  end;
end;

function TMainForm.InitIcon: TError;
var
  error: Integer;
begin
  Status := True;             //ʹ��״̬
  error := SetupIcon;                  //��������ͼ��
  if error <> SUS_SETICON then
  begin
    Mylog.writeWorkLog(format('��������ͼ��ʧ�ܣ�ȱʧ����������Դ��������%d', [error]));
    Result.errorCode := error;
    Exit;
  end;
  error := ChangeIcon(True);           //����ͼ��
  if error <> SUS_CREATEICON then
  begin
    Mylog.writeWorkLog(format('��������ͼ��ʧ�ܡ�������%d', [error]));
  end;
  Result.errorCode := error;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  myTask.DisableWorkers;
  myTask.CloseConnect;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  myTask.OpenConnect;
  myTask.EnableWorkers;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  activeFormHandle: HWND;
  buf: array[Byte] of Char;
  F, n: TextFile;
const
  filestr = 'record.log';
begin
  AssignFile(F, filestr);
//  Append(f);//�����У��� I/O error 103
 // ReWrite(F);
  CloseFile(F);
end;

function TMainForm.ChangeIcon(s: Boolean): Integer;
var
  IconData: TNotifyIconData;
begin
  IconData.cbSize := SizeOf(IconData);
  IconData.Wnd := Self.Handle;
  IconData.uID := Icon_ID;
  if s = False then
  begin
    IconData.hIcon := DisabledIcon.Handle;
    Status := False;
  end
  else
  begin
    IconData.hIcon := NormalIcon.Handle;
    Status := True;
  end;
  IconData.uFlags := NIF_ICON;
  if not Shell_NotifyIcon(NIM_MODIFY, @IconData) then
  begin
    Result := ERROR_CREATEICON;
  end
  else
  begin
    Result := SUS_CREATEICON;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeIcon;
  myTask.Destory;
  //Application.Terminate;
end;

procedure TMainForm.N1Click(Sender: TObject);
begin
  ShowForm.Show;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
  if Status = True then
  begin
    ChangeIcon(False);
    N2.Caption := 'ʹ��';
    myTask.DisableWorkers;
   // myTask.CloseConnect;

  end
  else
  begin
    ChangeIcon(True);
    N2.Caption := '����';
    //myTask.ClearError;
    processCount := 1;
    myTask.EnableWorkers;
  end;
end;
//�˳�

procedure TMainForm.N3Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.PNGButton1Click(Sender: TObject);
begin
  Self.Hide;
end;

procedure TMainForm.PNGButton2Click(Sender: TObject);
begin
  Hide;
end;

function TMainForm.SetupIcon: Integer;
var
  IconData: TNotifyIcondata;
  iTrapIconFilename, oiTrapIconFilename: string;
begin
  NormalIcon := TIcon.Create;
  DisabledIcon := TIcon.Create;
  iTrapIconFilename := gmm.AppDir + '\media\icon\open.ico';
  oiTrapIconFilename := gmm.AppDir + '\media\icon\close.ico';
  NormalIcon.LoadFromFile(iTrapIconFilename);
  DisabledIcon.LoadFromFile(oiTrapIconFilename);
  IconData.cbSize := SizeOf(IconData);
  IconData.Wnd := Self.Handle;
  IconData.uID := Icon_ID;
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  IconData.uCallbackMessage := MI_ICONEVENT;
  IconData.hIcon := NormalIcon.Handle;
  IconData.szTip := 'collectTower,welcome  you use';
  if Shell_NotifyIcon(NIM_ADD, @IconData) then
  begin
    Result := SUS_SETICON;
  end
  else
  begin
    Result := ERROR_SETICON;
  end;
end;

procedure TMainForm.testJobdata(AJob: PQJob);
var
  s: string;
begin
  s := PTaskInfo(AJob.data).taskTitle;
  Memo1.Lines.Add(s);
end;

function TMainForm.testJobdata1: integer;
var
  taskINF1: TTaskInfo;
  PTAS: PTaskInfo;
begin
 // Workers.Post(testJobdata, 3 * Q1Second, PTAS);
end;

procedure TMainForm.TestUtf8;

  function StrToHex(const S: string): string; overload;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Length(S) do
      Result := Result + IntToHex(Ord(S[I]), 2);
  end;

  function StrToHex(const S: WideString): string; overload;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Length(S) do
      Result := Result + IntToHex(Ord(S[I]), 2);
  end;

var
  s: WideString;
  us: string;
begin
  s := '��';
  ShowMessage(Format('%s=%s', [s, StrToHex(s)]));
  us := UTF8Encode(s);
  ShowMessage(Format('%s=(utf8)%s', [s, StrToHex(us)]));
end;

procedure TMainForm.WMPowerBroadcast(var AMessage: TMessage);
const
  PBT_APMSUSPEND = 4;
  PBT_APMRESUMESUSPEND = 7;
begin
  case AMessage.WParam of
    PBT_APMSUSPEND:
      begin
        Mylog.writeWorkLog('pc  starsleep');
        myTask.DisableWorkers;

      end;
    PBT_APMRESUMESUSPEND:
      begin
        Mylog.writeWorkLog('pc sleep end');
        processCount := 0;
        myTask.ClearError;

        myTask.EnableWorkers;
      end;
  end;
end;

end.
