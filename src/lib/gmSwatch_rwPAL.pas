unit gmSwatch_rwPAL;
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
 * Ma Xiaoguang and Ma Xiaoming < gmbros@hotmail.com >
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
uses Classes,SysUtils,
  gmFileFormatList,gmSwatch ;

type
  TgmPALConverter = class(TgmConverter)
  public
    procedure LoadFromStream(Stream: TStream; ACollection: TCollection); override;
    procedure LoadItemFromString(Item :TgmSwatchItem; S : string);
    //procedure LoadItemFromStream(Stream: TStream; AItem: TCollectionItem); virtual; abstract;
    procedure SaveToStream(Stream: TStream; ACollection: TCollection); override;
    //procedure SaveItemToStream(Stream: TStream; AItem: TCollectionItem); virtual; abstract;
    class function WantThis(AStream: TStream): Boolean; override;
    //constructor Create; virtual;
  end;

implementation

uses
  Graphics,GR32;
{ TgmConverter }

procedure TgmPALConverter.LoadFromStream(Stream: TStream;
  ACollection: TCollection);
var
  LStrList : TStrings;
  z,i : Integer;
  LCollection : TgmSwatchCollection;
begin
  LCollection := TgmSwatchCollection(ACollection);
  LStrList := TStringList.Create;
  LStrList.LoadFromStream(Stream);
  try

    if LStrList.Count > 0 then
    begin
      z := StrToInt(Trim(LStrList[2]));
      for i := 4 to z -1 do
        LoadItemFromString(LCollection.Add,LStrList[i]);
    end;
  finally
    LStrList.Free;
  end;

end;

procedure TgmPALConverter.LoadItemFromString(Item: TgmSwatchItem; S: string);
var
  i,r,g,b : Byte;
  s2 : string;
begin
  i := Pos(' ',s);
  r := StrToInt(Trim(Copy(s,1,i)));
  Delete(s,1,i);

  i := Pos(' ',s);
  g := StrToInt(Trim(Copy(s,1,i)));
  Delete(s,1,i);

  b := StrToInt(Trim(Copy(s,1,100)));
  Item.Color := (b shl 16) or (g shl 8) or r;
  //s2 := Trim(Copy(s,19,255));
  //Item.DisplayName := s2;
end;

procedure TgmPALConverter.SaveToStream(Stream: TStream;
  ACollection: TCollection);
var
  LStrList : TStrings;
  i : Integer;
  Color : TColor;
  r,g,b : Byte;
  s : string;
  LCollection : TgmSwatchCollection;
  LItem : TgmSwatchItem;
begin
  if ACollection.Count <= 0 then exit;

  LCollection := TgmSwatchCollection(ACollection);
  LStrList := TStringList.Create;
  try
      LStrList.Add(Format('%-6d %s',[LCollection.Count, LCollection.Description]));

      //z := StrToInt(Trim(Copy(LStrList[0],1,4)));
      for i := 0 to LCollection.Count -1 do
      begin
        //LoadItemFromString(LCollection.Add,LStrList[i]);
        LItem := LCollection[i];
        Color := LItem.Color;

        LStrList.Add(Format('%6d%6d%6d%s',[RedComponent(Color),
          GreenComponent(Color),BlueComponent(Color),LItem.DisplayName]))
      end;

    LStrList.SaveToStream(Stream);
  finally
    LStrList.Free;
  end;


end;

class function TgmPALConverter.WantThis(AStream: TStream): Boolean;
var s8 : string[8];
begin
  Result := false;
  AStream.Read(s8[1],8);
  SetLength(s8,8);
  Result := s8 = 'JASC-PAL';
end;

initialization
  TgmSwatchCollection.RegisterConverterReader('PAL','Palette File',0, TgmPALConverter);
  TgmSwatchCollection.RegisterConverterWriter('PAL','Palette File',0, TgmPALConverter);
end.
