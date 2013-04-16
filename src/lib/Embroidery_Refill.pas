unit Embroidery_Refill;

interface
uses
  SysUtils, Classes, GR32,
  Embroidery_Items, Thred_Types, Thred_Constants, Thred_Defaults, gmShape;

{.$DEFINE THRED_BITS}

type
  TVerboseProc = procedure (const VerboseMsg : string) of object;

  TThred = class(TObject)
  private
    FVerboseProc: TVerboseProc;
    FIni: TThredIniFile;
    FStitchForm: TEmbroideryItem;
    //lconflt : TArrayOfFloatPoint;//TArrayOfPoint;
    lconflt : TArrayOfStitchPoint;
    //map     : array [0..MAPLEN-1] of TColor32; // bitmap
    //lins    : TArrayOfTSMALPNTL;               // pairs of fill line endpoints
    //seq     : TArrayOfPSMALPNTL;               // sorted pointers to lins
    {$IFDEF THRED_BITS}
    map     : array [0..MAPLEN-1] of Cardinal; // bitmap
    {$ELSE}
    map     : array [0..LASTBIT] of ByteBool; // bitmap
    {$ENDIF}
    //lins    : TArrayOfStitchPoint ;               // pairs of fill line endpoints
    //seq     : TArrayOfPStitchPoint;               // sorted pointers to lins
    //bseq    : array [0..BSEQLEN-1] of TBSEQPNT;// reverse sequence for polygon fills
    //oseq    : array [0..OSEQLEN-1] of TFLPNT;  // temporary storage for sequencing
    //rgns    : array of TRGN;                   // a list of regions for sequencing
    srgns   : array of Cardinal;               // an array of subregion starts
    //grinds  : array of Cardinal;               // array of group indices for sequencing
    visit   : array of Byte;                   // visited character map for sequencing
    //pmap    : array of TRCON;                  // path map for sequencing
    //mpath   : array of TFSEQ;	                 // path of sequenced regions
    sids    : Cardinal;
    //tmpath  : TArrayOfTRGSEQ; //array of TRGSEQ;                 // temporary path connections
    dunpnts : array [0..3] of TFLPNT;          // corners of last region sequenced
    //rgpth   : PRGSEQArray;                     // length of the path to the region
    rgpth   : TArrayOfTRGSEQ; //array of TRGSEQ;//x2nie          //path to a region
    //minds   : array of Cardinal;
    //seqmap  : array of Cardinal;               // a bitmap of sequenced lines
    {$IFDEF THRED_BITS}
    seqmap  : array of Cardinal;               // a bitmap of sequenced lines
    {$ELSE}
    seqmap  : array of ByteBool;               // a bitmap of sequenced lines
    {$ENDIF}
    //grindpnt: Cardinal;                        // number of group indices
    //spnt    : Integer;
    lpnt    : Cardinal;
    //rgcnt   : LongInt;                        // number of regions to be sequenced
    nxtgrp  : Cardinal;                        // group that connects to the next region
    rgclos  : Double;                          // region close enough threshold for sequencing
    //mpathi  : Cardinal;                        // index to path of sequenced regions
    dunrgn  : Cardinal;                        // last region sequenced
    vispnt  : Cardinal;                        // next unvisited region for sequencing
    pthlen  : Cardinal;                        // length of the path to the region
    //cpnt    : Cardinal;                        // number of entries map for sequencing
    mpath0  : Cardinal;                        // point to the next path element for vertical fill sequencint
    lastgrp : Cardinal;                        // group of the last line written in the previous region;
    //opnt    : Cardinal;                        // output pointer for sequencing
    seqlin  : PStitchPoint;                       // line for vertical/horizontal/angle fills
    //seqlin  : TArrayOfTSMALPNTL;//x2nie        // line for vertical/horizontal/angle fills
    //seqpnt  : Cardinal;					//sequencing pointer
    s_Pnt   : TFloatPoint;

    durpnt  : PRGN;
    procedure brkdun(strt, fin: Cardinal);
    procedure brkseq(strt, fin: Cardinal);
    procedure dunseq(strt, fin: Cardinal);
    procedure durgn(pthi: Cardinal);
    procedure duseq(strt, fin: Cardinal);
    procedure duseq1;
    procedure duseq2(ind: Cardinal);
    function isclos(pnt0, pnt1: PStitchPoint): Boolean;
    function lnclos(gpA, lnA,   gpB, lnB: Cardinal): Boolean;
    procedure movseq(ind: Cardinal);
    function notdun(lvl: Cardinal): Boolean;
    function nxt(ind: cardinal): cardinal;
    procedure nxtrgn;
    procedure nxtseq(pthi: Cardinal);
    function prv(ind: cardinal): cardinal;
    function regclos(rgA, rgB: Cardinal): Word;
    function reglen(reg: Cardinal): Double;
    procedure rspnt(fx, fy: Single);
    function rstMap(bPnt: Cardinal): Cardinal;
    function setMap(bPnt: Cardinal): Cardinal;
    function setseq(bpnt: Cardinal): Boolean;
    function unvis: Boolean;
    {$IFNDEF THRED_BITS}
    function bts(bit: Cardinal): Boolean;
    {$ENDIF}
    //procedure ReCalcGrinds;
    function toglMap(bPnt: Cardinal): Boolean;
    function chkmax(arg0,arg1: Cardinal): Boolean;
  protected

  public

  private
  
    bars : array of Double;
    barZ : Cardinal; // length of bars

    barcount : Cardinal;

    lins    : TArrayOfStitchPoint ;               // pairs of fill line endpoints
    spnt    : Integer;

    seq     : TArrayOfPStitchPoint;               // sorted pointers to lins
    //bseq    : array [0..BSEQLEN-1] of TBSEQPNT;// reverse sequence for polygon fills
    bseq    : TArrayOfStitchPoint ;               // pairs of fill line endpoints
    opnt    : Cardinal;                           // output pointer for sequencing

    //oseq    : array [0..OSEQLEN-1] of TFLPNT;   // temporary storage for sequencing
    oseq    : TArrayOfStitchPoint;                // temporary storage for sequencing
    seqpnt  : Cardinal;					//sequencing pointer

    pmap    : array of TRCON;                  // path map for sequencing
    cpnt    : Cardinal;                        // number of entries map for sequencing

    rgns    : array of TRGN;                   // a list of regions for sequencing
    rgcnt   : LongInt;                        // number of regions to be sequenced

    mpath   : array of TFSEQ;	                 // path of sequenced regions
    mpathi  : Cardinal;                        // index to path of sequenced regions

    tmpath  : TArrayOfTRGSEQ; //array of TRGSEQ;                 // temporary path connections

    minds   : array of Cardinal;               //pointers to sets of adjacent regions

    grinds  : array of Cardinal;               // array of group indices for sequencing
    grindpnt: Cardinal;                        // number of group indices

  public
    constructor Create;
    destructor Destroy; override;

    function publins : PArrayOfStitchPoint;
    function pubbseq : PArrayOfStitchPoint;
    function pubOseq : PArrayOfStitchPoint;
    procedure fnvrt(AStitchForm: TEmbroideryItem);
    procedure lcon(AStitchForm: TEmbroideryItem);
    procedure bakseq();
    procedure ResetVars(Sender: TObject);
    
    property VerboseProc : TVerboseProc read FVerboseProc write FVerboseProc;
    property Ini : TThredIniFile read FIni write FIni;
  published

  end;


//procedure lcon(AStitchForm: TEmbroideryItem; AVerboseProc: TVerboseProc);
 
const
  VERTICES = 10;
  c : array[0..VERTICES-1] of TColor32 = (clYellow32, clLime32, clAqua32, clDodgerBlue32, clBlueViolet32, clFuchsia32, clred32,
      clGray32, clWhite32, clOrange32);
  TRA = clTrWhite32;

implementation


uses
  //SysUtils,
  {$IFDEF THRED_BITS}Thred_Bits, {$ENDIF}

   Math;
//-- Point Quick Sort Algorithm ------------------------------------------------

// Adapted from the algorithm in this topic:
// http://blog.csdn.net/stevenldj/article/details/7170303

type
  TPointSortCompare = function (Item1, Item2: PStitchPoint): Integer;
  TStitchCompare = function (Item1, Item2: TStitchPoint): Integer;
  TFloatPointCompare = function (Item1, Item2: TFloatPoint): Integer;
  
procedure QuickSortS(var APoints: TArrayOfStitchPoint; L, R: Integer;
  SCompare: TStitchCompare);
var
  I, J : Integer;
  P, T : TStitchPoint;
begin
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
      QuickSortS(APoints, L, J, SCompare);

    L := I;
    
  until I >= R;
end;

procedure QuickSortSP(var APoints: TArrayOfPStitchPoint; L, R: Integer;
  SCompare: TPointSortCompare);
var
  I, J : Integer;
  P, T : PStitchPoint;
begin
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
      QuickSortSP(APoints, L, J, SCompare);

    L := I;
    
  until I >= R;
end;
procedure PointSortSP(var APoints: TArrayOfPStitchPoint; L, R: Integer;
  ACompare: TPointSortCompare); 
var
  LCount : Integer;
begin
  LCount := Length(APoints);

  if LCount > 1 then
  begin
    // calling Compare() to sort points
    QuickSortSP(APoints, L, R, ACompare);
  end
end;


procedure QuickSortF(var APoints: TArrayOfFloatPoint; L, R: Integer;
  SCompare: TFloatPointCompare);
var
  I, J : Integer;
  P, T : TFloatPoint;
begin
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
      QuickSortF(APoints, L, J, SCompare);

    L := I;
    
  until I >= R;
end;
procedure PointSortF(var APoints: TArrayOfFloatPoint; L, R: Integer;
  ACompare: TFloatPointCompare);
var
  LCount : Integer;
begin
  LCount := Length(APoints);

  if LCount > 1 then
  begin
    // calling Compare() to sort points  
    QuickSortF(APoints, L, R, ACompare);
  end
end;


function comp(pnt0, pnt1: TStitchPoint): Integer;
begin
  if pnt1.Y < pnt0.Y then
  begin
    Result := 1;  // old code in thred
    //Result := -1;
    Exit;
  end;

  if pnt1.Y > pnt0.Y then
  begin
    Result := -1;  // old code in thred
    //Result := 1;
    Exit;
  end;

  if pnt1.X < pnt0.X then
  begin
    Result := 1;
    Exit;
  end;

  if pnt1.X > pnt0.X then
  begin
    Result := -1;
    Exit;
  end;

  if pnt1.lin < pnt0.lin then
  begin
    Result := 1;
    Exit;
  end;

  if pnt1.lin > pnt0.lin then
  begin
    Result := -1;
    Exit;
  end;
  
  Result := 0;
end;

function compF(pnt0, pnt1: TFloatPoint): Integer;
begin
  if pnt1.Y < pnt0.Y then
  begin
    Result := 1;  // old code in thred
    //Result := -1;
    Exit;
  end;

  if pnt1.Y > pnt0.Y then
  begin
    Result := -1;  // old code in thred
    //Result := 1;
    Exit;
  end;

  if pnt1.X < pnt0.X then
  begin
    Result := 1;
    Exit;
  end;

  if pnt1.X > pnt0.X then
  begin
    Result := -1;
    Exit;
  end;

  Result := 0;
end;

function sqcomp(A,B: PStitchPoint): Integer;
var
  pnt0: TStitchPoint ;
  pnt1: TStitchPoint ;
