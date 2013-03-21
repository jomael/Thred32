unit umChild;

interface

uses
  Windows, Classes, Graphics, Forms, Controls, Messages, StdCtrls, SysUtils,
{GR32}
  GR32, GR32_Image, GR32_Layers,
{GraphicsMagic}
  gmIntegrator, //gmGridBased_List,
  //gmSwatch_List,
  gmIntercept_GR32_Image,
{Thred32}
  Embroidery_Items, Embroidery_Painter,
  Stitch_items, //Stitch_rwTHR, Stitch_rwPCS, Stitch_rwPES,
  Embroidery_rwTHR,

  Menus, ActnList, ComCtrls, ToolWin, ExtCtrls, gmCore_Items,
  gmGridBased, gmSwatch, gmShape ;

type
{$DEFINE MODERNITEM}

  TfcDesign = class(TForm)
    swlCustom: TgmSwatchList;
    imgStitchs: TImgView32;
    timerLazyLoad: TTimer;
    lblLoading: TLabel;
    pnl1: TPanel;
    pbPreview: TPaintBox32;
    Panel1: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actUseOrdinalColorExecute(Sender: TObject);
    procedure imgStitchsScroll(Sender: TObject);
    procedure timerLazyLoadTimer(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure imgStitchsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FModified: boolean;
    FStitchLoaded : boolean;
    gmSource : TgmIntegratorSource;
    FUseOrdinalColor: boolean;
    //FDrawLine : TEmbroidery_LineProc;
    FPainter  : TEmbroideryPainterClass;
    
    //FSelections : TArrayOfArrayOfInteger;// TArrayOfPArrayOfgmShapeInfo;
    //FShapes : TArrayOfTgmShapeInfo;
    //FPolyPolygons : TArrayOfArrayOfgmShapeInfo;
    FShapeList: TEmbroideryList;
    FDrawQuality: Integer;
    procedure SetDrawQuality(const Value: Integer);
    procedure SetUseOrdinalColor(const Value: boolean);
    function GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
    function GetSelections: PArrayOfArrayOfInteger;
//    function GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
//    procedure SetSelectedIndex(const Value: Integer);
//    function GetSelections: PArrayOfArrayOfInteger;
  protected
//    FSelectedIndex {PolyPolygon}: Integer;

    //fired when starting/during/ending a "move" or "size" window
    procedure WMEnterSizeMove(var Msg: TMessage) ; message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var Msg: TMessage) ; message WM_EXITSIZEMOVE;
    procedure WMPosChanging(var Msg : TMessage); message WM_WINDOWPOSCHANGING;


  public
    { Public declarations }
    procedure DrawStitchs;
//    function AddShape(AddMode: TgmEditMode; Index : Integer = -1) : PgmShapeInfo;
    procedure LoadFromFile(const AFileName: string);
    property DrawQuality : Integer read FDrawQuality write SetDrawQuality;// render func index
    property UseOrdinalColor : boolean read FUseOrdinalColor write SetUseOrdinalColor;    

    property Modified : boolean read FModified;
    {$IFDEF MODERNITEM}
    //new mode
    property ShapeList : TEmbroideryList read FShapeList;

    {$ELSE}
    //old mode
    property PolyPolygons : PArrayOfArrayOfgmShapeInfo read GetPolyPolygons;
//    property SelectedIndex {PolyPolygon}: Integer read FSelectedIndex write SetSelectedIndex;
    property Selections : PArrayOfArrayOfInteger {PArrayOfPArrayOfgmShapeInfo} read GetSelections;
    {$ENDIF}
  end;


//Global proc
procedure CreateMDIChild(const AFileName: string); //called by MainForm.


implementation
{.$DEFINE GR32_200UP}

uses
  {$IFDEF GR32_200UP}
  //GR32_PolygonsEx,
  GR32_Polygons,
  GR32_VectorUtils,
  GR32_PolygonsOld,
  {$ELSE}
  GR32_PolygonsEx, //VPR
  GR32_VectorUtils, //VPR
  {$ENDIF}

  Thred_Constants,
  Embroidery_Lines32, Embroidery_Defaults {Thred_Defaults} ,
  Embroidery_Fill,
  umMain, umDm, Math;

