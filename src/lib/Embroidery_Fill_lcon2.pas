unit Embroidery_Fill_lcon2;

interface

uses
  GR32, Thred_Constants, Thred_Defaults, Thred_Types, 
  Embroidery_Items;

type
  TVerboseProc = procedure (const VerboseMsg : string) of object;

  TLCON = class(TObject)
  private
    FVerboseProc: TVerboseProc;
    FIni: TThredIniFile;
    FStitchForm: TEmbroideryItem;
    lconflt : TArrayOfFloatPoint;//TArrayOfPoint;
    //map     : array [0..MAPLEN-1] of TColor32; // bitmap
    //lins    : TArrayOfTSMALPNTL;               // pairs of fill line endpoints
    //seq     : TArrayOfPSMALPNTL;               // sorted pointers to lins
    map     : array [0..LASTBIT] of ByteBool; // bitmap
    lins    : TArrayOfStitchPoint ;               // pairs of fill line endpoints
    seq     : TArrayOfPStitchPoint;               // sorted pointers to lins
    //bseq    : array [0..BSEQLEN-1] of TBSEQPNT;// reverse sequence for polygon fills
    //oseq    : array [0..OSEQLEN-1] of TFLPNT;  // temporary storage for sequencing
    rgns    : array of TRGN;                   // a list of regions for sequencing
    srgns   : array of Cardinal;               // an array of subregion starts
    grinds  : array of Cardinal;               // array of group indices for sequencing
    visit   : array of Byte;                   // visited character map for sequencing
    pmap    : array of TRCON;                  // path map for sequencing
    mpath   : array of TFSEQ;	                 // path of sequenced regions
    sids    : Integer;
    tmpath  : TArrayOfTRGSEQ; //array of TRGSEQ;                 // temporary path connections
    dunpnts : array [0..3] of TFLPNT;          // corners of last region sequenced
    //rgpth   : PRGSEQArray;                     // length of the path to the region
    rgpth   : TArrayOfTRGSEQ; //array of TRGSEQ;//x2nie          //path to a region
    minds   : array of Cardinal;
    seqmap  : array of Cardinal;               // a bitmap of sequenced lines
    grindpnt: Cardinal;                        // number of group indices
    spnt    : Integer;
    lpnt    : Integer;
    rgcnt   : LongInt;                        // number of regions to be sequenced
    nxtgrp  : Cardinal;                        // group that connects to the next region
    rgclos  : Double;                          // region close enough threshold for sequencing
    mpathi  : Cardinal;                        // index to path of sequenced regions
    dunrgn  : Cardinal;                        // last region sequenced
    vispnt  : Cardinal;                        // next unvisited region for sequencing
    pthlen  : Cardinal;                        // length of the path to the region
    cpnt    : Cardinal;                        // number of entries map for sequencing
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
    function isclos(pnt0, pnt1: PStitchPoint): Word;
    function lnclos(gp0, ln0, gp1, ln1: Cardinal): Boolean;
    procedure movseq(ind: Cardinal);
    function notdun(lvl: Cardinal): Cardinal;
    function nxt(ind: cardinal): cardinal;
    procedure nxtrgn;
    procedure nxtseq(pthi: Cardinal);
    function prv(ind: cardinal): cardinal;
    function regclos(rg0, rg1: Cardinal): Word;
    function reglen(reg: Cardinal): Double;
    procedure rspnt(fx, fy: Single);
    function rstMap(bPnt: Cardinal): Cardinal;
    function setMap(bPnt: Cardinal): Cardinal;
    function setseq(bpnt: Cardinal): Cardinal;
    function unvis: Boolean;
    function bts(bit: Cardinal): Boolean;
    procedure ReCalcGrinds;
    function toglMap(bPnt: Cardinal): Boolean;
    function chkmax(arg0,arg1: Cardinal): Boolean;
  protected

  public
    bseq    : array [0..BSEQLEN-1] of TBSEQPNT;// reverse sequence for polygon fills
    oseq    : array [0..OSEQLEN-1] of TFLPNT;  // temporary storage for sequencing
    seqpnt  : Cardinal;					//sequencing pointer
    opnt    : Cardinal;                        // output pointer for sequencing

    constructor Create;
    destructor Destroy; override;
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
  TRA = clwhite32;// clTrWhite32;

implementation

uses
  SysUtils, Math;
//-- Point Quick Sort Algorithm ------------------------------------------------

// Adapted from the algorithm in this topic:
// http://blog.csdn.net/stevenldj/article/details/7170303

type
  TPointSortCompare = function (Item1, Item2: PStitchPoint): Integer;

