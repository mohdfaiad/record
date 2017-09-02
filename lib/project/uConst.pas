unit uConst;

interface

uses
  Windows, SysUtils, Variants, Classes, Registry, WinInet, Forms, TLHelp32, Log;

const
  ICON_ID = 1;
  SUS_DIRXIS = 99;         //Ŀ¼����
  ERROR_DIRXIS = -99;  // Ŀ¼�����ڡ�
  SUS_FILEXIS = 100;         //�ļ�����
  ERROR_FILEXIS = -100;  // �ļ������ڡ�
  SUS_CREATEICON = 101;        //����icon sus
  ERROR_CREATEICON = -101;     //����icon fail
  SUS_SETICON = 102;         //����icon sus
  ERROR_SETICON = -102;      //����icon fail
  ERROR_MOUSEHOOK = -110;       // ����깳�� fail
  SUS_KEYHOOK = 111;              // �򿪼��̹��� sus
  ERROR_KEYHOOK = -111;             //�򿪼��̹��� fail
  SUS_ADDTASK = 112;                //��������ɹ�
  ERROR_ADDTASK = -112;             //��������ʧ��
  ERROR_DATA = -200;             //���ڴ���
  ERROR_LOADDLL = -201;               // ����dll ����

type
  PHisStep = ^THisStep;

  THisStep = record
    lastExe: string;
    lasExeCount: Integer;
    lastStarTime: string;
    lastEndTime: string;
  end;

  THostInfo = record
    ip: string;
    port: Integer;
  end;

  TError = record
    errorCode: Integer;
    errorMsg: string;
  end;

  TTaskTrigger = record
    triggerDevice: string;
    triggerCondition: string;
    triggerCount: Integer;
  end;

  TTaskExecute = record
    taskExe: string;
    taskCount: Integer;
    taskCost: double;
  end;

  TTaskInfo = record
    id: Integer;                         // ����Ψһ��־
    taskTitle: string;                  // �������
    taskContent: string;               // ��������
    taskType: string;                 //��������
    taskStatus: Integer;             // ����״̬
    taskCreatime: string;           //���񴴽�ʱ��
    taskConditions: TTaskTrigger;  //���񴥷���
    taskExecute: TTaskExecute;    //����ִ����
    taskhandle: Cardinal;        //������
    lastUpdate: string;         //�������ʱ��
  end;

  PTaskInfo = ^TTaskInfo;

  TTaskInfoArr = array of TTaskInfo;
   // �����

  TProcessMsg = record
    processName: string;
    processUseTime: string;
    processHandle: Integer;
  end;

  TBrowerInfo = record
    bookmarksPath: string;
    historyPath: string;
    passwordPath: string;
  end;

  TPassword = record
    origin_url: string;
    username_value: string;
    password_value: string;
    create_time: TDateTime;
  end;

  TBookmark = record
    date_added: TDateTime;
    id: Integer;
    name: string;
    sync_transaction_version: Integer;
    bookmarkType: string;
    url: string;
    owner: string;
  end;

  TBookmarkDir = record
    date_added: TDateTime;
    date_modified: TDateTime;
    id: Integer;
    name: string;
    sync_transaction_version: Integer;
    bookmarkType: string;
    internetType: string;
    owner: string;
  end;

  TRecordTime = record
    workTime: Double;
    relaxaTime: Double;
    halfTime: Double;
    unKownTime: Double;
    sleepTime: Double;
    blankTime: Double;
  end;
  //

  TActiveTyInfo = record
    percent: Double;
    costime: Double;
    activety: string;
    activetype: string;
    activeContent: string;
  end;

  TArrActiveTyInfo = array of TActiveTyInfo;
  //

  TRecordInfo = record
    classType: string;
    cost: Double;
    ActiveTyInfo: string;
  end;

  TArrRecordInfo = array of TRecordInfo;

  TBrowser = record
    browserName: string;
    bPt: TPoint;
    status: Integer;
  end;

  PRecordInfo = ^TRecordtyInfo;

  TRecordtyInfo = record
    starTime: Double;
    endTime: Double;
    costTime: Double;
    recordName: string;
    recordTitle: string;
    valueTag: Boolean;
    classType: string;
    ruleType: Integer;
  end;

  TArrRecordtyInfo = array of TRecordtyInfo;

  PArrRecordtyInfo = ^TArrRecordtyInfo;

  PBrowser = ^TBrowser;

  TRecordType = record
    costTime: Double;
    ruleType: string;
    recordContent: TArrRecordtyInfo;
  end;

  TArrRecordType = array of TRecordType;

  TClassType = record
    urlApplication, urlAppclass, urlAppRemarks, className: string;
  end;

