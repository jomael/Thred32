unit umDmFill;

interface

uses
  SysUtils, Classes, GR32,
  Embroidery_Items, Thred_Types, Thred_Constants, Thred_Defaults, gmShape;

type
  TdmFill = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmFill: TdmFill;

//procedure fnvrt(AStitchForm: TEmbroideryItem; ABitmap32 : TBitmap32);
procedure fnhrz(AStitchForm: TEmbroideryItem; ABitmap32 : TBitmap32);





implementation

uses
  Math, GR32_VectorUtils;


{$R *.dfm}

//-- Point Quick Sort Algorithm ------------------------------------------------

// Adapted from the algorithm in this topic:
// http://blog.csdn.net/stevenldj/article/details/7170303

type
  TPointSortCompare = function (Item1, Item2: TStitchPoint): Integer;
  TCompareFunc = function (const Item1, Item2): Integer;
  TCmpFunc = function (var Data;  const A, B : Integer; Compare: Boolean): Integer;
  TArrayOfFloatRect = array of TFloatRect;
  
const
  VERTICES = 10;
  UEdgeColors : array[0..VERTICES-1] of TColor32 = (clYellow32, clLime32, clblack32, clAqua32, clred32,
      clBlueViolet32, clFuchsia32, clGray32, clLightGray32, clDarkOrange32);
  TRA = clwhite32;// clTrWhite32;

  
function ProjV(AX: Single; APoint1, APoint2: TFloatPoint;
  out AProjPoint: TFloatPoint): Boolean;
var
  dx, LSlope    : Single;
  LLeft, LRight : Single;
  LTemp         : Single;
begin
  Result := False;

  AProjPoint.X := AX;
  dx           := APoint2.X - APoint1.X;

  if dx <> 0 then
  begin
    LSlope       := (APoint2.Y - APoint1.Y) / dx;
    AProjPoint.Y := Round( (AX - APoint1.X) * LSlope + APoint1.Y );

    LLeft  := APoint1.X;
    LRight := APoint2.X;

    if LLeft > LRight then
    begin
      LTemp  := LLeft;
      LLeft  := LRight;
      LRight := LTemp;
    end;

    Result := ( (AX >= LLeft) and (AX <= LRight) );
  end
end;

function ProjH(AY: Single; APoint1, APoint2: TFloatPoint;
  out AProjPoint: TFloatPoint): Boolean;
var
  dy, LSlope    : Single;
  LTop, LBottom : Single;
  LTemp         : Single;
begin
  Result := False;

  AProjPoint.Y := AY;
  if APoint2.Y = APoint1.Y then   //perfectly at edge
  begin
    if APoint1.X = APoint2.X then
      Exit;


  end;

  dy           := APoint2.Y - APoint1.Y;

  if dy <> 0 then
  begin
    LSlope       := (APoint2.X - APoint1.X) / dy;
    AProjPoint.X := Round( (AY - APoint1.y) * LSlope + APoint1.X );

    LTop  := APoint1.Y;
    LBottom := APoint2.Y;

    if LTop > LBottom then
    begin
      LTemp  := LTop;
      LTop  := LBottom;
      LBottom := LTemp;
    end;

    Result := ( (AY >= LTop) and (AY <= LBottom) );
  end
end;



procedure QSORT1(var Data; A, B: Integer;
  cmp: TCmpFunc);
var
  I, J, T : Integer;
begin
   
  repeat
    I := A;
    J := B;
    T := (A + B) shr 1;
    repeat
      while cmp(Data, I, T, True) < 0 do
        Inc(I);

      while cmp(Data, J, T, True) > 0 do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          cmp(Data, I, J, False);
        end;

        Inc(I);
        Dec(J);
      end;

    until I > J;

    if A < J then
      QSORT1(Data, A, J, cmp);

    A := I;
    
  until I >= B;
end;  

procedure QSORT(var Data; A, B: Integer;
  cmp: TCmpFunc);
var
    Lo, Hi, Mid, T: Integer;
begin
  Lo := A;
  Hi := B;
  //Mid := Data[(Lo + Hi) div 2];
  Mid := (Lo + Hi) div 2;

  repeat
    //while Data[Lo] < Mid do Inc(Lo);
    while cmp(Data, Lo, Mid, True) < 0 do Inc(Lo);
    //while Data[Hi] > Mid do Dec(Hi);
    while cmp(Data,Hi,Mid, True) > 0 do Dec(Hi);
    if Lo <= Hi then
    begin
      //VisualSwap(Data[Lo], Data[Hi], Lo, Hi);
      {T := Data[Lo];
      Data[Lo] := Data[Hi];
      Data[Hi] := T;}
      cmp(Data, Lo, Hi, False);

      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > A then QSORT(Data, A, Hi, cmp);
  if Lo < B then QSORT(Data, Lo, B, cmp);
end;

procedure QuickSort(var APoints: TArrayOfStitchPoint; L, R: Integer;
  SCompare: TPointSortCompare);
var
  I, J : Integer;
  P, T : TStitchPoint;
begin
  if (Length(APoints) < 1) or (R-L < 1) then //nothing to compare?
    exit;
   
  repeat
    I := L;
    J := R;
    P := APoints[(L + R) shr 1];
    repeat
      while SCompare(APoints[I], P) < 0 do
        Inc(I);

      while SCompare(APoints[J], P) > 0 do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          T          := APoints[I];
          APoints[I] := APoints[J];
          APoints[J] := T;
        end;
  
        Inc(I);
        Dec(J);
      end;

    until I > J;

    if L < J then
      QuickSort(APoints, L, J, SCompare);

    L := I;
    
  until I >= R;
end;

procedure QuickSortLine(var ALines: TArrayOfStitchLine; L, R: Integer;
  SCompare: TCompareFunc);
var
  I, J : Integer;
  P, T : TStitchLine;
begin
  if (Length(ALines) < 1) or (R-L < 1) then //nothing to compare?
    exit;
   
  repeat                                
    I := L;
    J := R;
    P := ALines[(L + R) shr 1];
    repeat
      while SCompare(ALines[I], P) < 0 do
        Inc(I);

      while SCompare(ALines[J], P) > 0 do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          T          := ALines[I];
          ALines[I] := ALines[J];
          ALines[J] := T;
        end;
  
        Inc(I);
        Dec(J);
      end;

    until I > J;

    if L < J then
      QuickSortLine(ALines, L, J, SCompare);

    L := I;
    
  until I >= R;
end;
procedure QuickSortFloatPointY(var A: TArrayOfFloatPoint; iLo, iHi: Integer);
var
  Lo, Hi: Integer;
  Mid, T : TFloatPoint;
