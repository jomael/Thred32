unit umDm;

interface

uses
  SysUtils, Classes, Graphics, Forms, StdActns, ActnList, ImgList, Controls, Dialogs, Menus,
  AppEvnts, ExtDlgs, Thred_Types;

  
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
    actDqDebug_RGNS: TAction;
    actDqDebug_Brk: TAction;
    actDqDebug_CntBrk: TAction;
    actEditUndo: TAction;
    actEditRedo: TAction;
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
    procedure actEditUndoExecute(Sender: TObject);
    procedure actEditUndoUpdate(Sender: TObject);
    procedure actEditRedoUpdate(Sender: TObject);
    procedure actEditUndoHint(var HintStr: String; var CanShow: Boolean);
    procedure actEditRedoExecute(Sender: TObject);
  private
    { Private declarations }
    FChildInc : Integer;
    FThredIni: TThredIniFile;
    procedure DefaultPreference;

  public
    { Public declarations }
    property ThredIni : TThredIniFile read FThredIni;
    
    procedure ReadIni(ThredIniFileName : TFileName);
  end;

var
  DM: TDM;

implementation

uses
  umDmTool, gmTool_Shape,
  gmIntegrator, gmTool_Zoom,  gmTool_Hand, 
  gmSwatch_rwTHR, //gmSwatch_rwACO, gmSwatch_rwSWA,
  Stitch_FileDlg, gmCore_FileDlg {universal FileDlg},
  Embroidery_Viewer, Embroidery_Items, stitch_Items,
  Thred_Constants, Thred_Defaults,
  
  umChild, umMain,
  about;
{$R *.dfm}

procedure TDM.actOpenStitchExecute(Sender: TObject);
var i : Integer;
begin

  //with TOpenStitchsDialog.Create(Self) do
  //with TOpenDialog.Create(self) do
  ////with TgmOpenDialog.Create(Self) do
  //with TOpenPictureDialog.Create(self)
  //with TPreviewFileDialog.Create(Self) do
  //with TMyOpenDialog.Create(self) do
  with TOurPictureDialog.Create(Self) do
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
var LStitchs : TEmbroideryList;
begin
  assert(assigned(Application.Mainform.ActiveMDIChild));// error should happen in programming level.

  LStitchs := TfcDesign(Application.MainForm.ActiveMDIChild).ShapeList;
  if LStitchs.FileName <> '' then
  begin
    LStitchs.SaveToFile(LStitchs.FileName);
  end
  else
     actFileSaveAs1Execute(Sender);
//    mnu_FILE_SAVE3Click(Sender); //SaveAs
end;

procedure TDM.actFileSaveAs1Execute(Sender: TObject);
var LStitchs : TEmbroideryList;
begin
  assert(assigned(Application.Mainform.ActiveMDIChild));// error should happen in programming level.

  LStitchs := TfcDesign(Application.MainForm.ActiveMDIChild).ShapeList;
  //with TSaveStitchsDialog.Create(Self) do
    with TOurPictureSaveDialog.Create(Self) do
  begin
    ViewerClassName := TgmEmbroideryViewer.ClassName;    
    if Execute then
      LStitchs.SaveToFile(FileName);


    Free;
  end;
  
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
    if (LAction <> actDqDebug_Toggle) and (LAction.Tag in [8,9,10,11,12,13]) then
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
  Self.ReadIni(ExtractFilePath(Application.ExeName)+'thred.ini');
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

procedure TDM.actEditUndoExecute(Sender: TObject);
var frm : TfcDesign;
begin
  frm := TfcDesign(Application.MainForm.ActiveMDIChild);
  if Assigned(frm) then
  begin
    frm.UndoRedo.Undo;
  end;
end;

procedure TDM.actEditUndoUpdate(Sender: TObject);
var frm : TfcDesign;
begin
  frm := nil;
  with Application.MainForm do
  begin
    frm := (ActiveMDIChild as TfcDesign);
    TAction(Sender).Enabled := Assigned(frm) and (frm.UndoRedo.CanUndo);
  end;
end;

procedure TDM.actEditRedoUpdate(Sender: TObject);
var frm : TfcDesign;
begin
  frm := TfcDesign(Application.MainForm.ActiveMDIChild);
  TAction(Sender).Enabled := Assigned(frm) and frm.UndoRedo.CanRedo;
end;

procedure TDM.actEditUndoHint(var HintStr: String; var CanShow: Boolean);
var frm : TfcDesign;
begin
  HintStr := 'Undo';
  frm := TfcDesign(Application.MainForm.ActiveMDIChild);
  if Assigned(frm) and frm.UndoRedo.CanUndo then

end;

