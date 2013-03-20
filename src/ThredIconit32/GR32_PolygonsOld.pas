unit GR32_PolygonsOld;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1 or LGPL 2.1 with linking exception
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
 * Alternatively, the contents of this file may be used under the terms of the
 * Free Pascal modified version of the GNU Lesser General Public License
 * Version 2.1 (the "FPC modified LGPL License"), in which case the provisions
 * of this license are applicable instead of those above.
 * Please see the file LICENSE.txt for additional information concerning this
 * license.
 *
 * The Original Code is Vectorial Polygon Rasterizer for Graphics32
 *
 * The Initial Developer of the Original Code is
 * Mattias Andersson <mattias@centaurix.com>
 *
 * Portions created by the Initial Developer are Copyright (C) 2012
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

interface

{$I GR32.inc}

uses
  Classes, SysUtils, GR32, GR32_Polygons, GR32_Transforms;

type
  TAntialiasMode = (am32times, am16times, am8times, am4times, am2times, amNone,
    amAlways);

  TPolygon32 = class(TThreadPersistent)
  private
    FAntialiased: Boolean;
    FClosed: Boolean;
    FFillMode: TPolyFillMode;
    FNormals: TArrayOfArrayOfFixedPoint;
    FPoints: TArrayOfArrayOfFixedPoint;
    FAntialiasMode: TAntialiasMode;
    procedure AntiAliasReadOnly(const Value: TAntialiasMode);
  protected
    procedure AssignTo(Dst: TPersistent); override;
    procedure BuildNormals;
    procedure CopyPropertiesTo(Dst: TPolygon32); virtual;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Add(const P: TFixedPoint);
    procedure AddPoints(var First: TFixedPoint; Count: Integer);
    function  ContainsPoint(const P: TFixedPoint): Boolean;
    procedure Clear;
    function Grow(const Delta: TFixed; EdgeSharpness: Single = 0): TPolygon32;

    procedure Draw(Bitmap: TBitmap32; OutlineColor, FillColor: TColor32; Transformation: TTransformation = nil); overload;
    procedure Draw(Bitmap: TBitmap32; OutlineColor: TColor32; FillCallback: TFillLineEvent; Transformation: TTransformation = nil); overload;
    procedure Draw(Bitmap: TBitmap32; OutlineColor: TColor32; Filler: TCustomPolygonFiller; Transformation: TTransformation = nil); overload;

    procedure DrawEdge(Bitmap: TBitmap32; Color: TColor32; Transformation: TTransformation = nil);

    procedure DrawFill(Bitmap: TBitmap32; Color: TColor32; Transformation: TTransformation = nil); overload;
    procedure DrawFill(Bitmap: TBitmap32; FillCallback: TFillLineEvent; Transformation: TTransformation = nil); overload;
    procedure DrawFill(Bitmap: TBitmap32; Filler: TCustomPolygonFiller; Transformation: TTransformation = nil); overload;

    procedure NewLine;
    procedure Offset(const Dx, Dy: TFixed);
    function Outline: TPolygon32;
    procedure Transform(Transformation: TTransformation);
    function GetBoundingRect: TFixedRect;

    property Antialiased: Boolean read FAntialiased write FAntialiased;
    property AntialiasMode: TAntialiasMode read FAntialiasMode write AntiAliasReadOnly;
    property Closed: Boolean read FClosed write FClosed;
    property FillMode: TPolyFillMode read FFillMode write FFillMode;

    property Normals: TArrayOfArrayOfFixedPoint read FNormals write FNormals;
    property Points: TArrayOfArrayOfFixedPoint read FPoints write FPoints;
  end;

implementation

uses
  GR32_Math;

function PtInPolygon(const Pt: TFixedPoint; const Points: TArrayOfFixedPoint): Boolean;
var
  I: Integer;
  iPt, jPt: PFixedPoint;
begin
  Result := False;
  iPt := @Points[0];
  jPt := @Points[High(Points)];
  for I := 0 to High(Points) do
  begin
    Result := Result xor (((Pt.Y >= iPt.Y) xor (Pt.Y >= jPt.Y)) and
      (Pt.X - iPt.X < MulDiv(jPt.X - iPt.X, Pt.Y - iPt.Y, jPt.Y - iPt.Y)));
    jPt := iPt;
    Inc(iPt);
  end;
end;

{ TPolygon32 }

constructor TPolygon32.Create;
begin
  inherited;
  FClosed := True;
  FAntialiasMode := amAlways;
  NewLine; // initiate a new contour
end;

destructor TPolygon32.Destroy;
begin
  Clear;
  inherited;
end;

procedure TPolygon32.AssignTo(Dst: TPersistent);
var
  DstPolygon: TPolygon32;
  Index: Integer;
begin
  if Dst is TPolygon32 then
  begin
    DstPolygon := TPolygon32(Dst);
    CopyPropertiesTo(DstPolygon);
    SetLength(DstPolygon.FNormals, Length(Normals));
    for Index := 0 to Length(Normals) - 1 do
    begin
      DstPolygon.Normals[Index] := Copy(Normals[Index]);
    end;

    SetLength(DstPolygon.FPoints, Length(Points));
    for Index := 0 to Length(Points) - 1 do
    begin
      DstPolygon.Points[Index] := Copy(Points[Index]);
    end;
  end
  else
    inherited;
