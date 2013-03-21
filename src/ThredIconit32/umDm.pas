unit umDm;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdActns, ActnList, ImgList, Controls, Dialogs, Menus,
  AppEvnts, ExtDlgs;

  
{$DEFINE DISABLED_IL}

type

  //subclassing fro draw Saturated image while draw disabled menu item.
  {$IFDEF DISABLED_IL}
  TImageList = class(Controls.TImageList)
  protected
    procedure DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer;
      Style: Cardinal; Enabled: Boolean = True); override;
  end;
  {$ENDIF}

  TDM = class(TDataModule)
    il1: TImageList;
    actlstStandard: TActionList;
    actFileNew1: TAction;
    actFileOpen1: TAction;
    FileClose1: TWindowClose;
    actFileSave1: TAction;
    actFileSaveAs1: TAction;
    actFileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowArrangeAll1: TWindowArrange;
    actHelpAbout1: TAction;
    actOpenStitch: TAction;
    actViewToolbar: TAction;
    mm1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    View1: TMenuItem;
    mnhdWindow: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowTileItem2: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    ilDisabled: TImageList;
    il2: TImageList;
    il3: TImageList;
    ool1: TMenuItem;
    Hand1: TMenuItem;
    Zoom1: TMenuItem;
    ilQuality: TImageList;
    actlstQuality: TActionList;
    actDqSolid: TAction;
    actDqPhoto: TAction;
    actDqOutdoorPhoto: TAction;
    actDqMountain: TAction;
    actDqHotPerforated: TAction;
    actDqXRay: TAction;
    actDqWireframe: TAction;
    actUseOrdinalColor: TAction;
    actDqTogglePhoto: TAction;
    Solid1: TMenuItem;
    Photo1: TMenuItem;
    HotPerforated1: TMenuItem;
    Mountain1: TMenuItem;
    XRay1: TMenuItem;
    HotPerforated2: TMenuItem;
    il1TBX: TImageList;
    il4: TImageList;
    actEditDelete: TAction;
    actDqLineGroupDetect: TAction;
    actDqDebug_lin: TAction;
    actDqDebug_grp: TAction;
    actDqDebug_region: TAction;
    actDqDebug_Toggle: TAction;
    actDqDebug_Jump: TAction;
    actDqDebug_Western: TAction;
    dlgOpenPic1: TOpenPictureDialog;
    procedure actOpenStitchExecute(Sender: TObject);
    procedure actFileNew1Execute(Sender: TObject);
    procedure actHelpAbout1Execute(Sender: TObject);
    procedure actFileExit1Execute(Sender: TObject);
    procedure actFileSave1Execute(Sender: TObject);
    procedure actFileSaveAs1Execute(Sender: TObject);
    procedure actFileSaveAs1Update(Sender: TObject);
    procedure actFileSave1Update(Sender: TObject);
    procedure actQualityChanged(Sender: TObject);
    procedure actQualityUpdate(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure actEditDeleteUpdate(Sender: TObject);
    procedure actEditDeleteExecute(Sender: TObject);
  private
    { Private declarations }
    FChildInc : Integer;
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

uses
  umDmTool, gmTool_Shape,
  gmIntegrator, gmTool_Zoom,  gmTool_Hand, 
  gmSwatch_rwTHR, //gmSwatch_rwACO, gmSwatch_rwSWA,
  Stitch_FileDlg, gmCore_FileDlg {universal FileDlg}, Embroidery_Viewer, stitch_Items,
  Thred_Constants,
  
  umChild, umMain,
  about;
{$R *.dfm}

procedure TDM.actOpenStitchExecute(Sender: TObject);
var i : Integer;
begin

  //with TOpenStitchsDialog.Create(Self) do
  //with TOpenDialog.Create(self) do
  with TgmOpenDialog.Create(Self) do
  //with TOpenPictureDialog.Create(self) do
  begin
    ViewerClassName := TgmEmbroideryViewer.ClassName;
    Options := Options + [ofAllowMultiSelect];
    if Execute then
      for i := 0 to Files.Count -1  do
      begin
        CreateMDIChild(Files[i]);
      end;
    Free;
  end;

end;

procedure TDM.actFileNew1Execute(Sender: TObject);
begin
  Inc(FChildInc);
  CreateMDIChild('NONAME' + IntToStr(FChildInc {Application.MainForm.MDIChildCount + 1}));
end;

procedure TDM.actHelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TDM.actFileExit1Execute(Sender: TObject);
begin
  Application.MainForm.Close;
end;

procedure TDM.actFileSave1Execute(Sender: TObject);
///var LStitchs : TStitchList;
begin
  assert(assigned(Application.Mainform.ActiveMDIChild));// error should happen in programming level.
///
{  LStitchs := TfcDesign(Application.MainForm.ActiveMDIChild).Stitchs;
  if LStitchs.FileName <> '' then
  begin
    LStitchs.SaveToFile(LStitchs.FileName);
  end
  else
}  
//    mnu_FILE_SAVE3Click(Sender); //SaveAs
end;

procedure TDM.actFileSaveAs1Execute(Sender: TObject);
///var LStitchs : TStitchList;
begin
  assert(assigned(Application.Mainform.ActiveMDIChild));// error should happen in programming level.
///
{  LStitchs := TfcDesign(Application.MainForm.ActiveMDIChild).Stitchs;
  with TSaveStitchsDialog.Create(Self) do
  begin
    if Execute then
      LStitchs.SaveToFile(FileName);


    Free;
  end;
}  
end;

procedure TDM.actFileSaveAs1Update(Sender: TObject);
begin
  TAction(sender).Enabled := Assigned(Application.Mainform.ActiveMDIChild ) and
    (Application.Mainform.ActiveMDIChild is TfcDesign);
end;

procedure TDM.actFileSave1Update(Sender: TObject);
begin
  TAction(sender).Enabled := Assigned(Application.Mainform.ActiveMDIChild ) and
    (Application.Mainform.ActiveMDIChild is TfcDesign) and
    TfcDesign(Application.Mainform.ActiveMDIChild).Modified ;
end;

{ TImageList }
{$IFDEF DISABLED_IL}
procedure TImageList.DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer;
  Style: Cardinal; Enabled: Boolean);