begin
  pnt0:=A^;
  pnt1:=B^;
  Result := 0;
  
  if pnt0.lin = pnt1.lin then
  begin
    if pnt0.grp = pnt1.grp then
    begin
      if pnt0.Y = pnt1.Y then
      begin
        Exit;
      end
      else
      begin
        if pnt0.Y > pnt1.Y then
        begin
          Result := 1;
        end
        else
        begin
          Result := -1;
        end;
      end;
    end
    else
    begin
      if pnt0.grp > pnt1.grp then
      begin
        Result := 1;
      end
      else                
      begin
        Result := -1;
      end;
    end;
  end
  else
  begin
    if pnt0.lin > pnt1.lin then
    begin
      Result := 1;
    end
    else
    begin
      Result := -1;
    end;
  end;
end;

function ProjV(AX: Double; pnt0, pnt1: TFloatPoint;
  out AProjPoint: TFloatPoint): Boolean;
var
  dx, LSlope,tDub    : Double;
begin
  Result := False;

  AProjPoint.X := AX;
  dx           := pnt1.X - pnt0.X;

  if dx <> 0 then
  begin
    LSlope       := (pnt1.Y - pnt0.Y) / dx;
    AProjPoint.Y := (AX - pnt0.X) * LSlope + pnt0.Y ;

    if pnt0.x>pnt1.x then begin
			tdub:=pnt0.x;
			pnt0.x:=pnt1.x;
			pnt1.x:=tdub;
		end;
		if (AX<pnt0.x) or (AX>pnt1.x) then
			Result := False
		else
			Result := True;
    {LLeft  := APoint1.X;
    LRight := APoint2.X;

    if LLeft > LRight then
    begin
      LTemp  := LLeft;
      LLeft  := LRight;
      LRight := LTemp;
    end;

    if ( (AX < LLeft) or (AX > LRight) ) //or ( (LLeft = LRight) and (APoint1.Y = APoint2.Y) ) 
    then
      Result := False
    else
      Result := True;}
  end

end;

{ TLCON }

constructor TThred.Create;
begin
  FillChar(map, LASTBIT+1, 0);
               //
end;


    {$IFNDEF THRED_BITS}
    function TThred.bts(bit: Cardinal): Boolean;
    begin
      Result        := map[bit];
      map[bit] := True;
    end;
    {$ENDIF}
    
// form.cpp (Linux version), #3283
function TThred.setseq(bpnt: Cardinal): Boolean;
begin
  {$IFDEF THRED_BITS}
  if bts(seqmap, bpnt) then
  begin
    Result := False; //0;
  end
  else
  begin
    Result := True; //1;
  end;
  {$ELSE}
  Result := seqmap[bpnt];
  seqmap[bpnt] := True;
  {$ENDIF}
end;

// thred.cpp (Linux version), #1909
function TThred.setMap(bPnt: Cardinal): Cardinal;
begin
  //if bts(LBits, bPnt) then
  {$IFNDEF THRED_BITS}
  if bts(bPnt) then
  {$ELSE}
  if bts(map, bPnt) then
  {$ENDIF}
  begin
    Result := $FFFFFFFF;
  end
  else
  begin
    Result := 0;
  end;
end;

// thred.cpp (Linux version), #1917
function TThred.rstMap(bPnt: Cardinal): Cardinal;
  {$IFNDEF THRED_BITS}
  function btr(bit: Cardinal): Boolean;
  begin
    Result   := map[bit];
    map[bit] := False;
  end;
  {$ENDIF}
begin
  {$IFNDEF THRED_BITS}
  if btr(bPnt) then
  {$ELSE}
  if btr(map, bPnt) then
  {$ENDIF}
  begin
    Result := $FFFFFFFF;
  end
  else
  begin
    Result := 0;
  end;
end;


function TThred.toglMap(bPnt: Cardinal): Boolean;
begin
  {$IFNDEF THRED_BITS}
  Result   := map[bPnt];
  map[bPnt] := not map[bPnt];
  {$ELSE}
  if btc(map, bPnt) then
  begin
    Result := True;// $FFFFFFFF;
  end
  else
  begin
    Result := False;// 0;
  end;
  {$ENDIF}
end;



// from.cpp of thred #3372
function TThred.regclos(rgA, rgB: Cardinal): Word;
var
  pntAstart: PStitchPoint;
  pntAend: PStitchPoint;
  pntBstart: PStitchPoint;
  pntBend: PStitchPoint;

  grpAstart: Integer;//Cardinal;
  grpAend: Integer;//Cardinal;
  grpBstart: Integer;//Cardinal;
  grpBend: Integer;//Cardinal;
  grps : Cardinal;
  grpe : Cardinal;
  lins : Cardinal;
  line : Cardinal;
  prlin: Cardinal;   //prior line
  polin: Cardinal;   //post  line
begin

//PREPARE FOR COLLISION DETECTION
    pntAstart := @seq[rgns[rgA].StartLine]^;
    pntBstart := @seq[rgns[rgB].StartLine]^;
    grpAstart := pntAstart^.grp;
    grpBstart := pntBstart^.grp;

//1. DETECT WITH B.START.GRP    
    if grpAstart <= grpBstart then  // normally, A=left  B=right
    begin                   
      grps  := grpBstart;       // we use the B.startline.grp
      lins  := pntBstart^.lin;  // use rgnB.startLine.lin
      prlin := pntAstart^.lin;
    end
    else
    begin
      grps  := grpAstart;
      lins  := pntAstart^.lin;
      prlin := pntBstart^.lin;
    end;
                               //lins[Right-1]    // lins[Right]
    if (grps <> 0) and lnclos(grps - 1, prlin, grps, lins) then
    begin
      nxtgrp := grps;
      Result := 1;
      {
      A=left  B=right:
      Comparing with start line of B will resulting the "nxtgrp = B.startline.grp" ,

      B=left  A=right:
      comparing with start line of A will resulting the "nxtgrp = A.startline.grp"
      }
      Exit;
    end



    //Nothing close enough?
    else
//2. DETECT WITH A.END.GRP    
    begin
      pntAend := @seq[rgns[rgA].EndLine]^;
      pntBend := @seq[rgns[rgB].EndLine]^;
      grpBend := pntBend^.grp;
      grpAend := pntAend^.grp;


      if grpAend < grpBend then   //normally, A=left  B=right
      begin
        grpe  := grpAend;         //we use A.endline.grp
        line  := pntAend^.lin;
        polin := pntBend^.lin;
      end
      else
      begin
        grpe  := grpBend;
        line  := pntBend^.lin;
        polin := pntAend^.lin;
      end;
          //    lins[Left],   lins[Left + 1]
      if lnclos(grpe, line,   grpe + 1, polin) then
      begin
        nxtgrp := grpe;
        Result := 1;
        {
        A=left  B=right:
        Comparing with end line of A will resulting the "nxtgrp = A.endLine.grp" ,

        B=left  A=right:
        comparing with end line of B will resulting the "nxtgrp = B.endLine.grp"
        }
        Exit;
      end;
    end;


//3. MEET IN BOTH START ?
    if Abs(grpAstart - grpBstart) < 2 then    //distance = [0 .. 1] ?
    begin
      if isclos(pntAstart, pntBstart) then
      begin
        nxtgrp := grpAstart;
        Result := 1;
        Exit;
      end;
    end;

//4. DETECT A.start ~ B.end
    if Abs(grpAstart - grpBend) < 2 then    //distance = [0 .. 1] ?
    begin
      if isclos( pntAstart, pntBend ) then
      begin
        nxtgrp := grpAstart;
        Result := 1;
        Exit;
      end;
    end;

//5. DETECT A.end ~ B.start
    if Abs(grpAend - grpBstart) < 2 then    //distance = [0 .. 1] ?
    begin
      if isclos( pntAend, pntBstart ) then
      begin
        nxtgrp := grpAend;
        Result := 1;
        Exit;
      end;
    end;

//6. MEET IN BOTH END ?
    if Abs(grpAend - grpBend) < 2 then    //distance = [0 .. 1] ?
    begin
      if isclos( pntAend, pntBend ) then
      begin
        nxtgrp := grpAend;
        Result := 1;
        Exit;
      end;
    end;

    Result := 0;
end;

// from.cpp of thred #3333
function TThred.lnclos(gpA, lnA,   gpB, lnB: Cardinal): Boolean;  //this proc used only twice per comparison.
var
  indA, indB, cntA, cntB: Cardinal;
  pntA, pntB            : TArrayOfStitchPoint;//PSMALPNTL;
begin
//DONT CONNECT TO THE LAST POINT
    if gpB > (grindpnt - 2) then
    begin
      Result := False;
      Exit;
    end;

//DONT CONNECT TO THE FIRST POINT    
    if gpA = 0 then
    begin
      Result := False;
      Exit;
    end;

//FIND IND1 & IND0 FOR FURTHER COMPARISON USING "ISCLOS()" FUNC.

  cntA := ( grinds[gpA + 1] - grinds[gpA] ) div 2; //shr 1;
  indA := 0;

  //PREPARE A
  pntA := @lins[ grinds[gpA] ];
  while ( (cntA <> 0) and (pntA[indA].lin <> lnA) ) do
  begin
    cntA := cntA - 1;
    indA := indA + 2;
  end;
  

  if cntA > 0 then
  begin
    cntB := ( grinds[gpB + 1] - grinds[gpB] ) div 2; //shr 1;
    indB := 0;

    //PREPARE B    
    pntB := @lins[ grinds[gpB] ];
    while ( (cntB <> 0) and (pntB[indB].lin <> lnB) ) do
    begin
      cntB := cntB - 1;
      indB := indB + 2;
    end;


    if cntB > 0 then
    begin
      if isclos(@pntA[indA], @pntB[indB]) then
      begin
        Result := True;
        Exit;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;
  end;

  Result := False;

end;

function TThred.isclos(pnt0, pnt1: PStitchPoint): Boolean;
var
  loA, hiA, loB, hiB: Single;
  pnA, pnB: TArrayOfStitchPoint;
begin
  pnA := @pnt0^;
  pnB := @pnt1^;
//we know, that pointA.x is just beside pointB.x
//se, we only want to test the Y axis.
//Target : Y must be overlaped

  loA := pnA[0].y - rgclos; //curent +up
  hiA := pnA[1].y + rgclos; //next   +down

  loB := pnB[0].y - rgclos; //current +up
  hiB := pnB[1].y + rgclos; //next    +down

//OKAY, HERE WE GO:
//WE ONLY INTEREST WHEN A IS NEAR B (horizontally, detecting by the Y) :

  //A.y2 < B.y1 ?     not close!           aaa|
  if hiA < loB then   //too far detected.      |bbb
  begin               //                       |bbb
    Result := False;
    Exit;
  end;

  //B.y2 < A.y1  ?    not close!                |bbb
  if hiB < loA then   //too far detected.   aaa|
  begin               //                    aaa|
    Result := False;
    Exit;
  end;


  //close := (A.y2 >= B.y1) AND (B.y2 >= A.y1)

  //sample of collisions (close=true):
  //                                                                     |bbbbbb
  //       aaaa|                 |bbb.y1                              aaa|bbb
  //       aaaa|bbbb       y1.aaa|bbb.y2   <--- see this collision   aaaa|bb
  //           |bbbb       y2.aaa|                                  aaaaa|b
  //                                                              aaaaaaa|
  Result := True;
end;

function TThred.unvis: Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to (rgcnt - 1) do
  begin
    vispnt := i;
    if visit[i] = 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
  inc(vispnt);
