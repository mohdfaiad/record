unit recordVierFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, ADODB, Menus, ComCtrls, 
  ExtCtrls, ShellAPI, jpeg, DbOperate, DataView, uTask, uConst , Mask;

const
  MaxColumns = 7;

type
  TfrmRecord = class(TForm)
    PageControl1: TPageControl;
    pageEat: TTabSheet;
    ListView: TListView;
    edtList: TEdit;
    viewPage: TTabSheet;
   // recordChart: TChart;
   // psrsRecord: TPieSeries;
    Memo1: TMemo;
    Image1: TImage;
 
    procedure ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure N2Click(Sender: TObject);
    procedure NDayClick(Sender: TObject);
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
    procedure mxLBarHeaders0Buttons0Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure ListViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure N10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pngCloseClick(Sender: TObject);
  private
    { Private declarations }
    FListViewWndProc1: TWndMethod;
    procedure ListViewWndProc1(var Msg: TMessage);
    procedure GetUrl(var recordInfoList: TRecordInfo);
    procedure TodayRecord();
    procedure UpdateItem;
    function ChecekUrl(activename: string): string;
    function CheckSameLvsCaption(itemName: string): Boolean;
  public
    { Public declarations }

    procedure AddConsumelist(columnsTitle, total, goodsList, recordDate, guidS: string); // list consume
    procedure AddConsumelist_Title(colnumsList: array of string); // listview ����ͷ
    procedure AddConsumelist_Content(itemContent: array of string); // listview ����
    procedure AddComsumelvlist(recordInfo: TRecordInfo);
    function QueryMonthAccountTotal_Sqlite(sqlS: string; const displayTag: Boolean = True): Integer;   //��ѯ�����¼��ͳ��
    function UpdateSqlite(sqlS: string): Integer;  // ������ɾ��
    //������
    function QueryFoodNutrition(s: string): Integer;   //��ѯ�����¼��ͳ��
    function QueryMonthAccountTotal(sqlS: string; const displayTag: Boolean = True): Integer;   //��ѯ�����¼��ͳ��
    function UpdateDb(sqlS: string): Integer;  // ������ɾ��
    function StatisticsView(): Integer;        //�����ͼ
  end;

var
  frmRecord: TfrmRecord;
  backgroundJpeg: TJPEGImage;
  edtcol: integer; //��¼EDIT1��Columns�е�λ��,1-  MaxColumns;
  editem: Tlistitem;
  errorAccount: Integer;
  recordInfoList: TRecordInfo;

function CustomSortProc(Item1, Item2: TListItem; ColumnIndex: integer): integer; stdcall;

function GetGUID: string;

implementation


{$R *.dfm}

procedure TfrmRecord.ListViewWndProc1(var Msg: TMessage);
var
  IsNeg: Boolean;
begin
  try
    ShowScrollBar(ListView.Handle, SB_HORZ, false);
    //�϶�ListView������ʱ,��EDIT1��������
    if (Msg.Msg = WM_VSCROLL) or (Msg.Msg = WM_MOUSEWHEEL) then
      edtList.Visible := false;
    //��������Ϣ
    if Msg.Msg = WM_MOUSEWHEEL then
    begin
      if ListView.Selected = nil then
        exit;
      IsNeg := Short(Msg.WParamHi) < 0;
      ListView.SetFocus;
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

procedure TfrmRecord.ListViewCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
 // LockWindowUpdate(ListView.Handle);
  if Item.Index mod 2 <> 0 then
  begin
    Item.listview.Canvas.Brush.Color := RGB(238, 238, 238);
    Item.ListView.Canvas.Font.Color := clblack;
  end;
//  LockWindowUpdate(0);
end;

procedure TfrmRecord.AddComsumelvlist(recordInfo: TRecordInfo);
var
  i, count: Integer;
  item: tlistitem;
begin

  count := Length(recordInfo.ActiveTyInfo);
  for i := 0 to count - 1 do
  begin
    if recordInfo.ActiveTyInfo[i].activetype = '' then
    begin
      if CheckSameLvsCaption(recordInfo.ActiveTyInfo[i].activety) then
      begin
        item := ListView.Items.Add;
        item.Caption := recordInfo.ActiveTyInfo[i].activety;
        item.SubItems.Add((recordInfo.ActiveTyInfo[i].activeContent));
        item.SubItems.Add(recordInfo.ActiveTyInfo[i].activetype);
        //item.SubItems.Add(SecondToHour(recordInfo.ActiveTyInfo[i].costime));
      end;
    end;
   // Memo1.Lines.Add(recordInfo.ActiveTyInfo[i].activeContent);
  end;
