unit gmTool_StitchPolyline;

interface

uses
{$IFDEF FPC}
  LCLIntf, LCLType, LMessages, Types,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms,
  Classes, SysUtils,
  GR32, GR32_Image, GR32_Layers, GR32_Types,
  gmTools;

type


  TgmtoolPolyline = class(TgmTool)
  private
    FDownPoint : TPoint;
    FDragging : Boolean;
    FTempLayer : TRubberbandLayer;
    function CorrectLocation(P1,P2:TPoint):TRect ;
  protected
  public
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer); override;
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer); override;
    
    function IsCanFinish:Boolean; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
  published 

  end;


implementation
uses
  Math,
  gmIntegrator;

type
  TCustomImgViewAccess = class(TCustomImage32);//hack!
  TLayerCollectionAccess = class(TLayerCollection);


function TgmtoolPolyline.CorrectLocation(P1, P2: TPoint): TRect;
begin
  //topleft
  Result.Left := min(P1.X ,P2.X);
  Result.Top  := min(P1.Y, P2.Y);
  //bottomright
  Result.Right  := Max(P1.X ,P2.X);
  Result.Bottom := Max(P1.Y ,P2.Y);
end;

constructor TgmtoolPolyline.Create(AOwner: TComponent);
begin
  inherited;
  Cursor := crGrWandPlus;//crGrPolylineIn;
end;

destructor TgmtoolPolyline.Destroy;
begin
  isCanFinish();//free temp layer
  inherited;
end;

function TgmtoolPolyline.isCanFinish: Boolean;
begin
  result := True;
  if Assigned(FTempLayer) then
  begin
    FTempLayer.Free;
    FTempLayer := nil;
  end;
end;

procedure TgmtoolPolyline.MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
  LPoint : TFloatPoint;
begin
  //do not start zoom outside bitmap area. ?
  //if not Assigned(Layer) then  Exit; we will not draw outside bitmap, but we allow it.
  with TCustomImage32(Sender) do
  begin
    FDownPoint := ControlToBitmap(Point(X,Y));

    //FDownOffset:= FloatPoint(OffsetHorz, OffsetVert);
    {ActualIntegrator.ActiveImg32.}//Cursor := crGrPolylineIn;
    if Button = mbLeft then
    begin
      FDragging := true;
    end
    else
    begin
      //Cursor := crGrWandMinus;
    end;
  end;

end;

//draw marque box indicating area to be Polylineed
procedure TgmtoolPolyline.MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Layer: TCustomLayer);

    function DraggedEnough(APoint: TPoint): Boolean;
    begin
      Result :=  Assigned(FTempLayer)  or
                  ( (Abs(APoint.X - FDownPoint.X) > 10) and (Abs(APoint.Y - FDownPoint.Y) > 0) );
    end;

var
  LPoint :TPoint;
begin
  if not FDragging then Exit;
  assert(assigned(ActiveIntegrator.ActiveImg32)); //thrown here? set .active when childform.activate!
  with TCustomImgViewAccess(ActiveIntegrator.ActiveImg32) do
  begin
    LPoint := {BitmapToControl}(Point(X,Y));
    if not DraggedEnough(LPoint) then Exit;

    //okay, it is really dragging, not a kid-click, nor Polyline click
    //let prepare the marquee:
    if not Assigned(FTempLayer) then
    begin
      FTempLayer := TRubberBandLayer.Create(ActiveIntegrator.ActiveImg32.Layers);
      FTempLayer.Handles  := [rhFrame];
      FTempLayer.Scaled  := False;
      FTempLayer.ChildLayer := nil;
      FTempLayer.Visible := True;
    end;

    //LRect := FloatRect( FDownPoint.X,FDownPoint.Y, LPoint.X, LPoint.Y);

    //sometime we drag to negative location = (right < 0) or (right < left) etc.
    //we correct it!
    FTempLayer.Location := FloatRect(CorrectLocation(FDownPoint, LPoint));
  end;

end;

procedure TgmtoolPolyline.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);


  procedure PolylineByRect(APxPickedRect : TRect);
  var
    LImg32 : TCustomImage32;
    //APickedPixelRect : TRect;
    LPixelsWidth, LPixelHeight : Integer;
    LPickedOrigin : TRect;
    LVerticalStretch : Boolean;
    LRatioH, LRatioV,
    LScaleH, LScaleV : Single;
    LLastScale : Single;
  begin
    //tugasnya adalah:
    // *. atur offset agar area yg diPolyline ketengah img2
    // *. tentukan skala

    //add padding or margin
    InflateRect(APxPickedRect,5,5);

    with APxPickedRect do
    begin
      LPixelsWidth := Right - Left;
      LPixelHeight := Bottom - Top;
    end;

    //aspect ratio Polyline
    with TCustomImgViewAccess(Sender) do
    begin
      LLastScale := Scale; //remember before rescaled
      LPickedOrigin.TopLeft := ControlToBitmap(APxPickedRect.TopLeft);
      //LPickedOrigin.BottomRight := ControlToBitmap(APickedPixelRect.BottomRight);

      LScaleH := Width  / (LPixelsWidth * LLastScale);
      LScaleV := Height / (LPixelHeight * LLastScale);

      LRatioH := Width / LPixelsWidth;
      LRatioV := Height / LPixelHeight;

      BeginUpdate;
      LVerticalStretch := LRatioV < LRatioH;
      if LVerticalStretch then
      begin
        Scale := LScaleV;
        OffsetVert := -(LPickedOrigin.Top * LScaleV);
        //OffsetHorz := (Bitmap.Width  * LScaleH - Width ) div 2;
        OffsetHorz := -((LPickedOrigin.Left  * LScaleV) - //picked is left aligned
                      Trunc( Width -
                        (LPixelsWidth / LLastScale) //width in pixels of bitmap
                      ) div 2
                      );
      end;
//      Scale := LScale;
      InvalidateCache;
      EndUpdate;
      Changed;
    end;
  end;

begin
  if FDragging then
  begin
    FDragging := false;
    if Assigned(FTempLayer) then
        PolylineByRect( CorrectLocation(FDownPoint,Point(x,y)) )
    else
      with TCustomImage32(Sender) do
        Scale := Scale + 0.5; 
  end;
  IsCanFinish(); //clean up
  TCustomImage32(Sender).Cursor := Self.Cursor;
end;


end.