end;
function TThred.reglen(reg: Cardinal): Double;
var
  len     : Double;
  minlen  : Double;
  ind     : Cardinal;
  ine1    : Cardinal;
  pnts    : array [0..3] of PStitchPoint;
  LPoints : TArrayOfStitchPoint;
begin
  minlen := 1e99;
  {  pnts[0] := seq[ rgns[reg].StartLine ];
  pnts[1] := @PArrayOfTSMALPNTL(seq[ rgns[reg].StartLine ])^[1];
  pnts[2] := seq[ rgns[reg].EndLine ];
  pnts[3] := @PArrayOfTSMALPNTL(seq[ rgns[reg].EndLine ])^[1];}

  //PArrayOfTSMALPNTL(LPoints) := @seq[ rgns[reg].StartLine ]^;
  LPoints := @seq[ rgns[reg].StartLine ]^;
  pnts[0] := @LPoints[0];
  pnts[1] := @LPoints[1];

  //PArrayOfTSMALPNTL(LPoints) := @seq[ rgns[reg].EndLine ]^;
  LPoints := @seq[ rgns[reg].EndLine ]^;
  pnts[2] := @LPoints[0];
  pnts[3] := @LPoints[1];

  //PArrayOfTSMALPNTL(LPoints) := nil;
  LPoints := nil;


  for ind := 0 to 3 do
  begin
    for ine1 := 0 to 3 do   
    begin            
      len := Hypot(dunpnts[ind].X - pnts[ine1]^.x, dunpnts[ind].Y - pnts[ine1]^.y);

      if len < minlen then
      begin
        minlen := len;
      end;
    end;
  end;

  Result := minlen;
  LPoints := nil;
end;

{.$DEFINE DECTEST}    
function TThred.notdun(lvl: Cardinal): Boolean;
var
  ind  : Cardinal;
  tpiv : Integer;
  pivot: Integer;
begin


  pivot := lvl - 1;
  tpiv := pivot;

  rgpth :=  @tmpath[mpathi];
  //SetLength(rgpth, Length(tmpath) -mpathi +1);
  //Move(tmpath[mpathi], rgpth[0], Length(rgpth) * SizeOf(TRGSEQ) );
  rgpth[0].pcon := minds[dunrgn]; 
  rgpth[0].cnt  := minds[dunrgn + 1] - rgpth[0].pcon;

  for ind := 1 to (lvl - 1) do
  begin
    rgpth[ind].pcon := minds[pmap[rgpth[ind - 1].pcon].vrt];
    rgpth[ind].cnt  := minds[pmap[rgpth[ind - 1].pcon].vrt + 1] - rgpth[ind].pcon;
  end;

  while (visit[pmap[rgpth[pivot].pcon].vrt] <> 0) and (pivot >= 0) do
  begin
    {$IFDEF DECTEST}
    if (rgpth[pivot].cnt-1) > 0 then
    {$ELSE}
    Dec(rgpth[pivot].cnt);
    if (rgpth[pivot].cnt) > 0 then
    {$ENDIF}
    begin
      rgpth[pivot].pcon := rgpth[pivot].pcon + 1;
    end
    else
    begin
      tpiv := pivot;

      repeat  //do .....

        Dec(tpiv);
        if tpiv < 0 then 
        begin
          Result := True;
          Exit;
        end;

        rgpth[tpiv].cnt  := rgpth[tpiv].cnt - 1;
        rgpth[tpiv].pcon := rgpth[tpiv].pcon + 1;
      until {not} (rgpth[tpiv].cnt <> 0);
      //....  while(!rgpth[tpiv].cnt);  loop when .cnt = 0

      if tpiv < 0 then
      begin
        Result := True;
        Exit;
      end;

      Inc(tpiv);

      while tpiv <= pivot do
      begin
        if tpiv <> 0 then
        begin
          rgpth[tpiv].pcon := minds[pmap[rgpth[tpiv - 1].pcon].vrt];
          rgpth[tpiv].cnt  := minds[pmap[rgpth[tpiv - 1].pcon].vrt + 1] - rgpth[tpiv].pcon;
        end
        else
        begin
          {$IFDEF DECTEST}
          if (rgpth[0].cnt-1) <> 0 then
          {$ELSE}
          Dec(rgpth[0].cnt);
          if (rgpth[0].cnt) <> 0 then
          {$ENDIF}
          begin
            rgpth[0].pcon := rgpth[0].pcon + 1;
          end
          else
          begin
            Result := True;
            Exit;
          end;
        end;

        Inc(tpiv);
      end;
    end;
  end;

  Result := False;
end;


procedure TThred.nxtrgn;
var
  ind,indz   : Cardinal;
  nureg : Cardinal;
  //tpnt  : Cardinal;
  tpnt : TArrayOfStitchPoint;
  len   : Double;
  minlen: Double;
begin
  minlen := 1e99;
  len := 1e99;
  pthlen := 1;

  while notdun(pthlen) do
  begin
    Inc(pthlen);

    if (pthlen > 8) then //AVOID ENDLESS LOOP?
    begin
      //tpnt=&*seq[rgns[dunrgn].strt];
      tpnt := @seq[rgns[dunrgn].StartLine]^;
      dunpnts[0].X := tpnt[0].x;
      dunpnts[0].Y := tpnt[0].y;
      dunpnts[1].X := tpnt[1].x;
      dunpnts[1].Y := tpnt[1].y;

      //tpnt=&*seq[rgns[dunrgn].end];
      tpnt := @seq[rgns[dunrgn].EndLine]^;
      dunpnts[2].X := tpnt[0].x;
      dunpnts[2].Y := tpnt[0].y;
      dunpnts[3].X := tpnt[1].x;
      dunpnts[3].Y := tpnt[1].y;

      nureg := 0;

      for ind := 0 to (rgcnt - 1) do
      begin
        if visit[ind] = 0 then
        begin
          len := reglen(ind);

          if len < minlen then
          begin
            minlen := len;
            nureg  := ind;
          end;
        end;
      end;

      tmpath[mpathi].skp := 1;

      for ind := 0 to (cpnt - 1) do
      begin
        if pmap[ind].vrt = nureg then
        begin
          tmpath[mpathi].pcon := ind;
          Inc(mpathi);

          visit[nureg] := 1;
          dunrgn       := nureg;
          
          Exit;
        end;
      end;

      tmpath[mpathi].cnt  := vispnt;
      tmpath[mpathi].pcon := $FFFFFFFF;
      Inc(mpathi);
      
      visit[vispnt]       := 1;
      dunrgn              := vispnt;

      Exit;
    end;
  end;

  indz := 0;
  for ind := 0 to (pthlen - 1) do
  begin
    tmpath[mpathi].skp  := 0;
    tmpath[mpathi].pcon := rgpth[ind].pcon;
    Inc(mpathi);

    visit[pmap[rgpth[ind].pcon].vrt] := 1;
    indz := ind;
    inc(indz);
  end;

  dunrgn := pmap[rgpth[indz - 1].pcon].vrt;
  //dunrgn := pmap[rgpth[ind-1].pcon].vrt;

end;

procedure TThred.nxtseq(pthi: Cardinal);
var
  nxtvrt: Cardinal;
  ind   : Cardinal;                              
begin
  ind    := minds[mpath[pthi].vrt];
  nxtvrt := mpath[pthi + 1].vrt;

  while (ind < minds[mpath[pthi].vrt + 1]) and (pmap[ind].vrt <> nxtvrt) do
  begin
    Inc(ind);
  end;

  mpath[mpath0].grpn := pmap[ind].grpn;
  Inc(mpath0);
end;

function TThred.nxt(ind: cardinal): cardinal;
begin
	Inc(ind);
	if ind > sids-1 then
		ind:=0;
	result := ind;
end;

//unsigned short prv(unsigned ind){
function TThred.prv(ind: cardinal): cardinal;
begin
	if ind <> 0 then
		dec(ind)
	else
		ind:=sids-1;
	result := ind;
end;

procedure TThred.durgn(pthi: Cardinal);
var
  dun, mindif, ind, fdif, bdif: Cardinal;
  gdif : LongInt;
  seqs, seqe                        : Cardinal;
  grpn, grps, grpe                  : Cardinal;
  rgind                             : Cardinal;
  seql, seqn                        : Cardinal;
  len, minlen                       : Double;
  //pnts, pnte                        : PStitchPoint;
  pnts, pnte                        : TStitchPoint;
  bpnt : ^TBSEQPNT;
  
