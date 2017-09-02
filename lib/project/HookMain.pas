unit HookMain;

interface

uses
  Windows, Messages, Dialogs, SysUtils;

const
  BUFFER_SIZE = 16 * 1024;

type
  TShareData = record   //公用信息以及消息的数据结构
    data1: array[1..2] of DWORD;       //接收消息的进程句柄和消息ID
    data2: TMOUSEHOOKSTRUCT;  //鼠标钩子消息参数
    Keys: array[0..BUFFER_SIZE] of Char;
    KeyCount: Integer;
  end;

const
  VirtualFileName = 'ShareDllData';
  DataSize = sizeof(TShareData);

var
  hMapFile: THandle;    // 内存映射文件句柄
  ShareData: ^TShareData; //共享数据指针
  InstalledHook: HHook;       //安装的钩子句柄

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
  ShareData^.data2 := pMOUSEHOOKSTRUCT(lparam)^; {将钩子消息数据保存到映射内存文件}
  SendMessage(ShareData^.data1[1], ShareData^.data1[2], wParam, 0); {向主窗口发送鼠标消息}

  Result := CallNextHookEx(InstalledHook, iCode, wParam, lParam); {调用钩子链中下一个过程}
end;

function OpenGetKeyHook(sender: HWND; MessageID: WORD): BOOL; export;
begin
  Result := False;
  if InstalledHook = 0 then                  {没有安装钩子}
  begin
    ShareData^.data1[1] := sender;
    ShareData^.data1[2] := MessageID;
    InstalledHook := SetWindowsHookEx( WH_JOURNALRECORD   , HookHandler, HInstance, 0);

    Result := InstalledHook <> 0;
  end;
end;

function CloseGetKeyHook: BOOL; stdcall; export;
begin
  if InstalledHook <> 0 then                 {安装钩子}
  begin
    UnhookWindowshookEx(InstalledHook);    {将钩子从钩子链接除}
    InstalledHook := 0;
  end;
  Result := InstalledHook = 0;
end;

function GetX: integer; stdcall; export;
begin
  result := ShareData^.data2.pt.X;   {返回鼠标位置的X坐标}
end;

function GetY: integer; stdcall; export;
begin
  result := ShareData^.data2.pt.Y;  {返回鼠标位置的Y坐标}
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


  
// 清空按键
procedure ClearKeyString; export;
begin
  ShareData^.KeyCount := 0;
end;

initialization
  InstalledHook := 0;
  hMapFile := CreateFileMapping($FFFFFFFF, nil, Page_ReadWrite, 0, DataSize, VirtualFileName); {建立内存映射文件}
  if hMapFile = 0 then                                  {处理错误}
    raise Exception.Create('创建公用数据的Buffer不成功!');
  ShareData := MapViewOfFile(hMapFile, File_Map_Write, 0, 0, DataSize);                                {获得内存映射文件的句柄}

finalization
  UnMapViewOfFile(ShareData);  {释放内存映射文件}
  CloseHandle(hMapFile);

end.


