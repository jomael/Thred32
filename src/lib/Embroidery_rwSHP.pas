unit Embroidery_rwSHP;

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

const
  THREDSHP = 'THREDSHP';

type
  TSHPFILEHED = record
    MagicWord   : array[0..7] of Char;
    HeaderSize  : Word; //in byte
    filever     : Word;
    revision    : Word;
    ShapeCount  : Word;
  end;

  TSHPE_CHUNK = record
    MagicWord   : array[0..3] of Char; //must be SHPE
    HeaderSize  : Word; //in bytes
    PolygonCount: Word;
    ItemSize    : Word;//in bytes
  end;

  TPOLY_CHUNK = record
    MagicWord   : array[0..3] of Char;  //must be POLY
    HeaderSize  : Word; //in bytes
    PointCount  : Word; //because Info didnt store the len of points
    DataSize    : Word;//in bytes, need for jump to next chunk
    info        : TgmShapeInfo;
  end;

  TEmbroiderySHPConverter = class(TgmConverter)
  private
  public
    //constructor Create; override;
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



{ TEmbroiderySHPConverter }

procedure TEmbroiderySHPConverter.LoadFromStream(AStream: TStream;
  ACollection: TCollection);
var
  LDesign : TEmbroideryList;
  LItem : TEmbroideryItem;
  LFileHdr : TSHPFILEHED;
  SHP : TSHPE_CHUNK;
  POLY : TPOLY_CHUNK;
  //LShape : TArrayOfgmShapeInfo;
  LShape : PgmShapeInfo;
  i,j : Integer;

begin
  LDesign := TEmbroideryList(ACollection.Owner);
  LDesign.Clear;

  AStream.Read(LFileHdr, SizeOf(TSHPFILEHED));

  for i := 0 to LFileHdr.ShapeCount -1 do
  begin
    LItem := TEmbroideryItem(LDesign.add);
    AStream.Read(SHP, SizeOf(SHP));

    //SetLength(LShape, SHP.PolygonCount);
    
    {LShape := LDesign.Items[i].PolyPolygon;
    SHP.MagicWord := 'SHPE';
    SHP.HeaderSize := SizeOf(TSHPE_CHUNK);
    SHP.PolygonCount := Length(LShape^);
    SHP.ItemSize := SizeOf(Linfo); //in bytes}

    for j := 0 to SHP.PolygonCount -1 do
    begin
      AStream.Read(POLY, SizeOf(POLY));
      //LShape[j] := POLY.info;
      SetLength(POLY.info.Points, POLY.PointCount);
      AStream.Read(POLY.info.Points[0], POLY.DataSize);
      LShape := LItem.Add;
      CloneShape(POLY.info, LShape^);
    end;

  end;

end;

procedure TEmbroiderySHPConverter.SaveToStream(AStream: TStream;
  ACollection: TCollection);
var
  LDesign : TEmbroideryList;
  LFileHdr : TSHPFILEHED;
  SHP : TSHPE_CHUNK;
  POLY : TPOLY_CHUNK;
  LShape : PArrayOfgmShapeInfo;
  Linfo  : TgmShapeInfo;//used for nullage Points
  i,j : Integer;

begin
  LDesign := TEmbroideryList(ACollection.Owner);
  LFileHdr.magicword := THREDSHP;
  LFileHdr.HeaderSize := SizeOf(TSHPFILEHED);
  LFileHdr.filever := 1;
  LFileHdr.revision := 0;
  LFileHdr.ShapeCount := LDesign.Count;
  AStream.Write(LFileHdr, SizeOf(TSHPFILEHED));

  for i := 0 to LDesign.Count -1 do
  begin
    LShape := LDesign.Items[i].PolyPolygon;
    SHP.MagicWord := 'SHPE';
    SHP.HeaderSize := SizeOf(TSHPE_CHUNK);
    SHP.PolygonCount := Length(LShape^);
    SHP.ItemSize := SizeOf(Linfo); //in bytes
    AStream.Write(SHP, SizeOf(SHP));

    for j := 0 to High(LShape^) do
    begin
      Linfo := LShape^[j];
      POLY.MagicWord := 'POLY';
      POLY.HeaderSize := SizeOf(TPOLY_CHUNK);
      POLY.PointCount := Length(Linfo.Points);
      POLY.DataSize := SizeOf(tfloatpoint) * Length(Linfo.Points);
      POLY.info := Linfo;
      POLY.info.Points := nil;
      AStream.Write(POLY, SizeOf(POLY));
      AStream.Write(LInfo.Points[0], POLY.DataSize);
    end;
  end;
end;


class function TEmbroiderySHPConverter.WantThis(AStream: TStream): Boolean;
begin
  Result := True; //beta, eat'em all!
end;

initialization
  TEmbroideryList.RegisterConverterReader('SHP','GM Polypolygon',0, TEmbroiderySHPConverter);
  TEmbroideryList.RegisterConverterWriter('SHP','GM Polypolygon',0, TEmbroiderySHPConverter);

end.
