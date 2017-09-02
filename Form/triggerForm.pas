unit triggerForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzTabs, ComCtrls, pngextra, Spin;

type
  TtriggerForms = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button4: TButton;
    Button5: TButton;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    PNGButton1: TPNGButton;
    PNGButton2: TPNGButton;
    PNGButton3: TPNGButton;
    PNGButton4: TPNGButton;
    TabSheet5: TTabSheet;
    PNGButton5: TPNGButton;
    TabSheet6: TTabSheet;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    SpinEdit2: TSpinEdit;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Label9: TLabel;
    TabSheet7: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Label10: TLabel;
    SpinEdit6: TSpinEdit;
    Label11: TLabel;
    RadioButton1: TRadioButton;
    ComboBox2: TComboBox;
    SpinEdit7: TSpinEdit;
    Label12: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PNGButton1Click(Sender: TObject);
    procedure PNGButton2Click(Sender: TObject);
    procedure PNGButton3Click(Sender: TObject);
    procedure PNGButton5Click(Sender: TObject);
    procedure PNGButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  triggerForms: TtriggerForms;

implementation

{$R *.dfm}

procedure TtriggerForms.FormCreate(Sender: TObject);
var
i : Integer;
begin

 for i := 0 to PageControl1.PageCount - 1 do
  begin
    PageControl1.Pages[i].Brush.Color := clWhite;
    PageControl1.Pages[i].TabVisible := False; //вўВи
  end;
  PageControl1.ActivePageIndex := 0;

   for i := 0 to PageControl2.PageCount - 1 do
  begin
    //PageControl2.Pages[i].Brush.Color := clWhite;
    PageControl2.Pages[i].TabVisible := False; //вўВи
  end;
  PageControl2.ActivePageIndex := 0;
end;

procedure TtriggerForms.PNGButton1Click(Sender: TObject);
begin
  PageControl2.ActivePageIndex := 0;
end;

procedure TtriggerForms.PNGButton2Click(Sender: TObject);
begin
  PageControl2.ActivePageIndex := 1;
end;

procedure TtriggerForms.PNGButton3Click(Sender: TObject);
begin
  PageControl2.ActivePageIndex := 2;
end;

procedure TtriggerForms.PNGButton4Click(Sender: TObject);
begin
  PageControl2.ActivePageIndex := 4;
end;

procedure TtriggerForms.PNGButton5Click(Sender: TObject);
begin
  PageControl2.ActivePageIndex := 3;
end;

end.
