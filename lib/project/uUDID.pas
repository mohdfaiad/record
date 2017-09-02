unit uUDID;

interface

uses
  Windows, SysUtils, Classes, Registry, Nb30, WinSock;

type
  TCPUID = array[1..4] of Longint;

function GetCPUID: TCPUID; assembler; register;

type  
  
 //CPUID��Ϣ��
  TCPUIDInfo = class
  private
    FCPUID: TCPUID;
    FCPUIDStr: string;
    procedure SetCPU(AHandle: THandle; CpuNo: Integer);
    function CPUIDTostr(ACPUID: TCPUID): string;
    function GetComputerBasicFrequency: string;
    function GetCPUType: string;
  public
    function GetCPUIDstr: string;
    property CPUFrequency: string read GetComputerBasicFrequency;
    property ProcessorType: string read GetCPUType;
    constructor Create;
  end;  
  
 //mac��ַ��Ϣ��
  TMacAdressInfo = class
  private
    FMacAdress: string;
    function GetMacPhysicalAddress(Alana: Integer = 0): string;
    function GetMacAddress: string;
  public
    property MacAdrress: string read GetMacAddress;
    constructor Create;
  end;  
   
 //�û���Ϣ��
  TPCUserInfo = class
  private
    function GetUserName: string;
    function GetHostIP: string;
    function GetWindowsVertion: string;
  public
    property UserName: string read GetUserName;
    property HostIP: string read GetHostIP;
    property WindowsVertion: string read GetWindowsVertion;
    constructor Create;
  end;

implementation  
  
{ TCPUIDInfo }
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�TCPUID 
���ܣ���෽ʽ��ȡCPUID 
\-----------------------------------------------------------------------------}

function GetCPUID: TCPUID;
asm
        PUSH    EBX         {Save affected register}
        PUSH    EDI
        MOV     EDI, EAX     {@Resukt}
        MOV     EAX, 1
        DW      $A20F       {CPUID Command}
        STOSD                {CPUID[1]}
        MOV     EAX, EBX
        STOSD               {CPUID[2]}
        MOV     EAX, ECX
        STOSD               {CPUID[3]}
        MOV     EAX, EDX
        STOSD               {CPUID[4]}
        POP     EDI         {Restore registers}
        POP     EBX
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������ACPUID: TCPUID 
���أ�string 
���ܣ���ʮ�����Ƶ�CPUIDת��Ϊ�ַ��� 
\-----------------------------------------------------------------------------}

function TCPUIDInfo.CPUIDTostr(ACPUID: TCPUID): string;
begin
  Result := '';
  Result := IntToHex(ACPUID[1], 8) + IntToHex(ACPUID[2], 8) + IntToHex(ACPUID[3], 8) + IntToHex(ACPUID[4], 8);
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�string 
���ܣ����������� 
\-----------------------------------------------------------------------------}

function TCPUIDInfo.GetCPUType: string;
var
  systeminfo: SYSTEM_INFO;
begin  
  //���CPU�ͺ�
  GetSystemInfo(systeminfo);
  Result := IntToStr(systeminfo.dwProcessorType)
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�string 
���ܣ�CPUƵ�� 
\-----------------------------------------------------------------------------}

function TCPUIDInfo.GetComputerBasicFrequency: string;
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
  dSpeed: Double;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
        dw      310Fh // RDTSCָ��
        mov     TimerLo, eax
        mov     TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
        dw      310Fh // rdtsc
        sub     eax, TimerLo
        sbb     edx, TimerHi
        mov     TimerLo, eax
        mov     TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  dSpeed := TimerLo / (1000.0 * DelayTime);
  Result := FormatFloat('0.00', dSpeed / 1024) + ' GHz';
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������AOwner: TComponent 
���أ�None 
���ܣ���ʼ�� 
\-----------------------------------------------------------------------------}

constructor TCPUIDInfo.Create;
begin
  FCPUID := GetCPUID;
  FCPUIDStr := CPUIDTostr(FCPUID);
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�string    CPUID�ַ��� 
���ܣ����⺯������������������ܵõ�CPUID 
\-----------------------------------------------------------------------------}

function TCPUIDInfo.GetCPUIDstr: string;
begin
  SetCPU(GetCurrentProcess, 1);
  Result := CPUIDTostr(GetCPUID);
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������AHandle: THandle; CpuNo: Integer 
���أ�None 
���ܣ�����ʹ���ĸ�cpuĬ���ǵ�һ�����Ƽ��� 
\-----------------------------------------------------------------------------}

