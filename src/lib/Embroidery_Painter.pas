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
  GR32,
  Embroidery_Items;

type
  TEmbroideryPaintStage = (epsBeginPaint, epsPaint, epsEndPaint);
  
  TEmbroideryPainter = class(TObject)
  private
  protected
    class procedure PaintShape(B: TBitmap32; AnItem: TEmbroideryItem); virtual;
    //procedure PaintLine(B: TBitmap32; TopLeft, RightBottom : TStitchPoint);  TStitchLine
    class procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); virtual;
  public
    class procedure BeginPaint(B: TBitmap32); virtual;
    //procedure Paint(B: TBitmap32; AState: TEmbroideryPaintStage; AnItem: TEmbroideryItem = nil );
    class procedure Paint(B: TBitmap32; AnItem: TEmbroideryItem = nil; AState: TEmbroideryPaintStage = epsPaint); virtual;
    class procedure EndPaint(B: TBitmap32); virtual;
  end;

  TEmbroideryPainterClass = class of TEmbroideryPainter;


  TEmbroideryPhotoPainter = class(TEmbroideryPainter)
  protected
    class procedure PaintLine(B: TBitmap32; ALine : TStitchLine; AColor: TColor32); override;
  end;

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

implementation

uses
  Math, SysUtils,
  GR32_Blend,
  Embroidery_Defaults;


{ TEmbroideryPainter }

class procedure TEmbroideryPainter.BeginPaint(B: TBitmap32);
begin
  B.Clear(clWhite32);
end;

class procedure TEmbroideryPainter.EndPaint(B: TBitmap32);
begin

end;

class procedure TEmbroideryPainter.Paint(B: TBitmap32; AnItem: TEmbroideryItem;
  AState: TEmbroideryPaintStage);
begin
  case AState of
    epsBeginPaint : BeginPaint(B);
    epsPaint      : PaintShape(B, AnItem, );
    epsEndPaint   : EndPaint(B);
  end;
end;

class procedure TEmbroideryPainter.PaintLine(B: TBitmap32; ALine: TStitchLine; AColor: TColor32);
begin
  with ALine do
    B.LineFS(Start.x, Start.y, Finish.x, Finish.y, AColor);
end;

class procedure TEmbroideryPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
var
  LStitchs : TArrayOfStitchPoint;
  LShapeList : TEmbroideryList;
  i : Integer;
  LColorI : Byte;
  CurrentColor,
  LastColor :TColor32;
  R : TStitchLine;
begin
  //STITCH
  //PArrayOfStitchPoint(LStitchs) := LShapeItem.Stitchs;
  LShapeList := AnItem.ItemList;
  LStitchs := AnItem.Stitchs^;
  LastColor := $01000000;

  for i := 0 to High(LStitchs) do
  begin
    // Bitmap.PenColor:= clBlack32;
    with LStitchs[i] do
    begin
      LColorI := at and $FF;
      if LColorI > High(LShapeList.colors) then
        LColorI := at and $0F;

      //if UseOrdinalColor then
        CurrentColor := Color32( defCol[ LColorI ] );
      //else}
        //CurrentColor := Color32( LShapeList.Colors[ LColorI ] );

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

