unit dyKeyMouseHook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEnableKeyHook = function: BOOL; stdcall;

  TDisableKeyHook = function: BOOL; stdcall;

  TGetKeyCount = function: Integer; stdcall;

  TGetKey = function(index: Integer): Char; stdcall;

  TClearKeyString = procedure; stdcall;

  TOpenMouseHook = function(sender: HWND; MessageID: WORD): BOOL; stdcall;

  TCloseGetKeyHook = function: BOOL; stdcall;

  TGetMouseCount = function: Integer; stdcall;

  TGetMouse = function(index: Integer): TMOUSEHOOKSTRUCT; stdcall;

  TGetMessageMsg = function(index: Integer): Integer; stdcall;

  TSetShareCount = function(): Integer; stdcall;
{
function EnableKeyHook: BOOL; external 'KeyMouseHook.DLL';

function DisableKeyHook: BOOL; external 'KeyMouseHook.DLL';

function GetKeyCount: Integer; external 'KeyMouseHook.DLL';

function GetKey(index: Integer): Char; external 'KeyMouseHook.DLL';

procedure ClearKeyString; external 'KeyMouseHook.DLL';

function OpenMouseHook(sender: HWND; MessageID: WORD): BOOL; external 'KeyMouseHook.DLL';

function CloseGetKeyHook: BOOL; external 'KeyMouseHook.DLL';

function GetMouseCount: Integer; external 'KeyMouseHook.DLL';

function GetMouse(index: Integer): TMOUSEHOOKSTRUCT; external 'KeyMouseHook.DLL';

function GetMessageMsg(index: Integer): Integer; external 'KeyMouseHook.DLL';

function SetShareCount: Integer; external 'KeyMouseHook.DLL';
}

var
  EnableKeyHook: TEnableKeyHook;
  DisableKeyHook: TDisableKeyHook;
  GetKeyCount: TGetKeyCount;
  GetKey: TGetKey;
  ClearKeyString: TClearKeyString;
  OpenMouseHook: TOpenMouseHook;
  CloseGetKeyHook: TCloseGetKeyHook;
  GetMouseCount: TGetMouseCount;
  GetMouse: TGetMouse;
  GetMessageMsg: TGetMessageMsg;
  SetShareCount: TSetShareCount;

function dyLoadHookDll(dllFilename: string): Integer;

implementation

function dyLoadHookDll(dllFilename: string): Integer;
var
  temp: integer;
  handle: THandle;
  FPointer: TFarProc;
  error: Integer;
  s: TStringList;
begin
  handle := LoadLibrary(PChar(dllFilename));
  if handle <> 0 then
  try
    FPointer := GetProcAddress(handle, 'EnableKeyHook');     {获得函数的入口地址}
    if FPointer <> nil then
    begin
      EnableKeyHook := TEnableKeyHook(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'DisableKeyHook');    
    if FPointer <> nil then
    begin
      DisableKeyHook := TDisableKeyHook(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'GetKeyCount');
    if FPointer <> nil then
    begin
      GetKeyCount := TGetKeyCount(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'GetKey');
    if FPointer <> nil then
    begin
      GetKey := TGetKey(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'ClearKeyString');
    if FPointer <> nil then
    begin
      ClearKeyString := TClearKeyString(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'OpenMouseHook');
    if FPointer <> nil then
    begin
      OpenMouseHook := TOpenMouseHook(FPointer);
    end;

    FPointer := GetProcAddress(handle, 'CloseGetKeyHook');
    if FPointer <> nil then
    begin
      CloseGetKeyHook := TCloseGetKeyHook(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'GetMouseCount');
    if FPointer <> nil then
    begin
      GetMouseCount := TGetMouseCount(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'GetMouse');
    if FPointer <> nil then
    begin
      GetMouse := TGetMouse(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'GetMessageMsg');
    if FPointer <> nil then
    begin
      GetMessageMsg := TGetMessageMsg(FPointer);
    end;
    FPointer := GetProcAddress(handle, 'SetShareCount');
    if FPointer <> nil then
    begin
      SetShareCount := TSetShareCount(FPointer);
    end;
  finally
       // FreeLibrary(handle);                              {释放DLL}
  end
  else
    ShowMessage('未找到动态链接库MyFirstDLL.dll');
end;

end.

