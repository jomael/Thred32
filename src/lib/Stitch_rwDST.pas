unit Stitch_rwDST;

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
  TStitchDSTConverter = class(TgmConverter)
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

{ TStitchDSTConverter }

constructor TStitchDSTConverter.Create;
begin
  inherited;

end;


procedure TStitchDSTConverter.LoadFromStream(AStream: TStream;
  ACollection: TCollection);
var
//#5372    void dstran(){
//#5373
  LColors : tarrayoftcolor;
  LDesign : TStitchCollection;

//#5374        unsigned        ind,ine,col;
//#5375        POINT            loc;
//#5376        POINT            nu;
//#5377        FLPNT            max;
//#5378        FLPNT            min;
//#5379        FLPNT            siz;
//#5380        FLPNT            dif;
//#5381        HANDLE            hcol;
//#5382        unsigned*        pcol;
//#5383        unsigned        fsiz,colind;
//#5384        unsigned long    hisiz;
	led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
  ind,inf,i,siz,red,stind,cpnt,tcol : Integer;
  hed : THED;
  sthed : TSTRHED;
  hedx : TSTREX;
  stchs  : TArrayOfTSHRTPNT;
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


//#5385
//#5386        pcol=0;                                                                   
//#5387        if(colfil()){                                                                   
//#5388                                                                           
//#5389            hcol=CreateFile(colnam,GENERIC_READ,0,0,OPEN_EXISTING,0,0);                                                               
//#5390            if(hcol!=INVALID_HANDLE_VALUE){                                                               
//#5391                                                                           
//#5392                fsiz=GetFileSize(hcol,&hisiz);                                                           
//#5393                pcol=new unsigned[fsiz];                                                           
//#5394                ReadFile(hcol,(unsigned*)pcol,fsiz,&hisiz,0);                                                           
//#5395                CloseHandle(hcol);                                                           
//#5396                if(hisiz&&pcol&&pcol[0]==COLVER){                                                           
//#5397                                                                           
//#5398                    stchBak=pcol[1];                                                       
//#5399                    colCnt=0;                                                       
//#5400                }                                                           
//#5401                else{                                                           
//#5402                                                                           
//#5403                    if(pcol){                                                       
//#5404                                                                           
//#5405                        delete pcol;                                                   
//#5406                        pcol=0;                                                   
//#5407                    }                                                       
//#5408                }                                                           
//#5409            }                                                               
//#5410        }                                                                   
//#5411        ine=0;                                                                   
//#5412        if(pcol)                                                                   
//#5413            col=colmatch(pcol[2]);                                                               
//#5414        else                                                                   
//#5415            col=0;                                                               
//#5416        colind=3;                                                                   
//#5417        loc.x=loc.y=0;                                                                   
//#5418        max.x=max.y=(float)-1e12;                                                                   
//#5419        min.x=min.y=(float)1e12;                                                                   
//#5420        for(ind=0;ind<dstcnt;ind++){                                                                   
//#5421                                                                           
//#5422            if(drecs[ind].nd&0x40){                                                               
//#5423                                                                           
//#5424                if(pcol)                                                           
//#5425                    col=colmatch(pcol[colind++]);                                                       
//#5426                else{                                                           
//#5427                                                                           
//#5428                    col++;                                                       
//#5429                    col&=0xf;                                                       
//#5430                }                                                           
//#5431            }                                                               
//#5432            else{                                                               
//#5433                                                                           
//#5434                dstin(dtrn(&drecs[ind]),&nu);                                                           
//#5435                loc.x+=nu.x;                                                           
//#5436                loc.y+=nu.y;                                                           
//#5437                if(!(drecs[ind].nd&0x80)){                                                           
//#5438                                                                           
//#5439                    stchs[ine].at=col|NOTFRM;                                                       
//#5440                    stchs[ine].x=loc.x*0.6;                                                       
//#5441                    stchs[ine].y=loc.y*0.6;                                                       
//#5442                    if(stchs[ine].x>max.x)                                                       
//#5443                        max.x=stchs[ine].x;                                                   
//#5444                    if(stchs[ine].y>max.y)                                                       
//#5445                        max.y=stchs[ine].y;                                                   
//#5446                    if(stchs[ine].x<min.x)                                                       
//#5447                        min.x=stchs[ine].x;                                                   
//#5448                    if(stchs[ine].y<min.y)                                                       
//#5449                        min.y=stchs[ine].y;                                                   
//#5450                    ine++;                                                       
//#5451                }                                                           
//#5452            }                                                               
//#5453        }                                                                   
//#5454        if(pcol)                                                                   
//#5455            delete pcol;                                                               
//#5456        hed.stchs=ine;                                                                   
//#5457        siz.x=max.x-min.x;                                                                   
//#5458        siz.y=max.y-min.y;                                                                   
//#5459        ini.hup=CUSTHUP;                                                                   
//#5460        zum0.x=ini.hupx;                                                                   
//#5461        zum0.y=ini.hupy;                                                                   
//#5462        if(siz.x>zum0.x||siz.y>zum0.y){                                                                   
//#5463                                                                           
//#5464            ini.hupx=zum0.x=siz.x*1.1;                                                               
//#5465            ini.hupy=zum0.y=siz.y*1.1;                                                               
//#5466            hsizmsg();                                                               
//#5467        }                                                                   
//#5468        dif.x=(zum0.x-siz.x)/2-min.x;                                                                   
//#5469        dif.y=(zum0.y-siz.y)/2-min.y;                                                                   
//#5470        for(ind=0;ind<hed.stchs;ind++){                                                                   
//#5471                                                                           
//#5472             stchs[ind].x+=dif.x;                                                               
//#5473            stchs[ind].y+=dif.y;                                                               
//#5474        }                                                                   
//#5475    }         

  LDesign.Stitchs := stchs;
      
  LDesign.HeaderEx := hedx;
end;



class function TStitchDSTConverter.WantThis(AStream: TStream): Boolean;
var
  hed : THED;
  red : Integer;
begin
  result := false;
  red := AStream.Read(hed, SizeOf(THED));
  Result := (hed.ledIn = $32) and (hed.fColCnt = 16)
end;

initialization
  TStitchCollection.RegisterConverterReader('DST','Tajima',0, TStitchDSTConverter);
end.
