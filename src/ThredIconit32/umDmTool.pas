unit umDmTool;

interface

uses
  SysUtils, Classes, ActnList, ImgList, Controls,
  GR32, GR32_Image, GR32_Layers, TBXGraphics, TBXImageList32;

type
  TdmTool = class(TDataModule)
    il1: TImageList;
    actlstTool: TActionList;
    actToolHand: TAction;
    actToolZoom: TAction;
    actToolShape: TAction;
    actToolLineNew: TAction;
    actToolLineInsert: TAction;
    actToolStitch: TAction;
    actToolLineEdit: TAction;
    actToolSelect: TAction;
    actShapeEllipse: TAction;
    actShapeStar: TAction;
    actShapeRegular: TAction;
    actGroupCombine: TAction;
    actGroupExtract: TAction;
    actGroupUnion: TAction;
    actGroupIntersect: TAction;
    actGroupTrim: TAction;
    il3: TImageList;
    actGroupXOR: TAction;
    actShapeDaisy: TAction;
    procedure actToolHandExecute(Sender: TObject);
    procedure actToolZoomExecute(Sender: TObject);
    procedure actToolLineModeExecute(Sender: TObject);
    procedure actToolShapeExecute(Sender: TObject);
    procedure actToolLineModeUpdate(Sender: TObject);
    procedure actToolSelectExecute(Sender: TObject);
    procedure actShapeExecute(Sender: TObject);
    procedure actShapeUpdate(Sender: TObject);
    procedure actGroupCombineExecute(Sender: TObject);
    procedure actGroupCanBeGroupedUpdate(Sender: TObject);
    procedure actAtleast1SelectionUpdate(Sender: TObject);
    procedure actGroupExtractExecute(Sender: TObject);
    procedure actGroupUnionExecute(Sender: TObject);
    procedure actGroupIntersectExecute(Sender: TObject);
    procedure actGroupTrimExecute(Sender: TObject);
    procedure actGroupXORExecute(Sender: TObject);
  private
    { Private declarations }
    procedure actToolLineAfterMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure actToolLineBeforeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure actToolLineFinalEdit(sender : TObject);
    procedure actToolChanging(sender : TObject; const Info : string);
  public
    { Public declarations }
  end;

var
  dmTool: TdmTool;

implementation

uses
    Graphics,gmIntegrator, gmShape,
    gmTool_Zoom,  gmTool_Hand,  gmTool_Shape, gmTool_Shape_Select,
    Forms,umChild, umMain,
    Clipper;

{$R *.dfm}


procedure TdmTool.actToolSelectExecute(Sender: TObject);
begin
  with TAction(sender) do
  begin
               //this call the integrator to use tgmToolShapeSelect
               // as current mouse listener (Editor Tool).
    Checked := gmSelectTool(TgmtoolShapeSelect);
    if Checked then
      with TgmtoolShapeSelect(gmActiveTool) do
      begin
        OnBeforeMouseDown := actToolLineBeforeMouseDown;
        OnFinalEdit       := actToolLineFinalEdit;
        OnChanging        := actToolChanging;
      end;

  end;
end;

procedure TdmTool.actToolHandExecute(Sender: TObject);
begin
  TAction(sender).Checked := gmSelectTool(TgmtoolHand);
end;

procedure TdmTool.actToolZoomExecute(Sender: TObject);
begin
  TAction(sender).Checked := gmSelectTool(TgmtoolZoom);
end;

procedure TdmTool.actToolShapeExecute(Sender: TObject);
begin
  with TAction(Sender) do
  begin
     // this call the integrator to use TgmtoolShape
     // as current mouse listener (Editor Tool).
     // if TgmtoolShape is available,
     // so the toolbutton(sender) is being checked
    Checked := gmSelectTool(TgmtoolShape);
    
    if Checked then
    begin
      with TgmtoolShape(gmActiveTool) do
      begin
        OnBeforeMouseDown := actToolLineBeforeMouseDown;
        OnAfterMouseUp    := actToolLineAfterMouseUp;
        OnFinalEdit       := actToolLineFinalEdit;
        OnChanging        := actToolChanging;
      end;
    end;
  end;
end;

procedure TdmTool.actToolLineModeExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShape then
      TgmtoolShape(gmActiveTool).EditMode := TgmEditMode(TAction(Sender).Tag);
end;


procedure TdmTool.actToolLineModeUpdate(Sender: TObject);
begin
  with TAction(Sender) do
  begin
    {
    Visible := gmActiveTool is TgmtoolStitchStrightLine;
    if Visible then
    }
    Enabled := gmActiveTool is TgmtoolShape;
    if Enabled then
      Checked := TgmtoolShape(gmActiveTool).EditMode = TgmEditMode(TAction(Sender).Tag);
  end;

end;


procedure TdmTool.actToolLineBeforeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
  LToolLine : TgmtoolShapeBase;
  //LForm : PgmShapeInfo;