class procedure TEmbroideryPhotoPainter.PaintLine(B: TBitmap32;
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

{ TEmbroideryByLinPainter }

class procedure TEmbroideryByLinPainter.PaintShapeBy(B: TBitmap32;
  AnItem: TEmbroideryItem; Tag: Integer);
const
  VERTICES = 10;
  LEdgeColors : array[0..VERTICES-1] of TColor32 = (clYellow32, clLime32, clAqua32, clBlueViolet32, clFuchsia32, clred32,
      clGray32, clLightGray32, clblack32,  clDarkOrange32);
  TRA = clTrWhite32;

var
  LBarCount, 
  w,x,y,i,j : Integer;
  LFillPoints : TArrayOfStitchPoint;
  x1,y1,x2,y2 : TFloat;
  c1,c2 : TColor32;
begin
  //PArrayOfStitchPoint(LFillPoints) := AnItem.Stitchs;
  LFillPoints := AnItem.Stitchs^;
  LBarCount := Length(LFillPoints);
  


  //DRAWING.
  //Tag := 2;
  if LBarCount < 1 then
    Exit;


  //ABitmap32.PenColor := clRed32;

  x := Round(LFillPoints[0].X);
  y := Round(LFillPoints[0].Y);
  B.MoveTo(x, y);

  i := 0;


  i := 0;
  for j := 0 to (LBarCount - 1) do
  begin
    x1 := (LFillPoints[i].X);
    y1 := (LFillPoints[i].Y);
    //if chkDrawBoth.Checked then
    begin
      case Tag of
        0 : c1 := LEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
        1 : c1 := LEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
        2 : c1 := LEdgeColors[LFillPoints[i].region mod VERTICES] and TRA;
        3 : c1 := LEdgeColors[j mod VERTICES] and TRA;
        4 : c1 := LEdgeColors[LFillPoints[i].NorthIndex mod VERTICES] and TRA;
        5 : c1 := LEdgeColors[LFillPoints[i].WesternIndex mod VERTICES] and TRA;

      end;
      //ABitmap32.LineToS(x, y);
      //ABitmap32.LineToFS(LFillPoints[i].X, LFillPoints[i].Y);
    end;

    if Tag = 20 then
      B.LineToFSP(X1, Y1)
    else
      B.MoveToF(x1, y1);
    //ABitmap32.MoveTo(x, y);

    inc(i);
    case Tag of
      0 : c2 := LEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
      1 : c2 := LEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
      2 : c2 := LEdgeColors[LFillPoints[i].region mod VERTICES] and TRA;
      3 : c2 := c1;//LEdgeColors[j mod VERTICES] and TRA;
      4 : c2 := LEdgeColors[LFillPoints[i].NorthIndex mod VERTICES] and TRA;
      5 : c2 := LEdgeColors[LFillPoints[i].WesternIndex mod VERTICES] and TRA;

    end;

    x2 := (LFillPoints[i].X);
    y2 := (LFillPoints[i].Y);

    //three line below is backup line drawing, because in "GRP" draw, each line is end with white
    {Bitmap32.PenColor := c2;
    ABitmap32.LineToFS(X2, Y2); //it move the begin line
    ABitmap32.MoveToF(x1, y1); //set back to original begin line
    }

    //ABitmap32.LineToS(x, y);
    B.SetStipple([c1,c1,c2,c2, c2,c2]);
    B.StippleCounter := 0;
    //ABitmap32.LineToFS(x2,y2);
    B.StippleStep := 3.5/ max(Max(x2,x1) - Min(x2,x1),1);
    //ABitmap32.PenColor := c2;
    B.LineToFSP(X2, Y2);
    inc(i);
    if i >= LBarCount -1 then break;
  end;

  w := 2;
  for i := 0 to (LBarCount - 1) do
  begin
    x := Round(LFillPoints[i].X);
    y := Round(LFillPoints[i].Y);

    case Tag of
      0 : B.FillRectS(x - w, y - w, x + w, y + w, LEdgeColors[LFillPoints[i].lin mod VERTICES]);
      1 : B.FillRectS(x - w, y - w, x + w, y + w, LEdgeColors[LFillPoints[i].grp mod VERTICES]);
    end;

  end;                       

    //SetLength(FFillPoints, 0);
    //FFillPoints := nil;


end;

class procedure TEmbroideryByLinPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
begin
  PaintShapeBy(B, AnItem, 0);
end;



class procedure TEmbroideryByLinPainter.PaintText(B: TBitmap32;
  AnItem: TEmbroideryItem; Tag: Integer);
var
  LLines : TArrayOfStitchLine;
  W,H,
  LastRegion, i : Integer;
  L,R : TFloatRect;
  Drawn : Boolean;
begin
  //REGION
  LastRegion := -1;

  R := FloatRect(High(Integer), High(Integer), Low(Integer), Low(Integer));
  //sort by sequence of : Jumps, lin
  PArrayOfStitchLine(LLines) :=  @AnItem.Stitchs^[0];
  W := b.TextWidth('10') div 2;
  H := b.TextHeight('198') div 2;

  for i := 0 to High(AnItem.Stitchs^) div 2 do
  with LLines[i] do
  begin
    Drawn := False;
    if (Start.region <> LastRegion)  then
    begin
      if i > 0 then //dont draw in first detection
      begin
      with R do
        B.Textout(
          Round(Left + (Right - Left) /2) - W ,
          Round(Top + (Bottom - Top) /2) - H,
          IntToStr(LastRegion) );
      B.FrameRectS(MakeRect( R, rrOutside), clBlack32);
      Drawn := True;
      end;
      LastRegion := Start.region;

      R := FloatRect(High(Integer), High(Integer), Low(Integer), Low(Integer));
    end;

    if R.Left > Start.x then
      R.Left := Start.x;
    if R.Top > Start.y then
      R.Top := Start.y;

    if R.Right < Finish.x then
      R.Right := Finish.x;
    if R.Bottom < Finish.y then
      R.Bottom := Finish.y;

    if (i = High(AnItem.Stitchs^) div 2) and not Drawn then //last line
    begin
      with R do
        B.Textout(
          Round(Left + (Right - Left) /2) - W ,
          Round(Top + (Bottom - Top) /2) - H,
          IntToStr(LastRegion) );
      B.FrameRectS(MakeRect(R), clTrBlack32);
    end;



  end;


    {for j := LRegions[i].X div 2   to LRegions[i].Y div 2   do
    begin
      if LLines[j].Start.jump > 1 then
        if LLines[j].Start.lin <> LastJump then
        begin
          LastJump := LLines[j].Start.lin;
          Inc(z);
        end;
      LLines[j].Start.region := z;
      LLines[j].Finish.region := z;
    end;}




  PArrayOfStitchLine(LLines) := nil;
end;

{ TEmbroideryByGrpPainter }

class procedure TEmbroideryByGrpPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
begin
  PaintShapeBy(B, AnItem, 1);
end;

{ TEmbroideryByRegionPainter }

class procedure TEmbroideryByRegionPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
begin
  PaintShapeBy(B, AnItem, 2);
  PaintText(B,AnItem,2);
end;

{ TEmbroideryByJumpPainter }

class procedure TEmbroideryByJumpPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
begin
  PaintShapeBy(B, AnItem, 4);
end;

{ TEmbroideryByWesternPainter }

class procedure TEmbroideryByWesternPainter.PaintShape(B: TBitmap32;
  AnItem: TEmbroideryItem);
begin
  PaintShapeBy(B, AnItem, 5);
end;

end.
