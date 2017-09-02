unit uRecord;

interface

uses
  Classes, Windows, DbOperate, uConst, oleacc, Variants, SysUtils, Messages,
  dyKeyMouseHook, config;

type
  TMyRecord = class
  private
    FDayDbObj: TDbObj;
    FError: TError;
    FBrowerList: TList;
    FMsaaPause: Boolean;
    function IsValueBrowser(const processName: string; var position: Integer): Boolean;
    function GetCurrentUrl(processHandle: Integer; aProcessName: string): string;
    function GetCurrentUrlNew(aPosition: Integer; aProcessRect: TRect): string;
    function GetUlrRect(processRect: TRect): TPoint;
    // 保存到数据库
    function AddInternerRecord(url: string): integer;
    procedure AddActiveRecord(Processname: string);
    function JudgeUseStatus(): Integer;         //判断用户活动键盘钩子
    procedure AddStarValueTagRecord(guid: string);
    procedure AddStopValueTagRecord(guid: string; valueTag: Integer);
  public
    constructor Create(dayDbObj: TDbObj);
    destructor Destroy();
    //采集记录
    function CollectActiveRecord(): integer;
    function CollectValueRecord(): integer;
  end;

var
  myRecord: TMyRecord;
  processCount: Integer; // 记录次数
  searchCount: Integer;
  Acc, accchild: IAccessible;
  VarParent: variant;
  res: hresult;
  guidS, classPath, lastrecordTime, lastUrlTime, lastRecordInfo, lasturl: string;
  valueTag: Boolean;

implementation


// mass

function max(a, b: integer): integer;
begin
  if a > b then
    result := a
  else
    result := b;
end;

function getAccstate(state: longint): string;
var
  n, i: longint;
  r: array[0..255] of char;
  s: string;
begin
  s := '';
  n := 1;
  for i := 1 to 29 do
  begin
    if state and n <> 0 then
    begin
      getstatetext(n, @r, 255);
      if s <> '' then
        s := s + ' -- ';
      s := s + r;
    end;
    n := n * 2;
  end;
  result := s;
end;

function getAccrole(role: longint): string;
var
  r: array[0..255] of char;
begin
  getroletext(role, @r, 255);
  result := r;
end;

function GetaccFocus(v: variant): string;
begin
  case vartype(v) of
    VarEmpty:
      result := 'Cet objet et ses enfants n''ont pas le focus clavier.';
    VarInteger:
      if v = CHILDID_SELF then
        result := 'Cet object lui-m阭e a le focus clavier.'
      else
        result := 'L''enfant num閞o ' + inttostr(v) + 'a le focus clavier.';
    VarDispatch:
      result := 'Un enfant a le focus clavier (IDispatch)';
  end;
end;

function GetaccSelection(v: variant): string;
begin
  case vartype(v) of
    VarEmpty:
      result := 'Cet objet ou ses enfants ne sont pas s閘ectionn閟.';
    VarInteger:
      if v = CHILDID_SELF then
        result := 'Cet object lui-m阭e est s閘ectionn?'
      else
        result := 'L''enfant num閞o ' + inttostr(v) + 'est s閘ectionn?';
    VarDispatch:
      result := 'Un enfant est s閘ectionn?(IDispatch)';
    VarUnknown:
      result := 'Plusieurs enfants sont s閘ectionn閟 (IEnumVARIANT)';
  end;
end;

function Getpropriete(Prop: integer; acc: IAccessible; varID: variant): string;
var
  str: pwidechar;
  n: longint;
  v: variant;
begin
  case Prop of
    DISPID_ACC_NAME:
      res := acc.get_accName(varID, str);
    DISPID_ACC_VALUE:
      res := acc.get_accValue(varID, str);
    DISPID_ACC_DESCRIPTION:
      res := acc.get_accDescription(varID, str);
    DISPID_ACC_ROLE:
      res := acc.get_accRole(varID, v);
    DISPID_ACC_STATE:
      res := acc.get_accState(varID, v);
    DISPID_ACC_HELP:
      res := acc.get_accHelp(varID, str);
    DISPID_ACC_HELPTOPIC:
      res := acc.get_accHelpTopic(str, varID, n);
    DISPID_ACC_KEYBOARDSHORTCUT:
      res := acc.get_accKeyboardShortcut(varID, str);
    DISPID_ACC_FOCUS:
      res := acc.get_accFocus(v);
    DISPID_ACC_SELECTION:
      res := acc.get_accSelection(v);
    DISPID_ACC_DEFAULTACTION:
      res := acc.get_accDefaultAction(varID, str);
  end;
  case res of
    S_OK:
      case Prop of
        DISPID_ACC_NAME, DISPID_ACC_VALUE, DISPID_ACC_DESCRIPTION, DISPID_ACC_HELP, DISPID_ACC_HELPTOPIC, DISPID_ACC_KEYBOARDSHORTCUT, DISPID_ACC_DEFAULTACTION:
          result := str;
        DISPID_ACC_ROLE:
          result := getaccrole(v);
        DISPID_ACC_STATE:
          result := getaccstate(v);
        DISPID_ACC_FOCUS:
          result := GetAccFocus(v);
        DISPID_ACC_SELECTION:
          result := GetaccSelection(v);
      end;
    S_FALSE:
    //  result := 'Vide [FALSE]';
      Result := '';
    E_INVALIDARG:
    //  result := 'Erreur Argument';
      result := '';
    DISP_E_MEMBERNOTFOUND:
    //  result := 'l''objet ne supporte pas cette propri閠?;
      result := '';
  else
    result := 'Erreur inconnue';
  end;
