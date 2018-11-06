unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, IdBaseComponent, IdComponent,
  IdIPWatch, IdTCPServer;

type
  TForm3 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    IdIPWatch1: TIdIPWatch;
    Label2: TLabel;
    Edit2: TEdit;
    IdTCPServer1: TIdTCPServer;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
  private
    { Private declarations }
  public
    { Public declarations }
     procedure Log(S:string);
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}
procedure TForm3.Log(S:string);
begin
 Memo1.Lines.Add(TimeToStr(Time)+'  '+S);
end;
procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
form3.Visible:=false;
form1.visible:=true;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
//Якщо сервер вимкнено, то вмикаємо
 if IdTCPServer1.Active=false then
  begin
  edit1.Text:=IdIPWatch1.LocalIP;
   IdTCPServer1.Bindings.Add;
   IdTCPServer1.Bindings.Items[0].IP:=IdIPWatch1.LocalIP;
   IdTCPServer1.Bindings.Items[0].Port:=StrToInt(edit2.Text);
   IdTCPServer1.Active:=true;
   Button1.Caption:='Зупинити сервер';
   Image1.Picture.LoadFromFile('on.jpg');
   Log('Сервер активовано.');
   Log('IP адреса: '+IdTCPServer1.Bindings.Items[0].IP);
   Log('Номер порта: '+IntToStr(IdTCPServer1.Bindings.Items[0].Port));
  end
 else
  begin
   IdTCPServer1.Active:=false;
   IdTCPServer1.Bindings.Delete(0);
   Button1.Caption:='Запустити сервер';
   Image1.Picture.LoadFromFile('off.jpg');
   Log('Сервер зупинено');
  end;
end;



procedure TForm3.IdTCPServer1Execute(AThread: TIdPeerThread);

var
  z: string;


begin
  with AThread.Connection do
  begin
   //Читаємо, що прислав клієнт
    z := ReadLn;

    Memo2.Lines.Add(z);

    //Припиняємо зв'язок з клієнтом
  AThread.Connection.Disconnect;
 end;
 end;

end.