begin
  Lo := iLo;
  Hi := iHi;
  Mid := A[(Lo + Hi) div 2];
  repeat
    while A[Lo].Y < Mid.Y do Inc(Lo);
    while A[Hi].Y > Mid.Y do Dec(Hi);
    if Lo <= Hi then
    begin
      //VisualSwap(A[Lo], A[Hi], Lo, Hi);
      T := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > iLo then QuickSortFloatPointY(A, iLo, Hi);
  if Lo < iHi then QuickSortFloatPointY(A, Lo, iHi);

end;

procedure QuickSortFloatRectTop(var A: TArrayOfFloatRect; iLo, iHi: Integer);
    function cmp(APoint1, APoint2: TFloatPoint): Integer;
    begin
      if APoint2.Y < APoint1.Y then
      begin
        Result := 1;
        Exit;
      end;

      if APoint2.Y > APoint1.Y then
      begin
        Result := -1;
        Exit;
      end;

      if APoint2.X < APoint1.X then
      begin
        Result := 1;
        Exit;
      end;

      if APoint2.X > APoint1.X then
      begin
        Result := -1;
        Exit;
      end;

      Result := 0;
    end;
var
  Lo, Hi: Integer;
  Mid, T : TFloatRect;
begin
  Lo := iLo;
  Hi := iHi;
  Mid := A[(Lo + Hi) div 2];
  repeat
    //while A[Lo].Top < Mid.Top do Inc(Lo);
    while cmp(A[Lo].TopLeft , Mid.TopLeft) < 0 do Inc(Lo);
    //while A[Hi].Top > Mid.Top do Dec(Hi);
    while cmp(A[Hi].TopLeft, Mid.TopLeft) > 0 do Dec(Hi);


    if Lo <= Hi then
    begin
      //VisualSwap(A[Lo], A[Hi], Lo, Hi);
      T := A[Lo];
      A[Lo] := A[Hi];
      A[Hi] := T;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > iLo then QuickSortFloatRectTop(A, iLo, Hi);
  if Lo < iHi then QuickSortFloatRectTop(A, Lo, iHi);
    
end;

procedure FloatPointSort(var APoints: TArrayOfStitchPoint; L, R: Integer;
  ACompare: TPointSortCompare);
var
  LCount : Integer;
begin
  LCount := Length(APoints);

  if LCount > 1 then
  begin
    // calling Compare() to sort points  
    QuickSort(APoints, L, R, ACompare);
  end
end;

function Compare_LinesInBar(APoint1, APoint2: TStitchPoint): Integer;
begin
  if APoint2.Y < APoint1.Y then
  begin
    Result := 1;
    Exit;
  end;

  if APoint2.Y > APoint1.Y then
  begin
    Result := -1;
    Exit;
  end;

  if APoint2.X < APoint1.X then
  begin
    Result := 1;
    Exit;
  end;

  if APoint2.X > APoint1.X then
  begin
    Result := -1;
    Exit;
  end;

  Result := 0;
end;

function Compare_LinesInARegion1(APoint1, APoint2: TStitchPoint): Integer;
begin
  Result := 0;
  if APoint2.lin < APoint1.lin then
  begin
    Result := 1;
  end
  else
  if APoint2.lin > APoint1.lin then
  begin
    Result := -1;
  end
  else //we are in the same lin
    begin
    
      if APoint2.grp < APoint1.grp then
      begin
        Result := 1;
      end
      else
      if APoint2.grp > APoint1.grp then
      begin
        Result := -1;
      end;
    end;
end;


function Compare_LinesInARegion2(const Item1, Item2): Integer;
var APoint1, APoint2: TStitchPoint;
begin
  APoint1 := TStitchLine(Item1).Start;
  APoint2 := TStitchLine(Item2).Start;
  Result := 0;
      if APoint2.WesternIndex < APoint1.WesternIndex then
      begin
        Result := 1;
      end
      else
      if APoint2.WesternIndex > APoint1.WesternIndex then
      begin
        Result := -1;
      end
      else
      if APoint2.NorthIndex < APoint1.NorthIndex then
      begin
        Result := 1;
      end
      else
      if APoint2.NorthIndex > APoint1.NorthIndex then
      begin
        Result := -1;
      end
      else
  if APoint2.lin < APoint1.lin then
  begin
    Result := 1;
  end
  else
  if APoint2.lin > APoint1.lin then
  begin
    Result := -1;
  end
  else //we are in the same lin


      begin

        if APoint2.grp < APoint1.grp then
        begin
          Result := 1;
        end
        else
        if APoint2.grp > APoint1.grp then
        begin
          Result := -1;
        end;
      end;
end;

function cmp_LinesInARegion(var Data;  const A, B : Integer; Compare: Boolean): Integer;
var
  APoint1, APoint2: TStitchPoint;
  Temp : TStitchLine;
  //Lines : TArrayOfStitchLine absolute Data;
  Lines : TArrayOfStitchLine;
begin
  Result := 0;
  PArrayOfStitchLine(Lines) := @TArrayOfStitchLine(@Data)[0];

  try


    if not Compare then
    begin
      Temp := Lines[B];
      Lines[B] := Lines[A];
      Lines[A] := Temp;
      Exit;
    end;

  
    APoint1 := Lines[A].Start;
    APoint2 := Lines[B].Start;

    if APoint2.lin < APoint1.lin then
    begin
      Result := 1;
    end
    else
    if APoint2.lin > APoint1.lin then
    begin
      Result := -1;
    end
    else //we are in the same lin
      begin
    
        if APoint2.grp < APoint1.grp then
        begin
          Result := 1;
        end
        else
        if APoint2.grp > APoint1.grp then
        begin
          Result := -1;
        end;
      end;

  finally
    PArrayOfStitchLine(Lines) := nil;
  end;
end;

function Compare_LinesInARegion(const Item1, Item2): Integer;
var APoint1, APoint2: TStitchPoint;
begin
  APoint1 := TStitchLine(Item1).Start;
  APoint2 := TStitchLine(Item2).Start;  
  Result := 0;
  {if APoint1.jump > 1 then
  begin
    if APoint2.x < APoint1.x then
    begin
      Result := 1;
    end
    else
    if APoint2.x > APoint1.x then
    begin
      Result := -1;
    end
  end;
  }
  if Result = 0 then

  if APoint2.y < APoint1.y then
    begin
      Result := 1;
    end
    else
    if APoint2.y > APoint1.y then            
    begin
      Result := -1;
    end


  else
{if (APoint1.jump > 1) or (APoint2.jump > 1) then
  begin
    if APoint2.x < APoint1.x then
    begin
      Result := 1;
    end
    else
    if APoint2.x > APoint1.x then
    begin
      Result := -1;
    end
  end
else}     
if APoint2.lin < APoint1.lin then
  begin
    Result := 1;
  end
  else
  if APoint2.lin > APoint1.lin then
  begin
    Result := -1;
  end
  else   
    //we are in the same lin
    begin
    
      if APoint2.grp < APoint1.grp then
      begin
        Result := 1;
      end
      else
      if APoint2.grp > APoint1.grp then
      begin
        Result := -1;
      end;
    end;