procedure TDM.actEditRedoExecute(Sender: TObject);
var frm : TfcDesign;
begin
  frm := TfcDesign(Application.MainForm.ActiveMDIChild);
  if Assigned(frm) then
  begin
    frm.UndoRedo.Redo;
  end;
end;

procedure TDM.ReadIni(ThredIniFileName: TFileName);
var
  i, LFileHandle : Integer;
  LReadBytes     : Cardinal;
  F : file;
begin


  if FileExists(ThredIniFileName) then
  begin
    //LFileHandle := CreateFile( PAnsiChar(ThredIniFileName), GENERIC_READ, 0, nil, OPEN_EXISTING, 0, 0);
    //ReadFile(LFileHandle, FIni, SizeOf(FIni), LReadBytes, nil);
    
    AssignFile(F, ThredIniFileName);
    Reset(F,1);
    BlockRead(F,FThredIni, SizeOf(TThredIniFile), LFileHandle);


    if LReadBytes < 2061 then
    begin
      FThredIni.FormBoxPixels := DEFAULT_FORM_BOX_PIXELS;
    end;

    {for i := 0 to 15 do
    begin
      FUserColors[i]        := FIni.StitchColors[i];
      FCustomColors[i]      := FIni.PrefStitchColors[i];
      FBackCustomColors [i] := FIni.BackColors[i];
      FBitmapColors[i]      := FIni.BitmapBackColors[i];
    end;

    FStitchBackgroundColor     := FThredIni.StitchBackColor;
    FBitmapColor               := FIni.BitmapColor;
    FMinSize                   := FIni.MinSize;
    FShowStitchPointsThreshold := FIni.ShowPoints;

    if FIni.ThreadSize30 <> 0.0 then
    begin
      FThreadSize30 := FIni.ThreadSize30;
    end;

    if FIni.ThreadSize40 <> 0.0 then
    begin
      FThreadSize40 := FIni.ThreadSize40;
    end;

    if FIni.ThreadSize60 <> 0.0 then
    begin
      FThreadSize60 := FIni.ThreadSize60;
    end;

    if FIni.UserSize <> 0.0 then
    begin
      FUserSize := FIni.UserSize;
    end;

    if FIni.MaxSize = 0.0 then
    begin
      FIni.MaxSize := DEFAULT_MAX_STITCH_SIZE * PFGRAN;
    end;

    if FIni.SmallSize <> 0.0 then
    begin
      FSmallSize := FIni.SmallSize;
    end;

    FStitchBoxesThreshold := FIni.StitchBoxLevel;
    }
    if FThredIni.StitchSpacing <> 0.0 then             
    begin
      //FStitchSpace := FIni.StitchSpace;
    end;
    {
    FuMap := FIni.umap;

    if FIni.BorderWidth <> 0.0 then
    begin
      FBorderWidth := FIni.BorderWidth;
    end;

    if FIni.AppliqueColor <> 0 then
    begin
      FAppliqueColor := FIni.AppliqueColor and $F;
    end;

    if FIni.SnapLength <> 0.0 then
    begin
      FSnapLength := FIni.SnapLength;
    end;

    if FIni.StarRatio <> 0.0 then
    begin
      FStarRatio := FIni.StarRatio;
    end;

    if FIni.SpiralWrap <> 0.0 then
    begin
      FSpiralWrap := FIni.SpiralWrap;
    end;

    if FIni.ButtonholeFillCornerLength <> 0.0 then
    begin
      FButtonholeFillCornerLength := FIni.ButtonholeFillCornerLength;
    end;

    if FIni.GridSize = 0.0 then
    begin
      FIni.GridSize := 12;
    end;

    if FIni.WavePoints = 0 then
    begin
      FIni.WavePoints := DEFAULT_WAVE_POINTS;
    end;

    if FIni.WaveStart = 0 then
    begin
      FIni.WaveStart := DEFAULT_WAVE_START;
    end;

    if FIni.WaveEnd = 0 then
    begin
      FIni.WaveEnd := DEFAULT_WAVE_END;
    end;

    if FIni.WaveLobes = 0 then
    begin
      FIni.WaveLobes := DEFAULT_WAVE_LOBES;
    end;

    if FIni.FeatherFillType = 0 then
    begin
      FIni.FeatherFillType := DEFAULT_FEATHER_TYPE;
    end;

    if FIni.FeatherUpCount = 0 then
    begin
      FIni.FeatherUpCount := DEFAULT_FEATHER_UP_COUNT;
    end;

    if FIni.FeatherDownCount = 0 then
    begin
      FIni.FeatherDownCount := DEFAULT_FEATHER_DOWN_COUNT;
    end;

    if FIni.FeatherRatio = 0.0 then
    begin
      FIni.FeatherRatio := DEFAULT_FEATHER_RATIO;
    end;

    if FIni.FeatherFloor = 0.0 then
    begin
      FIni.FeatherFloor := DEFAULT_FEATHER_FLOOR;
    end;

    if FIni.FeatherNum = 0 then
    begin
      FIni.FeatherNum := DEFAULT_FEATHER_NUM;
    end;

    if FIni.DaisyHoleLength = 0 then
    begin
      FIni.DaisyHoleLength := DAISY_HOLE_LENGTH;
    end;

    if FIni.DaisyCount = 0 then
    begin
      FIni.DaisyCount := DAISY_COUNT;
    end;

    if FIni.DaisyInnerCount = 0 then
    begin
      FIni.DaisyInnerCount := DAISY_INNER_COUNT;
    end;

    if FIni.DaisyLength = 0.0 then
    begin
      FIni.DaisyLength := DAISY_LENGTH;
    end;

    if FIni.DaisyPetals = 0 then
    begin
      FIni.DaisyPetals := DAISY_PETALS;
    end;

    if FIni.DaisyPetalLength = 0 then
    begin
      FIni.DaisyPetalLength := DAISY_PETAL_LENGTH;
    end;
    }
    case THoopSetting(FThredIni.HoopType) of
      hsSmallHoop:
        begin
          FThredIni.HoopXSize := SMALL_HOOP_X_SIZE;
          FThredIni.HoopYSize := SMALL_HOOP_Y_SIZE;
        end;

      hsLargeHoop:
        begin
          FThredIni.HoopXSize := LARGE_HOOP_X_SIZE;
          FThredIni.HoopYSize := LARGE_HOOP_Y_SIZE;
        end;

      hsCustomHoop:
        begin
          if FThredIni.HoopXSize <> 0.0 then
          begin
            FThredIni.HoopXSize := LARGE_HOOP_X_SIZE;
          end;

          if FThredIni.HoopYSize <> 0.0 then
          begin
            FThredIni.HoopYSize := LARGE_HOOP_Y_SIZE;
          end;
        end;

      hsHoop100:
        begin
          if FThredIni.HoopXSize <> 0.0 then
          begin
            FThredIni.HoopXSize := Hoop_100_XY_Size;
          end;

          if FThredIni.HoopYSize <> 0.0 then
          begin
            FThredIni.HoopYSize := Hoop_100_XY_Size;
          end;
        end;

    else
      FThredIni.HoopType  := Ord(hsLargeHoop);
      FThredIni.HoopXSize := LARGE_HOOP_X_SIZE;
      FThredIni.HoopYSize := LARGE_HOOP_Y_SIZE;
    end;

    //FUnzoomedStitchWindowWidth  := Round(FThredIni.HoopXSize);
    //FUnzoomedStitchWindowHeight := Round(FThredIni.HoopYSize);
    //FPicotSpace                 := FIni.PicotSpace;

    //FileClose(LFileHandle);
    CloseFile(F);
  end
  else
  begin
    DefaultPreference;
  end;

  if FThredIni.GridColor = 0 then
  begin
    FThredIni.GridColor := GRID_DEFAULT_COLOR;
  end;

  if FThredIni.FillAngle = 0.0 then
  begin
    FThredIni.FillAngle := PI / 6;
  end;

  if FThredIni.InitRect.Left < 0 then
  begin
    FThredIni.InitRect.Left := 0;
  end;

  if FThredIni.InitRect.Top < 0 then
  begin
    FThredIni.InitRect.Top := 0;
  end;

  {if FThredIni.InitRect.Right > imgvwDrawingArea.Bitmap.Width then
  begin
    FThredIni.InitRect.Right := imgvwDrawingArea.Bitmap.Width;
  end;

  if FThredIni.InitRect.Bottom > imgvwDrawingArea.Bitmap.Height then
  begin
    FThredIni.InitRect.Bottom := imgvwDrawingArea.Bitmap.Height;
  end;}

