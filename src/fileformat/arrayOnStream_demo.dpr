program arrayOnStream_demo;

uses
  Forms,
  uArrayOnStreamMain in 'uArrayOnStreamMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
