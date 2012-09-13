unit umChild;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, SysUtils,
  GR32,
  Stitch_items, Stitch_rwTHR, Stitch_rwPCS, Stitch_rwPES,
  Stitch_Lines32,
  Form_cpp, GR32_Image, Menus, ActnList;

type
  TMDIChild = class(TForm)
    pb: TPaintBox32;
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure pbPaintBuffer(Sender: TObject);
    procedure QualityChanged(Sender: TObject);
  private
    { Private declarations }
    FStitchs : TStitchCollection;
    FDrawLine : TStitch_LineProc;  
  public
    { Public declarations }
    procedure LoadFromFile(const AFileName: string);
    property Stitchs : TStitchCollection read FStitchs;    
  end;

  
procedure CreateMDIChild(const AFileName: string);


implementation


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
  pb.Align := alClient;
  FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
end;

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMDIChild.LoadFromFile(const AFileName: string);
begin
  self.FStitchs.LoadFromFile(AFileName);
end;


procedure TMDIChild.pbPaintBuffer(Sender: TObject);
var i,j : Integer;
  zRat : TFloatPoint;
  ColorAt :Cardinal;
  LastColor,CurrentColor : TColor32;
  R : TFloatRect;
  
  first : boolean;
  b : byte;
begin
  //if not FPainting then exit;


  if Length(FStitchs.Stitchs) > 0 then
  begin
    zRat.X := (pb.Width / FStitchs.HeaderEx.xhup );
    zRat.Y := (pb.Height / FStitchs.HeaderEx.yhup );

    if zRat.X < zRat.Y then
      zRat.Y := zRat.X
    else
      zRat.X := zRat.Y;
    zRat.x := 1; //debug
    zRat.Y := 1; //debug

    pb.Buffer.Clear(clWhite32);
    R := FloatRect(0,0, FStitchs.HeaderEx.xhup * zRat.X, FStitchs.HeaderEx.yhup * zRat.Y);
    //pb.Buffer.FillRectTS(MakeRect(R), Color32(FStitchs.BgColor));
    FDrawLine(pb.Buffer, R, Color32(FStitchs.BgColor), sdlStart);
    //STITCH
    for i := 0 to High(FStitchs.stitchs) do
    begin
      pb.Buffer.PenColor:= clBlack32;
      with FStitchs.stitchs[i] do
      begin
        ColorAt := at and $FF;
        if ColorAt > High(FStitchs.colors) then
          ColorAt := at and $0F;
        //pb.Buffer.PenColor := Color32( FStitchs.Colors[ ColorAt ] );
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
          FDrawLine(pb.Buffer, R, CurrentColor, sdlLine);

          R.TopLeft := R.BottomRight;

        end;
        LastColor := CurrentColor;
        {if i = 0 then
          pb.Buffer.MoveToF(x * zRat.X, y * zRat.Y)
        else
          pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y);}
      end;
    end; 
    FDrawLine(pb.Buffer, R, Color32(FStitchs.BgColor), sdlFinish);

    //FORMS
    pb.Buffer.PenColor:= clTrRed32;
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
          pb.Buffer.PenColor:= Color32( FStitchs.Colors[ b ] );

        end;
        
        with FStitchs.Forms[i].flt[j] do
        if first then
          pb.Buffer.MoveToF(x * zRat.X, y * zRat.Y)
        else
          pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y);

        first := false;
      end;
      //back to first point
        with FStitchs.Forms[i].flt[0] do
          pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y)
    end;




  end;  

end;

procedure TMDIChild.QualityChanged(Sender: TObject);
begin
  case TAction(sender).Tag of 
    1 : FDrawLine := DrawWireFrame;
    2 : FDrawLine := DrawLineFS;
    3 : FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
    4 : FDrawLine := DrawLineStippled;//DrawLineFS;
    5 : FDrawLine := DrawLineFS;
    6 : FDrawLine := DrawXRay;
  end;
  pb.Repaint;
end;

end.
