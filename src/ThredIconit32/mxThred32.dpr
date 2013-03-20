program mxThred32;

uses
  Forms,
  umMain in 'umMain.pas' {MainForm},
  umxMain in 'umxMain.pas' {MainForm1},
  umDm in 'umDm.pas' {DM: TDataModule},
  umChild in 'umChild.pas' {fcDesign},
  about in 'about.pas' {AboutBox},
  umDmTool in 'umDmTool.pas' {dmTool: TDataModule},
  Stitch_items in '..\lib\Stitch_items.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TdmTool, dmTool);
  //  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainForm1, MainForm1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
