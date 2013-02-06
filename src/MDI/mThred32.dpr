program mThred32;

uses
  Forms,
  umMain in 'umMain.pas' {MainForm},
  umChild in 'umChild.pas' {fcDesign},
  about in 'about.pas' {AboutBox},
  umDm in 'umDm.pas' {DM: TDataModule},
  gmIntercept_GR32_Image in '..\lib\gmIntercept_GR32_Image.pas',
  umDmTool in 'umDmTool.pas' {dmTool: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Thred32';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TdmTool, dmTool);
  Application.Run;
end.
