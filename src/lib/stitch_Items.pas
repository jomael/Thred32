unit Stitch_items;

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
 * The Initial Developer of this unit are
 *
 * x2nie - Fathony Luthfillah  <x2nie@yahoo.com>
 *
 * Contributor(s):
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
{ Standard }
  Types, Classes, SysUtils, Graphics,
{ Graphics32 }
  GR32, GR32_LowLevel, GR32_Polygons, GR32_PolygonsEx,
{ Graphics Magic }  
  gmCore_rw, gmCore_Items, gmShape,
  Thred_Constants, Thred_Types;

type    //TStitchItem
  {//form types enum
	LIN   =1;
	POLI  =2;
	RPOLI =3;
	STAR  =4;
	SPIR  =5;
	SAT   =6;
	HART  =7;
	LENS  =8;
	EGG   =9;
	TEAR  =10;
	ZIG   =11;
	WAV   =12;
	DASY  =13;}
  TStitchFormType = (ftNone, ftLine, ftPolygon, ftRegularPolygon, ftStar,
    ftSpiral, ftSatin, ftHearth, ftLens, ftEgg, ftTear, ftZigzag, ftWave,
    ftDaisy);

  TStitchItem = class(TgmCoreItem)
  private
//    FFormType: TStitchFormType;
  protected
  public
//    property FormType : TStitchFormType read FFormType write FFormType;
    //property PolyPolygon : PArrayOfgmShapeInfo read GetPolyPolygon;
  published
  end;


  TStitchList = class(TgmCoreList)
  private
    FHeader: TSTRHED;
    FBName: string;
    FBgColor: TColor;
    FColors: TArrayOfTColor;
    FCustomColors: TArrayOfTColor;
    FThreadSize: T16Byte;
    FForms: TArrayOfTFRMHED;
    FStitchs: TArrayOfTSHRTPNT;
    FHeaderEx: TSTREX;
  protected
    class function GetItemClass : TCollectionItemClass; override;
  
  public
    constructor Create(AOwner: TComponent); override;
    class function GetFileReaders : TgmFileFormatsList; override;
    class function GetFileWriters : TgmFileFormatsList; override;


    function AddForm : PFRMHED;
    function GetNearestForm(P : TFloatPoint) : PFRMHED;

    property Header : TSTRHED read FHeader write FHeader;
    property HeaderEx : TSTREX read FHeaderEx write FHeaderEx;
    property BName : string read FBName write FBName;
    property ThreadSize : T16Byte read FThreadSize write FThreadSize;
    property BgColor : TColor read FBgColor write FBgColor;
    property Colors : TArrayOfTColor read FColors write FColors;
    property CustomColors : TArrayOfTColor read FCustomColors write FCustomColors;
    property Forms : TArrayOfTFRMHED read FForms write FForms;
    property Stitchs : TArrayOfTSHRTPNT read FStitchs write Fstitchs;
  end;


implementation

uses
  Math;
  //gmMiscFuncs;

var
  UStitchsReaders, UStitchsWriters : TgmFileFormatsList;  

{ TStitchCollection }


function TStitchList.AddForm: PFRMHED;
var
  L : Integer;
begin
  L := Length(FForms);
  SetLength(FForms, L + 1);
  Result := @fforms[L];
end;

constructor TStitchList.Create(AOwner: TComponent);
begin
  inherited;
  FBgColor := clWhite32;
end;

class function TStitchList.GetFileReaders: TgmFileFormatsList;
begin
 if not Assigned(UStitchsReaders) then
  begin
    UStitchsReaders := TgmFileFormatsList.Create;
  end;

  Result := UStitchsReaders;
end;

class function TStitchList.GetFileWriters: TgmFileFormatsList;
begin
  if not Assigned(UStitchsWriters) then
  begin
    UStitchsWriters := TgmFileFormatsList.Create;
  end;

  Result := UStitchsWriters;
end;


class function TStitchList.GetItemClass: TCollectionItemClass;
begin
  Result := TStitchItem;
end;

function TStitchList.GetNearestForm(P: TFloatPoint): PFRMHED;
const
  T = 4;
var i,j : Integer;
  LForm : TFRMHED;
  z : Double;
begin
  Result := nil;
  for i := High(FForms) downto Low(FForms) do
  begin
    LForm := FForms[i];
    for j := 0 to Length(LForm.flt)-1  do
    begin
      with P do
        z := Hypot(x - LForm.flt[j].X, Y - LForm.flt[j].y );
      if z < T then
      begin
        Result := @FForms[i];
        Break;
      end;
    end;

    if Result <> nil then
      Break;
  end;

end;

end.

