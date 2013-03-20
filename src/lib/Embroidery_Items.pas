unit Embroidery_Items;
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
  Thred_Constants,
  Thred_Types;

type

  TEmbroideryList = class;
  TStitchPoint = record //smallpoint Line
    lin,	// side index of a single primitive polygon. perhap ordered by Top of a TStitchLine.Start
    grp : word; //Y of

    //used by TtitchLine sort()
    IslandCount, //total line found in each Y-scanline.
    NorthIndex, //= Region, from top to bottom index for each a shape 
    WesternIndex, //from left to right in each NorthIndex

    
    Region, //final. used for sequence stitching order.
    at: Cardinal; //attribute
    case Integer of
      0 : (X, Y : TFloat);
      1 : (Point : TFloatPoint);
  end;
  
  TArrayOfStitchPoint = array of TStitchPoint;
  PArrayOfStitchPoint = ^TArrayOfStitchPoint;

  TStitchLine = record
    Start,
    Finish : TStitchPoint;
  end;
  TArrayOfStitchLine = array of TStitchLine;
  PArrayOfStitchLine = ^TArrayOfStitchLine;

    //TStitchItem
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

  TEmbroideryItem = class(TgmShapeItem)
  private
    FStitchs : TArrayOfStitchPoint;
    function GetIni: PThredIniFile;
    function GetStitchs: PArrayOfStitchPoint;
    //function GetCollection: TEmbroideryList;
    function GetEmbroideryList: TEmbroideryList;

//    FFormType: TStitchFormType;
  protected
    //procedure SetCollection(const Value: TEmbroideryList); reintroduce;
  public
    procedure ResetFill; override;
    procedure Move(dx,dy:TFloat); override;

//    property FormType : TStitchFormType read FFormType write FFormType;
    //property PolyPolygon : PArrayOfgmShapeInfo read GetPolyPolygon;
    property ItemList: TEmbroideryList read GetEmbroideryList;// write SetCollection;

    property Ini : PThredIniFile read GetIni;
    property Stitchs : PArrayOfStitchPoint read GetStitchs;
  published
  end;


  TEmbroideryList = class(TgmShapeList)
  // each instance of this manage a single file, therefore manage a Single MDIChild editor. 
  private
    FHupSize : TFloatPoint;
    FCustomColors: TArrayOfTColor;
    FColors: TArrayOfTColor;
    FStitchs: TArrayOfTSHRTPNT2;
    FBgColor: TColor;
    FIni: PThredIniFile;
    FDesignerName: string;
    FThreadSize: T16Byte;
    function GetItem(Index: TgmCoreIndex): TEmbroideryItem;
    procedure SetItem(Index: TgmCoreIndex; const Value: TEmbroideryItem);
    function GetHup(const Index: Integer): TFloat;
    procedure SetHup(const Index: Integer; const Value: TFloat);
  protected
    class function GetItemClass : TCollectionItemClass; override;

  public
    constructor Create(AOwner: TComponent); override;
  
    class function GetFileReaders : TgmFileFormatsList; override;
    class function GetFileWriters : TgmFileFormatsList; override;

    property HupWidth : TFloat index 0 read GetHup write SetHup;
    property HupHeight : TFloat index 1 read GetHup write SetHup;
    property HupSize : TFloatPoint read FHupSize write FHupSize;

    property DesignerName : string read FDesignerName write FDesignerName;
    property ThreadSize : T16Byte read FThreadSize write FThreadSize;
    property BgColor : TColor read FBgColor write FBgColor;
    property Colors : TArrayOfTColor read FColors write FColors;
    property CustomColors : TArrayOfTColor read FCustomColors write FCustomColors;
    //property Forms : TArrayOfTFRMHED read FForms write FForms;
    property Stitchs : TArrayOfTSHRTPNT2 read FStitchs write Fstitchs;
    property Ini : PThredIniFile read FIni write FIni;
    property Items[Index: TgmCoreIndex]: TEmbroideryItem read GetItem write SetItem; default;

  end;
  
implementation

uses
  Embroidery_Defaults;


{ unit }
var
  UEmbroideryReaders, UEmbroideryWriters : TgmFileFormatsList;


{ TEmbroideryList }


constructor TEmbroideryList.Create(AOwner: TComponent);
begin
  inherited;
  FHupSize := FloatPoint(LHUPX, LHUPY);
  SetLength(FColors,16);
  Move(defCol[0], FColors[0], 4 * 16);
end;

class function TEmbroideryList.GetFileReaders: TgmFileFormatsList;
begin
 if not Assigned(UEmbroideryReaders) then
  begin
    UEmbroideryReaders := TgmFileFormatsList.Create;
  end;

  Result := UEmbroideryReaders;
end;

class function TEmbroideryList.GetFileWriters: TgmFileFormatsList;
begin
  if not Assigned(UEmbroideryWriters) then
  begin
    UEmbroideryWriters := TgmFileFormatsList.Create;
  end;

  Result := UEmbroideryWriters;
end;

function TEmbroideryList.GetHup(const Index: Integer): TFloat;
begin
  Result := 0;
  case Index of
    0 : Result := FHupSize.X;
    1 : Result := FHupSize.Y;
  end;
end;

function TEmbroideryList.GetItem(Index: TgmCoreIndex): TEmbroideryItem;
begin
  Result := TEmbroideryItem( inherited Items[index]);
end;

class function TEmbroideryList.GetItemClass: TCollectionItemClass;
begin
  Result := TEmbroideryItem;
end;


procedure TEmbroideryList.SetHup(const Index: Integer;
  const Value: TFloat);
begin
  case Index of
    0 : FHupSize.X := Value;
    1 : FHupSize.Y := Value;
  end;
end;

procedure TEmbroideryList.SetItem(Index: TgmCoreIndex;
  const Value: TEmbroideryItem);
begin
  inherited Items[index] := Value;
end;

{ TEmbroideryItem }

function TEmbroideryItem.GetEmbroideryList: TEmbroideryList;
begin
  Result := TEmbroideryList(GetItemList);
end;

function TEmbroideryItem.GetIni: PThredIniFile;
begin
  Result := nil;
  if Assigned(Collection) then
    Result := TEmbroideryList(Collection).Ini;
end;

function TEmbroideryItem.GetStitchs: PArrayOfStitchPoint;
begin
  Result := @FStitchs;
end;

procedure TEmbroideryItem.Move(dx, dy: TFloat);
var i : Integer;
begin
  inherited;
  for i := 0 to High(Stitchs^) do
  begin
    with Stitchs^[i] do
    begin
      Point := FloatPoint(X + dx,  y + dy );
    end;
  end;

end;

procedure TEmbroideryItem.ResetFill;
begin
  SetLength(FStitchs,0);
end;


end.
