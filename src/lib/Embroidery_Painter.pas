unit Embroidery_Painter;
(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/LGPL 2.1/GPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Stitch_Line32.pas .
 *
 * The Initial Developer of the Original Code are
 *
 * x2nie - Fathony Luthfillah  <x2nie@yahoo.com>
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * ***** END LICENSE BLOCK ***** *)


interface

uses
  GR32, GR32_Image,
  Embroidery_Items;

type
  TEmbroideryPaintStage = (epsBeginPaint, epsPaint, epsPaintBuffer, epsEndPaint);

  TEmbroideryPainter = class(TObject)
  private
    FImage32: TCustomImage32;

  protected
    FWantToClear: Boolean;
    procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); virtual;
    procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); virtual;

    procedure BeginPaint(B: TBitmap32); virtual;

    //procedure PaintBitmap(B: TBitmap32; AnItem: TEmbroideryItem = nil; AState: TEmbroideryPaintStage = epsPaint); virtual;
    //procedure PaintBuffer(B: TBitmap32; AnItem: TEmbroideryItem = nil; AState: TEmbroideryPaintStage = epsPaint); virtual;
    procedure RepeatPaint(B: TBitmap32; AShapeList: TEmbroideryList; AState: TEmbroideryPaintStage);

    procedure PaintBitmap(B: TBitmap32; AnItem: TEmbroideryItem = nil; AState: TEmbroideryPaintStage = epsPaint); virtual;
    procedure PaintBuffer(B: TBitmap32; AnItem: TEmbroideryItem = nil; AState: TEmbroideryPaintStage = epsPaint); virtual;

    procedure EndPaint(B: TBitmap32); virtual;
  public
    constructor Create(AImage32: TCustomImage32);
    //function GetWantToClear: Boolean; virtual;
    procedure Paint(AShapeList: TEmbroideryList; AState: TEmbroideryPaintStage = epsPaint); virtual;
    property WantToClear : Boolean read FWantToClear write FWantToClear;
  end;

  TEmbroideryPainterClass = class of TEmbroideryPainter;


  TEmbroideryPhotoPainter = class(TEmbroideryPainter)
  protected
    procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); override;
  end;

  {
  TEmbroideryOutDoorPhotoPainter = class(TEmbroideryPainter)
  protected
    class procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); override;
  end;


  TEmbroideryHotPressurePainter = class(TEmbroideryPainter)
  protected
    class procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); override;
  public
    class procedure BeginPaint(B: TBitmap32); override;
    class procedure EndPaint(B: TBitmap32); override;
  end;


  TEmbroideryMountainPainter = class(TEmbroideryPainter)
  protected
    class procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); override;
  public
    class procedure BeginPaint(B: TBitmap32); override;
    class procedure EndPaint(B: TBitmap32); override;
  end;


  TEmbroideryXRayPainter = class(TEmbroideryPainter)
  protected
    class procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); override;
  public
    class procedure BeginPaint(B: TBitmap32); override;
  end;



  //----------------- BELOW ARE DEBUG PAINTERS:
  // ----------------not attended for production ----------------

  TEmbroideryByLinPainter = class(TEmbroideryPainter)
  private
    class procedure PaintShapeBy(B: TBitmap32; AnItem: TEmbroideryItem; Tag : Integer); 
    class procedure PaintText(B: TBitmap32; AnItem: TEmbroideryItem; Tag : Integer); 
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
  end;

  TEmbroideryByGrpPainter = class(TEmbroideryByLinPainter)
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
  end;

  TEmbroideryByRegionPainter = class(TEmbroideryByLinPainter)
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
  end;

  TEmbroideryByJumpPainter = class(TEmbroideryByLinPainter)
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
  end;

  TEmbroideryByWesternPainter = class(TEmbroideryByLinPainter)
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
  end;

  TEmbroideryByRGNSPainter = class(TEmbroideryByLinPainter)
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
  end;  }

implementation

uses
  Math, SysUtils,
  GR32_Blend,
  Embroidery_Defaults;

