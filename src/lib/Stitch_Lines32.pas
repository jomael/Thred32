unit Stitch_Lines32;

interface

uses
  GR32;

type
  TStitch_LineProc = procedure (B: TBitmap32; R : TFloatRect; C : TColor32);


procedure DrawLineFS(B: TBitmap32; R : TFloatRect; C : TColor32);
procedure DrawLineStippled(B: TBitmap32; R : TFloatRect; C : TColor32);
procedure Draw3DLine(B: TBitmap32; R : TFloatRect; C : TColor32);


implementation

uses
  Math,
  GR32_Blend;


procedure DrawLineFS(B: TBitmap32; R : TFloatRect; C : TColor32);
begin
  with R do
    B.LineFS(left, top, right, bottom, C);
end;

procedure DrawLineStippled(B: TBitmap32; R : TFloatRect; C : TColor32);
var h, x, y : TFloat;
  Cs : TArrayOfColor32;
begin

  with R do
  begin
    x := right - left;
    y := bottom - top;
    h := hypot(x,y);

    if h = 0 then exit;

    //B.StippleCounter := 0;
    B.StippleStep := 4/h;
    setlength(Cs,5);
    Cs[0] := Lighten(C, - 64);
    Cs[1] := C;//Lighten(C, 11);
    Cs[2] := Lighten(C, 151);
    Cs[3] := C;//Lighten(C, 11);
    Cs[4] := Lighten(C, - 64);
    B.SetStipple(Cs);


    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
  end;
end;

procedure Draw3DLine(B: TBitmap32; R : TFloatRect; C : TColor32);
var h, x, y : TFloat;
  Cs : TArrayOfColor32;
begin

  with R do
  begin
    x := right - left;
    y := bottom - top;
    h := hypot(x,y);

    if h = 0 then exit;

    //B.StippleCounter := 0;
    B.StippleStep := 4/h;
    setlength(Cs,5);
    Cs[0] := Lighten(C, - 64);
    Cs[1] := C;//Lighten(C, 11);
    Cs[2] := Lighten(C, 90);
    Cs[3] := C;//Lighten(C, 11);
    Cs[4] := Lighten(C, - 64);
    B.SetStipple(Cs);


    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
  end;
end;

end.