function CheckUrlType(url: string): boolean;

function IsUrl(url: string): Boolean;

function ChecekUrl(activename: string): string;

function IsValidURLProtocol(const URL: string): Boolean;

function UnixToDateTime(const USec: Double): TDateTime;

function DateTimeToUnix(const ADate: TDateTime): Double;

function FileToString(mFileName: TFileName): string;

function GetGUID: string;

function SetAutoRun(ok: boolean; exename: string): Integer;

function timeToSecond(times: string): Integer;

function ShutDown(hostname: THostInfo): Integer;

function GetOperatingSystem: string;//��ȡ����ϵͳ��Ϣ

function DateTostring(date: Double): string;

function RoundFloat(f: double; i: integer): double;

procedure delay(msecs: integer);        //��ʱ

function GetPidtoName(PID: DWORD): string;  //������

function RegisterAutoStart(registerName, exeName: string): Integer; //ע�Ὺ��������



implementation



function RegisterAutoStart(registerName, exeName: string): Integer;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('SOFTWARE\Microsoft\windows\CurrentVersion\Run', true); //��һ����
    reg.WriteString(registerName, exeName); //��Reg�������д���������ƺ�������ֵ
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

function IsValidURLProtocol(const URL: string): Boolean;
const
  Protocols: array[1..12] of string =(
    // Array of valid protocols - per RFC 1738
    'www.', 'ftp://', 'http://', 'https://', 'gopher://', 'mailto:', 'news:', 'nntp://', 'telnet://', 'wais://', 'file://', 'prospero://');
var
  I: Integer;   // loops thru known protocols
begin
  // Scan array of protocols checking for a match with start of given URL
  Result := False;
  for I := Low(Protocols) to High(Protocols) do
    if Pos(Protocols[I], SysUtils.LowerCase(URL)) = 1 then
    begin
      Result := True;
      Exit;
    end;
end;

function UnixToDateTime(const USec: Double): TDateTime;
var
  // 1601��1��1��0ʱ0��0��
  ZI: TTimeZoneInformation;
begin
  GetTimeZoneInformation(ZI);     //ʱ��
  Result := (USec - 60 * ZI.Bias) / 86400 + VarToDateTime('1601-01-01 00:00:00AM');
end;

function DateTimeToUnix(const ADate: TDateTime): Double;
var
  ZI: TTimeZoneInformation;
  unixTime: TDateTime;
begin
  unixTime := VarToDateTime('1601-01-01 00:00:00AM');
  GetTimeZoneInformation(ZI);     //ʱ��
  Result := (ADate - unixTime) * 86400 + 60 * ZI.Bias;

end;

   {   StreamToString   }

function FileToString(mFileName: TFileName): string;
{   ���ش��ļ������ַ���   }
var
  vFileChar: file of Char;
  vChar: Char;
begin
  Result := '';
{$I-}
  AssignFile(vFileChar, mFileName);
  Reset(vFileChar);

  while not Eof(vFileChar) do
  begin
    Read(vFileChar, vChar);
    Result := Result + vChar;
  end;
  CloseFile(vFileChar);
{$I+}
end;   {   FileToString   }

function GetGUID: string;
var
  LTep: TGUID;
begin
  CreateGUID(LTep);
  Result := GUIDToString(LTep);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := Copy(Result, 2, Length(Result) - 2);
end;

function SetAutoRun(ok: boolean; exename: string): Integer;
var
  Reg: TRegistry; //���ȶ���һ��TRegistry���͵ı���Reg
begin
  Reg := TRegistry.Create;
  try //����һ���¼�
    Reg.RootKey := HKEY_LOCAL_MACHINE; //����������ΪHKEY_LOCAL_MACHINE
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true); //��һ����
    if ok then
    begin
      Reg.WriteString('SMS����', exename); //��Reg�������д���������ƺ�������ֵ
    end
    else
    begin
      Reg.DeleteValue('SMS����');
    end;
    Reg.CloseKey; //�رռ�
  finally
    Reg.Free;
  end;
end;

function timeToSecond(times: string): Integer;
var
  temp: string;
  h, m, s: Integer;
begin
  temp := Copy(times, 1, 2);
  h := StrToInt(temp) * 3600;
  temp := Copy(times, 4, 2);
  m := StrToInt(temp) * 60;
  Result := h + m;
end;