procedure QuickSort(var APoints: TArrayOfPStitchPoint; L, R: Integer;
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
      QuickSort(APoints, L, J, SCompare);

    L := I;
    
  until I >= R;
end;

procedure PointSort(var APoints: TArrayOfPStitchPoint; L, R: Integer;
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


function comp(APoint1, APoint2: TStitchPoint): Integer;
begin
  if APoint2.Y < APoint1.Y then
  begin
//    Result := 1;  // old code in thred
    Result := -1;
    Exit;
  end;

  if APoint2.Y > APoint1.Y then
  begin
//    Result := -1;  // old code in thred
    Result := 1;
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

function sqcomp(A,B: PStitchPoint): Integer;
var
  APoint1: TStitchPoint ;
  APoint2: TStitchPoint ;
begin
  APoint1:=A^;
  APoint2:=B^;
  Result := 0;
  
  if APoint1.lin = APoint2.lin then
  begin
    if APoint1.grp = APoint2.grp then
    begin
      if APoint1.X <> APoint2.X then
      begin
        if APoint1.X > APoint2.X then
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
      if APoint1.grp > APoint2.grp then
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
    if APoint1.lin > APoint2.lin then
    begin
      Result := 1;
    end
    else
    begin
      Result := -1;
    end;
  end;
end;

{ TLCON }

constructor TLCON.Create;
begin
               //
end;

procedure TLCON.ReCalcGrinds();
var i,j : Integer;
  LastGrp : Integer;
begin
  SetLength(grinds,0);
  LastGrp := MaxInt;
  for i := 0 to (Length(lins) - 1) do
  begin
    if LastGrp <> lins[i].grp then
    begin
      LastGrp := lins[i].grp;
      
      j := Length(grinds);
      SetLength( grinds, j + 1 );
      grinds[j] := i;
    end;
  end;
  grindpnt := Length(grinds);
end;

procedure TLCON.lcon(AStitchForm: TEmbroideryItem);
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
  lconskip: Boolean;

  //rgns : array of TRGN;
  //srgns: array of Cardinal;
  tmap  : TArrayOfTRCON;

  ii,i,j,w,h,t: Integer;
begin
//-- lcon() begin --------------------------------------------------------------
  FStitchForm := AStitchForm;
  lins := @AStitchForm.Stitchs^[0];
  spnt := Length(lins);

  sids := Length( AStitchForm.PolyPolygon^[0].Points );

  if spnt <= 0 then
  exit;

  lconflt := @FStitchForm.PolyPolygon^[0].Points[0];
  ReCalcGrinds();
  
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
  PointSort(seq, 0, lpnt-1, sqcomp);


  rgcnt := 0;
  SetLength(rgns, spnt shr 1);
  rgns[0].StartLine := 0;
  blin := seq[0]^.lin;
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

  {for ind := 0 to (rgcnt - 1) do
  begin
    rgns[ind].StartLine := rgns[ind].StartLine;
    rgns[ind].EndLine   := rgns[ind].EndLine;
    visit[ind]          := 0;
    rgns[ind].cntbrk    := 0;
  end;

  tsrgns := nil;}
  sind   := 0;

  for ind := 0 to (rgcnt - 1) do begin

    cnt := 0;
    if (rgns[ind].EndLine - rgns[ind].StartLine) > 1 then begin

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

//Exit;  
  tmap := nil;// TArrayOfTRCON(@bseq[0]);
  SetLength(minds, rgcnt + 1);

  opnt := 0;
  if rgcnt > 1 then
  begin

    ine  := 0;
    cpnt := 0;

    for ind := 0 to (rgcnt - 1) do begin

      minds[ind] := cpnt;
      cnt        := 0;
      rgclos     := 0;
      indz := 0;
      for ine := 0 to (rgcnt - 1) do begin

        if ind <> ine then  begin

          tcon := regclos(ind, ine);
          if tcon > 0 then
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
        if rgclos > spnt * FIni.StitchSpacing
        then
          break;
          
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

    FVerboseProc(Format('CPNT=%d ~ ',[cpnt] ));

    minds[ind] := cpnt;
    SetLength(pmap, cpnt + 1);
    for ind := 0 to (cpnt - 1) do
    begin
      pmap[ind].con  := tmap[ind].con;
      pmap[ind].vrt  := tmap[ind].vrt;
      pmap[ind].grpn := tmap[ind].grpn; 
      FVerboseProc(Format('pmap:vrt=%d grpn=%d',[ pmap[ind].vrt, pmap[ind].grpn] ));
    end;

    // find the leftmost region
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
    FVerboseProc(Format('leftmost rgn=%d',[ine] ));
    FVerboseProc(Format('leftmost rgn.grp=@%d',[sgrp] ));


    opnt := 0;
    // find the leftmost region in pmap
    mpathi   := 1;
    lconskip := False;

    j := 0;
    for ind := 0 to (cpnt - 1) do
    begin
      j := ind;
      if pmap[ind].vrt = ine then
      begin
        lconskip := True;
        Break;
      end;
      Inc(j);
    end;
    FVerboseProc(Format('leftmost rgn. in pmap=@%d',[j] ));

    if not lconskip then
    begin
      ind := j;//c++ for ind
      
      pmap[cpnt].vrt  := ine;
      pmap[cpnt].grpn := 0;
      ind             := cpnt; 
    end;

    // set the first entry in the temporary path to the leftmost region
    tmpath[0].pcon := ind;
    tmpath[0].cnt  := 1;
    tmpath[0].skp  := 0;
    visit[ine]     := 1;
    dunrgn         := ine;

//Exit;    
    while unvis() do
    begin
      nxtrgn();
    end;
//Exit;
    ine := 0;
    cnt := $FFFFFFFF;

    for ind := 0 to (mpathi - 1) do
    begin
      indz := ind;
      mpath[ine].skp := tmpath[ind].skp;
      if tmpath[ind].pcon = $FFFFFFFF then
      begin
      
        mpath[ine].vrt := tmpath[ind].cnt;
        cnt            := tmpath[ind].cnt;

        Inc(ine);
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

    for ind := 0 to (mpathi - 1) do
    begin
      nxtseq(ind);
    end;

    FVerboseProc(Format('mpath0:%d  mpathi:%d ', [mpath0, mpathi ] ));


    ine := (lpnt shr 5) + 1;

    SetLength(seqmap, ine);
    for ind := 0 to (ine - 1) do
    begin
      seqmap[ind] := 0;
    end;

    for ind := 0 to (rgcnt - 1) do
    begin
      visit[ind] := 0;
    end;

    lastgrp := 0;

    for ind := 0 to (mpath0 - 1) do
    begin
      if not unvis() then
      begin
        Break;
      end;

      durgn(ind);
    end;
Exit;    
  end
  else
  begin
    SetLength(pmap, 1);
    SetLength(mpath, 1);

    ine := (lpnt shr 5) + 1;
    SetLength(seqmap, ine);

    for ind := 0 to (ine - 1) do
    begin
      seqmap[ind] := 0;
    end;

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
    FVerboseProc(Format('lin[%d]  L:%d  g:%d  x:%.2f   y:%.fd',[i, lins[i].lin, lins[i].grp, lins[i].x, lins[i].y]))
  end;


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


    function TLCON.bts(bit: Cardinal): Boolean;
    var
      offset: Cardinal;
      mask  : Cardinal;
      ret   : Boolean;
    begin

      Result        := map[bit];
      map[bit] := True;

      Result := ret;
    end;

// form.cpp (Linux version), #3283
function TLCON.setseq(bpnt: Cardinal): Cardinal;
begin

  if bts(bpnt) then
  begin
    Result := 0;
  end
  else
  begin
    Result := 1;
  end;
end;

// thred.cpp (Linux version), #1909
function TLCON.setMap(bPnt: Cardinal): Cardinal;
begin
  //if bts(LBits, bPnt) then
  if bts(bPnt) then
  begin
    Result := $FFFFFFFF;
  end
  else
  begin
    Result := 0;
  end;
end;

// thred.cpp (Linux version), #1917
function TLCON.rstMap(bPnt: Cardinal): Cardinal;

  function btr(bit: Cardinal): Boolean;
  var
    offset: Cardinal;
    mask  : Cardinal;
    ret   : Boolean;
  begin
    Result   := map[bit];
    map[bit] := False;
  end;
begin

  if btr(bPnt) then
  begin
    Result := $FFFFFFFF;
  end
  else
  begin
    Result := 0;
  end;
end;


function TLCON.toglMap(bPnt: Cardinal): Boolean;
begin
  Result   := map[bPnt];
  map[bPnt] := not map[bPnt];
end;



// from.cpp of thred #3372
function TLCON.regclos(rg0, rg1: Cardinal): Word;
var
  pnt0s: PStitchPoint;
  pnt0e: PStitchPoint;
  pnt1s: PStitchPoint;
  pnt1e: PStitchPoint;

  grp0s: Integer;//Cardinal;
  grp0e: Integer;//Cardinal;
  grp1s: Integer;//Cardinal;
  grp1e: Integer;//Cardinal;
  grps : Cardinal;
  grpe : Cardinal;
  lins : Cardinal;
  line : Cardinal;
  prlin: Cardinal;
  polin: Cardinal;
begin
  pnt0s := @seq[rgns[rg0].StartLine]^;
  pnt1s := @seq[rgns[rg1].StartLine]^;
  grp0s := pnt0s^.grp;
  grp1s := pnt1s^.grp;

  if grp0s > grp1s then
  begin
    grps  := grp0s;
    lins  := pnt0s^.lin;
    prlin := pnt1s^.lin;
  end
  else
  begin
    grps  := grp1s;
    lins  := pnt1s^.lin;
    prlin := pnt0s^.lin;
  end;

  if (grps <> 0) and lnclos(grps - 1, prlin, grps, lins) then
  begin
    nxtgrp := grps;
    Result := 1;
    Exit;
  end
  else
  begin
    pnt0e := @seq[rgns[rg0].EndLine]^;
    pnt1e := @seq[rgns[rg1].EndLine]^;
    grp1e := pnt1e^.grp;
    grp0e := pnt0e^.grp;

    if grp0e < grp1e then
    begin
      grpe  := grp0e;
      line  := pnt0e^.lin;
      polin := pnt1e^.lin;
    end
    else
    begin
      grpe  := grp1e;
      line  := pnt1e^.lin;
      polin := pnt0e^.lin;
    end;

    if lnclos(grpe, line, grpe + 1, polin) then
    begin
      nxtgrp := grpe;
      Result := 1;
      Exit;
    end;
  end;

  if Abs(grp0s - grp1s) < 2 then
  begin
    //if isclos( seq[pnt0s]^, seq[pnt0s + 1]^, seq[pnt1s]^, seq[pnt1s + 1]^ ) > 0 then
    if isclos(pnt0s, pnt1s) > 0 then
    begin
      nxtgrp := grp0s;
      Result := 1;
      Exit;
    end; 
  end;

  if Abs(grp0s - grp1e) < 2 then
  begin
    //if isclos( seq[pnt0s]^, seq[pnt0s + 1]^, seq[pnt1e]^, seq[pnt1e + 1]^ ) > 0 then
    if isclos( pnt0s, pnt1e ) > 0 then
    begin
      nxtgrp := grp0s;
      Result := 1;
      Exit;
    end;
  end;

  if Abs(grp0e - grp1s) < 2 then
  begin
    //if isclos( seq[pnt0e]^, seq[pnt0e + 1]^, seq[pnt1s]^, seq[pnt1s + 1]^ ) > 0 then
    if isclos( pnt0e, pnt1s ) > 0 then
    begin
      nxtgrp := grp0e;
      Result := 1;
      Exit;
    end;
  end;

  if Abs(grp0e - grp1e) < 2 then
  begin
    //if isclos( seq[pnt0e], seq[pnt0e + 1], seq[pnt1e], seq[pnt1e + 1] ) > 0 then
    if isclos( pnt0e, pnt1e ) > 0 then
    begin
      nxtgrp := grp0e;
      Result := 1;
      Exit;
    end;
  end;

  Result := 0;
end;

// from.cpp of thred #3333
function TLCON.lnclos(gp0, ln0,   gp1, ln1: Cardinal): Boolean;
  {begin
    grps  := grp1s;
    lins  := pnt1s^.lin;
    prlin := pnt0s^.lin;
  end;

  if (grps <> 0) and lnclos(grps - 1, prlin, grps, lins) then}
var
  ind0, ind1, cnt0, cnt1: Cardinal;
  pnt0, pnt1            : TArrayOfStitchPoint;//PSMALPNTL;
begin
  if gp1 > (grindpnt - 2) then
  begin
    Result := False;
    Exit;
  end;

  if gp0 = 0 then
  begin
    Result := False;
    Exit;
  end;

  cnt0 := ( grinds[gp0 + 1] - grinds[gp0] ) shr 1;
  ind0 := 0;
  try
    //x2nie will set back the reference so the var will perfectly discardable.
    // as like this: PArrayOfStitchLine(LLines) :=  @LFillPoints[0]; <---- Embroidery_Fill.pas # 1780
    //pnt0 := @lins[ grinds[gp0] ];
    //PArrayOfTSMALPNTL(pnt0) := @lins[ grinds[gp0] ]; //share the data!
    pnt0 := @lins[ grinds[gp0] ]; //share the data!

    while ( (cnt0 > 0) and (pnt0[ind0].lin <> ln0) ) do
    begin
      cnt0 := cnt0 - 1;
      ind0 := ind0 + 2;
    end;

    if cnt0 > 0 then
    begin
      cnt1 := ( grinds[gp1 + 1] - grinds[gp1] ) shr 1;
      ind1 := 0;
      //pnt1 := grinds[gp1];
      //PArrayOfTSMALPNTL(pnt1) := @lins[ grinds[gp1] ]; //share the data!
      pnt1 := @lins[ grinds[gp1] ]; //share the data!

      while ( (cnt1 > 0) and (pnt1[ind1].lin <> ln1) ) do
      begin
        cnt1 := cnt1 - 1;
        ind1 := ind1 + 2;
      end;

      if cnt1 > 0 then
      begin
        //if isclos(lins[pnt0 + ind0], lins[pnt0 + ind0 + 1],
        //          lins[pnt1 + ind1], lins[pnt1 + ind1 + 1]) > 0 then
        if isclos(@pnt0[ind0], @pnt1[ind1]) > 0 then
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
  finally
    //PArrayOfTSMALPNTL(pnt0) := nil;// it is now safely to discard
    //PArrayOfTSMALPNTL(pnt1) := nil;
    //pnt0 := nil;
    //pnt1 := nil;
  end;
end;

function TLCON.isclos(pnt0, pnt1: PStitchPoint): Word;
var
  lo0, hi0, lo1, hi1: Single;
begin
  Inc(pnt0); //[1]
  hi0 := pnt0.x + rgclos;
  Dec(pnt0); //[0]
  lo0 := pnt0.x - rgclos;

  Inc(pnt1); //[1]
  hi1 := pnt1.x + rgclos;
  Dec(pnt1); //[0]
  lo1 := pnt1.x - rgclos;

  if hi0 < lo1 then
  begin
    Result := 0;
    Exit;
  end;

  if hi1 < lo0 then
  begin
    Result := 0;
    Exit;
  end;

  Result := 1;
end;

function TLCON.unvis: Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to (rgcnt - 1) do
  begin
    if visit[i] = 0 then
    begin
      vispnt := i;
      Result := True;
      Break;
    end;
  end;
end;

procedure TLCON.nxtrgn;
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
try
  while notdun(pthlen) <> 0 do
  begin
    Inc(pthlen);

    if (pthlen > 8) then
    begin
      //tpnt=&*seq[rgns[dunrgn].strt];
      
      //tpnt         := rgns[dunrgn].StartLine;
      //PArrayOfTSMALPNTL(tpnt) := @seq[rgns[dunrgn].StartLine]^;
      tpnt := @seq[rgns[dunrgn].StartLine]^;
      dunpnts[0].X := tpnt[0].x;
      dunpnts[0].Y := tpnt[0].y;
      dunpnts[1].X := tpnt[1].x;
      dunpnts[1].Y := tpnt[1].y;

      //tpnt=&*seq[rgns[dunrgn].end];
      //tpnt         := rgns[dunrgn].EndLine;
      //PArrayOfTSMALPNTL(tpnt) := @seq[rgns[dunrgn].EndLine]^;
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

{.$RANGECHECKS OFF}

  indz := 0;
  for ind := 0 to (pthlen - 1) do
  begin
    tmpath[mpathi].skp  := 0;
    tmpath[mpathi].pcon := rgpth[ind].pcon;
    Inc(mpathi);

    visit[pmap[rgpth[ind].pcon].vrt] := 1;
    indz := ind;
  end;
  inc(indz);

  dunrgn := pmap[rgpth[indz - 1].pcon].vrt;

{.$RANGECHECKS ON}
finally
  //PArrayOfTSMALPNTL(tpnt) := nil;
  //tpnt := nil;
end;

end;

procedure TLCON.nxtseq(pthi: Cardinal);
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

function TLCON.nxt(ind: cardinal): cardinal;
begin
	Inc(ind);
	if ind > sids-1 then
		ind:=0;
	result := ind;
end;

//unsigned short prv(unsigned ind){
function TLCON.prv(ind: cardinal): cardinal;
begin
	if ind > 0 then
		dec(ind)
	else
		ind:=sids-1;
	result := ind;
end;

procedure TLCON.durgn(pthi: Cardinal);
var
  i, dun, gdif, mindif, ind, fdif, bdif: Integer;  //Cardinal;
  seqs, seqe                        : Cardinal;
  grpn, grps, grpe                  : Integer;  //Cardinal;
  rgind                             : Cardinal;
  seql : Integer;
  seqn                        : Cardinal;
  len, minlen                       : Double;
  pnts, pnte                        : PStitchPoint;
  bpnt : ^TBSEQPNT;
  
begin
  rgind := mpath[pthi].vrt;
  durpnt := @rgns[rgind];
  grpn  := mpath[pthi].grpn;
  //seqs  := rgns[rgind].StartLine;
  //seqe  := rgns[rgind].EndLine;
  seqs  := durpnt^.StartLine;
  seqe  := durpnt^.EndLine;



  
//  if (mpath[pthi].skp > 0) or ( rstMap(BRJFUX) ... don't translate for now
//  begin

//  end;
  if (mpath[pthi].skp <> 0) or (rstMap(BRKFIX) <> 0) then begin

		if bseq[opnt-1].attr <> SEQBOT then begin
      VerboseProc('1223');
			rspnt(bseq[opnt-2].x,bseq[opnt-2].y);
    end;
		pnts:=@seq[rgind]^;
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
  pnts := @seq[durpnt^.StartLine]^;
  pnte := @seq[durpnt^.EndLine]^;
  //grps := seq[ rgns[rgind].StartLine ]^.grp;
  //grpe := seq[ rgns[rgind].EndLine ]^.grp;
  grps := pnts^.grp;
  grpe := pnte^.grp;

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
          gdif := Integer(seq[ind]^.grp) - lastgrp;
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
          gdif := Integer(seq[ind]^.grp) - grpn;

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
        duseq(seqe, seqs);
        duseq(seqs, seqn);
      end
      else
      begin
        if grps <= grpn then
        begin
          if seql <> seqs then
          begin
            duseq(seql, seqs);
          end;

          duseq(seqs, seqe);

          if ( pthi < (mpathi - 1) ) and (seqe <> seqn) then
          begin
            duseq(seqe, seqn);
          end;
        end
        else
        begin
          if seql <> seqe then
          begin
            duseq(seql, seqe);
          end;

          duseq(seqe, seqs);

          if ( pthi < (mpathi - 1) ) and (seqs <> seqn) then
          begin
            duseq(seqs, seqn);
          end;
        end;
      end;
    end;
  end;
end;

procedure TLCON.brkdun(strt, fin: Cardinal);
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

procedure TLCON.brkseq(strt, fin: Cardinal);
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

      if setseq(ind) <> 0 then
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

      if setseq(ind) <> 0 then
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

procedure TLCON.dunseq(strt, fin: Cardinal);
var
  lin0, lin1 : TArrayOfStitchPoint;
  ind     : Cardinal;
  dy, miny: Single;//Double;
begin
  miny := 1e8;

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

  if miny = (1e8 / 2) then
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
end;

procedure TLCON.duseq(strt, fin: Cardinal);
var
  ind, topbak: Cardinal;
  indz : Integer;
  //seqlin2    : PSMALPNTL; 
begin
  seqlin := nil;
  rstMap(SEQDUN);
  //topbak := seq[strt + 1].lin;
  topbak := TArrayOfStitchPoint(@seq[strt]^)[1].lin;

  if strt > fin then
  begin
    for ind := strt downto fin do
    begin
      if setseq(ind) <> 0 then
      begin
        if setMap(SEQDUN) = 0 then
        begin
          duseq2(ind);
        end
        else
        begin
          //if topbak <> seq[ind + 1].lin then
          if topbak <> TArrayOfStitchPoint(@seq[ind]^)[1].lin then
          begin
            if ind <> 0 then
            begin
              duseq2(ind + 1);
            end;

            duseq2(ind);

            {seqlin2 := @seqlin;
            Inc(seqlin2);
            topbak := seqlin2^.lin;}
            topbak := TArrayOfStitchPoint(@seqlin^)[1].lin
          end;
        end;
      end
      else
      begin
        if rstMap(SEQDUN) <> 0 then
        begin
          duseq2(ind + 1);
        end;

        //seqlin := @seq[ind];
        seqlin := @seq[ind]^;
        movseq(ind);
      end;
      indz := ind;
    end;
    //Dec(indz);//downto

    if rstMap(SEQDUN) <> 0 then
    begin
      duseq2(indz + 1);
    end;

    lastgrp := seqlin^.grp;
  end
  else
  begin
    for ind := strt to fin do
    begin
      if setseq(ind) <> 0 then
      begin
        if setMap(SEQDUN) = 0 then
        begin
          duseq2(ind);
        end
        else
        begin
          //if topbak <> seq[ind + 1].lin then
          if topbak <> TArrayOfStitchPoint(@seq[ind]^)[1].lin then
          begin
            if ind <> 0 then
            begin
              duseq2(ind - 1);
            end;

            duseq2(ind);

            //seqlin2 := @seqlin;
            //Inc(seqlin2);

            //topbak := seqlin2^.lin;
            topbak := TArrayOfStitchPoint(@seqlin^)[1].lin
          end;
        end;
      end
      else
      begin
        if rstMap(SEQDUN) <> 0 then
        begin
          if ind <> 0 then
          begin
            duseq2(ind - 1);
          end;
        end;

        seqlin := @seq[ind]^;
        movseq(ind);
      end;
      indz := ind;
    end;
    //Inc(indz); //for to

    if rstMap(SEQDUN) <> 0 then
    begin
      if indz <> 0 then   
      begin
        duseq2(indz - 1);
      end;
    end;

    lastgrp := seqlin^.grp;
  end;
end;

procedure TLCON.rspnt(fx, fy: Single);
begin
  VerboseProc('RSPNT');
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
procedure TLCON.duseq1;
var
  Lseqlin: TArrayOfStitchPoint;
begin
  Lseqlin := @seqlin^;
  VerboseProc('duseq1 1814');
  rspnt( (Lseqlin[1].x - Lseqlin[0].x) / 2 + Lseqlin[0].x,
         (Lseqlin[1].y - Lseqlin[0].y) / 2 + Lseqlin[0].y );
end;

procedure TLCON.duseq2(ind: Cardinal);
var
  Lseqlin: TArrayOfStitchPoint;
begin
  seqlin  := @seq[ind]^;
  Lseqlin := @seqlin^;
  VerboseProc('duseq2 1825');
  rspnt( (Lseqlin[1].x - Lseqlin[0].x) / 2 + Lseqlin[0].x,
         (Lseqlin[1].y - Lseqlin[0].y) / 2 + Lseqlin[0].y );
end;

procedure TLCON.movseq(ind: Cardinal);
var
  lin : PStitchPoint;
begin
  VerboseProc('MOVSEQ');
  lin := @seq[ind]^;
  bseq[opnt].attr := SEQBOT;
  bseq[opnt].x    := lin^.x;
  bseq[opnt].y    := lin^.y;
  FVerboseProc(format('bseq[%d] X%.2f Y%.2f =%d',[opnt,bseq[opnt].x, bseq[opnt].y, bseq[opnt].attr ]));
  Inc(opnt);
  Inc(lin);
  bseq[opnt].attr := SEQTOP;
  bseq[opnt].x    := lin^.x;
  bseq[opnt].y    := lin^.y;
  FVerboseProc(format('bseq[%d] X%.2f Y%.2f =%d',[opnt,bseq[opnt].x, bseq[opnt].y, bseq[opnt].attr ]));
  Inc(opnt);
end;

function TLCON.notdun(lvl: Cardinal): Cardinal;
var
  ind  : Cardinal;
  tpiv : Integer;
  pivot: Integer;
begin
{.$RANGECHECKS OFF}

  pivot := lvl - 1;

  //rgpth         := @tmpath[mpathi];
  //PArrayOfTRGSEQ(rgpth) := @tmpath[mpathi];
  rgpth := @tmpath[mpathi];
  try
  rgpth[0].pcon := minds[dunrgn];
  rgpth[0].cnt  := minds[dunrgn + 1] - rgpth[0].pcon;

  for ind := 1 to (lvl - 1) do
  begin
    rgpth[ind].pcon := minds[pmap[rgpth[ind - 1].pcon].vrt];
    rgpth[ind].cnt  := minds[pmap[rgpth[ind - 1].pcon].vrt + 1] - rgpth[ind].pcon;
  end;

  while (visit[pmap[rgpth[pivot].pcon].vrt] <> 0) and (pivot >= 0) do
  begin
    Dec(rgpth[pivot].cnt);
    if (rgpth[pivot].cnt) > 0 then
    begin
      rgpth[pivot].pcon := rgpth[pivot].pcon + 1;
    end
    else
    begin
      tpiv := pivot;

      repeat
        Dec(tpiv);

        if tpiv < 0 then
        begin
          Result := 1;
          Exit;
        end;

        rgpth[tpiv].cnt  := rgpth[tpiv].cnt - 1;
        rgpth[tpiv].pcon := rgpth[tpiv].pcon + 1;
      until not (rgpth[tpiv].cnt <> 0);

      if tpiv < 0 then
      begin
        Result := 1;
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
          Dec(rgpth[0].cnt);
          if (rgpth[0].cnt) <> 0 then
          begin
            rgpth[0].pcon := rgpth[0].pcon + 1;
          end
          else
          begin
            Result := 1;
            Exit;
          end;
        end;

        Inc(tpiv);
      end;
    end;
  end;

  Result := 0;
  finally
    //PArrayOfTRGSEQ(rgpth) := nil;
  end;

{.$RANGECHECKS ON}
end;

function TLCON.reglen(reg: Cardinal): Double;
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
  LPoints := TArrayOfStitchPoint(@seq[ rgns[reg].StartLine ]^);
  pnts[0] := @LPoints[0];
  pnts[1] := @LPoints[1];

  //PArrayOfTSMALPNTL(LPoints) := @seq[ rgns[reg].EndLine ]^;
  LPoints := TArrayOfStitchPoint(@seq[ rgns[reg].EndLine ]^);
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
end;


procedure TLCON.ResetVars(Sender: TObject);
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

destructor TLCON.Destroy;
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



function TLCON.chkmax(arg0,arg1: Cardinal): Boolean;
begin
	result := False;

	if(arg0 and MAXMSK) <> 0 then
		result := True;
	if(arg1 and MAXMSK) <> 0 then
		result := True;
	if((arg1+arg0) and MAXMSK) <> 0 then
		result := True;
end;

procedure TLCON.bakseq();
var

  cnt,rcnt: Integer;
	ind,rit: Integer;
	dif,pnt,stp : TDUBPNTL;
	len,rslop,
	usesiz2,
	usesizh,
	usesiz9,
	stspac2: Double;
  selectedForm__xat : cardinal;
label
  blntop, blntopx,
  blntbot, blntbotx,
  toplab, toplabx,
  botlab, botlabx;
begin

{$IFDEF BUGBAK}

	for seqpnt:=0 to opnt do
	begin
		oseq[seqpnt].x:=bseq[seqpnt].x;
		oseq[seqpnt].y:=bseq[seqpnt].y;
	end;
	//selectedForm->fmax=6000;
{$ELSE}
  selectedForm__xat := 0;// AT_SQR;
	usesiz2:=usesiz*2;
	usesizh:=usesiz/2;
	usesiz9:=usesiz/9;
	stspac2:= FIni.StitchSpacing*2;

	seqpnt:=0;
	rstMap(FILDIR);
	ind:=opnt-1;
	oseq[seqpnt].x:=bseq[ind].x;
	oseq[seqpnt].y:=bseq[ind].y;
	Inc(seqpnt);
	s_Pnt.x:=bseq[ind].x;
	s_Pnt.y:=bseq[ind].y;
	Dec(ind);
	while(ind>0) do begin

		rcnt:=ind mod RITSIZ;
		if seqpnt>MAXSEQ then begin

			seqpnt:=MAXSEQ-1;
			Exit;
		end;
		rit:=ROUND(bseq[ind].x / stspac2);
		dif.x:=bseq[ind].x-bseq[ind+1].x;
		dif.y:=bseq[ind].y-bseq[ind+1].y;
		if dif.y <> 0 then
			rslop:=dif.x/dif.y
		else
			rslop:=1e99;

		case bseq[ind].attr of

      SEQTOP:
      begin

        //if(selectedForm->xat&AT_SQR)
        if selectedForm__xat and AT_SQR <> 0 then
        begin

          if toglMap(FILDIR) then  begin

            oseq[seqpnt].x:=bseq[ind-1].x;
            oseq[seqpnt].y:=bseq[ind-1].y;
            Inc(seqpnt);
            cnt:=ceil(bseq[ind].y/usesiz);
  blntop:
            oseq[seqpnt].y:=cnt*usesiz+(rit mod seqtab[rcnt])*usesiz9;
            if oseq[seqpnt].y>bseq[ind].y then
              goto blntopx;
            dif.y:=oseq[seqpnt].y-bseq[ind].y;
            oseq[seqpnt].x:=bseq[ind].x;
            Inc(seqpnt);
            Inc(cnt);
            goto blntop;
  blntopx:;
            oseq[seqpnt].x:=bseq[ind].x;
            oseq[seqpnt].y:=bseq[ind].y;
            Inc(seqpnt);
          end
          else begin

            oseq[seqpnt].x:=bseq[ind].x;
            oseq[seqpnt].y:=bseq[ind].y;
            Inc(seqpnt);
            cnt:=floor(bseq[ind].y/usesiz);
  blntbot:;
            oseq[seqpnt].y:=cnt*usesiz-((rit+2) mod seqtab[rcnt])*usesiz9;
            if(oseq[seqpnt].y<bseq[ind-1].y) then
              goto blntbotx;
            dif.y:=oseq[seqpnt].y-bseq[ind-1].y;
            oseq[seqpnt].x:=bseq[ind].x;
            Inc(seqpnt);
            Dec(cnt);
            goto blntbot;
  blntbotx:;
            oseq[seqpnt].x:=bseq[ind-1].x;
            oseq[seqpnt].y:=bseq[ind-1].y;
            Inc(seqpnt);
          end
        end
        else begin

          cnt:=ceil(bseq[ind+1].y/usesiz);
  toplab:;
          oseq[seqpnt].y:=cnt*usesiz+(rit mod seqtab[rcnt])*usesiz9;
          if(oseq[seqpnt].y>bseq[ind].y) then
            goto toplabx;
          dif.y:=oseq[seqpnt].y-bseq[ind+1].y;
          dif.x:=rslop*dif.y;
          oseq[seqpnt].x:=bseq[ind+1].x+dif.x;
          Inc(seqpnt);
          Inc(cnt);
          goto toplab;
  toplabx:;
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

          cnt:=floor(bseq[ind+1].y/usesiz);
  botlab:;
          oseq[seqpnt].y:=cnt*usesiz-((rit+2) mod seqtab[rcnt])*usesiz9;
          if(oseq[seqpnt].y<bseq[ind].y) then
            goto botlabx;
          dif.y:=oseq[seqpnt].y-bseq[ind+1].y;
          dif.x:=rslop*dif.y;
          oseq[seqpnt].x:=bseq[ind+1].x+dif.x;
          Inc(seqpnt);
          Dec(cnt);
          goto botlab;
  botlabx:;
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
            cnt:=Ceil(len/usesiz-1);
            if(chkmax(cnt,seqpnt)) or ((cnt+seqpnt)>MAXSEQ-3) then
              Exit;
            stp.x:=dif.x/cnt;
            stp.y:=dif.y/cnt;
            while cnt > 0 do begin

              pnt.x:=pnt.x+stp.x;
              pnt.y:=pnt.x+stp.y;
              oseq[seqpnt].x:=pnt.x;
              oseq[seqpnt].y:=pnt.y;
              Inc(seqpnt);
              Dec(cnt);
            end;
          end;
        end;
        oseq[seqpnt].x:=bseq[ind].x;
        oseq[seqpnt].y:=bseq[ind].y;
        Inc(seqpnt);
      end;
    end;
    dec(ind);
  end;
{$ENDIF}
end;




end.