end;

procedure TDM.DefaultPreference;
var
  i : Integer;
begin


  for i := 0 to 15 do
  begin
    FThredIni.StitchColors[i]      := DEFAULT_USER_COLORS[i];
    FThredIni.PrefStitchColors[i]  := DEFAULT_CUSTOM_COLORS[i];
    FThredIni.BackColors[i]        := DEFAULT_BACK_CUSTOM_COLORS[i];
    FThredIni.BitmapBackColors[i]  := DEFAUL_BITMAP_COLORS[i];
  end;

  //DaisyDefaul();
      FThredIni.DaisyCount       := DAISY_COUNT;
      FThredIni.DaisyHoleLength  := DAISY_HOLE_LENGTH;
      FThredIni.DaisyInnerCount  := DAISY_INNER_COUNT;
      FThredIni.DaisyLength      := DAISY_LENGTH;
      FThredIni.DaisyPetals      := DAISY_PETALS;
      FThredIni.DaisyPetalLength := DAISY_PETAL_LENGTH;
      FThredIni.DaisyHeartCount  := DAISY_MIRROR_COUNT;


      FThredIni.DaisyBorderType  := DAISY_TYPE;
  
  {FAppliqueColor              := 15;
  FBorderWidth                := DEFAULT_SATING_BORDER_WIDTH;
  FButtonholeFillCornerLength := INITIAL_BUTTONHOLE_FILL_CORNER_LENGTH;
  }
  FThredIni.ChainSpace             := DEFAULT_CHAIN_STITCH_LENGTH;
  FThredIni.ChainRatio             := DEFAULT_CHAIN_STITCH_RATIO;
  FThredIni.FillAngle              := DEFAULT_FILL_ANGLE;