const
  VERTICES = 11;
  LEdgeColors : array[0..VERTICES-1] of TColor32 = (
      clYellow32, clLime32, clAqua32, clDodgerBlue32, clBlueViolet32, clFuchsia32, clred32,
      clGray32, clLightGray32, clblack32,  clDarkOrange32);
  TRA = clTrWhite32;

var
  UHotPressureColors,
  UMountainColors : TArrayOfColor32;

{ Unit procs }
function Line2FloatRect(ALine: TStitchLine): TFloatRect;
begin
  Result.TopLeft := ALine.Start.Point;
  Result.BottomRight := ALine.Finish.Point;
end;

procedure BuildHotPressureColors;
var B: TBitmap32;
  i : integer;
begin
  B := TBitmap32.Create;
  B.SetSize(256,1); //1 horizontal line
  B.StippleStep := 4/255;
  setlength(UHotPressureColors,5);
  UHotPressureColors[0] := Color32($350c0a); //dark violet
  UHotPressureColors[1] := Color32($981992); 
  UHotPressureColors[2] := Color32($4d56d6); //orange
  UHotPressureColors[3] := clYellow32; 
  UHotPressureColors[4] := clWhite32; //

  B.SetStipple(UHotPressureColors);
  B.StippleCounter := 0;
  B.LineFSP(0,0,255,0);

  setlength(UHotPressureColors,256);
  for i := 0 to 255 do
  begin
    UHotPressureColors[i] := b.PixelS[i,0];
  end;
  B.Free;
end;

procedure BuildMountainColors;
var B: TBitmap32;
  i : integer;
begin
  B := TBitmap32.Create;
  B.SetSize(256,1); //1 horizontal line
  B.StippleStep := 3/255;
  setlength(UMountainColors,4);
  UMountainColors[0] := clGreen32;// clNavy32;//Color32(clGreen); //dark violet
  UMountainColors[1] := BlendReg(clLime32, clGreen32); EMMS;// Color32(clLime); //fuchsia
  UMountainColors[2] := clYellow32; //Color32($17b0f3); //
  UMountainColors[3] := Color32($4d56d6); //orange


  B.SetStipple(UMountainColors);
  B.StippleCounter := 0;
  B.LineFSP(0,0,255,0);

  setlength(UMountainColors,256);
  for i := 0 to 255 do
  begin
    UMountainColors[i] := b.PixelS[i,0];
  end;
  UMountainColors[0] := clNavy32;
  B.Free;
end;
  
{ TEmbroideryPainter }

procedure TEmbroideryPainter.BeginPaint(B: TBitmap32);
begin
  if Self.WantToClear then
    B.Clear(clWhite32);
end;

constructor TEmbroideryPainter.Create(AImage32: TCustomImage32);
begin
  inherited Create;
  FWantToClear := True;
  FImage32 := AImage32;
end;

procedure TEmbroideryPainter.EndPaint(B: TBitmap32);
begin

end;


procedure TEmbroideryPainter.Paint(AShapeList: TEmbroideryList;
  AState: TEmbroideryPaintStage);
begin
  case AState of
    epsPaintBuffer :
            RepeatPaint(FImage32.Buffer, AShapeList, AState);
    else
            RepeatPaint(FImage32.Bitmap, AShapeList, AState);
  end;
end;

procedure TEmbroideryPainter.RepeatPaint(B: TBitmap32; AShapeList: TEmbroideryList;
  AState: TEmbroideryPaintStage);
var i : Integer;
begin
  BeginPaint(B);

  for i := 0 to AShapeList.Count -1 do
  begin
    if AState = epsPaintBuffer then
      PaintBuffer(B, AShapeList[i])
    else
      PaintBitmap(B, AShapeList[i]);
  end;


  EndPaint(B);
end;

procedure TEmbroideryPainter.PaintBitmap(B: TBitmap32; AnItem: TEmbroideryItem;
  AState: TEmbroideryPaintStage);
begin
  case AState of
    epsBeginPaint : BeginPaint(B);
    epsPaint      : PaintShape(B, AnItem);
    epsEndPaint   : EndPaint(B);
  end;
end;

procedure TEmbroideryPainter.PaintBuffer(B: TBitmap32;
  AnItem: TEmbroideryItem; AState: TEmbroideryPaintStage);