end;

(* closed. use fnhrz instead that is scanning by Y through Y2, each iteration from left to right
procedure fnvrt(AStitchForm: TEmbroideryItem; ABitmap32 : TBitmap32);
// scan f
var
  i, j, p     : Integer;
  LSides      : Integer;
  LPriorCount : Integer;
  LBarCount   : Integer;
  LTempCount  : Integer;
  LLowX       : Double;
  LHighX      : Double;
  LGap        : Double;
  x0          : Double;
  LPoint1,
  LPoint2     : TFloatPoint;
  LProjPoint  : TFloatPoint;
  LPoints     : TArrayOfStitchPoint;
  //LFillPoints : TArrayOfTSMALPNTL;
  lx, ly      : TFloat;
  x, y, w     : Integer;
  x1,x2,y1,y2 : Single;
  c1,c2       : TColor32;
  inf         : Cardinal;
  LIndex      : Word;
  LGroupIndex : Word;
  OwnedBitmap32      : Boolean;
  LShape      : PgmShapeInfo;
  LColor32    : TColor32;
  Lini        : TThredIniFile;
  LFillPoints : TArrayOfStitchPoint;
  rg1ItemIndex : Integer; //radio group

  procedure DrawVertex();
  var i : Integer;
  begin
 //draw VERTEX
    with ABitmap32 do
    begin
      with LShape.Points[0] do
      begin
        ABitmap32.MoveToF(x, y);
        lx := x;
        ly := y;
      end;
      //Pen.Width := 2;
      Font.Size := 42;
      //Brush.Style := bsClear;

      for i := 0 to (LSides) do
      begin
        PenColor := (UEdgeColors[(VERTICES+i-1) mod VERTICES]);

        with LShape.Points[i mod LSides] do
        begin
          LineToFS(x,y);
          lx := x;
          ly := y;
        end;
      end;
    
      //text
      with LShape.Points[0] do
      begin
        lx := x;
        ly := y;
      end;
      for i := 1 to (LSides ) do
      begin
        PenColor := WinColor(UEdgeColors[(VERTICES+i-1) mod VERTICES]);

        with LShape.Points[i mod LSides] do
        begin
          //ABitmap32.TextOut( Round(lx + (x-lx)/ 2 ), Round(ly + (y-ly)/ 2), IntToStr(i));
          lx := x;
          ly := y;
        end;
      end;
    end;
  end;

  procedure DrawFill();
  var i,j : Integer;
  begin
    LBarCount := Length(LFillPoints);

    //DRAWING.
    if LBarCount > 0 then
    begin
      //ABitmap32.PenColor := clRed32;

      x := Round(LFillPoints[0].X);
      y := Round(LFillPoints[0].Y);
      ABitmap32.MoveTo(x, y);

      i := 0;


      i := 0;
      for j := 0 to (LBarCount - 1) do
      begin
        x1 := (LFillPoints[i].X);
        y1 := (LFillPoints[i].Y);
        //if chkDrawBoth.Checked then
        begin
          case rg1ItemIndex of
            0 : c1 := UEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
            1 : c2 := UEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
          end;
          //ABitmap32.LineToS(x, y);
          //ABitmap32.LineToFS(LFillPoints[i].X, LFillPoints[i].Y);
        end;
        //else
        ABitmap32.MoveToF(x1, y1);
        //ABitmap32.MoveTo(x, y);

        inc(i);
        case rg1ItemIndex of
          0 : c2 := UEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
          1 : c2 := UEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
        end;

        x2 := (LFillPoints[i].X);          
        y2 := (LFillPoints[i].Y);

        //three line below is backup line drawing, because in "GRP" draw, each line is end with white
        ABitmap32.PenColor := c2;
        ABitmap32.LineToFS(X2, Y2); //it move the begin line
        ABitmap32.MoveToF(x1, y1); //set back to original begin line


        //ABitmap32.LineToS(x, y);
        ABitmap32.SetStipple([c1,c1,c2,c2,c2,c2]);
        ABitmap32.StippleCounter := 0;
        //ABitmap32.LineToFS(x2,y2);
        ABitmap32.StippleStep := 3/max(Max(y2,y1) - Min(y2,y1),1);
        //ABitmap32.PenColor := c2;
        ABitmap32.LineToFSP(X2, Y2);
        inc(i);
        if i >= LBarCount -1 then break;
      end;

      w := 3;
      for i := 0 to (LBarCount - 1) do
      begin
        x := Round(LFillPoints[i].X);
        y := Round(LFillPoints[i].Y);

        case rg1ItemIndex of
          0 : ABitmap32.FillRectS(x - w, y - w, x + w, y + w, UEdgeColors[LFillPoints[i].lin mod VERTICES]);
          1 : ABitmap32.FillRectS(x - w, y - w, x + w, y + w, UEdgeColors[LFillPoints[i].grp mod VERTICES]);
        end;

      end;                       

      //SetLength(FFillPoints, 0);
      //FFillPoints := nil;
    end;
  end;

var
  //LWholeVertexs : TArrayOfFloatPoint;
  LWholeSides   : Integer;  
begin
  if not Assigned(AStitchForm) then
    Exit;
  rg1ItemIndex := 0;
  {OwnedBitmap32 := False;
  if not Assigned(ABitmap32) then
  begin
    OwnedBitmap32 := True;           
    ABitmap32 := TBitmap32.Create;
    ABitmap32.SetSize(800,600);
  end;}

  //if Assigned(AStitchForm.Ini) then
    //LIni := AStitchForm.Ini^;
  LIni.StitchSpacing := 10;//self.gbrSpace1.Position/10;

  LLowX  := High(Integer);// LShape.Points[0].X;
  LHighX := Low(Integer);// LLowX;

  //1 FIND MIN MAX X
  //SetLength(LWholeVertexs,0);
  LPriorCount := 0;
  for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
  begin
    LShape := @AStitchForm.PolyPolygon^[p];
    LSides := Length(LShape.Points);

    if Assigned(ABitmap32) then
      DrawVertex();


    //SetLength(LWholeVertexs, LPriorCount + LSides);
    for i := 0 to ( LSides - 1 ) do
    begin
      if LShape.Points[i].X > LHighX then
      begin
        LHighX := LShape.Points[i].X;
      end;

      if LShape.Points[i].X < LLowX then
      begin
        LLowX := LShape.Points[i].X;
      end;
      //LWholeVertexs[LPriorCount + i] := LShape.Points[i];
    end;
    Inc(LPriorCount, LSides); 
  end;
  LWholeSides := LPriorCount;

    LTempCount := Trunc(LLowX / LIni.StitchSpacing);
    LLowX      := LIni.StitchSpacing * LTempCount;
    LBarCount  := Trunc( (LHighX - LLowX) / LIni.StitchSpacing ) + 1;
    //mmo1.Lines.Add('LCOUNT:'+inttostr(LCount));

    LGap := (LHighX - LLowX) / LBarCount;

    SetLength(LPoints, LWholeSides + 2);

    LGroupIndex := 0;

    x0    := LLowX;
    for i := 0 to (LBarCount - 1) do
    begin
      x0  := x0 + LGap;

      inf := 0;
      for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
      begin
        LShape := @AStitchForm.PolyPolygon^[p];
        LSides := Length(LShape.Points);
        for j := 0 to (LSides - 2) do
        begin
          LPoint1 := LShape.Points[j];
          LPoint2 := LShape.Points[j+1];

          if ProjV(x0, LPoint1, LPoint2, LProjPoint) then
          begin
            LPoints[inf].X   := LProjPoint.X;
            LPoints[inf].y   := LProjPoint.y;
            LPoints[inf].lin := j;

            Inc(inf);
          end;
        end;

        LPoint1 := LShape.Points[LSides - 1];
        LPoint2 := LShape.Points[0];
        if ProjV(x0, LPoint1, LPoint2, LProjPoint) then
        begin
          LPoints[inf].lin := inf;
          LPoints[inf].X   := LProjPoint.X;
          LPoints[inf].y   := LProjPoint.y;

          Inc(inf);
        end;
      end;

      if inf > 1 then
      begin
        inf := inf and $FFFFFFFE; //EVENT & DEL IF ODD

        FloatPointSort(LPoints, 0, inf - 1, Compare_LinesInBar);

        j := 0;
        while j < inf do
        begin

          // X1
          SetLength(LFillPoints, Length(LFillPoints) + 1);
          LIndex := High(LFillPoints);

          LFillPoints[LIndex].x   := LPoints[j].x;
          LFillPoints[LIndex].y   := LPoints[j].y;
          LFillPoints[LIndex].lin := LPoints[j].lin;
          LFillPoints[LIndex].grp := LGroupIndex;
          Inc(j);

          // do twice ...
          // X2
          SetLength(LFillPoints, Length(LFillPoints) + 1);
          LIndex := High(LFillPoints);

          LFillPoints[LIndex].x   := LPoints[j].x;
          LFillPoints[LIndex].y   := LPoints[j].y;
          LFillPoints[LIndex].lin := LPoints[j].lin;
          LFillPoints[LIndex].grp := LGroupIndex;
          Inc(j);
        end;

        if j <> 0 then
        begin
          Inc(LGroupIndex);
        end;
      end;
    end;

    
  if Assigned(ABitmap32) then
    DrawFill();


  SetLength(LPoints, 0);
  LPoints := nil;
end;
*)

