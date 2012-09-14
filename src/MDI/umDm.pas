unit umDm;

interface

uses
  SysUtils, Classes, Graphics, StdActns, ActnList, ImgList, Controls, Dialogs, Menus,
  AppEvnts;

  
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
    actlst1: TActionList;
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
    oolbsr1: TMenuItem;
    Window1: TMenuItem;
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
    procedure actOpenStitchExecute(Sender: TObject);
    procedure actFileNew1Execute(Sender: TObject);
    procedure actHelpAbout1Execute(Sender: TObject);
    procedure actFileExit1Execute(Sender: TObject);
    procedure actFileSave1Execute(Sender: TObject);
    procedure actFileSaveAs1Execute(Sender: TObject);
    procedure actFileSaveAs1Update(Sender: TObject);
    procedure actFileSave1Update(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

uses
  gmSwatch_rwTHR, gmSwatch_rwACO, gmSwatch_rwSWA,
  Stitch_FileDlg, stitch_Items,
  umChild, umMain, about;
{$R *.dfm}

procedure TDM.actOpenStitchExecute(Sender: TObject);
var i : Integer;
begin
  with TOpenStitchsDialog.Create(Self) do
  begin
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
  CreateMDIChild('NONAME' + IntToStr(MainForm.MDIChildCount + 1));
end;

procedure TDM.actHelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TDM.actFileExit1Execute(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TDM.actFileSave1Execute(Sender: TObject);
var LStitchs : TStitchCollection;
begin
  assert(assigned(Mainform.ActiveMDIChild));// error should happen in programming level.
  LStitchs := TMDIChild(Mainform.ActiveMDIChild).Stitchs;
  if LStitchs.FileName <> '' then
  begin
    LStitchs.SaveToFile(LStitchs.FileName);
  end
  else
//    mnu_FILE_SAVE3Click(Sender); //SaveAs
end;

procedure TDM.actFileSaveAs1Execute(Sender: TObject);
var LStitchs : TStitchCollection;
begin
  assert(assigned(Mainform.ActiveMDIChild));// error should happen in programming level.
  
  LStitchs := TMDIChild(Mainform.ActiveMDIChild).Stitchs;
  with TSaveStitchsDialog.Create(Self) do
  begin
    if Execute then
      LStitchs.SaveToFile(FileName);


    Free;
  end;
end;

procedure TDM.actFileSaveAs1Update(Sender: TObject);
begin
  TAction(sender).Enabled := Mainform.ActiveMDIChild is TMDIChild;
end;

procedure TDM.actFileSave1Update(Sender: TObject);
begin
  TAction(sender).Enabled := (Mainform.ActiveMDIChild is TMDIChild) and
    TMDIChild(Mainform.ActiveMDIChild).Modified ;
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
      dm.il3.DoDraw(index, Canvas, X, Y, Style, True);

end;
{$ENDIF}

end.
