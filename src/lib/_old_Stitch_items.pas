unit _old_Stitch_items;//Stitch_items;
{unit gmGridBased}

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
  GR32, GR32_LowLevel,
  gmFileFormatList,
  Thred_Constants, Thred_Types;

type
  TStitchItem = class(TCollectionItem)
  private
    //Fat: Cardinal;
    Fy: Single;
    Fx: Single;
    FColorIndex: Byte;
    FLayerStackIndex: Byte;
  protected
    FDisplayName     : string;
    //FCachedBitmap: TBitmap32;
    //FCachedBitmapValid : Boolean;
    procedure SetDisplayName(const Value: string); override;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    //function CachedBitmap(AWidth, AHeight: Integer): TBitmap32;virtual;
    //function GetHint:string; virtual;
  published
    property DisplayName;// read GetDisplayName write SetDisplayName;
	  property x : Single read Fx write Fx;
	  property y : Single read Fy write Fy;
	  //property at: Cardinal read Fat write Fat;
    property ColorIndex : Byte read FColorIndex write FColorIndex;
    property LayerStackIndex: Byte read FLayerStackIndex write FLayerStackIndex; 
  end;


  TStitchCollection = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;
    FHeader: TSTRHED;
    FBName: string;
    FBgColor: TColor;
    FColors: TArrayOfTColor;
    FCustomColors: TArrayOfTColor;
    FThreadSize: T16Byte;
    FForms: TArrayOfTFRMHED;
    FStitchs: TArrayOfTSHRTPNT;
    FHeaderEx: TSTREX;
    FCurrentStreamFileName : TFileName;
    FFileName: TFilename;
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
    class function GetFileReaders : TgmFileFormatsList; virtual; 
    class function GetFileWriters : TgmFileFormatsList; virtual;  
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
    

    property OnChange             : TNotifyEvent    read FOnChange        write FOnChange;

    property Header : TSTRHED read FHeader write FHeader;
    property HeaderEx : TSTREX read FHeaderEx write FHeaderEx;
    property BName : string read FBName write FBName;
    property ThreadSize : T16Byte read FThreadSize write FThreadSize;
    property BgColor : TColor read FBgColor write FBgColor;
    property Colors : TArrayOfTColor read FColors write FColors;
    property CustomColors : TArrayOfTColor read FCustomColors write FCustomColors;
    property Forms : TArrayOfTFRMHED read FForms write FForms;
    property Stitchs : TArrayOfTSHRTPNT read FStitchs write Fstitchs;
    property FileName : TFilename read FFileName write FFileName;
  end;
  TStitchCollectionClass = class of TStitchCollection;


implementation

uses
  gmMiscFuncs;

var
  UStitchsReaders, UStitchsWriters : TgmFileFormatsList;  

{ TStitchsItem }


constructor TStitchItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDisplayName := 'Custom';
end;

function TStitchItem.GetDisplayName: string;
begin
  Result := FDisplayName;
end;


procedure TStitchItem.SetDisplayName(const Value: string);
begin
  FDisplayName := Value;
end;

{ TStitchCollection }

constructor TStitchCollection.Create(AOwner: TComponent);
begin
  Create(AOwner,TStitchItem);
end;

constructor TStitchCollection.Create(AOwner: TComponent;
  ItemClass: TCollectionItemClass);
begin
  inherited Create(AOwner,ItemClass);
end;




class function TStitchCollection.GetFileReaders: TgmFileFormatsList;
begin
 if not Assigned(UStitchsReaders) then
  begin
    UStitchsReaders := TgmFileFormatsList.Create;
  end;

  Result := UStitchsReaders;
end;

class function TStitchCollection.GetFileWriters: TgmFileFormatsList;
begin
  if not Assigned(UStitchsWriters) then
  begin
    UStitchsWriters := TgmFileFormatsList.Create;
  end;

  Result := UStitchsWriters;
end;

function TStitchCollection.IsValidIndex(index: Integer): Boolean;
begin
  Result := (index > -1) and (index < Count);
end;

procedure TStitchCollection.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  self.FileName := FileName;
  Stream := TFileStream.Create( ExpandFileName(FileName), fmOpenRead or fmShareDenyWrite);
  //Stream.Seek(0,soFromBeginning);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TStitchCollection.LoadFromStream(Stream: TStream);
var
  //LFileHeader         : TgmGradientFileHeader;
  LFirstStreamPosition: Int64;
  i                   : Integer;
  LReader             : TgmConverter;
  LReaderClass        : TgmConverterClass;
  LReaders            : TgmFileFormatsList;
  LReaderAccepted     : Boolean;
  //SelfClass           : TStitchCollectionClass;