{$R *.dfm}
{$R VirtualTrees.res}

  function Polygon32Arc(CenterX,CenterY, DistanceX,DistanceY:TFloat; Vertices:integer):TArrayOfFloatPoint;
  var i : integer;
    fp : TFloatPoint;
    aPie : Double;
  begin
    aPie := 360 / Vertices;
    SetLength(Result, Vertices +1);
    for i := 0 to Vertices -1 do
    begin
      fp.X := round(centerX + cos(degtoRad(i * aPie))*DistanceX);
      fp.Y := round(centerY + sin(degToRad(i * aPie))*DistanceY);
      Result[i] := fp;
    end;
    Result[Vertices] := result[0];
  end;

type
  TImgView32Access = class(TImgVIew32);

  
procedure CreateMDIChild(const AFileName: string);
var
  Child: TfcDesign;
  x : PByteArray;
begin
  { create a new MDI child window }
  Child := TfcDesign.Create(Application);
  Child.Caption := AFileName;
  //if FileExists(AFileName) then Child.LoadFromFile(AFileName);
  if FileExists(AFileName) then
    Child.ShapeList.FileName := AFileName; // Lazy Loading. for avoid flicker / hang while first time visibled.
end;

procedure TfcDesign.FormCreate(Sender: TObject);
begin
  self.imgStitchs.Align := alClient;

  imgStitchs.Bitmap.SetSize(400,400);// hup size
  imgStitchs.Bitmap.Clear(clWhite32);
  
  gmSource := TgmIntegratorSource.Create(self);
  gmSource.Img32 := imgStitchs;

  FShapeList := TEmbroideryList.Create(self);
  //FDrawLine := Draw3DLine;//DrawLineStippled;//DrawLineFS;
  //FPainter  := TEmbroideryPainter;
  DrawQuality := DQINDOORPHOTO;//DQDEBUG;//  
  FUseOrdinalColor := True;

//  FSelectedIndex := -1;
//  SetLength(FSelections,0);
end;

procedure TfcDesign.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormClose', 0); {$ENDIF}

  Action := caFree;
  TMainForm(Application.MainForm).ActiveChild := nil; //send signal to MDI form for ready reflect changes. such color swatch
end;

procedure TfcDesign.LoadFromFile(const AFileName: string);
var
  i : integer;
begin
///
//  FStitchs.LoadFromFile(AFileName);
  FShapeList.LoadFromFile(AFileName);
{  for i := 0 to High(FStitchs.Colors) do
  begin
    if swlCustom.Count < i +1 then
      swlCustom.Add;
    swlCustom[i].Color := FStitchs.Colors[i];
  end;}
  DrawStitchs();
  {imgStitchs.Show;
  lblLoading.Hide;

  if Application.MainForm.ActiveMDIChild = Self then
    FormActivate(self); // send signal to MDI MainForm
  }
end;


procedure TfcDesign.FormActivate(Sender: TObject);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormActivate', 0); {$ENDIF}

  //send signal to MDI MainForm to reflect my (childform) properties; such colors swatch

  self.gmSource.Activate; //set ready to TgmTool
  if imgStitchs.Visible then
    imgStitchs.SetFocus; //allow mouse wheel

///  if Length(FStitchs.Stitchs) > 0 then
    TMainForm(Application.MainForm).ActiveChild := self;

end;

procedure TfcDesign.actUseOrdinalColorExecute(Sender: TObject);
begin
  self.DrawStitchs;
end;

