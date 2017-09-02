unit HookMain;

interface

uses
  Windows, Messages, Dialogs, SysUtils;

const
  BUFFER_SIZE = 16 * 1024;

type
  TShareData = record   //������Ϣ�Լ���Ϣ�����ݽṹ
    data1: array[1..2] of DWORD;       //������Ϣ�Ľ��̾������ϢID
    data2: TMOUSEHOOKSTRUCT;  //��깳����Ϣ����
    Keys: array[0..BUFFER_SIZE] of Char;
    KeyCount: Integer;
  end;

const
  VirtualFileName = 'ShareDllData';
  DataSize = sizeof(TShareData);

var
  hMapFile: THandle;    // �ڴ�ӳ���ļ����
  ShareData: ^TShareData; //��������ָ��
  InstalledHook: HHook;       //��װ�Ĺ��Ӿ��

function HookHandler(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; export;

function OpenGetKeyHook(sender: HWND; MessageID: WORD): BOOL; export;
function CloseGetKeyHook: BOOL; stdcall; export;
function GetX: integer; stdcall; export;

function GetY: integer; stdcall; export;

function KeyHookProc(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; export;

function GetKeyCount: Integer; export;

function GetKey1(index: Integer):Char; export;

procedure ClearKeyString; export;

implementation

function HookHandler(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall; export;
begin
  ShareData^.data2 := pMOUSEHOOKSTRUCT(lparam)^; {��������Ϣ���ݱ��浽ӳ���ڴ��ļ�}
  SendMessage(ShareData^.data1[1], ShareData^.data1[2], wParam, 0); {�������ڷ��������Ϣ}

  Result := CallNextHookEx(InstalledHook, iCode, wParam, lParam); {���ù���������һ������}
end;

function OpenGetKeyHook(sender: HWND; MessageID: WORD): BOOL; export;
begin
  Result := False;
  if InstalledHook = 0 then                  {û�а�װ����}
  begin
    ShareData^.data1[1] := sender;
    ShareData^.data1[2] := MessageID;
    InstalledHook := SetWindowsHookEx( WH_JOURNALRECORD   , HookHandler, HInstance, 0);

    Result := InstalledHook <> 0;
  end;
end;

function CloseGetKeyHook: BOOL; stdcall; export;
begin
  if InstalledHook <> 0 then                 {��װ����}
  begin
    UnhookWindowshookEx(InstalledHook);    {�����Ӵӹ������ӳ�}
    InstalledHook := 0;
  end;
  Result := InstalledHook = 0;
end;

function GetX: integer; stdcall; export;
begin
  result := ShareData^.data2.pt.X;   {�������λ�õ�X����}
end;

function GetY: integer; stdcall; export;
begin
  result := ShareData^.data2.pt.Y;  {�������λ�õ�Y����}
end;

function KeyHookProc(iCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; export;
const
  KeyPressMask = $80000000;
begin
  if iCode < 0 then
    Result := CallNextHookEx(InstalledHook, iCode, wParam, lParam)
  else
  begin
    if ((lParam and KeyPressMask) = 0) then
    begin
      ShareData^.Keys[ShareData^.KeyCount] := Char(wParam and $00FF);
      Inc(ShareData^.KeyCount);

      if ShareData^.KeyCount >= BUFFER_SIZE - 1 then
        ShareData^.KeyCount := 0;
    end;
    result := 0;
  end;
end;

function GetKey1(index: Integer):Char; export;
begin
  Result := ShareData^.Keys[index];
end;

function GetKeyCount: Integer; export;
begin
  Result := ShareData^.KeyCount;
end;


  
// ��հ���
procedure ClearKeyString; export;
begin
  ShareData^.KeyCount := 0;
end;

initialization
  InstalledHook := 0;
  hMapFile := CreateFileMapping($FFFFFFFF, nil, Page_ReadWrite, 0, DataSize, VirtualFileName); {�����ڴ�ӳ���ļ�}
  if hMapFile = 0 then                                  {�������}
    raise Exception.Create('�����������ݵ�Buffer���ɹ�!');
  ShareData := MapViewOfFile(hMapFile, File_Map_Write, 0, 0, DataSize);                                {����ڴ�ӳ���ļ��ľ��}

finalization
  UnMapViewOfFile(ShareData);  {�ͷ��ڴ�ӳ���ļ�}
  CloseHandle(hMapFile);

end.


