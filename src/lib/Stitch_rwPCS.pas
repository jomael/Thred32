unit Stitch_rwPCS;

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

uses
  Classes, SysUtils, Graphics,
  gmFileFormatList, Stitch_items;

type
  TStitchPCSConverter = class(TgmConverter)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(AStream: TStream; ACollection: TCollection); override;
    //procedure LoadItemFromString(Item :TgmSwatchItem; S : string);
    //procedure LoadItemFromStream(AStream: TStream; AItem: TCollectionItem); virtual;
    //procedure SaveToStream(Stream: TStream; ACollection: TCollection); override;
    //procedure SaveItemToStream(Stream: TStream; AItem: TCollectionItem); virtual; abstract;
    class function WantThis(AStream: TStream): Boolean; override;
    //constructor Create; virtual;
  end;

implementation

uses
  Math,
  Thred_Constants, Thred_Types,
  GR32 ;//, GR32_LowLevel;

{ TStitchPCSConverter }

constructor TStitchPCSConverter.Create;
begin
  inherited;

end;


procedure TStitchPCSConverter.LoadFromStream(AStream: TStream;
  ACollection: TCollection);
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  ind,inf,i,siz,red,stind,cpnt,tcol : Integer;
  hed : THED;
  sthed : TSTRHED;
  hedx : TSTREX;
  stchs  : TArrayOfTSHRTPNT;
  LColors : tarrayoftcolor;
  LDesign : TStitchCollection;
  c : TColor;
  c16 : T16Colors;
  buf : array[0..17] of Char;
  //inf : integer;
  filBuf : array of TPCSTCH;
  colch : array of TCOLCHNG;
  strct : TFloatRect;
begin
  LDesign := TStitchCollection(ACollection);
  LDesign.Clear;
  strct := FloatRect(makerect(0,0,0,0));

  //here we go!
  //validation of stream is already done.


//#5887                    setMap(NOTHRFIL);
//#5888                    if(tchr=='p'){
//#5889
//#5890                        if(tolower(pext[01])=='c'){
//#5891
//#5892                            ReadFile(hFil,(HED*)&hed,0x46,&red,NULL);
//#5893                            if(!siz){
//#5894
//#5895                                filnopn(IDS_ZEROL,filnam);
//#5896                                return;
//#5897                            }
//#5898                            if(hed.ledIn==0x32&&hed.fColCnt==16){

  AStream.Read(hed,SizeOf(THED) );
  //LCollection.Header := sthed;
  if not ( (hed.ledIn = $32) and (hed.fColCnt = 16)) then
        raise Exception.Create(IDS_SHRTF);

  SetLength(LColors, 16);
  //AStream.Read(c16[0], 64);

  for i := 0 to 15 do
  begin
    LColors[i] := hed.fCols[i];
  end;


  LDesign.Colors := LColors;

  //LCollection.Colors := sthed.fCols;


                                               
//#5899                                                                           
//#5900                                for(ind=0;ind<16;ind++)                                           
//#5901                                    useCol[ind]=hed.fCols[ind];                                       
//#5902                                siz-=0x46;                                           
//#5903                                inf=siz/sizeof(PCSTCH)+2;
  siz := astream.Size - $46;
  inf := siz div SizeOf(TPCSTCH) + 2;
  setlength(filBuf, inf);

//#5904                                filBuf=new PCSTCH[inf];                                           
//#5905                                ReadFile(hFil,filBuf,siz,&red,NULL);
  AStream.Read(filBuf[0], siz);

//#5906                                stind=0;                                           
//#5907                                cPnt=0;                                           
//#5908                                tcol=0;                                           
//#5909                                ind=0;
  stind := 0;
  cPnt := 0;
  tcol := 0;
  ind  := 0;
  setlength(colch,siz);
  setlength(stchs,hed.stchs);
  while (stind < hed.stchs) and (ind < inf) do
  begin
//#5910                                while(stind<hed.stchs&&ind<inf){                                           
//#5911
    if filBuf[ind].typ = 3 then
    begin
//#5912                                    if(filBuf[ind].typ==3){
//#5913
      colch[cpnt].colind := filBuf[ind].fx;
      colch[cpnt].stind := stind;
      inc(cPnt);
      tcol := NOTFRM or filBuf[ind].fx;
      inc(ind);
//#5914                                        colch[cPnt].colind=filBuf[ind].fx;
//#5915                                        colch[cPnt++].stind=stind;
//#5916                                        tcol=NOTFRM|filBuf[ind++].fx;
//#5917                                    }
    end
    else
    begin