begin
try
  rgind := mpath[pthi].vrt;
  durpnt := @rgns[rgind];
  grpn  := mpath[pthi].grpn;
  //seqs  := rgns[rgind].StartLine;
  //seqe  := rgns[rgind].EndLine;
  seqs  := durpnt^.StartLine;
  seqe  := durpnt^.EndLine;



  

  if (mpath[pthi].skp <> 0) or (rstMap(BRKFIX) <> 0) then begin

		if bseq[opnt-1].attr <> SEQBOT then begin
      VerboseProc('1223');
			rspnt(bseq[opnt-2].x,bseq[opnt-2].y);
    end;
		pnts:=seq[rgind]^;
		dun :=seq[seqs]^.lin;
		bpnt:=@bseq[opnt-1];
		minlen:=1e99;
		for ind :=0 to sids - 1 do begin

			len:=hypot(bpnt^.x-lconflt[ind].x,bpnt^.y-lconflt[ind].y);
			if len<minlen then begin

				minlen:=len;
				mindif:=ind;
			end;
		end;
		if(minlen <> 0) then begin
      VerboseProc('1240');
			rspnt(lconflt[mindif].x,lconflt[mindif].y);
    end;
		fdif:=(sids+dun-mindif) mod sids;
		bdif:=(sids-dun+mindif) mod sids;
		if(fdif<bdif) then begin

			ind:=nxt(mindif);
			while(ind<>dun) do begin
        VerboseProc('1249');
				rspnt(lconflt[ind].x,lconflt[ind].y);
				ind:=nxt(ind);
			end;
      VerboseProc('1253');
			rspnt(lconflt[ind].x,lconflt[ind].y);
		end
		else begin

			ind:=prv(mindif);
			while ind<>dun  do begin
              VerboseProc('1260');
				rspnt(lconflt[ind].x,lconflt[ind].y);
				ind:=prv(ind);
			end;
      VerboseProc('1264');
			rspnt(lconflt[ind].x,lconflt[ind].y);
		end;
	end;
  {for i :=  to durpnt^.EndLine  do
  begin
    FVerboseProc(Format('%d =lin:%d grp:%d', [i, seq[i]^.lin, seq[i]^.grp ] ))
  end;}

  FVerboseProc(Format('durgn pthi:%d  rgind:%d  %d ~ %d', [pthi, rgind, seq[durpnt^.StartLine]^.grp, seq[durpnt^.EndLine]^.grp ] ));


  if visit[rgind] <> 0 then
  begin
    dun := 1;
  end
  else
  begin
    dun := 0;
    visit[rgind] := visit[rgind] + 1;
  end;
  
  //pnts=&*seq[durpnt->strt];
	//pnte=&*seq[durpnt->end];
  //pnts := @seq[durpnt^.StartLine]^;
  //pnte := @seq[durpnt^.EndLine]^;
  pnts := seq[durpnt^.StartLine]^;
  pnte := seq[durpnt^.EndLine]^;
  //grps := seq[ rgns[rgind].StartLine ]^.grp;
  //grpe := seq[ rgns[rgind].EndLine ]^.grp;
  grps := pnts.grp;
  grpe := pnte.grp;

  if grpe <> grps then
  begin
    seql := Trunc( (lastgrp - grps) / (grpe - grps) * (seqe - seqs) + seqs );
  end
  else
  begin
    seql := 0;
  end;

  if seql > lpnt then
  begin
    seql := 0;
  end;

  len := (grpe - grps) * (seqe - seqs);

  if len <> 0 then
  begin
    seqn := Trunc( (grpn - grps) / len + seqs );
  end
  else
  begin
    seqn := seqe;
  end;

  if seql < seqs then
  begin
    seql := seqs;
  end;

  if seql > seqe then
  begin
    seql := seqe;
  end;

  if seqn < seqs then
  begin
    seqn := seqs;
  end;

  if seqn > seqe then
  begin
    seqn := seqe;
  end;

  //FVerboseProc(Format('s:%d ~ e:%d  l=%d n=%d', [seqs, seqe,   seql,  seqn] ));
  //FVerboseProc(Format('s:%d ~ e:%d  l=%d n=%d', [seqs, seqe,   seq[seql + 1]^.grp,  seq[seqn + 1]^.grp] ));
  FVerboseProc(Format('@l=%d n=%d (%d %d)', [seqs, seqe,   seq[seql]^.grp,  seq[seqn]^.grp] ));
  
  if seq[seql]^.grp <> lastgrp then
  begin
    if (seql < seqe) and (seq[seql + 1]^.grp = lastgrp) then
    begin
      Inc(seql);
    end
    else
    begin
      if (seql > seqs) and (seq[seql - 1]^.grp = lastgrp) then
      begin
        Dec(seql);
      end
      else
      begin
        mindif := $FFFFFFFF;

        for ind := seqs to seqe do
        begin
          //gdif := Abs(Integer(seq[ind]^.grp - lastgrp));  //ERROR: integer overflow, sometime
          gdif := seq[ind]^.grp - lastgrp;
          //FVerboseProc(Format('gdif:%d grp:%d L:%d',[gdif,seq[ind]^.grp, lastgrp]));

          if gdif < 0 then
            gdif := gdif * -1;

          if gdif < mindif then
          begin
            mindif := gdif;
            seql   := ind;
          end;
        end;
      end;
    end;
  end;

  if seq[seqn]^.grp <> grpn then
  begin
    if (seqn < seqe) and (seq[seqn + 1]^.grp = grpn) then
    begin
      Inc(seqn);
    end
    else
    begin
      if (seqn > seqs) and (seq[seqn - 1]^.grp = grpn) then
      begin
        Dec(seqn);
      end
      else
      begin
        mindif := $FFFFFFFF;

        for ind := seqs to seqe do
        begin
          //gdif := Abs( seq[ind]^.grp - grpn );
          gdif := seq[ind]^.grp - grpn;

          //FVerboseProc(Format('gdif:%d grp:%d N:%d',[gdif,seq[ind]^.grp, grpn]));
          
          if gdif < 0 then
            gdif := gdif * -1;

          if gdif < mindif then
          begin
            mindif := gdif;
            seqn   := ind;
          end;
        end;
      end;
    end;
  end;

  FVerboseProc(Format('#d%d l=%d n=%d (%d %d)', [ durpnt^.cntbrk, seqs, seqe,   seq[seql]^.grp,  seq[seqn]^.grp] ));

  //if rgns[rgind].cntbrk <> 0 then
  if durpnt^.cntbrk <> 0 then
  begin
    if dun <> 0 then
    begin
      brkdun(seql, seqn);
    end
    else
    begin
      if lastgrp >= grpe then
      begin
        brkseq(seqe, seqs);

        if ( pthi < (mpathi - 1) ) and (seqe <> seqn) then
        begin
          brkseq(seqs, seqn);
        end;
      end
      else
      begin
        if grps <= grpn then
        begin
          if seql <> seqs then
          begin
            brkseq(seql, seqs);
          end;

          brkseq(seqs, seqe);

          if ( pthi < (mpathi - 1) ) and (seqe <> seqn) then
          begin
            brkseq(seqe, seqn);
          end;
        end
        else
        begin
          if seql <> seqe then
          begin
            brkseq(seql, seqe);
          end;

          brkseq(seqe, seqs);

          if ( pthi < (mpathi - 1) ) and (seqs <> seqn) then
          begin
            brkseq(seqs, seqn);
          end;
        end;
      end;
    end;
  end
  else
  begin
    if dun <> 0 then
    begin
      dunseq(seql, seqn);
    end
    else
    begin
      if lastgrp >= grpe then
      begin
        VerboseProc('1670');
        duseq(seqe, seqs);
        VerboseProc('1672');
        duseq(seqs, seqn);
      end
      else
      begin
        if grps <= grpn then
        begin
          if seql <> seqs then
          begin
            VerboseProc('1681');
            duseq(seql, seqs);
          end;
          VerboseProc('1684');
          duseq(seqs, seqe);

          if ( pthi < (mpathi - 1) ) and (seqe <> seqn) then
          begin
            VerboseProc('1689');
            duseq(seqe, seqn);
          end;
        end
        else
        begin
          if seql <> seqe then
          begin
            VerboseProc('1697');
            duseq(seql, seqe);
          end;
          VerboseProc('1700');
          duseq(seqe, seqs);

          if ( pthi < (mpathi - 1) ) and (seqs <> seqn) then
          begin
            VerboseProc('1705');
            duseq(seqs, seqn);
          end;
        end;
      end;
    end;
  end;
finally
  //bpnt := nil;
  //pnts := nil;
  //pnte := nil;
end;  
end;

procedure TThred.brkdun(strt, fin: Cardinal);
begin
  VerboseProc('brkdun 1518');
  rspnt(seq[strt]^.x, seq[strt]^.y);
  rspnt(seq[fin]^.x, seq[fin]^.y);
  
  //rspnt(lconflt[seq[strt]->lin].x,lconflt[seq[strt]->lin].y);
  VerboseProc('brkdun 1523');
  with FStitchForm.PolyPolygon^[0] do
  rspnt( Points[seq[strt]^.lin].X,
         Points[seq[strt]^.lin].Y);
  setMap(BRKFIX);
end;

procedure TThred.brkseq(strt, fin: Cardinal);
var
  ind : Cardinal;
  bgrp: Cardinal;
begin
  rstMap(SEQDUN);

  if strt > fin then
  begin
    bgrp := seq[strt]^.grp + 1;

    for ind := strt downto fin do
    begin
      Dec(bgrp);

      if seq[ind]^.grp <> bgrp then
      begin
        VerboseProc('brkdun 1547');
        rspnt(seqlin^.x, seqlin^.y);
        seqlin := @seq[ind]^;
        VerboseProc('brkdun 1550');
        rspnt(seqlin^.x, seqlin^.y);
        bgrp := seqlin^.grp;
      end
      else
      begin
        seqlin := @seq[ind]^;
      end;

      if setseq(ind) then
      begin
        if setMap(SEQDUN) = 0 then
        begin
          duseq1();
        end;
      end
      else
      begin
        movseq(ind);
      end;
    end;

    lastgrp := seqlin^.grp;
  end
  else
  begin
    bgrp := seq[strt]^.grp - 1;

    for ind := strt to fin do
    begin
      Inc(bgrp);

      if seq[ind]^.grp <> bgrp then
      begin
        VerboseProc('brkdun 1584');
        rspnt(seqlin^.x, seqlin^.y);
        seqlin := @seq[ind]^;
        VerboseProc('brkdun 1587');
        rspnt(seqlin^.x, seqlin^.y);
        bgrp := seqlin^.grp;
      end
      else
      begin
        seqlin := @seq[ind]^;
      end;

      if setseq(ind) then
      begin
        if setMap(SEQDUN) = 0 then
        begin
          duseq1();
        end;
      end
      else
      begin
        movseq(ind);
      end;
    end;

    lastgrp := seqlin^.grp;
  end;

  if rstMap(SEQDUN) <> 0 then
  begin
    duseq1();
  end;
end;

procedure TThred.dunseq(strt, fin: Cardinal);
var
  lin0, lin1 : TArrayOfStitchPoint;
  ind     : Cardinal;
  dy, miny: Double;
const
  ie : double = 1e16;
begin
  miny := ie;// 1e30;// 1e8;

  for ind := strt to fin do
  begin
    //dy := seq[ind + 1].y - seq[ind].y;
    lin0 := @seq[ind]^;
    dy := lin0[1].y - lin0[0].y;

    if dy < miny then
    begin
      miny := dy;
    end;
  end;

  miny := miny / 2;
  lin0 := @seq[strt]^;
  lin1 := @seq[fin]^;

  //if miny = (1e30 / 2) then
  if miny = (ie / 2) then
  begin
    miny := 0;
  end;

  //rspnt( seq[strt].x, seq[strt].y + miny );
  //rspnt( seq[fin].x, seq[fin].y + miny );
  VerboseProc('1649');
  rspnt( lin0[0].x, lin0[0].y + miny );
  VerboseProc('1651');
  rspnt( lin1[0].x, lin1[0].y + miny );

  lastgrp := lin1[0].grp;
  lin1 := nil;
  lin0 := nil;
end;

procedure TThred.duseq(strt, fin: Cardinal);
var
  ind, topbak: Cardinal;
  indz : Integer;
  //seqlin2    : PSMALPNTL;
  tp : TArrayOfStitchPoint;
begin
  seqlin := nil;
  rstMap(SEQDUN);
  //topbak := seq[strt + 1].lin;
  //topbak := TArrayOfStitchPoint(@seq[strt]^)[1].lin;
  //topbak := TArrayOfStitchPoint(@seq[strt]^)[1].lin;
  tp := @seq[strt]^;
  topbak := tp[1].lin;
try
  if strt > fin then
  begin
    indz := strt;
    for ind := strt downto fin do
    begin
      if setseq(ind) then
      begin
        if setMap(SEQDUN) = 0 then
        begin
          VerboseProc('1879');
          duseq2(ind);
        end
        else
        begin
          //if topbak <> seq[ind + 1].lin then
          tp := @seq[ind]^;
          //if topbak <> TArrayOfStitchPoint(@seq[ind]^)[1].lin then
          if topbak <> tp[1].lin then
          begin
            if ind <> 0 then
            begin
              VerboseProc('1891');
              duseq2(ind + 1);
            end;
            VerboseProc('1894');
            duseq2(ind);

            {seqlin2 := @seqlin;
            Inc(seqlin2);
            topbak := seqlin2^.lin;}
            //topbak := TArrayOfStitchPoint(@seqlin^)[1].lin
            tp := @seqlin^;
            topbak := tp[1].lin;
          end;
        end;
      end
      else
      begin
        if rstMap(SEQDUN) <> 0 then
        begin
          VerboseProc('1910');
          duseq2(ind + 1);
        end;

        seqlin := @seq[ind];
        //seqlin := @seq[ind]^;
        movseq(ind);
      end;
      indz := ind;
      Dec(indz);//downto
    end;

    VerboseProc('~~1653'); 

    if rstMap(SEQDUN) <> 0 then
    begin
      VerboseProc('1924');
      duseq2(indz + 1);
    end;

    lastgrp := seqlin^.grp;
  end
  else
  begin
    for ind := strt to fin do
    begin
      if setseq(ind) then
      begin
        if setMap(SEQDUN) = 0 then
        begin
          VerboseProc('1938');
          duseq2(ind);
        end
        else
        begin
          //if topbak <> seq[ind + 1].lin then
          //if topbak <> TArrayOfStitchPoint(@seq[ind]^)[1].lin then
          //if topbak <> TArrayOfStitchPoint(@seq[ind]^)[1].lin then
          tp := @seq[ind]^;
          if topbak <> tp[1].lin then
          begin
            if ind <> 0 then
            begin
              VerboseProc('1951');
              duseq2(ind - 1);
            end;
            VerboseProc('1954');
            duseq2(ind);

            //seqlin2 := @seqlin;
            //Inc(seqlin2);

            //topbak := seqlin2^.lin;
            //topbak := TArrayOfStitchPoint(@seqlin^)[1].lin
            tp := @seqlin^;
            topbak := tp[1].lin;
            //topbak := TArrayOfStitchPoint(seqlin)[1].lin
          end;
        end;
      end
      else
      begin
        if rstMap(SEQDUN) <> 0 then
        begin
          if ind <> 0 then
          begin
            VerboseProc('1974');
            duseq2(ind - 1);
          end;
        end;

        seqlin := @seq[ind]^;
        movseq(ind);
      end;
      indz := ind;
      Inc(indz); //for to
    end;

    if rstMap(SEQDUN) <> 0 then
    begin
      if indz <> 0 then   
      begin
        VerboseProc('1990');
        duseq2(indz - 1);
      end;
    end;

    lastgrp := seqlin^.grp;
  end;