begin
  if Enabled {or (ColorDepth <> cd32Bit)} then
    inherited
  else
    if self <> DM.il1 then
      inherited
    else
      if Application.MainForm.ClassType = TMainForm then //dont custom draw in TBX
        dm.il3.DoDraw(index, Canvas, X, Y, Style, True)
      else
        inherited;

end;
{$ENDIF}

procedure TDM.actQualityChanged(Sender: TObject);
var
  LAction : TAction;
begin
  LAction := TAction(Sender);
  with Application.MainForm do
  begin
    if Assigned(ActiveMDIChild) and (ActiveMDIChild is TfcDesign) then
      TfcDesign(ActiveMDIChild).DrawQuality :=  LAction.Tag;

    if (LAction <> actDqTogglePhoto) and (LAction.Tag in [DQINDOORPHOTO, DQOUTDOORPHOTO]) then
    begin
      actDqTogglePhoto.Assign(LAction);
      actDqTogglePhoto.Tag := LAction.Tag;
    end;
    if (LAction <> actDqDebug_Toggle) and (LAction.Tag in [8,9,10,11,12]) then
    begin
      actDqDebug_Toggle.Assign(LAction);
      actDqDebug_Toggle.Tag := LAction.Tag;
    end;
  end;
end;

procedure TDM.actQualityUpdate(Sender: TObject);
begin
  with Application.MainForm do
  begin
    TAction(Sender).Enabled := Assigned(ActiveMDIChild) and (ActiveMDIChild is TfcDesign);
    if TAction(Sender).Enabled then
      TAction(Sender).Checked := TAction(Sender).Enabled and (TfcDesign(ActiveMDIChild).DrawQuality = TAction(Sender).Tag);
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  actDqTogglePhoto.Assign(actDqPhoto);
  actDqTogglePhoto.Tag := actDqPhoto.Tag;
end;

procedure TDM.actEditDeleteUpdate(Sender: TObject);
begin
  dmTool.actAtleast1SelectionUpdate(Sender);
end;

procedure TDM.actEditDeleteExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).DeleteSelection;
end;

end.
