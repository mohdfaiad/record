unit dayAccountBook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, ADODB, Menus, ComCtrls, 
  ExtCtrls, ShellAPI, jpeg, DbOperate, DataView, uTask;

const
  MaxColumns = 7;

type
  TacountBook = class(TForm)
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    Button1: TButton;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    PageControl1: TPageControl;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    pageEat: TTabSheet;
    ListView1: TListView;
    N5: TMenuItem;
    formPage: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    Button2: TButton;
    Panel1: TPanel;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Memo1: TMemo;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    chooseItem: TComboBox;
    edtList: TEdit;
    N13: TMenuItem;
    N71: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    viewPage: TTabSheet;
    Image1: TImage;
    N20: TMenuItem;
    listPopMenu: TPopupMenu;
    N21: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure N2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure ToolBar1Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure edtListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtListChange(Sender: TObject);
    procedure mxLBarHeaders0Buttons1Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure mxLBarHeaders0Buttons3Click(Sender: TObject);
    procedure mxLBarHeaders0Buttons0Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure N10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
    FListViewWndProc1: TWndMethod;
    procedure ListViewWndProc1(var Msg: TMessage);
  public
    { Public declarations }
    procedure AddConsumelist(columnsTitle, total, goodsList, recordDate, guidS: string); // list consume
    procedure AddConsumelist_Title(colnumsList: array of string); // listview 标题头
    procedure AddConsumelist_Content(itemContent: array of string); // listview 内容

    function QueryMonthAccountTotal_Sqlite(sqlS: string; const displayTag: Boolean = True): Integer;   //查询最近记录并统计
    function UpdateSqlite(sqlS: string): Integer;  // 更新与删除
    //已弃用
    function QueryFoodNutrition(s: string): Integer;   //查询最近记录并统计
    function QueryMonthAccountTotal(sqlS: string; const displayTag: Boolean = True): Integer;   //查询最近记录并统计
    function UpdateDb(sqlS: string): Integer;  // 更新与删除
    function StatisticsView(): Integer;        //类别视图
  end;

var
  acountBook: TacountBook;
  backgroundJpeg: TJPEGImage;
  edtcol: integer; //记录EDIT1在Columns中的位置,1-  MaxColumns;
  editem: Tlistitem;
  errorAccount: Integer;

function CustomSortProc(Item1, Item2: TListItem; ColumnIndex: integer): integer; stdcall;

function GetGUID: string;

implementation

{$R *.dfm}

procedure TacountBook.FormCreate(Sender: TObject);
var
  i: Integer;
  appdir: string;
  dbPath: string;
begin
  acountBook.Color := clWhite;
  formPage.TabVisible := False;
  edtList.parent := ListView1;
 //拦载LISTVIEW1鼠标消息
  FListViewWndProc1 := ListView1.WindowProc;
  ListView1.WindowProc := ListViewWndProc1;
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    PageControl1.Pages[i].TabVisible := False;
  end;
  PageControl1.ActivePageIndex := 0;
end;

procedure TacountBook.ListViewWndProc1(var Msg: TMessage);
var
  IsNeg: Boolean;
begin
  try
    ShowScrollBar(ListView1.Handle, SB_HORZ, false);
    //拖动Listview1滚动条时,将EDIT1隐藏起来
    if (msg.Msg = WM_VSCROLL) or (msg.Msg = WM_MOUSEWHEEL) then
      edtList.Visible := false;
    //滚动条消息
    if Msg.Msg = WM_MOUSEWHEEL then
    begin
      if ListView1.Selected = nil then
        exit;
      IsNeg := Short(msg.WParamHi) < 0;
      ListView1.SetFocus;
      if IsNeg then
        SendMessage(edtList.Handle, WM_KEYDOWN, VK_down, 0)
      else
        SendMessage(edtList.Handle, WM_KEYDOWN, VK_up, 0);
    end
    else
      FListViewWndProc1(Msg);
  except
  end;
end;

