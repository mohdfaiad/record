unit usDataBaseOperate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Vcl.FileCtrl, uConst, log;

const
  // 数据库SUS400-500,FAIL对应负数.
  SUS_CONNECT = 400;                     //连接数据库成功
  FAIL_CONNECT = -400;              //连接数据库失败
  SUS_QUERY = 401;                   //查询成功
  FAil_QUERY = -401;                 //查询失败
  SUS_DELETE = 402;                  //删除数据库表单成功
  FAil_DELETE = -402;                //删除数据库表单失败
  SUS_CLEAR = 403;                   //清除数据库表单成功
  FAil_CLEAR = -403;                 //清除数据库表单失败
  SUS_INSERT = 404;                  //插入数据库表单成功
  FAil_INSERT = -404;                //插入数据库表单失败
  SUS_UPDATE = 405;                  //插入数据库表单成功
  FAil_UPDATE = -405;                //插入数据库表单失败
  SUS_CREATE = 406;                  //插入数据库表单成功
  FAil_CREATE = -406;                //插入数据库表单失败
  SUS_FILE = 407;                    //数据库文件存在
  FAil_NOTFILE = -407;               //数据库文件不存在
  SUS_SQL = 408;                     // SQL执行成功
  FAil_SQL = -409;                   // SQL执行失败
  DBCONNECT_INFO = 410;              //数据库连接信息
  DBTABLE_INFO = 411;              //数据库中的表名列表
  DBFIELD_INFO = 412;              //数据库中的表中的字段名列表
  ERROR_SQLSENTENCE = -413;         // SQL语句错误
  SUS_EDPASSWORD = 414;              //修改数据库密码成功
  FAIL_EDPASSWORD = -414;              //修改数据库密码失败
  SUS_SETPASSWORD = 415;              //设置数据库密码成功
  FAIL_SETPASSWORD = -415;              //设置数据库密码失败
  SUS_REPASSWORD = 416;              //移除数据库密码成功
  FAIL_REPASSWORD = -416;              //移除数据库密码失败

type
  TFrmUsDatabase = class(TForm)
    fdCon: TFDConnection;
    fdqry: TFDQuery;
    ds: TDataSource;
    dbgrd: TDBGrid;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Edit1: TEdit;
    fdmtbl: TFDMemTable;
    Button3: TButton;
    Memo2: TMemo;
    Label1: TLabel;
    Button4: TButton;
    Button6: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Button5: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure fdConError(ASender, AInitiator: TObject; var AException: Exception);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    FError: TError;
    FCS: TRTLCriticalSection;
    FDbFile, FDbType: string;
    FSqlLogTag: Boolean;
    function EditSqlitePassword(const dbFilePath, dbType, password, newPassword: string): Boolean;   //临界区

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destory();
    function GetLastError(): TError;
    // demo
    procedure OpenDb(const dbFilePath, dbType, password: string);
    procedure CreateTable(const aSql, tableName, password: string);
    function SetPassword(const password: string): Boolean;                     //设置密码
    function ChangePassword(const oldPassword, newPassword: string): Boolean; //改变密码    newPassword 为空表示取消密码
    procedure Excute_Sql(const aSql: string);    //执行sql

    procedure lock();                               // 加锁
    procedure unlock();                             //解锁
    procedure BeginTans_Sqlite;                     //开始事物
    procedure Rollback;                      //回滚
    procedure Sweep();
    procedure Commit_Sqlite;                        //提交
    function GetDbInfo(const dbInfoType: Integer; const tableName: string): TStringList;  //获取数据库信息
    property sqlLogTag: Boolean read FSqlLogTag write FSqlLogTag;
  end;

var
  frmUsDatabase: TFrmUsDatabase;

implementation

{$R *.dfm}

procedure TFrmUsDatabase.BeginTans_Sqlite;
begin
  fdCon.StartTransaction; //开始一个事务
end;

procedure TFrmUsDatabase.Button1Click(Sender: TObject);
var
  list: TStringList;
  db: TSQLiteDatabase;
  aSql: string;
begin
  OpenDb('D:\work\windows\delphi\demo\FD数据库\fddemo.sdb', 'SQLite', '');
  aSql := '';
  CreateTable(aSql, 'MyTable', '');
  aSql := 'INSERT INTO MyTable(Name, Age) VALUES(''1111'', ''222'')';
  frmUsDatabase.Excute_Sql(aSql);
  fdqry.SQL.Text := 'SELECT * FROM MyTable';
  fdcon.Open();
  fdqry.Open();
  dbgrd.Align := alClient;
end;

procedure TFrmUsDatabase.Button3Click(Sender: TObject);
var
  sql: string;
begin
  fdqry.Connection := fdcon;
  ds.DataSet := fdqry;
  dbgrd.DataSource := ds;
  Excute_Sql(Memo2.Text);
end;

procedure TFrmUsDatabase.Button5Click(Sender: TObject);
var
  dir: string;
  dbFile, dbType: string;
begin
  if OpenDialog1.Execute then
  begin
    dbFile := OpenDialog1.FileName;
    dbType := 'SQLite';
    OpenDb(dbFile, dbType, '');
  end
  else
  begin

  end;
end;

{ TUsDatabase }

procedure TFrmUsDatabase.Commit_Sqlite;
begin
  try
    fdCon.Commit;   //提交
  except
    fdCon.Rollback; //回滚
  end;
end;

