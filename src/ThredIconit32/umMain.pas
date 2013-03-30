unit umMain;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, //XPMan,
  
{Graphics32}
  GR32_Image, GR32_RangeBars,

{Graphics Magic}
  gmRuller, //gmGridBased_ListView,
  gmSwatch_ListView, //gmGridBased_List, gmSwatch_List,
  AppEvnts,

{This project units}
  umDM{should be put after Controls in USES.INTEFACE. need to subclassing the disabled menuitem},
  umChild, gmCore_Items, gmGridBased, gmSwatch, gmCore_Viewer,
  gmGridBased_ListView, Spin, Tabs;

type
  TMainForm = class(TForm)
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
    pnlTools: TPanel;
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
    tb3: TToolBar;
    btnToolLineNew: TToolButton;
    btnToolLineInsert: TToolButton;
    mmo1: TMemo;
    tb2: TToolBar;
    btnToolStitch: TToolButton;
    btnToolZoom: TToolButton;
    btnToolHand: TToolButton;
    btnToolZoom1: TToolButton;
    btnDqOutdoorPhoto: TToolButton;
    spl1: TSplitter;
    btnToolSelect: TToolButton;
    btn10: TToolButton;
    btnShapeStar: TToolButton;
    btnShapeEllipse: TToolButton;
    btnShapeRegular: TToolButton;
    spinVertex: TSpinEdit;
    ctrlbr2: TControlBar;
    tb7: TToolBar;
    btnToolSelect1: TToolButton;
    btnToolShape: TToolButton;
    btnToolStitch1: TToolButton;
    btnToolHand1: TToolButton;
    btnToolZoom2: TToolButton;
    btn11: TToolButton;
    btnGroupCombine: TToolButton;
    btnGroupExtract: TToolButton;
    ToolButton1: TToolButton;
    btnEditDelete: TToolButton;
    ToolButton2: TToolButton;
    btnGroupIntersect: TToolButton;
    btnGroupUnion: TToolButton;
    btnGroupTrim: TToolButton;
    ToolButton3: TToolButton;
    btnDqLineGroupDetect: TToolButton;
    pmDqDebug: TPopupMenu;
    actDqDebuglin1: TMenuItem;
    actDqDebuggrp1: TMenuItem;
    actDqDebugregion1: TMenuItem;
    DebugJump1: TMenuItem;
    actDqDebugWestern1: TMenuItem;
    btnGroupXOR: TToolButton;
    ToolButton4: TToolButton;
    actDqDebugRGNS1: TMenuItem;
    btnDaisy: TToolButton;
    ToolButton5: TToolButton;
    btnShapeDaisy: TToolButton;
    btnDqDebug_Brk: TToolButton;
    btnDqDebug_CntBrk: TToolButton;
    btn12: TToolButton;
    btn13: TToolButton;
    btn14: TToolButton;
    btnEditUndo: TToolButton;
    ToolButton7: TToolButton;
    btnEditRedo: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure appevents1Hint(Sender: TObject);
    procedure gau1Change(Sender: TObject);
    procedure pnlZoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure appevents1Exception(Sender: TObject; E: Exception);
    procedure appevents1ActionUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure btnDaisyClick(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure btn14Click(Sender: TObject);
  private
    { Private declarations }
    FParamsLoaded : boolean;
    FIdentLog : Integer;
    FActUpdateLog : Boolean;
    procedure rullerVOnSetBound(Sender : TObject);
    function GetActiveChild: TfcDesign;
    procedure SetActiveChild(const Value: TfcDesign);
    procedure DebugLog(Sender : TObject; const Msg : string; Ident : Integer);
    //FIni : TThredIniFile;
  public
    { Public declarations }
    //procedure ChildMoved(AChild : TMDIChild); rullerRedraw!
    procedure RullersRedraw;
    property ActiveChild : TfcDesign read GetActiveChild write SetActiveChild; //special purpose. it able to set as nil value!
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  //StrUtils,
  about,
  GR32_Polygons,
  gmIntegrator, gmTool_Shape, gmShape, //gmGradient,
  gmCore_UndoRedo,
  umDmTool
  //uFormSelector
  , umDaisyDlg;



procedure TMainForm.FormCreate(Sender: TObject);
var i : integer;
begin

  //WE NEED TO CORRECT ALL NEED IN RUNTIME HERE, BECAUSE WE STILL NEED THEM IN DESIGN TIME.

  // fixup captions
  pnlHint.Caption := '';

  // add TMainMenu to this form.
  self.Menu := dm.mm1;
  self.WindowMenu := dm.mnhdWindow;

  //correct the most left drawn ruller.
  rullerH.ZeroPixel := pnlTools.Width + rullerV.Width;

  //INTEGRATOR
  ActiveIntegrator.OnDebugLog := self.DebugLog;
  FActUpdateLog := True;

  rullerV.OnSetBound := rullerVOnSetBound;
end;

procedure TMainForm.FormActivate(Sender: TObject);
var i : integer;
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormActivate', 0); {$ENDIF}
  //Load some files such supplied by parameters. (if any.)
  if not FParamsLoaded then
  begin
    FParamsLoaded := true;
    if paramcount > 0 then
    begin
      for i := 1 to Paramcount do
        CreateMDIChild(paramstr(i));
    end
    else
        TfcDesign.Create(Application);

    dmTool.actToolShape.Execute;
    dmTool.actShapeRegular.Execute;

  end;
  //We couldn't put this code in FormOnCreate because childForm won't loaded
  //while no MDIParent was activated yet. 
end;

procedure TMainForm.appevents1Hint(Sender: TObject);
begin
  PnlHint.Caption := application.Hint;
end;





function TMainForm.GetActiveChild: TfcDesign;
begin
  result := TfcDesign(self.ActiveMDIChild); //property create by borland. perhap nil.
  if assigned(result) and not (result is TfcDesign) then //make sure correct type.
    result := nil;
end;

type
  TToolBarAccess = class(TToolBar) end;

procedure TMainForm.SetActiveChild(const Value: TfcDesign);
var i : integer;
begin
  if Value = nil then
  begin
    rullerH.Image32 := nil;
    rullerV.Image32 := nil;
  end
  else
  begin
    rullerH.Image32 := value.imgStitchs;
    rullerV.Image32 := value.imgStitchs;


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

procedure TMainForm.DebugLog(Sender: TObject; const Msg: string; Ident : integer);
var space : string;
  i : integer;
begin
  {$IFDEF DEBUGLOG}
  if Ident < 0 then
    dec(FIdentLog, Ident *-1);

  space := '';
  //while Length(space) < FIdentLog do
  for i := 0 to FIdentLog do
    space := space + '   ';

  mmo1.Lines.Add(Format('(%d) @%s %s : %s',[ FIdentLog, FormatDateTime('HH:mm:ss.zzz',now), space + Sender.ClassName, msg]) );

  if Ident > 0 then
    Inc(FIdentLog, Ident);
  {$ENDIF}
end;

procedure TMainForm.appevents1Exception(Sender: TObject; E: Exception);
begin
  FActUpdateLog := False;
  DebugLog(Self,E.ClassName +': '+ E.Message, 0);
end;

procedure TMainForm.appevents1ActionUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  if FActUpdateLog then
  DebugLog(Self,Action.Name+': Update', 0);
end;

procedure TMainForm.rullerVOnSetBound(Sender: TObject);
var L : Integer;
begin
  L := rullerV.ClientToScreen(Point(rullerV.Width,0)).X;

  rullerH.ZeroPixel :=   rullerH.ScreenToClient(Point(L,0)).X;
//
end;

procedure TMainForm.btnDaisyClick(Sender: TObject);
begin
  frmDaisyDlg.ShowModal
end;

procedure TMainForm.btn13Click(Sender: TObject);
  function ComponentToString(Component: TComponent): string;

  var
    BinStream:TMemoryStream;
    StrStream: TStringStream;
    s: string;
  begin
    BinStream := TMemoryStream.Create;
    try
      StrStream := TStringStream.Create(s);
      try
        BinStream.WriteComponent(Component);
        BinStream.Seek(0, soFromBeginning);
        ObjectBinaryToText(BinStream, StrStream);
        StrStream.Seek(0, soFromBeginning);
        Result:= StrStream.DataString;
      finally
        StrStream.Free;

      end;
    finally
      BinStream.Free
    end;
  end;
var
  s : string;
begin
  s := '?';
  if GetActiveChild() <> nil then
    s := ComponentToString(self.GetActiveChild.ShapeList);
  mmo1.Lines.Text := s;
end;

procedure TMainForm.btn14Click(Sender: TObject);
    procedure StringToComponent(Value: string; Component: TComponent);
    var
      StrStream:TStringStream;
      BinStream: TMemoryStream;
    begin
      StrStream := TStringStream.Create(Value);
      try
        BinStream := TMemoryStream.Create;
        try
          ObjectTextToBinary(StrStream, BinStream);
          BinStream.Seek(0, soFromBeginning);
          BinStream.ReadComponent(Component);

        finally
          BinStream.Free;
        end;
      finally
        StrStream.Free;
      end;
    end;

var
  s : string;
begin
  s := mmo1.Lines.Text;
  if s <> '' then
  begin
    if GetActiveChild() <> nil then
      StringToComponent(s, self.GetActiveChild.ShapeList);

  end;  
//
end;

end.