procedure TacountBook.ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 <> 0 then
  begin
    item.listview.Canvas.Brush.Color := RGB(238, 238, 238);
    item.ListView.Canvas.Font.Color := clblack;
  end;
end;

procedure TacountBook.AddConsumelist(columnsTitle, total, goodsList, recordDate, guidS: string);
var
  item: tlistitem;
begin
  item := listview1.Items.Add;
  item.Caption := columnsTitle;
  item.SubItems.Add(goodsList);
  item.SubItems.Add(total);
  item.SubItems.Add(recordDate);
  item.SubItems.Add(guidS);
end;

procedure TacountBook.N2Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TacountBook.N5Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
end;

procedure TacountBook.Button2Click(Sender: TObject);
const
  fmtInsert = 'INSERT OR IGNORE INTO  accountBook (''userName'',''goodsContent'',''accuntDate'',''goodsTitle'' ,''guidS'',total  ) VALUES( ''%s'',''%s'',''%s'',''%s'',''%s'' , %f)';
var
  sqlS, s, tableName: string;
  accountInfo: array of Variant;
  userName, goodsContent, goodsTitle, guidS, accuntDate: string;
  total: Double;
begin
  //为空
  if chooseItem.Text = '' then
  begin
    chooseItem.SetFocus;
    Exit;
  end;
  if Edit3.Text = '' then
  begin
    Edit3.SetFocus;
    Exit;
  end;
  tableName := 'accountBook';
  //sqlS := 'insert into ' + tableName + '(userName, goodsContent,accuntDate,total,goodsTitle,guidS )values (:0,:1,:2,:3,:4,:5)';
  //表单
  userName := Self.Caption;
  goodsContent := Trim(Memo1.Text);
  accuntDate := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now);
  total := StrToFloat(Trim(Edit3.Text));
  goodsTitle := Trim(chooseItem.Text);
  guidS := GetGUID();                                                            //获得guid
  guidS := StringReplace(guidS, '-', '', [rfReplaceAll]);
  guidS := Copy(guidS, 2, Length(guidS) - 2);
  sqlS := Format(fmtInsert, [AnsiToUtf8(userName), AnsiToUtf8(goodsContent), accuntDate, AnsiToUtf8(goodsTitle), guidS, total]);
 {
  setlength(accountInfo, 6);
  accountInfo[0] := userName;
  accountInfo[1] := goodsContent;
  accountInfo[2] := accuntDate;
  accountInfo[3] := total;
  accountInfo[4] := goodsTitle;
  accountInfo[5] := guidS;
  errorAccount := myDbObj.InsertRecord(sqlS, tableName, accountInfo);
   }

  errorAccount := myTaskDb.ExcuteSql_Sqlite(sqlS);
  s := 'select * from accountBook ';
  QueryMonthAccountTotal_Sqlite(s);
  PageControl1.ActivePageIndex := 0;
end;

function TacountBook.QueryMonthAccountTotal(sqlS: string; const displayTag: Boolean): Integer;
begin


end;

function TacountBook.QueryMonthAccountTotal_Sqlite(sqlS: string; const displayTag: Boolean): Integer;
begin


end;

procedure TacountBook.N7Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL);              //打开计算器
end;

procedure TacountBook.Button5Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  formPage.TabVisible := False;
end;

procedure TacountBook.N12Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL);
end;

procedure TacountBook.N13Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("d",accuntDate,Now())=0';
  ListView1.Clear;
  QueryMonthAccountTotal(s);

end;

procedure TacountBook.N14Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("m",accuntDate,Now())=0';
  QueryMonthAccountTotal(s);
end;

procedure TacountBook.N15Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''食品类'' ';
  QueryMonthAccountTotal(s);
end;

procedure TacountBook.N16Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''日常用品类'' ';
  QueryMonthAccountTotal(s);
end;

procedure TacountBook.ToolBar1Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("w",accuntDate,Now())=0';
  QueryMonthAccountTotal(s);

end;

