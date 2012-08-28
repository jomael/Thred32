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
 * x2nie - Fathony Luthfillah  <x2nie@yahoo.com>
 * Ma Xiaoguang and Ma Xiaoming < gmbros@hotmail.com >
 *
 * Contributor(s):
 *
 * Lab to RGB color conversion is using RGBCIEUtils.pas under mbColorLib library
 * developed by Marko Binic' marko_binic [at] yahoo [dot] com
 * or mbinic [at] gmail [dot] com.
 * forums : http://mxs.bergsoft.net/forums
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
uses Classes,SysUtils, Graphics,
  gmFileFormatList, Stitch_items ;

type

  TStitchTHRConverter = class(TgmConverter)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream; ACollection: TCollection); override;
    //procedure LoadItemFromString(Item :TgmSwatchItem; S : string);
    procedure LoadItemFromStream(Stream: TStream; AItem: TCollectionItem); virtual;
    //procedure SaveToStream(Stream: TStream; ACollection: TCollection); override;
    //procedure SaveItemToStream(Stream: TStream; AItem: TCollectionItem); virtual; abstract;
    class function WantThis(AStream: TStream): Boolean; override;
    //constructor Create; virtual;
  end;

implementation

uses
  Math,
  Thred_Types, Thred_Constants,
  GR32
  //, GR32_LowLevel
  ;
{ TgmConverter }

constructor TStitchTHRConverter.Create;
begin
  inherited;

end;


procedure TStitchTHRConverter.LoadFromStream(Stream: TStream;
  ACollection: TCollection);
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  formpnt,
  vervar,i,red : Integer;
  sthed : TSTRHED;
  item  : TSHRTPNT;
  hedx : TSTREX;
  LCollection : TStitchCollection;
  c : TColor;
  c16 : T16Colors;
  buf : array[0..17] of Char;
  Bytes : T16Byte;

  Lflts,
  Lclps : TArrayOfFloatPoint;//array of TFLPNT;
  Lsatks :array of  TSATCON;
  Ltxpnts : array of TTXPNT;
  Lfrmlstx : array of TFRMHEDO;
  Lformlst : array of TFRMHED;

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
begin
  LCollection := TStitchCollection(ACollection);
  LCollection.Clear;
  
  //here we go!
  //validation of stream is already done.
  
//#5711                if(tchr=='t'){
//#5712
//#5713                    ReadFile(hFil,(STRHED*)&sthed,sizeof(STRHED),&red,NULL);
//  red := Stream.Read(buf[0],SizeOf(buf));

  Stream.Read(sthed,SizeOf(TSTRHED) );
  LCollection.Header := sthed;
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
    Stream.Read(hedx, SizeOf(TSTREX));
//#5746                            if(red!=sizeof(STREX)){
//#5747
//#5748                                tabmsg(IDS_SHRTF);
//#5749                                return;
//#5750                            }
//#5751                            ini.hupx=zum0.x=hedx.xhup;
//#5752                            ini.hupy=zum0.y=hedx.yhup;
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

//#5761                        zRct.bottom=zRct.left=0;
//#5762                        zRct.right=zum0.x=ini.hupx;
//#5763                        zRct.top=zum0.y=ini.hupy;
//#5764                        hed.stchs=sthed.stchs;
//#5765                        ReadFile(hFil, (SHRTPNT*)stchs, hed.stchs*sizeof(SHRTPNT), &red, NULL);
  for i := 0 to sthed.stchs -1 do
  begin
    //Stream.Read(item,red); 
    //if red = SizeOf(item) then
    LoadItemFromStream(Stream, LCollection.Add);
  end;

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
  red := Stream.Read(buf[0],16);
  LCollection.BName := buf;
//  if red <> 16 then    Exit;

//#5780                        ReadFile(hFil,(COLORREF*)&stchBak,4,&red,0);
//#5781                        tred+=red;
//#5782                        if(red!=4){
//#5783
//#5784                            stchBak=ini.stchBak;
//#5785                            prtred();
//#5786                            return;
//#5787                        }
  Stream.Read(c,4);
  LCollection.BgColor := c;
//#5788                        hStchBak=CreateSolidBrush(stchBak);


//#5789                        ReadFile(hFil,(COLORREF*)useCol,64,&red,0);
//#5790                        tred+=red;
//#5791                        if(red!=64){
//#5792
//#5793                            prtred();
//#5794                            return;
//#5795                        }
  Stream.Read(c16[0], 64);
  LCollection.Colors := c16;

//#5796                        ReadFile(hFil,(COLORREF*)custCol,64,&red,0);
//#5797                        tred+=red;
//#5798                        if(red!=64){
//#5799
//#5800                            prtred();
//#5801                            return;
//#5802                        }
  Stream.Read(c16, 64);
  LCollection.CustomColors := c16;

  //THREAD SIZE (ON SCREEN)