procedure fnhrz_toofar_IcanthandleIt(AStitchForm: TEmbroideryItem; ABitmap32 : TBitmap32);
var
  i, j, k, p  : Integer;
  LenSides    : Integer;
  LPriorCount : Integer;
  LBarCount   : Integer;
  LTempCount  : Integer;
  LLowY       : Double;
  LHighY      : Double;
  LGap        : Double;
  y0          : Double;
  LPoint1,
  LPoint2     : TFloatPoint;
  LProjPoint  : TFloatPoint;
  LPoints     : TArrayOfStitchPoint;
  //LFillPoints : TArrayOfTSMALPNTL;
  lx, ly      : TFloat;
  x, y, w     : Integer;
  x1,x2,y1,y2 : Single;
  c1,c2       : TColor32;
  inf         : Cardinal;
  LIndex      : Word;
  LGroupIndex : Word;
  OwnedBitmap32      : Boolean;
  LShape      : PgmShapeInfo;
  LColor32    : TColor32;
  Lini        : TThredIniFile;
  LFillPoints : TArrayOfStitchPoint;
  rg1ItemIndex : Integer; //radio group

  procedure DrawVertex();
  var i : Integer;
  begin
    if Length(LShape.Points) < 1 then Exit;
 //draw VERTEX
    with ABitmap32 do
    begin
      with LShape.Points[0] do
      begin
        ABitmap32.MoveToF(x, y);
        lx := x;
        ly := y;
      end;
      //Pen.Width := 2;
      Font.Size := 42;
      //Brush.Style := bsClear;

      for i := 0 to (LenSides) do
      begin
        PenColor := (UEdgeColors[(VERTICES+i-1) mod VERTICES]);

        with LShape.Points[i mod LenSides] do
        begin
          LineToFS(x,y);
          lx := x;
          ly := y;
        end;
      end;
    
      //text
      with LShape.Points[0] do
      begin
        lx := x;
        ly := y;
      end;
      for i := 1 to (LenSides ) do
      begin
        PenColor := WinColor(UEdgeColors[(VERTICES+i-1) mod VERTICES]);

        with LShape.Points[i mod LenSides] do
        begin
          //ABitmap32.TextOut( Round(lx + (x-lx)/ 2 ), Round(ly + (y-ly)/ 2), IntToStr(i));
          lx := x;
          ly := y;
        end;
      end;
    end;
  end;

  procedure DrawFill();
  var i,j : Integer;
  begin
    LBarCount := Length(LFillPoints);

    //DRAWING.
    if LBarCount > 0 then
    begin
      //ABitmap32.PenColor := clRed32;

      x := Round(LFillPoints[0].X);
      y := Round(LFillPoints[0].Y);
      ABitmap32.MoveTo(x, y);

      i := 0;


      i := 0;
      for j := 0 to (LBarCount - 1) do
      begin
        x1 := (LFillPoints[i].X);
        y1 := (LFillPoints[i].Y);
        //if chkDrawBoth.Checked then
        begin
          case rg1ItemIndex of
            0 : c1 := UEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
            1 : c2 := UEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
          end;
          //ABitmap32.LineToS(x, y);
          //ABitmap32.LineToFS(LFillPoints[i].X, LFillPoints[i].Y);
        end;
        //else
        ABitmap32.MoveToF(x1, y1);
        //ABitmap32.MoveTo(x, y);

        inc(i);
        case rg1ItemIndex of
          0 : c2 := UEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
          1 : c2 := UEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
        end;

        x2 := (LFillPoints[i].X);          
        y2 := (LFillPoints[i].Y);

        //three line below is backup line drawing, because in "GRP" draw, each line is end with white
        {Bitmap32.PenColor := c2;
        ABitmap32.LineToFS(X2, Y2); //it move the begin line
        ABitmap32.MoveToF(x1, y1); //set back to original begin line
        }

        //ABitmap32.LineToS(x, y);
        ABitmap32.SetStipple([c1,c1,c2,c2, c2,c2]);
        ABitmap32.StippleCounter := 0;
        //ABitmap32.LineToFS(x2,y2);
        ABitmap32.StippleStep := 3.5/ max(Max(x2,x1) - Min(x2,x1),1);
        //ABitmap32.PenColor := c2;
        ABitmap32.LineToFSP(X2, Y2);
        inc(i);
        if i >= LBarCount -1 then break;
      end;

      w := 2;
      for i := 0 to (LBarCount - 1) do
      begin
        x := Round(LFillPoints[i].X);
        y := Round(LFillPoints[i].Y);

        case rg1ItemIndex of
          0 : ABitmap32.FillRectS(x - w, y - w, x + w, y + w, UEdgeColors[LFillPoints[i].lin mod VERTICES]);
          1 : ABitmap32.FillRectS(x - w, y - w, x + w, y + w, UEdgeColors[LFillPoints[i].grp mod VERTICES]);
        end;

      end;                       

      //SetLength(FFillPoints, 0);
      //FFillPoints := nil;
    end;
  end;

