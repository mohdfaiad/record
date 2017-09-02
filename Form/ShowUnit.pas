unit ShowUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Buttons, ExtCtrls, MainUnit, taskForms, recordVierFrm, uUwp;

type
  TShowForm = class(TForm)
    Panel1: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Timer1: TTimer;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowForm: TShowForm;
  AppPath: string;

implementation

uses
  CustomDrawDemoMain;

{$R *.DFM}

procedure TShowForm.SpeedButton1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TShowForm.FormShow(Sender: TObject);
begin
  ShowForm.SetFocus;
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

procedure TShowForm.SpeedButton2Click(Sender: TObject);
begin
  if Assigned(createTaskForm) then
  begin
    createTaskForm.Free;
    createTaskForm := nil;
  end;
  Application.CreateForm(TCreateTaskForm, createTaskForm);
  createTaskForm.Show;
  Self.Hide;
end;

procedure TShowForm.SpeedButton5Click(Sender: TObject);
begin
  if not assigned(frmRecord) then
  begin
    Application.CreateForm(TfrmRecord, frmRecord);
  end;
  frmRecord.Show;
  Self.hide;
end;

procedure TShowForm.SpeedButton6Click(Sender: TObject);
begin
  MainForm.Show;
  Self.Hide;
end;

procedure TShowForm.Timer1Timer(Sender: TObject);
begin
  if Timer1.Tag div 2 = 0 then
  begin
    frmRecord.Close;
    Sleep(2000);
  end
  else
    SpeedButton5.Click;
  Timer1.Tag := Timer1.Tag + 1;
end;

procedure TShowForm.SpeedButton3Click(Sender: TObject);
begin
  if not Assigned(frmUwp) then
    Application.CreateForm(TfrmUwp, frmUwp);
  frmUwp.show;
  Self.hide;
end;

procedure TShowForm.SpeedButton4Click(Sender: TObject);
begin
  CustomDrawDemoMainForm.Show;
  self.hide;
end;

end.

