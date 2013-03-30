unit Embroidery_Fill_LCON;

interface
uses
  GR32, Thred_Types,
  Embroidery_Items;

procedure LCON(AStitchForm: TEmbroideryItem);

implementation

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

function comp(APoint1, APoint2: TSMALPNTL): Integer;
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


procedure LCON(AStitchForm: TEmbroideryItem);
var
  i,j,k   : Integer;
  e       : Integer;
  blin    : Cardinal;
  sind    : Cardinal;
  cnt     : Cardinal;
  priorGrp    : Cardinal;
  opnt    : Cardinal;  // output pointer for sequencing
  tcon    : SmallInt;
  tpnt    : Cardinal;
  lconskip: Boolean;

    rgnSeq    : array of TRGN;                   // a list of regions for sequencing
    srgns   : array of Cardinal;               // an array of subregion starts
    grinds  : array of Cardinal;               // array of group indices for sequencing
    visit   : array of Byte;                   // visited character map for sequencing
    minds   : array of Cardinal;

  tableRegions : array of TRGN;
  tsrgns: array of Cardinal;
  tmap  : array of TRCON;
  rgcnt,
  LineCount : Integer;
  spnt,ii: Integer;
  lins  : TArrayOfStitchPoint;
  seq   : TArrayOfPStitchPoint;               // sorted pointers to lins
begin
//-- lcon() begin --------------------------------------------------------------

  PArrayOfStitchPoint(lins) := @AStitchForm.Stitchs^[0];
  spnt := Length(lins);


  //if form has lines
  LineCount := 0;
  if spnt > 0 then
  begin
    SetLength( seq, spnt div 2);

    // 1. copy LIN to SEQ, copy the only 1st-point of each line
    for j :=  0 to (spnt div 2) -1 do
    begin
      seq[j] := @lins[j * 2];
      LineCount := j; //I dont trust the iterator J since it may be undefined after loop.
    end;

    //this is sorting the "seq" by this priority order: by Vertice, by MostLeft, by MostTop
    PointSort(seq, 0, LineCount, sqcomp);
  end;

  //FIND REGIONS COUNT
  //DIVIDE "SEQ" (LINE) BY VERTICES.

  SetLength(tableRegions, spnt); //maximum posible length = spnt
  tableRegions[0].StartLine := 0;
  blin := seq[0].lin;
  rgcnt := 0;
  j := 0;
  for i := 0 to (LineCount - 1) do
  begin
    if blin <> seq[i]^.lin then
    begin
      tableRegions[rgcnt].EndLine := i - 1;
      Inc(rgcnt);
      tableRegions[rgcnt].StartLine := i;
      blin := seq[i]^.lin;
    end;
    j := i; //I dont trust the iterator "i" since it may be undefined after loop.
  end;
  tableRegions[rgcnt].EndLine := j - 1;
  Inc(rgcnt);
  //this time, region_count was reached.


  //x2nie immediatelly write the RGNS
  for i := 0 to rgcnt-1 do
  begin
    for j :=tableRegions[i].StartLine  to tableRegions[i].EndLine do
    begin
      //lins[j].rgns := i;
      seq[j]^.rgnSeq := i;
    end;
  end;


  //Region. copy table region into real Region.
  SetLength(rgnSeq, rgcnt);
  SetLength(visit, rgcnt);

  for i := 0 to (rgcnt - 1) do
  begin
    rgnSeq[i].StartLine := tableRegions[i].StartLine;
    rgnSeq[i].EndLine   := tableRegions[i].EndLine;
    rgnSeq[i].cntbrk    := 0;
    visit[i]          := 0;
  end;

  tsrgns := nil;
  sind   := 0;

//this each region is identically equal as shape.SIDE

  //We scan per each region
  for i := 0 to (rgcnt - 1) do
  begin
    cnt := 0;


    //FIND TOTAL COUNT OF BARS FOR EACH REGION.
    
    //do that in a region having several LINE
    if (rgnSeq[i].EndLine - rgnSeq[i].StartLine) > 1 then
    begin
      priorGrp := seq[ rgnSeq[i].StartLine ]^.grp;
      
      //Okay, we now scanning per each LINE, from second bar.
      for e := (rgnSeq[i].StartLine + 1) to rgnSeq[i].EndLine do
      begin
        Inc(priorGrp);

        //Is it in next bar ?
        if seq[e]^.grp <> priorGrp then
        begin
          if cnt = 0 then
          begin
            rgnSeq[i].brk := sind; //start break
          end;

          Inc(cnt);
          priorGrp := seq[e]^.grp;

          SetLength( tsrgns, Length(tsrgns) + 1 );
          tsrgns[sind] := e;
          Inc(sind);
        end;
      end;
    end;

    rgnSeq[i].cntbrk := cnt;  // cnt = total count of bar

  end;

  //x2nie immediatelly write the RGNS
  for i := 0 to rgcnt-1 do
  begin
    for j :=rgnSeq[i].StartLine  to rgnSeq[i].EndLine do
    begin
      seq[j]^.brk := rgnSeq[i].brk;
      seq[j]^.cntbrk := rgnSeq[i].cntbrk;
    end;
  end;


  SetLength(srgns, sind);
  if sind > 0 then
  begin
    for i := 0 to (sind - 1) do
    begin
      srgns[i] := tsrgns[i];
    end;
  end;

