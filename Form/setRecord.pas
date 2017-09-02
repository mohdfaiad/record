unit setRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uTask, uConst;

type
  TfrmSetClass = class(TForm)
    Button1: TButton;
    edtClass: TEdit;
    edtTitle: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mmContent: TMemo;
    cbbClass: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FError: TError;
  public
    { Public declarations }
    itemCaption: string;
  end;

var
  frmSetClass: TfrmSetClass;

implementation

{$R *.dfm}

procedure TfrmSetClass.Button1Click(Sender: TObject);
var
  itemName, itemType, itemContent, classname: string;
begin

  //表单
  begin
    itemName := ItemCaption;
    itemContent := mmContent.Text;
    itemType := edtClass.Text;
    classname := cbbClass.Text;
    myTask.SetItemType(itemName, itemType, itemContent, classname);
  end;
  Self.Close;
end;

procedure TfrmSetClass.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmSetClass := nil;           //Form对象指向空地址
  Action := cafree;
end;

procedure TfrmSetClass.FormShow(Sender: TObject);
var
  classType: TClassType;
begin

  classType := myTask.QueryClassItem(itemCaption);
  edtTitle.Text := itemCaption;
  edtClass.Text := (classType.urlAppclass);
  cbbClass.Text := classType.className;
  mmContent.Text := classType.urlAppRemarks;
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;
end;

end.