finally
  tp := nil;
end;
end;

procedure TThred.rspnt(fx, fy: Single);
begin
  VerboseProc('RSPNT');
  SetLength(bseq, Length(bseq)+1);
  bseq[opnt].x    := fx;
  bseq[opnt].y    := fy;
  bseq[opnt].attr := 0;
  //FVerboseProc(format('r  %d %.2f %.2f =%d',[opnt,bseq[opnt].x, bseq[opnt].y, bseq[opnt].attr ]));
  FVerboseProc(format('bseq[%d] X%.2f Y%.2f =%d',[opnt,bseq[opnt].x, bseq[opnt].y, bseq[opnt].attr ]));
  Inc(opnt);
end;

{procedure TfrmMain.duseq1;
var
  seqlin2: PSMALPNTL;
begin
  seqlin2 := seqlin;
  Inc(seqlin2);

  rspnt( (seqlin2^.x - seqlin^.x) / 2 + seqlin^.x,
         (seqlin2^.x - seqlin^.y) / 2 + seqlin^.y );
end;
procedure TfrmMain.duseq2(ind: Cardinal);
var
  seqlin2: PSMALPNTL;
begin
  seqlin  := @seq[ind];
  seqlin2 := @seq[ind + 1];

  rspnt( (seqlin2^.x - seqlin^.x) / 2 + seqlin^.x,
         (seqlin2^.y - seqlin^.y) / 2 + seqlin^.y );
end;}
procedure TThred.duseq1;
var
  Lseqlin: TArrayOfStitchPoint;
begin
  Lseqlin := @seqlin^;
  VerboseProc('duseq1 1814');
  rspnt( (Lseqlin[1].x - Lseqlin[0].x) / 2 + Lseqlin[0].x,
         (Lseqlin[1].y - Lseqlin[0].y) / 2 + Lseqlin[0].y );
  Lseqlin := nil;
end;

procedure TThred.duseq2(ind: Cardinal);
var
  Lseqlin: TArrayOfStitchPoint;
begin
  seqlin  := @seq[ind]^;
  Lseqlin := @seqlin^;
  VerboseProc('duseq2 1825');
  rspnt( (Lseqlin[1].x - Lseqlin[0].x) / 2 + Lseqlin[0].x,
         (Lseqlin[1].y - Lseqlin[0].y) / 2 + Lseqlin[0].y );
  Lseqlin := nil;
end;

procedure TThred.movseq(ind: Cardinal);
var
  lin : PStitchPoint;
begin
  VerboseProc('MOVSEQ');
  lin := @seq[ind]^;
  SetLength(bseq, Length(bseq)+1);
  bseq[opnt].attr := SEQBOT;
  bseq[opnt].x    := lin^.x;
  bseq[opnt].y    := lin^.y;
  FVerboseProc(format('bseq[%d] X%.2f Y%.2f =%d',[opnt,bseq[opnt].x, bseq[opnt].y, bseq[opnt].attr ]));
  Inc(opnt);
  Inc(lin);
  SetLength(bseq, Length(bseq)+1);
  bseq[opnt].attr := SEQTOP;
  bseq[opnt].x    := lin^.x;
  bseq[opnt].y    := lin^.y;
  FVerboseProc(format('bseq[%d] X%.2f Y%.2f =%d',[opnt,bseq[opnt].x, bseq[opnt].y, bseq[opnt].attr ]));
  Inc(opnt);
end;



procedure TThred.ResetVars(Sender: TObject);
begin
//-- for fnvrt() ---------------------------------------------------------------
  lins   := nil;
  grinds := nil;

//-- for lcon() ----------------------------------------------------------------
  seq    := nil;
  rgns   := nil;
  srgns  := nil;
  pmap   := nil;
  minds  := nil;
  seqmap := nil;

  SetLength(mpath, SizeOf(TFSEQ) * OSEQLEN);
  SetLength(tmpath, SizeOf(TFLPNT) * OSEQLEN);
  FillChar(map, Length(map), 0);
end;

destructor TThred.Destroy;
begin
  inherited;
//-- for fnvrt() ---------------------------------------------------------------
  SetLength(lins, 0);
  lins := nil;

  SetLength(grinds, 0);
  grinds := nil;

//-- for lcon() ----------------------------------------------------------------
  SetLength(seq, 0);
  seq := nil;

  SetLength(rgns, 0);
  rgns := nil;

  SetLength(srgns, 0);
  srgns := nil;

  SetLength(pmap, 0);
  pmap := nil;

  SetLength(mpath, 0);
  mpath := nil;

  SetLength(tmpath, 0);
  tmpath := nil;

  SetLength(visit, 0);
  visit := nil;

  SetLength(minds, 0);
  minds := nil;

  //SetLength(seqmap, 0);
  //seqmap := nil;
end;



function TThred.chkmax(arg0,arg1: Cardinal): Boolean;
begin
	result := False;

	if(arg0 and MAXMSK) <> 0 then
		result := True;
	if(arg1 and MAXMSK) <> 0 then
		result := True;
	if((arg1+arg0) and MAXMSK) <> 0 then
		result := True;
end;

procedure TThred.bakseq();
var

  cnt,rcnt: Integer;
	ind,rit: Integer;
	dif,pnt,stp : TDUBPNTL;
	len,rslop,
	usesiz2,
	usesizh,
	usesiz9,
	stspac2: Double;
  Lseqpnt : Integer;
  selectedForm__xat : cardinal;
label
  blntop, blntopx,
  blntbot, blntbotx,
  toplab, toplabx,
  botlab, botlabx;
begin
{.$DEFINE BUGBAK}

{$IFDEF BUGBAK}

	for Lseqpnt:=0 to opnt do
	begin
		oseq[Lseqpnt].x:=bseq[Lseqpnt].x;
		oseq[Lseqpnt].y:=bseq[Lseqpnt].y;
    seqpnt := Lseqpnt +1;
	end;
	//selectedForm->fmax=6000;
{$ELSE}
  selectedForm__xat := AT_SQR;
	usesiz2:=usesiz*2;
	usesizh:=usesiz/2;
	usesiz9:=usesiz/9;
	stspac2:= FIni.StitchSpacing*2;

	Lseqpnt:=0;
	rstMap(FILDIR);
	ind:=opnt-1;
  SetLength(oseq, Lseqpnt+1);
	oseq[Lseqpnt].x:=bseq[ind].x;
	oseq[Lseqpnt].y:=bseq[ind].y;
	Inc(Lseqpnt);
	s_Pnt.x:=bseq[ind].x;
	s_Pnt.y:=bseq[ind].y;
	Dec(ind);
	while(ind>0) do begin

		rcnt:=ind mod RITSIZ;
		if seqpnt>MAXSEQ then begin

			seqpnt:=MAXSEQ-1;
			Exit;
		end;
		rit:=Trunc(bseq[ind].x / stspac2);
		dif.x:=bseq[ind].x-bseq[ind+1].x;
		dif.y:=bseq[ind].y-bseq[ind+1].y;
		if dif.y <> 0 then
			rslop:=dif.x/dif.y
		else
			rslop:=1e16;//1e99;

		case bseq[ind].attr of

      SEQTOP:
      begin

        //if(selectedForm->xat&AT_SQR)
        if selectedForm__xat and AT_SQR <> 0 then
        begin

          if toglMap(FILDIR) then  begin
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].x:=bseq[ind-1].x;
            oseq[seqpnt].y:=bseq[ind-1].y;
            Inc(seqpnt);
            cnt:=ceil(bseq[ind].y/usesiz);
  blntop:
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].y:=cnt*usesiz+(rit mod seqtab[rcnt])*usesiz9;
            if oseq[seqpnt].y>bseq[ind].y then
              goto blntopx;
            dif.y:=oseq[seqpnt].y-bseq[ind].y;
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].x:=bseq[ind].x;
            Inc(seqpnt);
            Inc(cnt);
            goto blntop;
  blntopx:
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].x:=bseq[ind].x;
            oseq[seqpnt].y:=bseq[ind].y;
            Inc(seqpnt);
          end
          else begin
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].x:=bseq[ind].x;
            oseq[seqpnt].y:=bseq[ind].y;
            Inc(seqpnt);
            cnt:=Floor(bseq[ind].y/usesiz);
  blntbot:
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].y:=cnt*usesiz-((rit+2) mod seqtab[rcnt])*usesiz9;
            if(oseq[seqpnt].y<bseq[ind-1].y) then
              goto blntbotx;
            dif.y:=oseq[seqpnt].y-bseq[ind-1].y;
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].x:=bseq[ind].x;
            Inc(seqpnt);
            Dec(cnt);
            goto blntbot;
  blntbotx:
            SetLength(oseq, seqpnt+1);
            oseq[seqpnt].x:=bseq[ind-1].x;
            oseq[seqpnt].y:=bseq[ind-1].y;
            Inc(seqpnt);
          end
        end
        else begin

          cnt:=ceil(bseq[ind+1].y/usesiz);
  toplab:
          oseq[seqpnt].y:=cnt*usesiz+(rit mod seqtab[rcnt])*usesiz9;
          if(oseq[seqpnt].y>bseq[ind].y) then
            goto toplabx;
          dif.y:=oseq[seqpnt].y-bseq[ind+1].y;
          dif.x:=rslop*dif.y;
          SetLength(oseq, seqpnt+1);
          oseq[seqpnt].x:=bseq[ind+1].x+dif.x;
          Inc(seqpnt);
          Inc(cnt);
          goto toplab;
  toplabx:
          SetLength(oseq, seqpnt+1);
          oseq[seqpnt].x:=bseq[ind].x;
          oseq[seqpnt].y:=bseq[ind].y;
          Inc(seqpnt);
        end;
        //break;
      end;

      SEQBOT:
      begin

        //if not(selectedForm->xat&AT_SQR) then
        if not (selectedForm__xat and AT_SQR <> 0) then
        begin

          cnt:=Floor(bseq[ind+1].y/usesiz);
  botlab:
          SetLength(oseq, seqpnt+1);
          oseq[seqpnt].y:=cnt*usesiz-((rit+2) mod seqtab[rcnt])*usesiz9;
          if(oseq[seqpnt].y<bseq[ind].y) then
            goto botlabx;
          dif.y:=oseq[seqpnt].y-bseq[ind+1].y;
          dif.x:=rslop*dif.y;
          SetLength(oseq, seqpnt+1);
          oseq[seqpnt].x:=bseq[ind+1].x+dif.x;
          Inc(seqpnt);
          Dec(cnt);
          goto botlab;
  botlabx:
          SetLength(oseq, seqpnt+1);
          oseq[seqpnt].x:=bseq[ind].x;
          oseq[seqpnt].y:=bseq[ind].y;
          Inc(seqpnt);
        end;
        //break;
      end;

      0:
      begin

        dif.x:=bseq[ind].x-bseq[ind+1].x;
        dif.y:=bseq[ind].y-bseq[ind+1].y;
        rstMap(FILDIR);
        len:=hypot(dif.x,dif.y);
        if len <> 0 then begin

          if(len>usesiz2) then begin

            pnt.x:=bseq[ind+1].x;
            pnt.y:=bseq[ind+1].y;
            cnt:=Trunc(len/usesiz-1);
            if(chkmax(cnt,seqpnt)) or ((cnt+seqpnt)>MAXSEQ-3) then
              Exit;
            stp.x:=dif.x/cnt;
            stp.y:=dif.y/cnt;
            while cnt <> 0 do begin

              pnt.x:=pnt.x+stp.x;
              pnt.y:=pnt.y+stp.y;
              SetLength(oseq, seqpnt+1);
              oseq[seqpnt].x:=pnt.x;
              oseq[seqpnt].y:=pnt.y;
              Inc(seqpnt);
              Dec(cnt);
            end;
          end;
        end;
        SetLength(oseq, seqpnt+1);
        oseq[seqpnt].x:=bseq[ind].x;
        oseq[seqpnt].y:=bseq[ind].y;
        Inc(seqpnt);
      end;
    end;
    dec(ind);
  end;
{$ENDIF}
end;