{  
  tmap := nil;
  SetLength(minds, rgcnt + 1);

  opnt := 0;
  if rgcnt > 1 then
  begin
    e  := 0;
    cpnt := 0;

    for i := 0 to (rgcnt - 1) do
    begin
      minds[i] := cpnt;
      cnt        := 0;
      rgclos     := 0;

      for e := 0 to (rgcnt - 1) do
      begin
        if i <> e then
        begin
          tcon := regclos(i, e);

          if tcon > 0 then
          begin
            SetLength(tmap, Length(tmap) + 1);
            tmap[cpnt].con  := tcon;
            tmap[cpnt].grpn := nxtgrp;
            tmap[cpnt].vrt  := e;

            Inc(cpnt);
            Inc(cnt);
          end;
        end;
      end;

      while (cnt = 0) do
      begin
        rgclos := rgclos + FIni.StitchSpace;
        cnt    := 0;

        for e := 0 to (rgcnt - 1) do
        begin
          if i <> e then
          begin
            tcon := regclos(i, e);

            if tcon <> 0 then
            begin
              SetLength(tmap, Length(tmap) + 1);
              tmap[cpnt].con  := tcon;
              tmap[cpnt].grpn := nxtgrp;
              tmap[cpnt].vrt  := e;

              Inc(cpnt);
              Inc(cnt);
            end;
          end;
        end;
      end;
    end;

    minds[i] := cpnt;
    SetLength(pmap, cpnt + 1);
    for i := 0 to (cpnt - 1) do
    begin
      pmap[i].con  := tmap[i].con;
      pmap[i].vrt  := tmap[i].vrt;
      pmap[i].grpn := tmap[i].grpn;
    end;

    // find the leftmost region
    priorGrp := $FFFFFFFF;
    e  := 0;
    for i := 0 to (rgcnt - 1) do
    begin
      tpnt := rgns[i].StartLine;

      if seq[tpnt].grp < priorGrp then
      begin
        priorGrp := seq[tpnt].grp;
        e  := i;
      end; 
    end;

    opnt   := 0;
    // find the leftmost region in pmap
    mpathi   := 1;
    lconskip := False;

    for i := 0 to (cpnt - 1) do
    begin
      if pmap[i].vrt = e then
      begin
        lconskip := True;
        Break;
      end;
    end;

    if not lconskip then
    begin
      pmap[cpnt].vrt  := e;
      pmap[cpnt].grpn := 0;
      i             := cpnt; 
    end;

    // set the first entry in the temporary path to the leftmost region
    tmpath[0].pcon := i;
    tmpath[0].cnt  := 1;
    tmpath[0].skp  := 0;
    visit[e]     := 1;
    dunrgn         := e;

    while unvis() do
    begin
      nxtrgn();
    end;

    e := 0;
    cnt := $FFFFFFFF;

    for i := 0 to (mpathi - 1) do
    begin
      mpath[e].skp := tmpath[i].skp;

      if tmpath[i].pcon = $FFFFFFFF then
      begin
        mpath[e].vrt := tmpath[i].cnt;
        cnt            := tmpath[i].cnt;

        Inc(e);
      end
      else
      begin
        if tmpath[i].pcon <> cnt then
        begin
          cnt            := tmpath[i].pcon;
          mpath[e].vrt := pmap[tmpath[i].pcon].vrt;

          Inc(e);
        end;
      end;
    end;

    mpathi := i;
    mpath0 := 0;

    for i := 0 to (mpathi - 1) do
    begin
      nxtseq(i);
    end;

    e := (LineCount shr 5) + 1;

    SetLength(seqmap, e);
    for i := 0 to (e - 1) do
    begin
      seqmap[i] := 0;
    end;

    for i := 0 to (rgcnt - 1) do
    begin
      visit[i] := 0;
    end;

    lastgrp := 0;

    for i := 0 to (mpath0 - 1) do
    begin
      if not unvis() then
      begin
        Break;
      end;

      durgn(i);
    end;
  end
  else
  begin
    SetLength(pmap, 1);
    SetLength(mpath, 1);

    e := (LineCount shr 5) + 1;
    SetLength(seqmap, e);

    for i := 0 to (e - 1) do
    begin
      seqmap[i] := 0;
    end;

    lastgrp       := 0;
    mpath[0].vrt  := 0;
    mpath[0].grpn := seq[rgns[0].EndLine].grp;
    mpath[0].skp  := 0;

    durgn(0);
  end;

  Memo1.Lines.Clear;
{  Memo1.Lines.Add( 'ind: ' + IntToStr(ind) );
  Memo1.Lines.Add('');
  for ii := 0 to (rgcnt - 1) do
  begin
    Memo1.Lines.Add( 'i:' + IntToStr(visit[ii]) );
  end;
  Memo1.Update;  }

  SetLength(tableRegions, 0);
  tableRegions := nil;

  SetLength(tmap, 0);
  tmap := nil;
  //reset
  PArrayOfStitchPoint(lins) := nil;


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
end.