procedure TfcDesign.DrawStitchs;
var
  LXorPoints: TArrayOfArrayOfFloatPoint;

  (*procedure LDrawSelectionXor();
  var i,j : Integer;
    LPoints : TArrayOfPoint;
    LCanvas : TCanvas;
  begin
    LCanvas := imgStitchs.Bitmap.Canvas;
    LCanvas.Pen.Mode := pmNotXor;

    for i := 0 to Length(LXorPoints) -1 do
    begin
      SetLength(LPoints, Length(LXorPoints[i]) );
      for j := 0 to Length(LXorPoints[i])-1 do
      begin
        LPoints[j] := Point( LXorPoints[i,j] );
      end;

      LCanvas.Polyline( LPoints );
    end;
  end;

  procedure LDrawSelection1();
  var i,j : Integer;
    LPoints : TArrayOfFloatPoint;
  begin


    for i := 0 to Length(LXorPoints) -1 do
    begin

      for j := 0 to Length(LXorPoints[i])-1 do
      begin
        //LPoints[j] := Point( LXorPoints[i,j] );
        with LXorPoints[i,j] do
          LPoints := Ellipse(x,y, 3,3, 12);

//        PolygonFS(imgStitchs.Bitmap, LPoints, clTrRed32);

      end;

    end;
  end;

  (*procedure LDrawSelection2();
  var i,j,k : Integer;
    LDotPoints : TArrayOfFloatPoint;
    LShapes : PArrayOfgmShapeInfo;
  begin
    for i := 0 to Length(FSelections) -1 do
    begin
      LShapes := FSelections[i];
      if LShapes <> nil then
      for j := 0 to Length(LShapes^)-1 do
      begin

        for k := 0 to Length(LShapes^[j].Points)-1 do
        begin
          with LShapes^[j].Points[k] do
            LDotPoints := Ellipse(x,y, 3,3, 12);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;

      {if FSelections[i]^ <> nil then
      for j := 0 to Length(FSelections[i]^)-1 do
      begin

        for k := 0 to Length(FSelections[i]^[j].Points)-1 do
        begin
          with FSelections[i]^[j].Points[k] do
            LDotPoints := Ellipse(x,y, 3,3, 12);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;}
    end;
  end;*)

  procedure LDrawSelection();
  var i,j,k : Integer;
    LDotPoints : TArrayOfFloatPoint;
    LShapes : PArrayOfgmShapeInfo;
    //LShapes : TgmShapeItem;
  begin
    for i := 0 to FShapeList.SelectionItems.count -1 do
    begin

      LShapes :=  TgmShapeItem(FShapeList.SelectionItems[i]).PolyPolygon;

      if LShapes <> nil then
      for j := 0 to Length(LShapes^)-1 do
      begin

        for k := 0 to Length(LShapes^[j].Points)-1 do
        begin
          with LShapes^[j].Points[k] do
            LDotPoints := Polygon32Arc(x,y, 3,3, 36);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;

      {if FSelections[i]^ <> nil then
      for j := 0 to Length(FSelections[i]^)-1 do
      begin

        for k := 0 to Length(FSelections[i]^[j].Points)-1 do
        begin
          with FSelections[i]^[j].Points[k] do
            LDotPoints := Ellipse(x,y, 3,3, 12);
          PolygonFS(imgStitchs.Bitmap, LDotPoints, clTrRed32);
        end;
      end;}
    end;
    SetLength(LDotPoints,0);
  end;

var i,j : Integer;
  zRat : TFloatPoint;
  ColorAt :Cardinal;
  LastColor,CurrentColor : TColor32;
  R : TFloatRect;
  LPoints : TArrayOfArrayOfFloatPoint;
  
  first : boolean;
  b : byte;
  C : TColor32;
  LShapeItem : TEmbroideryItem;
  LPolyPolyGon : TArrayOfgmShapeInfo;
  LStitchs : TArrayOfStitchPoint;
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'DrawStitchs', 0); {$ENDIF}


  //We will do painting while there is something to draw.
  //if Length(FStitchs.Stitchs) = 0 then exit;   But, we might have a new form.

  LastColor := clNone;

  imgStitchs.Bitmap.SetSize(Ceil(ShapeList.HupWidth), Ceil(ShapeList.HupHeight));

  zRat.X := ( imgStitchs.Width / ShapeList.HupWidth );
  zRat.Y := ( imgStitchs.Height / ShapeList.HupHeight );

  if zRat.X < zRat.Y then
    zRat.Y := zRat.X
  else
    zRat.X := zRat.Y;

  zRat.x := 1; //debug
  zRat.Y := 1; //debug


  with imgStitchs do
  begin
    BeginUpdate;
    try
      //Bitmap.Clear(clWhite32);

      //R := FloatRect(Bitmap.BoundsRect);
      //FDrawLine(Bitmap, R, clWhite32, sdlStart);
      FPainter.BeginPaint(Bitmap);

      if FShapeList.Count > 0 then
      //for i := 0 to FStitchs.Header.fpnt -1 do
      for j := 0 to FShapeList.Count -1 do
      begin
        LShapeItem := FShapeList[j];
        if Length(LShapeItem.Stitchs^) <= 0 then
          fnhrz(LShapeItem, nil);

        FPainter.Paint(Bitmap, LShapeItem);

        //STITCH
        //PArrayOfStitchPoint(LStitchs) := LShapeItem.Stitchs;
        {LStitchs := LShapeItem.Stitchs^;
        for i := 0 to High(LStitchs) do
        begin
          // Bitmap.PenColor:= clBlack32;
          with LStitchs[i] do
          begin
            ColorAt := at and $FF;
            if ColorAt > High(FShapeList.colors) then
              ColorAt := at and $0F;

            if UseOrdinalColor then
              CurrentColor := Color32( defCol[ ColorAt ] )
            else
              CurrentColor := Color32( FShapeList.Colors[ ColorAt ] );

            if i = 0 then
            begin
              R.TopLeft := floatPoint(x * zRat.X, y * zRat.Y);
            end
            else
            begin
              R.BottomRight := floatPoint(x * zRat.X, y * zRat.Y);

              //JUMP STITCH + COLOR CHANGED.
              if CurrentColor = LastColor then
              FDrawLine(Bitmap, R, CurrentColor, sdlLine);

              R.TopLeft := R.BottomRight;

            end;
            LastColor := CurrentColor;
            {if i = 0 then
              pb.Buffer.MoveToF(x * zRat.X, y * zRat.Y)
            else
              pb.Buffer.LineToFS(x * zRat.X, y * zRat.Y);
          end;
        end;
        //R := FloatRect(0,0, FShapeList.HeaderEx.xhup * zRat.X, FShapeList.HeaderEx.yhup * zRat.Y);

        R := FloatRect(Bitmap.BoundsRect);

        FDrawLine(Bitmap, R, Color32(FShapeList.BgColor), sdlFinish); }
        //fnhrz(TEmbroideryItem( FShapeList[i]), Bitmap);
        {
        LPolyPolyGon := FShapeList[i].PolyPolygon^;
        if Length(LPolyPolyGon) <= 0 then
          Continue;
          
        SetLength(LPoints, Length(LPolyPolyGon));
        for j := 0 to Length(LPolyPolyGon)-1 do
        begin
          if length(LPolyPolyGon[j].Points) = 0 then
            continue;
          LPoints[j] := LPolyPolyGon[j].Points;
        end;

        ActiveIntegrator.DoDebugLog(Self,
          Format('Points[%d]: %d',[i, Length(LPolyPolyGon) ]) ) ;

        PolyPolygonFS(Bitmap, LPoints, clTrRed32); //FPolyPolygons[i,0].BackColor);
        PolyPolylineFS(Bitmap, LPoints, clTrBlack32);

        //if i = FSelectedIndex then
          //LXorPoints := LPoints;
        }
      end;//for

      FPainter.EndPaint(Bitmap);

      //if FSelectedIndex >= 0 then
        LDrawSelection();

    finally
      SetLength(LPoints,0);
      EndUpdate;
      Changed;
    end;
  end;
end;

procedure TfcDesign.WMEnterSizeMove(var Msg: TMessage);
begin
  if csDestroying in Self.ComponentState then Exit;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'WMEnterSizeMove', 0); {$ENDIF}

  //code here
  inherited;