begin
  assert(gmActiveTool is TgmtoolShapeBase);
  LToolLine := TgmtoolShape(gmActiveTool);

  //properties mapping
  if LToolLine is TgmtoolShape then
    TgmtoolShape(LToolLine).ShapeInfo.Star.VertexCount := TMainForm(Application.MainForm).spinVertex.Value;


  if (Button = mbLeft) {and (LToolLine.EditMode = emEditNode)} then
  begin

    with TfcDesign(Application.MainForm.ActiveMDIChild) do
    begin
      LToolLine.ShapeList := ShapeList;
      //LToolLine.PolyPolygons := PolyPolygons; //make link
      //LToolLine.Selections   := Selections; //link
    end;
///
{    LForm := Stitchs.GetNearestForm(
      //ActiveIntegrator.ActiveImg32.
      imgStitchs.ControlToBitmap( FloatPoint(X,Y) )
    );

    if LForm <> nil then
    begin
      LToolLine.AddSelection(LForm);
    end;
    }
  end;
end;

procedure TdmTool.actToolLineAfterMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
var
  //LPoints : TArrayOfFloatPoint;
  LToolLine : TgmtoolShape;
begin
  assert(gmActiveTool is TgmtoolShape);
  LToolLine := TgmtoolShape(gmActiveTool);

  if (Button = mbLeft) and (LToolLine.EditMode in [emNew, emAppendChild] )
    and (LToolLine.Modified)
  then
  begin
    //LToolLine.Modified := False;
    //LPoints := LToolLine.ShapePoints;
    //LForm := TfcDesign(Application.MainForm.ActiveMDIChild).AddShape(LToolLine.EditMode);
    //CloneShape(LToolLine.ShapeInfo^, LForm^ );
///    LForm.sids := Length(LPoints);
///    LForm.flt := LPoints;
  end;

  if (LToolLine.EditMode = emEditNode) and LToolLine.Modified then
  begin
    TfcDesign(Application.MainForm.ActiveMDIChild).DrawStitchs;
  end;

end;

procedure TdmTool.actShapeExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShape then
      TgmtoolShape(gmActiveTool).ShapeInfo.Kind := TgmShapekind(TAction(Sender).Tag);
end;

procedure TdmTool.actShapeUpdate(Sender: TObject);
begin
  with TAction(Sender) do
  begin
    {
    Visible := gmActiveTool is TgmtoolStitchStrightLine;
    if Visible then
    }
    Enabled := gmActiveTool is TgmtoolShape;
    if Enabled then
      Checked := TgmtoolShape(gmActiveTool).ShapeInfo.Kind = TgmShapeKind(TAction(Sender).Tag);
  end;
end;

procedure TdmTool.actToolLineFinalEdit(sender: TObject);
begin
  TfcDesign(Application.MainForm.ActiveMDIChild).DrawStitchs;
end;

procedure TdmTool.actGroupCombineExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).CombineSelection;
end;

procedure TdmTool.actGroupCanBeGroupedUpdate(Sender: TObject);
var LEnabled : Boolean;
begin
  with TAction(Sender) do
  begin
    {
    Visible := gmActiveTool is TgmtoolStitchStrightLine;
    if Visible then
    }
    LEnabled := (gmActiveTool is TgmtoolShapeBase);
    if LEnabled then
      LEnabled := Assigned(TgmtoolShape(gmActiveTool).ShapeList)
      and Assigned(TgmtoolShape(gmActiveTool).ShapeList.SelectionItems)
      and (TgmtoolShape(gmActiveTool).ShapeList.SelectionItems.Count > 1);
    Enabled := LEnabled;
  end;
end;

procedure TdmTool.actAtleast1SelectionUpdate(Sender: TObject);
var LEnabled : Boolean;
begin
  with TAction(Sender) do
  begin
    {
    Visible := gmActiveTool is TgmtoolStitchStrightLine;
    if Visible then
    }
    LEnabled := (gmActiveTool is TgmtoolShapeBase);
    if LEnabled then
      LEnabled := Assigned(TgmtoolShape(gmActiveTool).ShapeList)
      and Assigned(TgmtoolShape(gmActiveTool).ShapeList.SelectionItems)
      and (TgmtoolShape(gmActiveTool).ShapeList.SelectionItems.Count >= 1);
    Enabled := LEnabled;
  end;
//
end;

procedure TdmTool.actGroupExtractExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).ExtractSelection;
end;

procedure TdmTool.actGroupUnionExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).MakeUnionSelection;
end;

procedure TdmTool.actGroupIntersectExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).MakeIntersectSelection;
end;

procedure TdmTool.actGroupTrimExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).MakeTrimSelection;
end;

procedure TdmTool.actGroupXORExecute(Sender: TObject);
begin
  if gmActiveTool is TgmtoolShapeBase then
    TgmtoolShapeBase(gmActiveTool).MakeXorSelection;
end;

procedure TdmTool.actToolChanging(sender: TObject; const Info : string);
begin
  TfcDesign(Application.MainForm.ActiveMDIChild).UndoRedo.AllocateUndo(Info);
end;

end.
