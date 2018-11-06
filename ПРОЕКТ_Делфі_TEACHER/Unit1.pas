unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,pngimage, IdRawBase, IdRawClient, WinSock,
  IdIcmpClient, jpeg, Menus, CoolTrayIcon,ShellAPI, ImgList,
  IdAntiFreezeBase, IdAntiFreeze;

type
  TForm1 = class(TForm)
    IdTCPClient1: TIdTCPClient;
    B_GetScr: TButton;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    PortNumber: TEdit;
    B_Control: TButton;
    control1: TButton;
    Timer1: TTimer;
    B_Watch: TButton;
    Image2: TImage;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    MainMenu1: TMainMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu2: TPopupMenu;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    HOST: TComboBox;
    Button2: TButton;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    IdAntiFreeze1: TIdAntiFreeze;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    procedure B_GetScrClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure B_WatchClick(Sender: TObject);
    procedure B_ControlClick(Sender: TObject);
    procedure control1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure HOSTDropDown(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure connect_to_server;
  end;

var
  Form1: TForm1;

implementation

uses Unit3, Unit4;

{$R *.dfm}


procedure TForm1.connect_to_server;
begin
 //Параметри підключення
 IdTCPClient1.Host:=HOST.Text;
 IdTCPClient1.Port:=StrToInt(PortNumber.Text);
 //Підключаємось
 IdTCPClient1.Connect;
end;

 function HostToIP(name: string; var Ip: string): Boolean;
var
  wsdata : TWSAData;
  hostName : array [0..255] of char;
  hostEnt : PHostEnt;
  addr : PChar;
begin
  WSAStartup ($0101, wsdata);
  try
    gethostname (hostName, sizeof (hostName));
    StrPCopy(hostName, name);
    hostEnt := gethostbyname (hostName);
    if Assigned (hostEnt) then
      if Assigned (hostEnt^.h_addr_list) then begin
        addr := hostEnt^.h_addr_list^;
        if Assigned (addr) then begin
          IP := Format ('%d.%d.%d.%d', [byte (addr [0]),
          byte (addr [1]), byte (addr [2]), byte (addr [3])]);
          Result := True;
        end
        else
          Result := False;
      end
      else
        Result := False
    else begin
      Result := False;
    end;
  finally
    WSACleanup;
  end
end;

  procedure TForm1.B_GetScrClick(Sender: TObject);
var
 s:TFileStream;
 Bitmap: TBitmap;
 PNG: TPNGObject;
begin
 //Підключення до сервера
connect_to_server;
 //Посмлаємо команду "get_screen "
 IdTCPClient1.WriteLn('get_screen ');

 with IdTCPClient1 do
 begin
   if FileExists(ExtractFilePath(Application.ExeName)+'\'+'s.png') then DeleteFile(ExtractFilePath(Application.ExeName)+'\'+'s.png');
   //Створюємо поток
   s := TFileStream.Create(ExtractFilePath(Application.ExeName)+'\'+'s.png',fmCreate);
   //Поки є з'єднання, читаємо дані
   while connected do
        ReadStream(s,-1,true);
   //Закриваємо поток
   FreeAndNil(s);
   //Відключаємось
   Disconnect;
   Image1.Picture:=nil;
   //Виводимо отриманий скріншот на екран
   PNG := TPNGObject.Create;
   Bitmap := TBitmap.Create;
   try
    PNG.LoadFromFile(ExtractFilePath(Application.ExeName)+'\'+'s.png');
    Bitmap.Assign(PNG);
    Image1.Picture.Bitmap.Assign(Bitmap);


   finally
     PNG.Free;
    Bitmap.Free;
   end;
 end;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=false;
  B_GetScrClick(self);
  //Якщо користувач все ще в режимі перегляду, то продовжуємо отримувати скріншоти
 if B_Watch.Caption='Зупинити перегляд' then Timer1.Enabled:=true;
end;

procedure TForm1.B_WatchClick(Sender: TObject);
begin
 if B_Watch.Caption='Перегляд' then
  begin
   B_Watch.Caption:='Зупинити перегляд';
   B_GetScr.Enabled:=false;
   B_Control.Enabled:=false;
   Control1.Enabled:=false;
   Button3.Enabled:=false;
   button1.Enabled:=false;
   n11.Enabled:=false;
   n12.Enabled:=false;
   n17.Enabled:=false;
   n18.Enabled:=false;
   n25.Enabled:=false;
   n2.Enabled:=false;
   n19.Enabled:=false;
   n26.Enabled:=false;
   n20.Enabled:=false;
   n27.Enabled:=false;
   Timer1.Enabled:=true;
  end
 else
  begin
   B_Watch.Caption:='Перегляд';
   B_GetScr.Enabled:=true;
   B_Control.Enabled:=true;
      Control1.Enabled:=true;
   Button3.Enabled:=true;
   button1.Enabled:=true;
   n11.Enabled:=true;
   n12.Enabled:=true;
   n17.Enabled:=true;
   n18.Enabled:=true;
   n25.Enabled:=true;
   n2.Enabled:=true;
   n19.Enabled:=true;
   n26.Enabled:=true;
   n20.Enabled:=true;
   n27.Enabled:=true;
   Timer1.Enabled:=true;
  end;
end;

procedure TForm1.B_ControlClick(Sender: TObject);
 begin
WinExec(PAnsiChar('cmd /c mstsc /v:'+host.Text), SW_HIDE);

end;


procedure TForm1.control1Click(Sender: TObject);
begin
 connect_to_server;

 IdTCPClient1.WriteLn('message_for_you1 ');
 IdTCPClient1.Disconnect;


 
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
form1.Visible:=false;
form4.Visible:=true;

end;

procedure TForm1.N7Click(Sender: TObject);
begin
close;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
   B_Watch.Click;

  end;
procedure TForm1.N11Click(Sender: TObject);
begin
B_GetScr.Click;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
button1.Click;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
 B_Watch.Click;


end;

procedure TForm1.N2Click(Sender: TObject);
begin
 B_GetScr.Click;
end;

procedure TForm1.N15Click(Sender: TObject);
begin
close;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
CoolTrayIcon1.IconVisible:=true;
CoolTrayIcon1.HideMainform;
end;

procedure TForm1.CoolTrayIcon1Click(Sender: TObject);
begin
 CoolTrayIcon1.IconVisible:=false;
CoolTrayIcon1.ShowMainForm;

end;

procedure TForm1.N16Click(Sender: TObject);
begin
close;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
n9.Click;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
ShellExecute(Form1.Handle, nil, 'довідка.pdf', nil, nil, SW_RESTORE);
end;

procedure TForm1.N17Click(Sender: TObject);
begin
 B_Control.Click;
end;

procedure TForm1.N18Click(Sender: TObject);
begin
control1.Click;
end;

procedure TForm1.N19Click(Sender: TObject);
begin
 B_Control.Click;
end;

procedure TForm1.N20Click(Sender: TObject);
begin
 control1.Click;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
ShellExecute(Form1.Handle, nil, 'допомога.pdf', nil, nil, SW_RESTORE);
end;

procedure TForm1.N14Click(Sender: TObject);
begin
ShellExecute(Form1.Handle, nil, 'допомога.pdf', nil, nil, SW_RESTORE);
end;

procedure TForm1.N4Click(Sender: TObject);
begin
ShellExecute(Form1.Handle, nil, 'довідка.pdf', nil, nil, SW_RESTORE);
end;





procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := MessageDlg('Ви хочете закрити програму?',mtCUSTOM,[mbYES, mbNO], 0) = mrYes;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
form3.visible:=true;
form1.visible:=false;
end;

procedure TForm1.HOSTDropDown(Sender: TObject);
begin
host.items:=form3.Memo2.Lines;
end;

procedure TForm1.N21Click(Sender: TObject);
begin
button2.Click;
end;

procedure TForm1.N22Click(Sender: TObject);
begin
button2.Click;
end;

procedure TForm1.N23Click(Sender: TObject);
begin
ShellExecute(handle, 'open','http://vk.com/dzazymko',nil,nil,SW_SHOW) ;
end;

procedure TForm1.N24Click(Sender: TObject);
begin
n23.Click;
end;

procedure TForm1.Button3Click(Sender: TObject);
var FName:string;
FS: TFileStream;

begin

   if OpenDialog1.Execute then FName := OpenDialog1.FileName;

     if FName<>'' then
     begin
      B_GetScr.Enabled:=false;
   B_Control.Enabled:=false;
   B_Watch.Enabled:=false;
   control1.Enabled:=false;
   button1.Enabled:=false;
   n11.Enabled:=false;
   n12.Enabled:=false;
   n17.Enabled:=false;
   n18.Enabled:=false;
   n10.Enabled:=false;
   n2.Enabled:=false;
   n19.Enabled:=false;
   n1.Enabled:=false;
   n20.Enabled:=false;
   n27.Enabled:=false;
        connect_to_server;
     IdTCPClient1.WriteLn('FILE '+FName);

        FS := TFileStream.Create(FName, fmOpenRead or fmShareDenyNone); // Загрузка
  try

    IdTCPClient1.WriteStream(FS); // Поток принимаемый сервером
  finally
    FreeAndNil(FS);
  end;

  

  IdTCPClient1.Disconnect;
  showmessage('файл передано');
   B_GetScr.Enabled:=true;
   B_Control.Enabled:=true;
   B_Watch.Enabled:=true;
   control1.Enabled:=true;
   button1.Enabled:=true;
   n11.Enabled:=true;
   n12.Enabled:=true;
   n17.Enabled:=true;
   n18.Enabled:=true;
   n10.Enabled:=true;
   n2.Enabled:=true;
   n19.Enabled:=true;
   n1.Enabled:=true;
   n20.Enabled:=true;
   n27.Enabled:=true;

  end;






end;

procedure TForm1.N25Click(Sender: TObject);
begin
Button3.Click;
end;

procedure TForm1.N26Click(Sender: TObject);
begin
Button3.Click;
end;

procedure TForm1.N27Click(Sender: TObject);
begin
button1.Click;
end;

end.