procedure TacountBook.N71Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("w",accuntDate,Now())=0';
  QueryMonthAccountTotal(s);
end;

procedure TacountBook.N17Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''针纺服饰类'' ';
  QueryMonthAccountTotal(s);
end;

procedure TacountBook.N18Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''生活服务类'' ';
  QueryMonthAccountTotal(s);
end;

procedure TacountBook.N19Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''其他类'' ';
  QueryMonthAccountTotal(s);
end;

function TacountBook.QueryFoodNutrition(s: string): Integer;
begin
 // myDbObj.QueryRecord(s);
 // myDbObj.GetTable_Sqlite(s);
end;

procedure TacountBook.AddConsumelist_Content(itemContent: array of string);
var
  item: tlistitem;
  i, lenContent: Integer;
begin
  // 内容
  lenContent := Length(itemContent);
  item := listview1.Items.Add;
  item.Caption := itemContent[0];
  for i := 1 to lenContent - 1 do
  begin
    item.SubItems.Add(itemContent[i]);
  end;
end;

procedure TacountBook.AddConsumelist_Title(colnumsList: array of string);
var
  len, i: Integer;
begin
  len := Length(colnumsList);
  ListView1.Columns.Clear;
  for i := 0 to len - 1 do
  begin
    ListView1.Columns.Add;
    ListView1.Columns[i].Caption := colnumsList[i];
    ListView1.Columns[i].Width := 150;
  end;

end;

procedure TacountBook.edtListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  item: tlistitem;
  ix, lt, i: integer;
  rect: Trect;
  tempS, S, editField: string;
