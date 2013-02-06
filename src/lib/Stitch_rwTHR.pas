unit Stitch_rwTHR;

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
 * The Initial Developer of the Original Code are
 *
 * Marion McCoskey  <>
 * x2nie - Fathony Luthfillah  <x2nie@yahoo.com>
 *
 * Contributor(s):
 *
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
  Classes, SysUtils, Graphics,
  gmCore_rw, Stitch_items ;

{$DEFINE LOADFORMS}

type
  TStitchTHRConverter = class(TgmConverter)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(AStream: TStream; ACollection: TCollection); override;
    //procedure LoadItemFromString(Item :TgmSwatchItem; S : string);
    //procedure LoadItemFromStream(Stream: TStream; AItem: TCollectionItem); virtual;
    procedure SaveToStream(AStream: TStream; ACollection: TCollection); override;
    //procedure SaveItemToStream(Stream: TStream; AItem: TCollectionItem); virtual; abstract;
    class function WantThis(AStream: TStream): Boolean; override;
    //constructor Create; virtual;
  end;

implementation

uses
  Math,
  Thred_Types, Thred_Constants,
  GR32, GR32_Polygons
  //, GR32_LowLevel
  ;

{ TStitchTHRConverter }

constructor TStitchTHRConverter.Create;
begin
  inherited;

end;


procedure TStitchTHRConverter.LoadFromStream(AStream: TStream;
  ACollection: TCollection);

const
  LMAXFORMS = 64;  
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  formpnt,
  vervar,i,j,red : Integer;
  sthed : TSTRHED;
  item  : TSHRTPNT;
  hedx : TSTREX;
  LDesign : TStitchList;
  c : TColor;
  c16 : T16Colors;
  LColors : TArrayOfTColor;
  buf : array[0..17] of Char;
  LBytes : T16Byte;
  zum0 : TPoint;
  zRct : TRect; 

  LTempstchs, Lstchs : TArrayOfTSHRTPNT;
  Lflts,
  Lclps : TArrayOfFloatPoint;//array of TFLPNT;
  Lsatks :TArrayOfTSATCON;
  Ltxpnts : array of TTXPNT;
  Lfrmlstx : array of TFRMHEDO;
  Lfrmx : TFRMHEDO;

  LTempFormlst: Array[0..LMAXFORMS-1] Of TFRMHED_STREAM;
  LFormCount,LFormStreamCount : integer;
  Lformlst : TArrayOfTFRMHED;
  Lform : TFRMHED;
  clpad,satkad,fltad : Integer;

  procedure xofrm();
  var ind : Cardinal;
  begin
    //frmlstx=(FRMHEDO*)&bseq;
    SetLength(Lformlst, Length(Lfrmlstx));
    //FillMemory(&bseq,0,sizeof(FRMHED)*formpnt);
    FillChar(Lformlst[0], SizeOf(TFRMHED) * formpnt, 0);
    for ind :=0 to formpnt -1 do
      Move(Lformlst[ind], Lfrmlstx[ind],sizeof(TFRMHEDO));
  end;

  function adflt(cnt: Cardinal): TArrayOfFloatPoint;