var
  //LWholeVertexs : TArrayOfFloatPoint;
  LWholeSides   : Integer;
  LJumps : TArrayOfByte; //count of lines each bar
  LastLin,LastJump : Integer; //prior count of lines
  LRegions : TArrayOfPoint;// x=start, y=finish
  LLines : TArrayOfStitchLine;
  F,L,Z : Integer;
  LastZ, LzY : Integer;
  LCorners,TempCorners : TArrayOfFloatRect;
  R : TFloatRect;
  LWestern : Integer; //island index;
begin
  if not Assigned(AStitchForm) then
    Exit;
  rg1ItemIndex := 0;


  //if Assigned(AStitchForm.Ini) then
    //LIni := AStitchForm.Ini^;
  LIni.StitchSpacing := 1;//0.45;//self.gbrSpace1.Position/10;

  LLowY  := High(Integer);// LShape.Points[0].X;
  LHighY := Low(Integer);// LLowX;

  //1 FIND MIN MAX X
  //SetLength(LWholeVertexs,0);
  LPriorCount := 0;
  for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
  begin
    LShape := @AStitchForm.PolyPolygon^[p];
    LenSides := Length(LShape.Points);

    if Assigned(ABitmap32) then
      DrawVertex();


    //SetLength(LWholeVertexs, LPriorCount + LSides);
    for i := 0 to ( LenSides - 1 ) do
    begin
      if LShape.Points[i].Y > LHighY then
      begin
        LHighY := LShape.Points[i].Y;
      end;

      if LShape.Points[i].Y < LLowY then
      begin
        LLowY := LShape.Points[i].Y;
      end;
      //LWholeVertexs[LPriorCount + i] := LShape.Points[i];
    end;
    Inc(LPriorCount, LenSides); 
  end;
  LWholeSides := LPriorCount;

  LTempCount := Trunc(LLowY / LIni.StitchSpacing);
  LLowY      := LIni.StitchSpacing * LTempCount;
  LBarCount  := Trunc( (LHighY - LLowY) / LIni.StitchSpacing ) + 1;

  if LBarCount < 2 then Exit;

  //prepare jump count & regions
  SetLength(LJumps,LBarCount);
  FillChar(LJumps[0],LBarCount,0); //fill zero
  SetLength(LRegions,0);
  //LRegions[0].x := 0;//first bar          
  LastJump := 0;
  L := 0;


  LGap := (LHighY - LLowY) / LBarCount;



    LzY   := 0;
    //get intersection of a scanline through all polygon of each shape
    for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
    begin
      LShape := @AStitchForm.PolyPolygon^[p];

      LenSides := Length(LShape.Points);
      //we only interest on closed polygon
      LPoint1 := LShape.Points[LenSides - 1];
      LPoint2 := LShape.Points[0];
      if (LPoint1.X = LPoint2.X) and (LPoint1.Y = LPoint2.Y) then
        Dec(LenSides);

      if LenSides >= 3 then
      begin

        //we need to sort all corner by Y of this polygon...
        //but in same time we also need to keep all sides in it's order.
        // (if I sort directly the corner, the polygon then unpredicable shape.)
        //So, we make a copy of corners, not change order directly.
        SetLength(LCorners, LzY+ LenSides);
        for j := 0 to LenSides - 1 do
        begin
          LCorners[LzY+j].TopLeft := LShape.Points[j];
          k := (j + 1) mod LenSides; //avoid range error | we connect the last to the first, if necessery.
          LCorners[LzY+j].BottomRight := LShape.Points[k];

          //okay, nice. but then we care the direction. it should be ascending only.
          if LCorners[LzY+j].Bottom > LCorners[LzY+j].Top then
          begin
            //swap!
            LPoint1 := LCorners[LzY+j].BottomRight;
            LCorners[LzY+j].BottomRight := LCorners[LzY+j].TopLeft;
            LCorners[LzY+j].TopLeft := LPoint1;
          end;
        end;
        Inc(LzY, LenSides);

      end;
    end; //for p

    //detect collision between 2 lines.
    //if any intersection found, we break 2 lines into 4 lines.
    //BUBLES:
    for I := Low(LCorners) to High(LCorners) -1  do
      for J := I to High(LCorners) do
      begin
        if i = j then Continue;
        
        if GR32_VectorUtils.Intersect(
          LCorners[i].TopLeft, LCorners[i].BottomRight,
          LCorners[j].TopLeft, LCorners[j].BottomRight, LPoint1) then
        begin
          //I:
          R := LCorners[i]; //save
          LCorners[i].BottomRight := LPoint1;
          R.TopLeft := LPoint1;
          SetLength(TempCorners, Length(TempCorners)+1);
          TempCorners[High(TempCorners)] := R;


          //twice
          //J:
          R := LCorners[j]; //save
          LCorners[j].BottomRight := LPoint1;
          R.TopLeft := LPoint1;
          SetLength(TempCorners, Length(TempCorners)+1);
          TempCorners[High(TempCorners)] := R;

        end;

      end;
    //attach
    I := Length(LCorners); //before resize
    J := Length(TempCorners);
    SetLength(LCorners, I+J+1); //resizing
    Move(TempCorners[0], LCorners[I+1], SizeOf(TFloatRect) * J);

        //Move(LShape.Points[0], LCorners[0], SizeOf(TFloatPoint) * LenSides);
        //QuickSortFloatPointY(LCorners, 0, High(LCorners));
        QuickSortFloatRectTop(LCorners, 0, High(LCorners));

  SetLength(LPoints, LWholeSides + 2);

  LGroupIndex := 0;

  y0    := LLowY;

  for i := 0 to (LBarCount - 1) do
  begin
    y0  := y0 + LGap;

    inf := 0;
        //here is the real calculation
        //for j := 0 to LenSides - 1 do
        for j := 0 to High(LCorners) do
        begin
          if ProjH(y0, LCorners[j].TopLeft, LCorners[j].BottomRight, LProjPoint) then
          begin
            LPoints[inf].X   := LProjPoint.X;
            LPoints[inf].y   := LProjPoint.y;
            LPoints[inf].lin := j;//j;   //distinc corner index in whole shape, even different polygon
            //inc(LzY);

            Inc(inf);
          end;
        end;

      //end;
      //Inc(LzY, LenSides);

    //end;

    if inf > 1 then
    begin
      inf := inf and $FFFFFFFE; //EVENT only. DEL IF ODD
      LJumps[i] := inf div 2;

      FloatPointSort(LPoints, 0, inf - 1, Compare_LinesInBar);

      j := 0;
      LWestern := High(Integer);
      while j < inf do
      begin
        // X1
        SetLength(LFillPoints, Length(LFillPoints) + 1);
        LIndex := High(LFillPoints);

        LFillPoints[LIndex].x   := LPoints[j].x;
        LFillPoints[LIndex].y   := LPoints[j].y;
        LFillPoints[LIndex].lin := LPoints[j].lin;
        LFillPoints[LIndex].grp := LGroupIndex;
        if LFillPoints[LIndex].x < LWestern then
          LWestern := 0
        else
          Inc(LWestern);
        LFillPoints[LIndex].WesternIndex := LWestern;
        Inc(j);

        // do twice ...
        // X2
        SetLength(LFillPoints, Length(LFillPoints) + 1);
        LIndex := High(LFillPoints);

        LFillPoints[LIndex].x   := LPoints[j].x;
        LFillPoints[LIndex].y   := LPoints[j].y;
        LFillPoints[LIndex].lin := LPoints[j].lin;
        LFillPoints[LIndex].grp := LGroupIndex;
        LFillPoints[LIndex].WesternIndex := LWestern;
        Inc(j);
      end;

      if j <> 0 then
      begin
        Inc(LGroupIndex);
      end;
    end;

    //REGION
    // a star when be divided into 3 region with jumps => [2,1,2] will be lik this:
    //        1
    //   22211111222
    //      11111
    //    22     22
    //
    if (inf > 1) and (LastJump <> LJumps[i]) then
    begin
      L := Length(LRegions);
      F := High(LFillPoints)-LJumps[i];
      if L > 0 then
        LRegions[L-1].Y := F-1; //prior end

      SetLength(LRegions, L+1);
      L := High(LRegions);
      LRegions[L].X := F;
      LastJump := LJumps[i];
    end;
  end;
  LRegions[L].Y := High(LFillPoints);
  // lines is sorted by GRP
  //        1
  //   22222222222
  //      33333
  //    44     44
  //


  //sort by sequence of : Jumps, lin            
  PArrayOfStitchLine(LLines) :=  @LFillPoints[0]; 
  Z := 0;
  LastLin := LLines[0].Start.lin;
  for i := 0 to High(LRegions) do
  begin
    for j := LRegions[i].X   to LRegions[i].Y   do
    begin
      //LFillPoints[j].jump := LJumps[ j ];

      LFillPoints[j].NorthIndex := i; //this is also okay!
    end;
    //QuickSort(LFillPoints, LRegions[i].X, LRegions[i].Y, Compare_LinesInARegion);
    QuickSortLine( LLines, LRegions[i].X div 2, LRegions[i].Y div 2, Compare_LinesInARegion2);
    //QSORT(LLines, LRegions[i].X div 2, LRegions[i].Y div 2, cmp_LinesInARegion );
    // lines sorted by REGION, LIN, GRP

    
    {for j := LRegions[i].X div 2  to LRegions[i].Y div 2  do
    begin
      if LFillPoints[j].lin <> LastJump then
      begin
        LastJump := LFillPoints[j].lin;
        Inc(z);
      end;
      LFillPoints[j].region := z;
    end;}

    //Write the region signal

    for j := LRegions[i].X div 2   to LRegions[i].Y div 2   do
    begin
      if (LLines[j].Start.lin <> LastLin) then
      begin
        LastLin := LLines[j].Start.lin;

        if (j > 0) then
        begin
          Inc(z);
        end;
      end;
      LLines[j].Start.region := z;
      LLines[j].Finish.region := z;


    end;


  end;

  PArrayOfStitchLine(LLines) := nil;
  //SetLength(AStitchForm.Stitchs^, Length(LFillPoints) );
  //Move(LFillPoints[0], AStitchForm.Stitchs^[0], SizeOf(TStitchPoint) * High(LFillPoints));
  AStitchForm.Stitchs^ := LFillPoints;
    
  //if Assigned(ABitmap32) then
    //DrawFill();


  //SetLength(LPoints, 0);
  //LPoints := nil;