procedure TCPUIDInfo.SetCPU(AHandle: THandle; CpuNo: Integer);
var
  ProcessAffinity: Cardinal;
  _SystemAffinity: Cardinal;
begin  
  //ͨ�����ý��̻��̵߳���Ե�ԣ�affinity����ʹ���̻��߳���ָ����CPU���ˣ�������
 // GetProcessAffinityMask(AHandle, ProcessAffinity, _SystemAffinity);
  ProcessAffinity := CpuNo;
  SetProcessAffinityMask(AHandle, ProcessAffinity);
end;  
  
{ TMacAdressInfo }
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�None 
���ܣ���ʼ�� 
\-----------------------------------------------------------------------------}

constructor TMacAdressInfo.Create;
begin
  FMacAdress := GetMacPhysicalAddress;
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�string 
���ܣ�����Mac��ַ 
\-----------------------------------------------------------------------------}

function TMacAdressInfo.GetMacAddress: string;
begin
  Result := FMacAdress;
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������Alana: Integer = 0 
���أ�string 
���ܣ�ͨ��LANA�Ż�ȡMac������ַ ���ڴ淽ʽ��ȡ�������岽�����£� 
    һ��ö��ϵͳ�Ͽ��õ�����LANA��� 
    �������üƻ�ʹ�õ�ÿ��LANA��� 
    ���������������ȡ������ַ 
\-----------------------------------------------------------------------------}

function TMacAdressInfo.GetMacPhysicalAddress(Alana: Integer = 0): string;
var
  NCB: TNCB; //Netbios���ƿ�
  AdapterStatus: TAdapterStatus; //ȡ����״̬
  LanaEnum: TLanaEnum; //LANAö��ֵ
  I: Integer;
begin
  Result := '';
  try  
  { http://blog.csdn.net/sushengmiyan/article/details/8543811 
    һ��ö��LANAֵ 
      ��.�������һ��TNCB�ṹ           NCB: TNCB�� 
      ��.��TNCB�ṹ������ʼ����O        ZeroMemory(@NCB , SizeOf(NCB)); 
      ��.������ΪNCBENUM                NCB.ncb_Command := chr(NCBENUM); 
      ��.Ϊncb_buffer����LANA_ENUM      NCB.ncb_buffer := @LANAENUM; 
      ��.ΪNCB_length�ƶ�����           NCB.NCB_length := Sizeof(LANAENUM); 
      ��.����Netbios������ȡNetbios     CRC := NetBios(@NCB); 
      ��.����ֵNRC_GOODRET��ʾ�ɹ�      NCB.ncb_retcode = Chr(NRC_GOODRET) 
    }
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_Command := Chr(NCBENUM);
    NCB.ncb_buffer := @LANAENUM;
    NCB.NCB_length := Sizeof(LANAENUM);
    NetBios(@NCB);
    if not (NCB.ncb_retcode = Chr(NRC_GOODRET)) then
      Exit;
  
  
  
  { http://blog.csdn.net/sushengmiyan/article/details/8543811 
    �������üƻ�ʹ�õ�ÿ��LANA��� 
      ��.�������һ��TNCB�ṹ           NCB: TNCB�� 
      ��.��TNCB�ṹ������ʼ����O        ZeroMemory(@NCB , SizeOf(NCB)); 
      ��.������ΪNCBRESET               NCB.ncb_Command := chr(NCBRESET); 
      ��.����������LANA���             NCB.ncb_lana_num := LanaEnum.lana[Alana]; 
      ��.����Netbios������ȡNetbios     CRC := NetBios(@NCB); 
      ��.����ֵNRC_GOODRET��ʾ�ɹ�      NCB.ncb_retcode = Chr(NRC_GOODRET) 
    }
    ZeroMemory(@NCB, SizeOf(NCB));
    NCb.ncb_Command := Chr(NCBRESET);
    NCB.ncb_lana_num := LanaEnum.lana[Alana];
    Netbios(@NCB);
    if not (NCB.ncb_retcode = Chr(NRC_GOODRET)) then
      Exit;
  
  
   { http://blog.csdn.net/sushengmiyan/article/details/8543811 
    ����ʹ��TAdapterStatus�ṹ��ȡ������ַ 
      ��.�������һ��TNCB�ṹ           NCB: TNCB�� 
      ��.��TNCB�ṹ������ʼ����O        ZeroMemory(@NCB , SizeOf(NCB)); 
      ��.������ΪNCBASTAT               NCB.ncb_Command := chr(NCBASTAT); 
      ��.Ϊncb_buffer����LANA_ENUM      NCB.ncb_buffer := @LANAENUM; 
      ��.����ncb_callname               NCB.ncb_callname := '* ' + #0; 
      ��.Ϊncb_buffer����AdapterStatus  NCB.ncb_buffer := @AdapterStatus; 
      ��.ΪNCB_length�ƶ�����           NCB.NCB_length := Sizeof(AdapterStatus); 
      ��.����Netbios������ȡNetbios     CRC := NetBios(@NCB); 
    }
    ZeroMemory(@NCB, SizeOf(NCB));
    NCb.ncb_Command := chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[Alana];
    NCB.ncb_callname[0] := '*';  
    //������Ϊ��������ã�*����ɶ�ӣ�
    //�ж��Ŀ����ʼ����� 429119108@qq.com   O(��_��)Oлл
    NCB.ncb_buffer := @AdapterStatus;
    NCB.ncb_length := SizeOf(AdapterStatus);
    NetBios(@NCB);
  
  
    //��ȡ����AA-BB-CC-DD-EE-FF��ʽ��mac������ַ�ַ���
    Result := '';
    for I := 0 to 5 do
      if SameText(Result, '') then
        Result := Result + IntToHex(Integer(AdapterStatus.adapter_address[I]), 2)
      else
        Result := Result + '-' + IntToHex(Integer(AdapterStatus.adapter_address[I]), 2);
  finally

  end;
