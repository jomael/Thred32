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
  {$IFDEF FPC}
    LCLIntf, LCLType, LMessages, Types,
  {$ELSE}
    Windows, Messages,
  {$ENDIF}
  GR32, GR32_Image,
  Embroidery_Items;

type
  TEmbroideryPaintStage = (epsBeginPaint, epsPaint, epsPaintBuffer, epsEndPaint);

  TEmbroideryPainter = class(TObject)
  private
    FImage32: TCustomImage32;
    FMultiply : TFloatPoint;
    FWantToCalcRect: Boolean;
    procedure DoCalcRect( ALine : TStitchLine);
    function GetMultiply(const Index: Integer): Single;
    procedure SetMultiply(const Index: Integer; const Value: Single);
  protected
    FWantToClear: Boolean;
    FDrawnRect : TFloatRect;
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
    procedure Assign(Src : TEmbroideryPainter); virtual;
    //after paint procs
    function GetDrawnSize: TPoint; //used by such fileOpenDlg
    function GetDrawnRect: TRect; //used by such fileOpenDlg
    procedure CropDrawnRect; //used by such fileOpenDlg

    //before paint procs
    property WantToClear : Boolean read FWantToClear write FWantToClear;
    property WantToCalcRect : Boolean read FWantToCalcRect write FWantToCalcRect;
    property Multiply : Single index 0 read GetMultiply write SetMultiply;
    property MultiplyX : Single index 1 read GetMultiply write SetMultiply;
    property MultiplyY : Single index 2 read GetMultiply write SetMultiply;
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


  }
  //----------------- BELOW ARE DEBUG PAINTERS:
  // ----------------not attended for production ----------------

  TEmbroideryDebugPainter = class(TEmbroideryPainter)
  protected

    procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); override;
    procedure CalcColor(P1,P2: TStitchPoint; var C1,C2: TColor32); virtual;
    procedure MapColor(V1,V2: Word; var C1,C2: TColor32); overload;
    procedure MapColor(AValue: Word; var C1,C2: TColor32); overload;
    procedure MapColor(AValue: Word; var AColor: TColor32); overload;
  end;

  TEmbroideryDebugLinPainter = class(TEmbroideryDebugPainter);

  TEmbroideryDebugGrpPainter = class(TEmbroideryDebugPainter)
  protected
    procedure CalcColor(P1,P2: TStitchPoint; var C1,C2: TColor32); override;
  end;

  TEmbroideryDebugRegionPainter = class(TEmbroideryDebugPainter)
  protected
    procedure CalcColor(P1,P2: TStitchPoint; var C1,C2: TColor32); override;
  end;

  TEmbroideryDebugRgnsPainter = class(TEmbroideryDebugPainter)
  protected
    procedure CalcColor(P1,P2: TStitchPoint; var C1,C2: TColor32); override;
  end;

  TEmbroideryDebugBrkPainter = class(TEmbroideryDebugPainter)
  protected
    procedure CalcColor(P1,P2: TStitchPoint; var C1,C2: TColor32); override;
  end;

  TEmbroideryDebugCntBrkPainter = class(TEmbroideryDebugPainter)
  protected
    procedure CalcColor(P1,P2: TStitchPoint; var C1,C2: TColor32); override;
  end;


  {TEmbroideryByLinPainter = class(TEmbroideryPainter)
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
  //TRA = clTrWhite32;
  TRA = clWhite32;

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
  FDrawnRect := FloatRect(B.Width * FImage32.ScaleX * 2, B.Height * FImage32.ScaleY * 2,
    0,0);
end;

constructor TEmbroideryPainter.Create(AImage32: TCustomImage32);
begin
  inherited Create;
  FWantToClear := True;
  FImage32 := AImage32;
  FMultiply.X := 1;
  FMultiply.Y := 1;
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
    B.LineFS(
      Start.x * FMultiply.X, Start.y * FMultiply.Y,
      Finish.x * FMultiply.X, Finish.y * FMultiply.Y, AColor);
  DoCalcRect(ALine);
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
      
  for i := 0 to Length(LStitchs)-1 do
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


procedure TEmbroideryPainter.DoCalcRect(ALine: TStitchLine);
begin
  if FWantToCalcRect then
    with FDrawnRect do
    begin
      Left := Min(Left,  Min(ALine.Start.X, ALine.Finish.X));
      Top := Min(Top,  Min(ALine.Start.Y, ALine.Finish.Y));
      Right := Max(Right,  Max(ALine.Start.X, ALine.Finish.X));
      Bottom := Max(Bottom,  Max(ALine.Start.Y, ALine.Finish.Y));
    end;
end;

function TEmbroideryPainter.GetDrawnSize: TPoint;
var R: TRect;
begin
  R := GetDrawnRect;
  OffsetRect(R, -R.Left, -R.Top); //set pos to zero
  Result := R.BottomRight;
end;

function TEmbroideryPainter.GetDrawnRect: TRect;
begin
  Result.Left   := Max(0, Floor(FDrawnRect.Left));
  Result.Top    := Max(0,Floor(FDrawnRect.Top));
  Result.Right  := Min(FImage32.Bitmap.Width, Floor(FDrawnRect.Right));
  Result.Bottom := Min(FImage32.Bitmap.Height, Floor(FDrawnRect.Bottom));
end;

procedure TEmbroideryPainter.CropDrawnRect;
var R : TRect;
  Src,Dst : PColor32Array;
  x,y, w,h : Integer;
  B : TBitmap32;
begin
  R:= GetDrawnRect;
  w := r.Right - r.Left +1;
  h := r.Bottom - r.Top +1;
  if (h=0) or (w=0) then Exit;

  B := TBitmap32.Create;
  try
  B.Assign(FImage32.Bitmap);
  FImage32.Bitmap.SetSize(W,H);

  FImage32.Bitmap.Draw(FImage32.Bitmap.BoundsRect, R, B);

  {for y := 0 to h -1 do
  begin
    Src := B.ScanLine[y+ R.Top-1 ];
    Dst := FImage32.Bitmap.ScanLine[y];
    for x := 0 to w-1 do
    begin
      Dst[x] := Src[x + R.Left-1];
    end;
  end;}
  finally
    B.Free;
  end;
end;

function TEmbroideryPainter.GetMultiply(const Index: Integer): Single;
begin
  if Index in [0,1] then
    Result := FMultiply.X
  else
    Result := FMultiply.Y;
end;

procedure TEmbroideryPainter.SetMultiply(const Index: Integer;
  const Value: Single);
begin
  if Index = 0 then
  begin
    FMultiply.X := Value;
    FMultiply.Y := Value;
  end
  else if Index = 1 then
    FMultiply.X := Value
  else
    FMultiply.Y := Value;
end;

procedure TEmbroideryPainter.Assign(Src: TEmbroideryPainter);
begin
  FImage32 := Src.FImage32;
  FMultiply := Src.FMultiply;
  FWantToCalcRect := Src.FWantToCalcRect;
  FWantToClear := Src.FWantToClear;
  FDrawnRect := Src.FDrawnRect;
end;

{ TEmbroideryPhotoPainter }

procedure TEmbroideryPhotoPainter.PaintLine(B: TBitmap32;
  ALine: TStitchLine; AColor: TColor32);
  procedure Offset(var F : TFloatPoint; D : TFloat);
  begin
    F.X := F.X * D;
    F.Y := F.Y * D;

  end;
var h, x, y : TFloat;
  Cs : TArrayOfColor32;
  LStart, LFinish : TFloatPoint;
  R : TFloatRect;
begin

  with ALine do
  begin
    LStart := Start.Point;
    LFinish := Finish.Point;
    Offset(LStart, Multiply);
    Offset(LFinish, Multiply);
    //IntersectRect(R,R,FloatRect(B.BoundsRect));
    try
      x := LFinish.x - LStart.x;
      y := LFinish.y - LStart.y;
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
      B.LineFSP(LStart.x, LStart.y, LFinish.x, LFinish.y);
      B.StippleCounter := 0;
      B.LineFSP(LStart.x, LStart.y, LFinish.x, LFinish.y);
    except
      //raise Exception.Create(Format('x:%f y:%f -(%f,%f,%f,%f)',[x,y, Left, Top, Right, Bottom ]));
    end;
  end;
  DoCalcRect(ALine);
end;


{ TEmbroideryDebugPainter }

procedure TEmbroideryDebugPainter.CalcColor(P1, P2: TStitchPoint; var C1,
  C2: TColor32);
begin
  MapColor(P1.lin, P2.lin, C1,C2);
end;

procedure TEmbroideryDebugPainter.MapColor(V1, V2: Word; var C1,
  C2: TColor32);
begin
  //C1 := LEdgeColors[V1 mod VERTICES] and TRA;
  //C2 := LEdgeColors[V2 mod VERTICES] and TRA;
  MapColor(V1,C1);
  MapColor(V2,C2);
end;

procedure TEmbroideryDebugPainter.MapColor(AValue: Word; var C1,
  C2: TColor32);
begin
  MapColor(AValue, C1 );
  C2 := C1;
end;

procedure TEmbroideryDebugPainter.MapColor(AValue: Word;
  var AColor: TColor32);
begin
  AColor := LEdgeColors[AValue mod VERTICES] and TRA;
end;

procedure TEmbroideryDebugPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
var
  LBarCount, 
  w,x,y,i,j : Integer;
  LFillPoints : TArrayOfStitchPoint;
  x1,y1,x2,y2, x3,y3 : TFloat;
  c1,c2 : TColor32;

begin
  //PArrayOfStitchPoint(LFillPoints) := AnItem.Stitchs;
  LFillPoints := AnItem.Stitchs^;
  LBarCount := Length(LFillPoints);

  //VERTICE

    for i := 0 to Length(AnItem.PolyPolygon^) -1 do
    begin
      for j := 0 to Length(AnItem.PolyPolygon^[i].Points) -1 do
      begin
        //Font.Color := WinColor(c[(VERTICES+i-1) mod VERTICES]);

        with AnItem.PolyPolygon^[i].Points[j] do
        begin
          B.TextOut(Round(X * FMultiply.X), Round(Y * FMultiply.Y), IntToStr(J));
        end;
      end;
    end;


  //DRAWING.
  //Tag := 2;
  if LBarCount < 1 then
    Exit;


  //ABitmap32.PenColor := clRed32;

  x := Round(LFillPoints[0].X * FMultiply.X);
  y := Round(LFillPoints[0].Y * FMultiply.Y);
  B.MoveTo(x, y);

  i := 0;


  i := 0;
  for j := 0 to (LBarCount - 1) do
  begin
    x1 := (LFillPoints[i].X * FMultiply.X);
    y1 := (LFillPoints[i].Y * FMultiply.Y);
    x2 := (LFillPoints[i+1].X * FMultiply.X);
    y2 := (LFillPoints[i+1].Y * FMultiply.Y);

    B.MoveToF(x1, y1);
    
    //if chkDrawBoth.Checked then
    {begin
      case Tag of
        0 : c1 := LEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
        1 : c1 := LEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
        2 : c1 := LEdgeColors[LFillPoints[i].region mod VERTICES] and TRA;
        3 : c1 := LEdgeColors[j mod VERTICES] and TRA;
        4 : c1 := LEdgeColors[LFillPoints[i].NorthIndex mod VERTICES] and TRA;
        5 : c1 := LEdgeColors[LFillPoints[i].WesternIndex mod VERTICES] and TRA;
        13 : c1 := LEdgeColors[LFillPoints[i].rgns mod VERTICES] and TRA;

      end;
      //ABitmap32.LineToS(x, y);
      //ABitmap32.LineToFS(LFillPoints[i].X, LFillPoints[i].Y);
    end;

    if Tag = 20 then
      B.LineToFSP(X1, Y1)
    else
    //ABitmap32.MoveTo(x, y);

    inc(i);
    case Tag of
      0 : c2 := LEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
      1 : c2 := LEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
      2 : c2 := LEdgeColors[LFillPoints[i].region mod VERTICES] and TRA;
      3 : c2 := c1;//LEdgeColors[j mod VERTICES] and TRA;
      4 : c2 := LEdgeColors[LFillPoints[i].NorthIndex mod VERTICES] and TRA;
      5 : c2 := LEdgeColors[LFillPoints[i].WesternIndex mod VERTICES] and TRA;
      13 : c2 := c1;
    end;
    }
    
    CalcColor(LFillPoints[i],LFillPoints[i+1], c1,c2);


    //three line below is backup line drawing, because in "GRP" draw, each line is end with white
    {Bitmap32.PenColor := c2;
    ABitmap32.LineToFS(X2, Y2); //it move the begin line
    ABitmap32.MoveToF(x1, y1); //set back to original begin line
    }

    if c1 = c2 then
    begin
      B.PenColor := c1;
      B.LineToFS(x2,y2);
    end
    else
    begin
      //ABitmap32.LineToS(x, y);
      B.SetStipple([c1,c1,c2,c2, c2,c2]);
      B.StippleCounter := 0;
      //ABitmap32.LineToFS(x2,y2);
      //B.StippleStep := 3.5/ max(Max(x2,x1) - Min(x2,x1),1); //fine. but it only draw vertical stipple
      x3 := Abs(x2-x1);
      y3 := Abs(y2-y1);
      B.StippleStep := 3.5/ Max( Max(x3,y3), 1);


      //ABitmap32.PenColor := c2;
      B.LineToFSP(X2, Y2);
    end;

    inc(i,2);

    if i >= LBarCount -1 then break;
  end;

  {w := 2;
  for i := 0 to (LBarCount - 1) do
  begin
    x := Round(LFillPoints[i].X);
    y := Round(LFillPoints[i].Y);

    case Tag of
      0 : B.FillRectS(x - w, y - w, x + w, y + w, LEdgeColors[LFillPoints[i].lin mod VERTICES]);
      1 : B.FillRectS(x - w, y - w, x + w, y + w, LEdgeColors[LFillPoints[i].grp mod VERTICES]);
    end;

  end;}                       

    //SetLength(FFillPoints, 0);
    //FFillPoints := nil;



end;

{ TEmbroideryDebugGrpPainter }

procedure TEmbroideryDebugGrpPainter.CalcColor(P1, P2: TStitchPoint;
  var C1, C2: TColor32);
begin
  MapColor(P1.grp, P2.grp, C1,C2);
end;

{ TEmbroideryDebugRegionPainter }

procedure TEmbroideryDebugRegionPainter.CalcColor(P1, P2: TStitchPoint;
  var C1, C2: TColor32);
begin
  MapColor(P1.Region, P2.Region, C1,C2);
end;

{ TEmbroideryDebugRgnsPainter }

procedure TEmbroideryDebugRgnsPainter.CalcColor(P1, P2: TStitchPoint;
  var C1, C2: TColor32);
begin
  MapColor(P1.rgns, C1,C2);
end;

{ TEmbroideryDebugCntBrkPainter }

procedure TEmbroideryDebugCntBrkPainter.CalcColor(P1, P2: TStitchPoint;
  var C1, C2: TColor32);
begin
  MapColor(P1.cntbrk, C1,C2);
end;

{ TEmbroideryDebugBrkPainter }

procedure TEmbroideryDebugBrkPainter.CalcColor(P1, P2: TStitchPoint;
  var C1, C2: TColor32);
begin
  MapColor(P1.brk, C1,C2);
end;

initialization
  UHotPressureColors := nil;
  UMountainColors := nil;
finalization
  UHotPressureColors := nil;
  UMountainColors := nil;
end.