end;

function GetName(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_NAME, acc, varID);
end;

function GetValue(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_VALUE, acc, varID);
end;

function GetDescription(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_DESCRIPTION, acc, varID);
end;

function GetRole(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_ROLE, acc, varID);
end;

function GetState(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_STATE, acc, varID);
end;

function GetHelp(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_HELP, acc, varID);
end;

function GetHelpTopic(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_HELPTOPIC, acc, varID);
end;

function GetKeyShortCut(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_KEYBOARDSHORTCUT, acc, varID);
end;

function GetFocus(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_FOCUS, acc, varID);
end;

function GetSelection(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_SELECTION, acc, varID);
end;

function GetDefaultAction(acc: IAccessible; varID: variant): string;
begin
  result := Getpropriete(DISPID_ACC_DEFAULTACTION, acc, varID);
end;
{ TMyRecord }

function TMyRecord.IsValueBrowser(const processName: string; var position: Integer): Boolean;
var
  I, len: Integer;   // loops thru known protocols
  Protocols: array of string;
  PBrowser: ^TBrowser;
begin
  Result := False;
  len := FBrowerList.Count;
  SetLength(Protocols, len);
  for I := 0 to len - 1 do
  begin
    PBrowser := FBrowerList.Items[I];
    Protocols[I] := PBrowser.browserName;
  end;
  for I := Low(Protocols) to High(Protocols) do
    if Pos(Protocols[I], SysUtils.LowerCase(processName)) = 1 then
    begin
      position := I;
      Result := True;
      Exit;
    end;
end;

function TMyRecord.GetUlrRect(processRect: TRect): TPoint;
var
  url: string;
  tmrect: TRect;
  x, y, w, h, i: longint;
  pt: TPoint;
  theight: Integer;
begin
  tmrect.left := processRect.Left;
  tmrect.top := processRect.Top;
  pt.X := processRect.Left;
  pt.y := processRect.Top;
  theight := processRect.Top + (processRect.Bottom - processRect.Top) div 6;
  while not IsValidURLProtocol(url) do
  begin
    if (tmrect.top > theight) then
    begin
      Result.x := -1;
      Result.y := -1;
      exit;
    end;
    try
      res := AccessibleObjectFrompoint(pt, @acc, VarParent);
    except
      url := '';
    end;
    if res <> S_OK then
      Continue;
    try
      url := getvalue(acc, VarParent);
      if tmrect.Left < processRect.Right then
      begin
        tmrect.Left := tmrect.Left + 20;
      end
      else
      begin
        if tmrect.top < theight then
        begin
          tmrect.top := tmrect.top + 10;
          tmrect.Left := processRect.Left;
        end;
      end;
      pt.X := tmrect.left;
      pt.y := tmrect.top;
    except
      url := '';
    end;

  end;
  Result.x := pt.X;
  Result.y := pt.Y;
end;

function TMyRecord.CollectActiveRecord: integer;
var
  activeFormHandle: HWND;
  buf: array[Byte] of Char;
  dwProcessID: DWORD;
  processName: ^string;
  Caption, temps, aProcessName: string;
  sonhandle: HWND;
  ps: array[0..254] of Char;
  timeout: Integer;
  proStatus: Cardinal;
  error, count: Integer;
  tempActiveProcess: ^TProcessMsg;
  statTime: TDateTime;
  activeFormRect: TRect;
  tpt: tpoint;
  res: hresult;
  curentUrl: string;
  postition: Integer;