constructor TFrmUsDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not Assigned(mylog) then
    Mylog := TMyLog.Create('');
  Mylog.writeWorkLog('1111', ErrorLevel);
end;

procedure TFrmUsDatabase.CreateTable(const aSql, tableName, password: string);
var
  tableList: TStringList;
begin
  OpenDb(FDbFile, FDbType, password);
  if FError.errorCode < 0 then
  begin
    Exit;
  end
  else
  begin
    tableList := TStringList.Create;
    tableList := GetDbInfo(DBTABLE_INFO, '');
    if CheckSameItem(tableName, tableList) then
      Exit;
    Excute_Sql(aSql);
    tableList.Free;
  end;
end;

destructor TFrmUsDatabase.Destory;
begin

end;

function TFrmUsDatabase.EditSqlitePassword(const dbFilePath, dbType, password, newPassword: string): Boolean;
var
  sParams: string;
begin
  fdCon.Connected := False;
  try
    fdcon.Params.Clear;
    sParams := 'DriverID=' + dbType;
    fdcon.Params.Add(sParams);
    sParams := 'Database=' + dbFilePath;
    fdcon.Params.Add(sParams);
    fdCon.Connected := True;
    fdqry.Connection := fdcon;
    ds.DataSet := fdqry;
    dbgrd.DataSource := ds;
    fdCon.Connected := False;
  except
    FError.errorCode := FAIL_CONNECT;
    FError.errorMsg := 'db access fail ';
    Exit;
  end;
  FError.errorCode := SUS_CONNECT;
  FError.errorMsg := 'db access success ';
end;

procedure TFrmUsDatabase.Excute_Sql(const aSql: string);
begin
  with TSQLiteStatement.Create(fdcon.CliObj) do
  try
    try
      Prepare(aSql);
    except
      FError.errorCode := ERROR_SQLSENTENCE;
      FError.errorMsg := 'sql sentence  error';
      Exit;
    end;
    Execute;
    while PrepareNextCommand do
      Execute;
    FError.errorCode := SUS_SQL;
    FError.errorMsg := 'sql excute  success';
  finally
    Free;
  end;
end;

procedure TFrmUsDatabase.fdConError(ASender, AInitiator: TObject; var AException: Exception);
var
  sError: string;
begin
  sError := AException.Message;
  Mylog.writeWorkLog(sError, ErrorLevel);
end;

function TFrmUsDatabase.GetDbInfo(const dbInfoType: Integer; const tableName: string): TStringList;
var
  List: TStrings;
  V: Variant;
  sDbInfo: string;
begin
  Result := TStringList.Create;
  if dbInfoType = DBCONNECT_INFO then
  begin
    fdCon.GetInfoReport(Result);
  end
  else if dbInfoType = DBTABLE_INFO then
  begin
    fdCon.GetTableNames('', '', '', Result);
  end
  else if dbInfoType = DBFIELD_INFO then
  begin
    fdCon.GetFieldNames('', '', tableName, '', Result);
  end;
    cmTotal
end;

function TFrmUsDatabase.GetLastError: TError;
begin
  Result := FError;
end;

procedure TFrmUsDatabase.lock;
begin
  EnterCriticalSection(FCS);
end;

procedure TFrmUsDatabase.OpenDb(const dbFilePath, dbType, password: string);
var
  sParams: string;
begin
  if not FileExists(dbFilePath) then
  begin
    FError.errorCode := FAil_NOTFILE;
    FError.errorMsg := 'file is not exist';
    Exit;
  end;
  if fdCon.Connected then
  begin
    fdCon.Connected := False;
  end;
  try
    fdcon.Params.Clear;
    sParams := 'DriverID=' + dbType;
    fdcon.Params.Add(sParams);
    sParams := 'Database=' + dbFilePath;
    fdcon.Params.Add(sParams);
    if password <> '' then
    begin
      sParams := 'Password=' + password;
      fdcon.Params.Add(sParams);
    end;
    fdCon.Connected := True;
    FDbFile := dbFilePath;
    FDbType := dbType;
  except
    FError.errorCode := FAIL_CONNECT;
    FError.errorMsg := 'db access fail ';
    Exit;
  end;
  FError.errorCode := SUS_CONNECT;
  FError.errorMsg := 'db access success ';
end;

procedure TFrmUsDatabase.Rollback;
begin
  fdCon.Rollback; //回滚
end;

function TFrmUsDatabase.SetPassword(const password: string): Boolean;
begin

end;

procedure TFrmUsDatabase.Sweep;
begin

end;

function TFrmUsDatabase.ChangePassword(const oldPassword, newPassword: string): Boolean;
begin
  Result := False;
  fdcon.Params.Clear;
  fdcon.Connected := False;
  try
    fdcon.Params.Add('DriverID=' + FDbType);
    fdcon.Params.Add('Database=' + FDbFile);
    fdcon.Params.Add('Password=' + oldPassword);
    fdcon.Params.Add('NewPassword=' + newPassword); //新密码, 密码为空表示取消密码
    fdcon.Connected := True;
  except
    FError.errorCode := SUS_EDPASSWORD;
    FError.errorMsg := 'change dbpassword fail';
  end;
  FError.errorCode := FAIL_EDPASSWORD;
  FError.errorMsg := 'change dbpassword success';
  fdcon.Connected := False;
  Result := True;
end;

procedure TFrmUsDatabase.unlock;
begin
  LeaveCriticalSection(FCS);
end;

end.

