program stitch_IO_demo;

uses
  Forms,
  Stitch_items in '..\lib\Stitch_items.pas',
  uMain in 'uMain.pas' {Form1},
  Stitch_rwTHR in '..\lib\Stitch_rwTHR.pas',
  Stitch_FileDlg in '..\lib\Stitch_FileDlg.pas',

  Thred_h in '..\Thred_h.pas',
  Thred_rc in '..\Thred_rc.pas',
  Thred_Types in '..\lib\Thred_Types.pas',
  Thred_Constants in '..\lib\Thred_Constants.pas',
  Stitch_rwPCS in '..\lib\Stitch_rwPCS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
