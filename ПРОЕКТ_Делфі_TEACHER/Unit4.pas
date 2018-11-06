unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
         procedure connect_to_server;
  end;

var
  Form4: TForm4;

implementation

uses Unit1;

{$R *.dfm}
  procedure TForm4.connect_to_server;
begin
 //Параметри підключення
 form1.IdTCPClient1.Host:=form1.HOST.Text;
 form1.IdTCPClient1.Port:=StrToInt(form1.PortNumber.Text);
 //Підключаємось
 form1.IdTCPClient1.Connect;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
connect_to_server;
  form1.IdTCPClient1.WriteLn('remark '+form4.edit1.text);
  form1.IdTCPClient1.Disconnect;
  form4.Visible:=false;
form1.Visible:=true;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
form4.Visible:=false;
form1.Visible:=true;
end;

end.
