program TEACHER;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  form2:=tform2.Create(application);
  form2.Show;
  form2.Update;
  while form2.Timer1.Enabled do
  application.ProcessMessages;



    Application.Title := '�������� �� ������';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  form2.top:=screen.Height;;


  Application.Run;
end.
