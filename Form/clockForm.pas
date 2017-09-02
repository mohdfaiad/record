unit clockForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TclockF = class(TForm)
    Button1: TButton;
    Button2: TButton;
    lb1Title: TLabel;
    Image8: TImage;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  clockF: TclockF;

implementation

{$R *.dfm}
//сроб╫г
procedure TclockF.FormShow(Sender: TObject);
var
  R: TRect;
  TrayWnd: HWnd;
begin
  TrayWnd := FindWindow('Shell_TrayWnd',nil);
  GetWindowRect(TrayWnd, R);
  Self.Left := Screen.Width - Self.Width;
  Self.Top :=  Screen.Height -  Self.Height - (R.Bottom - r.Top);
end;

procedure TclockF.Button1Click(Sender: TObject);
begin
 // Self.Hide;
end;

end.

