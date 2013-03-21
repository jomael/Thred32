unit Embroidery_rwTHR;

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
  gmCore_rw, gmShape, Stitch_items,
  Embroidery_Items ;

{$DEFINE LOADFORMS}

type
  TEmbroideryTHRConverter = class(TgmConverter)
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

constructor TEmbroideryTHRConverter.Create;
begin
  inherited;

end;


procedure TEmbroideryTHRConverter.LoadFromStream(AStream: TStream;
  ACollection: TCollection);

const
  LMAXFORMS = 64;  
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  formCount,
  vervar,i,j,k,m,n,red : Integer;
  at,formIndex : Cardinal;
  LHeader : TSTRHED;
  item  : TSHRTPNT;
  hedx : TSTREX;
  LDesign : TEmbroideryList;
  c : TColor;
  c16 : T16Colors;
  LColors : TArrayOfTColor;
  buf : array[0..17] of Char;
  LBytes : T16Byte;
  zum0 : TPoint;
  zRct : TRect; 

  LTempstchs, LThredStitchs : TArrayOfTSHRTPNT;
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

  //EMBROIDERY SHAPE
  LShape : PgmShapeInfo;
  

  procedure TransferFromOldFormFormat();
  var ind : Cardinal;
  begin
    //frmlstx=(FRMHEDO*)&bseq;
    SetLength(Lformlst, Length(Lfrmlstx));
    //FillMemory(&bseq,0,sizeof(FRMHED)*formpnt);
    FillChar(Lformlst[0], SizeOf(TFRMHED) * formCount, 0);
    for ind :=0 to formCount -1 do
      Move(Lformlst[ind], Lfrmlstx[ind],sizeof(TFRMHEDO));
  end;

  function adflt(cnt: Cardinal): TArrayOfFloatPoint;

  var i,ind : Cardinal;
  begin
	  ind := fltad;
    if(fltad+cnt>MAXFLT) then
      raise Exception.Create(IDS_FRMOVR);
    Inc(fltad,cnt);
    Setlength(result, cnt);

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
  var
  P :PFloatPoint;
  var ind : Cardinal;
  begin
	  ind := fltad;
    if(fltad+cnt>MAXFLT) then
      raise Exception.Create(IDS_FRMOVR);
    Inc(fltad,cnt);
    Setlength(result, cnt);

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

var
  LItem : TEmbroideryItem;
  LStitchs : TArrayOfStitchPoint;  
  LStitchCount : Integer;
begin
  LDesign := TEmbroideryList(ACollection.Owner);
  LDesign.Clear;
  
  //here we go!
  //validation of stream is already done.

  AStream.Read(LHeader,SizeOf(TSTRHED) );
  //LDesign.Header := sthed;
  if LHeader.led and $ffffff <> $746872 then                   //#5714                    if((sthed.led&0xffffff)==0x746872){
        raise Exception.Create({IDS_SHRTF} IDS_NOTHR);        //#5717


  vervar := (LHeader.led and $ff000000) shr 24;
  case vervar of
    0 :   begin
            FillChar(hedx, SizeOf(TSTREX),0);
            if LHeader.hup = SMALHUP then
            begin
              hedx.xhup := SHUPX;
              hedx.yhup := SHUPY;
            end
            else
            begin
              hedx.xhup := LHUPX;
              hedx.yhup := LHUPY;
              LHeader.hup := LARGHUP;
            end;  
          end;

    1,2 :   begin
              AStream.Read(hedx, SizeOf(TSTREX));
              zum0.X := Round(hedx.xhup);
              zum0.Y := Round(hedx.yhup);
            end
    else
      Exit;
  end;

  LDesign.HupWidth := hedx.xhup;
  LDesign.HupHeight := hedx.yhup;

  //LDesign.HeaderEx := hedx;

  zRct := MakeRect(0,0, zum0.X, zum0.Y);

  //LOAD STITCHS
  SetLength(LThredStitchs, LHeader.stchs);
  AStream.Read(LThredStitchs[0], LHeader.stchs * SizeOf(TSHRTPNT));
  for i := 0 to LHeader.stchs do
  begin
    //Hey, Thred is updwon side. that is the first Y is in bottom, so we convert to delphi style
    LThredStitchs[i].y := {hedx.yhup -}(hedx.yhup - LThredStitchs[i].y);
  end;

  //LDesign.Stitchs := Lstchs;
  {for i := 0 to sthed.stchs -1 do
  begin
    //Stream.Read(item,red);
    //if red = SizeOf(item) then
    LoadItemFromStream(Stream, LCollection.Add);
  end;}

  //DESIGNER NAME
  red := AStream.Read(buf[0],16);
  LDesign.DesignerName := buf;
  AStream.Read(c,4);
  LDesign.BgColor := c;

  //COLORS
  SetLength(LColors, 16);
  AStream.Read(c16[0], 64);
  for i := 0 to 15 do
  begin
    LColors[i] := c16[i];
  end;
  
  LDesign.Colors := LColors;

  AStream.Read(c16[0], 64);