// rstu(SQRFIL)  

  FThredIni.StitchSpacing               := DEFAULT_STITCH_SPACE * PFGRAN;
///  FShowStitchPointsThreshold := SHOW_STITCH_POINTS_ZOOM_THRESHOLD;
  
  FThredIni.GridSize        := 12;
  FThredIni.HoopType        := Ord(hsLargeHoop);
  FThredIni.HoopXSize       := LARGE_HOOP_X_SIZE;
  FThredIni.HoopYSize       := LARGE_HOOP_Y_SIZE;
  FThredIni.CursorNudgeStep := DEFAULT_NUDGE_STEP;
  FThredIni.NudgePixels     := DEFAULT_NUDGE_PIXELS;

//  setu(BLUNT);
  {
  FSmallSize            := DEFAULT_SMALL_STITCH_SIZE * PFGRAN;
  FSnapLength           := DEFAULT_SNAP_LENGTH * PFGRAN;
  FSpiralWrap           := DEFAULT_SPIRAL_WRAP;
  FStarRatio            := DEFAULT_STAR_RATIO;
  FStitchBoxesThreshold := SHOW_STITCH_BOXES_ZOOM_THRESHOLD;
  }
  FThredIni.MaxSize := DEFAULT_MAX_STITCH_SIZE * PFGRAN;

///  FUserSize := USER_SIZE * PFGRAN;

  FThredIni.ClipboardOffset    := 0;
  FThredIni.ClipboardFillPhase := 0;

///  FBitmapColor := $C8DFEE;

  if FThredIni.CustomHoopWidth = 0.0 then
  begin
    FThredIni.CustomHoopWidth := LARGE_HOOP_X_SIZE;
  end;

  if FThredIni.CustomHoopHeight <> 0.0 then
  begin
    FThredIni.CustomHoopHeight := LARGE_HOOP_Y_SIZE;
  end;

///  FPicotSpace := INITIAL_PICOT_BORDER_SPACE;

//  setu(PIL2OF);
//  fil2men();
{
  FStitchBackgroundColor      := $A8C4B1;
  FUnzoomedStitchWindowWidth  := Round(FThredIni.HoopXSize);
  FUnzoomedStitchWindowHeight := Round(FThredIni.HoopYSize);
}
  FThredIni.WaveEnd              := DEFAULT_WAVE_END;
  FThredIni.WavePoints           := DEFAULT_WAVE_POINTS;
  FThredIni.WaveLobes            := DEFAULT_WAVE_LOBES;
  FThredIni.WaveStart            := DEFAULT_WAVE_START;
  FThredIni.FeatherFillType      := DEFAULT_FEATHER_TYPE;
  FThredIni.FeatherUpCount       := DEFAULT_FEATHER_UP_COUNT;
  FThredIni.FeatherDownCount     := DEFAULT_FEATHER_DOWN_COUNT;
  FThredIni.FeatherRatio         := DEFAULT_FEATHER_RATIO;
  FThredIni.FeatherFloor         := DEFAULT_FEATHER_FLOOR;
  FThredIni.FeatherNum           := DEFAULT_FEATHER_NUM;
  FThredIni.UnderlayStitchLength := DEFAULT_UNDERLAY_STITCH_LENGTH;
  FThredIni.UnderlaySpacing      := DEFAULT_UNDERLAY_STITCH_SPACE;
  FThredIni.FormBoxPixels        := DEFAULT_FORM_BOX_PIXELS;
  FThredIni.TextureFillHeight    := DEFAULT_TEXTURE_EDITOR_HEIGHT;
  FThredIni.TextureFillWidth     := DEFAULT_TEXTURE_EDITOR_WIDTH;
  FThredIni.TextureFillSpacing   := DEFAULT_TEXTURE_EDITOR_SPACING;

///  FGridColor     := GRID_DEFAULT_COLOR;
  FThredIni.GridColor := GRID_DEFAULT_COLOR;
end;

end.
