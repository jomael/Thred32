unit gmTool_Stitch_StrightLine;

interface

uses
{$IFDEF FPC}
  LCLIntf, LCLType, LMessages, Types,
{$ELSE}
  Windows, Messages,
{$ENDIF}
  Graphics, Controls, Forms,
  Classes, SysUtils,
  GR32, GR32_Image, GR32_Layers, GR32_Types,
  gmTools, Thred_Types;

type

  TgmEditMode = (emNew, emAppendChild, emEditNode);

  TgmtoolStitchStrightLine = class(TgmTool)
  private
    FXorPointss : TArrayOfArrayOfPoint;
    FShapePoints        : TArrayOfFloatPoint;
    FStartPoint,
    FEndPoint       : TFloatPoint;
    FLeftButtonDown : Boolean;
    FAngled : Boolean;
    FShift : TShiftState; //for redraw by shift-keyboard-down

    //FDragging : Boolean;
    FTempLayer : TRubberbandLayer;
    FEditMode: TgmEditMode;
    FVertexCount: Integer;
    FSelections: TArrayOfPFRMHED;
    FXorDrawn : Boolean;
    function CorrectLocation(P1,P2:TPoint):TRect ;
    procedure ClearPoints;
    procedure DrawStarOnCanvas;
    procedure DrawSelectionXOR;
    procedure DrawStarOnBackground;
    procedure SetAngled(const Value: Boolean);
    procedure Reset; //Esc pressed
    procedure RebuildXorPoint;
    procedure SetEditMode(const Value: TgmEditMode); //avoid too many convertion
  protected


    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer); override;
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer); override;
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer); override;
    procedure KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); override;

    //RELATED MODE
    procedure ShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure ShapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

    procedure NodeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure NodeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure NodeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

{
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
}

    property Angled : Boolean read FAngled write SetAngled;
  public
    function IsCanFinish:Boolean; override;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure ClearSelection;
    procedure AddSelection(Afrm : PFRMHED);

    property EditMode : TgmEditMode read FEditMode write SetEditMode;
    property VertexCount : Integer read FVertexCount write FVertexCount;
    property ShapePoints : TArrayOfFloatPoint read FShapePoints;
    property Selections : TArrayOfPFRMHED read FSelections write FSelections;
  published 

  end;


implementation
uses
  Math,
  GR32_Polygons,
  gmIntegrator, gmShape_StraightStar;

type
  TCustomImgViewAccess = class(TCustomImage32);//hack!
  TLayerCollectionAccess = class(TLayerCollection);


function TgmtoolStitchStrightLine.CorrectLocation(P1, P2: TPoint): TRect;
begin
  //topleft
  Result.Left := min(P1.X ,P2.X);
  Result.Top  := min(P1.Y, P2.Y);
  //bottomright
  Result.Right  := Max(P1.X ,P2.X);
  Result.Bottom := Max(P1.Y ,P2.Y);
end;

constructor TgmtoolStitchStrightLine.Create(AOwner: TComponent);
begin
  inherited;
  //Cursor := crGrWandPlus;//crGrZoomIn;
  FVertexCount := 5;
end;

destructor TgmtoolStitchStrightLine.Destroy;
begin
  isCanFinish();//free temp layer
  inherited;
end;

function TgmtoolStitchStrightLine.isCanFinish: Boolean;
begin
  result := True;
  if Assigned(FTempLayer) then
  begin
    FTempLayer.Free;
    FTempLayer := nil;
  end;
  ClearPoints;
  ClearSelection;
  FModified := False;
  {$IFDEF DEBUGLOG} DebugLog('isCanFinish' ); {$ENDIF}
end;

procedure TgmtoolStitchStrightLine.ClearPoints;
begin
  if Length(FShapePoints) > 0 then
  begin
    SetLength(FShapePoints, 0);
  end;

  FShapePoints := nil;
end;

procedure TgmtoolStitchStrightLine.DrawStarOnCanvas;
var
  i, LPointCount : Integer;
  LPoints        : TArrayOfPoint;
  LCanvas : TCanvas;
begin
  LPoints     := nil;
  LPointCount := Length(FShapePoints);

  if LPointCount > 1 then
  begin
    LCanvas := Image32.Bitmap.Canvas;
    SetLength(LPoints, LPointCount);
    try
      for i := 0 to (LPointCount - 1) do
      begin
        //LPoints[i] := Self.Image32.BitmapToControl( Point(FPolygon[i]) );
        LPoints[i] := Point(FShapePoints[i]);
      end;

      if LCanvas.Pen.Mode <> pmNotXor then
      begin
        LCanvas.Pen.Mode := pmNotXor;
      end;

      LCanvas.Polyline(LPoints);
    finally
      SetLength(LPoints, 0);
      LPoints := nil;
    end;
  end;