procedure TThred.fnvrt(AStitchForm: TEmbroideryItem);
var
  i,k        : Integer;
  j           : Cardinal;
  LSides      : Integer;
  cnt      : Integer;
  tcnt  : Integer;
  LLineCount  : Integer;
  lox       : Double;
  hix      : Double;
  LGap,mstp       : Double;
  x0          : Double;
  LPoint1     ,
  LPoint2     : TFloatPoint;
  LProjPoint  : TFloatPoint;
  LPoints     : TArrayOfStitchPoint;// TArrayOfTSMALPNTL;
  //lins : TArrayOfStitchPoint;//TArrayOfTSMALPNTL;
  x, y        : Integer;
  loop, inf,ine     : Cardinal;
  //spnt      : Word;
  LGroupIndex : Word;
  tind        : Integer;
  //tgrinds     : array of Cardinal;
  SidesPoint  : TArrayOfFloatPoint;
  stspace : Double; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<temporary,test

  p,LPriorCount,LzC,
  LBarCount,

  LenSides, ltempcount,
  LWholeSides : Integer;

  LJumps : TArrayOfByte; //count of lines each bar
  LShape      : PgmShapeInfo;      
  LCorners : TArrayOfStitchPoint; //TArrayOfFloatRect;
begin
  LLineCount := 0;

  //FIni.StitchSpacing := 2.70000000476837158;
  lox  := High(Integer);// LShape.Points[0].X;
  hix := Low(Integer);// LLowX;

  //1 FIND MIN MAX X
  //SetLength(LWholeVertexs,0);
  LPriorCount := 0;
  for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
  begin
    LShape := @AStitchForm.PolyPolygon^[p];
    LenSides := Length(LShape^.Points);
    VerboseProc(format('polygon[%d].sides = %d',[p,LenSides ]));
    for i := 0 to (LenSides)-1 do
    begin
      with LShape^.Points[i] do
          VerboseProc(Format('x=%g   y=%g',[x, y]));
    end;
    //if Assigned(ABitmap32) then
      //DrawVertex();


    //SetLength(LWholeVertexs, LPriorCount + LSides);
    for i := 0 to ( LenSides -1 ) do
    begin
      if LShape^.Points[i].X > hix then
      begin
        hix := LShape^.Points[i].X;
      end;

      if LShape^.Points[i].X < lox then
      begin
        lox := LShape^.Points[i].X;
      end;
      //LWholeVertexs[LPriorCount + i] := LShape.Points[i];
    end;
    Inc(LPriorCount, LenSides);
  end;
  LWholeSides := LPriorCount;
  

  LTempCount := Trunc(lox / FIni.StitchSpacing);
  lox      := FIni.StitchSpacing * LTempCount;
  LBarCount  := Trunc( (hix - lox) / FIni.StitchSpacing ) + 1;

  if LBarCount < 2 then Exit;

  //prepare jump count & regions
  SetLength(LJumps,LBarCount);
  //FillChar(LJumps[0],LBarCount,0); //fill zero
  //SetLength(LRegions,0);
  //LRegions[0].x := 0;//first bar
  //LastJump := 0;
  //L := 0;

  SetLength(grinds,0);//     := nil;
  grindpnt    := 0;
  
  LGap := (hix - lox) / LBarCount;

  SetLength(LPoints, LWholeSides + 2);

  LGroupIndex := 0;
  spnt        := 0;

  x0    := lox;

  //get intersection of a scanline through all polygon of each shape
  LCorners := @lconflt[0];
  SetLength(LCorners,0);
  LzC := 0;
    for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
    begin
      LShape := @AStitchForm.PolyPolygon^[p];

      LenSides := Length(LShape^.Points);

      //we only interest on closed polygon. So, here to test:
      if LenSides >= 3 then
      begin
        LPoint1 := LShape^.Points[LenSides - 1];
        LPoint2 := LShape^.Points[0];
        if (LPoint1.X = LPoint2.X) and (LPoint1.Y = LPoint2.Y) then
          Dec(LenSides);
      end;

      if LenSides >= 3 then
      begin

        //we need to sort all corner by X of this polygon...
        //but in same time we also need to keep all sides in it's order.
        // (if I sort directly the corner, the polygon then unpredicable shape.)
        //So, we make a copy of corners, not change order directly.
        SetLength(LCorners, Length(LCorners) + LenSides);
        for j := 0 to LenSides - 1 do
        begin
          LCorners[LzC+j].Point := LShape^.Points[j];
          //k := (j + 1) mod LenSides; //avoid range error, we connect the last to the first, if necessery.
          //LCorners[LzC+].BottomRight := LShape^.Points[k];
          LCorners[LzC+j].lin   := LzC+j;
          LCorners[LzC+j].attr  := 0;

          if j = LenSides -1 then //the last?
          begin
            LCorners[LzC+j].attr   := SEQBOT;
            LCorners[LzC+j].cntbrk := LzC; //first point of this shapeinfo
          end;  
          //okay, nice. but then we care the direction. it should be ascending only.
          {if LCorners[j].Right < LCorners[j].Left then
          begin
            //swap!
            LPoint1 := LCorners[j].BottomRight;
            LCorners[j].BottomRight := LCorners[j].TopLeft;
            LCorners[j].TopLeft := LPoint1;
          end;}
        end;
        //Move(LShape.Points[0], LCorners[0], SizeOf(TFloatPoint) * LenSides);
        //QuickSortFloatPointY(LCorners, 0, High(LCorners));

        //QuickSortFloatRectTop(LCorners, 0, High(LCorners)); //this is fine!


        //here the real calculation
        {for j := 0 to LenSides - 1 do
        begin
          if ProjV(x0, LCorners[j].TopLeft, LCorners[j].BottomRight, LProjPoint) then
          begin
            LPoints[inf].X   := LProjPoint.X;
            LPoints[inf].y   := LProjPoint.y;
            //LPoints[inf].lin := j+LzY;//j;   //distinc corner index in whole shape, even different polygon
            LPoints[inf].lin := LCorners[j].lin+LzC;//j;   //distinc corner index in whole shape, even different polygon
            //inc(LzY);

            Inc(inf);
          end;
        end;}

      end;
      Inc(LzC, LenSides);

    end;
    sids := LzC;


  for i := 0 to (LBarCount - 1) do
  begin
    x0  := x0 + LGap;

    //LzC   := 0;
    inf := 0;

    //get intersection of a scanline through all polygon of each shape
    {for p := 0 to Length(AStitchForm.PolyPolygon^) -1 do
    begin
      LShape := @AStitchForm.PolyPolygon^[p];

      LenSides := Length(LShape^.Points);

      //we only interest on closed polygon. So, here to test:
      if LenSides >= 3 then
      begin
        LPoint1 := LShape^.Points[LenSides - 1];
        LPoint2 := LShape^.Points[0];
        if (LPoint1.X = LPoint2.X) and (LPoint1.Y = LPoint2.Y) then
          Dec(LenSides);
      end;

      if LenSides >= 3 then
      begin

        //we need to sort all corner by X of this polygon...
        //but in same time we also need to keep all sides in it's order.
        // (if I sort directly the corner, the polygon then unpredicable shape.)
        //So, we make a copy of corners, not change order directly.
        SetLength(LCorners, LenSides);
        for j := 0 to LenSides - 1 do
        begin
          LCorners[j].TopLeft := LShape^.Points[j];
          k := (j + 1) mod LenSides; //avoid range error, we connect the last to the first, if necessery.
          LCorners[j].BottomRight := LShape^.Points[k];
          LCorners[j].lin := j;

          //okay, nice. but then we care the direction. it should be ascending only.
          if LCorners[j].Right < LCorners[j].Left then
          begin
            //swap!
            LPoint1 := LCorners[j].BottomRight;
            LCorners[j].BottomRight := LCorners[j].TopLeft;
            LCorners[j].TopLeft := LPoint1;
          end;
        end;
        //Move(LShape.Points[0], LCorners[0], SizeOf(TFloatPoint) * LenSides);
        //QuickSortFloatPointY(LCorners, 0, High(LCorners));

        //QuickSortFloatRectTop(LCorners, 0, High(LCorners)); //this is fine!


        //here the real calculation
        for j := 0 to LenSides - 1 do
        begin
          if ProjV(x0, LCorners[j].TopLeft, LCorners[j].BottomRight, LProjPoint) then
          begin
            LPoints[inf].X   := LProjPoint.X;
            LPoints[inf].y   := LProjPoint.y;
            //LPoints[inf].lin := j+LzY;//j;   //distinc corner index in whole shape, even different polygon
            LPoints[inf].lin := LCorners[j].lin+LzC;//j;   //distinc corner index in whole shape, even different polygon
            //inc(LzY);

            Inc(inf);
          end;
        end;

      end;
      Inc(LzC, LenSides);

    end;}

    //here the real calculation
    for j := 0 to LzC - 1 do
    begin
      if LCorners[j].attr = SEQBOT then
      begin
        k := LCorners[j].cntbrk; //back to first point
      end
      else
        k := j +1; //next
      if ProjV(x0, LCorners[j].Point,  LCorners[k].Point,  LProjPoint) then
      begin
        LPoints[inf].X   := LProjPoint.X;
        LPoints[inf].y   := LProjPoint.y;
        //LPoints[inf].lin := j+LzY;//j;   //distinc corner index in whole shape, even different polygon
        LPoints[inf].lin := LCorners[j].lin;//j;   //distinc corner index in whole shape, even different polygon
        //inc(LzY);

        Inc(inf);
      end;
    end;
        
    LJumps[i] := 0;
    if inf > 1 then
    begin
      inf := inf and $FFFFFFFE; //EVEN only. DEL IF ODD
      LJumps[i] := inf div 2;

      SetLength( grinds, Length(grinds) + 1 );
      grinds[grindpnt] := spnt;             
      Inc(grindpnt);


      //FloatPointSort(LPoints, 0, inf - 1, @Compare_LinesInBar);
      QuickSortS(LPoints, 0, inf - 1, comp);

      j := 0;
      tind := spnt;
      //LWestern := High(Integer);
      while j < inf do
      begin
        // X1
        SetLength(lins, Length(lins) + 1);
        //LIndex := High(lins);

        lins[spnt].x   := LPoints[j].x;
        lins[spnt].y   := LPoints[j].y;
        lins[spnt].lin := LPoints[j].lin;
        lins[spnt].grp := LGroupIndex;
        {if LFillPoints[LIndex].x < LWestern then
          LWestern := 0
        else
          Inc(LWestern);
        LFillPoints[LIndex].WesternIndex := LWestern;}
        Inc(j);
        inc(spnt);

        // do twice ...
        // X2
        SetLength(lins, Length(lins) + 1);
        //LIndex := High(lins);

        lins[spnt].x   := LPoints[j].x;
        lins[spnt].y   := LPoints[j].y;
        lins[spnt].lin := LPoints[j].lin;
        lins[spnt].grp := LGroupIndex;
        //LFillPoints[LIndex].WesternIndex := LWestern;
        Inc(j);
        inc(spnt);
      end;

      //if j <> 0 then
      if spnt <> tind then
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
    {if (inf > 1) and (LastJump <> LJumps[i]) then
    begin
      L := Length(LRegions);
      F := High(LFillPoints)-LJumps[i];
      if L > 0 then
        LRegions[L-1].Y := F-1; //prior end

      SetLength(LRegions, L+1);
      L := High(LRegions);
      LRegions[L].X := F;
      LastJump := LJumps[i];
    end;}
  end;
  {SidesPoint := @AStitchForm.PolyPolygon^[0].Points[0];
  LSides := Length(SidesPoint);// AStitchForm.PolyPolygon^[0].Points );
  VerboseProc('LSIDES = '+inttostr(LSides));
  for i := 0 to (LSides)-1 do
  begin
    with SidesPoint[i] do
        VerboseProc(Format('x=%g   y=%g',[x, y]));
  end;


  lox  := SidesPoint[0].X;
  hix := lox;

  for i := 1 to ( LSides - 1 ) do
  begin
    if SidesPoint[i].X > hix then
    begin
      hix := SidesPoint[i].X;
    end;

    if SidesPoint[i].X < lox then
    begin
      lox := SidesPoint[i].X;
    end;
  end;

  stspace := FIni.StitchSpacing;
  //stspace :=
  tcnt := Trunc(lox / stspace);
  lox      := stspace * tcnt;
  cnt     := Trunc( (hix - lox) / stspace  + 1);
  barcount := cnt;

  mstp := (hix - lox) / cnt;
  x0    := lox;


  for i := 0 to (cnt - 1) do
  begin
    x0  := x0 + mstp;
    inf := 0;

    for j := 0 to (LSides - 2) do
    begin
      LPoint1 := SidesPoint[j];
      LPoint2 := SidesPoint[j + 1];

      if ProjV(x0, LPoint1, LPoint2, LProjPoint) then
      begin
        Inc(inf);
      end;
    end;

    LPoint1 := SidesPoint[LSides - 1];
    LPoint2 := SidesPoint[0];
    if ProjV(x0, LPoint1, LPoint2, LProjPoint) then
    begin
      Inc(inf);
    end;

    LLineCount := LLineCount + inf;
  end;

  SetLength(LPoints, LSides + 2);
  SetLength(lins, LLineCount);

  LGroupIndex := 0;
  spnt        := 0;
  x0          := lox;

  SetLength(grinds,0);//     := nil;
  grindpnt    := 0;

  SetLength(bars, LLineCount);
  barZ := 0;
  loop := 0;
  for i := 0 to (cnt - 1) do
  begin
    x0  := x0 + mstp;
    bars[barZ] := x0;
    inc(barZ);
    inf := 0;
    ine := 0;
    for j := 0 to (LSides - 2) do
    begin
      LPoint1 := SidesPoint[j];
      LPoint2 := SidesPoint[j + 1];
      ine := j;

      if ProjV(x0, LPoint1, LPoint2, LProjPoint) then
      begin
        LPoints[inf].lin := ine;
        LPoints[inf].X   := LProjPoint.X;
        LPoints[inf].y   := LProjPoint.y;

        Inc(inf);
      end;
    end;

    LPoint1 := SidesPoint[LSides - 1];
    LPoint2 := SidesPoint[0];
    if ProjV(x0, LPoint1, LPoint2, LProjPoint) then
    begin
      Inc(ine);
      LPoints[inf].lin := ine;
      LPoints[inf].X   := LProjPoint.X;
      LPoints[inf].y   := LProjPoint.y;

      Inc(inf);
    end;

    if inf > 1 then
    begin
      inf := inf and $FFFFFFFE;

      SetLength( grinds, Length(grinds) + 1 );
      grinds[grindpnt] := spnt;
      Inc(grindpnt);

      QuickSortS(LPoints, 0, inf - 1, comp);

      j    := 0;
      tind := spnt;
      while j < inf -1 do
      begin
        lins[spnt].lin := LPoints[j].lin;
        lins[spnt].grp := LGroupIndex;
        lins[spnt].x   := LPoints[j].x;
        lins[spnt].y   := LPoints[j].y;
        lins[spnt].Loop := loop;

        inc(spnt);
        Inc(j);

        // do twice ...
        lins[spnt].lin := LPoints[j].lin;
        lins[spnt].grp := LGroupIndex;
        lins[spnt].x   := LPoints[j].x;
        lins[spnt].y   := LPoints[j].y;
        lins[spnt].Loop := loop;

        inc(spnt);
        Inc(j);
      end;
      Inc(loop);

      if spnt <> tind then
      begin
        Inc(LGroupIndex);
      end;
    end;
  end;
  //PointSort(lins, 0, High(lins), sqcomp);
}
  VerboseProc('Lins : '+inttostr(Length(lins) div 2) );

  SetLength( grinds, Length(grinds) + 1 );
  grinds[grindpnt] := spnt;
  Inc(grindpnt);

  {SetLength(grinds, grindpnt);
  for i := 0 to (grindpnt - 1) do
  begin
    grinds[i] := grinds[i];
  end;}

