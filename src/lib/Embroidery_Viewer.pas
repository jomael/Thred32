unit Embroidery_Viewer;

interface

uses
  Classes, Embroidery_Items,
  gmCore_Viewer;

type
  TgmEmbroideryViewer = class(TgmCoreViewer)
  private

  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  
    //for universal file dialog
    procedure LoadFromFile(const FileName: string); override;
    function GetReaderFilter : string; override;

  published

  end;
implementation

uses
  gmCore_Items;

{ TgmGraphicViewer }

constructor TgmEmbroideryViewer.Create(AOwner: TComponent);
begin
  inherited;
  //FPicture := TPicture.Create;

end;

destructor TgmEmbroideryViewer.Destroy;
begin
  //FPicture.Free;
  inherited;
end;

function TgmEmbroideryViewer.GetReaderFilter: string;
begin
  Result := TEmbroideryList.ReadersFilter;
end;

procedure TgmEmbroideryViewer.LoadFromFile(const FileName: string);
begin
  //FPicture.LoadFromFile(FileName);
  //Self.Bitmap.Assign(FPicture.Graphic);
end;

initialization
  RegisterCoreViewer(TgmEmbroideryViewer);
end.