begin
  postition := 0;
  activeFormHandle := GetForegroundWindow;
  GetWindowRect(activeFormHandle, activeFormRect);
  proStatus := 0;
  GetWindowText(activeFormHandle, buf, SizeOf(buf));
  if buf <> '' then
  begin
    GetWindowThreadProcessId(activeFormHandle, dwProcessID);
    aProcessName := GetPidtoName(dwProcessID);
    inc(processCount);
    if processCount > 500 then
    begin
      processCount := 1;
      FDayDbObj.Commit_Sqlite;
      FDayDbObj.BeginTans_Sqlite;
    end;
    if IsValueBrowser(aProcessName, postition) then
    begin

      //浏览器处理
      curentUrl := GetCurrentUrlNew(postition, activeFormRect);
     // curentUrl := GetCurrentUrl(activeFormHandle, aProcessName);
      if curentUrl <> '' then
      begin
        AddInternerRecord(curentUrl);
       // curentUrl1 := curentUrl;
      end;
    end;
    AddActiveRecord(aProcessName);
  end;
  result := 0;
end;

function TMyRecord.CollectValueRecord: integer;
var
  UserInfo: Integer;
begin
  valueTag := false;
  UserInfo := 0;
  UserInfo := JudgeUseStatus;
  if guidS <> '' then
  begin
    SetShareCount;
    AddStopValueTagRecord(guidS, UserInfo);
    guidS := '';

  end;
  guidS := GetGUID();                                                            //获得guid
  AddStarValueTagRecord(guidS);
end;

function TMyRecord.GetCurrentUrl(processHandle: Integer; aProcessName: string): string;
var
  res: hresult;
  url: string;
  tpt: tpoint;
  activeFormRect: TRect;
  tWidth: Integer;
begin
  url := '';
  GetWindowRect(processHandle, activeFormRect);
  //谷歌
  if aProcessName = 'chrome.exe' then
  begin
    tpt.X := activeFormRect.Left + 160;
    tpt.y := activeFormRect.Top + 54;
  end
  // 火狐
  else if (aProcessName = 'firefox.exe') then
  begin
    tWidth := (activeFormRect.Right - activeFormRect.Left) div 3 - 10;
    tpt.X := activeFormRect.Left + tWidth;
    tpt.y := activeFormRect.Top + 58;
  end
  //ie
  else if (aProcessName = 'iexplore.exe') then
  begin
    tpt.X := activeFormRect.Left + 105;
    tpt.y := activeFormRect.Top + 31;
  end
  else
  begin
    Exit;
  end;
  res := AccessibleObjectFrompoint(tpt, @acc, VarParent);
  if res <> S_OK then
    exit;
  url := getvalue(acc, VarParent);
  if IsValidURLProtocol(url) then
  begin

  end;

  Result := url;
end;

function TMyRecord.GetCurrentUrlNew(aPosition: Integer; aProcessRect: TRect): string;
var
  res: hresult;
  url: string;
  tpt: tpoint;
  activeFormRect: TRect;
  tWidth: Integer;
  ptBrowser: PBrowser;
begin
  ptBrowser := FBrowerList.Items[aPosition];
  if PBrowser(FBrowerList.Items[aPosition]).status = 1 then
  begin
    tpt.X := aProcessRect.Left + PBrowser(FBrowerList.Items[aPosition]).bPt.x;
    tpt.y := aProcessRect.Top + PBrowser(FBrowerList.Items[aPosition]).bPt.y;
  end
  else if PBrowser(FBrowerList.Items[aPosition]).status = 0 then
  begin
    tpt := GetUlrRect(aProcessRect);
    if tpt.X = -1 then
    begin
      PBrowser(FBrowerList.Items[aPosition]).status := -1;
      url := '';
      //log
      Exit;
    end;
    PBrowser(FBrowerList.Items[aPosition]).bPt.x := tpt.X - aProcessRect.Left;
    PBrowser(FBrowerList.Items[aPosition]).bPt.y := tpt.y - aProcessRect.Top;
  end
  else
  begin
    url := '';
    if searchCount > 120 then
    begin
      PBrowser(FBrowerList.Items[aPosition]).status := 0;
      searchCount := 0;
    end;

    inc(searchCount);

    Exit;
  end;
  res := AccessibleObjectFrompoint(tpt, @acc, VarParent);
  if res <> S_OK then
    exit;
  url := getvalue(acc, VarParent);
  {if not IsValidURLProtocol(url) then
  if ChecekUrl(url) then
  begin
    PBrowser(FBrowerList.Items[aPosition]).status := 0;
  end;
   }
  Result := url;
end;

function TMyRecord.JudgeUseStatus: Integer;
var
  i, count: Integer;
  myMsg: Integer;
  key: Char;
  ps: TPoint;
