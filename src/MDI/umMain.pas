unit umMain;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, //XPMan,
  
  {Graphics32}
  GR32_Image, GR32_RangeBars,

  {Graphics Magic}
  gmRuller, gmGridBased_ListView,  gmSwatch_ListView, gmGridBased_List, gmSwatch_List,
  Thred_Types, Thred_Constants, Thred_Defaults, AppEvnts,

  {This project units}
  umDM{should be put after Controls in USES.INTEFACE. need to subclassing the disabled menuitem},
  umChild;

type
  TMainForm = class(TForm)
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
    rullerH: TgmRuller;
    rullerV: TgmRuller;
    ctrlbr1: TControlBar;
    tb1: TToolBar;
    btnFileNew2: TToolButton;
    btnOpenStitch1: TToolButton;
    btnFileSave2: TToolButton;
    btn1: TToolButton;
    btn2: TToolButton;
    btn3: TToolButton;
    btn4: TToolButton;
    btn5: TToolButton;
    btn6: TToolButton;
    btn7: TToolButton;
    btn8: TToolButton;
    tbChildren: TToolBar;
    btnSolid: TToolButton;
    pnl1: TPanel;
    tb2: TToolBar;
    btnToolHand: TToolButton;
    btnToolZoom: TToolButton;
    btnPhoto: TToolButton;
    btnMountain: TToolButton;
    btnXRay: TToolButton;
    btnHotPerforated: TToolButton;
    btnWireframe: TToolButton;
    btn9: TToolButton;
    btnUseOrdinalColor: TToolButton;
    pmDqPhoto: TPopupMenu;
    Photo1: TMenuItem;
    OutdoorPhoto1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure appevents1Hint(Sender: TObject);
    procedure gau1Change(Sender: TObject);
    procedure pnlZoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FParamsLoaded : boolean;
    function GetActiveChild: TMDIChild;
    procedure SetActiveChild(const Value: TMDIChild);
    //FIni : TThredIniFile;
  public
    { Public declarations }
    //procedure ChildMoved(AChild : TMDIChild); rullerRedraw!
    procedure RullersRedraw;
    property ActiveChild : TMDIChild read GetActiveChild write SetActiveChild; //special purpose. it able to set as nil value!
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses about,
  GR32_Polygons,
  gmIntegrator, 
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

  //correct the most left drawn ruller.
  rullerH.ZeroPixel := pnlTools.Width + rullerV.Width;


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
  //while no MDIParent was activated yet. 
end;

procedure TMainForm.appevents1Hint(Sender: TObject);
begin
  PnlHint.Caption := application.Hint;
end;





function TMainForm.GetActiveChild: TMDIChild;
begin
  result := TMDIChild(self.ActiveMDIChild); //property create by borland. perhap nil.
  if assigned(result) and not (result is TMDIChild) then //make sure correct type.
    result := nil;
end;

type
  TToolBarAccess = class(TToolBar) end;
  
procedure TMainForm.SetActiveChild(const Value: TMDIChild);
var i : integer;
begin
  if Value = nil then
  begin
    swaCustom.SwatchList := swlCustom;
    {tbChildren.Hide;
    for i := 0 to tbChildren.ButtonCount -1 do
    begin
      tbChildren.Buttons[i].Action := nil;
    end;}

    rullerH.Image32 := nil;
    rullerV.Image32 := nil;
  end
  else
  begin
    swaCustom.SwatchList := value.swlCustom;
    rullerH.Image32 := value.imgStitchs;
    rullerV.Image32 := value.imgStitchs;
    {for i := 0 to value.tbChildren.ButtonCount -1 do
    begin
      if tbChildren.ButtonCount <= i then
        with TToolButton.Create(self) do
        begin
          parent := tbChildren;
        end;
      //tbChildren.Buttons[i].Assign(value.tbChildren.Buttons[i]);
      tbChildren.Buttons[i].Style := value.tbChildren.Buttons[i].Style;
      tbChildren.Buttons[i].Width := value.tbChildren.Buttons[i].Width;
      tbChildren.Buttons[i].Action := value.tbChildren.Buttons[i].Action;
      tbChildren.Buttons[i].AllowAllUp := value.tbChildren.Buttons[i].AllowAllUp;
    end;
    tbChildren.Images := Value.tbChildren.Images;
    tbchildren.Show;}


  end;
end;


procedure TMainForm.RullersRedraw;
begin
  //reflect the ruller of moved child
  rullerH.Repaint;
  rullerV.Repaint;
end;


procedure TMainForm.gau1Change(Sender: TObject);
var
  LScale : single;
const
  scales : array[0..5] of single = (0.25, 0.50, 1, 2,4, 8);  
begin
  LScale := scales[gau1.Position];
  pnlZoom.Caption := format('%.0f%%', [Lscale*100]);
  if assigned(ActiveChild) then
    ActiveChild.imgStitchs.Scale := LScale;
  RullersRedraw;
end;



procedure TMainForm.pnlZoomMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
//RESIZE WINDOW BY THIS FORM  
{$IFNDEF PLATFORM_INDEPENDENT}
var
  Action: Cardinal;
  Msg: TMessage;
  P: TPoint;
{$ENDIF}
begin
{$IFNDEF PLATFORM_INDEPENDENT}
  //if IsSizeGripVisible and (Owner is TCustomForm) then
  begin
    P.X := X; P.Y := Y;
    //if PtInRect(GetSizeGripRect, P) then
    begin
      Action := HTBOTTOMRIGHT;
      Application.ProcessMessages;
      Msg.Msg := WM_NCLBUTTONDOWN;
      Msg.WParam := Action;
      SetCaptureControl(nil);
      with Msg do SendMessage(self.Handle, Msg, wParam, lParam);
      Exit;
    end;
  end;
{$ENDIF}
end;

end.
