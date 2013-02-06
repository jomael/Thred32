unit umChild;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Messages, StdCtrls, SysUtils,
{GR32}
  GR32, GR32_Image, GR32_Layers,
{GraphicsMagic}
  gmIntegrator, //gmGridBased_List,
  //gmSwatch_List,
  gmIntercept_GR32_Image,
{Thred32}
  Stitch_items, Stitch_rwTHR, Stitch_rwPCS, Stitch_rwPES,
  Stitch_Lines32,

  Form_cpp, Menus, ActnList, ComCtrls, ToolWin, ExtCtrls, gmCore_Items,
  gmGridBased, gmSwatch ;

type
  TfcDesign = class(TForm)
    swlCustom: TgmSwatchList;
    imgStitchs: TImgView32;
    timerLazyLoad: TTimer;
    lblLoading: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actUseOrdinalColorExecute(Sender: TObject);
    procedure imgStitchsScroll(Sender: TObject);
    procedure timerLazyLoadTimer(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure imgStitchsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
  private
    { Private declarations }
    FStitchs : TStitchList;
    FDrawLine : TStitch_LineProc;
    FDrawQuality : Integer;
    FModified: boolean;
    FStitchLoaded : boolean;
    gmSource : TgmIntegratorSource;
    FUseOrdinalColor: boolean;
    procedure SetDrawQuality(const Value: Integer);
    procedure SetUseOrdinalColor(const Value: boolean);
  protected
    //fired when starting/during/ending a "move" or "size" window
    procedure WMEnterSizeMove(var Msg: TMessage) ; message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var Msg: TMessage) ; message WM_EXITSIZEMOVE;
    procedure WMPosChanging(var Msg : TMessage); message WM_WINDOWPOSCHANGING;


  public
    { Public declarations }
    procedure DrawStitchs;
    procedure LoadFromFile(const AFileName: string);
    property Stitchs : TStitchList read FStitchs;
    property Modified : boolean read FModified;
    property DrawQuality : Integer read FDrawQuality write SetDrawQuality;// render func index
    property UseOrdinalColor : boolean read FUseOrdinalColor write SetUseOrdinalColor;    
  end;


//Global proc
procedure CreateMDIChild(const AFileName: string); //called by MainForm.


implementation

uses umMain, umDm, Thred_Constants, Thred_Defaults, Thred_Types, Math;

{$R *.dfm}
{$R VirtualTrees.res}

type
  TImgView32Access = class(TImgVIew32);

  
procedure CreateMDIChild(const AFileName: string);
var
  Child: TfcDesign;
begin
  { create a new MDI child window }
  Child := TfcDesign.Create(Application);
  Child.Caption := AFileName;
  //if FileExists(AFileName) then Child.LoadFromFile(AFileName);
  if FileExists(AFileName) then
    Child.FStitchs.FileName := AFileName; // Lazy Loading. for avoid flicker / hang while first time visibled.
end;

procedure TfcDesign.FormCreate(Sender: TObject);
var LSTREX : PSTREX;
begin
  FStitchs := TStitchList.Create(self);
  self.imgStitchs.Align := alClient;
  LSTREX := @FStitchs.HeaderEx;
  LSTREX.xhup := 400;
  LSTREX.yhup := 400;
  imgStitchs.Bitmap.SetSize(400,400);// hup size
  imgStitchs.Bitmap.Clear(clWhite32);
  
  FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
  FDrawQuality := DQINDOORPHOTO;
  gmSource := TgmIntegratorSource.Create(self);
  gmSource.Img32 := imgStitchs;

end;

procedure TfcDesign.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  TMainForm(Application.MainForm).ActiveChild := nil; //send signal to MDI form for ready reflect changes. such color swatch
end;

procedure TfcDesign.LoadFromFile(const AFileName: string);
var
  i : integer;