begin

end;

procedure TEmbroideryPainter.PaintLine(B: TBitmap32; ALine: TStitchLine; AColor: TColor32);
begin
  with ALine do
    B.LineFS(Start.x, Start.y, Finish.x, Finish.y, AColor);
end;

procedure TEmbroideryPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
var
  LStitchs : TArrayOfStitchPoint;
  LShapeList : TEmbroideryList;
  i : Integer;
  LColorI : Byte;
  CurrentColor,
  LastColor :TColor32;
  R : TStitchLine;
  zoomRatio : TFloatPoint;
begin
  //STITCH
  //PArrayOfStitchPoint(LStitchs) := LShapeItem.Stitchs;
  LShapeList := AnItem.ItemList;
  LStitchs := AnItem.Stitchs^;
  LastColor := $01000000;

  zoomRatio.X := ( B.Width / LShapeList.HupWidth );
  zoomRatio.Y := ( B.Height / LShapeList.HupHeight );

  if zoomRatio.X < zoomRatio.Y then
    zoomRatio.Y := zoomRatio.X
  else
    zoomRatio.X := zoomRatio.Y;
      
  for i := 0 to High(LStitchs) do
  begin
    // Bitmap.PenColor:= clBlack32;
    with LStitchs[i] do
    begin
      LColorI := at and $FF;
      if LColorI > High(LShapeList.colors) then
        LColorI := at and $0F;

      //if UseOrdinalColor then
        //CurrentColor := Color32( defCol[ LColorI ] );
      //else}
        CurrentColor := Color32( LShapeList.Colors[ LColorI ] );

      if i = 0 then
      begin
        //R.TopLeft := floatPoint(x * zRat.X, y * zRat.Y);
        R.Start := LStitchs[i];
      end
      else
      begin
        //R.BottomRight := floatPoint(x * zRat.X, y * zRat.Y);
        R.Finish := LStitchs[i];

        //JUMP STITCH + COLOR CHANGED.
        if CurrentColor = LastColor then
          //FDrawLine(Bitmap, R, CurrentColor, sdlLine);
          self.PaintLine(B,R,CurrentColor);

        //R.TopLeft := R.BottomRight;
        R.Start := LStitchs[i];

      end;
      {if i = 0 then
        pb.Buffer.MoveToF(x * zRat.X, y * zRat.Y)
      else
        pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y);}
    end;
    LastColor := CurrentColor;
  end;
end;


{ TEmbroideryPhotoPainter }

procedure TEmbroideryPhotoPainter.PaintLine(B: TBitmap32;
  ALine: TStitchLine; AColor: TColor32);
var h, x, y : TFloat;
  Cs : TArrayOfColor32;
begin

  with ALine do
  begin
    //IntersectRect(R,R,FloatRect(B.BoundsRect));
    try
      x := Finish.x - Start.x;
      y := Finish.y - Start.y;
      h := hypot(x,y);

      if h = 0 then exit;

      //B.StippleCounter := 0;
      B.StippleStep := 4/h;
      setlength(Cs,5);
      Cs[0] := $0fffffff and Lighten(AColor, - 64); EMMS; // calling EMMS each time after call to Lighten() to avoid "invalid floating operation" error
      Cs[1] := AColor;//Lighten(C, 11);
      Cs[2] := Lighten(AColor, 90); EMMS;
      Cs[3] := AColor;//Lighten(C, 11);
      Cs[4] := $0fffffff and Lighten(AColor, - 64); EMMS;
      B.SetStipple(Cs);


      B.StippleCounter := 0;
      B.LineFSP(Start.x, Start.y, Finish.x, Finish.y);
      B.StippleCounter := 0;
      B.LineFSP(Start.x, Start.y, Finish.x, Finish.y);
    except
      //raise Exception.Create(Format('x:%f y:%f -(%f,%f,%f,%f)',[x,y, Left, Top, Right, Bottom ]));
    end;
  end;
  
end;


initialization
  UHotPressureColors := nil;
  UMountainColors := nil;
finalization
  UHotPressureColors := nil;
  UMountainColors := nil;
end.
