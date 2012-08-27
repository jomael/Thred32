unit Unit2;
{unit gmGridBased;}

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

uses
{ Standard }
  Types, Classes, SysUtils, Graphics,
{ Graphics32 }
  GR32, GR32_LowLevel,
  gmFileFormatList;

type
  TgmGrowFlow = (ZWidth2Bottom,
                 NHeight2Right,
                 OSquaredGrow,
                 XStretchInnerGrow);


  TgmGridBasedItem = class(TCollectionItem)
  private
    
  protected
    FDisplayName     : string;
    FCachedBitmap: TBitmap32;
    FCachedBitmapValid : Boolean;
    procedure SetDisplayName(const Value: string); override;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    function CachedBitmap(AWidth, AHeight: Integer): TBitmap32;virtual;
    function GetHint:string; virtual;
  published
    property DisplayName;// read GetDisplayName write SetDisplayName;
  end;


  TgmGridBasedCollection = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;
  protected
    procedure Update(Item: TCollectionItem); override;
  
  public
    constructor Create(AOwner: TComponent); overload; virtual;
    constructor Create(AOwner: TComponent; ItemClass: TCollectionItemClass);overload;virtual;
    function IsValidIndex(index : Integer):Boolean;virtual;

    {"Simulating class properties in (Win32) Delphi"
    http://delphi.about.com/library/weekly/aa031505a.htm
    While (Win32) Delphi enables you to create class (static) methods
    (function or procedure), you cannot mark a property of a class to be a
    class (static) property. False. You can! Let's see how to simulate
    class properties using typed constants.}
    class function GetFileReaders : TgmFileFormatsList; virtual; abstract; 
    class function GetFileWriters : TgmFileFormatsList; virtual; abstract; 
    //property FileReaders : TgmFileFormatsList read GetFileReaders;

    //procedure RegisterGradientWriter(const AExtension, ADescription: string;
      //DescID: Integer; AWriterClass: TgmConverterClass);
    class procedure RegisterConverterReader(const AExtension, ADescription: string;
      DescID: Integer; AReaderClass: TgmConverterClass);
    class procedure RegisterConverterWriter(const AExtension, ADescription: string;
      DescID: Integer; AReaderClass: TgmConverterClass);
    class function ReadersFilter: string;
    class function WritersFilter: string;


    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    //procedure Move(CurIndex, NewIndex: Integer); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    function Draw(const AGradientIndex: Integer;
      const ACanvas: TCanvas; const ARect: TRect): Boolean;

    property OnChange             : TNotifyEvent    read FOnChange        write FOnChange;
    
  end;
  TgmGridBasedCollectionClass = class of TgmGridBasedCollection;


implementation

uses
  gmMiscFuncs;


{ TgmSwatchItem }

function TgmGridBasedItem.CachedBitmap(AWidth,
  AHeight: Integer): TBitmap32;
begin
  Result := nil; //descendant must override;
  if Assigned(FCachedBitmap) then
    Result := FCachedBitmap;
end;

constructor TgmGridBasedItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDisplayName := 'Custom';
end;

function TgmGridBasedItem.GetDisplayName: string;
begin
  Result := FDisplayName;
end;

function TgmGridBasedItem.GetHint: string;
begin
  Result := DisplayName;
end;

procedure TgmGridBasedItem.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

{ TgmGridBasedCollection }

constructor TgmGridBasedCollection.Create(AOwner: TComponent);
begin
  Create(AOwner,TgmGridBasedItem);
end;

constructor TgmGridBasedCollection.Create(AOwner: TComponent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner,ItemClass);
end;


function TgmGridBasedCollection.Draw(const AGradientIndex: Integer;
  const ACanvas: TCanvas; const ARect: TRect): Boolean;
var
  LGradientBmp: TBitmap32;
  LRect       : TRect;
  LItem       : TgmGridBasedItem;
