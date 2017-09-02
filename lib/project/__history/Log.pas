unit Log;

interface

uses
  Classes, windows, SysUtils, Dialogs;

const
  //0 提示 -1 错误 1 警告  level
  ErrorLevel = -1;
  WarmLevel = 1;
  HintLevel = 0;
  //
  OFFLOG = 2;   //关闭所有日志记录
  FATALLOG = 3;  //导致程序退出的错误
  ERROELOG = 4; //发生了错误但不影响系统运行
  WARNLOG = 5;  //会出现潜在的错误情形
  INFOLOG = 6;   //系统发生了那些事情
  DEBUGLOG = 7; //调试程序有关的信息
  ALLLOG = 8;  //输出所有日志记录

type
  TLogBuffer = class
  private
    FMaxBufferSize: Int64;
   // F : TSTREAM ;
    FBuffer: TStringStream;
    procedure SetBufferSize(value: int64);
    function GetBufferSize(): int64;
  public
    constructor Create();
    destructor Destroy; override;
    procedure AppendBuffer(Data: string);
    procedure ResetBuffer();
    property BufferSize: Int64 read GetBufferSize;
    property MaxBuffer: Int64 read FMaxBufferSize write SetBufferSize;
    property Buf: TStringStream read FBuffer;
  end;

  TMyLog = class
  private
    FlogFileName: string;
    FCSLock: TRTLCriticalSection; //临界区
    FMaxLogSize: Int64;
    FLogType: Integer;  // 2:all  3:hint  4: warming 5 error
    FLogBuffer: TLogBuffer;
    function GetFileSizeStr(fileName: string): string;
  public
    constructor Create(logFileName: string);
    destructor Destroy; override;
    procedure writeWorkLog(str: string; const Level: integer = 0);           //0 提示 -1 错误 1 警告
    property LogMaxSize: Int64 read FMaxLogSize write FMaxLogSize;      // 日志文本最大值。
    property LogType: Integer read FLogType write FLogType;
  end;

  TAsynchronousLog = class(TMyLog)
  private
  public
    constructor Create(logFileName: string);
    destructor Destroy; override;
  end;

var
  Mylog: TMyLog;

implementation


{ TMyLog }

constructor TMyLog.Create(logFileName: string);
begin
  inherited Create();
  FLogBuffer := TLogBuffer.Create;
  InitializeCriticalSection(FCSLock);
  FlogFileName := logFileName;
  FLogType := 2;
  FMaxLogSize := 104857600;
end;

destructor TMyLog.Destroy;
begin
  TLogBuffer.Destroy;
  DeleteCriticalSection(FCSLock);
  inherited;
end;

function TMyLog.GetFileSizeStr(fileName: string): string;
var
  FileHandle: integer;
  nSize: Int64;
begin
  FileHandle := FileOpen(fileName, 0);
  nSize := GetFileSize(FileHandle, nil);
  if nSize > 1073741824 then
    Result := FormatFloat('###,##0.00G', nSize / 1073741824)
  else if nSize > 1048576 then
    Result := FormatFloat('###,##0.00M', nSize / 1048576)
  else if nSize > 1024 then
    Result := FormatFloat('###,##00K', nSize / 1024)
  else
    Result := FormatFloat('###,#0B', nSize);
  if Length(Result) > 2 then
    if Result[1] = '0' then
      Delete(Result, 1, 1);
  FileClose(FileHandle);
end;

procedure TMyLog.writeWorkLog(str: string; const Level: integer);
var
  filev: TextFile;
  ss, txt: string;
  FS: TFileStream;
  wTag: Boolean;
begin

  EnterCriticalSection(FCSLock);
  try
    wTag := False;
    FS := nil;
    if (FLogType = ALLLOG) then
    begin
      wTag := True;
    end
    else if (FLogType = INFOLOG) then
    begin
      if Level = HintLevel then
        wTag := True
      else
        wTag := False;
    end
    else if (FLogType = WARNLOG) then
    begin
      if Level = WarmLevel then
        wTag := True
      else
        wTag := False;
    end
    else if (FLogType = ERROELOG) then
    begin
      if Level = ErrorLevel then
        wTag := True
      else
        wTag := False;
    end;
  //
    if wTag then
    begin
      if Level = HintLevel then
      begin
        str := DateTimeToStr(Now) + ' Log: Hint ' + str;
      end
      else if (Level = WarmLevel) then
      begin
        str := DateTimeToStr(Now) + ' Log: Warming ' + str;
      end
      else if (ErrorLevel = -1) then
      begin
        str := DateTimeToStr(Now) + ' Log: Error ' + str;
      end;
      if FLogBuffer.BufferSize < FLogBuffer.MaxBuffer then
        FLogBuffer.AppendBuffer(str)
      else
      begin
        try
          ss := FlogFileName;
          if FileExists(ss) then
          begin
            FS := TFileStream.Create(FlogFileName, fmShareDenyNone);
            try
              AssignFile(filev, ss);
              append(filev);
              txt := FLogBuffer.Buf.DataString;
             // writeln(filev, str);
              Writeln(filev, txt);
             // Writeln(filev, FLogBuffer.Buf);
              if FS.Size > FMaxLogSize then
              begin
                DeleteFile(FlogFileName);
                ReWrite(filev);
              end;
            finally
              FS.Free;
            end;
          end
          else
          begin
            AssignFile(filev, ss);
            ReWrite(filev);
            writeln(filev, str);
          end;
        finally
          CloseFile(filev);
          FLogBuffer.ResetBuffer;
        end;

      end;

    end;
  finally
    LeaveCriticalSection(FCSLock);
  end;
end;

{ TLogBuffer }

procedure TLogBuffer.AppendBuffer(Data: string);
var
  buf: array of Char;
begin
  if FBuffer.Size < MaxBuffer then
    FBuffer.WriteString(Data + #13#10)
  else
    FBuffer.Clear;
end;

constructor TLogBuffer.Create;
begin
  FBuffer := TStringStream.Create;
  MaxBuffer := 1024 * 1;
end;

destructor TLogBuffer.Destroy;
begin
  FBuffer.Clear;
  FBuffer.Free;
  inherited;
end;

function TLogBuffer.GetBufferSize: int64;
begin
  Result := FBuffer.Size;
end;

procedure TLogBuffer.ResetBuffer;
begin
  FBuffer.Clear;
end;

procedure TLogBuffer.SetBufferSize(value: int64);
begin
  if value <> FMaxBufferSize then
  begin
    FMaxBufferSize := value;
    MaxBuffer := value;

  end;
end;

{ TAsynchronousLog }

constructor TAsynchronousLog.Create(logFileName: string);
begin
  inherited;

end;

destructor TAsynchronousLog.Destroy;
begin

  inherited;
end;

end.