//#2381    FLPNT* adflt(unsigned cnt){
//#2382
//#2383        unsigned ind=fltad;
//#2384
//#2385        if(fltad+cnt>MAXFLT)
//#2386            tabmsg(IDS_FRMOVR);
//#2387        fltad+=cnt;
//#2388        return &flts[ind];                                                                   
//#2389    }

  //P :PFloatPoint;

  var i,ind : Cardinal;
  begin
	  ind := fltad;
    if(fltad+cnt>MAXFLT) then
      raise Exception.Create(IDS_FRMOVR);
    Inc(fltad,cnt);
    Setlength(result, cnt);

    //TArrayOfFloatPoint((Result) := TArrayOfFloatPoint(pointer(Lflts[ind]));
    //move(Lflts[ind], result[0], sizeof(TFloatPoint) * cnt);
    //P := @LFLTS[0];
    //inc(p,ind);
    //move(p^, result[0], sizeof(TFloatPoint) * cnt);
    for i := 0 to cnt-1 do
    begin
      result [i] := Lflts[i + ind];
    end;
  end;

  procedure CopyHed(var Des: TFRMHED; src: TFRMHED);
  begin
    with des do
    begin
      at  :=  src.at;
      sids  :=  src.sids;
      typ  :=  src.typ;
      fcol  :=  src.fcol;
      bcol  :=  src.bcol;
      nclp  :=  src.nclp;
      flt  :=  nil;//src.flt;
      //sacang  := nil;// src.sacang;
      clp  :=  nil;//src.clp;
      stpt  :=  src.stpt;
      wpar  :=  src.wpar;
      rct  :=  src.rct;
      ftyp  :=  src.ftyp;
      etyp  :=  src.etyp;
      fspac  :=  src.fspac;
      flencnt  :=   src.flencnt;
      angclp  := src.angclp;
      esiz :=  src.esiz;
      espac :=  src.espac;
      elen  :=  src.elen;
      res  :=  src.res;
      xat :=  src.xat;
      fmax :=  src.fmax;
      fmin :=  src.fmin;
      emax :=  src.emax;
      emin :=  src.emin;
      dhx  :=  src.dhx;
      strt :=  src.strt;
      endp  :=  src.endp;
      uspac :=  src.uspac;
      ulen :=  src.ulen;
      uang :=  src.uang;
      wind :=  src.wind;
      txof  :=  src.txof;
      ucol :=  src.ucol;
      cres  :=  src.cres;

    end;
  end;

  procedure j_adflt(var result : TArrayOfFloatPoint;cnt: Cardinal);
//#2381    FLPNT* adflt(unsigned cnt){
//#2382
//#2383        unsigned ind=fltad;                                                                   
//#2384                                                                           
//#2385        if(fltad+cnt>MAXFLT)                                                                   
//#2386            tabmsg(IDS_FRMOVR);                                                               
//#2387        fltad+=cnt;                                                                   
//#2388        return &flts[ind];                                                                   
//#2389    }
  var
  P :PFloatPoint;
  var ind : Cardinal;
  begin
	  ind := fltad;
    if(fltad+cnt>MAXFLT) then
      raise Exception.Create(IDS_FRMOVR);
    Inc(fltad,cnt);
    Setlength(result, cnt);

    //TArrayOfFloatPoint((Result) := TArrayOfFloatPoint(pointer(Lflts[ind]));
    //move(Lflts[ind], result[0], sizeof(TFloatPoint) * cnt);
    P := @LFLTS[0];
    inc(p,ind);
    move(p^, result[0], sizeof(TFloatPoint) * cnt);


  end;

  function adsatk(cnt: Cardinal) : TArrayOfTSATCON;
  var ind : Cardinal;
  begin
	  ind:=satkad;
    Inc(satkad, cnt);
    result := TArrayOfTSATCON(@Lsatks[ind]);
  end;

  function isclp(find: Cardinal):Boolean;
  begin
  	Result :=((1 shl Lformlst[find].ftyp) and clpmap) <> 0;
  end;

  function iseclp(find: Cardinal): Boolean;
  begin
    result := (Lformlst[find].etyp=EGCLP) or (Lformlst[find].etyp= EGPIC) or (Lformlst[find].etyp=EGCLPX);
  end;

  function iseclpx(find: Cardinal): boolean;
  begin
	  result := iseclp(find) and (Lformlst[find].nclp <> 0);
  end;

  function adclp(cnt: Cardinal): TArrayOfFloatPoint;
  var ind : Cardinal;
  begin
	  ind:=clpad;

    Inc(clpad,cnt);
    result := TArrayOfFloatPoint(@Lclps[ind]);
  end;

begin
  LDesign := TStitchList(ACollection.Owner);
  LDesign.Clear;
  
  //here we go!
  //validation of stream is already done.
  
//#5711                if(tchr=='t'){
//#5712
//#5713                    ReadFile(hFil,(STRHED*)&sthed,sizeof(STRHED),&red,NULL);
//  red := Stream.Read(buf[0],SizeOf(buf));

  AStream.Read(sthed,SizeOf(TSTRHED) );
  LDesign.Header := sthed;
  if sthed.led and $ffffff <> $746872 then                   //#5714                    if((sthed.led&0xffffff)==0x746872){
        raise Exception.Create({IDS_SHRTF} IDS_NOTHR);        //#5717


