﻿unit uTask;

interface

uses
  Windows, Messages, ExtCtrls, SysUtils, Menus, StdCtrls, Classes, Controls,
  Graphics, Forms, Dialogs, ShellAPI, TLHelp32, DbOperate, config, Variants,
  dyKeyMouseHook, RdpCrypt, uConst, qworker, uRecord, system.json, FireDAC.Comp.Client;

type
  TTask = class
  private
    aMainHandle: Thandle;
    FError: TError;     // 错误码
    FCheckTag: Boolean; //复查标志 1 复查  非1 不复查
    dayRecordDbPath, planTaskDbPath, mangerDbPath, classPath, rulePath: string;        //数据库路径
    FhistoryUpdate, FBookmarksUpdate, FPasswordUpdate, FUploadServer: TDateTime;    //TaskTime
    myborwerInfo: TBrowerInfo;       //borwerinfo
    tempDir: string;          //临时文件目录
    templatesDir: string;     //模板文件目录
    cost, star: Integer;
    taskCount: Integer;                    //  任务数
    FTaskList: TList;                  // 任务队列
    function InitHook(): TError;  // 初始化钩子
    function EveryDayCheckTask(): Integer;   //每日任务检查
    function InsertDayTb_Sqlite(managerDbPath: string): TError;     //manager.db 数据库索引
    function CheckFileOrDir(appDir: string): TError;      // 检查程序 依赖项。
    function EveryDayTaskInit(): TError;
    function GetBrowerPath(var myborwerInfo: TBrowerInfo): Integer;    //获取浏览器路径
    function BookmarkSynchronize(bookmarkPath: string): Integer;      //同步书签
    function PasswordSynchronize(passwordPath: string): Integer;      //同步密码
    function HighistorySynchronize(historyPath: string): Integer;     //同步历史记录
    function Bookmarkurl(s: string; folder: string): Integer;
    function FindSonJs(s: string; folder: string): Integer;
    function SetTaskInfo(taskInfo: TTaskInfo): Integer;
    // 任务
    function GearmanTask(taskInfo: PTaskInfo): TError;  //分配任务处理者
    function TaskManager(): TError;   // 任务管理
    procedure ManagerTask(AJob: PQJob);
    //活动记录
    procedure ActiveRecord(AJob: PQJob);     //采集活动记录_PC
    procedure ValueRecord(AJob: PQJob);     // 采集有效记录_pc
    procedure StatisticsTask(AJob: PQJob);     // 统计recordTask
    procedure UploadClassTask(AJob: PQJob);   //上传classTask
    function StatisticsRecord: Integer;
    function UploadClass: Integer;
    function ClearTaskList: Integer;
    function CheckSameStringList(item: string; chekcStringlist: TStringList): Boolean;
    function SwitchDaySqlite(day: string): Integer;   //更新每日数据库地址
    procedure SwitchayTask();       // 更新任务。
    procedure ClearList();

    // 视图
  public
    constructor Create(mainHandle: Thandle);
    destructor Destory;
    procedure ClearError();
    function GetLastError(): TError;
    function RecordTask(activeProInterval: Integer; valueInterval: Integer): TError;     // 记录活动。
    function SetEveryDay(): TError;   // 设置每日任务。
    //任务
    function CheckYesterdayTaskInfo(): TError; //检查昨日任务
    function GetTaskInfo(): Integer; // 获取任务-数据库
    function EditAllRunTask_Sqlite(): Integer;
    function AddTask(taskInfo: TTaskInfo): Integer;                 //添加任务
    function DeleteTask(taskInfo: TTaskInfo): Integer;              // 删除任务
    function EditTask(taskInfo: TTaskInfo): Integer;               // 标记任务
    function DisableWorkers(): Integer; //禁止所有工作者。
    function EnableWorkers(): Integer; //启用工作者
    //browse 浏览器
    function GetTotalTimeTask(var timeTaskList: TTaskInfoArr): Integer;
    procedure TimerTaskBookmarks();          //书签同步_PC  谷歌  ie
    procedure TimerTaskPassword();          //密码任务_PC  同步 谷歌 ie
    //统计
    procedure GetClassRecord(startime, endtime: Double; var RecordList: TList);
    procedure CloseConnect();
    procedure OpenConnect();
    function GetProcessList(reInfo: TArrRecordtyInfo): TStringList;
    function GetProcessListType(reInfo: TArrRecordtyInfo): TArrRecordInfo;
    function CheckSameRecord(sRecordList: TStringList; itemName: string; var postion: Integer): Boolean;
    function ExPortActiveRecord(recordStarTime: string; recordEndTime: string; ExPortFileType: string): Integer; //导入活动记录 格式
    function GetDayActiveRecord(recordStarTime: string; recordEndTime: string; var recordInfoArr: TArrRecordInfo): Integer; //获取活动记录显示
    function SetAllItmeType(): Integer;
    function SetItemType(itemName: string; itemType: string; itemContent: string; classname: string): Integer;    //设置记录类型
    function QueryClassItem(itemName: string): TClassType;
  //  function GetActivetyInfo(dbPath: string; var activeTyInfo: TArrActiveTyInfo; starTime: string; endTime: string): Integer;
    function UpdatePlanTaskTime(): Integer;
    function IsValueBrowser(const processName: string): Boolean;
    function GetActiveRecord(recordStarTime: string; recordEndTime: string; var recordInfoArr: TArrRecordtyInfo; RecordMode: Integer; FilterWord: string): Integer;
    function GetActiveRecordClass(recordStarTime: string; recordEndTime: string; var reInfo: TArrRecordtyInfo): Integer;
    function GetActiveRecordClass1(recordStarTime: string; recordEndTime: string; var classRecord: TArrRecordType; var reInfo: TArrRecordtyInfo): Integer;
    function GetUlrRecord(recordStarTime: string; recordEndTime: string; var recordInfoArr: TArrRecordtyInfo): Integer;
    function JuageRecordClass(urlApp: string; classRecord: TArrRecordType): Integer;
  end;

var
  myTask: TTask;
  myTaskDb, ttDbObj: TDbObj;
  tCount, processCount, FCheckCount: Integer;

implementation

uses
  Log, recordVierFrm;


// TTask
constructor TTask.Create(mainHandle: Thandle);
var
  errorS: string;