begin
  FStitchs.LoadFromFile(AFileName);
  for i := 0 to High(FStitchs.Colors) do
  begin
    if swlCustom.Count < i +1 then
      swlCustom.Add;
    swlCustom[i].Color := FStitchs.Colors[i];
  end;
  DrawStitchs();
  {imgStitchs.Show;
  lblLoading.Hide;

  if Application.MainForm.ActiveMDIChild = Self then
    FormActivate(self); // send signal to MDI MainForm
  }
end;


procedure TfcDesign.FormActivate(Sender: TObject);
begin
  //send signal to MDI MainForm to reflect my (childform) properties; such colors swatch
  self.gmSource.Activate; //set ready to TgmTool
  if imgStitchs.Visible then
    imgStitchs.SetFocus; //allow mouse wheel

  if Length(FStitchs.Stitchs) > 0 then
    TMainForm(Application.MainForm).ActiveChild := self;

end;

procedure TfcDesign.actUseOrdinalColorExecute(Sender: TObject);
begin
  self.DrawStitchs;
end;

procedure TfcDesign.DrawStitchs;
var i,j : Integer;
  zRat : TFloatPoint;
  ColorAt :Cardinal;
  LastColor,CurrentColor : TColor32;
  R : TFloatRect;
  
  first : boolean;
  b : byte;
begin

  //We will do painting while there is something to draw.
  //if Length(FStitchs.Stitchs) = 0 then exit;   But, we might have a new form.

  LastColor := clNone;

  {zRat.X := (imgStitchs.Width / FStitchs.HeaderEx.xhup );
  zRat.Y := (imgStitchs.Height / FStitchs.HeaderEx.yhup );

  if zRat.X < zRat.Y then
    zRat.Y := zRat.X
  else
    zRat.X := zRat.Y;
  }
  zRat.x := 1; //debug
  zRat.Y := 1; //debug


  with imgStitchs do
  begin
    BeginUpdate;
    try
      Bitmap.SetSize(   ceil(FStitchs.HeaderEx.xhup), ceil(FStitchs.HeaderEx.yhup) );
      Bitmap.Clear(clWhite32);
      R := FloatRect(0,0, FStitchs.HeaderEx.xhup * zRat.X, FStitchs.HeaderEx.yhup * zRat.Y);
      //pb.Buffer.FillRectTS(MakeRect(R), Color32(FStitchs.BgColor));
      FDrawLine(Bitmap, R, Color32(FStitchs.BgColor), sdlStart);
      //STITCH
      for i := 0 to High(FStitchs.stitchs) do
      begin
        Bitmap.PenColor:= clBlack32;
        with FStitchs.stitchs[i] do
        begin
          ColorAt := at and $FF;
          if ColorAt > High(FStitchs.colors) then
            ColorAt := at and $0F;

          if UseOrdinalColor then
            CurrentColor := Color32( defCol[ ColorAt ] )
          else
            CurrentColor := Color32( FStitchs.Colors[ ColorAt ] );

          if i = 0 then
          begin
            R.TopLeft := floatPoint(x * zRat.X, y * zRat.Y);
          end
          else
          begin
            R.BottomRight := floatPoint(x * zRat.X, y * zRat.Y);

            //JUMP STITCH + COLOR CHANGED.
            if CurrentColor = LastColor then
            FDrawLine(Bitmap, R, CurrentColor, sdlLine);

            R.TopLeft := R.BottomRight;

          end;
          LastColor := CurrentColor;
          {if i = 0 then
            pb.Buffer.MoveToF(x * zRat.X, y * zRat.Y)
          else
            pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y);}
        end;
      end;
      R := FloatRect(0,0, FStitchs.HeaderEx.xhup * zRat.X, FStitchs.HeaderEx.yhup * zRat.Y);
    
      FDrawLine(Bitmap, R, Color32(FStitchs.BgColor), sdlFinish);

      //FORMS
      Bitmap.PenColor:= clTrRed32;
      if length(FStitchs.Forms) > 0 then
      //for i := 0 to FStitchs.Header.fpnt -1 do
      for i := 0 to Length(FStitchs.Forms) -1 do
      begin
        if length(FStitchs.Forms[i].flt) = 0 then continue;

        first := true;
        for j := 0 to high(FStitchs.Forms[i].flt)  do
        begin

          //color
          if length(FStitchs.Forms[i].clp) > 0 then
          begin
            b := round(FStitchs.Forms[i].clp[j].X);
            if b > 15 then
               b := b mod 16;
            Bitmap.PenColor:= Color32( FStitchs.Colors[ b ] );

          end;
        
          with FStitchs.Forms[i].flt[j] do
          if first then
            Bitmap.MoveToF(x * zRat.X, y * zRat.Y)
          else
            Bitmap.LineToFS(x * zRat.X, y * zRat.Y);

          first := false;
        end;
        //back to first point
          with FStitchs.Forms[i].flt[0] do
            Bitmap.LineToFS(x * zRat.X, y * zRat.Y)
      end;
    finally
      EndUpdate;
      Changed;
    end;
  end;