begin
  BeginUpdate;
  try
    //In case current stream position is not zero, we remember the position.
    LFirstStreamPosition := Stream.Position;


    // Because many reader has same MagicWord as their signature,
    // we make a beauty contest: the way to choose a queen quickly.
    // when we anyone dealed to eat the rest of stream, this ceremony closed. :)
    // So, be carefull when make order list of "uses" unit of "stitch_rwXXX," !


    LReaders := GetFileReaders;
    for i := 0 to (LReaders.Count -1) do
    begin
      //Okay, there a beautifull guest coming.
      LReaderClass := LReaders.Readers(i);

      //We let them to taste the appetise:
      //Ask if she want to really eat the maincourse ?
      LReaderAccepted := LReaderClass.WantThis(Stream);

      //However, we back to the kitchen first, to prepare
      Stream.Seek(LFirstStreamPosition,soFromBeginning);

      //Here we go!
      //If she made an order menu, we are servicing her for the real dinner
      if LReaderAccepted then
      begin
        LReader := LReaderClass.Create;
        try
          LReader.LoadFromStream(Stream,Self);
        finally
          LReader.Free;
        end;

        //Okay, we've serviced one queen. we quit!
        Break;
      end

      //Oh? we haven't yet meet a queen? ask next other guest to be our queen if any.
    end;
  finally
    EndUpdate;
    Changed;    
  end;

end;


class function TStitchCollection.ReadersFilter: string;
var
  LFilters: string;
begin
  self.GetFileReaders.BuildFilterStrings(TgmConverter, Result, LFilters);
end;

class procedure TStitchCollection.RegisterConverterReader(
  const AExtension, ADescription: string; DescID: Integer;
  AReaderClass: TgmConverterClass);
begin
  self.GetFileReaders.Add(AExtension, ADescription, DescID,AReaderClass);
end;

class procedure TStitchCollection.RegisterConverterWriter(
  const AExtension, ADescription: string; DescID: Integer;
  AReaderClass: TgmConverterClass);
begin
  self.GetFileWriters.Add(AExtension, ADescription, DescID,AReaderClass);
end;

procedure TStitchCollection.SaveToFile(const FileName: string);
var
  LStream: TStream;
begin
  FCurrentStreamFileName := ExpandFileName(FileName); //some reader/writer always accept; sadly sometime they wrong. we anticipate this accident

  LStream := TFileStream.Create(FCurrentStreamFileName, fmCreate);
  try
    SaveToStream(LStream);
  finally
    LStream.Free;
  end;
end;

procedure TStitchCollection.SaveToStream(Stream: TStream);
var
  //LFileHeader         : TgmGradientFileHeader;
  LFirstStreamPosition: Int64;
  i                   : Integer;
  LWriter             : TgmConverter;
  LWriterClass        : TgmConverterClass;
  LWriters            : TgmFileFormatsList;
  LWriterAccepted     : Boolean;
  //SelfClass           : TStitchCollectionClass;
begin
  //BeginUpdate;
  try
    //In case current stream position is not zero, we remember the position.
    LFirstStreamPosition := Stream.Position;


    // Because many reader has same MagicWord as their signature,
    // we make a beauty contest: the way to choose a queen quickly.
    // when we anyone dealed to eat the rest of stream, this ceremony closed. :)
    // So, be carefull when make order list of "uses" unit of "stitch_rwXXX," !


    LWriters := GetFileWriters;

    //LEVEL 1, find the extention
    if FCurrentStreamFileName <> '' then
    begin
      LWriterClass  := LWriters.FindExt(ExtractFileExt(FCurrentStreamFileName));
      if Assigned(LWriterClass) then
      begin
        LWriter := LWriterClass.Create;
        try
          LWriter.SaveToStream(Stream,Self);
        finally
          LWriter.Free;
        end;
      end;
    end;
    { TODO -ox2nie -cmedium : 
Until now, we cant make sure wether first selected TWriter is as same as user prever to used.
Perhap we must integrated te Writers with the TSaveDialog }

  finally
    //EndUpdate;
    //Changed;    
  end;
end;

procedure TStitchCollection.Update(Item: TCollectionItem);
begin
  inherited;
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;

end;


class function TStitchCollection.WritersFilter: string;
var
  LFilters: string;
begin
  Self.GetFileWriters.BuildFilterStrings(TgmConverter, Result, LFilters);
end;

end.