end;

procedure TPolygon32.Add(const P: TFixedPoint);
var
  H, L: Integer;
begin
  H := High(Points);
  L := Length(Points[H]);
  SetLength(Points[H], L + 1);
  Points[H][L] := P;
  Normals := nil;
end;

procedure TPolygon32.AddPoints(var First: TFixedPoint; Count: Integer);
var
  H, L, I: Integer;
begin
  H := High(Points);
  L := Length(Points[H]);
  SetLength(Points[H], L + Count);
  for I := 0 to Count - 1 do
    Points[H, L + I] := PFixedPointArray(@First)[I];
  Normals := nil;
end;

procedure TPolygon32.AntiAliasReadOnly(const Value: TAntialiasMode);
begin
  // read only!
end;

procedure TPolygon32.CopyPropertiesTo(Dst: TPolygon32);
begin
  Dst.Antialiased := Antialiased;
  Dst.AntialiasMode := AntialiasMode;
  Dst.Closed := Closed;
  Dst.FillMode := FillMode;
end;

function TPolygon32.GetBoundingRect: TFixedRect;
begin
//  Result := PolyPolygonBounds(Points);
end;

procedure TPolygon32.BuildNormals;
var
  I, J, Count, NextI: Integer;
  dx, dy, f: Single;
begin
  if Length(Normals) <> 0 then Exit;
  SetLength(FNormals, Length(Points));

  for J := 0 to High(Points) do
  begin
    Count := Length(Points[J]);
    SetLength(Normals[J], Count);

    if Count = 0 then Continue;
    if Count = 1 then
    begin
      FillChar(Normals[J][0], SizeOf(TFixedPoint), 0);
      Continue;
    end;

    I := 0;
    NextI := 1;
    dx := 0;
    dy := 0;

    while I < Count do
    begin
      if Closed and (NextI >= Count) then NextI := 0;
      if NextI < Count then
      begin
        dx := (Points[J][NextI].X - Points[J][I].X) / $10000;
        dy := (Points[J][NextI].Y - Points[J][I].Y) / $10000;
      end;
      if (dx <> 0) or (dy <> 0) then
      begin
        f := 1 / GR32_Math.Hypot(dx, dy);
        dx := dx * f;
        dy := dy * f;
      end;
      with Normals[J][I] do
      begin
        X := Fixed(dy);
        Y := Fixed(-dx);
      end;
      Inc(I);
      Inc(NextI);
    end;
  end;
end;

procedure TPolygon32.Clear;
begin
  Points := nil;
  Normals := nil;
  NewLine;
end;

function TPolygon32.ContainsPoint(const P: TFixedPoint): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(FPoints) do
    if PtInPolygon(P, FPoints[I]) then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TPolygon32.Draw(Bitmap: TBitmap32; OutlineColor,
  FillColor: TColor32; Transformation: TTransformation);
begin
  Bitmap.BeginUpdate;

  if (FillColor and $FF000000) <> 0 then
    PolyPolygonXS(Bitmap, Points, FillColor, FillMode, Transformation);
  if (OutlineColor and $FF000000) <> 0 then
    PolyPolylineXS(Bitmap, Points, OutlineColor, Closed, $1000, jsMiter,
      esButt, $4000, Transformation);

  Bitmap.EndUpdate;
  Bitmap.Changed;
end;

procedure TPolygon32.Draw(Bitmap: TBitmap32; OutlineColor: TColor32;
  FillCallback: TFillLineEvent; Transformation: TTransformation);
begin
  Bitmap.BeginUpdate;

  if (OutlineColor and $FF000000) <> 0 then
    PolyPolylineXS(Bitmap, Points, OutlineColor, Closed, $1000, jsMiter,
      esButt, $4000, Transformation);

  Bitmap.EndUpdate;
  Bitmap.Changed;
end;

procedure TPolygon32.Draw(Bitmap: TBitmap32; OutlineColor: TColor32;
  Filler: TCustomPolygonFiller; Transformation: TTransformation);
begin
  Draw(Bitmap, OutlineColor, Filler.FillLine, Transformation);
end;

procedure TPolygon32.DrawEdge(Bitmap: TBitmap32; Color: TColor32; Transformation: TTransformation);
begin
  Bitmap.BeginUpdate;

  PolyPolylineXS(Bitmap, Points, Color, Closed, $1000, jsMiter,
    esButt, $4000, Transformation);

  Bitmap.EndUpdate;
  Bitmap.Changed;
end;

procedure TPolygon32.DrawFill(Bitmap: TBitmap32; Color: TColor32; Transformation: TTransformation);
begin
  Bitmap.BeginUpdate;

  PolyPolygonXS(Bitmap, Points, Color, FillMode, Transformation);

  Bitmap.EndUpdate;
  Bitmap.Changed;