begin
  aMainHandle := mainHandle;
  valueTag := False;
  FCheckTag := True;
  gMm := Tconfig.Create;
  Mylog := TMyLog.Create(gMm.AppDir + '\record.log');
  myAsynchronousLog := TAsynchronousLog.Create(gMm.AppDir + '\record.log');
 // myAsynchronousLog.StopLog;
  Mylog.LogType := gMm.logType;
  mylog.writeWorkLog('*********************************************', INFOLOG);
  mylog.writeWorkLog('时间管理器开始运行，当前版本1.0.0.1', INFOLOG);

  myTaskDb := TDbObj.Create;
  FTaskList := TList.Create;
  //RegisterAutoStart('时间管理', Application.ExeName);
  //检查文件/目录 dll完整性
  mylog.writeWorkLog('正在检查程序文件， dll完整性', INFOLOG);
  FError := CheckFileOrDir(gMm.appdir);
  if FError.errorCode <> 0 then
  begin
    errorS := Format('缺失必要文件，程序被终止，reason %s ,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, FATALLOG);
    Exit;
  end;
  //钩子
  mylog.writeWorkLog(' 初始化钩子模块', INFOLOG);
  FError := InitHook;
  if FError.errorCode <> 0 then
  begin
    errorS := Format('初始化钩子模块失败，程序被终止: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, FATALLOG);
    Exit;
  end;
  myRecord := TMyRecord.Create(dayRecordDbPath);
  //sqlite
  ttDbObj := TDbObj.Create;
  ttDbObj.OpenDb(classPath, 'SQLite', '');
  myTaskDb.OpenDb(planTaskDbPath, 'SQLite');
  //每日任务检查
  mylog.writeWorkLog(' 开始检查每日任务表', INFOLOG);
  CheckYesterdayTaskInfo;
  if FError.errorCode < 0 then
  begin
    errorS := Format('检查每日任务失败: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
  end;
  Workers.MaxWorkers := 100;
  mylog.writeWorkLog('开启记录器', INFOLOG);
  TaskManager;
  if FError.errorCode < 0 then
  begin
    errorS := Format('开启记录器失败: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, FATALLOG);
    Exit;
  end;
  FError.errorCode := 0;
 // Mylog.LogType := ERRORLOG;
 // Workers.DisableWorkers;
end;

function TTask.DeleteTask(taskInfo: TTaskInfo): Integer;
begin
  Result := 0;
end;

destructor TTask.Destory;
begin
  myAsynchronousLog.Free;
  Mylog.free;
  Workers.Clear;
  EditAllRunTask_Sqlite;
  ClearList;
  FTaskList.Free;
  gMm.Free;
  CloseGetKeyHook;
  DisableKeyHook;
  ttDbObj.Free;
  myTaskDb.Commit;
  myTaskDb.Free;
  myRecord.Destroy;

end;

function TTask.DisableWorkers: Integer;
begin
  Workers.DisableWorkers;
  Result := 0;
end;

function TTask.EditAllRunTask_Sqlite: Integer;
var
  i, Len: Integer;
  tmTaskInfo: TTaskInfo;
begin
  Len := FTaskList.Count;
  for i := 0 to Len - 1 do
  begin
    tmTaskInfo := PTaskInfo(FTaskList.Items[i])^;
    EditTask(tmTaskInfo);
  end;
  Result := 0;
end;

function TTask.EditTask(taskInfo: TTaskInfo): Integer;
const
  fmtUpt = 'update task_trigger set triggerDevice=''%s'',triggerCondition = ''%s'',triggerCount =%d  where id = %d';
  fmtUpt1 = 'update task_Exe set taskExeCount = %d, taskExe=''%s'',taskCost= %f where id = %d';
  fmtUpt2 = 'update task_info set taskTitle = ''%s'', taskContent=''%s'', taskStatus=%d, taskType=''%s'',taskTime=''%s'' ,tasklastUpdate = ''%s'' where id = %d';
var
  sql, errorS: string;
begin
  // 更新数据库。
  // task_info
  sql := Format(fmtUpt2, [(taskInfo.taskTitle), (taskInfo.taskContent), taskInfo.taskStatus, taskInfo.taskType, taskInfo.taskCreatime, taskInfo.lastUpdate, taskInfo.id]);
  myTaskDb.ExcuteSql(sql);
  FError := myTaskDb.GetLastError;
  if FError.errorCode < 0 then
  begin
    FError.errorMsg := Format('sql执行失败: %s', [sql]);
    errorS := Format('update task_info  fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
  end;
  // task_trigger
  sql := Format(fmtUpt, [taskInfo.taskConditions.triggerDevice, taskInfo.taskConditions.triggerCondition, taskInfo.taskConditions.triggerCount, taskInfo.id]);
  myTaskDb.ExcuteSql(sql);
  FError := myTaskDb.GetLastError;
  if FError.errorCode < 0 then
  begin
    FError.errorMsg := Format('sql执行失败: %s', [sql]);
    errorS := Format('update task_info  fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
  end;
  // task_Exe
  sql := Format(fmtUpt1, [taskInfo.taskExecute.taskCount, taskInfo.taskExecute.taskExe, taskInfo.taskExecute.taskCost, taskInfo.id]);
  myTaskDb.ExcuteSql(sql);
  FError := myTaskDb.GetLastError;
  if FError.errorCode < 0 then
  begin
    FError.errorMsg := Format('sql执行失败: %s', [sql]);
    errorS := Format('update task_info  fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
  end;
  Result := 0;
end;

function TTask.EnableWorkers: Integer;
begin
  Workers.EnableWorkers;
  Result := 0;
end;

function TTask.ExPortActiveRecord(recordStarTime, recordEndTime, ExPortFileType: string): Integer;
begin
  Result := 0;
end;

procedure TTask.ManagerTask(AJob: PQJob);
var
  i, len: Integer;
begin
  GetTaskInfo;
  len := FTaskList.Count;
  for i := 0 to len - 1 do
  begin
    if PTaskInfo(FTaskList.Items[i]).taskhandle = 1 then
      GearmanTask(FTaskList.Items[i])
    else
    begin
       // dispose(tptaskInfo);
    end;
  end;
end;

procedure TTask.OpenConnect;
begin
  myTaskDb.OpenConnect;
  ttDbObj.OpenConnect;
  myRecord.OpenConnect;
end;

function TTask.TaskManager(): TError;
var
  star, cost, stop: Integer;
  i, len: Integer;
begin
  GetTaskInfo;
  len := FTaskList.Count;
  for i := 0 to len - 1 do
  begin
    if PTaskInfo(FTaskList.Items[i]).taskhandle = 1 then
      GearmanTask(FTaskList.Items[i])
    else
    begin
       // dispose(tptaskInfo);
    end;
  end;
  Exit;
  star := GetTickCount;
  Workers.Post(ManagerTask, 20 * Q1Second, nil);
  cost := GetTickCount - star;
end;

procedure TTask.TimerTaskBookmarks();
begin
  BookmarkSynchronize(tempDir + '\bookmarks');
end;

procedure TTask.TimerTaskPassword();
begin
  PasswordSynchronize(tempDir + '\password.db');
end;

function TTask.UpdatePlanTaskTime: Integer;
const
  fmtUpt = 'update task_info set tasklastUpdate = ''%s''  where id = %d';
var
  sql: string;
  error: Integer;
  sNow: string;
begin
  myTaskDb.OpenDb(planTaskDbPath, 'SQLite');
  sNow := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  sql := Format(fmtUpt, [sNow, 1]);
  try
    myTaskDb.ExcuteSql(sql);
  except
    //Mylog.writeWorkLog(Format('pc_process_record数据库插入失败，进程名：%s, sql：%s, 错误代码：%d ', [Processname, sqlS, error]), -1);
  end;
  sql := Format(fmtUpt, [sNow, 2]);
  try
    myTaskDb.ExcuteSql(sql);
  except
   // Mylog.writeWorkLog(Format('pc_process_record数据库插入失败，进程名：%s, sql：%s, 错误代码：%d ', [Processname, sqlS, error]), -1);
  end;
end;

function TTask.UploadClass: Integer;
begin

end;

procedure TTask.UploadClassTask(AJob: PQJob);
begin

end;

procedure TTask.ValueRecord(AJob: PQJob);
const
  fmtUpt = 'update task_trigger set triggerCount = %d where id = %d';
  fmtUpt1 = 'update task_Exe set taskExeCount = %d where id = %d';
var
  errorS: string;
begin
 // 触发时。
  Mylog.writeWorkLog('无人值守判断' + inttostr(PTaskInfo(AJob.Data).taskConditions.triggerCount));
  Inc(PTaskInfo(AJob.Data).taskConditions.triggerCount);
  myRecord.CollectValueRecord;
  //执行后
  if FError.errorCode < 0 then
  begin
    errorS := Format('collect pcrecord task fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
  end;
  Inc(PTaskInfo(AJob.Data).taskExecute.taskCount);

end;

procedure ShowString(Ajob: PQjOb);
begin
  OutputDebugString(PChar(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)));
end;

function TTask.GetTaskInfo(): Integer;
var
  sqlS, nowD, errorS: string;
  I, Len: Integer;
  tlb, ttlb, tmtlb: TFDMemTable;
  FPTaskInfo: PTaskInfo;
begin

  try
  // //sql  task_info
    nowD := FormatDateTime('YYYY-MM-DD 00:00:00', Now);
    sqlS := ' select * from task_info where task_info.taskStatus = 0   and tasklastUpdate>=''' + nowD + '''';
    tlb := myTaskDb.querysql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('任务表planTask.db执行sql %s失败,errorcode %d', [sqlS, FError.errorCode]);
      Mylog.writeWorkLog(errorS, ERROELOG);
      Exit;
    end;
    Len := tlb.SourceView.Rows.Count;
    for I := 0 to Len - 1 do
    begin
      if I < FTaskList.Count then
      begin
        if PTaskInfo(FTaskList.Items[I]).taskhandle <> 0 then
          Continue;
      end;
      New(FPTaskInfo);
      FPTaskInfo.id := tlb.FieldByName('id').AsInteger;
      FPTaskInfo.taskTitle := tlb.FieldByName('taskTitle').AsString;
      FPTaskInfo.taskContent := tlb.FieldByName('taskContent').AsString;
      FPTaskInfo.taskType := tlb.FieldByName('taskType').AsString;
      FPTaskInfo.taskCreatime := tlb.FieldByName('taskTime').AsString;
      FPTaskInfo.lastUpdate := tlb.FieldByName('tasklastUpdate').AsString;
      FPTaskInfo.taskStatus := tlb.FieldByName('taskStatus').AsInteger;
      tlb.Next;
     //sql  task_trigger
      sqlS := ' select * from task_trigger where id = ' + IntToStr(FPTaskInfo.id) + ' limit 0,1';
      ttlb := myTaskDb.QuerySql(sqlS);
      FError.errorCode := SUS_QUERY;
      if FError.errorCode <> SUS_QUERY then
      begin
        errorS := Format('task_trigger 执行sql %s失败', [sqlS]);
        Mylog.writeWorkLog(errorS, ERROELOG);
        Exit;
      end;
      if ttlb.SourceView.Rows.Count <= 0 then
      begin
        errorS := Format('task_trigger 执行sql %s失败', [sqlS]);
        Mylog.writeWorkLog(errorS, ERROELOG);
        Exit;
      end;
      FPTaskInfo.taskConditions.triggerDevice := ttlb.FieldByName('triggerDevice').AsString;
      FPTaskInfo.taskConditions.triggerCondition := ttlb.FieldByName('triggerCondition').AsString;
      FPTaskInfo.taskConditions.triggerCount := StrToInt(ttlb.FieldByName('triggerCount').AsString);
      ttlb.Free;
    //sql  task_Exe
      sqlS := ' select * from task_Exe where id = ' + IntToStr(FPTaskInfo.id) + ' limit 0,1';
      tmtlb := myTaskDb.QuerySql(sqlS);
      FError.errorCode := SUS_QUERY;
      if FError.errorCode <> SUS_QUERY then
      begin
        errorS := Format('task_Exe执行sql %s失败', [sqlS]);
        Mylog.writeWorkLog(errorS, ERROELOG);
        Exit;
      end;
      if tmtlb.SourceView.Rows.Count <= 0 then
      begin
        errorS := Format('task_Exe执行sql %s失败', [sqlS]);
        Mylog.writeWorkLog(errorS, ERROELOG);

        Exit;
      end;
      FPTaskInfo.taskExecute.taskExe := tmtlb.FieldByName('taskExe').AsString;
      FPTaskInfo.taskExecute.taskCost := tmtlb.FieldByName('taskCost').AsFloat;
      FPTaskInfo.taskExecute.taskCount := tmtlb.FieldByName('taskExeCount').AsInteger;
      tmtlb.Free;
      FPTaskInfo.taskhandle := 1;
      FTaskList.Add(FPTaskInfo);
    end;
  finally
    tlb.free;
  end;

end;

function TTask.GetTotalTimeTask(var timeTaskList: TTaskInfoArr): Integer;
const
  fmtInsert = 'INSERT OR IGNORE INTO  day_task (''taskname'',''taskType'',''taskRemarks'',''taskTime'' ,''taskStatus'' ) VALUES(''%s'',''%s'',''%s'',''%s'',0)';
begin

end;

function TTask.GetUlrRecord(recordStarTime, recordEndTime: string; var recordInfoArr: TArrRecordtyInfo): Integer;
var
  dayObj, classObj: TDbObj;
  dayDbPath, sql, tsql: string;
  dTlb, classTlb: TFDMemTable;
  len, i: Integer;
  sError: string;
begin
  dayObj := TDbObj.Create;
  classObj := TDbObj.Create;
  try
    classObj.OpenDb(classPath, 'SQLite');
  //day
    dayDbPath := dayRecordDbPath;
    dayObj.OpenDb(dayDbPath, 'SQLite');

    sql := 'select  * from  internet_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + '''';
    try
      dTlb := dayObj.QuerySql(sql);
    except
      sError := format('查询记录失败，错误代码%d, sql%s,', [FError.errorCode, sql]);
      Mylog.writeWorkLog(sError, ERROELOG);
      Exit;
    end;
    len := dTlb.SourceView.Rows.Count;
    SetLength(recordInfoArr, len);
    for i := 0 to len - 1 do
    begin
      if (dTlb.FieldByName('url').AsString <> '') and (dTlb.FieldByName('url_title').AsString <> '') and (dTlb.FieldByName('record_startime').AsString <> '') and (dTlb.FieldByName('record_endtime').AsString <> '') then
      begin
        recordInfoArr[i].recordName := dTlb.FieldByName('url').AsString;
        recordInfoArr[i].recordTitle := dTlb.FieldByName('url_title').AsString;
        try
          recordInfoArr[i].starTime := VarToDateTime(dTlb.FieldByName('record_startime').AsString);
          recordInfoArr[i].endTime := VarToDateTime(dTlb.FieldByName('record_endtime').AsString);
        except
          sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [dTlb.FieldByName('record_startime').AsString, dTlb.FieldByName('record_endtime').AsString]);
          Mylog.writeWorkLog(sError, ERROELOG);
          recordInfoArr[i].starTime := 0;
          recordInfoArr[i].endTime := 0;
        end;
      end
      else
      begin
        SetLength(recordInfoArr, len - 1);
        Continue;
      end;
      recordInfoArr[i].costTime := recordInfoArr[i].endTime - recordInfoArr[i].starTime;
      if recordInfoArr[i].costTime = 0 then
      begin
        sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [dTlb.FieldByName('record_startime').AsString, dTlb.FieldByName('record_endtime').AsString]);
        Mylog.writeWorkLog(sError, ERROELOG);
      end;
      dTlb.Next;
    end;
    Exit;
    tsql := '';
    try
      classTlb := classObj.QuerySql(sql);
    except
      Exit;
    end;
  finally
    dTlb.free;
    dayObj.Free;
    classObj.Free;
  end;

end;

procedure TTask.ActiveRecord(AJob: PQJob);
const
  fmtUpt = 'update task_trigger set triggerCount = %d where id = %d';
  fmtUpt1 = 'update task_Exe set taskExeCount = %d where id = %d';
var
  JobInfo: tTaskInfo;
  count: integer;
  sql, errorS, tTime, sDayPath: string;
begin
  count := PTaskInfo(AJob.Data).taskConditions.triggerCount;
  Mylog.writeWorkLog('*****第' + inttostr(count) + '次开始获取活动记录***** ');
  Inc(PTaskInfo(AJob.Data).taskConditions.triggerCount);
  AJob.Worker.ComNeeded;
  myRecord.CollectActiveRecord;
  FError := myRecord.GetLastError;
  if FError.errorCode < 0 then
  begin
    errorS := Format('collect pcrecord task fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, ERROELOG);
  end;
  Inc(PTaskInfo(AJob.Data).taskExecute.taskCount);
  Mylog.writeWorkLog('*****第' + inttostr(count) + '次获取活动记录' + '完成*****');
  Mylog.writeWorkLog('         ')
end;

function TTask.AddTask(taskInfo: TTaskInfo): Integer;
const
  fmtInsert = 'INSERT OR IGNORE INTO  task_info (''taskTitle'',''taskType'',''taskContent'',''taskTime'' ,''tasklastUpdate''  ) VALUES(''%s'',''%s'',''%s'',''%s'' ,''%s'')';
  fmtInsert1 = 'INSERT OR IGNORE INTO  task_trigger (''triggerDevice'',''triggerCondition'',id ) VALUES(''%s'',''%s'',%d)';
  fmtInsert2 = 'INSERT OR IGNORE INTO  task_exe (''taskExe'', id ) VALUES(''%s'',%d)';
var
  sqlS, idS, errorS: string;
  tlb: TFDMemTable;
begin
  try
  // task_info
    sqlS := Format(fmtInsert, [AnsiToUtf8(taskInfo.taskTitle), taskInfo.taskType, AnsiToUtf8(taskInfo.taskContent), taskInfo.taskCreatime, taskInfo.lastUpdate]);
    myTaskDb.ExcuteSql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_SQL then
    begin
      errorS := Format('任务表planTask.db执行sql %s失败', [sqlS]);
      FError.errorMsg := errorS;
      Exit;
    end;
  //get TaskId
    sqlS := 'select LAST_INSERT_ROWID() from task_info';
    tlb := myTaskDb.QuerySql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('任务表planTask.db执行sql %s失败', [sqlS]);
      FError.errorMsg := errorS;
      Exit;
    end;
    taskInfo.id := tlb.FieldByName('LAST_INSERT_ROWID()').AsInteger;
  //task_trigger
    sqlS := Format(fmtInsert1, [AnsiToUtf8(taskInfo.taskConditions.triggerDevice), AnsiToUtf8(taskInfo.taskConditions.triggerCondition), taskInfo.id]);
    myTaskDb.ExcuteSql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_SQL then
    begin
      errorS := Format('任务表planTask.db执行sql %s失败', [sqlS]);
      FError.errorMsg := errorS;
      Exit;
    end;
  //task_exe
    sqlS := Format(fmtInsert2, [AnsiToUtf8(taskInfo.taskExecute.taskExe), taskInfo.id]);
    myTaskDb.ExcuteSql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_SQL then
    begin
      errorS := Format('任务表planTask.db执行sql %s失败', [sqlS]);
      FError.errorMsg := errorS;
      Exit;
    end;
  finally
    taskInfo.id := 0;
    taskInfo.taskTitle := '';
    taskInfo.taskStatus := 0;
    taskInfo.taskContent := '';
    taskInfo.taskType := '';
    taskInfo.taskCreatime := '';
    taskInfo.taskhandle := 0;
    taskInfo.lastUpdate := '';
    taskInfo.taskConditions.triggerDevice := '';
    taskInfo.taskConditions.triggerCondition := '';
    taskInfo.taskConditions.triggerCount := 0;
    taskInfo.taskExecute.taskExe := '';
    taskInfo.taskExecute.taskCount := 0;
    taskInfo.taskExecute.taskCost := 0;
    tlb.free;
    tlb := nil;
  end;

end;

function TTask.GetDayActiveRecord(recordStarTime: string; recordEndTime: string; var recordInfoArr: TArrRecordInfo): Integer;
var
  sSql, s, tempS: string;
  tempDb: TDbObj;
  activeTyInfo: TArrActiveTyInfo;
  errorS: string;
  sumCost: Double;
  len, count, i, j, k, recordCount, cost, Star: Integer;
  list: TList;
  classString, tempString: TStringList;
begin
  classString := TStringList.Create;
  Star := GetTickCount;
  //GetActivetyInfo(dayRecordDbPath, activeTyInfo, recordStarTime, recordEndTime);
  cost := GetTickCount - Star;
  len := Length(activeTyInfo);
  Star := GetTickCount;
  for i := 0 to len - 1 do
  begin
    if activeTyInfo[i].activetype <> '' then
    begin
      if CheckSameStringList(activeTyInfo[i].activetype, classString) then
        classString.Add(activeTyInfo[i].activetype);
    end;
  end;
  count := classString.Count;
  SetLength(recordInfoArr, count);
  for i := 0 to count - 1 do
  begin
    recordInfoArr[i].classType := classString[i];
    tempString := TStringList.Create;
    for j := 0 to len - 1 do
    begin
      if activeTyInfo[j].activetype = classString[i] then
      begin
        tempString.Add(FloatToStr(activeTyInfo[j].percent));
        tempString.Add(FloatToStr(activeTyInfo[j].costime));
        tempString.Add(activeTyInfo[j].activety);
        tempString.Add(activeTyInfo[j].activetype);
        tempString.Add(activeTyInfo[j].activeContent);
        Inc(recordCount);
      end;
    end;
    SetLength(recordInfoArr[i].activeTyInfo, recordCount);
    for k := 0 to recordCount - 1 do
    begin
     { recordInfoArr[i].activeTyInfo[k].percent := StrToFloat(tempString[k * 5]);
      recordInfoArr[i].activeTyInfo[k].costime := StrToFloat(tempString[k * 5 + 1]);
      recordInfoArr[i].activeTyInfo[k].activety := (tempString[k * 5 + 2]);
      recordInfoArr[i].activeTyInfo[k].activetype := (tempString[k * 5 + 3]);
      recordInfoArr[i].activeTyInfo[k].activeContent := (tempString[k * 5 + 4]);
      sumCost := sumCost + recordInfoArr[i].activeTyInfo[k].costime;  }
    end;
    recordInfoArr[i].cost := sumCost;
    sumCost := 0.0;
    s := '';
    recordCount := 0;
    tempString.Free;
  end;
  cost := GetTickCount - Star;

  classString.Free;
end;

function TTask.InitHook: TError;
begin
  Result.errorCode := 0;
  Result.errorMsg := '';
  try
    dyLoadHookDll(gMm.AppDir + '\KeyMouseHook.dll');
  except
    Result.errorCode := ERROR_LOADDLL;
    Result.errorMsg := '加载dll错误';
    Exit;
  end;
  if not EnableKeyHook then
  begin
    Result.errorCode := ERROR_KEYHOOK;
    Result.errorMsg := '打开键盘钩子失败';
    Exit;

  end;
  if not OpenMouseHook(aMainHandle, 0) then
  begin
    Result.errorCode := ERROR_MOUSEHOOK;
    Result.errorMsg := '打开鼠标钩子失败';
    Exit;
  end;
end;

function TTask.InsertDayTb_Sqlite(managerDbPath: string): TError;
var
  sqlS, errorS: string;
  i: Integer;
  tDbType, tDbPath: string;
  todayS: string;
  todayD: TDateTime;
  tlb, tdlb: TFDMemTable;
  myDbObj: TDbObj;
begin
  myDbObj := TDbObj.Create;
  try
    myDbObj.OpenDb(mangerDbPath, 'SQLite');
  //plantask
    todayS := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now);
    tDbPath := planTaskDbPath;
    sqlS := 'select * from  mydb_info  where  dbType=''planTask''';
    tlb := myDbObj.QuerySql(sqlS);
    FError.errorCode := SUS_QUERY;
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('索引表manager.db执行sql%s失败', [sqlS]);
      FError.errorMsg := errorS;
      Result := FError;
      Exit;
    end;
    if tlb.SourceView.Rows.Count = 0 then
    begin
      sqlS := 'INSERT OR IGNORE INTO  mydb_info (''dbPath'',''dbType'',''tableStatus'',''upStatus'',''createTime'') VALUES(''' + AnsiToUtf8(tDbPath) + ''', ''planTask'',0,0,' + '''' + todayS + ''')';

      myDbObj.ExcuteSql(sqlS);
      FError := myDbObj.GetLastError;
      if FError.errorCode <> SUS_SQL then
      begin
        errorS := Format('索引表manager.db执行sql%s失败', [sqlS]);
        FError.errorMsg := errorS;
        Result := FError;
        Exit;
      end;
    end;
  //pcrecord
    todayS := FormatDateTime('YYYY-MM-DD 00:00:00', Now);
    sqlS := 'select * from  mydb_info  where  dbType=''pcrecord'' and createTime >=''' + todayS + '''';
    tdlb := myDbObj.QuerySql(sqlS);
    FError.errorCode := SUS_QUERY;
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('索引表manager.db执行sql%s失败', [sqlS]);
      FError.errorMsg := errorS;
      Result := FError;
      Exit;
    end;
    if tdlb.SourceView.Rows.Count = 0 then
    begin
      todayS := FormatDateTime('YYYY-MM-DD', Now);
      tDbPath := ExtractFileDir(mangerDbPath) + '\EveryDay\' + todayS + '.db';
      todayS := FormatDateTime('YYYY-MM-DD HH:MM:SS', Now);
      sqlS := 'INSERT INTO mydb_info (''dbPath'',''dbType'',''tableStatus'',''upStatus'',''createTime'') VALUES(''' + AnsiToUtf8(tDbPath) + ''', ''pcrecord'',0,0,' + '''' + todayS + ''')';
      myDbObj.ExcuteSql(sqlS);
      FError := myDbObj.GetLastError;
      if FError.errorCode <> SUS_SQL then
      begin
        errorS := Format('索引表manager.db执行sql%s失败', [sqlS]);
        FError.errorMsg := errorS;
        Result := FError;
        Exit;
      end;
    end;
  finally
    myDbObj.Free;
  end;

end;

function TTask.IsValueBrowser(const processName: string): Boolean;
var
  postion: Integer;
begin
  postion := 0;
  Result := myRecord.IsValueBrowser(processName, postion);
end;

function TTask.JuageRecordClass(urlApp: string; classRecord: TArrRecordType): Integer;
var
  i, j, count, Len, iCount: Integer;
  recordClass, sql, sTemp: string;
  classGrounp: TStringList;
  tlb: TFDMemTable;
  classDb: TDbObj;
begin
  //
  urlApp := ChecekUrl(urlApp);
  count := Length(classRecord);
  classDb := TDbObj.Create;
  try
    classDb.OpenDb(classPath, 'SQLite');
    sql := 'select * from  record_class where urlApplication =  ''' + urlApp + '''';
    tlb := classDb.QuerySql(sql);

    if tlb.SourceView.Rows.Count = 0 then
    begin
      Result := 4;
      Exit;
    end;
    sTemp := (tlb.FieldByName('class').AsString);
    for i := 0 to count - 1 do
    begin
      if sTemp = classRecord[i].ruleType then
      begin
        Result := i;
        Exit;
      end;
    end;
    Result := 4;
  finally
    tlb.Free;
    classDb.Free;
  end;
end;

function TTask.CheckFileOrDir(appDir: string): TError;
var
  tDbDir: string;
  tDir: string;
  iTrapIconFilename, oiTrapIconFilename, dllFilePath: string;
  error: Integer;
  tFilenPath: string;
  sqlS: string;
  todayS: string;
begin
  Result.errorCode := 0;
  Result.errorMsg := '';
   //判断目录是否存在
  //media/icon  图标目录
  tDir := appDir + '\media\icon';
  if not DirectoryExists(tempDir) then
  begin
    ForceDirectories(tDir);
  end;
  //temp 临时目录
  tempDir := appDir + '\temp';
  if not DirectoryExists(tempDir) then
  begin
    ForceDirectories(tempDir);
  end;
  //templates   模板目录
  templatesDir := appDir + '\templates';
  if not DirectoryExists(templatesDir) then
  begin
    ForceDirectories(templatesDir);
  end;
  // \db\EveryDay  // 每日记录目录
  tDbDir := ExtractFileDir(ExtractFileDir(gMm.AppDir));
  tDbDir := tDbDir + '\db\EveryDay';
  if not DirectoryExists(tDbDir) then
  begin
    ForceDirectories(tDbDir);
  end;
   // \db\EveryDay  // 每日记录目录
  tDbDir := ExtractFileDir(ExtractFileDir(gMm.AppDir));
  tDbDir := tDbDir + '\db\dbasicLib';
  if not DirectoryExists(tDbDir) then
  begin
    ForceDirectories(tDbDir);
  end;
  //判断文件是否存在
  iTrapIconFilename := gmm.AppDir + '\media\icon\open.ico';
  oiTrapIconFilename := gmm.AppDir + '\media\icon\close.ico';
  if not FileExists(iTrapIconFilename) then
  begin
    Result.errorCode := ERROR_FILEXIS;
    Result.errorMsg := 'open.ico';
    Exit;
  end;
  if not FileExists(oiTrapIconFilename) then
  begin
    Result.errorCode := ERROR_FILEXIS;
    Result.errorMsg := 'close.ico';
    Exit;
  end;
  //dll
  dllFilePath := gMm.AppDir + '\sqlite3.dll';
  if not FileExists(dllFilePath) then
  begin
    Result.errorCode := ERROR_FILEXIS;
    Result.errorMsg := 'sqlite3.dll';
    Exit;
  end;
  dllFilePath := gMm.AppDir + '\KeyMouseHook.dll';
  if not FileExists(dllFilePath) then
  begin
    Result.errorCode := ERROR_FILEXIS;
    Result.errorMsg := 'KeyMouseHook.dll';
    Exit;
  end;
  dllFilePath := gMm.AppDir + '\oleacc.dll';
  if not FileExists(dllFilePath) then
  begin
    Result.errorCode := ERROR_FILEXIS;
    Result.errorMsg := 'oleacc.dll';
    Exit;
  end;
  //模板文件  sqlite 数据库
  tFilenPath := templatesDir + '\manger.db';
  if not FileExists(tFilenPath) then
  begin
    sqlS := '';
    myTaskDb.OpenDb(tFilenPath, 'SQLite');
    myTaskDb.ExcuteSql(sqlS);
  end;
  tFilenPath := templatesDir + '\date.db';
  if not FileExists(tFilenPath) then
  begin
    sqlS := '';
    myTaskDb.OpenDb(tFilenPath, 'SQLite');
    myTaskDb.ExcuteSql(sqlS);
  end;
  tFilenPath := templatesDir + '\planTask.db';
  if not FileExists(tFilenPath) then
  begin
    sqlS := '';
    myTaskDb.OpenDb(tFilenPath, 'SQLite');
    myTaskDb.ExcuteSql(sqlS);
  end;

  // 数据库文件路径
  todayS := FormatDateTime('YYYY-MM-DD', Now);
  tDbDir := ExtractFileDir(tDbDir);
  mangerDbPath := tDbDir + '\manger.db';
  if not FileExists(mangerDbPath) then
  begin
    CopyFile(PChar(templatesDir + '\manger.db'), PChar(mangerDbPath), False);
  end;
  planTaskDbPath := tDbDir + '\planTask.db';
  if not FileExists(planTaskDbPath) then
  begin
    CopyFile(PChar(templatesDir + '\planTask.db'), PChar(planTaskDbPath), False);
  end;
  dayRecordDbPath := tDbDir + '\EveryDay\' + 'date.db';
  if not FileExists(dayRecordDbPath) then
  begin
    CopyFile(PChar(templatesDir + '\date.db'), PChar(dayRecordDbPath), False);
  end;
  classPath := tDbDir + '\dbasicLib\Class.db';
  if not FileExists(classPath) then
  begin
    CopyFile(PChar(templatesDir + '\Class.db'), PChar(classPath), False);
  end;
  rulePath := tDbDir + '\dbasicLib\rule.db';
  if not FileExists(rulePath) then
  begin
    CopyFile(PChar(templatesDir + '\rule.db'), PChar(rulePath), False);
  end;

  //浏览器文件
  if FileExists(myborwerInfo.bookmarksPath) then
  begin
    CopyFile(PChar(myborwerInfo.bookmarksPath), PChar(tempDir + '\bookmarks'), False);
  end;
  if FileExists(myborwerInfo.passwordPath) then
  begin
    CopyFile(PChar(myborwerInfo.passwordPath), PChar(tempDir + '\password.db'), False);
  end;

end;

function TTask.CheckSameRecord(sRecordList: TStringList; itemName: string; var postion: Integer): Boolean;
var
  i, Len: Integer;
begin
  Result := False;
  postion := -1;
  Len := sRecordList.Count;
  if Len < 1 then
    Exit;
  for i := 0 to Len - 1 do
  begin
    if itemName = sRecordList[i] then
    begin
      Result := True;
      postion := i;
      Exit;
    end;
  end;
end;

function TTask.CheckSameStringList(item: string; chekcStringlist: TStringList): Boolean;
var
  i, count: Integer;
begin
  count := chekcStringlist.Count;
  for i := 0 to count - 1 do
  begin
    if item = chekcStringlist[i] then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function TTask.CheckYesterdayTaskInfo: TError;
var
  errorS: string;
begin
  FError := SetEveryDay;
  if FError.errorCode < 0 then
  begin
    errorS := Format('set EverydayTask fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
    Mylog.writeWorkLog(errorS, -1);
    Exit;
  end;
end;

procedure TTask.ClearError;
begin
  myRecord.ClearError;
end;

procedure TTask.ClearList;
var
  i, count: Integer;
  task: PTaskInfo;
begin
  count := FTaskList.Count;
  for i := 0 to count - 1 do
  begin
    Dispose(PTaskInfo(FTaskList[i]));
  end;
  FTaskList.Clear;
end;

function TTask.ClearTaskList: Integer;
begin

end;

procedure TTask.CloseConnect;
begin
 // myTaskDb.CloseConnect;
  //ttDbObj.CloseConnect;
  myRecord.CloseConnect;
end;

function TTask.SetAllItmeType: Integer;
begin
end;

function TTask.SetEveryDay: TError;
var
  s: string;
begin

  FError := EveryDayTaskInit;     // 设置每日任务
  Result := FError;
end;

function TTask.EveryDayCheckTask: Integer;
begin

end;

function TTask.EveryDayTaskInit: TError;
const
  fmtInsert = 'INSERT OR IGNORE INTO  day_task (''taskname'',''taskType'',''taskRemarks'',''taskTime'' ,''taskStatus'' ) VALUES(''%s'',''%s'',''%s'',''%s'',0)';
var
  sqlS, todayS, nowD, errorS, sTemp: string;
  myTaskInfo: TTaskInfo;
  tlb, tlb1: TFDMemTable;
begin
  try
    nowD := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now);
  //collect pcrecord
    myTaskInfo.taskTitle := ('采集PC活动记录');
    myTaskInfo.taskTitle := (myTaskInfo.taskTitle);
    myTaskInfo.taskType := 'timerTask';
    myTaskInfo.taskContent := '';
    myTaskInfo.taskCreatime := nowD;
    myTaskInfo.lastUpdate := nowD;
    myTaskInfo.taskConditions.triggerDevice := 'local';
    myTaskInfo.taskConditions.triggerCondition := '{"total": 1,"condition": [{"type":"time","interval": 1}]}';
    myTaskInfo.taskExecute.taskExe := '{"total": 1,"execute": [{"type": "function","name": "CollectActiveRecord"}]}';
    todayS := FormatDateTime('YYYY-MM-DD 00:00:00', Now);
    sqlS := 'select * from  task_info  where  ( taskType=''timerTask'') and  (taskTitle=''' + (myTaskInfo.taskTitle) + ''') and ( tasklastUpdate >=''' + todayS + ''')';
    tlb := myTaskDb.QuerySql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('任务%s执行sql %s失败', [myTaskInfo.taskTitle, sqlS]);
      FError.errorMsg := errorS;
      Result := FError;
      Exit;
    end;
    if tlb.SourceView.Rows.Count = 0 then
      AddTask(myTaskInfo);
  //pcValue
    myTaskInfo.taskTitle := ('采集有效记录');
    myTaskInfo.taskTitle := (myTaskInfo.taskTitle);
    myTaskInfo.taskType := 'timerTask';
    myTaskInfo.taskContent := '';
    myTaskInfo.taskCreatime := nowD;
    myTaskInfo.lastUpdate := nowD;
    myTaskInfo.taskConditions.triggerDevice := 'local';
    myTaskInfo.taskConditions.triggerCondition := '{"total": 1,"condition": [{"type": "time","interval": 30}]}';
    myTaskInfo.taskExecute.taskExe := '{"total": 1,"execute": [{"type": "function","name": "CollectValueRecord"}]}';
    todayS := FormatDateTime('YYYY-MM-DD 00:00:00', Now);
    sqlS := 'select * from  task_info  where   taskType=''timerTask'' and  taskTitle=''' + (myTaskInfo.taskTitle) + ''' and  tasklastUpdate >''' + todayS + '''';
 //sqlS := 'select * from  task_info  where   taskType=''timerTask'' and  taskTitle=''' + UnicodeToUTF8String(myTaskInfo.taskTitle) + '''';
    tlb1 := myTaskDb.QuerySql(sqlS);
    FError := myTaskDb.GetLastError;
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('任务%s执行sql %s失败', [myTaskInfo.taskTitle, sqlS]);
      FError.errorMsg := errorS;
      Result := FError;
      Exit;
    end;
    if tlb1.SourceView.Rows.Count = 0 then
      AddTask(myTaskInfo);
  //StatisticsRecord
    Result := FError;
  finally
    myTaskInfo.id := 0;
    myTaskInfo.taskTitle := '';
    myTaskInfo.taskStatus := 0;
    myTaskInfo.taskContent := '';
    myTaskInfo.taskType := '';
    myTaskInfo.taskCreatime := '';
    myTaskInfo.taskhandle := 0;
    myTaskInfo.lastUpdate := '';
    myTaskInfo.taskConditions.triggerDevice := '';
    myTaskInfo.taskConditions.triggerCondition := '';
    myTaskInfo.taskConditions.triggerCount := 0;
    myTaskInfo.taskExecute.taskExe := '';
    myTaskInfo.taskExecute.taskCount := 0;
    myTaskInfo.taskExecute.taskCost := 0;
    tlb.free;
    tlb := nil;
    tlb1.Free;
    tlb1 := nil;
  end;
end;

function TTask.BookmarkSynchronize(bookmarkPath: string): Integer;
{var
  s, sNode, temp: string;
  jo: ISuperObject;
  item: TSuperObjectIter;
  ja: TSuperArray;
  len, i, j: Integer;  }
begin
  {myTaskDb.BeginTans_Sqlite;
  s := Utf8ToAnsi(FileToString(bookmarkPath));
  jo := SO(s);
  s := jo.s['roots.bookmark_bar'];
  FindSonJs(s, 'bookmark_bar');
  s := jo.s['roots.other'];
  FindSonJs(s, 'other');
  myTaskDb.Commit_Sqlite;  }
end;

function TTask.GearmanTask(taskInfo: PTaskInfo): TError;
var
  jo, js: TJSONObject;
  ja: TJSONArray;
  i, len, interval: Integer;
  atimer: string;
  s, sNode, temp, exeName: string;
begin
  // analysis 任务，任务触发，任务执行者。
  if taskInfo.taskType = 'timerTask' then
  begin
     // 解析任务触发
    s := taskInfo.taskConditions.triggerCondition;
    jo := TJSONObject.ParseJSONValue(Trim(s)) as TJSONObject;
    ja := TJSONArray(jo.GetValue('condition'));

    len := ja.count;
    for i := 0 to len - 1 do
    begin
      sNode := ja.Items[i].ToString;
      js := TJSONObject.ParseJSONValue(Trim(sNode)) as TJSONObject;
      temp := js.GetValue('type').ToString;
      temp := StringReplace(temp, '"', '', [rfReplaceAll]);
      // s m,h
      if temp = 'time' then
      begin
        temp := js.GetValue('interval').ToString;
        temp := StringReplace(temp, '"', '', [rfReplaceAll]);
        interval := StrToInt(temp);  //

      end
      // d M Y
      else if temp = 'timeDay' then
      begin
        temp := js.GetValue('triggertime').ToString;
        temp := StringReplace(temp, '"', '', [rfReplaceAll]);
        atimer := temp;
      end;
      js.Free;
    end;
    jo.Free;
    // 解析 任务执行者
    s := taskInfo.taskExecute.taskExe;
    jo := TJSONObject.ParseJSONValue(Trim(s)) as TJSONObject;
    ja := TJSONArray(jo.GetValue('execute'));
    len := ja.count;
    for i := 0 to len - 1 do
    begin
      sNode := ja.Items[i].ToString;
      js := TJSONObject.ParseJSONValue(Trim(sNode)) as TJSONObject;
      temp := js.getValue('type').tostring;
      temp := StringReplace(temp, '"', '', [rfReplaceAll]);
      if temp = 'function' then
      begin
        exeName := js.GetValue('name').ToString;
        exeName := StringReplace(exeName, '"', '', [rfReplaceAll]);
        if exeName = 'CollectActiveRecord' then
        begin
          taskInfo.taskhandle := Workers.Post(ActiveRecord, interval * Q1Second, taskInfo, False, jdfFreeByUser);
        // taskInfo.taskhandle := Workers.Post(ActiveRecord, 5 * Q1Second, taskInfo, False, jdfFreeByUser);
        end
        else if (exeName = 'CollectValueRecord') then
        begin
          taskInfo.taskhandle := Workers.Post(ValueRecord, interval * Q1Second, taskInfo, False, jdfFreeByUser);
        end;
      end;
      js.Free;
    end;
    jo.Free;
  end
  else if True then
  begin

  end;

  Exit;
  RecordTask(gMm.activeProInterval, gMm.valueInterval);
end;

function TTask.GetActiveRecord(recordStarTime: string; recordEndTime: string; var recordInfoArr: TArrRecordtyInfo; RecordMode: Integer; FilterWord: string): Integer;
var
  dayObj, classObj: TDbObj;
  dayDbPath, sql, tsql: string;
  dTlb, tTlb, classTlb: TFDMemTable;
  len, i, j, valueTag, sumCount, tCount: Integer;
  sError: string;
  tRecordInfoArr: TArrRecordtyInfo;
  dInteruptTime: Double;
begin
  sumCount := 0;
  dInteruptTime := VarToDateTime('00:00:30') * 10;
  j := 0;
  tCount := 0;
  dayObj := TDbObj.Create;
  classObj := TDbObj.Create;
  try
    classObj.OpenDb(classPath, 'SQLite');
  //day
    dayDbPath := dayRecordDbPath;
    dayObj.OpenDb(dayDbPath, 'SQLite');

    sql := 'select  * from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + '''';
    try
      dTlb := dayObj.QuerySql(sql);
    except
      sError := format('查询记录失败，错误代码%d, sql%s,', [FError.errorCode, sql]);
      Mylog.writeWorkLog(sError, ERROELOG);
      Exit;
    end;
    len := dTlb.SourceView.Rows.Count;

    for i := 0 to len - 1 do
    begin
      if (dTlb.FieldByName('action_process').AsString <> '') and (dTlb.FieldByName('record_startime').AsString <> '') and (dTlb.FieldByName('record_endtime').AsString <> '') then
      begin
        Inc(tCount);
        SetLength(tRecordInfoArr, tCount);
        try
          tRecordInfoArr[tCount - 1].recordName := dTlb.FieldByName('action_process').AsString;
          tRecordInfoArr[tCount - 1].starTime := VarToDateTime(dTlb.FieldByName('record_startime').AsString);
          tRecordInfoArr[tCount - 1].endTime := VarToDateTime(dTlb.FieldByName('record_endtime').AsString);
          tRecordInfoArr[tCount - 1].costTime := tRecordInfoArr[tCount - 1].endTime - tRecordInfoArr[tCount - 1].starTime;
        except
          sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [dTlb.FieldByName('record_startime').AsString, dTlb.FieldByName('record_endtime').AsString]);
          Mylog.writeWorkLog(sError, ERROELOG);
          Exit;
        end;
      end
      else
      begin
        dTlb.Next;
        Continue;
      end;
      if tRecordInfoArr[tCount - 1].costTime >= dInteruptTime then
      begin
        sql := 'select  value_tag from valuetime_record  where value_Tag >0  and   star_time >= ''' + dTlb.FieldByName('record_startime').AsString + ''' and stop_time <= ''' + dTlb.FieldByName('record_endtime').AsString + '''';
        try
          tTlb := dayObj.QuerySql(sql);
          if tTlb.SourceView.Rows.Count > 0 then
            tRecordInfoArr[tCount - 1].valueTag := True
          else
          begin
            tRecordInfoArr[tCount - 1].valueTag := false;
          end;
        finally
          tTlb.free;
        end;
      end
      else
      begin
        tRecordInfoArr[tCount - 1].valueTag := True;
      end;

      dTlb.Next;
    end;

    if RecordMode = 0 then
    begin
      recordInfoArr := tRecordInfoArr;
    end
    else if RecordMode = 1 then
    begin
      recordInfoArr := tRecordInfoArr;

    end;
    Exit;
  finally
    dTlb.free;
    dayObj.Free;
    classObj.Free;
  end;

end;
//

function TTask.GetActiveRecordClass(recordStarTime, recordEndTime: string; var reInfo: TArrRecordtyInfo): Integer;
var
  dayDbPath, sql, tsql: string;
  dTlb, tTlb, iTlb, classTlb: TFDMemTable;
  len, i, j, valueTag, sumCount, tCount, sleepCount, classCount, count, internetCount, lastCount, blankCount: Integer;
  sError, actionProcess, StarTime, Endtime: string;
  tRecordInfoArr: TArrRecordtyInfo;
  dInteruptTime, sumcost, costTime, dTemp, dEndTime, dMaxTime: Double;
  value: Boolean;
begin
  sumCount := 0;
  sleepCount := 0;
  count := 0;
  j := 0;
  tCount := 0;
  costTime := 0;
  internetCount := 0;
  blankCount := Length(reInfo);
  dInteruptTime := VarToDateTime('00:00:30') * 10;
  dMaxTime := VarToDateTime('01:00:00') * 4;

  try
    sql := 'select  * from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + '''';
    try
      dTlb := myRecord.DayDbObj.QuerySql(sql);
    except
      sError := format('查询记录失败，错误代码%d, sql%s,', [FError.errorCode, sql]);
      Mylog.writeWorkLog(sError, ERROELOG);
      Exit;
    end;
    len := dTlb.SourceView.Rows.Count;
    for i := -1 to len do
    begin
      //赋值
      if i = -1 then
      begin
        sql := 'select  * from pc_process_record  where  record_endtime = (select  min(record_startime) from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + ''')';
        try
          tTlb := myRecord.DayDbObj.QuerySql(sql);
          if tTlb.SourceView.Rows.Count = 1 then
          begin
            actionProcess := tTlb.FieldByName('action_process').AsString;
            StarTime := recordStarTime;
            Endtime := tTlb.FieldByName('record_endtime').AsString;
            costTime := VarToDateTime(Endtime) - VarToDateTime(StarTime);
          end;
        finally
          tTlb.Free;
        end;
      end
      else if (i = len) then
      begin
        sql := 'select  * from pc_process_record  where  record_startime =  (select  max(record_endtime) from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + ''')';
        try
          tTlb := myRecord.DayDbObj.QuerySql(sql);
          if tTlb.SourceView.Rows.Count = 1 then
          begin

            Endtime := tTlb.FieldByName('record_endtime').AsString;
            if (Endtime = '') or (Endtime < recordEndTime) then
              actionProcess := ''
            else
            begin
              actionProcess := tTlb.FieldByName('action_process').AsString;
              StarTime := tTlb.FieldByName('record_startime').AsString;
              Endtime := recordEndTime;
              costTime := VarToDateTime(Endtime) - VarToDateTime(StarTime);
            end;
          end
          else
          begin
            actionProcess := '';
          end;
        finally
          tTlb.Free;
        end;
      end
      else
      begin
        actionProcess := dTlb.FieldByName('action_process').AsString;
        StarTime := dTlb.FieldByName('record_startime').AsString;
        Endtime := dTlb.FieldByName('record_endtime').AsString;
        costTime := VarToDateTime(Endtime) - VarToDateTime(StarTime);
      end;
       //reinfo
      if (actionProcess <> '') and (StarTime <> '') and (Endtime <> '') then
      begin
             //valueTag
        if costTime >= dInteruptTime then
        begin
          sql := 'select  value_tag from valuetime_record  where value_Tag >0  and   star_time >= ''' + StarTime + ''' and stop_time <= ''' + Endtime + '''';
          try
            tTlb := myRecord.DayDbObj.QuerySql(sql);

            if tTlb.SourceView.Rows.Count > 0 then
              value := True
            else
            begin

              value := False;
            end;
            if costTime >= dMaxTime then
            begin
              if tTlb.SourceView.Rows.Count > 4 then
              begin
                value := True
              end
              else
              begin
                value := False;
              end;
            end;

          finally
            tTlb.free;
          end;
        end
        else
        begin
          value := True;
        end;
        if IsValueBrowser(actionProcess) then
        begin
          sql := 'select  * from internet_record  where record_startime >= ''' + StarTime + ''' and record_endtime <= ''' + Endtime + '''';
          dEndTime := VarToDateTime(StarTime);
          try
            iTlb := myRecord.DayDbObj.QuerySql(sql);
            internetCount := iTlb.SourceView.Rows.Count;
            if iTlb.SourceView.Rows.Count >= 1 then
            begin
              for j := 0 to internetCount - 1 do
              begin
                dTemp := VarToDateTime(iTlb.FieldByName('record_startime').AsString);
                if (dTemp <> dEndTime) then
                begin
                  Inc(blankCount);
                  SetLength(reInfo, blankCount);
                  reInfo[blankCount - 1].StarTime := dEndTime;
                  reInfo[blankCount - 1].Endtime := dTemp;
                  reInfo[blankCount - 1].costTime := dTemp - dEndTime;
                  reInfo[blankCount - 1].recordName := 'blank';
                  reInfo[blankCount - 1].recordTitle := '';
                  reInfo[blankCount - 1].classType := '';
                  reInfo[blankCount - 1].ruleType := 0;
                  reInfo[blankCount - 1].valueTag := False;
                end;
                Inc(tCount);
                SetLength(tRecordInfoArr, tCount);
                try
                  tRecordInfoArr[tCount - 1].recordName := iTlb.FieldByName('url').AsString;
                  tRecordInfoArr[tCount - 1].StarTime := VarToDateTime(iTlb.FieldByName('record_startime').AsString);
                  tRecordInfoArr[tCount - 1].Endtime := VarToDateTime(iTlb.FieldByName('record_endtime').AsString);
                  tRecordInfoArr[tCount - 1].costTime := tRecordInfoArr[tCount - 1].Endtime - tRecordInfoArr[tCount - 1].StarTime;
                  tRecordInfoArr[tCount - 1].valueTag := value;
                  tRecordInfoArr[tCount - 1].ruleType := 2;
                  sumcost := sumcost + tRecordInfoArr[tCount - 1].costTime;
                except
                  sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [StarTime, Endtime]);
                  Mylog.writeWorkLog(sError, ERROELOG);
                  Exit;
                end;
                dEndTime := VarToDateTime(iTlb.FieldByName('record_endtime').asstring);
                iTlb.Next;
              end;

            end;
          finally
            iTlb.Free;
          end;

        end
        else
        begin
          Inc(tCount);
          SetLength(tRecordInfoArr, tCount);
          try
            tRecordInfoArr[tCount - 1].recordName := actionProcess;
            tRecordInfoArr[tCount - 1].StarTime := VarToDateTime(StarTime);
            tRecordInfoArr[tCount - 1].Endtime := VarToDateTime(Endtime);
            tRecordInfoArr[tCount - 1].costTime := tRecordInfoArr[tCount - 1].Endtime - tRecordInfoArr[tCount - 1].StarTime;
            tRecordInfoArr[tCount - 1].valueTag := value;
            tRecordInfoArr[tCount - 1].ruleType := 2;
            if not value then
              tRecordInfoArr[tCount - 1].ruleType := 1;

          except
            sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [StarTime, Endtime]);
            Mylog.writeWorkLog(sError, ERROELOG);
            Exit;
          end;
        end;
      end;
      if (i <> -1) and (i <> len) then
        dTlb.Next;
      value := False;
    end;
    //rule
    tCount := Length(tRecordInfoArr);
    sleepCount := 0;
    for i := 0 to tCount - 1 do
    begin
      if tRecordInfoArr[i].valueTag then
      begin
        Inc(blankCount);
        SetLength(reInfo, blankCount);
        reInfo[blankCount - 1].StarTime := tRecordInfoArr[i].StarTime;
        reInfo[blankCount - 1].Endtime := tRecordInfoArr[i].Endtime;
        reInfo[blankCount - 1].costTime := reInfo[blankCount - 1].Endtime - reInfo[blankCount - 1].StarTime;
        reInfo[blankCount - 1].recordName := tRecordInfoArr[i].recordName;
        reInfo[blankCount - 1].recordTitle := tRecordInfoArr[i].recordName;
        reInfo[blankCount - 1].classType := tRecordInfoArr[i].classType;
        reInfo[blankCount - 1].ruleType := 2;
        reInfo[blankCount - 1].valueTag := True;
      end
      else
      begin
        Inc(blankCount);
        SetLength(reInfo, blankCount);
        reInfo[blankCount - 1].StarTime := tRecordInfoArr[i].StarTime;
        reInfo[blankCount - 1].Endtime := tRecordInfoArr[i].Endtime;
        reInfo[blankCount - 1].costTime := reInfo[blankCount - 1].Endtime - reInfo[blankCount - 1].StarTime;
        reInfo[blankCount - 1].recordName := tRecordInfoArr[i].recordName;
        reInfo[blankCount - 1].recordTitle := tRecordInfoArr[i].recordName;
        reInfo[blankCount - 1].classType := tRecordInfoArr[i].classType;
        reInfo[blankCount - 1].ruleType := 1;
        reInfo[blankCount - 1].valueTag := False;
      end;
    end;

  finally
    dTlb.free;
  end;

end;

function TTask.GetActiveRecordClass1(recordStarTime, recordEndTime: string; var classRecord: TArrRecordType; var reInfo: TArrRecordtyInfo): Integer;
var
  dayObj, classObj: TDbObj;
  dayDbPath, sql, tsql: string;
  dTlb, tTlb, iTlb, classTlb: TFDMemTable;
  len, i, j, valueTag, sumCount, tCount, sleepCount, classCount, count, internetCount, lastCount, blankCount: Integer;
  sError, actionProcess, StarTime, Endtime: string;
  tRecordInfoArr: TArrRecordtyInfo;
  dInteruptTime, sumcost, costTime, dTemp, dEndTime: Double;
  value: Boolean;
begin
  sumCount := 0;
  sleepCount := 0;
  count := 0;
  j := 0;
  tCount := 0;
  costTime := 0;
  internetCount := 0;
  blankCount := Length(reInfo);
  dInteruptTime := VarToDateTime('00:00:30') * 10;

  dayObj := TDbObj.Create;
  classObj := TDbObj.Create;
  try
    classObj.OpenDb(classPath, 'SQLite');
  //day
    dayDbPath := dayRecordDbPath;
    dayObj.OpenDb(dayDbPath, 'SQLite');
    sql := 'select  * from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + '''';
    try
      dTlb := dayObj.QuerySql(sql);
    except
      sError := format('查询记录失败，错误代码%d, sql%s,', [FError.errorCode, sql]);
      Mylog.writeWorkLog(sError, ERROELOG);
      Exit;
    end;
    len := dTlb.SourceView.Rows.Count;
    for i := -1 to len do
    begin
      //赋值
      if i = -1 then
      begin
        sql := 'select  * from pc_process_record  where  record_endtime = (select  min(record_startime) from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + ''')';
        try
          tTlb := dayObj.QuerySql(sql);
          if tTlb.SourceView.Rows.Count = 1 then
          begin
            actionProcess := tTlb.FieldByName('action_process').asstring;
            StarTime := recordStarTime;
            Endtime := tTlb.FieldByName('record_endtime').asstring;
            costTime := VarToDateTime(Endtime) - VarToDateTime(StarTime);
          end;
        finally
          tTlb.Free;
        end;
      end
      else if (i = len) then
      begin
        sql := 'select  * from pc_process_record  where  record_startime =  (select  max(record_endtime) from pc_process_record  where record_startime >= ''' + recordStarTime + ''' and record_endtime <= ''' + recordEndTime + ''')';
        try
          tTlb := dayObj.QuerySql(sql);
          if tTlb.SourceView.Rows.Count = 1 then
          begin

            Endtime := tTlb.FieldByName('record_endtime').asstring;
            if (Endtime = '') or (Endtime < recordEndTime) then
              actionProcess := ''
            else
            begin
              actionProcess := tTlb.FieldByName('action_process').asstring;
              StarTime := tTlb.FieldByName('record_startime').asstring;
              Endtime := recordEndTime;
              costTime := VarToDateTime(Endtime) - VarToDateTime(StarTime);
            end;
          end
          else
          begin
            actionProcess := '';
          end;
        finally
          tTlb.Free;
        end;
      end
      else
      begin
        actionProcess := dTlb.FieldByName('action_process').asstring;
        StarTime := dTlb.FieldByName('record_startime').asstring;
        Endtime := dTlb.FieldByName('record_endtime').asstring;
        costTime := VarToDateTime(Endtime) - VarToDateTime(StarTime);
      end;
       //reinfo
      if (actionProcess <> '') and (StarTime <> '') and (Endtime <> '') then
      begin
             //valueTag
        if costTime >= dInteruptTime then
        begin
          sql := 'select  value_tag from valuetime_record  where value_Tag >0  and   star_time >= ''' + StarTime + ''' and stop_time <= ''' + Endtime + '''';
          try
            tTlb := dayObj.QuerySql(sql);
            if tTlb.SourceView.Rows.Count > 0 then
              value := True
            else
            begin

              value := False;
            end;
          finally
            tTlb.free;
          end;
        end
        else
        begin

          value := True;
        end;
        if IsValueBrowser(actionProcess) then
        begin
          sql := 'select  * from internet_record  where record_startime >= ''' + StarTime + ''' and record_endtime <= ''' + Endtime + '''';
          dEndTime := VarToDateTime(StarTime);
          try
            iTlb := dayObj.QuerySql(sql);
            internetCount := iTlb.SourceView.Rows.Count;
            if iTlb.SourceView.Rows.Count >= 1 then
            begin
              for j := 0 to internetCount - 1 do
              begin
                dTemp := VarToDateTime(iTlb.FieldByName('record_startime').AsString);
                if (dTemp <> dEndTime) then
                begin
                  Inc(blankCount);
                  SetLength(classRecord[0].recordContent, blankCount);
                  classRecord[0].recordContent[blankCount - 1].StarTime := dEndTime;
                  classRecord[0].recordContent[blankCount - 1].Endtime := dTemp;
                  classRecord[0].recordContent[blankCount - 1].costTime := dTemp - dEndTime;
                  sumcost := sumcost + classRecord[0].recordContent[blankCount - 1].costTime;
                  classRecord[0].recordContent[blankCount - 1].recordName := 'blank';
                end;
                Inc(tCount);
                SetLength(tRecordInfoArr, tCount);
                try
                  tRecordInfoArr[tCount - 1].recordName := iTlb.FieldByName('url').asstring;
                  tRecordInfoArr[tCount - 1].StarTime := VarToDateTime(iTlb.FieldByName('record_startime').asstring);
                  tRecordInfoArr[tCount - 1].Endtime := VarToDateTime(iTlb.FieldByName('record_endtime').asstring);
                  tRecordInfoArr[tCount - 1].costTime := tRecordInfoArr[tCount - 1].Endtime - tRecordInfoArr[tCount - 1].StarTime;
                  tRecordInfoArr[tCount - 1].valueTag := value;
                  sumcost := sumcost + tRecordInfoArr[tCount - 1].costTime;
                except
                  sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [StarTime, Endtime]);
                  Mylog.writeWorkLog(sError, ERROELOG);
                  Exit;
                end;
                dEndTime := VarToDateTime(iTlb.FieldByName('record_endtime').asstring);
                iTlb.Next;
              end;

            end;
          finally
            iTlb.Free;
          end;

        end
        else
        begin
          Inc(tCount);
          SetLength(tRecordInfoArr, tCount);
          try
            tRecordInfoArr[tCount - 1].recordName := actionProcess;
            tRecordInfoArr[tCount - 1].StarTime := VarToDateTime(StarTime);
            tRecordInfoArr[tCount - 1].Endtime := VarToDateTime(Endtime);
            tRecordInfoArr[tCount - 1].costTime := tRecordInfoArr[tCount - 1].Endtime - tRecordInfoArr[tCount - 1].StarTime;
            tRecordInfoArr[tCount - 1].valueTag := value;
          except
            sError := format('记录时间转换失败，错误信息开始时间%s,结束时间%s', [StarTime, Endtime]);
            Mylog.writeWorkLog(sError, ERROELOG);
            Exit;
          end;
        end;
      end;
      if (i <> -1) and (i <> len) then
        dTlb.Next;
      value := False;
    end;
    //class
    tCount := Length(tRecordInfoArr);
    sleepCount := 0;
    for i := 0 to tCount - 1 do
    begin
      if tRecordInfoArr[i].valueTag then
      begin
        classCount := JuageRecordClass(tRecordInfoArr[i].recordName, classRecord);
        //classCount := 4;
        sumCount := length(classRecord[classCount].recordContent) + 1;
        SetLength(classRecord[classCount].recordContent, sumCount);
        classRecord[classCount].recordContent[sumCount - 1].recordName := tRecordInfoArr[i].recordName;
        classRecord[classCount].recordContent[sumCount - 1].StarTime := tRecordInfoArr[i].StarTime;
        classRecord[classCount].recordContent[sumCount - 1].Endtime := tRecordInfoArr[i].Endtime;
        classRecord[classCount].recordContent[sumCount - 1].costTime := classRecord[classCount].recordContent[sumCount - 1].Endtime - classRecord[classCount].recordContent[sumCount - 1].StarTime
      end
      else
      begin
        Inc(sleepCount);
        SetLength(classRecord[1].recordContent, sleepCount);
        classRecord[1].recordContent[sleepCount - 1].recordName := tRecordInfoArr[i].recordName;
        classRecord[1].recordContent[sleepCount - 1].StarTime := tRecordInfoArr[i].StarTime;
        classRecord[1].recordContent[sleepCount - 1].Endtime := tRecordInfoArr[i].Endtime;
        classRecord[1].recordContent[sleepCount - 1].costTime := classRecord[1].recordContent[sleepCount - 1].Endtime - classRecord[1].recordContent[sleepCount - 1].StarTime;
      end;
    end;
    //cost
    len := Length(classRecord);
    sumcost := 0;
    for i := 0 to len - 1 do
    begin
      count := Length(classRecord[i].recordContent);
      for j := 0 to count - 1 do
      begin
        sumcost := sumcost + classRecord[i].recordContent[j].costTime;
      end;
      classRecord[i].costTime := sumcost;
      sumcost := 0;
    end;
  finally
    dTlb.free;
    dayObj.Free;
    classObj.Free;
  end;

end;

{function TTask.GetActivetyInfo(dbPath: string; var activeTyInfo: TArrActiveTyInfo; starTime: string; endTime: string): Integer;
const
  frmSelect = '';
var
  sSql, tempS: string;
  nowD: Double;
  Len, len1, I, star, cost: Integer;
  dbObj, dbObj1: TDbObj;
  tdlb, tdlb1: TFDMemTable;
begin
  Exit;
  tempS := StringReplace(dbPath, ExtractFileDir(mangerDbPath) + '\EveryDay\', '', [rfReplaceAll]);
  tempS := StringReplace(tempS, '.db', '', [rfReplaceAll]) + ' 23:59:59';
  nowD := VarToDateTime(tempS);
  // interval
  if starTime = '' then
  begin
    starTime := FormatDateTime('YYYY-MM-DD 00:00:00', nowD)
  end;
  if endTime = '' then
  begin
    endTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', nowD)
  end;
  dbObj := TDbObj.Create;
  dbObj1 := TDbObj.Create;
  dbObj.OpenDb(dbPath, 'SQLite');
  dbObj1.OpenDb(dbPath, 'SQLite');
  star := GetTickCount;
  //recordInfo
  sSql := 'select *, count(*) from pc_process_record group by action_process  having count(*)>1 and record_startime > ''' + starTime + ''' and record_startime < ''' + endTime + '''';
  tdlb := dbObj.QuerySql(sSql);
  cost := GetTickCount - star;
 // Mylog.writeWorkLog(IntToStr(cost), -1);
  Len := tdlb.SourceView.Rows.Count;
  sSql := 'select *, count(*) from internet_record group by  url  having count(*)>1 and record_startime > ''' + starTime + ''' and record_startime < ''' + endTime + '''';
  star := GetTickCount;
  tdlb1 := dbObj1.QuerySql(sSql);
  len1 := Len + tdlb1.SourceView.Rows.Count;
  SetLength(activeTyInfo, len1);
  for I := 0 to Len - 1 do
  begin
    activeTyInfo[I].activety := tdlb.FieldByName['action_process'];
    activeTyInfo[I].costime := gMm.activeProInterval * (strtofloat(tdlb.FieldByName['count(*)'])); //s;
    tdlb.Next;
  end;
  for I := Len to len1 - 1 do
  begin
    activeTyInfo[I].activety := tdlb1.FieldByName['url'];
    activeTyInfo[I].costime := gMm.activeProInterval * (strtofloat(tdlb1.FieldByName['count(*)'])); //s
    tdlb1.Next;
  end;

  // type
  Len := Length(activeTyInfo);
  dbObj.OpenDb(classPath, 'SQLite');
  for I := 0 to Len - 1 do
  begin
    activeTyInfo[I].activety := ChecekUrl(activeTyInfo[I].activety);
   // ssql := 'select * from record_class  where urlApplication like ''' + '%' + UnicodeToUTF8String(activeTyInfo[I].activety) + '%''';
    sSql := 'select * from record_class  where urlApplication  = ''' + UnicodeToUTF8String(activeTyInfo[I].activety) + '''COLLATE NOCASE';
    tdlb := dbObj.QuerySql(sSql);
    FError.errorCode := 0;
    if FError.errorCode < 0 then
    begin
      FError.errorMsg := 'query record_class fail';
      Exit;
    end;
    if tdlb.SourceView.Rows.Count <= 0 then
    begin
      activeTyInfo[I].activetype := '';
      activeTyInfo[I].activeContent := '';
    end
    else
    begin
      activeTyInfo[I].activetype := tdlb.FieldByName['urlAppclass'];
      activeTyInfo[I].activeContent := tdlb.FieldByName['remarks'];
    end;
  end;
  dbObj.Free;
  dbObj1.Free;
end;
 }
function TTask.GetBrowerPath(var myborwerInfo: TBrowerInfo): Integer;
var
  p: PChar;
  num: DWORD;
  userN: string;
begin
  num := 0;
  GetUserName(nil, num);
  GetMem(p, num);
  GetUserName(p, num);
  userN := PChar(p);
  FreeMem(p);
  //谷歌
  myborwerInfo.historyPath := 'C:\Users\' + userN + '\AppData\Local\Google\Chrome\User Data\Default\History';
  myborwerInfo.bookmarksPath := 'C:\Users\' + userN + '\AppData\Local\Google\Chrome\User Data\Default\Bookmarks';
  myborwerInfo.passwordPath := 'C:\Users\' + userN + '\AppData\Local\Google\Chrome\User Data\Default\Login Data';
  if not FileExists(myborwerInfo.historyPath) then
  begin
  end;
  if not FileExists(myborwerInfo.bookmarksPath) then
  begin

  end;
  if not FileExists(myborwerInfo.passwordPath) then
  begin

  end;
end;

procedure TTask.GetClassRecord(startime, endtime: Double; var RecordList: TList);
var
  ruleDb: TDbObj;
  i, j, len, count, blankCount, valueTag, valueSum, valueCount, sleepCount, classCount, tClassCount, iRuleType, sumCount: integer;
  tlb, dtlb: TFDMemTable;
  sql, sClassName, tstartime, tendtime, sRecordName, sLastRecordName, sError: string;
  dStarTime, dEndTime, dTemp, dTemp1, sumCost, sumcost1, interuptTime, dNow: Double;
  reInfo: TArrRecordtyInfo;
  PRecord, tPRecord: PRecordInfo;
  trecordList: TList;
  tValue: boolean;
begin
  interuptTime := VarToDateTime('00:00:30') * 20;
  valueSum := 10;
  valueCount := 0;
  sleepCount := 0;
  blankCount := 0;
  sumcost1 := 0;
  tstartime := FormatDateTime('YYYY-MM-DD HH:MM:SS', startime);
  tendtime := FormatDateTime('YYYY-MM-DD HH:MM:SS', endtime);
  trecordList := TList.Create;
  ruleDb := TDbObj.Create;
  try
    ruleDb.OpenDb(rulePath, 'SQLite');
    sql := 'select  * from   valuetime_record where star_time >= ''' + tstartime + ''' and stop_time <= ''' + tendtime + '''';
    dtlb := myRecord.DayDbObj.QuerySql(sql);
    len := dtlb.SourceView.Rows.Count;
    dEndTime := startime;
    try
      for i := 0 to len - 1 do
      begin
        if (dtlb.FieldByName('star_time').asstring <> '') and (dtlb.FieldByName('stop_time').asstring <> '') then
        begin
          dTemp := VarToDateTime(dtlb.FieldByName('star_time').asstring);
          if (dEndTime >= startime) and (dTemp - dEndTime > 0) then
          begin
            Inc(blankCount);
            SetLength(reInfo, blankCount);
            reInfo[blankCount - 1].startime := dEndTime;
            reInfo[blankCount - 1].endtime := dTemp;
            reInfo[blankCount - 1].costTime := dTemp - dEndTime;
            reInfo[blankCount - 1].recordName := 'blank';
            reInfo[blankCount - 1].recordTitle := '';
            reInfo[blankCount - 1].classType := '';
            reInfo[blankCount - 1].ruleType := 0;
            reInfo[blankCount - 1].valueTag := False;
          end;
          dEndTime := VarToDateTime(dtlb.FieldByName('stop_time').asstring);
        end;
        dtlb.Next;
      end;
    except
    end;
    GetActiveRecordClass(tstartime, tendtime, reInfo);
    count := Length(reInfo);
    if count <= 0 then
      Exit;
    for i := 0 to count - 1 do
    begin
      New(PRecord);
      PRecord.starTime := reInfo[i].startime;
      PRecord.endTime := reInfo[i].endtime;
      PRecord.recordName := reInfo[i].recordName;
      PRecord.recordTitle := reInfo[i].recordTitle;
      PRecord.costTime := reInfo[i].costTime;
      PRecord.valueTag := reInfo[i].valueTag;
      PRecord.classType := reInfo[i].classType;
      PRecord.ruleType := reInfo[i].ruleType;
      trecordList.Add(PRecord);
      //sError := Format('stratime %s, end %s, ruletype %d', [FormatDateTime('YYYY-MM-DD HH:MM:SS', PRecord.starTime), FormatDateTime('YYYY-MM-DD HH:MM:SS', PRecord.endTime), PRecord.ruleType]);
     // Mylog.writeWorkLog(sError, -1);
    end;
    Sort(trecordList, 1, 1);
    count := trecordList.Count;
    sRecordName := '';
    sLastRecordName := '';
    dEndTime := PRecordInfo(trecordList.Items[count - 1]).startime;
    dTemp := PRecordInfo(trecordList.Items[0]).startime;
    for i := 0 to count - 1 do
    begin
      tPRecord := PRecordInfo(trecordList.Items[i]);
      sRecordName := ChecekUrl(tPRecord.recordName);
      dStarTime := tPRecord.startime;
     // sError := Format('stratime %s, end %s, ruletype %d', [FormatDateTime('YYYY-MM-DD HH:MM:SS', tPRecord.starTime), FormatDateTime('YYYY-MM-DD HH:MM:SS', tPRecord.endTime), tPRecord.ruleType]);
      //Mylog.writeWorkLog(sError, -1);
      if (sLastRecordName <> '') and (dEndTime - dTemp > 0) then
      begin
        if sRecordName <> sLastRecordName then
        begin
          New(PRecord);
          begin
            PRecord.recordName := sLastRecordName;
          end;
          PRecord.starTime := dTemp;
          PRecord.endTime := dEndTime;
          PRecord.costTime := PRecord.endTime - PRecord.starTime;
          PRecord.recordName := sLastRecordName;
          PRecord.recordTitle := tPRecord.recordTitle;
          PRecord.valueTag := tValue;
          PRecord.classType := sClassName;
          PRecord.ruleType := iRuleType;
          RecordList.Add(PRecord);
          dTemp := dEndTime;
        end
        else
        begin
          if (tPRecord.ruleType <> iRuleType) then
          begin
            New(PRecord);
            PRecord.starTime := dTemp;
            PRecord.endTime := dEndTime;
            PRecord.costTime := PRecord.endTime - PRecord.starTime;
            PRecord.recordName := sLastRecordName;
            PRecord.recordTitle := tPRecord.recordTitle;
            PRecord.valueTag := tValue;
            PRecord.classType := sClassName;
            PRecord.ruleType := iRuleType;
            RecordList.Add(PRecord);
            dTemp := dEndTime;
          end;
        end;
      end;
      sLastRecordName := sRecordName;
      dEndTime := tPRecord.endtime;
      tValue := tPRecord.valueTag;
      iRuleType := tPRecord.ruleType;
      sClassName := tPRecord.classType;
    end;
    dTemp := PRecordInfo(trecordList.Items[0]).startime;
    dEndTime := PRecordInfo(trecordList.Items[trecordList.Count - 1]).endtime;
    if dTemp > startime then
    begin
      New(PRecord);
      PRecord.starTime := startime;
      PRecord.endTime := dTemp;
      PRecord.costTime := PRecord.endTime - PRecord.starTime;
      PRecord.recordName := 'blank';
      PRecord.recordTitle := '';
      PRecord.valueTag := False;
      PRecord.classType := '';
      PRecord.ruleType := 0;
      RecordList.Add(PRecord);
    end;
    if dEndTime < endtime then
    begin
      New(PRecord);
      PRecord.starTime := dEndTime;
      PRecord.endTime := endtime;
      PRecord.costTime := PRecord.endTime - PRecord.starTime;
      PRecord.recordName := 'blank';
      PRecord.recordTitle := '';
      PRecord.valueTag := False;
      PRecord.classType := '';
      PRecord.ruleType := 0;
      RecordList.Add(PRecord);
    end;
    Sort(RecordList, 1, 2);
    count := trecordList.Count;

  finally
    tlb.Free;
    dtlb.Free;
    ruleDb.Free;

    for i := 0 to count - 1 do
    begin
      Dispose(PRecordInfo(trecordList[i]));
    end;
    trecordList.Clear;
    trecordList.Free;
  end;
end;

function TTask.FindSonJs(s: string; folder: string): Integer;
{const
  fmtInsert = 'INSERT OR IGNORE INTO bookmarkDirctory VALUES(%d,''%s'',%f,%f,%d,''%s'',''%s'',''%s'')';
var
  s1: string;
  jo: ISuperObject;
  item: TSuperObjectIter;
  key: Integer;
  sqlS: string;
  myBookmarkDir: TBookmarkDir;
  unixTimeDouble: Double;
  star, stop: integer; }
begin
 { jo := so(s);
  if ObjectFindFirst(jo, item) then
    repeat

      if item.key = 'date_added' then
      begin
        unixTimeDouble := StrToInt64(item.val.AsString) / 1000000;
        s1 := FormatDatetime('YYYY/MM/DD HH:MM:SS', UnixToDateTime(unixTimeDouble));
        myBookmarkDir.date_added := UnixToDateTime(unixTimeDouble);
      end
      else if (item.key = 'date_modified') then
      begin

        unixTimeDouble := StrToInt64(item.val.AsString) / 1000000;
        s1 := FormatDatetime('YYYY/MM/DD HH:MM:SS', UnixToDateTime(unixTimeDouble));
        myBookmarkDir.date_modified := UnixToDateTime(unixTimeDouble);
      end
      else if (item.key = 'id') then
      begin
        myBookmarkDir.id := item.val.AsInteger;
      end
      else if (item.key = 'name') then
      begin
        myBookmarkDir.name := item.val.AsString;
        myBookmarkDir.name := StringReplace(myBookmarkDir.name, '''', '', [rfReplaceAll]);
        myBookmarkDir.name := UnicodeToUTF8String(StringReplace(myBookmarkDir.name, '"', '', [rfReplaceAll]));
      end
      else if (item.key = 'sync_transaction_version') then
      begin
        myBookmarkDir.sync_transaction_version := item.val.AsInteger;
      end
      else if (item.key = 'type') then
      begin
        myBookmarkDir.bookmarkType := item.val.AsString;
      end;
     // Memo1.Lines.Add(Format('key: %s; val: %s', [item.key, item.val.AsString]));
    until not ObjectFindNext(item);
  ObjectFindClose(item);
  myBookmarkDir.owner := 'roots';
  myBookmarkDir.internetType := 'GOOGLE';

  // add db sqlite
  sqlS := Format(fmtInsert, [myBookmarkDir.id, myBookmarkDir.internetType, myBookmarkDir.date_modified, myBookmarkDir.date_added, myBookmarkDir.sync_transaction_version, myBookmarkDir.bookmarkType, (myBookmarkDir.name), myBookmarkDir.owner]);

  star := gettickcount;
  myTaskDb.ExcuteSql(sqlS);
  //children
  stop := gettickcount - star;
