unit taskForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, jpeg;

type
  TcreateTaskForm = class(TForm)
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Image8: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    ListView1: TListView;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListView2: TListView;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PNGButton1Click(Sender: TObject);
    procedure PNGButton2Click(Sender: TObject);
    procedure PNGButton3Click(Sender: TObject);
    procedure PNGButton4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  createTaskForm: TcreateTaskForm;

implementation

{$R *.dfm}

procedure TcreateTaskForm.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TcreateTaskForm.FormCreate(Sender: TObject);
var
  i: Integer;
  arect: TRect;
begin
  Panel2.Brush.Color := clWhite;
  Self.Canvas.Brush.Color := clWhite;
  arect.Left := Button3.Left;
  arect.Top := Button3.Top;
  arect.Right := arect.Left + Button3.Width;
  arect.Bottom := arect.top + Button3.Height;
  Self.Canvas.FillRect(arect);
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    PageControl1.Pages[i].Brush.Color := clWhite;
    PageControl1.Pages[i].TabVisible := False; //вўВи
  end;
  PageControl1.ActivePageIndex := 0;
end;

procedure TcreateTaskForm.FormShow(Sender: TObject);
begin
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.top := (Screen.Height - Self.Height) div 2;
end;

procedure TcreateTaskForm.PageControl1Change(Sender: TObject);
var
  i: integer;
  sheet: TTabSheet;
begin
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    sheet := PageControl1.Pages[i];
    if sheet = PageControl1.ActivePage then
      sheet.Highlighted := true
    else
      sheet.Highlighted := false;
  end;
end;

procedure TcreateTaskForm.PNGButton1Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TcreateTaskForm.PNGButton2Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 1;
end;

procedure TcreateTaskForm.PNGButton3Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 2;
end;

procedure TcreateTaskForm.PNGButton4Click(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 3;
end;

end.

