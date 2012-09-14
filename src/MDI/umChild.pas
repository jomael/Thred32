unit umChild;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, SysUtils,
  {GR32}
  GR32, GR32_Image,
  {GraphicsMagic}
  gmIntegrator, gmGridBased_List, gmSwatch_List,
  {Thred32}
  Stitch_items, Stitch_rwTHR, Stitch_rwPCS, Stitch_rwPES,
  Stitch_Lines32,

  Form_cpp, Menus, ActnList ;

type
  TMDIChild = class(TForm)
    mm1: TMainMenu;
    View1: TMenuItem;
    Quality1: TMenuItem;
    N2: TMenuItem;
    yuiop1: TMenuItem;
    actlst1: TActionList;
    actXRay: TAction;
    actMountain: TAction;
    actPhoto: TAction;
    actOutdoorPhoto: TAction;
    actWireframe: TAction;
    actSolid: TAction;
    Solid1: TMenuItem;
    Photo1: TMenuItem;
    OutdoorPhoto1: TMenuItem;
    Mountain1: TMenuItem;
    XRay1: TMenuItem;
    actHotPerforated: TAction;
    HotPressure1: TMenuItem;
    swlCustom: TgmSwatchList;
    actUseOrdinalColor: TAction;
    N1: TMenuItem;
    UseOrdinalColor1: TMenuItem;
    imgStitchs: TImgView32;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure QualityChanged(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actUseOrdinalColorExecute(Sender: TObject);
  private
    { Private declarations }
    FStitchs : TStitchCollection;
    FDrawLine : TStitch_LineProc;
    FModified: boolean;
    gmSource : TgmIntegratorSource;
    procedure DrawStitchs;
  public
    { Public declarations }
    procedure LoadFromFile(const AFileName: string);
    property Stitchs : TStitchCollection read FStitchs;
    property Modified : boolean read FModified;    
  end;


//Global proc
procedure CreateMDIChild(const AFileName: string); //called by MainForm.


implementation

uses umMain, Thred_Defaults, Math;


{$R *.dfm}

procedure CreateMDIChild(const AFileName: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := AFileName;
  if FileExists(AFileName) then Child.LoadFromFile(AFileName);
end;

procedure TMDIChild.FormCreate(Sender: TObject);
begin
  FStitchs := TStitchCollection.Create(self);
  self.imgStitchs.Align := alClient;
  FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
  gmSource := TgmIntegratorSource.Create(self);
  gmSource.Img32 := imgStitchs;

end;

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  MainForm.ActiveChild := nil; //send signal to MDI form for ready reflect changes. such color swatch
end;

procedure TMDIChild.LoadFromFile(const AFileName: string);
var
  i : integer;
begin
  self.FStitchs.LoadFromFile(AFileName);
  for i := 0 to High(FStitchs.Colors) do
  begin
    if swlCustom.Count < i +1 then
      swlCustom.Add;
    swlCustom[i].Color := FStitchs.Colors[i];
  end;
  DrawStitchs();
//  swlCustom.Changed;
  FormActivate(self); // send signal to MDI MainForm 
end;


procedure TMDIChild.QualityChanged(Sender: TObject);
begin
  //it is modified by my own (childform) render quality menu. 
  case TAction(sender).Tag of 
    1 : FDrawLine := DrawWireFrame;
    2 : FDrawLine := DrawLineFS;
    3 : FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
    4 : FDrawLine := DrawLineStippled;//DrawLineFS;
    5 : FDrawLine := DrawLineFS;
    6 : FDrawLine := DrawXRay;
    7 : FDrawLine := DrawHotPressure;
  end;
  //pb.Repaint;
  self.DrawStitchs;
end;

procedure TMDIChild.FormActivate(Sender: TObject);
begin
  //send signal to MDI MainForm to reflect my (childform) properties; such colors swatch
  self.gmSource.Activate;
  if Length(FStitchs.Stitchs) > 0 then
    MainForm.ActiveChild := self;
end;

procedure TMDIChild.actUseOrdinalColorExecute(Sender: TObject);
begin
  self.DrawStitchs;
end;

procedure TMDIChild.DrawStitchs;
var i,j : Integer;
  zRat : TFloatPoint;
  ColorAt :Cardinal;
  LastColor,CurrentColor : TColor32;
  R : TFloatRect;
  
  first : boolean;
  b : byte;
begin

  //We will do painting while there is something to draw.
  if Length(FStitchs.Stitchs) = 0 then exit;

  LastColor := clNone;

  zRat.X := (imgStitchs.Width / FStitchs.HeaderEx.xhup );
  zRat.Y := (imgStitchs.Height / FStitchs.HeaderEx.yhup );

  if zRat.X < zRat.Y then
    zRat.Y := zRat.X
  else
    zRat.X := zRat.Y;
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

          if actUseOrdinalColor.Checked then
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
      for i := 0 to FStitchs.Header.fpnt -1 do
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

end.