end;

procedure TfrmRecord.AddConsumelist(columnsTitle, total, goodsList, recordDate, guidS: string);
var
  item: tlistitem;
begin
  item := ListView.Items.Add;
  item.Caption := columnsTitle;
  item.SubItems.Add(goodsList);
  item.SubItems.Add(total);
  item.SubItems.Add(recordDate);
  item.SubItems.Add(guidS);
end;

procedure TfrmRecord.N2Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmRecord.N5Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
end;

function TfrmRecord.QueryMonthAccountTotal(sqlS: string; const displayTag: Boolean): Integer;
begin

end;

function TfrmRecord.QueryMonthAccountTotal_Sqlite(sqlS: string; const displayTag: Boolean): Integer;
begin

end;

procedure TfrmRecord.NDayClick(Sender: TObject);
begin
  TodayRecord;
end;

procedure TfrmRecord.pngCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmRecord.Button5Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmRecord.N12Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'calc.exe', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmRecord.N13Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("d",accuntDate,Now())=0';
  ListView.Clear;
  QueryMonthAccountTotal(s);

end;

procedure TfrmRecord.N14Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("m",accuntDate,Now())=0';
  QueryMonthAccountTotal(s);
end;

procedure TfrmRecord.N15Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''ʳƷ��'' ';
  QueryMonthAccountTotal(s);
end;

procedure TfrmRecord.N16Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''�ճ���Ʒ��'' ';
  QueryMonthAccountTotal(s);
end;

procedure TfrmRecord.TodayRecord;
var
  recordInfo: TArrRecordInfo;
  reInfo: TArrRecordtyInfo;
  starTime, endTime: string;
  cost, Star, I, count: Integer;
  lvsContent: array of string;
begin
  starTime := FormatDateTime('YYYY-MM-DD 00:00:00', Now);
  endTime := FormatDateTime('YYYY-MM-DD HH:MM:SS', Now);
  //��ȡ�������м�¼��
  Star := GetTickCount;
 // myTask.GetDayActiveRecord(starTime, endTime, recordInfo);
  myTask.GetActiveRecord(starTime, endTime, reInfo);
  count := Length(reInfo);
  SetLength(lvsContent, 4);
  for I := 0 to count - 1 do
  begin
    lvsContent[0] := reInfo[I].recordName;
    lvsContent[1] := FormatDateTime('YYYY-MM-DD HH:MM:SS', reInfo[I].starTime);
    lvsContent[2] := FormatDateTime('YYYY-MM-DD HH:MM:SS', reInfo[I].endTime);
    lvsContent[3] := FormatDateTime('HH:MM:SS', reInfo[I].costTime);
    AddConsumelist_Content(lvsContent);
    lvsContent[0] := '';
    lvsContent[1] := '';
    lvsContent[2] := '';
    lvsContent[3] := '';
  end;
  Exit;
  {
  recordChart.Title.Text.Strings[0] := FormatDateTime('YYYY-MM-DD', Now) + ' ��¼';
  cost := GetTickCount - Star;
  Memo1.Clear;
  Memo1.Lines.Add('��ʱ' + IntToStr(cost) + '����');
  // ��ʾ�����¼
  recordChart.Series[0].Clear;
 // Exit;
  count := Length(recordInfo);

  for I := 0 to count - 1 do
  begin
    recordChart.Series[0].Add(recordInfo[I].cost, recordInfo[I].classType);
  end;}
end;

procedure TfrmRecord.ToolBar1Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("w",accuntDate,Now())=0';
  QueryMonthAccountTotal(s);

end;

procedure TfrmRecord.N71Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where datediff("w",accuntDate,Now())=0';
  QueryMonthAccountTotal(s);
end;

procedure TfrmRecord.N17Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''��ķ�����'' ';
  QueryMonthAccountTotal(s);
end;

procedure TfrmRecord.N18Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''���������'' ';
  QueryMonthAccountTotal(s);
end;

procedure TfrmRecord.N19Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from liftConsumptionTable where goodsTitle = ''������'' ';
  QueryMonthAccountTotal(s);
end;

function TfrmRecord.QueryFoodNutrition(s: string): Integer;
begin
 // myDbObj.QueryRecord(s);
 // myDbObj.GetTable_Sqlite(s);
end;

procedure TfrmRecord.AddConsumelist_Content(itemContent: array of string);
var
  item: tlistitem;
  i, lenContent: Integer;