end;

procedure TgmtoolStitchStrightLine.RebuildXorPoint;
var i,j : Integer;
  dx, dy : TFloat;
begin
  dx := FEndPoint.X - FStartPoint.X;
  dy := FEndPoint.Y - FStartPoint.Y;
  SetLength(FXorPointss, Length(FSelections));
  for i := 0 to Length(FSelections) -1 do
  begin
    SetLength(FXorPointss[i], Length(FSelections[i].flt));
      for j := 0 to Length(FSelections[i].flt)-1 do
      begin
        //LPoints[i] := Point(FShapePoints[i]);
        with FSelections[i].flt[j] do
          FXorPointss[i][j] := Point(FloatPoint(X + dx, Y + dy));
      end;
  end;
end;


procedure TgmtoolStitchStrightLine.DrawSelectionXOR;
var i,j : Integer;
  LCanvas : TCanvas;
begin
  LCanvas := Image32.Bitmap.Canvas;
  if LCanvas.Pen.Mode <> pmNotXor then
      begin
        LCanvas.Pen.Mode := pmNotXor;
      end;
  FXorDrawn := not FXorDrawn;
  for i := 0 to Length(FXorPointss) -1 do
  begin
    LCanvas.Polyline(FXorPointss[i]);
  end;
end;

procedure TgmtoolStitchStrightLine.DrawStarOnBackground;
var
  i, LPointCount : Integer;
  LPolygon       : TPolygon32;
  LFillColor     : TColor32;
begin
  LPointCount := Length(FShapePoints);

  if LPointCount > 2 then
  begin
    LPolygon := TPolygon32.Create;
    try

      for i := 0 to (LPointCount - 1) do
      begin
        LPolygon.Add( FixedPoint(FShapePoints[i]) );
      end;

      LFillColor := clTrGreen32; //Color32(shpFillColor.Brush.Color);
      LPolygon.Draw(Self.Image32.Bitmap, LFillColor, LFillColor);
    finally
      LPolygon.Free;
    end;
  end;
end;

procedure TgmtoolStitchStrightLine.MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  case EditMode of
    emNew,
    emAppendChild :
        ShapeMouseDown(Sender, Button, Shift, x,y, Layer);

    emEditNode :
        NodeMouseDown(Sender, Button, Shift, x,y, Layer);
  end;
end;

//draw marque box indicating area to be zoomed
procedure TgmtoolStitchStrightLine.MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer; Layer: TCustomLayer);

begin
  case EditMode of
    emNew,
    emAppendChild :
        ShapeMouseMove(Sender, Shift, x,y, Layer);

    emEditNode :
        NodeMouseMove(Sender, Shift, x,y, Layer);
  end;
end;

procedure TgmtoolStitchStrightLine.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  case EditMode of
    emNew,
    emAppendChild :
        ShapeMouseUp(Sender, Button, Shift, x,y, Layer);

    emEditNode :
        NodeMouseUp(Sender, Button, Shift, x,y, Layer);
  end;
end;


procedure TgmtoolStitchStrightLine.KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LAngled : Boolean;
begin
  case Key of
    VK_CONTROL :
        begin
          Angled := False;
        end;
    VK_ESCAPE :
      begin
        Reset;
      end;
  end;
  //DebugLog('KeyDown:'+ IntToStr(key));
end;

procedure TgmtoolStitchStrightLine.KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_CONTROL :
        begin
          Angled := True;
        end;
  end;
  //DebugLog('KeyUp:'+ IntToStr(key));
end;

procedure TgmtoolStitchStrightLine.SetAngled(const Value: Boolean);
begin
  if FAngled <> Value then
  begin
    FAngled := Value;
    if FLeftButtonDown then
    begin
      with Image32.BitmapToControl(Point(FEndPoint)) do
        self.MouseMove(Image32, FShift, X, Y, nil );
      {$IFDEF DEBUGLOG} DebugLog('Angled set to '+booltostr(FAngled) ); {$ENDIF}
    end;
  end;
end;

procedure TgmtoolStitchStrightLine.Reset;
begin
  if FLeftButtonDown then
  begin
    FLeftButtonDown := False;
    case EditMode of
      emNew,
      emAppendChild :
          begin
            DrawStarOnCanvas;
            ClearPoints;
          end;

      emEditNode :
          begin
             DrawSelectionXOR;
             FEndPoint := FStartPoint;
             RebuildXorPoint;
             DrawSelectionXOR;
          end;
          
    end;
    FModified := False;
  end;
