unit umMain;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, //XPMan,
  GR32_Image,
  gmGridBased_ListView,  gmSwatch_ListView, gmGridBased_List, gmSwatch_List,
  Thred_Types, Thred_Constants, Thred_Defaults, AppEvnts, GR32_RangeBars,

  umChild, umDM, gmRuller{should be put after Controls in USES.INTEFACE. need to subclassing the disabled menuitem};

type
  TMainForm = class(TForm)
    ToolBar2: TToolBar;
    btnOpenStitch: TToolButton;
    btnFileSave1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    btnFileNew1: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    swlDefault: TgmSwatchList;
    swlCustom: TgmSwatchList;
    pmForm: TPopupMenu;
    Line1: TMenuItem;
    Freehand1: TMenuItem;
    RegularPolygon1: TMenuItem;
    pnlStatusBar: TPanel;
    appevents1: TApplicationEvents;
    pnlHint: TPanel;
    pnlZoom: TPanel;
    gau1: TGaugeBar;
    pnlSidebar: TPanel;
    pnl2: TPanel;
    pnlTools: TPanel;
    pgscrlr1: TPageScroller;
    swaDefault: TgmSwatchListView;
    swaCustom: TgmSwatchListView;
    btnSizeWrapper: TSpeedButton;
    btnHand: TSpeedButton;
    btnCurve: TSpeedButton;
    btnZoom: TSpeedButton;
    rullerH: TgmRuller;
    rullerV: TgmRuller;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure appevents1Hint(Sender: TObject);
    procedure btnZoomClick(Sender: TObject);
    procedure btnHandClick(Sender: TObject);
  private
    { Private declarations }
    FParamsLoaded : boolean;
    function GetActiveChild: TMDIChild;
    procedure SetActiveChild(const Value: TMDIChild);
    //FIni : TThredIniFile;
  public
    { Public declarations }
    property ActiveChild : TMDIChild read GetActiveChild write SetActiveChild; //special purpose. it able to set as nil value!
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses about,
  GR32_Polygons,
  gmIntegrator, gmTool_Zoom,  gmTool_Hand,
  gmSwatch_rwTHR, gmSwatch_rwACO, gmSwatch_rwSWA,
  Stitch_FileDlg;



procedure TMainForm.FormCreate(Sender: TObject);
var i : integer;
begin

  //WE NEED TO CORRECT ALL NEED IN RUNTIME HERE, BECAUSE WE STILL NEED THEM IN DESIGN TIME.

  // fixup captions
  pnlHint.Caption := '';

  // add TMainMenu to this form.
  self.Menu := dm.mm1;
  self.WindowMenu := dm.Window1;


  //redini;
  {Fini.StitchColors :=  defUseCol;
  custCol := defCustCol;
  bakCust := defBakCust;
  bakBit  := defBakBit;}

  //Load default colors to swatch.
  for i := 0 to 15 do
  begin
    swlDefault.Add;
    swlDefault[i].Color := defCol[i];// defUseCol[i];

    swlCustom.Add;
    swlCustom[i].Color := defUseCol[i];
  end;

  swaCustom.Changed;
  swaDefault.Changed;
    

end;

procedure TMainForm.FormActivate(Sender: TObject);
var i : integer;
begin
  //Load some files such supplied by parameters. (if any.)
  if not FParamsLoaded then
  begin
    FParamsLoaded := true;
    if paramcount > 0 then
      for i := 1 to Paramcount do
        CreateMDIChild(paramstr(i));

  end;
  //We couldn't put this code in FormOnCreate because childForm won't loaded
  //while no MDIParent is activated. 
end;

procedure TMainForm.appevents1Hint(Sender: TObject);
begin
  //PnlHint.Caption := application.Hint;
end;





function TMainForm.GetActiveChild: TMDIChild;
begin
  result := TMDIChild(self.ActiveMDIChild); //property create by borland. perhap nil.
  if assigned(result) and not (result is TMDIChild) then //make sure correct type.
    result := nil;
end;

procedure TMainForm.SetActiveChild(const Value: TMDIChild);
begin
  if Value = nil then
  begin
    swaCustom.SwatchList := swlCustom;
    rullerH.Image32 := nil;
    rullerV.Image32 := nil;


  end
  else
  begin
    swaCustom.SwatchList := value.swlCustom;
    rullerH.Image32 := value.imgStitchs;
    rullerV.Image32 := value.imgStitchs;
  end;
end;

procedure TMainForm.btnZoomClick(Sender: TObject);
begin
    btnZoom.Down := gmSelectTool(TgmtoolZoom);
end;

procedure TMainForm.btnHandClick(Sender: TObject);
begin
  self.btnHand.Down := gmSelectTool(TgmtoolHand);
end;

end.