begin
  Result := False;

  if not IsValidIndex(AGradientIndex) then
    raise Exception.Create('GridBasedCollection.Draw() -- Error: invalid index.');

  if not Assigned(ACanvas) then
  begin
    raise Exception.Create('GridBasedCollection.Draw() -- Error: Canvas is nil.');
  end;

  if IsRectEmpty(ARect) then
  begin
    raise Exception.Create('Rect is Empty');
  end;

  with ARect do
  begin
    LRect := MakeRect(0, 0, Right - Left, Bottom - Top);
  end;

  LItem := TgmGridBasedItem(items[agradientIndex]);
  //LGradientBmp := LItem.CachedBitmap(LRect.Right +1,LRect.Bottom + 1);

  LGradientBmp := TBitmap32.Create;
  LGradientBmp.SetSize(LRect.Right +1,LRect.Bottom + 1);
  DrawCheckerboard(LGradientBmp,LGradientBmp.BoundsRect);

  //DrawLinearGradient(LGradientBmp, LRect.TopLeft, LRect.BottomRight,
  //                   Items[agradientIndex], False);
  LGradientBmp.Draw(0,0,LItem.CachedBitmap(LRect.Right +1,LRect.Bottom + 1));

  LGradientBmp.DrawTo(ACanvas.Handle, ARect.Left, ARect.Top);
  LGradientBmp.Free;
end;

function TgmGridBasedCollection.IsValidIndex(index: Integer): Boolean;
begin
  Result := (index > -1) and (index < Count);
end;

procedure TgmGridBasedCollection.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create( ExpandFileName(FileName), fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TgmGridBasedCollection.LoadFromStream(Stream: TStream);
var
  //LFileHeader         : TgmGradientFileHeader;
  LFirstStreamPosition: Int64;
  i                   : Integer;
  LReader             : TgmConverter;
  LReaderClass        : TgmConverterClass;
  LReaders            : TgmFileFormatsList;
  LReaderAccepted     : Boolean;
  //SelfClass           : TgmGridBasedCollectionClass;
begin
  BeginUpdate;
  try
    //In case current stream position is not zero, we remember the position.
    LFirstStreamPosition := Stream.Position;


    // Because many reader has same MagicWord as their signature,
    // we want to ask all of them,
    // when anyone is accepting, we break.
    // if UGradientReaders.Find(IntToHex(MagicWord,8),i) then
    //  (UGradientReaders.Objects[i] as TgmCustomGradientReader).LoadFromStream(Stream,Self);
    LReaders := GetFileReaders;
    for i := 0 to (LReaders.Count -1) do
    begin
      LReaderClass := LReaders.Readers(i);

      //do test
      LReaderAccepted := LReaderClass.WantThis(Stream);

      //set to beginning stream
      Stream.Seek(LFirstStreamPosition,soFromBeginning);

      //do real dinner!
      if LReaderAccepted then
      begin
        LReader := LReaderClass.Create;
        try
          LReader.LoadFromStream(Stream,Self);
        finally
          LReader.Free;
        end;

        Break;
      end
    end;
  finally
    EndUpdate;
    Changed;    
  end;

end;


class function TgmGridBasedCollection.ReadersFilter: string;
var
  LFilters: string;
begin
  self.GetFileReaders.BuildFilterStrings(TgmConverter, Result, LFilters);
end;

class procedure TgmGridBasedCollection.RegisterConverterReader(
  const AExtension, ADescription: string; DescID: Integer;
  AReaderClass: TgmConverterClass);
begin
  self.GetFileReaders.Add(AExtension, ADescription, DescID,AReaderClass);
end;

class procedure TgmGridBasedCollection.RegisterConverterWriter(
  const AExtension, ADescription: string; DescID: Integer;
  AReaderClass: TgmConverterClass);
begin
  self.GetFileWriters.Add(AExtension, ADescription, DescID,AReaderClass);
end;

procedure TgmGridBasedCollection.SaveToFile(const FileName: string);
var
  LStream: TStream;
begin
  LStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(LStream);
  finally
    LStream.Free;
  end;
end;

procedure TgmGridBasedCollection.SaveToStream(Stream: TStream);
begin

end;

procedure TgmGridBasedCollection.Update(Item: TCollectionItem);
begin
  inherited;
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;

end;


class function TgmGridBasedCollection.WritersFilter: string;
var
  LFilters: string;
begin
  Self.GetFileWriters.BuildFilterStrings(TgmConverter, Result, LFilters);
end;

end.

