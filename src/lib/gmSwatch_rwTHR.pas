unit gmSwatch_rwTHR;

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
  gmFileFormatList, gmSwatch;

type

  TStitchTHRConverter = class(TgmConverter)
  private
  public
    constructor Create; override;
    procedure LoadFromStream(AStream: TStream; ACollection: TCollection); override;
    class function WantThis(AStream: TStream): Boolean; override;
  end;

implementation

uses
  Thred_Types, Thred_Constants;
//  GR32, GR32_LowLevel;

{ TStitchTHRConverter }

constructor TStitchTHRConverter.Create;
begin
  inherited;

end;


procedure TStitchTHRConverter.LoadFromStream(AStream: TStream;
  ACollection: TCollection);
var
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  vervar,i,red : Integer;
  sthed : TSTRHED;
  item  : TSHRTPNT;
  hedx : TSTREX;
  c : TColor;
  c16 : T16Colors;
  buf : array[0..17] of Char;

  LCollection : TgmSwatchCollection;
begin
  LCollection := TgmSwatchCollection(ACollection);

  LCollection.Clear;
  
  //here we go!
  //validation of stream is already done.
  
//#5711                if(tchr=='t'){
//#5712
//#5713                    ReadFile(hFil,(STRHED*)&sthed,sizeof(STRHED),&red,NULL);
//  red := Stream.Read(buf[0],SizeOf(buf));

  AStream.Read(sthed,SizeOf(TSTRHED) );
  //LCollection.Header := sthed;
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
    //Stream.Read(hedx, SizeOf(TSTREX));
    AStream.Seek(SizeOf(TSTREX), soFromCurrent);
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
    
    //else
      //Exit;
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

    AStream.Seek(SizeOf(TSHRTPNT) * sthed.stchs, soFromCurrent );

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
  //LCollection.BName := buf;
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
//#5788                        hStchBak=CreateSolidBrush(stchBak);


//#5789                        ReadFile(hFil,(COLORREF*)useCol,64,&red,0);
//#5790                        tred+=red;
//#5791                        if(red!=64){
//#5792
//#5793                            prtred();
//#5794                            return;
//#5795                        }
  AStream.Read(c16[0], 64);
  //LCollection.Colors := c16;
  for i := 0 to 15 do
    LCollection.Add.Color := c16[i];


//#5796                        ReadFile(hFil,(COLORREF*)custCol,64,&red,0);
//#5797                        tred+=red;
//#5798                        if(red!=64){
//#5799
//#5800                            prtred();
//#5801                            return;
//#5802                        }
  AStream.Read(c16, 64);
  //LCollection.CustomColors := c16;
  for i := 0 to 15 do
    LCollection.Add.Color := c16[i];

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
  //TStitchCollection.RegisterConverterReader('THR','Thredwork',0, TStitchTHRConverter);
  TgmSwatchCollection.RegisterConverterReader('THR','Thredwork',0, TStitchTHRConverter);
//  TgmSwatchCollection.RegisterConverterWriter('SWA','GraphicsMagic Color Swatch',0, TgmSwaConverter);

end.