end;

procedure TfcDesign.WMEnterSizeMove(var Msg: TMessage);
begin
  //code here
  inherited;
end;

procedure TfcDesign.WMExitSizeMove(var Msg: TMessage);
begin
  //code here
  TMainForm(Application.MainForm).RullersRedraw;
  inherited
end;

procedure TfcDesign.WMPosChanging(var Msg: TMessage);
begin
  //code here
  TMainForm(Application.MainForm).RullersRedraw;
  inherited;
end;

  
procedure TfcDesign.imgStitchsScroll(Sender: TObject);
begin
  TMainForm(Application.MainForm).RullersRedraw;
  //caption := format('%d, %d',[TImgView32Access(imgStitchs).HScroll.Range, TImgView32Access(imgStitchs).VScroll.Range]);
end;

procedure TfcDesign.timerLazyLoadTimer(Sender: TObject);
begin
  if not (csLoading in self.ComponentState) and self.Visible and not FStitchLoaded then
  begin
    timerLazyLoad.Enabled := False;
    FStitchLoaded := True;
    if FStitchs.FileName <> '' then
    begin
      self.LoadFromFile(FStitchs.FileName);
    end
    else
    begin
      
    end;
    imgStitchs.Show;
    lblLoading.Hide;

    if Application.MainForm.ActiveMDIChild = Self then
      FormActivate(self); // send signal to MDI MainForm
  end;

end;

procedure TfcDesign.SetDrawQuality(const Value: Integer);
begin
  if FDrawQuality <> Value then
  begin
    FDrawQuality := Value;
    //it is modified by my own (childform) render quality menu.
    case Value of
      1 : FDrawLine := DrawWireFrame;
      2 : FDrawLine := DrawLineFS;  //Solid
      3 : FDrawLine := Draw3DLine;  //Photo
      4 : FDrawLine := DrawLineStippled;//Outdoor Photo
      5 : FDrawLine := DrawMountain;
      6 : FDrawLine := DrawXRay;        //
      7 : FDrawLine := DrawHotPressure;
    end;
    //pb.Repaint;
    self.DrawStitchs;
  end;

end;

procedure TfcDesign.SetUseOrdinalColor(const Value: boolean);
begin
  if FUseOrdinalColor <> Value then
  begin
    FUseOrdinalColor := Value;
    DrawStitchs;
  end;
end;

procedure TfcDesign.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if [ssShift, ssAlt] * Shift <> [] then //modifiered?
    imgStitchs.Scroll(16,0) //
  else
    imgStitchs.Scroll(0, 16) //end;
end;

procedure TfcDesign.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if [ssShift, ssAlt] * Shift <> [] then //modifiered?
    imgStitchs.Scroll(-16, 0) //
  else
    imgStitchs.Scroll(0, -16) //end;
end;

procedure TfcDesign.imgStitchsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  caption :=  inttostr(Ord(Button));
end;

end.