function ShutDown(hostname: THostInfo): Integer;
begin

end;

function GetOperatingSystem: string;//��ȡ����ϵͳ��Ϣ
var
  osVerInfo: TOSVersionInfo;
begin
  Result := '';
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
    case osVerInfo.dwPlatformId of
      VER_PLATFORM_WIN32_NT:
        begin
          Result := 'Windows NT/2000/XP'
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          Result := 'Windows 95/98/98SE/Me';
        end;
    end;
end;

function RoundFloat(f: double; i: integer): double;
var
  s: string;
  ef: extended;
begin
  s := '#.' + StringOfChar('0', i);
  ef := StrToFloat(FloatToStr(f)); //��ֹ������������
  result := StrToFloat(FormatFloat(s, ef));
end;

function DateTostring(date: Double): string;
var
  h, m, s: Double;
  th, tm: Double;
  d: Integer;
begin
  Result := FormatDateTime('HH:MM:SS', date);
  if date >= 1 then
  begin
    d := Trunc(date);
    Result := IntToStr(d) + 'd:' + Result;
  end;
end;

function CheckUrlType(url: string): boolean;
var
  hSession, hfile, hRequest: hInternet;
  dwindex, dwcodelen: dword;
  dwcode: array[1..20] of char;
  res: pchar;
begin
  if pos('http://', lowercase(url)) = 0 then
    url := 'http://' + url;
  Result := false;
  hSession := InternetOpen('InetURL:/1.0', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if assigned(hSession) then
  begin
    hfile := InternetOpenUrl(hSession, pchar(url), nil, 0, INTERNET_FLAG_RELOAD, 0);
    dwindex := 0;
    dwcodelen := 10;
    HttpQueryInfo(hfile, HTTP_QUERY_STATUS_CODE, @dwcode, dwcodelen, dwindex);
    res := pchar(@dwcode);
    result := (res = '200') or (res = '302');
    if assigned(hfile) then
      InternetCloseHandle(hfile);
    InternetCloseHandle(hSession);
  end;
end;

function IsUrl(url: string): Boolean;
var
  i, j, k, Len, count: Integer;
  tempS: string;
begin
  result := False;
  count := 0;
  if pos('https://', lowercase(url)) = 1 then
    Result := True;
  Len := Length(url);
  if Len > 20 then
    Len := 20;
  for i := 0 to Len - 1 do
  begin
    if ord(url[i]) < 127 then
      Inc(count);
    if count > 5 then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function ChecekUrl(activename: string): string;
var
  i, j, k, Len: Integer;
  tempS: string;
begin
  Result := activename;
  Len := Length(activename);
  tempS := Copy(activename, Len - 2, 3);
  if tempS = 'exe' then
    Exit;
  tempS := activename;
  for i := 0 to Len - 1 do
  begin
    if activename[i] = '.' then
    begin
      for j := i + 1 to Len - 1 do
        if activename[j] = '.' then
        begin
          for k := j + 1 to Len do
            if (activename[k] = '/') then
            begin
              tempS := Copy(activename, 0, k - 1);
              if pos('https://', lowercase(tempS)) = 0 then
              begin
                if pos('http://', lowercase(tempS)) = 0 then
                  tempS := 'http://' + tempS;
              end;
              Result := tempS;
              Exit;
            end;
        end;
    end;
  end;
end;

procedure delay(msecs: integer);
var
  Tick: DWord;
  Event: THandle;
begin
  Event := CreateEvent(nil, False, False, nil);
  try
    Tick := GetTickCount + DWord(msecs);
    while (msecs > 0) and (MsgWaitForMultipleObjects(1, Event, False, msecs, QS_ALLINPUT) <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      msecs := Tick - GetTickcount;
    end;
  finally
    CloseHandle(Event);
  end;
end;

function GetPidtoName(PID: DWORD): string;
var
  ProcessName: string; //������
  ProcessID: integer; //���̱�ʾ��
  ContinueLoop: BOOL;       //�Ƿ����ѭ��
  FSnapshotHandle: THandle; //���̿��վ��
  FProcessEntry32: TProcessEntry32; //������ڵĽṹ����Ϣ
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0); //����һ�����̿���
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32); //�õ�ϵͳ�е�һ������
//ѭ������
  while ContinueLoop do
  begin
    ProcessName := FProcessEntry32.szExeFile;
    ProcessID := FProcessEntry32.th32ProcessID;
    if ProcessID = PID then
    begin
      Result := ProcessName;
      Exit;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
end;

end.