end;

procedure TgmtoolStitchStrightLine.AddSelection(Afrm: PFRMHED);
var L : Integer;
begin
  L := Length(FSelections);
  SetLength(FSelections, L+1 );
  FSelections[L] := Afrm;
end;

procedure TgmtoolStitchStrightLine.ClearSelection;
begin
  SetLength(FSelections, 0);
  SetLength(FXorPointss, 0);
end;

procedure TgmtoolStitchStrightLine.ShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
  LPoint : TFloatPoint;
begin
  if Button = mbLeft then
  begin

    FAngled := not (ssCtrl in Shift); //initial

    LPoint := self.Image32.ControlToBitmap( FloatPoint(X, Y) );

    ClearPoints;

    FStartPoint := LPoint;
    FEndPoint   := LPoint;

    FShapePoints    := GetStraightStarPoints(FStartPoint, FEndPoint, FVertexCount, FAngled);

//    DebugLog(Format('%d points. first: %d,%d',[Length(FPolygon), FPolygon[i]));
    DrawStarOnCanvas;

    FLeftButtonDown := True;

//    StatusBar1.Panels[0].Text := Format('Last Down at ( X = %d, Y = %d )', [LPoint.X, LPoint.Y]);
  end;
end;

procedure TgmtoolStitchStrightLine.ShapeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  LPoint : TFloatPoint;
begin
  if FLeftButtonDown then
  begin
    FModified := True;
    // erase the old figure
    Image32.Bitmap.BeginUpdate;
    DrawStarOnCanvas;

    // get new points of the figure

    FEndPoint := self.Image32.ControlToBitmap( FloatPoint(X, Y) );

    FShapePoints  := GetStraightStarPoints(FStartPoint, FEndPoint, self.FVertexCount, FAngled);


    DrawStarOnCanvas;
    Image32.Bitmap.EndUpdate;
    Image32.Invalidate;
  end;
end;

procedure TgmtoolStitchStrightLine.ShapeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  if FLeftButtonDown then
  begin
    FLeftButtonDown := False;
    DrawStarOnCanvas;
    //DrawStarOnBackground;
  end;

end;

procedure TgmtoolStitchStrightLine.NodeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  if Button = mbLeft then
  begin
    if FXorDrawn then
      DrawSelectionXOR;
      
    FStartPoint := self.Image32.ControlToBitmap( FloatPoint(X, Y) );
    FEndPoint := FStartPoint;
    FLeftButtonDown := True;
    if Length(FSelections) > 0 then
    begin
      RebuildXorPoint;
      DrawSelectionXOR;
    end;

  end;
end;

procedure TgmtoolStitchStrightLine.NodeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if FLeftButtonDown and (Length(FSelections) > 0) then
  begin
    FModified := True;
    // erase the old figure
    Image32.Bitmap.BeginUpdate;
    DrawSelectionXOR;
    // get new points of selection
    FEndPoint := self.Image32.ControlToBitmap( FloatPoint(X, Y) );
    
    RebuildXorPoint;
    DrawSelectionXOR;
    
    Image32.Bitmap.EndUpdate;
    Image32.Invalidate;
  end;
end;

procedure TgmtoolStitchStrightLine.NodeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var i,j : Integer;
  dx, dy : TFloat;
begin
  {$IFDEF DEBUGLOG} DebugLog('NodeMouseUp'); {$ENDIF}
  
  if FLeftButtonDown then    //only interest on Left Mouse
  begin
    FLeftButtonDown := False;

    { TODO -ox2nie : in future, better to using Transformation class rather than inplace transform. }
    dx := FEndPoint.X - FStartPoint.X;
    dy := FEndPoint.Y - FStartPoint.Y;
    //if FStartPoint <> FEndPoint then //incompatible error
    FModified := (dx <> 0) and (dy <> 0);
    if FModified then
    begin

      for i := 0 to Length(FSelections) -1 do
      begin
          for j := 0 to Length(FSelections[i].flt)-1 do
          begin
            //LPoints[i] := Point(FShapePoints[i]);
            with FSelections[i].flt[j] do
            begin
              //FXorPointss[i][j] := Point(FloatPoint(X + dx, Y + dy));
              x := X + dx;
              y := Y + dy;
            end;
          end;
      end;
      //Image32.Invalidate;
    end;
  end;
end;




procedure TgmtoolStitchStrightLine.SetEditMode(const Value: TgmEditMode);
begin
  if FEditMode <> Value then
  begin
    //Reset;
    isCanFinish;
    FEditMode := Value;
  end;
end;

end.
