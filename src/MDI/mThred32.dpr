program mThred32;

uses
  Forms,
  umMain in 'umMain.pas' {MainForm},
  umChild in 'umChild.pas' {MDIChild},
  about in 'about.pas' {AboutBox},
  umDm in 'umDm.pas' {DM: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