//  memo1.lines.add('耗时' + inttostr(stop));
  Bookmarkurl(s, folder);  }
end;

function TTask.Bookmarkurl(s: string; folder: string): Integer;
{const
  fmtInsert = 'INSERT OR IGNORE INTO bookmarkDirctory VALUES(%d,''%s'',%f,%f,%d,''%s'',''%s'',''%s'')';
  fmtInsert1 = 'INSERT OR IGNORE INTO bookmarkUrl VALUES(%d, %d, %f,''%s'' ,''%s'',''%s'',''%s'')';
var
  sNode, temp: string;
  jo: ISuperObject;
  item: TSuperObjectIter;
  ja: TSuperArray;
  len, i, j: Integer;
  myBookmarkDir: TBookmarkDir;
  myBookmark: TBookmark;
  sqlS: string;
  unixTimeDouble: Double; }
begin
 { jo := SO(s);
  ja := jo['children'].AsArray;
  len := ja.Length;
  sqlS := '';
  for i := 0 to len - 1 do
  begin
    sNode := ja.S[i];
    jo := SO(sNode);
    temp := jo.S['type'];
    if temp = 'folder' then
    begin
      myBookmarkDir.id := jo.I['id'];
      myBookmarkDir.internetType := jo.S['internetType'];
      myBookmarkDir.bookmarkType := 'folder';
      temp := jo.S['name'];
      temp := StringReplace(temp, '''', '', [rfReplaceAll]);
      temp := StringReplace(temp, '"', '', [rfReplaceAll]);
      myBookmarkDir.name := UnicodeToUTF8String(temp);
      myBookmarkDir.owner := jo.S['owner'];
      myBookmarkDir.sync_transaction_version := jo.I['sync_transaction_version'];
      unixTimeDouble := jo.I['date_modified'] / 1000000;
      myBookmarkDir.date_modified := UnixToDateTime(unixTimeDouble);
      unixTimeDouble := jo.I['date_added'] / 1000000;
      myBookmarkDir.date_added := UnixToDateTime(unixTimeDouble);
      myBookmarkDir.owner := folder;
      myBookmarkDir.internetType := 'GOOGLE';
      // add db sqlite
      sqlS := Format(fmtInsert, [myBookmarkDir.id, myBookmarkDir.internetType, myBookmarkDir.date_modified, myBookmarkDir.date_added, myBookmarkDir.sync_transaction_version, myBookmarkDir.bookmarkType, (myBookmarkDir.name), myBookmarkDir.owner]);
      myTaskDb.ExcuteSql(sqlS);
      Bookmarkurl(sNode, myBookmarkDir.name);
    end
    else
    begin
      myBookmark.id := jo.I['id'];
      myBookmark.sync_transaction_version := jo.I['sync_transaction_version'];
      unixTimeDouble := jo.I['date_added'] / 1000000;
      myBookmark.date_added := UnixToDateTime(unixTimeDouble);
      myBookmark.url := jo.S['url'];
      myBookmark.bookmarkType := jo.S['type'];
      temp := jo.S['name'];
      temp := StringReplace(temp, '''', '', [rfReplaceAll]);
      temp := StringReplace(temp, '"', '', [rfReplaceAll]);
      myBookmark.name := UnicodeToUTF8String(temp);
      myBookmark.owner := folder;
      sqlS := Format(fmtInsert1, [myBookmark.id, myBookmark.sync_transaction_version, myBookmark.date_added, (myBookmark.name), myBookmark.url, myBookmark.bookmarkType, myBookmark.owner]);
      myTaskDb.ExcuteSql(sqlS);
      // add db sqlite

    end;
  end;  }
end;

function TTask.HighistorySynchronize(historyPath: string): Integer;
const
  fmtInsert = 'INSERT OR IGNORE INTO passwordTb (''origin_url'',''username_value'',''password_value'',''create_time'') VALUES(''%s'',''%s'',''%s'',''%s'')';
var
  sqlS: string;
  s: string;
  mem: TMemoryStream;
  pc1: PChar;
  i: Integer;
  TTaskDb: TDbObj;
  tHistoryPath: string;
  passwordInfo: TPassword;
  unixTimeDouble: Double;
  tlb: TFDMemTable;
begin
  tHistoryPath := tempDir + '\history.db';
  CopyFile(PChar(historyPath), PChar(tHistoryPath), False);

  TTaskDb := TDbObj.Create;
  TTaskDb.OpenDb(tHistoryPath, 'SQLite');
  sqlS := 'SELECT * FROM logins where origin_url <> ''''';
  tlb := TTaskDb.QuerySql(sqlS);
  for i := 0 to tlb.SourceView.Rows.Count - 1 do
  begin

    Mylog.writeWorkLog(tlb.FieldByName('origin_url').asstring);
    mem := TMemoryStream.Create;
    //mem := TTaskDb.tlb.FieldAsBlob(tlb.FieldIndex['password_value']);
    mem.Position := 0;
    s := DecryptRDPPassword_men(mem);
    passwordInfo.password_value := s;
    passwordInfo.origin_url := tlb.FieldByName('origin_url').asstring;
    passwordInfo.username_value := tlb.FieldByName('username_value').asstring;
   // passwordInfo.create_time := UnixToDateTime((tlb.FieldAsInteger(9) / 1000000));
    sqlS := Format(fmtInsert, [passwordInfo.origin_url, passwordInfo.username_value, passwordInfo.password_value, FloatToStr(passwordInfo.create_time)]);
    myTaskDb.ExcuteSql(sqlS);
    mem.Free;
    tlb.Next;
  end;
  TTaskDb.Free;
end;

function TTask.PasswordSynchronize(passwordPath: string): Integer;
const
  fmtInsert = 'INSERT OR IGNORE INTO passwordTb (''origin_url'',''username_value'',''password_value'',''create_time'') VALUES(''%s'',''%s'',''%s'',''%s'')';
var
  sqlS: string;
  s: string;
  mem: TMemoryStream;
  pc1: PChar;
  i: Integer;
  TTaskDb: TDbObj;
  tPasswordPath: string;
  passwordInfo: TPassword;
  unixTimeDouble: Double;
  tlb: TFDMemTable;
begin
  tPasswordPath := tempDir + '\password.db';
  CopyFile(PChar(passwordPath), PChar(tPasswordPath), False);
  TTaskDb := TDbObj.Create;
  TTaskDb.OpenDb(tPasswordPath, 'SQLite');
  sqlS := 'SELECT * FROM logins where origin_url <> ''''';
  tlb := TTaskDb.QuerySql(sqlS);
  for i := 0 to tlb.SourceView.Rows.Count - 1 do
  begin
    Mylog.writeWorkLog(tlb.FieldByName('origin_url').asstring);
    mem := TMemoryStream.Create;
   // mem := TTaskDb.tlb.FieldAsBlob(tlb.FieldIndex['password_value']);
    mem.Position := 0;
    s := DecryptRDPPassword_men(mem);
    passwordInfo.password_value := s;
    passwordInfo.origin_url := tlb.FieldByName('origin_url').asstring;
    passwordInfo.username_value := tlb.FieldByName('username_value').asstring;
   // passwordInfo.create_time := UnixToDateTime((tlb.FieldAsInteger(9) / 1000000));
  //  sqlS := Format(fmtInsert, [passwordInfo.origin_url, passwordInfo.username_value, passwordInfo.password_value, FloatToStr(passwordInfo.create_time)]);
    myTaskDb.ExcuteSql(sqlS);
    mem.Free;
    tlb.Next;
  end;

  TTaskDb.Free;
end;

function TTask.QueryClassItem(itemName: string): TClassType;
const
  frmSelect = 'select * from record_class  where urlApplication like ''%s''';
  frmInsert = 'INSERT INTO record_class (''urlApplication'',''urlAppclass'',''remarks'',''class'' ) VALUES(''%s'',''%s'',''%s'',''%s'')';
  fmtUpt = 'update record_class set urlAppclass = ''%s'', remarks = ''%s'', class = ''%s'' where urlApplication = ''%s''';
var
  sql: string;
  tlb: TFDMemTable;
begin
  sql := Format(frmSelect, [(itemName)]);
  tlb := ttDbObj.QuerySql(sql);
  FError.errorCode := 401;
  if FError.errorCode < 0 then
  begin
    FError.errorMsg := 'query record_class fail';
    Exit;
  end
  else
  begin
    if tlb.SourceView.Rows.Count = 1 then
    begin
      Result.urlApplication := tlb.FieldByName('urlApplication').asstring;
      Result.urlAppRemarks := tlb.FieldByName('remarks').asstring;
      Result.urlAppclass := tlb.FieldByName('urlAppclass').asstring;
      Result.className := tlb.FieldByName('class').asstring;
    end;
  end;
  tlb.free;
end;

function TTask.RecordTask(activeProInterval: Integer; valueInterval: Integer): TError;
var
  errorS: string;
begin
  //记录活动
  Workers.Post(ActiveRecord, activeProInterval * Q1Second, nil);
  Workers.Post(ValueRecord, valueInterval * Q1Second, nil);
  Result := FError;
end;

function TTask.GetLastError: TError;
begin
  Result := FError;
end;

function TTask.GetProcessList(reInfo: TArrRecordtyInfo): TStringList;
var
  count, iCount, i, postion: Integer;
  costTime, sumTime: Double;
  sReocrname, tProcessInfo: string;
  sRecorList: TStringList;
  arrActiveTyInfo: TArrRecordInfo;
begin
  sRecorList := TStringList.Create;
  Result := TStringList.Create;     // 哈希表
  iCount := 0;
  count := Length(reInfo);
  for i := 0 to count - 1 do
  begin
    sReocrname := ChecekUrl(reInfo[i].recordName);
    if (sReocrname <> '') then
    begin
      if (CheckSameRecord(sRecorList, sReocrname, postion)) then
      begin
        costTime := reInfo[i].costTime;
        arrActiveTyInfo[postion].cost := arrActiveTyInfo[postion].cost + costTime;
        Result.Values[sReocrname] := FloatToStr(StrToFloat(Result.Values[sReocrname]) + costTime);
      end
      else
      begin
        costTime := reInfo[i].costTime;
        tProcessInfo := sReocrname + '=' + FloatToStr(costTime);
        Result.Add(tProcessInfo);
        sRecorList.Add(sReocrname);
        Inc(iCount);
        SetLength(arrActiveTyInfo, iCount);
        arrActiveTyInfo[iCount - 1].activeTyInfo := sReocrname;
        arrActiveTyInfo[iCount - 1].cost := costTime;
      end;
    end;
  end;
  sRecorList.Clear;
  sRecorList.Free;
end;

function TTask.GetProcessListType(reInfo: TArrRecordtyInfo): TArrRecordInfo;
var
  count, iCount, i, postion: Integer;
  costTime, sumTime: Double;
  sReocrname, sReocrType, tProcessInfo, sql: string;
  sRecorList: TStringList;
  tlb: TFDMemTable;
begin
  sRecorList := TStringList.Create;
  iCount := 0;
  count := Length(reInfo);
  try
    for i := 0 to count - 1 do
    begin
      sReocrname := ChecekUrl(reInfo[i].recordName);
      if (sReocrname <> '') then
      begin
        if (CheckSameRecord(sRecorList, sReocrname, postion)) then
        begin
          costTime := reInfo[i].costTime;
          Result[postion].cost := result[postion].cost + costTime;
        end
        else
        begin
          costTime := reInfo[i].costTime;
          sRecorList.Add(sReocrname);
          Inc(iCount);
          SetLength(result, iCount);
          result[iCount - 1].activeTyInfo := sReocrname;
          result[iCount - 1].cost := costTime;
        end;
      end;
    end;
    ttDbObj.OpenDb(classPath, 'SQLite');
    count := Length(Result);
    for i := 0 to count - 1 do
    begin
      sReocrname := result[i].activeTyInfo;
      sql := 'select * from record_class  where urlApplication  = ''' + sReocrname + ''' COLLATE NOCASE';
      tlb := ttDbObj.QuerySql(sql);
      if tlb.SourceView.Rows.Count = 1 then
      begin
        sReocrType := (tlb.FieldByName('urlAppclass').asstring);
      end
      else
      begin
        sReocrType := '';
      end;
      tProcessInfo := sReocrname + '=' + sReocrType;
      result[i].classType := sReocrType;
      tlb.Free;
    end;
  finally
    sRecorList.Clear;
    sRecorList.Free;
  end;

end;

function TTask.SetItemType(itemName, itemType: string; itemContent: string; classname: string): Integer;
const
  frmSelect = 'select * from record_class  where urlApplication like ''%s''';
  frmInsert = 'INSERT INTO record_class (''urlApplication'',''urlAppclass'',''remarks'',''class'' ) VALUES(''%s'',''%s'',''%s'',''%s'')';
  fmtUpt = 'update record_class set urlAppclass = ''%s'', remarks = ''%s'', class = ''%s'' where urlApplication = ''%s''';
var
  sql: string;
  tlb: TFDMemTable;
  sTemp1: utf8string;
  sTemp: ansistring;
begin
  sql := Format(frmSelect, [(itemName)]);
  tlb := ttDbObj.QuerySql(sql);
  FError.errorCode := 401;
  if FError.errorCode < 0 then
  begin
    FError.errorMsg := 'query record_class fail';
    Exit;
  end
  else
  begin
    if tlb.SourceView.Rows.Count > 0 then
    begin
      sTemp := itemType;
      sql := Format(fmtUpt, [(itemType), (itemContent), (classname), (itemName)]);
      ttDbObj.ExcuteSql(sql);
      FError := GetLastError;
      if FError.errorCode < 0 then
      begin
        FError.errorMsg := 'update record_class fail';
        Exit;
      end;
    end
    else
    begin
      sql := Format(frmInsert, [(itemName), UTF8Encode(itemType), (itemContent), (classname)]);
      ttDbObj.ExcuteSql(sql);
      FError := GetLastError;
      if FError.errorCode < 0 then
      begin
        FError.errorMsg := 'insert record_class fail';
        Exit;
      end;
    end;
  end;
  FError.errorCode := 0;
  tlb.free;
end;

function TTask.SetTaskInfo(taskInfo: TTaskInfo): Integer;
begin

end;

function TTask.StatisticsRecord: Integer;
begin

end;

procedure TTask.StatisticsTask(AJob: PQJob);
begin

end;
// 切换sqlite数据库

procedure TTask.SwitchayTask;
const
  fmtUpt = 'update mydb_info set tableStatus = %d  where dbPath = ''%s''';
var
  i, len, len1, taskId, taskStatus, sumCost, delayT: Integer;
  dnow, tnow, tDDay: Double;
  nows, tnows, tdayRecordDbPath, tsDay, tsDay1, errorS, sql, dayDbPath: string;
  recordInfo: TRecordInfo;
  dbPathString: TStringList;
  tmTaskInfo: TTaskInfo;
  tag: Boolean;
  tMagerDbobj: tdbobj;
  tlb: TFDMemTable;
begin
  tag := False;
  dbPathString := TStringList.Create;
  // 切换数据库
  tnows := FormatDateTime('23:58:00', Now());
 // tNows := FormatDateTime('00:18:00', Now());
  tnow := VarToDateTime(tnows);
  dnow := Now - Trunc(now);
  if ((dnow - tnow) > 0) and (FCheckCount = 0) then
  begin
    tsDay := ExtractFileName(dayRecordDbPath);
    tsDay := StringReplace(tsDay, '.db', '', [rfReplaceAll]);
    tDDay := VarToDateTime(tsDay) + 1;
    tsDay1 := FormatDateTime('yyyy-mm-dd', tDDay);
    dayRecordDbPath := StringReplace(dayRecordDbPath, tsDay, tsDay1, [rfReplaceAll]);
    tag := True;
    FCheckTag := true;
  end;
  if FCheckTag then
  begin
    Workers.DisableWorkers;
  // 停止所有工作者  检查所有是否未完成任务。完成所有统计，上传，过期任务。
    tDDay := Now;
    //昨日任务
    tsDay1 := FormatDateTime('yyyy-mm-dd 00:00:00', tDDay);
    sql := ' select * from mydb_info where tableStatus = 0 and dbtype=''pcrecord''   and createTime<''' + tsDay1 + '''';
    tMagerDbobj := tdbobj.create;
    tMagerDbobj.OpenDb(mangerDbPath, 'SQLite');
    tlb := tMagerDbobj.QuerySql(sql);
    if FError.errorCode <> SUS_QUERY then
    begin
      errorS := Format('Overdue task fail：执行sql %s失败', [sql]);
      Mylog.writeWorkLog(errorS, ERROELOG);
    end;
    len := tlb.SourceView.Rows.Count;
    if len > 0 then
    begin
      //判断文件目录是否存在
      tsDay1 := FormatDateTime('yyyy-mm-dd', tDDay);
      tdayRecordDbPath := StringReplace(dayRecordDbPath, tsDay, tsDay1, [rfReplaceAll]);
      for i := 0 to len - 1 do
      begin
        dayDbPath := tlb.FieldByName('dbPath').asstring;
        dbPathString.Add(dayDbPath);
        if FileExists(dayDbPath) then
        begin
         // GetActivetyInfo(dayDbPath, recordInfo.ActiveTyInfo, '', '');
          recordInfoList := recordInfo;
          if not Assigned(frmRecord) then
            Application.CreateForm(tfrmRecord, frmRecord);
          frmRecord.AddComsumelvlist(recordInfoList);
        end
        else
        begin
          CopyFile(PChar(templatesDir + '\date.db'), PChar(dayDbPath), False);
        end;
        tlb.Next;
      end;
      try
      //  len := frmRecord.ListView1.Items.Count;
      except
       //mylog
        exit;
      end;
      if len > 0 then
        frmRecord.Show
      else
      begin
        //update  manager;
        len := dbPathString.Count;
        for i := 0 to len - 1 do
        begin
          sql := Format(fmtUpt, [1, (dbPathString[i])]);
          tMagerDbobj.ExcuteSql(sql);
        end;
      end;
    end;
    //
    if tag then
    begin
      //manager
      dayDbPath := FormatDateTime('yyyy-mm-dd hh:mm:ss', now);
      sql := Format(fmtUpt, [1, (dayDbPath)]);
      tMagerDbobj.ExcuteSql(sql);
      tMagerDbobj.free;
     // playtask
      len := FTaskList.Count;
      for i := 0 to len - 1 do
      begin
        tmTaskInfo := PTaskInfo(FTaskList.Items[i])^;
        tmTaskInfo.taskStatus := 1;
        EditTask(tmTaskInfo);
      end;
     // delay
      tnows := FormatDateTime('YYYY-MM-DD 23:59:59', Now());
   // tNows := FormatDateTime('YYYY-MM-DD 00:19:00', Now());
      tnow := VarToDateTime(tnows);
      dnow := (tnow - NOW) * 3600 * 24;
      delayT := Trunc(dnow * 1000);
      delay(delayT);
      FCheckCount := 0;
      //sqlite
     // myDbObj.Commit_Sqlite;
      if not FileExists(dayRecordDbPath) then
      begin
        CopyFile(PChar(templatesDir + '\date.db'), PChar(dayRecordDbPath), False);
      end;
      nows := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now());
      mylog.writeWorkLog('现在时间' + nows, INFOLOG);
      FTaskList.Clear;
      tag := false;
    end;
    FError := SetEveryDay;
    if FError.errorCode < 0 then
    begin
      errorS := Format('set EverydayTask fail: reason %s,errorCode %d', [FError.errorMsg, FError.errorCode]);
      Mylog.writeWorkLog(errorS, -1);
      Exit;
    end;
   // myDbObj.OpenDb(dayRecordDbPath, 'SQLite');
    nows := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now());
    mylog.writeWorkLog('当前数据库为' + dayRecordDbPath, INFOLOG);
   // myDbObj.BeginTans_Sqlite;
    Workers.EnableWorkers;
    FCheckTag := False;
  end;
end;

function TTask.SwitchDaySqlite(day: string): Integer;
const
  fmtUpt = 'update mydb_info set tableStatus = %d  where dbPath = ''%s''';
var
  tDDay: Double;
  tsDay, sql: string;
  tMagerDbobj: tdbobj;
begin
  //managerSqlite
  tMagerDbobj := tdbobj.create;
  tMagerDbobj.OpenDb(mangerDbPath, 'SQLite');
  tsDay := FormatDateTime('yyyy-mm-dd hh:mm:ss', now);
  sql := Format(fmtUpt, [1, (tsDay)]);
  tMagerDbobj.ExcuteSql(sql);
  tMagerDbobj.free;
  FError := InsertDayTb_Sqlite(mangerDbPath);     //设置数据库索引表。
  //update plantask
  //UpdatePlanTaskTime;

end;

end.

