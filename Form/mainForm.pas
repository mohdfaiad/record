unit mainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  taskForms, uTask;

procedure TForm1.Button1Click(Sender: TObject);
begin
  createTaskForm.Show;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  taskInfoList: TTaskInfoArr;
  i, len: Integer;
begin
  myTask := TTask.Create(Self.Handle);
  //复查昨日任务
  //获取当日所有任务
  myTask.GetTodayTaskInfo(taskInfoList);
  myTask.RecordTask;
  Exit;
  len := Length(taskInfoList);
  for I := 0 to len - 1 do
  begin

  end;
 //基本任务

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  myTask.Free;
end;

end.

