program Thred32;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  uMenu in 'uMenu.pas' {Form2},
  Thred_rc in 'Thred_rc.pas',
  uResourceString in 'uResourceString.pas' {Form3},
  Thred_h in 'Thred_h.pas',
  Thred_Constants in 'lib\Thred_Constants.pas',
  Thred_Defaults in 'lib\Thred_Defaults.pas',
  gmSwatch_rwPAL in 'lib\gmSwatch_rwPAL.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