end;

procedure TfcDesign.WMExitSizeMove(var Msg: TMessage);
begin
  if csDestroying in Self.ComponentState then Exit;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'WMExitSizeMove', 0); {$ENDIF}

  //code here
  TMainForm(Application.MainForm).RullersRedraw;
  inherited
end;

procedure TfcDesign.WMPosChanging(var Msg: TMessage);
begin
  if csDestroying in Self.ComponentState then Exit;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'WMPosChanging', 0); {$ENDIF}

  //code here
  TMainForm(Application.MainForm).RullersRedraw;
  inherited;
end;

  
procedure TfcDesign.imgStitchsScroll(Sender: TObject);
begin
  TMainForm(Application.MainForm).RullersRedraw;
  //caption := format('%d, %d',[TImgView32Access(imgStitchs).HScroll.Range, TImgView32Access(imgStitchs).VScroll.Range]);
end;

procedure TfcDesign.timerLazyLoadTimer(Sender: TObject);
begin
  if not (csLoading in self.ComponentState) and self.Visible and not FStitchLoaded then
  begin
    timerLazyLoad.Enabled := False;
    FStitchLoaded := True;
////
    if FShapeList.FileName <> '' then
    begin
      self.LoadFromFile(FShapeList.FileName);
    end
    else
    begin

    end;

    imgStitchs.Show;
    lblLoading.Hide;

    if Application.MainForm.ActiveMDIChild = Self then
      FormActivate(self); // send signal to MDI MainForm
  end;

end;