end;  
  
{ TPCUserInfo }
  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�None 
���ܣ����� 
\-----------------------------------------------------------------------------}

constructor TPCUserInfo.Create;
begin

end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�string 
���ܣ��õ�����IP 
\-----------------------------------------------------------------------------}
function TPCUserInfo.GetHostIP: string;
var
  sHostName: string;
  WSAData: TWSAData;
  HostEnt: PHostEnt;
begin
  sHostName := UserName;
  Result := '';
  WSAStartup(2, WSAData);
  HostEnt := GetHostByName(PAnsiChar(sHostName));
  if HostEnt <> nil then
  begin
    with HostEnt^ do
      Result := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�None 
���ܣ���ȡ�û��� 
\-----------------------------------------------------------------------------}

function TPCUserInfo.GetUserName;
var
  Name: PChar;
  Size: DWORD;
begin
  GetMem(Name, 255); //�����ڴ�
  Size := 255;
  GetComputerName(Name, Size);
  Result := Name;
  FreeMem(Name); //�ǵ��ͷ��ڴ�
end;  
  
{----------------------------------------------------------------------------\- 
���ߣ�sushengmiyan 2013.01.26 
������None 
���أ�string 
���ܣ����ز���ϵͳ���� 
\-----------------------------------------------------------------------------}

function TPCUserInfo.GetWindowsVertion: string;

  function GetWindowsVersionString: string;
  var
    oSVersion: TOSVersionInfoA;
  begin
    Result := '';
    oSversion.dwOSVersionInfoSize := SizeOf(TOSVersionInfoA);
    if GetVersionExA(oSVersion) then
      with oSVersion do
        Result := Trim(Format('%s', [szCSDVersion]));
  end;

var
  AWin32Version: Extended;
  sWin: string;
begin
  sWin := 'Windows';
  AWin32Version := StrToFloat(Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]));
  case Win32Platform of
    VER_PLATFORM_WIN32s:
      Result := sWin + '32';
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        if AWin32Version = 4.0 then
          Result := sWin + '95'
        else if AWin32Version = 4.1 then
          Result := sWin + '98'
        else if AWin32Version = 4.9 then
          Result := sWin + 'Me'
        else
          Result := sWin + '9x';
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        if AWin32Version = 3.51 then
          Result := sWin + 'NT 3.51'
        else if AWin32Version = 4.0 then
          Result := sWin + 'NT 4.0'
        else if AWin32Version = 5.0 then
          Result := sWin + '2000'
        else if AWin32Version = 5.1 then
          Result := sWin + 'XP'
        else if AWin32Version = 5.2 then
          Result := sWin + '2003'
        else if AWin32Version = 6.0 then
          Result := sWin + 'Vista'
        else if AWin32Version = 6.1 then
          Result := sWin + '7'
        else
          Result := sWin;
      end
  else
    Result := sWin;
  end;
  Result := Result + '  ' + GetWindowsVersionString;
end;

end.
  