begin
  try
    if Key = 13 then      //更新数据    enter
    begin
      edtList.Text := Trim(edtList.Text);
      tempS := ListView1.Selected.SubItems.Strings[3];
      if edtcol = 0 then
      begin
        editField := 'goodsTitle';
      end
      else if edtcol = 1 then
      begin
        editField := 'goodsContent';
      end
      else if edtcol = 2 then
      begin
        editField := 'total';
      end;
     // s := 'update liftConsumptionTable set ' + editField + '=''' + edtList.Text + ''' where guidS =''' + tempS + '''';
     // UpdateDb(s);
      s := 'update accountbook set ' + editField + '=''' + edtList.Text + ''' where guidS =''' + tempS + '''';
      UpdateSqlite(s);
      //ShowMessage('更新成功');
     // ShowMsg('更新成功',MES_HINT);
    end;
  //----对上、下、左、右方向键进行处理-----------------
    if (key <> VK_DOWN) and (KEY <> VK_UP) and (KEY <> VK_RIGHT) and (KEY <> VK_LEFT) then
      EXIT;
    if (KEY = VK_RIGHT) then  //键盘右键
    begin
     //按下键盘右键后,判断光标位置是否处于最右边,如果不在最右边,不作处理 EXIT
      if length(edtList.Text) > edtList.SelStart then
        exit;
      item := listview1.Selected;
     //计算edit1位于哪个Columns,如果<最大Columns,+1,否则=1,即转到最左边

      if (edtcol < MaxColumns) then
        edtcol := edtcol + 1
      else
        edtcol := 0;
      lt := 0;

    //从 edtcol值计算出 Columns的位置(Left,width),EDIT1按此设置
      for i := 0 to edtcol - 1 do
        lt := lt + listview1.Columns[i].Width;
      edtList.Left := lt + 1;
      edtList.Width := listview1.Columns[edtcol].Width;
    end;
    if (KEY = VK_left) then  //键盘左键
    begin
      if edtList.SelStart <> 0 then
        exit;
      item := listview1.Selected;
      if (edtcol > 0) then
        edtcol := edtcol - 1
      else
        edtcol := MaxColumns;
      lt := 0;
      for i := 0 to edtcol - 1 do
        lt := lt + listview1.Columns[i].Width;
      edtList.Left := lt + 1;
      edtList.Width := listview1.Columns[edtcol].Width;
    end;
    if (key = VK_DOWN) then     //键盘下键
    begin
      item := listview1.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix >= listview1.Items.Count - 1 then
        exit;
      SendMessage(listview1.Handle, WM_KEYDOWN, VK_down, 0)
    end;
    if (key = VK_UP) then  //键盘上键
    begin
      item := listview1.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix < 1 then
        exit;
      SendMessage(listview1.Handle, WM_KEYDOWN, VK_up, 0)
    end;
    listview1.ItemFocused := listview1.Selected;
    item := listview1.Selected;
    edtList.Visible := false;
    rect := item.DisplayRect(drSelectBounds);
    edtList.SetBounds(edtList.left, rect.Top - 1, edtList.Width, rect.Bottom - rect.Top + 2);
    if edtcol > 0 then
      edtList.Text := item.SubItems[edtcol - 1]
    else
      edtList.Text := item.Caption;
    edtList.Visible := true;
    edtList.SetFocus;

  except
  end;
end;

procedure TacountBook.edtListChange(Sender: TObject);
var
  tempNow, s: string;
  count: Integer;
  item: tlistitem;
begin
  try
    if not edtList.Visible then
      exit;
    if edtcol = 0 then
      ListView1.Selected.Caption := edtList.Text
    else
      ListView1.Selected.SubItems[edtcol - 1] := edtList.Text;

  except
  end;
end;

function TacountBook.UpdateDb(sqlS: string): Integer;
begin

end;

function TacountBook.UpdateSqlite(sqlS: string): Integer;
begin
  myTaskDb.ExcuteSql_Sqlite(sqlS)
end;

function GetGUID: string;
var
  LTep: TGUID;
begin
  CreateGUID(LTep);
  Result := GUIDToString(LTep);
end;

procedure TacountBook.mxLBarHeaders0Buttons1Click(Sender: TObject);
begin
  N13.Click;
end;

procedure TacountBook.N20Click(Sender: TObject);
begin

  //StatisticsView;
end;

procedure TacountBook.mxLBarHeaders0Buttons3Click(Sender: TObject);
begin
  N20.Click;
end;

procedure TacountBook.mxLBarHeaders0Buttons0Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
  formPage.TabVisible := True;
  viewPage.TabVisible := False;
  Edit2.Text := '0';
  Edit3.Text := '0';
  Edit4.Text := '0';
end;

procedure TacountBook.N21Click(Sender: TObject);
var
  s, tempS: string;
begin
  if ListView1.Items.Count <> 0 then
    if ListView1.SelCount > 0 then
    begin
      tempS := ListView1.Selected.SubItems.Strings[3];
      s := 'delete from liftConsumptionTable  where guidS =''' + tempS + '''';
      UpdateDb(s);
      ListView1.DeleteSelected;
    end;
end;
// 视图

function TacountBook.StatisticsView: Integer;
var
  myview: TMyDataView;
  total: Double;
  sonArray: array of Double;
  rect: TRect;
  colorArray: array of Cardinal;
  dbnameArray: array of string;
  s: string;
  display: Boolean;
begin
  {myview := TMyDataView.Create;
  display := False;
  rect.Left := 100;
  rect.Top := 100;
  rect.Right := 220;
  rect.Bottom := 220;
  SetLength(sonArray, 5);
  SetLength(colorArray, 5);
  SetLength(dbnameArray, 5);
  s := 'select sum(total) AS OrderTotal from liftConsumptionTable ';
  QueryMonthAccountTotal(s, display);
  total := ADOQuery1.Fields[0].AsFloat;
  s := 'select sum(total) AS OrderTotal from liftConsumptionTable where goodsTitle = ''食品类'' ';
  QueryMonthAccountTotal(s, display);
  sonarray[0] := ADOQuery1.Fields[0].AsFloat;
  s := 'select sum(total) AS OrderTotal from liftConsumptionTable where goodsTitle = ''日常用品类''';
  QueryMonthAccountTotal(s, display);
  sonarray[1] := ADOQuery1.Fields[0].AsFloat;
  s := 'select sum(total) AS OrderTotal from liftConsumptionTable where goodsTitle = ''针纺服饰类''';
  QueryMonthAccountTotal(s, display);
  sonarray[2] := ADOQuery1.Fields[0].AsFloat;
  s := 'select sum(total) AS OrderTotal from liftConsumptionTable where goodsTitle = ''生活服务类''';
  QueryMonthAccountTotal(s, display);
  sonarray[3] := ADOQuery1.Fields[0].AsFloat;
  s := 'select sum(total) AS OrderTotal from liftConsumptionTable where goodsTitle = ''其他类''';
  QueryMonthAccountTotal(s, display);
  sonarray[4] := ADOQuery1.Fields[0].AsFloat;
  //colorArray[0] := MakeColor(0, 0, 255);
 // colorArray[1] := MakeColor(0, 255, 0);
 // colorArray[2] := MakeColor(255, 66, 222);
 // colorArray[3] := MakeColor(244, 111, 11);
 // colorArray[4] := MakeColor(0, 0, 111);
  dbnameArray[0] := '食品类';
  dbnameArray[1] := '日常用品类';
  dbnameArray[2] := '针纺服饰类';
  dbnameArray[3] := '生活服务类';
  dbnameArray[4] := '其他类';
  PageControl1.ActivePageIndex := 2;
  viewPage.TabVisible := True;
  myview.DrawDataCircleView(total, sonArray, Image1.Canvas.Handle, rect, colorArray);
  rect.Left := rect.Left + 220;
  rect.Right := rect.Right + 220;
  rect.Top := rect.top - 100;
  myview.DisplayDataPercentage(total, sonArray, dbnameArray, rect, Image1.Canvas.Handle, colorArray);
  }