//#5714                    if((sthed.led&0xffffff)==0x746872){
//#5715                                                                           
//#5716                        if(red!=sizeof(STRHED)){                                                   
//#5717                                                                           
//#5718                            tabmsg(IDS_SHRTF);                                               
//#5719                            return;                                               
//#5720                        }
//#5721                        vervar=(sthed.led&0xff000000)>>24;
  vervar := (sthed.led and $ff000000) shr 24;
  case vervar of
//#5722                        switch(vervar){
//#5723
//#5724                        case 0:
    0 :
    begin
      FillChar(hedx, SizeOf(TSTREX),0);
      if sthed.hup = SMALHUP then
      begin
        hedx.xhup := SHUPX;
        hedx.yhup := SHUPY;
      end
      else
      begin
        hedx.xhup := LHUPX;
        hedx.yhup := LHUPY;
        sthed.hup := LARGHUP;
      end;  


//#5725
//#5726                            if(hed.hup==SMALHUP){
//#5727
//#5728                                zum0.x=ini.hupx=SHUPX;
//#5729                                zum0.y=ini.hupy=SHUPY;
//#5730                            }
//#5731                            else{
//#5732
//#5733                                zum0.x=ini.hupx=LHUPX;
//#5734                                zum0.y=ini.hupy=LHUPY;
//#5735                                hed.hup=LARGHUP;
//#5736                            }
//#5737                            ritfnam(ini.desnam);
//#5738                            strcpy(fildes,ini.desnam);
//#5739                            strcpy(hedx.modnam,ini.desnam);
//#5740                            break;
//#5741

    end;

//#5742                        case 1:
//#5743                        case 2:
    1,2 :
    begin
//#5744
//#5745                            ReadFile(hFil,(STREX*)&hedx,sizeof(STREX),&red,NULL);
      AStream.Read(hedx, SizeOf(TSTREX));
//#5746                            if(red!=sizeof(STREX)){
//#5747
//#5748                                tabmsg(IDS_SHRTF);
//#5749                                return;
//#5750                            }
//#5751                            ini.hupx=zum0.x=hedx.xhup;
//#5752                            ini.hupy=zum0.y=hedx.yhup;
      zum0.X := Round(hedx.xhup);
      zum0.Y := Round(hedx.yhup);
//#5753                            redfnam(fildes);
//#5754                            break;
    end
    
    else
      Exit;
//#5755
//#5756                        default:
//#5757
//#5758                            tabmsg(IDS_NOTVER);
//#5759                            return;
//#5760                        }

  end;

  LDesign.HeaderEx := hedx;

//#5761                        zRct.bottom=zRct.left=0;
//#5762                        zRct.right=zum0.x=ini.hupx;
//#5763                        zRct.top=zum0.y=ini.hupy;
  zRct := MakeRect(0,0, zum0.X, zum0.Y);
  
//#5764                        hed.stchs=sthed.stchs;
//#5765                        ReadFile(hFil, (SHRTPNT*)stchs, hed.stchs*sizeof(SHRTPNT), &red, NULL);
  SetLength(Lstchs, sthed.stchs);
  AStream.Read(Lstchs[0], sthed.stchs * SizeOf(TSHRTPNT));
  for i := 0 to sthed.stchs do
  begin
    //Hey, Thred is updwon side. that is the first Y is in bottom, so we convert to delphi style
    Lstchs[i].y := {hedx.yhup -}(hedx.yhup - Lstchs[i].y);
  end;

  LDesign.Stitchs := Lstchs;
  {for i := 0 to sthed.stchs -1 do
  begin
    //Stream.Read(item,red);
    //if red = SizeOf(item) then
    LoadItemFromStream(Stream, LCollection.Add);
  end;}

//#5766                        if(red!=hed.stchs*sizeof(SHRTPNT)){
//#5767
//#5768                            hed.stchs=red/sizeof(SHRTPNT);
//#5769                            prtred();
//#5770                            return;
//#5771                        }

//#5772                        ReadFile(hFil,(TCHAR*)bnam,16,&red,0);
//#5773                        tred=red;
//#5774                        if(red!=16){
//#5775
//#5776                            bnam[0]=0;
//#5777                            prtred();
//#5778                            return;
//#5779                        }
  red := AStream.Read(buf[0],16);
  LDesign.BName := buf;
//  if red <> 16 then    Exit;