end;

procedure TPolygon32.DrawFill(Bitmap: TBitmap32; FillCallback: TFillLineEvent;
  Transformation: TTransformation);
var
  Filler: TCallbackPolygonFiller;
begin
  Bitmap.BeginUpdate;

  Filler := TCallbackPolygonFiller.Create;
  try
    Filler.FillLineEvent := FillCallback;
    PolyPolygonXS(Bitmap, Points, Filler, FillMode, Transformation);
  finally
    Filler.Free;
  end;

  Bitmap.EndUpdate;
  Bitmap.Changed;
end;

procedure TPolygon32.DrawFill(Bitmap: TBitmap32; Filler: TCustomPolygonFiller;
  Transformation: TTransformation);
begin
  PolyPolygonXS(Bitmap, Points, Filler, FillMode, Transformation);
end;

function TPolygon32.Grow(const Delta: TFixed; EdgeSharpness: Single = 0): TPolygon32;
var
  J, I, PrevI: Integer;
  PX, PY, AX, AY, BX, BY, CX, CY, R, D, E: Integer;

  procedure AddPoint(LongDeltaX, LongDeltaY: Integer);
  var
    N, L: Integer;
  begin
    with Result do
    begin
      N := High(Points);
      L := Length(Points[N]);
      SetLength(Points[N], L + 1);
    end;
    with Result.Points[N][L] do
    begin
      X := PX + LongDeltaX;
      Y := PY + LongDeltaY;
    end;
  end;

begin
  BuildNormals;

  if EdgeSharpness > 0.99 then
    EdgeSharpness := 0.99
  else if EdgeSharpness < 0 then
    EdgeSharpness := 0;

  D := Delta;
  E := Round(D * (1 - EdgeSharpness));

  Result := TPolygon32.Create;
  CopyPropertiesTo(Result);

  if Delta = 0 then
  begin
    // simply copy the data
    SetLength(Result.FPoints, Length(Points));
    for J := 0 to High(Points) do
      Result.Points[J] := Copy(Points[J], 0, Length(Points[J]));
    Exit;
  end;

  Result.Points := nil;

  for J := 0 to High(Points) do
  begin
    if Length(Points[J]) < 2 then Continue;

    Result.NewLine;

    for I := 0 to High(Points[J]) do
    begin
      with Points[J][I] do
      begin
        PX := X;
        PY := Y;
      end;

      with Normals[J][I] do
      begin
        BX := MulDiv(X, D, $10000);
        BY := MulDiv(Y, D, $10000);
      end;

      if (I > 0) or Closed then
      begin
        PrevI := I - 1;
        if PrevI < 0 then PrevI := High(Points[J]);
        with Normals[J][PrevI] do
        begin
          AX := MulDiv(X, D, $10000);
          AY := MulDiv(Y, D, $10000);
        end;

        if (I = High(Points[J])) and (not Closed) then AddPoint(AX, AY)
        else
        begin
          CX := AX + BX;
          CY := AY + BY;
          R := MulDiv(AX, CX, D) + MulDiv(AY, CY, D);
          if R > E then AddPoint(MulDiv(CX, D, R), MulDiv(CY, D, R))
          else
          begin
            AddPoint(AX, AY);
            AddPoint(BX, BY);
          end;
        end;
      end
      else AddPoint(BX, BY);
    end;
  end;
end;

procedure TPolygon32.NewLine;
begin
  SetLength(FPoints, Length(Points) + 1);
  Normals := nil;
end;

procedure TPolygon32.Offset(const Dx, Dy: TFixed);
var
  J, I: Integer;
begin
  for J := 0 to High(Points) do
    for I := 0 to High(Points[J]) do
      with Points[J][I] do
      begin
        Inc(X, Dx);
        Inc(Y, Dy);
      end;
end;

function TPolygon32.Outline: TPolygon32;
var
  J, I, L, H: Integer;
begin
  BuildNormals;

  Result := TPolygon32.Create;
  CopyPropertiesTo(Result);

  Result.Points := nil;

  for J := 0 to High(Points) do
  begin
    if Length(Points[J]) < 2 then Continue;

    if Closed then
    begin
      Result.NewLine;
      for I := 0 to High(Points[J]) do Result.Add(Points[J][I]);
      Result.NewLine;
      for I := High(Points[J]) downto 0 do Result.Add(Points[J][I]);
    end
    else // not closed
    begin
      // unrolled...
      SetLength(Result.FPoints, Length(Result.FPoints) + 1);
      Result.FNormals:= nil;

      L:= Length(Points[J]);
      H:= High(Result.FPoints);
      SetLength(Result.FPoints[H], L * 2);
      for I := 0 to High(Points[J]) do
        Result.FPoints[H][I]:= (Points[J][I]);
      for I := High(Points[J]) downto 0 do
        Result.FPoints[H][2 * L - (I + 1)]:= (Points[J][I]);
    end;
  end;
end;

procedure TPolygon32.Transform(Transformation: TTransformation);
begin
  Points := TransformPoints(Points, Transformation);
end;

end.
