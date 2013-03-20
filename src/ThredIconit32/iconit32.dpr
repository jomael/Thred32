program iconit32;

uses
  Forms,
  umMain in 'umMain.pas' {MainForm},
  about in 'about.pas' {AboutBox},
  umDm in 'umDm.pas' {DM: TDataModule},
  umDmTool in 'umDmTool.pas' {dmTool: TDataModule},
  umChild in 'umChild.pas' {fcDesign},
  Embroidery_Items in '..\lib\Embroidery_Items.pas',
  umDmFill in 'umDmFill.pas' {dmFill: TDataModule},
  Embroidery_Lines32 in '..\lib\Embroidery_Lines32.pas',
  Embroidery_Painter in '..\lib\Embroidery_Painter.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Iconit32';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TdmTool, dmTool);
  Application.CreateForm(TdmFill, dmFill);
  Application.Run;
end.