//#5780                        ReadFile(hFil,(COLORREF*)&stchBak,4,&red,0);
//#5781                        tred+=red;
//#5782                        if(red!=4){
//#5783
//#5784                            stchBak=ini.stchBak;
//#5785                            prtred();
//#5786                            return;
//#5787                        }
  AStream.Read(c,4);
  LDesign.BgColor := c;
//#5788                        hStchBak=CreateSolidBrush(stchBak);


//#5789                        ReadFile(hFil,(COLORREF*)useCol,64,&red,0);
//#5790                        tred+=red;
//#5791                        if(red!=64){
//#5792
//#5793                            prtred();
//#5794                            return;
//#5795                        }
  SetLength(LColors, 16);
  AStream.Read(c16[0], 64);
  for i := 0 to 15 do
  begin
    LColors[i] := c16[i];
  end;

  LDesign.Colors := LColors;

//#5796                        ReadFile(hFil,(COLORREF*)custCol,64,&red,0);
//#5797                        tred+=red;
//#5798                        if(red!=64){
//#5799
//#5800                            prtred();
//#5801                            return;
//#5802                        }
  AStream.Read(c16[0], 64);
//  LDesign.CustomColors := LColors;

  //THREAD SIZE (ON SCREEN)
//#5803                        ReadFile(hFil,(TCHAR*)msgbuf,16,&red,0);
//#5804                        tred+=red;
//#5805                        if(red!=16){
//#5806
//#5807                            prtred();
//#5808                            return;
//#5809                        }
  red := AStream.Read(LBytes[0],16);
  //LCollection.BName := Bytes;
  if red <> 16 then
    Exit;
  for i := 0 to 15 do
  begin
     LBytes[i] := LBytes[i] * 10;
  end;
  LDesign.ThreadSize := LBytes;
//#5810                        for(ind=0;ind<16;ind++)
//#5811                            thrdSiz[ind][0]=msgbuf[ind];


//#5812                        formpnt=sthed.fpnt;
//#5813                        if(formpnt>MAXFORMS)
//#5814                            formpnt=MAXFORMS;
//#5815                        inf=0;ing=0,inh=0;
  formpnt := min(sthed.fpnt, MAXFORMS);

  //FORM
  {$IFNDEF LOADFORMS}
    formpnt := 0;
  {$ENDIF}
//#5816                        if(formpnt){
  if formpnt > 0 then
  begin
//#5817
//#5818                            ind=fltad=satkad=clpad=0;
    fltad := 0;
    satkad := 0;
    clpad := 0;
//#5819                            msgbuf[0]=0;
//#5820                            if(vervar<2){

    //OLD FORM HEADER
    if vervar < 2 then
    begin
//#5821
//#5822                                frmlstx=(FRMHEDO*)&bseq;
      SetLength(Lfrmlstx, formpnt);
      //Stream.Read(Lfrmlstx[0], SizeOf(TFRMHEDO) * formpnt);
      for i := 0 to formpnt-1 do
      begin
        AStream.Read(Lfrmlstx[i], SizeOf(TFRMHEDO) );
      end;

//#5823                                ReadFile(hFil,(FRMHEDO*)frmlstx,formpnt*sizeof(FRMHEDO),&red,0);
//#5824                                if(red!=formpnt*sizeof(FRMHEDO)){
//#5825
//#5826                                    formpnt=red/sizeof(FRMHEDO);
//#5827                                    setMap(BADFIL);
//#5828                                }
//#5829                                xofrm();
      xofrm();                                      
//#5830                            }
    end
    else
    begin  //VER 2 FORM HEADER
//#5831                            else{                                               
//#5832
      SetLength(Lformlst, formpnt);
      //SetLength(LTempFormlst, LMAXFORMS); //64
      LFormCount := 0;
      while LFormCount < formpnt do
      begin
        LFormStreamCount := min(LMAXFORMS, formpnt - LFormCount);
        //fillchar(lformlst[0], sizeof(tfrmhed) * formpnt, 0);
        AStream.Read(LTempFormlst[0], SizeOf(TFRMHED)* LFormStreamCount);
        //SetLength(Lformlst, formpnt);

        //clean the memory address valued by stream to zero. it is avoid a "access violation".
        for i := 0 to LFormStreamCount-1 do
        begin
          LTempFormlst[I].flt := 0;
          LTempFormlst[I].sacang := 0;
          LTempFormlst[I].angclp := 0;
          LTempFormlst[I].clp:= 0;

          
          Lformlst[LFormCount + i] := PFRMHED(@LTempFormlst[I])^;
          //Stream.Read(Lformlst[i], SizeOf(TFRMHED) );
          //lformlst[i].flt := nil;
          //Stream.Read(LTempFormlst[i], SizeOf(TFRMHED));
          //CopyHed(Lformlst[i],LTempFormlst[i]);
  //        Lformlst[i] := LTempFormlst[i];
        end;
        inc(LFormCount, LFormStreamCount);
      end;

