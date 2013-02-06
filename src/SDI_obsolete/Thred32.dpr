program Thred32;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  Thred_rc in 'Thred_rc.pas',
  Thred_h in 'Thred_h.pas',
  Thred_Constants in '..\lib\Thred_Constants.pas',
  Thred_Defaults in '..\lib\Thred_Defaults.pas',
  gmSwatch_rwPAL in '..\lib\gmSwatch_rwPAL.pas',
  Stitch_rwTHR in '..\lib\Stitch_rwTHR.pas',
  Stitch_rwPES in '..\lib\Stitch_rwPES.pas',
  Stitch_Lines32 in '..\lib\Stitch_Lines32.pas',
  Form_cpp in '..\lib\Form_cpp.pas',
  Stitch_rwDST in '..\lib\Stitch_rwDST.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