end;

procedure TacountBook.ListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  ListView1.CustomSort(@CustomSortProc, Column.Index);
end;

function CustomSortProc(Item1, Item2: TListItem; ColumnIndex: integer): integer; stdcall;
begin
  if ColumnIndex = 0 then
    Result := CompareText(Item1.Caption, Item2.Caption)
  else
    Result := CompareText(Item1.SubItems[ColumnIndex - 1], Item2.SubItems[ColumnIndex - 1])
end;

procedure TacountBook.N10Click(Sender: TObject);
var
  s: string;
begin
  formPage.TabVisible := False;
  PageControl1.ActivePageIndex := 0;
  s := 'select * from accountBook ';
  ListView1.Clear;
  QueryMonthAccountTotal_Sqlite(s);
end;
//界面居中

procedure TacountBook.FormShow(Sender: TObject);
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;
//listview 编辑

procedure TacountBook.ListView1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rect: Trect;
  p: tpoint;
  wtmp, i: integer;
begin
  try
  //显示编辑控件
    edtList.Visible := false;
  //根据鼠标位置，得到所对应行的LISTITEM
    editem := ListView1.GetItemAt(x, y);
    if editem <> nil then
    begin
   //根据鼠标位置，计算出是哪个 Columns.
      p := editem.Position;
      wtmp := p.X;
      for i := 0 to ListView1.Columns.Count - 1 do
        if (x > wtmp) and (x < (wtmp + ListView1.Column[i].Width)) then
          break  //找到对应的Columns,打断退出，I确定.
        else
          inc(wtmp, ListView1.Column[i].Width);
   //根据I的值，取得 Columns的对应位置。在对应位置按其它的SIZE放EDIT1。
      edtcol := i;
      rect := editem.DisplayRect(drSelectBounds);
      edtList.SetBounds(wtmp - 1, rect.Top - 1, ListView1.Column[i].Width + 1, rect.Bottom - rect.Top + 2);
      if edtcol > 0 then
        edtList.Text := editem.SubItems[i - 1]
      else
        edtList.Text := editem.Caption;
      edtList.Visible := true;
      edtList.SetFocus;
    end;
  except
  end;
end;

end.