//#5803                        ReadFile(hFil,(TCHAR*)msgbuf,16,&red,0);
//#5804                        tred+=red;
//#5805                        if(red!=16){
//#5806
//#5807                            prtred();
//#5808                            return;
//#5809                        }
  red := Stream.Read(Bytes[0],16);
  //LCollection.BName := Bytes;
  if red <> 16 then
    Exit;


  for i := 0 to 15 do
  begin
     Bytes[i] := Bytes[i] * 10;
  end;
  LCollection.ThreadSize := Bytes;
//#5810                        for(ind=0;ind<16;ind++)
//#5811                            thrdSiz[ind][0]=msgbuf[ind];


//#5812                        formpnt=sthed.fpnt;
//#5813                        if(formpnt>MAXFORMS)
//#5814                            formpnt=MAXFORMS;
//#5815                        inf=0;ing=0,inh=0;
  formpnt := min(sthed.fpnts, MAXFORMS);

  //FORM
//#5816                        if(formpnt){
  if formpnt > 0 then
  begin
//#5817
//#5818                            ind=fltad=satkad=clpad=0;
//#5819                            msgbuf[0]=0;                                               
//#5820                            if(vervar<2){

    //OLD FORM HEADER
    if vervar < 2 then
    begin
//#5821                                                                           
//#5822                                frmlstx=(FRMHEDO*)&bseq;
      SetLength(Lfrmlstx, formpnt);
      Stream.Read(Lfrmlstx[0], SizeOf(TFRMHEDO) * formpnt);
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
      Stream.Read(Lformlst[0], SizeOf(TFRMHED)* formpnt);
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
    Stream.Read(Lflts[0], SizeOf(TFLPNT) * sthed.fcnt);
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
    Stream.Read(Lsatks[0], SizeOf(TSATCON) * sthed.scnt);
//#5850                            ReadFile(hFil,(SATCON*)satks,sthed.scnt*sizeof(SATCON),&red,0);                                               
//#5851                            if(red!=sthed.scnt*sizeof(SATCON)){
//#5852                                                                           
//#5853                                satkad=red/sizeof(SATCON);                                           
//#5854                                setMap(BADFIL);                                           
//#5855                            }

  //points to clipboard data                                               
    SetLength(Lclps, sthed.fcnt);
    Stream.Read(Lclps[0], SizeOf(TFLPNT) * sthed.scnt);
//#5856                            ReadFile(hFil,(FLPNT*)clps,sthed.ecnt*sizeof(FLPNT),&red,0);
//#5857                            if(red!=sthed.ecnt*sizeof(FLPNT)){                                               
//#5858                                                                           
//#5859                                clpad=red/sizeof(FLPNT);                                           
//#5860                                setMap(BADFIL);                                           
//#5861                            }

  //textured fill point count
    SetLength(Ltxpnts, sthed.fcnt);
    Stream.Read(Ltxpnts[0], SizeOf(TTXPNT) * sthed.scnt);
//#5862                            ReadFile(hFil,(TXPNT*)txpnts,hedx.txcnt*sizeof(TXPNT),&red,0);                                               
//#5863                            txad=red/sizeof(TXPNT);                                               
//#5864                            if(rstMap(BADFIL))
//#5865                                bfilmsg();



//#5866                            for(ind=0;ind<formpnt;ind++){
    for i := 0 to formpnt -1 do
    begin
      //Lformlst[i].flt :=
//#5867
//#5868                                formlst[ind].flt=adflt(formlst[ind].sids);
//#5869                                if(formlst[ind].typ==SAT){

  //SATIN
  //SACANG = satin guidlines or angle clipboard fill angle
  //STPT = number of satin guidlines
//#5871                                    if(formlst[ind].stpt)
//#5872                                        formlst[ind].sacang.sac=adsatk(formlst[ind].stpt);
//#5873                                }

  //HAS CLIPBOARD?
//#5874                                if(isclp(ind))
//#5875                                    formlst[ind].angclp.clp=adclp(formlst[ind].flencnt.nclp);
//#5876                                if(iseclpx(ind))
//#5877                                    formlst[ind].clp=adclp(formlst[ind].nclp);
//#5878                            }
    end;





//#5879                            setfchk();
//#5880                        }
  end;
//#5881                    }                                                       
//#5882                    else                                                       
//#5883                        tabmsg(IDS_NOTHR);
//#5884                }
end;

procedure TStitchTHRConverter.LoadItemFromStream(Stream: TStream;
  AItem: TCollectionItem);
var d : integer;
  b : TSHRTPNT;
  i : TStitchItem;
begin
  Stream.Read(b,SizeOf(TSHRTPNT));
  with TStitchItem(AItem) do
  begin
    x := b.x;
    y := b.y;
    //at := b.at;
    ColorIndex := b.at and COLMSK;
    LayerStackIndex := (b.at and LAYMSK) shr LAYSHFT; 
  end;

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
  TStitchCollection.RegisterConverterReader('THR','Thredwork',0, TStitchTHRConverter);
end.