begin
  // ����
  lenContent := Length(itemContent);
  item := ListView.Items.Add;
  item.Caption := itemContent[0];
  for i := 1 to lenContent - 1 do
  begin
    item.SubItems.Add(itemContent[i]);
  end;
end;

procedure TfrmRecord.AddConsumelist_Title(colnumsList: array of string);
var
  len, i: Integer;
begin
  len := Length(colnumsList);
  ListView.Columns.Clear;
  for i := 0 to len - 1 do
  begin
    ListView.Columns.Add;
    ListView.Columns[i].Caption := colnumsList[i];
    ListView.Columns[i].Width := 150;
  end;

end;

procedure TfrmRecord.edtListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  item: tlistitem;
  ix, lt, i: integer;
  rect: Trect;
  tempS, S, editField: string;
begin
  try
    if Key = 13 then      //��������    enter
    begin
      UpdateItem;
      edtList.Visible := False;
    end;
  //----���ϡ��¡����ҷ�������д���-----------------
    if (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_RIGHT) and (Key <> VK_LEFT) then
      EXIT;
    if (Key = VK_RIGHT) then  //�����Ҽ�
    begin
     //���¼����Ҽ���,�жϹ��λ���Ƿ������ұ�,����������ұ�,�������� EXIT
      if length(edtList.Text) > edtList.SelStart then
        exit;
      item := ListView.Selected;
     //����edit1λ���ĸ�Columns,���<���Columns,+1,����=1,��ת�������

      if (edtcol < MaxColumns) then
        edtcol := edtcol + 1
      else
        edtcol := 0;
      lt := 0;

    //�� edtcolֵ����� Columns��λ��(Left,width),EDIT1��������
      for i := 0 to edtcol - 1 do
        lt := lt + ListView.Columns[i].Width;
      edtList.Left := lt + 1;
      edtList.Width := ListView.Columns[edtcol].Width;
    end;
    if (Key = VK_left) then  //�������
    begin
      if edtList.SelStart <> 0 then
        exit;
      item := ListView.Selected;
      if (edtcol > 0) then
        edtcol := edtcol - 1
      else
        edtcol := MaxColumns;
      lt := 0;
      for i := 0 to edtcol - 1 do
        lt := lt + ListView.Columns[i].Width;
      edtList.Left := lt + 1;
      edtList.Width := ListView.Columns[edtcol].Width;
    end;
    if (Key = VK_DOWN) then     //�����¼�
    begin
      item := ListView.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix >= ListView.Items.Count - 1 then
        exit;
      SendMessage(ListView.Handle, WM_KEYDOWN, VK_down, 0)
    end;
    if (Key = VK_UP) then  //�����ϼ�
    begin
      item := ListView.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix < 1 then
        exit;
      SendMessage(ListView.Handle, WM_KEYDOWN, VK_up, 0)
    end;
    ListView.ItemFocused := ListView.Selected;
    item := ListView.Selected;
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

procedure TfrmRecord.edtListChange(Sender: TObject);
var
  tempNow, s: string;
  count: Integer;
  item: tlistitem;
begin
  try
    if not edtList.Visible then
      exit;
    if edtcol = 0 then
      ListView.Selected.Caption := edtList.Text
    else
      ListView.Selected.SubItems[edtcol - 1] := edtList.Text;

  except
  end;
end;

function TfrmRecord.UpdateDb(sqlS: string): Integer;
begin
  myDbObj.UpdateDbRecord(sqlS);

end;

procedure TfrmRecord.UpdateItem;
var
  itemName, itemType, itemContent: string;
begin
  if ListView.Selected.Selected then
  begin
    itemName := ListView.Selected.Caption;
    itemType := ListView.Selected.SubItems.Strings[1];
    itemContent := ListView.Selected.SubItems.Strings[0];
    myTask.SetItemType(itemName, itemType, itemContent);

  end;
end;

function TfrmRecord.UpdateSqlite(sqlS: string): Integer;
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

procedure TfrmRecord.mxLBarHeaders0Buttons0Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
end;

procedure TfrmRecord.N21Click(Sender: TObject);
var
  s, tempS: string;