{  Memo1.Lines.Clear;
  Memo1.Lines.Add( 'grindpnt: ' + IntToStr(grindpnt) );
  Memo1.Lines.Add('');
  for i := 0 to (grindpnt - 1) do
  begin
    Memo1.Lines.Add( 'i:' + IntToStr(i) );
    Memo1.Lines.Add('grinds[i]:' + IntToStr(grinds[i]) );
    Memo1.Lines.Add('');
  end;
  Memo1.Update;  }

  SetLength(LPoints, 0);
  LPoints := nil;

  //AStitchForm.Stitchs^ := @lins[0];

end;

procedure TThred.lcon(AStitchForm: TEmbroideryItem);
var
  ind, indz : Integer;
  ine     : Integer;
  blin    : Cardinal;
  sind    : Integer;
  cnt     : Cardinal;
  sgrp    : Cardinal;
  tcon    : SmallInt;
  //tpnt    : Cardinal;
  tpnt    : PStitchPoint; //x2nie
  //lconskip: Boolean;

  //rgns : array of TRGN;
  //srgns: array of Cardinal;
  tmap  : TArrayOfTRCON;

  ii,i,j,w,h,t,k,l: Integer;
  mpathfirst : TArrayOfCardinal;

label
  lconskip;
begin
//PREPARING VARS
      //-- lcon() begin --------------------------------------------------------------
      SetLength(bseq,0);
      FStitchForm := AStitchForm;
      //AStitchForm.Stitchs^ := @lins[0];
      //lins := @AStitchForm.Stitchs^[0];
      spnt := Length(lins);

      //sids := Length( AStitchForm.PolyPolygon^[0].Points );

      if spnt <= 0 then
      exit;
      lconflt := @FStitchForm.PolyPolygon^[0].Points[0];
      //ReCalcGrinds();

//FILL SEQ:
      SetLength( seq, (spnt shr 1) );
      lpnt := 0;

      ind := 0;
      while ind < spnt do
      begin
        seq[lpnt] := @lins[ind];

        ind  := ind + 2;
        lpnt := lpnt + 1;
      end;
      //PPointSort(seq, 0, High(seq), sqcomp);

//PREPARE REGIONS BY SORT BY .LIN
      PointSortSP(seq, 0, lpnt-1, sqcomp);


//BUILD REGIONS BY .LIN  (SORTED ALREADY)
      rgcnt := 0;
      SetLength(rgns, spnt shr 1);
      rgns[0].StartLine := 0;
      blin := seq[0]^.lin;
      indz := 0;
      for ind := 0 to (lpnt - 1) do
      begin
        indz := ind;
        if blin <> seq[ind]^.lin then
        begin
          rgns[rgcnt].EndLine := ind - 1;
          Inc(rgcnt);
          rgns[rgcnt].StartLine := ind;
          blin := seq[ind]^.lin;
        end;
        Inc(indz);
      end;
      ind := indz;
      rgns[rgcnt].EndLine := ind - 1;
      Inc(rgcnt);

      //x2nie immediatelly write the RGNS
      for i := 0 to rgcnt-1 do
      begin
        for j :=rgns[i].StartLine  to rgns[i].EndLine do
        begin
          //lins[j].rgns := i;
          seq[j]^.rgns := i;
        end;
        FVerboseProc(Format('rgn[%d]  %d ~ %d',[i, seq[rgns[i].StartLine]^.grp,  seq[rgns[i].EndLine]^.grp ] ) )
      end;

    //exit;

      SetLength(rgns, rgcnt);
      SetLength(visit, rgcnt);
      SetLength(srgns, rgcnt * 2);

      for ind := 0 to (rgcnt - 1) do
      begin
        //rgns[ind].StartLine := rgns[ind].StartLine;
        //rgns[ind].EndLine   := rgns[ind].EndLine;
        visit[ind]          := 0;
        rgns[ind].brk    := $CDCDCDCD;
        rgns[ind].cntbrk    := 0;
      end;


//VALIDATE IF RGNS HAS SOME BRK BLA BLA BLA ???? 
      sind   := 0;
      for ind := 0 to (rgcnt - 1) do begin

        cnt := 0;
        if (rgns[ind].EndLine - rgns[ind].StartLine) >= 2 then begin

          sgrp := seq[ rgns[ind].StartLine ]^.grp;
          for ine := (rgns[ind].StartLine + 1) to rgns[ind].EndLine do begin

            Inc(sgrp);
            if seq[ine]^.grp <> sgrp then begin

              if cnt = 0 then
              begin
                rgns[ind].brk := sind;
              end;

              Inc(cnt);
              sgrp := seq[ine]^.grp;

              srgns[sind] := ine;
              Inc(sind);
            end;
          end;
        end;

        rgns[ind].cntbrk := cnt;
      end;

      SetLength(srgns, sind);



//FIND THE NEAREST (CLOSED) REGIONS, IF THERE IS MORE THAN SINGLE ONE REGION.       
    //Exit;
      tmap := nil;// TArrayOfTRCON(@bseq[0]);
      SetLength(minds, rgcnt + 1);

      opnt := 0;
      if rgcnt > 1 then
      begin

        ine  := 0;