procedure TfcDesign.SetDrawQuality(const Value: Integer);
begin
  if FDrawQuality <> Value then
  begin
    FDrawQuality := Value;
    //it is modified by my own (childform) render quality menu.
    case Value of
      //1 : FDrawLine := DrawWireFrame;
      2 : FPainter  := TEmbroideryPainter;  //Solid
      3 : FPainter  := TEmbroideryPhotoPainter;  //Photo
      4 : FPainter  := TEmbroideryOutDoorPhotoPainter;//Outdoor Photo
      5 : FPainter  := TEmbroideryMountainPainter;
      6 : FPainter  := TEmbroideryXRayPainter;        //
      7 : FPainter  := TEmbroideryHotPressurePainter;
      8 : FPainter  := TEmbroideryByLinPainter;
      9 : FPainter  := TEmbroideryByGrpPainter;
      10 : FPainter  := TEmbroideryByRegionPainter ;
      11 : FPainter  := TEmbroideryByJumpPainter ;
      12 : FPainter  := TEmbroideryByWesternPainter ;
    end;
    //pb.Repaint;
    self.DrawStitchs;
  end;
end;

procedure TfcDesign.SetUseOrdinalColor(const Value: boolean);
begin
  if FUseOrdinalColor <> Value then
  begin
    FUseOrdinalColor := Value;
    DrawStitchs;
  end;
end;

procedure TfcDesign.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if [ssShift, ssAlt] * Shift <> [] then //modifiered?
    imgStitchs.Scroll(16,0) //
  else
    imgStitchs.Scroll(0, 16) //end;
end;

procedure TfcDesign.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if [ssShift, ssAlt] * Shift <> [] then //modifiered?
    imgStitchs.Scroll(-16, 0) //
  else
    imgStitchs.Scroll(0, -16) //end;
end;

procedure TfcDesign.imgStitchsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'imgStitchsMouseDown', 0); {$ENDIF}

  //caption :=  inttostr(Ord(Button));
end;

(*function TfcDesign.AddShape(AddMode: TgmEditMode; Index : Integer = -1): PgmShapeInfo;
var
  Len, N : Integer;
  LPolygon : PArrayOfgmShapeInfo;
  LNewPoly2 : Boolean;
begin
  LNewPoly2 := (AddMode = emNew) or (Length(FPolyPolygons) = 0) or  (Index >= Length(FPolyPolygons) );
  if (Index = -1) or LNewPoly2 then  // the last?
  begin
    if LNewPoly2 then //Has no item, add!
    begin
      Len := Length(FPolyPolygons);
      SetLength(FPolyPolygons, Len+1);
    end;
    
    //LPolygon := @FPolyPolygons[ High(FPolyPolygons)];
    index := High(FPolyPolygons); // the last!
  end
  else
  begin
    //LPolygon := @FPolyPolygons[ Index ];
  end;


  LPolygon := @FPolyPolygons[ Index ];
  Len := Length(LPolygon^);
  SetLength(LPolygon^, Len + 1);
  Result := @LPolygon^[Len];

  //SELECT IT
  FSelectedIndex := index;
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self,Format('AddShapeInfoSelection %d %d',[index, Len]) ); {$ENDIF}
  AddShapeInfoSelection(index, Len, FPolyPolygons, FSelections);
end;  *)

{function TfcDesign.GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
begin
  Result := @FPolyPolygons;
end;}

(*procedure TfcDesign.SetSelectedIndex(const Value: Integer);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'SetSelectedIndex', 0); {$ENDIF}

  if FSelectedIndex <> Value then
  begin
    FSelectedIndex := Value;
    imgStitchs.Invalidate;
  end;
end;*)

{function TfcDesign.GetSelections: PArrayOfArrayOfInteger;
begin
  //Result := nil;
  //if FSelections <> nil then
    Result := @FSelections;
end;}

procedure TfcDesign.FormDestroy(Sender: TObject);
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'FormDestroy', 0); {$ENDIF}
//  ClearShapes(FPolyPolygons);
  //SetLength(FPolyPolygons,0);
//  FPolyPolygons := nil;
  //FSelections := nil;
//  SetLength(FSelections,0);
//  FSelections := nil;
end;

function TfcDesign.GetPolyPolygons: PArrayOfArrayOfgmShapeInfo;
begin

end;

function TfcDesign.GetSelections: PArrayOfArrayOfInteger;
begin

end;

end.
