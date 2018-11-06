unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdComponent, IdIPWatch, IdAntiFreezeBase, IdAntiFreeze;

type
  TForm2 = class(TForm)
    Edit2: TEdit;
    Label1: TLabel;
    IdIPWatch1: TIdIPWatch;
    IdTCPClient1: TIdTCPClient;
    Label2: TLabel;
    IdAntiFreeze1: TIdAntiFreeze;
    Memo1: TMemo;
    
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}



procedure TForm2.FormCreate(Sender: TObject);
  var ipadd:string;
begin
form2.Visible:=false;

    memo1.Lines.LoadFromFile('IP server.txt');
 ipadd:= IdIPWatch1.LocalIP;
   IdTCPClient1.Host:=memo1.Lines[1];
   IdTCPClient1.Port:=StrToInt(edit2.Text);
   IdTCPClient1.Connect;
   IdTCPClient1.WriteLn(ipadd);
   IdTCPClient1.Disconnect;
end;

end.
 