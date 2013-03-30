unit Embroidery_Viewer;

interface

uses
  Classes, Embroidery_Items,
  gmCore_Viewer, GR32_Image;

type
  TgmEmbroideryViewer = class(TgmCoreViewer)
  private
    FShapeList: TEmbroideryList;
    procedure DrawStitchs;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  
    //for universal file dialog
    procedure LoadFromFile(const FileName: string); override;
    function GetReaderFilter : string; override;
    function GetWriterFilter : string; override; 

  published

  end;
implementation

uses
  gmCore_Items, Embroidery_Painter, Embroidery_Fill;

{ TgmGraphicViewer }

constructor TgmEmbroideryViewer.Create(AOwner: TComponent);
begin
  inherited;
  FShapeList := TEmbroideryList.Create(self);
  ScaleMode := smOptimal;
  ScrollBars.Visibility := svHidden;
end;

destructor TgmEmbroideryViewer.Destroy;
begin
  FShapeList.Free;
  inherited;
end;

procedure TgmEmbroideryViewer.DrawStitchs;
var
  LPainter : TEmbroideryPainter ;
  j : Integer;
  LShapeItem : TEmbroideryItem;
begin
  LPainter :=  TEmbroideryPhotoPainter.Create(Self) ;//TEmbroideryPainter ;
  LPainter.WantToCalcRect := True;
  BeginUpdate;
  try
    Bitmap.SetSize(Round(FShapeList.HupWidth), Round(FShapeList.HupHeight));
      {LPainter.BeginPaint(Bitmap);

      if FShapeList.Count > 0 then
      //for i := 0 to FStitchs.Header.fpnt -1 do
      for j := 0 to FShapeList.Count -1 do
      begin
        LShapeItem := FShapeList[j];
        if Length(LShapeItem.Stitchs^) <= 0 then
          fnhrz(LShapeItem, nil);

        LPainter.Paint(Bitmap, LShapeItem);
      end;

    LPainter.EndPaint(Bitmap);}
    LPainter.Paint(FShapeList, epsPaint);
    LPainter.CropDrawnRect();
  finally
    EndUpdate;
    Changed;
    LPainter.Free;
  end;
end;

function TgmEmbroideryViewer.GetReaderFilter: string;
begin
  Result := TEmbroideryList.ReadersFilter;
end;

function TgmEmbroideryViewer.GetWriterFilter: string;
begin
  Result := TEmbroideryList.WritersFilter;
end;

procedure TgmEmbroideryViewer.LoadFromFile(const FileName: string);
begin
  FShapeList.LoadFromFile(FileName);
  DrawStitchs();
  //Self.Bitmap.Assign(FPicture.Graphic);
end;

initialization
  RegisterCoreViewer(TgmEmbroideryViewer);
end.