end;

procedure fnhrz(AStitchForm: TEmbroideryItem; ABitmap32 : TBitmap32);
var
  i, j, k, p  : Integer;
  LenSides    : Integer;
  LPriorCount : Integer;
  LBarCount   : Integer;
  LTempCount  : Integer;
  LLowY       : Double;
  LHighY      : Double;
  LGap        : Double;
  y0          : Double;
  LPoint1,
  LPoint2     : TFloatPoint;
  LProjPoint  : TFloatPoint;
  LPoints     : TArrayOfStitchPoint;
  //LFillPoints : TArrayOfTSMALPNTL;
  lx, ly      : TFloat;
  x, y, w     : Integer;
  x1,x2,y1,y2 : Single;
  c1,c2       : TColor32;
  inf         : Cardinal;
  LIndex      : Word;
  LGroupIndex : Word;
  OwnedBitmap32      : Boolean;
  LShape      : PgmShapeInfo;
  LColor32    : TColor32;
  Lini        : TThredIniFile;
  LFillPoints : TArrayOfStitchPoint;
  rg1ItemIndex : Integer; //radio group

  procedure DrawVertex();
  var i : Integer;
  begin
    if Length(LShape.Points) < 1 then Exit;
 //draw VERTEX
    with ABitmap32 do
    begin
      with LShape.Points[0] do
      begin
        ABitmap32.MoveToF(x, y);
        lx := x;
        ly := y;
      end;
      //Pen.Width := 2;
      Font.Size := 42;
      //Brush.Style := bsClear;

      for i := 0 to (LenSides) do
      begin
        PenColor := (UEdgeColors[(VERTICES+i-1) mod VERTICES]);

        with LShape.Points[i mod LenSides] do
        begin
          LineToFS(x,y);
          lx := x;
          ly := y;
        end;
      end;
    
      //text
      with LShape.Points[0] do
      begin
        lx := x;
        ly := y;
      end;
      for i := 1 to (LenSides ) do
      begin
        PenColor := WinColor(UEdgeColors[(VERTICES+i-1) mod VERTICES]);

        with LShape.Points[i mod LenSides] do
        begin
          //ABitmap32.TextOut( Round(lx + (x-lx)/ 2 ), Round(ly + (y-ly)/ 2), IntToStr(i));
          lx := x;
          ly := y;
        end;
      end;
    end;
  end;

  procedure DrawFill();
  var i,j : Integer;
  begin
    LBarCount := Length(LFillPoints);

    //DRAWING.
    if LBarCount > 0 then
    begin
      //ABitmap32.PenColor := clRed32;

      x := Round(LFillPoints[0].X);
      y := Round(LFillPoints[0].Y);
      ABitmap32.MoveTo(x, y);

      i := 0;


      i := 0;
      for j := 0 to (LBarCount - 1) do
      begin
        x1 := (LFillPoints[i].X);
        y1 := (LFillPoints[i].Y);
        //if chkDrawBoth.Checked then
        begin
          case rg1ItemIndex of
            0 : c1 := UEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
            1 : c2 := UEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
          end;
          //ABitmap32.LineToS(x, y);
          //ABitmap32.LineToFS(LFillPoints[i].X, LFillPoints[i].Y);
        end;
        //else
        ABitmap32.MoveToF(x1, y1);
        //ABitmap32.MoveTo(x, y);

        inc(i);
        case rg1ItemIndex of
          0 : c2 := UEdgeColors[LFillPoints[i].lin mod VERTICES] and TRA;
          1 : c2 := UEdgeColors[LFillPoints[i].grp mod VERTICES] and TRA;
        end;

        x2 := (LFillPoints[i].X);          
        y2 := (LFillPoints[i].Y);

        //three line below is backup line drawing, because in "GRP" draw, each line is end with white
        {Bitmap32.PenColor := c2;
        ABitmap32.LineToFS(X2, Y2); //it move the begin line
        ABitmap32.MoveToF(x1, y1); //set back to original begin line
        }

        //ABitmap32.LineToS(x, y);
        ABitmap32.SetStipple([c1,c1,c2,c2, c2,c2]);
        ABitmap32.StippleCounter := 0;
        //ABitmap32.LineToFS(x2,y2);
        ABitmap32.StippleStep := 3.5/ max(Max(x2,x1) - Min(x2,x1),1);
        //ABitmap32.PenColor := c2;
        ABitmap32.LineToFSP(X2, Y2);
        inc(i);
        if i >= LBarCount -1 then break;
      end;

      w := 2;
      for i := 0 to (LBarCount - 1) do
      begin
        x := Round(LFillPoints[i].X);
        y := Round(LFillPoints[i].Y);

        case rg1ItemIndex of
          0 : ABitmap32.FillRectS(x - w, y - w, x + w, y + w, UEdgeColors[LFillPoints[i].lin mod VERTICES]);
          1 : ABitmap32.FillRectS(x - w, y - w, x + w, y + w, UEdgeColors[LFillPoints[i].grp mod VERTICES]);
        end;

      end;                       

      //SetLength(FFillPoints, 0);
      //FFillPoints := nil;
    end;
  end;