//#5833                                ReadFile(hFil,(FRMHED*)formlst,formpnt*sizeof(FRMHED),&red,0);
//#5834                                rstMap(BADFIL);
//#5835                                if(red!=formpnt*sizeof(FRMHED)){
//#5836
//#5837                                    formpnt=red/sizeof(FRMHED);
//#5838                                    setMap(BADFIL);
//#5839                                }
//#5840                            }
    end;


  //form points
    SetLength(Lflts, sthed.fcnt);
    //red := Stream.Read(Lflts[0], SizeOf(TFLPNT) * sthed.fcnt);
    for i := 0 to sthed.fcnt -1 do
    begin
      AStream.Read(Lflts[i], SizeOf(TFLPNT));

      //Hey, Thred is updwon side. that is the first Y is in bottom, so we convert to delphi style
      Lflts[i].y := {hedx.yhup -}(hedx.yhup - Lflts[i].y);
    end;


//#5842                            ReadFile(hFil,(FLPNT*)flts,sthed.fcnt*sizeof(FLPNT),&red,0);
//#5843                            if(red!=sizeof(FLPNT)*sthed.fcnt){
//#5844
//#5845                                fltad=red/sizeof(FLPNT);
//#5846                                for(ind=fltad;ind<sthed.fcnt;ind++)                                           
//#5847                                    flts[ind].x=flts[ind].y=0;

//#5848                                setMap(BADFIL);                                           
//#5849                            }


  //dline data count
    SetLength(Lsatks, sthed.fcnt);
    AStream.Read(Lsatks[0], SizeOf(TSATCON) * sthed.scnt);
//#5850                            ReadFile(hFil,(SATCON*)satks,sthed.scnt*sizeof(SATCON),&red,0);                                               
//#5851                            if(red!=sthed.scnt*sizeof(SATCON)){
//#5852                                                                           
//#5853                                satkad=red/sizeof(SATCON);
//#5854                                setMap(BADFIL);
//#5855                            }

  //points to clipboard data
    SetLength(Lclps, sthed.fcnt);
    AStream.Read(Lclps[0], SizeOf(TFLPNT) * sthed.ecnt);
//#5856                            ReadFile(hFil,(FLPNT*)clps,sthed.ecnt*sizeof(FLPNT),&red,0);
//#5857                            if(red!=sthed.ecnt*sizeof(FLPNT)){
//#5858
//#5859                                clpad=red/sizeof(FLPNT);
//#5860                                setMap(BADFIL);
//#5861                            }

  //textured fill point count
    SetLength(Ltxpnts, sthed.fcnt);
    AStream.Read(Ltxpnts[0], SizeOf(TTXPNT) * hedx.txcnt);
//#5862                            ReadFile(hFil,(TXPNT*)txpnts,hedx.txcnt*sizeof(TXPNT),&red,0);
//#5863                            txad=red/sizeof(TXPNT);
//#5864                            if(rstMap(BADFIL))
//#5865                                bfilmsg();


    
//#5866                            for(ind=0;ind<formpnt;ind++){
    for i := 0 to formpnt -1 do
    begin
      Lformlst[i].flt := adflt(Lformlst[i].sids);
      //adflt(Lformlst[i].flt, Lformlst[i].sids);
      //continue;
      if Lformlst[i].typ = SAT then
      begin
//#5868                                formlst[ind].flt=adflt(formlst[ind].sids);
//#5869                                if(formlst[ind].typ==SAT){

  //SATIN
  //SACANG = satin guidlines or angle clipboard fill angle
  //STPT = number of satin guidlines
//#5871                                    if(formlst[ind].stpt)
//#5872                                        formlst[ind].sacang.sac=adsatk(formlst[ind].stpt);
        if LFormlst[i].stpt > 0 then
          lformlst[i].sacang.sac^ := adsatk(Lformlst[i].stpt)
          ;
