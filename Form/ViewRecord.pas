unit ViewRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeeGDIPlus, TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls,
  ComCtrls, uTask, uConst;

const
  MaxColumns = 7;

type
  TViewForm = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Chart1: TChart;
    psrsRecord: TPieSeries;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lvItemCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvItemData(Sender: TObject; Item: TListItem);
    procedure edtLstChange(Sender: TObject); // listview 内容
  private
    FListViewWndProc1: TWndMethod;
    procedure AddConsumelist(myrecordInfo: TRecordInfo);
    procedure ListViewWndProc1(var Msg: TMessage);
    { Private declarations }
  public
    { Public declarations }

  end;

var
  ViewForm: TViewForm;
  edtcol: integer; //记录EDIT1在Columns中的位置,1-  MaxColumns;
  editem: Tlistitem;

implementation

{$R *.dfm}

{ TViewForm }

procedure TViewForm.AddConsumelist(myrecordInfo: TRecordInfo);
var
  i, count: Integer;
  item: tlistitem;
begin

end;

procedure TViewForm.Button1Click(Sender: TObject);
var
  i, count, star, cost: Integer;
  myrecordInfo: TRecordInfo;
begin
  star := GetTickCount;
  myTask.ImPortActiveRecord('2017-01-22 00:00:00', '2017-01-23 00:00:00', myrecordInfo);
  cost := (GetTickCount - star);
  Memo1.Lines.Add('导入耗时' + IntToStr(cost));
  AddConsumelist(myrecordInfo);
end;

procedure TViewForm.edtLstChange(Sender: TObject);
begin
  // 更改类型和备注 
end;

procedure TViewForm.FormShow(Sender: TObject);
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

procedure TViewForm.ListViewWndProc1(var Msg: TMessage);

begin

end;

procedure TViewForm.lvItemCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 <> 0 then
  begin
    item.listview.Canvas.Brush.Color := RGB(238, 238, 238);
    item.ListView.Canvas.Font.Color := clblack;
  end;
end;

procedure TViewForm.lvItemData(Sender: TObject; Item: TListItem);
var
  i, count: Integer;
begin

end;

end.

