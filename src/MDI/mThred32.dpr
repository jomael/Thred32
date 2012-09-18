program mThred32;

uses
  Forms,
  umMain in 'umMain.pas' {MainForm},
  umChild in 'umChild.pas' {MDIChild},
  about in 'about.pas' {AboutBox},
  umDm in 'umDm.pas' {DM: TDataModule},
  gmIntegrator in '..\..\..\..\..\..\..\UI\GR32\GraphicsMagicPro\graphicsmagic\branches\GraphicsMagic_2_0_0\Source\Internal\Core\gmIntegrator.pas',
  gmCoreItems in '..\..\..\..\..\..\..\UI\GR32\GraphicsMagicPro\graphicsmagic\branches\GraphicsMagic_2_0_0\Source\Internal\Core\gmCoreItems.pas',
  gmIntercept_GR32_Image in '..\lib\gmIntercept_GR32_Image.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Thred32';
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