//#5918                                    else{                                       
//#5919
      stchs[stind].x := filBuf[ind].x+ filBuf[ind].fx/256;
      stchs[stind].y := filBuf[ind].y+filBuf[ind].fy/256;
      stchs[stind].at := tcol;

      strct.Left := min(strct.Left, stchs[stind].x);
      strct.Right := max(strct.Right, stchs[stind].x);
      strct.Top := min(strct.Top, stchs[stind].y);
      strct.Bottom := max(strct.Bottom, stchs[stind].y);


      inc(stind);
      inc(ind);
//#5920                                        stchs[stind].x=filBuf[ind].x+(float)filBuf[ind].fx/256;                                   
//#5921                                        stchs[stind].y=filBuf[ind].y+(float)filBuf[ind].fy/256;                                   
//#5922                                        stchs[stind++].at=tcol;                                   
//#5923                                        ind++;                                   
//#5924                                    }
    end;                                  
//#5925                                }
  end;                                           
//#5926                                hed.stchs=stind;
  //hed.stchs := stind;
  fillchar(sthed,sizeof(TSTRHED),0);
  sthed.stchs := stind;
  setlength(stchs,stind);

  LDesign.Header := sthed;
//#5927                                tnam=(TCHAR*)&filBuf[ind];
//#5928                                strcpy(bnam,tnam);                                           
//#5929                                delete filBuf;                                           
//#5930                                strcpy(pext,"thr");                                           
//#5931                                ini.auxfil=AUXPCS;                                           
//#5932                                if(hed.hup!=LARGHUP&&hed.hup!=SMALHUP)                                           
//#5933                                    hed.hup=LARGHUP;                                       
//#5934                                sizstch(&strct);

  fillchar(hedx, sizeof( TSTREX),0);
  if(strct.left<0) or(strct.right>LHUPY) or (strct.bottom<0) or(strct.top>LHUPY) then
//#5935                                if(strct.left<0||strct.right>LHUPY||strct.bottom<0||strct.top>LHUPY){
  begin
    hedx.xhup := LHUPX;
    hedx.yhup := LHUPY;
  end
//#5936
//#5937                                    ini.hupx=LHUPX;
//#5938                                    ini.hupy=LHUPY;
//#5939                                    chkhup();
//#5940                                }
//#5941                                else{
  else
  if hed.hup = LARGHUP then
  begin
    hedx.xhup := LHUPX;
    hedx.yhup := LHUPY;
  end

//#5942
//#5943                                    if(hed.hup==LARGHUP){
//#5944
//#5945                                        ini.hup=LARGHUP;
//#5946                                        ini.hupx=LHUPX;
//#5947                                        ini.hupy=LHUPY;
//#5948                                    }
//#5949                                    else{
  else
  if (strct.Right > SHUPX) or (strct.Bottom >SHUPY) or (hed.hup = LARGHUP) then
  begin
    hedx.xhup := SHUPX;
    hedx.yhup := SHUPY;
  end

//#5950
//#5951                                        if(strct.right>SHUPX||strct.top>SHUPY||hed.hup==LARGHUP){
//#5952
//#5953                                            ini.hup=LARGHUP;
//#5954                                            ini.hupx=SHUPX;
//#5955                                            ini.hupy=SHUPY;
//#5956                                        }
//#5957                                        else{
//#5958
  else
  begin
    hedx.xhup := SHUPX;
    hedx.yhup := SHUPY;
  end;

//#5959                                            ini.hup=SMALHUP;                               
//#5960                                            ini.hupx=SHUPX;                               
//#5961                                            ini.hupy=SHUPY;                               
//#5962                                        }                                   
//#5963                                    }                                       
//#5964                                }                                           
//#5965                            }                                               
//#5966                        }
  for i := 0 to stind -1 do
  begin

    //Hey, Thred is updwon side. that is the first Y is in bottom, so we convert to delphi style
    stchs[i].y := {hedx.yhup -}(hedx.yhup - stchs[i].y);
  end;

  LDesign.Stitchs := stchs;
      
  LDesign.HeaderEx := hedx;
end;



class function TStitchPCSConverter.WantThis(AStream: TStream): Boolean;
var
  hed : THED;
  red : Integer;
begin
  result := false;
  red := AStream.Read(hed, SizeOf(THED));
  Result := (hed.ledIn = $32) and (hed.fColCnt = 16)
end;

initialization
  TStitchCollection.RegisterConverterReader('PCS','Thredwork',0, TStitchPCSConverter);
end.