begin
  if ListView.Items.Count <> 0 then
    if ListView.SelCount > 0 then
    begin
      tempS := ListView.Selected.SubItems.Strings[3];
      s := 'delete from liftConsumptionTable  where guidS =''' + tempS + '''';
      UpdateDb(s);
      ListView.DeleteSelected;
    end;
end;

procedure TfrmRecord.N22Click(Sender: TObject);
begin

end;

// ��ͼ

function TfrmRecord.StatisticsView: Integer;
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

end;

procedure TfrmRecord.ListViewColumnClick(Sender: TObject; Column: TListColumn);
begin

  ListView.CustomSort(@CustomSortProc, Column.Index);
end;

function CustomSortProc(Item1, Item2: TListItem; ColumnIndex: integer): integer; stdcall;
begin
  if ColumnIndex = 0 then
    Result := CompareText(Item1.Caption, Item2.Caption)
  else
    Result := CompareText(Item1.SubItems[ColumnIndex - 1], Item2.SubItems[ColumnIndex - 1]);

end;

procedure TfrmRecord.N10Click(Sender: TObject);
var
  s: string;
begin

  PageControl1.ActivePageIndex := 0;
  s := 'select * from accountBook ';
  ListView.Clear;
  QueryMonthAccountTotal_Sqlite(s);
end;
//�������

procedure TfrmRecord.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmRecord.Free;
  frmRecord := nil;
end;

procedure TfrmRecord.FormCreate(Sender: TObject);
var
  i, len: Integer;
  appdir: string;
  dbPath: string;
begin
 // inherited Create(AOwner);
  DoubleBuffered := True;
  ListView.DoubleBuffered := True;
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    PageControl1.Pages[i].TabVisible := False;
  end;
  Self.PageControl1.ActivePageIndex := 0;
  TodayRecord;

end;

procedure TfrmRecord.FormShow(Sender: TObject);
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

procedure TfrmRecord.GetUrl(var recordInfoList: TRecordInfo);
var
  Len, I: Integer;
begin
  Len := Length(recordInfoList.ActiveTyInfo);
  for I := 0 to Len - 1 do
  begin
    recordInfoList.ActiveTyInfo[I].activety := ChecekUrl(recordInfoList.ActiveTyInfo[I].activety);
  end;
end;

function TfrmRecord.ChecekUrl(activename: string): string;
var
  i, j, k, Len: Integer;
  tempS: string;
begin
  Len := Length(activename);

  for i := 0 to Len - 1 do
  begin
    if activename[i] = '.' then
    begin
      for j := i + 1 to Len - 1 do
        if activename[j] = '.' then
        begin
          for k := j + 1 to Len do
            if (activename[k] = '/') then
            begin
              tempS := Copy(activename, 0, k - 1);
              Result := tempS;
              Exit;
            end;
        end;
    end;
  end;

  Result := activename;
end;

function TfrmRecord.CheckSameLvsCaption(itemName: string): Boolean;
var
  i, Len: Integer;
  lvCaptionList: TStringList;
begin
  Result := False;
  lvCaptionList := TStringList.Create;
  Len := ListView.Items.Count;
  for i := 0 to Len - 1 do
  begin
    lvCaptionList.Add(ListView.Items[i].Caption);
  end;

  Len := lvCaptionList.Count;
  for i := 0 to Len - 1 do
  begin
    if itemName = lvCaptionList[i] then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
  lvCaptionList.Free;
end;

//listview �༭

procedure TfrmRecord.ListViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rect: Trect;
  p: tpoint;
  wtmp, i: integer;
begin
  try
  //��ʾ�༭�ؼ�
    edtList.Visible := false;
  //�������λ�ã��õ�����Ӧ�е�LISTITEM
    editem := ListView.GetItemAt(X, Y);
    if editem <> nil then
    begin
   //�������λ�ã���������ĸ� Columns.
      p := editem.Position;
      wtmp := p.X;
      for i := 0 to ListView.Columns.Count - 1 do
        if (X > wtmp) and (X < (wtmp + ListView.Column[i].Width)) then
          break  //�ҵ���Ӧ��Columns,����˳���Iȷ��.
        else
          inc(wtmp, ListView.Column[i].Width);
   //����I��ֵ��ȡ�� Columns�Ķ�Ӧλ�á��ڶ�Ӧλ�ð�������SIZE��EDIT1��
      edtcol := i;
      rect := editem.DisplayRect(drSelectBounds);
      edtList.SetBounds(wtmp - 1, rect.Top - 1, ListView.Column[i].Width + 1, rect.Bottom - rect.Top + 2);
      if edtcol > 0 then
        edtList.Text := editem.SubItems[i - 1]
      else
        edtList.Text := editem.Caption;
      if (edtcol = 1) or (edtcol = 2) then
      begin
        edtList.Visible := true;
        edtList.SetFocus;
      end;

    end;
  except
  end;
end;

end.