//  LDesign.CustomColors := LColors;

  //THREAD SIZE (ON SCREEN)
  red := AStream.Read(LBytes[0],16);
  //LCollection.BName := Bytes;
  if red <> 16 then
    Exit;
  for i := 0 to 15 do
  begin
     LBytes[i] := LBytes[i] * 10;
  end;
  LDesign.ThreadSize := LBytes;

  formCount := min(LHeader.fpnt, MAXFORMS);

  //FORM
  {$IFNDEF LOADFORMS}
    formCount := 0;
  {$ENDIF}
    //prepare Embroidery
    //FillChar(LShape, SizeOf(TgmShapeInfo), 0);
    //LShape.Kind := skPolygon;
    
  if formCount = 0 then
  begin
    LItem := TEmbroideryItem( LDesign.Add);
    LStitchCount := LHeader.stchs +1;
    SetLength(LStitchs, LStitchCount);
    FillChar(LStitchs[0], SizeOf(TStitchPoint) * LStitchCount, 0);
    for i := 0 to LStitchCount -1  do
    begin
      LStitchs[i].X := LThredStitchs[i].x;
      LStitchs[i].Y := LThredStitchs[i].y;
      LStitchs[i].at := LThredStitchs[i].at;

    end;

    LItem.Stitchs^ := LStitchs;
    //LShape.Points  := adflt(Lformlst[i].sids);
    //LDesign.AttachShape(@LShape, emNew );

  end;  

  if formCount > 0 then
  begin
    fltad := 0;
    satkad := 0;
    clpad := 0;

    //OLD FORM HEADER
    if vervar < 2 then
    begin
      SetLength(Lfrmlstx, formCount);
      //Stream.Read(Lfrmlstx[0], SizeOf(TFRMHEDO) * formpnt);
      for i := 0 to formCount-1 do
      begin
        AStream.Read(Lfrmlstx[i], SizeOf(TFRMHEDO) );
      end;

      TransferFromOldFormFormat();
    end
    else
    begin  //VER 2 FORM HEADER
      SetLength(Lformlst, formCount);
      LFormCount := 0;
      while LFormCount < formCount do
      begin
        LFormStreamCount := min(LMAXFORMS, formCount - LFormCount);
        AStream.Read(LTempFormlst[0], SizeOf(TFRMHED)* LFormStreamCount);

        //clean the memory address valued by stream to zero. it is avoid a "access violation".
        for i := 0 to LFormStreamCount-1 do
        begin
          LTempFormlst[I].flt := 0;
          LTempFormlst[I].sacang := 0;
          LTempFormlst[I].angclp := 0;
          LTempFormlst[I].clp:= 0;


          Lformlst[LFormCount + i] := PFRMHED(@LTempFormlst[I])^;
        end;
        inc(LFormCount, LFormStreamCount);
      end;

    end;


    //all form points in a one var
    SetLength(Lflts, LHeader.fcnt);
    //red := Stream.Read(Lflts[0], SizeOf(TFLPNT) * sthed.fcnt);
    for i := 0 to LHeader.fcnt -1 do
    begin
      AStream.Read(Lflts[i], SizeOf(TFLPNT));

      //Hey, Thred is updwon side. that is the first Y is in bottom, so we convert to delphi style
      Lflts[i].y := {hedx.yhup -}(hedx.yhup - Lflts[i].y);
    end;




  //dline data count
    SetLength(Lsatks, LHeader.fcnt);
    AStream.Read(Lsatks[0], SizeOf(TSATCON) * LHeader.scnt);

  //points to clipboard data
    SetLength(Lclps, LHeader.fcnt);
    AStream.Read(Lclps[0], SizeOf(TFLPNT) * LHeader.ecnt);

  //textured fill point count
    SetLength(Ltxpnts, LHeader.fcnt);
    AStream.Read(Ltxpnts[0], SizeOf(TTXPNT) * hedx.txcnt);




    for i := 0 to formCount -1 do
    begin
      //Lformlst[i].flt := adflt(Lformlst[i].sids);
      //LShape.Points  := adflt(Lformlst[i].sids);
      //LDesign.AttachShape(@LShape, emNew );
      LItem := TEmbroideryItem( LDesign.Add);
      LShape := LItem.Add;
      LShape^.Points  := adflt(Lformlst[i].sids);

      {LStitchCount := 1024;Lformlst[i].endp - Lformlst[i].strt +1;
      SetLength(LStitchs, LStitchCount);
      FillChar(LStitchs[0], SizeOf(TStitchPoint) * LStitchCount, 0);
      for j := 0 to LStitchCount -1  do
      begin
        LStitchs[j].X := LThredStitchs[j + Lformlst[i].strt].x;
        LStitchs[j].Y := LThredStitchs[j + Lformlst[i].strt].y;
        LStitchs[j].at := LThredStitchs[j + Lformlst[i].strt].at;

      end;}
      LStitchCount := LHeader.stchs +1;
      SetLength(LStitchs, LStitchCount);
      FillChar(LStitchs[0], SizeOf(TStitchPoint) * LStitchCount, 0);
      k := 0; 
      for j := 0 to LStitchCount do
      begin
        formIndex := (LThredStitchs[j].at and FRMSK) shr FRMSHFT;
        if formIndex = i then
        begin
          //LStitchs[k] := LThredStitchs[j];
          LStitchs[k].X := LThredStitchs[j].x;
          LStitchs[k].Y := LThredStitchs[j].y;
          LStitchs[k].at := LThredStitchs[j].at;
          Inc(k);
        end;  

        //LStitchs := Lflts[i].y := {hedx.yhup -}(hedx.yhup - Lflts[i].y);
      end;
      SetLength(LStitchs, k);
      SetLength(Litem.Stitchs^,k);
      LItem.Stitchs^ := LStitchs;
      SetLength(LStitchs,0);
      


      //adflt(Lformlst[i].flt, Lformlst[i].sids);
      //continue;
      if Lformlst[i].typ = SAT then
      begin

  //SATIN
  //SACANG = satin guidlines or angle clipboard fill angle
  //STPT = number of satin guidlines
        if LFormlst[i].stpt > 0 then
          lformlst[i].sacang.sac^ := adsatk(Lformlst[i].stpt)
          ;
      end;

  //HAS CLIPBOARD?
      if isclp(i) then
        Lformlst[i].angclp.clp^ := adclp(lformlst[i].flencnt.nclp)
        ;

      if iseclpx(i) then
        Lformlst[i].clp := adclp(lformlst[i].nclp);
    end;





  end;
  ///LDesign.Forms := lformlst;
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

procedure TEmbroideryTHRConverter.SaveToStream(AStream: TStream;
  ACollection: TCollection);
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  formpnt,
  vervar,i,red : Integer;
  sthed : TSTRHED;
  item  : TSHRTPNT;
  hedx : TSTREX;
  LDesign : TEmbroideryList;
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
(*
  LDesign := TEmbroideryList(ACollection.Owner);
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
*)
end;


class function TEmbroideryTHRConverter.WantThis(AStream: TStream): Boolean;
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
  TEmbroideryList.RegisterConverterReader('THR','Thredwork',0, TEmbroideryTHRConverter);
///  TEmbroideryList.RegisterConverterWriter('THR','Thredwork',0, TEmbroideryTHRConverter);
end.
