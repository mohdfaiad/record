unit USqliteManger;

{
  ������sqlite3���ݿ������
  ���ã����ڷ�����ҪOCR������ͼƬ��Ϣ
  ���ڣ�20161022
  ���ߣ�������
}

interface
uses
  SQLite3,SQLiteTable3,SysUtils,Classes,StrUtils, windows;

type

  TMySqlite3 = class
  private
    CS: TRTLCriticalSection;
    sldb: TSQLiteDatabase;
    fdbpath:string;
    function GetDbPath():string;
  public
    datafilePath: string;
    function OpenDbFile(const FileName: string): boolean;

    procedure lock();
    procedure unlock();
    procedure BeginTans;
    procedure Rollback;
    procedure Commit;
    function ExcuteSql(const sql: String): boolean;
    function ReadInt(const sql: String): integer;
    function ReadString(const sql: String): String;
    function ReadStringlist(const sql: String): TStringList;
    function GetTable(const sql: String): TSQLiteTable;
    constructor create;
    destructor destroy;override;
    {
    0:�ɹ�
    1:�Ѿ�����
    -1:ʧ��
    }
    //function pushWaybill(rd:TMyWaybillRecord):Integer;
    //function isExists(no:string):Boolean;
  end;
           {
  TRecTask = Record
    id: integer;
    waybillno: string;//����
	  weight: string;//����
	  bmpPath: string;//ԭͼ·��
	  picPath: string;//ѹ����ͼƬ·��
	  recordTime: string;//��¼����ʱ��
	  status: integer;//״̬ 0-������ 1-jpg�ϴ����; 99-OCR�������
	  pos: string;//����λ����Ϣ
  end;

  }

//var
//  FVaildWaybillList:TStringlist;
var
  gDbOpr: TMySqlite3;

implementation
uses
  Forms;//ULog,UAppReg, ; // ,UnGlobalFun,DateUtils
{ TMySqlite3 }

procedure TMySqlite3.BeginTans;
begin
  sldb.BeginTransaction;
end;

procedure TMySqlite3.Commit;
begin
  sldb.Commit;
end;

constructor TMySqlite3.create;
var
  dbpath:string;
  createSql:string;
  filepath:string;
begin
  {filepath := ExtractFilePath(Application.ExeName) + 'waybills.txt';

  FVaildWaybillList := TStringlist.Create;
  if (FileExists(filepath))then
  begin
     FVaildWaybillList.LoadFromFile(filepath);
  end; }
  InitializeCriticalSection(CS);
  datafilePath := '';
 // dbpath := gMm.OcrDbFileName;
  sldb := TSQLiteDatabase.Create(dbpath);

  
end;

destructor TMySqlite3.destroy;
begin
  sldb.Free;
  DeleteCriticalSection(CS);
  inherited;
end;
         {
//��ȡ���ݿ��·��
function TMySqlite3.DoBackData: Boolean;
var
  time:Int64;
  sqlstr:string;
begin
  //һ��ǰ������ȫ������
  ULog.PrintLog('Sqlite Back ',OPER_INFO);
  time := DateTimeToUnix(DateUtils.IncDay( Now() , -1 ));
  sqlstr := 'INSERT INTO tt_express_bak select * from tt_express where version<=?';
  try
    sldb.ExecSQL(sqlstr,[time]);
    sldb.ExecSQL('delete from tt_express where version<=?',[time]);
  except
    PrintLog('Sqlite Back Error��'+sldb.LastErrorMsg,ERROR_INFO);
  end;
  ULog.PrintLog('Sqlite Back Success',OPER_INFO);
end;   }

function TMySqlite3.ExcuteSql(const sql: String): boolean;
begin
  try
    sldb.ExecSQL(sql, []);
    Result := True;
  except
    Result := False;
  end;
end;

function TMySqlite3.GetDbPath: string;
var
  dir:string;
begin
  dir:= ExtractFilePath(Application.ExeName);
  dir := dir + 'dat';
  if not DirectoryExists(dir) then
  begin
    CreateDir(dir);
  end;
  Result := dir + '\express.dat';
end;             {
//�����ݿ����һ����¼
function TMySqlite3.isExists(no: string): Boolean;
var
  slTable:TSQLiteTable;
begin
  Result := False;
  slTable := sldb.GetTable('SELECT * FROM tt_express WHERE waybillNo=?',[no]);
  if (slTable.RowCount > 0) then
  begin
    Result := True;
    Exit;
  end;
end;   }
function TMySqlite3.GetTable(const sql: String): TSQLiteTable;
begin
  Result := sldb.GetTable(sql, []);
end;

procedure TMySqlite3.lock;
begin
  EnterCriticalSection(CS);
end;

function TMySqlite3.OpenDbFile(const FileName: string): boolean;
begin
  Result := False;
  if FileExists(FileName) then
  begin
    if Assigned(sldb) then
      sldb.Free;
    try
      sldb := TSQLiteDatabase.Create(FileName);
      Result := True;
      datafilePath := FileName;
    except
    end;
  end;
end;

function TMySqlite3.ReadInt(const sql: String): integer;
var
  tbl: TSQLiteTable;
  ret: string;
begin
  Result := -999;
  ret := ReadString(sql);
  if ret <> '' then
    Result := StrToIntDef(ret, Result);
end;

function TMySqlite3.ReadString(const sql: String): String;
var
  tbl: TSQLiteTable;
begin
  tbl := sldb.GetTable(sql, []);
  try
    if tbl.RowCount > 0 then
    try
      Result := tbl.Fields[0];
    except
      Result := '';
    end;
  finally
    tbl.Free;
  end;
end;

function TMySqlite3.ReadStringlist(const sql: String): TStringList;

begin

end;

procedure TMySqlite3.Rollback;
begin
  sldb.Rollback;
end;

procedure TMySqlite3.unlock;
begin
  LeaveCriticalSection(CS);
end;
        {
initialization
  gDbOpr := TMySqlite3.create;

finalization
  gDbOpr.Free;  }

end.