begin
  //鼠标钩子
  valueTag := False;
  Result := -1;
  count := GetMouseCount - 1;
  for i := 0 to count do
  begin
    ps.X := GetMouse(i).pt.x;
    ps.Y := GetMouse(i).pt.y;
    myMsg := GetMessageMsg(i);
    case myMsg of
      WM_LBUTTONDOWN:
        begin
          Result := myMsg;
          valueTag := True;

          Exit;
        end;
      WM_LBUTTONDBLCLK:
        begin
          valueTag := True;
          Result := myMsg;

          Exit;
        end;
      WM_RBUTTONDOWN:
        begin
          valueTag := True;
          Result := myMsg;

          Exit;
        end;
      WM_RBUTTONDBLCLK:
        begin
          valueTag := True;
          Result := myMsg;

          Exit;
        end;
      WM_MBUTTONDOWN:
        begin
          valueTag := True;
          Result := myMsg;

        end;
      WM_MBUTTONDBLCLK:
        begin
          valueTag := True;
          Result := myMsg;

          Exit;
        end;
      //滚轮
      WM_MOUSEWHEEL:
        begin
          valueTag := True;
          Result := myMsg;
          Exit;
        end;
    end;
  end;
  count := GetKeyCount - 1;
  for i := 0 to count do
  begin
    key := GetKey(i);
    if key <> '' then
    begin
      valueTag := True;
      Result := 2;
      Exit;
    end;
  end;

end;

function TMyRecord.AddInternerRecord(url: string): integer;
const
  fmtInsert = 'INSERT INTO internet_record (''url'',''record_time'' ) VALUES(''%s'',''%s'')';
var
  sqlS: string;
  error: Integer;
  starT, cost: Integer;
  tTime: string;
begin
  tTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', now);
  begin
    sqlS := Format(fmtInsert, [AnsiToUtf8(url), tTime]);
    try
      starT := GetTickCount;
      error := FDayDbObj.ExcuteSql_Sqlite(sqlS);
      cost := GetTickCount - starT;
    except

    end;
  end;
end;

procedure TMyRecord.AddStarValueTagRecord(guid: string);
const
  fmtInsert = 'INSERT INTO valuetime_record (''guids'',''star_time'' ) VALUES(''%s'',''%s'')';
var
  s: string;
  tTime: string;
begin
  tTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', now);
  s := Format(fmtInsert, [guid, tTime]);
  try
    FDayDbObj.ExcuteSql_Sqlite(s);
  except
  end;
end;

procedure TMyRecord.AddStopValueTagRecord(guid: string; valueTag: Integer);
const
  fmtInsert = 'INSERT INTO pc_process_record (''action_process'',''record_time'' ) VALUES(''%s'',''%s'')';
var
  sqlS: string;
  error: Integer;
  tTime: string;
begin
  tTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', now);
  sqlS := 'update valuetime_record set stop_time =''' + tTime + ''', value_tag = ' + IntToStr(valueTag) + ' where guids =''' + guid + '''';
  try
    error := FDayDbObj.ExcuteSql_Sqlite(sqlS);
  except
   // Mylog.writeWorkLog(Format('pc_process_record数据库插入失败，进程名：%s, sql：%s, 错误代码：%d ', [Processname, sqlS, error]), -1);
  end;
end;

procedure TMyRecord.AddActiveRecord(Processname: string);
const
  fmtInsert = 'INSERT INTO pc_process_record (''action_process'',''record_time'' ) VALUES(''%s'',''%s'')';
var
  sqlS: string;
  error: Integer;
  starT, cost: Integer;
  tTime: string;
begin
  tTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', now);
  sqlS := Format(fmtInsert, [Processname, tTime]);
  try
    starT := GetTickCount;
    error := FDayDbObj.ExcuteSql_Sqlite(sqlS);
    cost := GetTickCount - starT;
  except
     // Mylog.writeWorkLog(Format('pc_process_record数据库执行失败，进程名：%s, sql：%s, 错误代码：%d ', [Processname, sqlS, error]), -1);
  end;
end;

constructor TMyRecord.Create(dayDbObj: TDbObj);
var
  PBrowserInfo: ^TBrowser;
begin
  FDayDbObj := dayDbObj;
  FBrowerList := TList.Create;
  New(PBrowserInfo);
  PBrowserInfo.browserName := 'chrome.exe';
  PBrowserInfo.bPt.x := 160;
  PBrowserInfo.bPt.y := 54;
  PBrowserInfo.status := 1;
  FBrowerList.Add(PBrowserInfo);
  New(PBrowserInfo);
  PBrowserInfo.browserName := 'firefox.exe';
  PBrowserInfo.bPt.x := 0;
  PBrowserInfo.bPt.y := 0;
  PBrowserInfo.status := 0;
  FBrowerList.Add(PBrowserInfo);
  New(PBrowserInfo);
  PBrowserInfo.browserName := 'iexplore.exe';
  PBrowserInfo.bPt.x := 140;
  PBrowserInfo.bPt.y := 40;
  PBrowserInfo.status := 1;
  FBrowerList.Add(PBrowserInfo);
  searchCount := 0;
end;

destructor TMyRecord.Destroy;
begin
  FBrowerList.Clear;
  FBrowerList.Free;
end;

end.

