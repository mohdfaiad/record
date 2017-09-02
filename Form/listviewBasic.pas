unit listviewBasic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfrmLvsbic = class(TForm)
    edt1: TEdit;
    lv1: TListView;
    procedure edt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edt1Change(Sender: TObject);
    procedure lv1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FListViewWndProc1: TWndMethod;
    procedure ListViewWndProc1(var Msg: TMessage);
  public
    { Public declarations }
  end;

const
  MaxColumns = 7;  //   总Columns-1

var
  frmLvsbic: TfrmLvsbic;
  edtcol: integer; //记录EDIT1在Columns中的位置,1-  MaxColumns;
  editem: Tlistitem;

implementation

{$R *.dfm}
procedure TfrmLvsbic.ListViewWndProc1(var Msg: TMessage);
var
  IsNeg: Boolean;
begin
  try
    ShowScrollBar(lv1.Handle, SB_HORZ, false);

        //拖动Listview1滚动条时,将EDIT1隐藏起来
    if (Msg.Msg = WM_VSCROLL) or (Msg.Msg = WM_MOUSEWHEEL) then
      edt1.Visible := false;
    if Msg.Msg = WM_MOUSEWHEEL then
    begin
      if lv1.Selected = nil then
        exit;
      IsNeg := Short(Msg.WParamHi) < 0;
      lv1.SetFocus;
      if IsNeg then
        SendMessage(edt1.Handle, WM_KEYDOWN, VK_down, 0)
      else
        SendMessage(edt1.Handle, WM_KEYDOWN, VK_up, 0);
    end
    else
      FListViewWndProc1(Msg);
  except
  end;
end;

procedure TfrmLvsbic.edt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  item: tlistitem;
  ix, lt, i: integer;
  rect: Trect;
begin
  try
  //----对上、下、左、右方向键进行处理-----------------
    if (Key <> VK_DOWN) and (Key <> VK_UP) and (Key <> VK_RIGHT) and (Key <> VK_LEFT) then
      EXIT;
    if (Key = VK_RIGHT) then  //键盘右键
    begin
     //按下键盘右键后,判断光标位置是否处于最右边,如果不在最右边,不作处理 EXIT
      if length(edt1.Text) > edt1.SelStart then
        exit;
      item := lv1.Selected;
     //计算edit1位于哪个Columns,如果<最大Columns,+1,否则=1,即转到最左边

      if (edtcol < MaxColumns) then
        edtcol := edtcol + 1
      else
        edtcol := 0;
      lt := 0;

    //从 edtcol值计算出 Columns的位置(Left,width),EDIT1按此设置

      for i := 0 to edtcol - 1 do
        lt := lt + lv1.Columns[i].Width;
      edt1.Left := lt + 1;
      edt1.Width := lv1.Columns[edtcol].Width;
    end;
    if (Key = VK_left) then  //键盘左键
    begin
      if edt1.SelStart <> 0 then
        exit;
      item := lv1.Selected;
      if (edtcol > 0) then
        edtcol := edtcol - 1
      else
        edtcol := MaxColumns;
      lt := 0;
      for i := 0 to edtcol - 1 do
        lt := lt + lv1.Columns[i].Width;
      edt1.Left := lt + 1;
      edt1.Width := lv1.Columns[edtcol].Width;
    end;
    if (Key = VK_DOWN) then     //键盘下键
    begin
      item := lv1.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix >= lv1.Items.Count - 1 then
        exit;
      SendMessage(lv1.Handle, WM_KEYDOWN, VK_down, 0)
    end;
    if (Key = VK_UP) then  //键盘上键
    begin
      item := lv1.Selected;
      if item = nil then
        exit;
      ix := item.Index;
      if ix < 1 then
        exit;
      SendMessage(lv1.Handle, WM_KEYDOWN, VK_up, 0)
    end;
    lv1.ItemFocused := lv1.Selected;
    item := lv1.Selected;
    edt1.Visible := false;
    rect := item.DisplayRect(drSelectBounds);
    edt1.SetBounds(edt1.left, rect.Top - 1, edt1.Width, rect.Bottom - rect.Top + 2);
    if edtcol > 0 then
      edt1.Text := item.SubItems[edtcol - 1]
    else
      edt1.Text := item.Caption;
    edt1.Visible := true;
    edt1.SetFocus;

  except
  end;
end;





//编辑控件内容改变后,保存改变到Listview1对应位置

procedure TfrmLvsbic.edt1Change(Sender: TObject);
begin
  try
    if not edt1.Visible then
      exit;

    if edtcol = 0 then
      lv1.Selected.Caption := edt1.Text
    else
      lv1.Selected.SubItems[edtcol - 1] := edt1.Text;
  except
  end;
end;

//在LISTVIEW1上按下鼠标

procedure TfrmLvsbic.lv1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rect: Trect;
  p: tpoint;
  wtmp, i: integer;
begin
  try
  //显示编辑控件
    edt1.Visible := false;
  //根据鼠标位置，得到所对应行的LISTITEM
    editem := lv1.GetItemAt(X, Y);
    if editem <> nil then
    begin
   //根据鼠标位置，计算出是哪个 Columns.
      p := editem.Position;
      wtmp := p.X;
      for i := 0 to lv1.Columns.Count - 1 do
        if (X > wtmp) and (X < (wtmp + lv1.Column[i].Width)) then
          break  //找到对应的Columns,打断退出，I确定.
        else
          inc(wtmp, lv1.Column[i].Width);
   //根据I的值，取得 Columns的对应位置。在对应位置按其它的SIZE放EDIT1。
      edtcol := i;
      rect := editem.DisplayRect(drSelectBounds);
      edt1.SetBounds(wtmp - 1, rect.Top - 1, lv1.Column[i].Width + 1, rect.Bottom - rect.Top + 2);
      if edtcol > 0 then
        edt1.Text := editem.SubItems[i - 1]
      else
        edt1.Text := editem.Caption;
      edt1.Visible := true;
      edt1.SetFocus;
    end;
  except
  end;
end;

//初始化,加入测试数据.
procedure TfrmLvsbic.FormCreate(Sender: TObject);
var
  item: tlistitem;
  i: integer;
begin

 //将edit1的父亲选为LISTVIEW1,用以响应LISTVIEW1消息
  edt1.parent := lv1;
 //拦载LISTVIEW1鼠标消息
  FListViewWndProc1 := Lv1.WindowProc;
  Lv1.WindowProc := ListViewWndProc1;
end;



//  上面的代码只是最基本的代码，仅可以通过键盘的上、下、左、右键控制EDIT在各个Column中切换，要将它做得更好，还要加入如拦截Column的宽度变化消息，以便Column变宽或变窄后相应的调整EDIT宽度等等。

end.