var
  //LWholeVertexs : TArrayOfFloatPoint;
  LWholeSides   : Integer;
  LJumps : TArrayOfByte; //count of lines each bar
  LastWestern, LastX, LastZ, LzY : Integer;
  LastFX : TFloat;
  LastLin,LastJump : Integer; //prior count of lines
  LRegions : TArrayOfPoint;// x=start, y=finish
  LLines : TArrayOfStitchLine;
  F,L,Z : Integer;

  LCorners : TArrayOfFloatRect;
  LWestern : Integer; //island index;
begin
  if not Assigned(AStitchForm) then
    Exit;
  rg1ItemIndex := 0;


  //if Assigned(AStitchForm.Ini) then
    //LIni := AStitchForm.Ini^;
  LIni.StitchSpacing := 1;//0.45;//self.gbrSpace1.Position/10;

  LLowY  := High(Integer);// LShape.Points[0].X;
  LHighY := Low(Integer);// LLowX;

  //1 FIND MIN MAX X
  //SetLength(LWholeVertexs,0);
  LPriorCount := 0;
  for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
  begin
    LShape := @AStitchForm.PolyPolygon^[p];
    LenSides := Length(LShape.Points);

    if Assigned(ABitmap32) then
      DrawVertex();


    //SetLength(LWholeVertexs, LPriorCount + LSides);
    for i := 0 to ( LenSides - 1 ) do
    begin
      if LShape.Points[i].Y > LHighY then
      begin
        LHighY := LShape.Points[i].Y;
      end;

      if LShape.Points[i].Y < LLowY then
      begin
        LLowY := LShape.Points[i].Y;
      end;
      //LWholeVertexs[LPriorCount + i] := LShape.Points[i];
    end;
    Inc(LPriorCount, LenSides); 
  end;
  LWholeSides := LPriorCount;

  LTempCount := Trunc(LLowY / LIni.StitchSpacing);
  LLowY      := LIni.StitchSpacing * LTempCount;
  LBarCount  := Trunc( (LHighY - LLowY) / LIni.StitchSpacing ) + 1;

  if LBarCount < 2 then Exit;

  //prepare jump count & regions
  SetLength(LJumps,LBarCount);
  //FillChar(LJumps[0],LBarCount,0); //fill zero
  SetLength(LRegions,0);
  //LRegions[0].x := 0;//first bar          
  LastJump := 0;
  L := 0;


  LGap := (LHighY - LLowY) / LBarCount;

  SetLength(LPoints, LWholeSides + 2);

  LGroupIndex := 0;

  y0    := LLowY;

  for i := 0 to (LBarCount - 1) do
  begin
    y0  := y0 + LGap;

    LzY   := 0;
    inf := 0;

    //get intersection of a scanline through all polygon of each shape
    for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
    begin
      LShape := @AStitchForm.PolyPolygon^[p];

      LenSides := Length(LShape.Points);
      //we only interest on closed polygon
      LPoint1 := LShape.Points[LenSides - 1];
      LPoint2 := LShape.Points[0];
      if (LPoint1.X = LPoint2.X) and (LPoint1.Y = LPoint2.Y) then
        Dec(LenSides);

      if LenSides >= 3 then
      begin

        //we need to sort all corner by Y of this polygon...
        //but in same time we also need to keep all sides in it's order.
        // (if I sort directly the corner, the polygon then unpredicable shape.) 
        //So, we make a copy of corners, not change order directly.
        SetLength(LCorners, LenSides);
        for j := 0 to LenSides - 1 do
        begin
          LCorners[j].TopLeft := LShape.Points[j];
          k := (j + 1) mod LenSides; //avoid range error, we connect the last to the first, if necessery.
          LCorners[j].BottomRight := LShape.Points[k];

          //okay, nice. but then we care the direction. it should be ascending only.
          if LCorners[j].Bottom > LCorners[j].Top then
          begin
            //swap!
            LPoint1 := LCorners[j].BottomRight;
            LCorners[j].BottomRight := LCorners[j].TopLeft;
            LCorners[j].TopLeft := LPoint1;
          end;  
        end;
        //Move(LShape.Points[0], LCorners[0], SizeOf(TFloatPoint) * LenSides);
        //QuickSortFloatPointY(LCorners, 0, High(LCorners));
        QuickSortFloatRectTop(LCorners, 0, High(LCorners));


        //here the real calculation
        for j := 0 to LenSides - 1 do
        begin
          if ProjH(y0, LCorners[j].TopLeft, LCorners[j].BottomRight, LProjPoint) then
          begin
            LPoints[inf].X   := LProjPoint.X;
            LPoints[inf].y   := LProjPoint.y;
            LPoints[inf].lin := j+LzY;//j;   //distinc corner index in whole shape, even different polygon
            //inc(LzY);

            Inc(inf);
          end;
        end;

      end;
      Inc(LzY, LenSides);

    end;

    LJumps[i] := 0;
    if inf > 1 then
    begin
      inf := inf and $FFFFFFFE; //EVENT only. DEL IF ODD
      LJumps[i] := inf div 2;

      FloatPointSort(LPoints, 0, inf - 1, Compare_LinesInBar);

      j := 0;
      LWestern := High(Integer);
      while j < inf do
      begin
        // X1
        SetLength(LFillPoints, Length(LFillPoints) + 1);
        LIndex := High(LFillPoints);

        LFillPoints[LIndex].x   := LPoints[j].x;
        LFillPoints[LIndex].y   := LPoints[j].y;
        LFillPoints[LIndex].lin := LPoints[j].lin;
        LFillPoints[LIndex].grp := LGroupIndex;
        if LFillPoints[LIndex].x < LWestern then
          LWestern := 0
        else
          Inc(LWestern);
        LFillPoints[LIndex].WesternIndex := LWestern;
        Inc(j);

        // do twice ...
        // X2
        SetLength(LFillPoints, Length(LFillPoints) + 1);
        LIndex := High(LFillPoints);

        LFillPoints[LIndex].x   := LPoints[j].x;
        LFillPoints[LIndex].y   := LPoints[j].y;
        LFillPoints[LIndex].lin := LPoints[j].lin;
        LFillPoints[LIndex].grp := LGroupIndex;
        LFillPoints[LIndex].WesternIndex := LWestern;
        Inc(j);
      end;

      if j <> 0 then
      begin
        Inc(LGroupIndex);
      end;
    end;

    //REGION
    // a star when be divided into 3 region with jumps => [2,1,2] will be lik this:
    //        1
    //   22211111222
    //      11111
    //    22     22
    //
    if (inf > 1) and (LastJump <> LJumps[i]) then
    begin
      L := Length(LRegions);
      F := High(LFillPoints)-LJumps[i];
      if L > 0 then
        LRegions[L-1].Y := F-1; //prior end

      SetLength(LRegions, L+1);
      L := High(LRegions);
      LRegions[L].X := F;
      LastJump := LJumps[i];
    end;
  end;
  LRegions[L].Y := High(LFillPoints);
  // lines is sorted by GRP
  //        1
  //   22222222222
  //      33333
  //    44     44
  //


  //sort by sequence of : Jumps, lin            
  PArrayOfStitchLine(LLines) :=  @LFillPoints[0]; 
  Z := 0;
  LastLin := LLines[0].Start.lin;
  for i := 0 to High(LRegions) do
  begin
    LastWestern := 0;//
    LastFX := High(Integer);

    for j := LRegions[i].X div 2   to LRegions[i].Y div 2   do
    begin
      if (LLines[j].Start.X < LastFX) then
      begin
        LastWestern := 0;
      end
      else
      if (LLines[j].Start.X > LastFX) then
      begin
        inc(LastWestern);
      end;
      LastFX := LLines[j].Start.X;
      
      LLines[j].Start.WesternIndex := LastWestern;
      LLines[j].Finish.WesternIndex := LastWestern;
    end;

    for j := LRegions[i].X   to LRegions[i].Y   do
    begin

      LFillPoints[j].IslandCount := LJumps[ LFillPoints[j].grp ];

      LFillPoints[j].NorthIndex := i; //this is also okay!
    end;
    //QuickSort(LFillPoints, LRegions[i].X, LRegions[i].Y, Compare_LinesInARegion);
    QuickSortLine( LLines, LRegions[i].X div 2, LRegions[i].Y div 2, Compare_LinesInARegion2);
    //QSORT(LLines, LRegions[i].X div 2, LRegions[i].Y div 2, cmp_LinesInARegion );
    // lines sorted by REGION, LIN, GRP

    
    {for j := LRegions[i].X div 2  to LRegions[i].Y div 2  do
    begin
      if LFillPoints[j].lin <> LastJump then
      begin
        LastJump := LFillPoints[j].lin;
        Inc(z);
      end;
      LFillPoints[j].region := z;
    end;}

    //Write the region signal

    for j := LRegions[i].X div 2   to LRegions[i].Y div 2   do
    begin
      if (LLines[j].Start.lin <> LastLin) then
      begin
        LastLin := LLines[j].Start.lin;

        if (j > 0) then
        begin
          Inc(z);
        end;
      end;
      LLines[j].Start.region := z;
      LLines[j].Finish.region := z;


    end;


  end;

  PArrayOfStitchLine(LLines) := nil;
  //SetLength(AStitchForm.Stitchs^, Length(LFillPoints) );
  //Move(LFillPoints[0], AStitchForm.Stitchs^[0], SizeOf(TStitchPoint) * High(LFillPoints));
  AStitchForm.Stitchs^ := LFillPoints;
    
  //if Assigned(ABitmap32) then
    //DrawFill();


  //SetLength(LPoints, 0);
  //LPoints := nil;
end;

end.
