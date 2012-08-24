program Thred32;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uMenu in 'uMenu.pas' {Form2},
  Thred_rc in 'Thred_rc.pas',
  uResourceString in 'uResourceString.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