//FIND REGION OVERLAPING BY .GRP  >>> SAVE RESULT INTO "PMAP"
        cpnt := 0;      
        for ind := 0 to (rgcnt - 1) do begin

          minds[ind] := cpnt; //MIN DS | MIN Delta
          cnt        := 0;
          rgclos     := 0;
          indz := 0;
          for ine := 0 to (rgcnt - 1) do begin

            if ind <> ine then  begin

              tcon := regclos(ind, ine);
              if tcon <> 0 then
              begin

                FVerboseProc(Format('>%d ~ %d > %d',[ind, ine, nxtgrp] ));

                SetLength(tmap, Length(tmap) + 1);
                tmap[cpnt].con  := tcon;
                tmap[cpnt].grpn := nxtgrp;
                tmap[cpnt].vrt  := ine;

                Inc(cpnt);
                Inc(cnt);
              end;
            end;
            indz := ine;
          end;
          inc(indz);
          ine := indz;

          while (cnt = 0) do
          begin

            rgclos := rgclos + FIni.StitchSpacing;
            {if rgclos > spnt * FIni.StitchSpacing
            then //endless loop?
              break;}
          
            cnt    := 0;
            for ine := 0 to (rgcnt - 1) do begin

              if ind <> ine then
              begin

                tcon := regclos(ind, ine);
                if tcon <> 0 then
                begin
                  FVerboseProc(Format('*%d ~ %d >> %d ',[ind, ine, nxtgrp] ));

                  SetLength(tmap, Length(tmap) + 1);
                  tmap[cpnt].con  := tcon;
                  tmap[cpnt].grpn := nxtgrp;
                  tmap[cpnt].vrt  := ine;

                  Inc(cpnt);
                  Inc(cnt);
                end;
              end;
            end;
          end; 
        indz := ind;
        end; //for ind
        inc(indz);
        ind := indz;
        minds[ind] := cpnt;

        FVerboseProc(Format('CPNT=%d ~ ',[cpnt] ));

        SetLength(pmap, cpnt + 1);
        for ind := 0 to (cpnt - 1) do
        begin
          pmap[ind].con  := tmap[ind].con;
          pmap[ind].vrt  := tmap[ind].vrt;
          pmap[ind].grpn := tmap[ind].grpn; 
          FVerboseProc(Format('pmap:vrt=%d grpn=%d',[ pmap[ind].vrt, pmap[ind].grpn] ));
        end;




//FIND LEFT MOST REGION

        //1. FIND THE SMALLEST .GRP
        sgrp := $FFFFFFFF;
        ine  := 0;
        for ind := 0 to (rgcnt - 1) do
        begin
          tpnt := @seq[rgns[ind].StartLine]^;

          if tpnt^.grp < sgrp then
          begin                                                                  
            sgrp := tpnt^.grp;
            ine  := ind;
          end;
        end;
        FVerboseProc(Format('leftmost rgn=[ine=%d]',[ine] ));
        FVerboseProc(Format('[leftmost rgn].grp=%d',[sgrp] ));
//INE = LEFTMOST REGION.INDEX



        // find the leftmost region in pmap
        //mpathi   := 1; moved to line #790
        opnt := 0;
        indz := 0;
        for ind := 0 to (cpnt - 1) do
        begin
          indz := ind;
          if pmap[ind].vrt = ine then
            goto lconskip;
          Inc(indz);
        end;

        //if not lconskip then
        begin
          //ind := indz;//c++ for ind

          pmap[cpnt].vrt  := ine;
          pmap[cpnt].grpn := 0;
          indz             := cpnt;
        end;

    lconskip:
        FVerboseProc(Format('leftmost rgn. in pmap=@[%d]',[indz] ));
        
        // set the first entry in the temporary path to the leftmost region
        tmpath[0].pcon := indz;
        tmpath[0].cnt  := 1;
        tmpath[0].skp  := 0;
        visit[ine]     := 1;
        dunrgn         := ine; //LAST DONE REGION
//OKE, FIRST PATH IS FOUND.

//Exit;

//NOW GET THE ANY POSSIBLE PATH (NEXT SEQUENCE STEPS) THROUGH ALL REGIONS
        mpathi   := 1;  // Curent index of mpath[] to fill. | count of region visited.
        while unvis() do
          nxtrgn(); //STORE TO "TMPATH []"

//Exit;


        // BUILD MPATH[] FROM TMPATH
        ine := 0;
        cnt := $FFFFFFFF;

        for ind := 0 to (mpathi - 1) do
        begin
          indz := ind;
          mpath[ine].skp := tmpath[ind].skp;
          if tmpath[ind].pcon = $FFFFFFFF then
          begin

            mpath[ine].vrt := tmpath[ind].cnt;
            Inc(ine);
            cnt            := tmpath[ind].cnt;
          end
          else
          begin
            if tmpath[ind].pcon <> cnt then
            begin 
              cnt            := tmpath[ind].pcon;
              mpath[ine].vrt := pmap[tmpath[ind].pcon].vrt;

              Inc(ine);
            end;
          end;
          Inc(indz);
        end;
        ind := indz;

        mpathi := ind;
        mpath0 := 0;

//Exit;

        SetLength(mpathfirst, mpathi);//x2nie
        for ind := 0 to (mpathi - 1) do
        begin
          nxtseq(ind);
          mpathfirst[ind] := 0; //x2nie;
        end;

        FVerboseProc(Format('mpath0:%d  mpathi:%d ', [mpath0, mpathi ] ));

//Exit;
        //x2nie immediatelly write the mpath
        {for i := 0 to mpathi do
        begin
          k := rgns[mpath[i].vrt].StartLine;
          l := mpath[i].grpn;
          for j :=rgns[i].StartLine  to rgns[i].EndLine do
          begin
            //lins[j].rgns := i;
            seq[j]^.mpath := i;
          end;
          //FVerboseProc(Format('rgn[%d]  %d ~ %d',[i, seq[rgns[i].StartLine]^.grp,  seq[rgns[i].EndLine]^.grp ] ) )
        end;}


//OKE, ALL NEEDED TO BUILD STITCHS ARE NOW AVAILABLE.
//LET'S RESET THE COUNTERS, FIRST:
        {$IFNDEF THRED_BITS}
        ine := (lpnt {shr 5}) + 1;
        SetLength(seqmap, ine);
        for ind := 0 to (ine - 1) do
        begin
          seqmap[ind] := False;
        end;

        {$ELSE}

        ine := (lpnt shr 5) + 1;
        SetLength(seqmap, ine);
        for ind := 0 to (ine - 1) do
        begin
          seqmap[ind] := 0;
        end;
        {$ENDIF}


        for ind := 0 to (rgcnt - 1) do
        begin
          visit[ind] := 0;
        end;

        lastgrp := 0;
//Exit;
//THEN BUILD STITCHS! FROM HERE:        
        for ind := 0 to (mpath0 - 1) do
        begin
          if not unvis() then
          begin
            Break;
          end;

          durgn(ind);
        end;
    //Exit;    
      end
      else
      begin
        SetLength(pmap, 1);
        SetLength(mpath, 1);

        {$IFNDEF THRED_BITS}
        ine := (lpnt {shr 5}) + 1;
        SetLength(seqmap, ine);

        for ind := 0 to (ine - 1) do
        begin
          seqmap[ind] := False;
        end;
        
        {$ELSE}

        ine := (lpnt shr 5) + 1;
        SetLength(seqmap, ine);

        for ind := 0 to (ine - 1) do
        begin
          seqmap[ind] := 0;
        end;
        {$ENDIF};


        lastgrp       := 0;
        mpath[0].vrt  := 0;
        mpath[0].grpn := seq[rgns[0].EndLine]^.grp;
        mpath[0].skp  := 0;

        durgn(0);
      end;
           
{  Memo1.Lines.Clear;
  FVerboseProc( 'opnt: ' + IntToStr(opnt) );
  FVerboseProc('');
  for ii := 0 to (opnt - 1) do
  begin
    FVerboseProc( 'i:' + IntToStr(ii) );
    FVerboseProc( 'x: ' + FloatToStr(bseq[ii].x) );
    FVerboseProc( 'y: ' + FloatToStr(bseq[ii].y) );
    FVerboseProc( 'attr: ' + IntToStr(bseq[ii].attr) );
    FVerboseProc( '' );
  end;
  Memo1.Update;}

  {if opnt > 1 then
  begin
    //imgvwDrawingArea.Bitmap.PenColor := clBlack32;
    imgvwDrawingArea.Bitmap.MoveToF(bseq[0].x, bseq[0].y);
    for ii := 1 to (opnt - 1) do
    begin
      imgvwDrawingArea.Bitmap.PenColor := c[bseq[ii].attr mod VERTICES];

      imgvwDrawingArea.Bitmap.LineToFS(bseq[ii].x, bseq[ii].y);
    end;

    h := imgvwDrawingArea.Bitmap.TextHeight(chr(122)) div 2 ;
    for ii := 0 to (opnt - 1) do
    begin
      w := imgvwDrawingArea.Bitmap.TextWidth(IntToStr(ii)) ;
      t := ((ii mod 50) div 10) * h;
      with Point(Round(bseq[ii].x), Round(bseq[ii].y)) do
      begin
        imgvwDrawingArea.Bitmap.FillRectS(x , y-h +t , x + w, y-h + h*2 -1 +t, c[bseq[ii].attr mod VERTICES]);
        //imgvwDrawingArea.Bitmap.Textout( Round(bseq[ii].x), Round(bseq[ii].y) , IntToStr(ii));
        imgvwDrawingArea.Bitmap.Textout(x, y-h +t , IntToStr(ii));

      end;
    end;

    imgvwDrawingArea.Bitmap.Changed;
  end;}

  for i := 0 to High(lins) do
  begin
    //FVerboseProc(Format('lin[%d]  L:%d  g:%d  x:%.2f   y:%.fd',[i, lins[i].lin, lins[i].grp, lins[i].x, lins[i].y]))
  end;

Exit;
  SetLength(rgns, 0);
  rgns := nil;

  SetLength(tmap, 0);
  tmap := nil;

//------------------------------------------------------------------------------

{  LCount := Length(LFillPoints);

  if LCount > 0 then
  begin
    imgvwDrawingArea.Bitmap.PenColor := clRed32;

    x := Round(LFillPoints[0].X);
    y := Round(LFillPoints[0].Y);
    imgvwDrawingArea.Bitmap.MoveTo(x, y);

    for i := 0 to (LCount - 1) do
    begin
      x := Round(LFillPoints[i].X);
      y := Round(LFillPoints[i].Y);
      imgvwDrawingArea.Bitmap.LineToS(x, y);
    end;

    for i := 0 to (LCount - 1) do
    begin
      x := Round(LFillPoints[i].X);
      y := Round(LFillPoints[i].Y);

      imgvwDrawingArea.Bitmap.FillRectS(x - 1, y - 1, x + 1, y + 1, clBlue32);
    end;

    SetLength(LFillPoints, 0);
    LFillPoints := nil;
  end;

  SetLength(LPoints, 0);
  LPoints := nil; }
end;

function TThred.publins: PArrayOfStitchPoint;
begin
  Result := @lins;
end;

function TThred.pubbseq: PArrayOfStitchPoint;
begin
  Result := @bseq;
end;

function TThred.pubOseq: PArrayOfStitchPoint;
begin
  Result := @oseq;
end;

end.