//#5873                                }
      end;

  //HAS CLIPBOARD?
      if isclp(i) then
        Lformlst[i].angclp.clp^ := adclp(lformlst[i].flencnt.nclp)
        ;
//#5874                                if(isclp(ind))
//#5875                                    formlst[ind].angclp.clp=adclp(formlst[ind].flencnt.nclp);

      if iseclpx(i) then
        Lformlst[i].clp := adclp(lformlst[i].nclp);
//#5876                                if(iseclpx(ind))
//#5877                                    formlst[ind].clp=adclp(formlst[ind].nclp);
//#5878                            }
    end;





//#5879                            setfchk();
//#5880                        }
  end;
  LDesign.Forms := lformlst;
//#5881                    }                                                       
//#5882                    else                                                       
//#5883                        tabmsg(IDS_NOTHR);
//#5884                }
end;

{procedure TStitchTHRConverter.LoadItemFromStream(const AStream: TStream; const
  AItem: TCollectionItem);
var d : integer;
  b : TSHRTPNT;
  i : TStitchItem;
begin
  {Stream.Read(b,SizeOf(TSHRTPNT));
  with TStitchItem(AItem) do
  begin
    x := b.x;
    y := b.y;
    //at := b.at;
    ColorIndex := b.at and COLMSK;
    LayerStackIndex := (b.at and LAYMSK) shr LAYSHFT;
  end;

end;}

procedure TStitchTHRConverter.SaveToStream(AStream: TStream;
  ACollection: TCollection);
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  formpnt,
  vervar,i,red : Integer;
  sthed : TSTRHED;
  item  : TSHRTPNT;
  hedx : TSTREX;
  LDesign : TStitchList;
  c : TColor;
  c16 : T16Colors;
  LColors : TArrayOfTColor;
  buf : array[0..15] of Char;
  LBytes : T16Byte;
  zum0 : TPoint;
  zRct : TRect; 

  LTempstchs, Lstchs : TArrayOfTSHRTPNT;
  Lflts,
  Lclps : TArrayOfFloatPoint;//array of TFLPNT;
  Lsatks :TArrayOfTSATCON;
  Ltxpnts : array of TTXPNT;
  Lfrmlstx : array of TFRMHEDO;
  Lformlst : TArrayOfTFRMHED;
  clpad,satkad,fltad : Integer;

begin
  
  LDesign := TStitchList(ACollection.Owner);
  //header 0
  FillChar(sthed, SizeOf(TSTRHED),0);
  with sthed do
  begin
    led := $02746872; //ver 2
    hup := LDesign.Header.hup;
    stchs := Length(LDesign.Stitchs);
  end;
  AStream.Write(sthed, SizeOf(sthed));

  FillChar(hedx, SizeOf(TSTREX),0);
  with hedx do
  begin
    xhup := LDesign.HeaderEx.xhup;
    yhup := LDesign.HeaderEx.yhup;
  end;
  AStream.Write(hedx, SizeOf(TSTREX));

  
  //LDesign.Stitchs := Lstchs;
  SetLength(Lstchs, sthed.stchs);
  Lstchs := LDesign.Stitchs;
  for i := 0 to sthed.stchs do
  begin
    //Hey, Thred is updwon side. that is the first Y is in bottom, so we convert to it back from delphi style

    Lstchs[i].y := hedx.yhup - Lstchs[i].y;
  end;
  AStream.Write(Lstchs[0], sthed.stchs * SizeOf(TSHRTPNT));
  SetLength(Lstchs, 0);
  lstchs := nil;



  //Stitch Sizes
  //pchar(buf[0])^ := pchar(LDesign.BName);
  fillchar(buf[0],16,0);
  AStream.Write(buf, 16);


  //BG COLOR
  AStream.Write(LDesign.BgColor,4);

  //Colors
  for i := 0 to 15 do
  begin
    c16[i] := LDesign.Colors[i];
  end;
  AStream.Write(c16[0], 64);

  //custom color
  AStream.Write(c16[0], 64);


  //THREAD SIZE (ON SCREEN)
  for i := 0 to 15 do
  begin
     LBytes[i] := LDesign.ThreadSize[i] div 10;
  end;
  AStream.Write(LBytes[0], 16);

//#9816    void thrsav(){
//#9817                                                                           
//#9818        unsigned            ind,len;
//#9819        int                    tind;                                               
//#9820        unsigned long        wrot;                                                           
//#9821        unsigned            flind=0;                                                       
//#9822        unsigned            slind=0;                                                       
//#9823        unsigned            elind=0;                                                       
//#9824        WIN32_FIND_DATA        fdat;                                                            
//#9825        HANDLE                hndl;                                                   
//#9826        TCHAR                nunam[MAX_PATH];                                                   
//#9827                                                                           
//#9828        if(chkattr(filnam))                                                                   
//#9829            return;                                                               
//#9830        if(!rstMap(IGNAM)){                                                                   
//#9831                                                                           
//#9832            hndl=FindFirstFile(genam,&fdat);                                                               
//#9833            ind=0;                                                               
//#9834            if(hndl!=INVALID_HANDLE_VALUE){                                                               
//#9835                                                                           
//#9836                rstMap(CMPDO);                                                           
//#9837                for(ind=0;ind<OLDVER;ind++)                                                           
//#9838                    vernams[ind][0]=0;                                                       
//#9839                duver(fdat.cFileName);                                                           
//#9840                while(FindNextFile(hndl,&fdat))
//#9841                    duver(fdat.cFileName);                                                       
//#9842                FindClose(hndl);                                                           
//#9843                DeleteFile(vernams[OLDVER-1]);                                                           
//#9844                for(tind=OLDVER-2;tind>=0;tind--){                                                           
//#9845                                                                           
//#9846                    if(vernams[tind][0]){                                                       
//#9847                                                                           
//#9848                        vernams[tind][MAX_PATH-1]=0;                                                   
//#9849                        strcpy(nunam,vernams[tind]);                                                   
//#9850                        len=duth(nunam);                                                   
//#9851                        nunam[len]=tind+'s';                                                   
//#9852                        MoveFile(vernams[tind],nunam);                                                   
//#9853                    }                                                       
//#9854                }                                                           
//#9855            }                                                               
//#9856        }                                                                   
//#9857        hFil=CreateFile(thrnam,(GENERIC_WRITE),0,NULL,                                                                   
//#9858            CREATE_ALWAYS,0,NULL);                                                               
//#9859        if(hFil==INVALID_HANDLE_VALUE){                                                                   
//#9860                                                                           
//#9861            crmsg(thrnam);                                                               
//#9862            hFil=0;                                                               
//#9863        }                                                                   
//#9864        else{                                                                   
//#9865                                                                           
//#9866            dubuf();                                                               
//#9867            WriteFile(hFil,bseq,bufref(),&wrot,0);                                                               
//#9868            if(wrot!=(unsigned long)bufref()){                                                               
//#9869                                                                           
//#9870                sprintf(msgbuf,"File Write Error: %s\n",thrnam);                                                           
//#9871                shoMsg(msgbuf);                                                           
//#9872            }                                                               
//#9873            CloseHandle(hFil);                                                               
//#9874        }                                                                   
//#9875    }

end;


class function TStitchTHRConverter.WantThis(AStream: TStream): Boolean;
var
  hed : TSTRHED;
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  ver,red : Integer;
begin
  result := false;
  red := AStream.Read(hed, SizeOf(TSTRHED));                         //#5711                if(tchr=='t'){
                                                  //#5712
                                                  //#5713                    ReadFile(hFil,(STRHED*)&sthed,sizeof(STRHED),&red,NULL);
  if hed.led and $ffffff=$746872 then                   //#5714                    if((sthed.led&0xffffff)==0x746872){
  begin                                           //#5715
     if red <> SizeOf(TSTRHED) then                //#5716                        if(red!=sizeof(STRHED)){
        raise Exception.Create(IDS_SHRTF);        //#5717
                                                  //#5718                            tabmsg(IDS_SHRTF);
                                                  //#5719                            return;
                                                  //#5720                        }
      ver := (hed.led and $ff000000) shl 24;      //#5721                        vervar=(sthed.led&0xff000000)>>24;
      Result := ver in [0,1,2];                   //#5722                        switch(vervar){
   end;                                               //#5723
end;

initialization
  TStitchList.RegisterConverterReader('THR','Thredwork',0, TStitchTHRConverter);
  TStitchList.RegisterConverterWriter('THR','Thredwork',0, TStitchTHRConverter);
end.
