unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GR32_RangeBars,
  GR32, GR32_Image,
  gmShape, Thred_Types, Thred_Constants, Thred_Defaults,
  Embroidery_Items, Embroidery_Painter, Embroidery_Fill_lcon2, gmRuller ;

type
  TfrmMain = class(TForm)
    pnlStatusBar: TPanel;
    pnlHint: TPanel;
    pnlZoom: TPanel;
    gau1: TGaugeBar;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    chkDrawgrid: TCheckBox;
    chkVideo: TCheckBox;
    gbrSpace1: TGaugeBar;
    btnNewStar: TButton;
    btn_bakseq: TButton;
    rg1: TRadioGroup;
    Memo1: TMemo;
    imgStitchs: TImgView32;
    rulV: TgmRuller;
    rulH: TgmRuller;
    tmrVideo: TTimer;
    chkOseq: TCheckBox;
    tmrOseq: TTimer;
    procedure btnNewStarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gau1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure imgStitchsScroll(Sender: TObject);
    procedure chkVideoClick(Sender: TObject);
    procedure tmrVideoTimer(Sender: TObject);
    procedure btn_bakseqClick(Sender: TObject);
    procedure chkOseqClick(Sender: TObject);
    procedure tmrOseqTimer(Sender: TObject);
  private
    { Private declarations }
    FIni : TThredIniFile;
    FShapeList: TEmbroideryList;
    FPainter  : TEmbroideryPainter;
    FUnzoomedStitchWindowWidth ,
    FUnzoomedStitchWindowHeight :Integer;
    FStitchBackgroundColor : TColor;
    FMultiply: Single;
    FLCON : TLCON;
    FVideoPosition : Integer;

    procedure DrawStitchs;
    procedure ReadIni;
    procedure SetMultiply(const Value: Single);
  protected
    procedure Verbose(const VerboseMsg : string);
    property imgvwDrawingArea : TImgView32 read  imgStitchs;
    property Multiply : Single read FMultiply write SetMultiply;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation
uses Math, Embroidery_Fill;
{$R *.dfm}

procedure TfrmMain.btnNewStarClick(Sender: TObject);
var
  x,y : Integer;
  LShape : TEmbroideryItem;
  LPolygon : PgmShapeInfo;
begin
  FShapeList.ClearSelections;
  FShapeList.Clear;
  LShape := TEmbroideryItem(FShapeList.Add);
  LPolygon := LShape.Add;

  LPolygon.Centroid := FloatPoint(
        //imgStitchs.Bitmap.Width div 2-1,
        //imgStitchs.Bitmap.Height div 2-1
        FIni.HoopXSize /2, FIni.HoopYSize /2
  );
  //LPolygon.Delta := FloatPoint( LPolygon.Centroid.X /3 *2, LPolygon.Centroid.Y /3 * 2);
  LPolygon.Delta := FloatPoint( 162, 171);
  LPolygon.Kind := skStar;
  LPolygon.Star.VertexCount := 5;
  LPolygon.Star.Straight := True;

  BuildStarPoints(LPolygon^, [smAngled]);

  //TStarForm(FStitchForm).EndingPoint := Point(x + 162, y + 171);
  Self.DrawStitchs;
end;

procedure TfrmMain.DrawStitchs;
var
  LXorPoints: TArrayOfArrayOfFloatPoint;


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
  M : TBitmap32;
  BackgroundFileName : string;
begin
  {$IFDEF DEBUGLOG} ActiveIntegrator.DoDebugLog(Self, 'DrawStitchs', 0); {$ENDIF}


  //We will do painting while there is something to draw.
  //if Length(FStitchs.Stitchs) = 0 then exit;   But, we might have a new form.

  LastColor := clNone;

  //imgStitchs.Bitmap.SetSize(Ceil(FShapeList.HupWidth), Ceil(FShapeList.HupHeight));

  zRat.X := ( imgStitchs.Width / FShapeList.HupWidth );
  zRat.Y := ( imgStitchs.Height / FShapeList.HupHeight );

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

      //if not FPainter.WantToClear then      begin
        BackgroundFileName := ExtractFilePath(Application.ExeName)+'\Assets\bg.bmp';
        if FileExists(BackgroundFileName) then
        begin
          M:= TBitmap32.Create;
          try
            M.LoadFromFile(BackgroundFileName);
            for i := 0 to Bitmap.Height div M.Height do
            for j := 0 to Bitmap.Width div M.Width do
            begin
              M.DrawTo(Bitmap, j * M.Width, i* M.Height);
            end;
          finally
            M.Free;
          end;
          FPainter.WantToClear := False;
        end
        else
          //Bitmap.Clear(clWhite32);
          FPainter.WantToClear := True;
      //end;

      //

      //R := FloatRect(Bitmap.BoundsRect);
      //FDrawLine(Bitmap, R, clWhite32, sdlStart);
//      FPainter.BeginPaint(Bitmap);

      if FShapeList.Count > 0 then

      for j := 0 to FShapeList.Count -1 do
      begin
        LShapeItem := FShapeList[j];

        // DO FILLING ALGORITHM HERE, IF NECESSARY
        if Length(LShapeItem.Stitchs^) <= 0 then
        begin
          fnhrz(LShapeItem, nil);
          rulV.ZeroPixel := Round(LShapeItem.Stitchs^[0].Y);
          //LCON(LShapeItem);
        end;
      end;

      FPainter.Paint(FShapeList);

        //LDrawSelection();

    finally
      SetLength(LPoints,0);
      EndUpdate;
      Changed;
    end;
  end;
end;

procedure TfrmMain.ReadIni;
var
  LFileName      : string;
  i, LFileHandle : Integer;
  LReadBytes     : Cardinal;
begin
  LFileName := ParamStr(0);
  LFileName := ChangeFileExt(LFileName, '.ini');

  if FileExists(LFileName) then
  begin
    LFileHandle := CreateFile( PAnsiChar(LFileName), GENERIC_READ, 0, nil, OPEN_EXISTING, 0, 0);

    ReadFile(LFileHandle, FIni, SizeOf(FIni), LReadBytes, nil);

    if LReadBytes < 2061 then
    begin
      FIni.FormBoxPixels := DEFAULT_FORM_BOX_PIXELS;
    end;

    {for i := 0 to 15 do
    begin
      FUserColors[i]        := FIni.StitchColors[i];
      FCustomColors[i]      := FIni.PrefStitchColors[i];
      FBackCustomColors [i] := FIni.BackColors[i];
      FBitmapColors[i]      := FIni.BitmapBackColors[i];
    end;
    }
    FStitchBackgroundColor     := FIni.StitchBackColor;
    {FBitmapColor               := FIni.BitmapColor;
    FMinSize                   := FIni.MinSize;
    FShowStitchPointsThreshold := FIni.ShowPoints;

    if FIni.ThreadSize30 <> 0.0 then
    begin
      FThreadSize30 := FIni.ThreadSize30;
    end;

    if FIni.ThreadSize40 <> 0.0 then
    begin
      FThreadSize40 := FIni.ThreadSize40;
    end;

    if FIni.ThreadSize60 <> 0.0 then
    begin
      FThreadSize60 := FIni.ThreadSize60;
    end;

    if FIni.UserSize <> 0.0 then
    begin
      FUserSize := FIni.UserSize;
    end;

    if FIni.MaxSize = 0.0 then
    begin
      FIni.MaxSize := DEFAULT_MAX_STITCH_SIZE * PFGRAN;
    end;

    if FIni.SmallSize <> 0.0 then
    begin
      FSmallSize := FIni.SmallSize;
    end;

    FStitchBoxesThreshold := FIni.StitchBoxLevel;

    if FIni.StitchSpace <> 0.0 then
    begin
      FStitchSpace := FIni.StitchSpace;
    end;

    FuMap := FIni.umap;

    if FIni.BorderWidth <> 0.0 then
    begin
      FBorderWidth := FIni.BorderWidth;
    end;

    if FIni.AppliqueColor <> 0 then
    begin
      FAppliqueColor := FIni.AppliqueColor and $F;
    end;

    if FIni.SnapLength <> 0.0 then
    begin
      FSnapLength := FIni.SnapLength;
    end;

    if FIni.StarRatio <> 0.0 then
    begin
      FStarRatio := FIni.StarRatio;
    end;

    if FIni.SpiralWrap <> 0.0 then
    begin
      FSpiralWrap := FIni.SpiralWrap;
    end;

    if FIni.ButtonholeFillCornerLength <> 0.0 then
    begin
      FButtonholeFillCornerLength := FIni.ButtonholeFillCornerLength;
    end;

    if FIni.GridSize = 0.0 then
    begin
      FIni.GridSize := 12;
    end;

    if FIni.WavePoints = 0 then
    begin
      FIni.WavePoints := DEFAULT_WAVE_POINTS;
    end;

    if FIni.WaveStart = 0 then
    begin
      FIni.WaveStart := DEFAULT_WAVE_START;
    end;

    if FIni.WaveEnd = 0 then
    begin
      FIni.WaveEnd := DEFAULT_WAVE_END;
    end;

    if FIni.WaveLobes = 0 then
    begin
      FIni.WaveLobes := DEFAULT_WAVE_LOBES;
    end;

    if FIni.FeatherFillType = 0 then
    begin
      FIni.FeatherFillType := DEFAULT_FEATHER_TYPE;
    end;

    if FIni.FeatherUpCount = 0 then
    begin
      FIni.FeatherUpCount := DEFAULT_FEATHER_UP_COUNT;
    end;

    if FIni.FeatherDownCount = 0 then
    begin
      FIni.FeatherDownCount := DEFAULT_FEATHER_DOWN_COUNT;
    end;

    if FIni.FeatherRatio = 0.0 then
    begin
      FIni.FeatherRatio := DEFAULT_FEATHER_RATIO;
    end;

    if FIni.FeatherFloor = 0.0 then
    begin
      FIni.FeatherFloor := DEFAULT_FEATHER_FLOOR;
    end;

    if FIni.FeatherNum = 0 then
    begin
      FIni.FeatherNum := DEFAULT_FEATHER_NUM;
    end;

    if FIni.DaisyHoleLength = 0 then
    begin
      FIni.DaisyHoleLength := DAISY_HOLE_LENGTH;
    end;

    if FIni.DaisyCount = 0 then
    begin
      FIni.DaisyCount := DAISY_COUNT;
    end;

    if FIni.DaisyInnerCount = 0 then
    begin
      FIni.DaisyInnerCount := DAISY_INNER_COUNT;
    end;

    if FIni.DaisyLength = 0.0 then
    begin
      FIni.DaisyLength := DAISY_LENGTH;
    end;

    if FIni.DaisyPetals = 0 then
    begin
      FIni.DaisyPetals := DAISY_PETALS;
    end;

    if FIni.DaisyPetalLength = 0 then
    begin
      FIni.DaisyPetalLength := DAISY_PETAL_LENGTH;
    end;
    }
    case THoopSetting(FIni.HoopType) of
      hsSmallHoop:
        begin
          FIni.HoopXSize := SMALL_HOOP_X_SIZE;
          FIni.HoopYSize := SMALL_HOOP_Y_SIZE;
        end;

      hsLargeHoop:
        begin
          FIni.HoopXSize := LARGE_HOOP_X_SIZE;
          FIni.HoopYSize := LARGE_HOOP_Y_SIZE;
        end;

      hsCustomHoop:
        begin
          if FIni.HoopXSize <> 0.0 then
          begin
            FIni.HoopXSize := LARGE_HOOP_X_SIZE;
          end;

          if FIni.HoopYSize <> 0.0 then
          begin
            FIni.HoopYSize := LARGE_HOOP_Y_SIZE;
          end;
        end;

      hsHoop100:
        begin
          if FIni.HoopXSize <> 0.0 then
          begin
            FIni.HoopXSize := Hoop_100_XY_Size;
          end;

          if FIni.HoopYSize <> 0.0 then
          begin
            FIni.HoopYSize := Hoop_100_XY_Size;
          end;
        end;

    else
      FIni.HoopType  := Ord(hsLargeHoop);
      FIni.HoopXSize := LARGE_HOOP_X_SIZE;
      FIni.HoopYSize := LARGE_HOOP_Y_SIZE;
    end;

    FUnzoomedStitchWindowWidth  := Round(FIni.HoopXSize);
    FUnzoomedStitchWindowHeight := Round(FIni.HoopYSize);
    //FPicotSpace                 := FIni.PicotSpace;

    FileClose(LFileHandle);
  end
  else
  begin
    //DefaultPreference;
  end;

  if FIni.GridColor = 0 then
  begin
    FIni.GridColor := GRID_DEFAULT_COLOR;
  end;

  if FIni.FillAngle = 0.0 then
  begin
    FIni.FillAngle := PI / 6;
  end;

  if FIni.InitRect.Left < 0 then
  begin
    FIni.InitRect.Left := 0;
  end;

  if FIni.InitRect.Top < 0 then
  begin
    FIni.InitRect.Top := 0;
  end;

  if FIni.InitRect.Right > imgvwDrawingArea.Bitmap.Width then
  begin
    FIni.InitRect.Right := imgvwDrawingArea.Bitmap.Width;
  end;

  if FIni.InitRect.Bottom > imgvwDrawingArea.Bitmap.Height then
  begin
    FIni.InitRect.Bottom := imgvwDrawingArea.Bitmap.Height;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FShapeList := TEmbroideryList.Create(self);
  FPainter := TEmbroideryDebugRgnsPainter.Create(imgStitchs);
  imgStitchs.Align := alClient;

  FMultiply := 1;  
  ReadIni();
  FIni.StitchSpacing := gbrSpace1.Position/10;

  FLCON := TLCON.Create;
  FLCON.VerboseProc := Verbose;
  FLCON.Ini := FIni;
  imgvwDrawingArea.Bitmap.SetSize( Round(FIni.HoopXSize), Round(FIni.HoopYSize) );
  //imgvwDrawingArea.Bitmap.Clear( Color32(FStitchBackgroundColor) );
  imgvwDrawingArea.Bitmap.Clear( clBlack32 );

  btnNewStarClick(Sender);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FLCON.Free;
end;

procedure TfrmMain.gau1Change(Sender: TObject);
var
  LScale : single;
const
  scales : array[0..5] of single = (0.25, 0.50, 1, 2,4, 8);  
begin
  LScale := scales[gau1.Position];
  pnlZoom.Caption := format('%.0f%%', [Lscale*100]);
  //if assigned(ActiveChild) then
    //ActiveChild.
    //imgStitchs.Scale := LScale;
  Multiply := LScale;

end;

procedure TfrmMain.SetMultiply(const Value: Single);
begin
  if FMultiply <> Value then
  begin
    FMultiply := Value;
    imgvwDrawingArea.Bitmap.SetSize( Round(FIni.HoopXSize * FMultiply), Round(FIni.HoopYSize * FMultiply) );
    FPainter.Multiply := FMultiply;

    DrawStitchs;
  end;
end;



procedure TfrmMain.Button2Click(Sender: TObject);
VAR I : Integer;
begin
  if FShapeList.Count < 1 then
    btnNewStarClick(Sender);

  FLCON.ResetVars(sender);
  FLCON.lcon(FShapeList[0]);
  Self.DrawStitchs;

  {for i := 0 to self.FLCON.opnt - 1 do
  with self.FLCON.bseq[i] do
  begin
    Memo1.Lines.Add(Format('bseq[%d] x:%.0f y:%.0f att:%d',[i, x, y, attr]))
  end;}

end;

procedure TfrmMain.Verbose(const VerboseMsg: string);
begin
  Memo1.Lines.Add(VerboseMsg);
end;

procedure TfrmMain.imgStitchsScroll(Sender: TObject);
begin
  rulV.Repaint;
  rulH.Repaint;
end;

procedure TfrmMain.chkVideoClick(Sender: TObject);
  procedure DrawVertices();
  var y,x,w,lx,ly,i,LSides : Integer;

  begin
    {LSides := Length(FStitchForm.FormPoints);

    //draw VERTEX
    with imgvwDrawingArea.Bitmap.Canvas do
    begin
      with FStitchForm.FormPoints[0] do
      begin
        imgvwDrawingArea.Bitmap.Canvas.MoveTo(x, y);
        lx := x;
        ly := y;
      end;
      Pen.Width := 2;
      Font.Size := 42;
      Brush.Style := bsClear;

      for i := 0 to LSides do
      begin
        Pen.Color := WinColor(c[(VERTICES+i-1) mod VERTICES]);

        with FStitchForm.FormPoints[i mod LSides] do
        begin
          LineTo(x,y);
          lx := x;
          ly := y;
        end;
      end;
    
      //text
      with FStitchForm.FormPoints[0] do
      begin
        lx := x;
        ly := y;
      end;
      //VERTICE
      for i := 1 to (LSides ) do
      begin
        Font.Color := WinColor(c[(VERTICES+i-1) mod VERTICES]);

        with FStitchForm.FormPoints[i mod LSides] do
        begin
          TextOut(lx + (x-lx)div 2, ly + (y-ly)div 2, IntToStr(i-1));
          lx := x;
          ly := y;
        end;
      end;

      //CORNER
      Font.Size := 18;
      for i := 0 to (LSides -1) do
      begin
        Font.Color := WinColor(c[(VERTICES+i) mod VERTICES]);

        with FStitchForm.FormPoints[i mod LSides] do
        begin
          TextOut(X, Y, IntToStr(i));

        end;
      end;

    end;
    imgvwDrawingArea.Bitmap.Font.Color := clWhite;
    w := imgvwDrawingArea.Bitmap.TextWidth('9') div 2;
    for i := Low(seq) to High(seq) do
    begin
      x := Round(seq[i]^.X);
      y := 230;
      imgvwDrawingArea.Bitmap.Textout(x-w, y, IntToStr(seq[i]^.grp div 10) );
      inc(y,12);
      imgvwDrawingArea.Bitmap.Textout(x-w, y, IntToStr(seq[i]^.grp mod 10) );
    end;
    imgvwDrawingArea.Bitmap.Font.Color := clBlack;
   }
  end;
begin
  if chkVideo.Checked then
  begin
    imgvwDrawingArea.Bitmap.Clear( clBlack32 );
    DrawVertices();
    FVideoPosition := 0;
    tmrVideo.Enabled := True;
  end
  else
  begin
    tmrVideo.Enabled := False;
    imgvwDrawingArea.Bitmap.Clear( Color32(FStitchBackgroundColor) );
    //RedrawFill(Self);
  end;
end;

procedure TfrmMain.tmrVideoTimer(Sender: TObject);
var
    i,j,w,h,t: Integer;
 opnt : Integer;
begin
  opnt := Length(self.FLCON.bseq);
  if opnt > 1 then
  with self.FLCON do
  begin
    Inc(FVideoPosition);
    if FVideoPosition = 0 then
      Inc(FVideoPosition);

    if FVideoPosition > opnt then
    begin
      //chkVideo.Checked := False;
      tmrVideo.Enabled := false;
      exit;
    end;  

    i := FVideoPosition;

    //imgvwDrawingArea.Bitmap.PenColor := clBlack32;
    imgvwDrawingArea.Bitmap.MoveToF(bseq[i-1].x, bseq[i-1].y);
    //for i := 1 to (opnt - 1) do
    begin
      imgvwDrawingArea.Bitmap.PenColor := c[bseq[i].attr mod VERTICES];

      imgvwDrawingArea.Bitmap.LineToFS(bseq[i].x, bseq[i].y);
    end;

    h := imgvwDrawingArea.Bitmap.TextHeight(chr(122)) div 2 ;
    //for i := 0 to (opnt - 1) do
    begin
      w := imgvwDrawingArea.Bitmap.TextWidth(IntToStr(i)) ;
      t := ((i mod 50) div 10) * h;
      with Point(Round(bseq[i].x), Round(bseq[i].y)) do
      begin
        imgvwDrawingArea.Bitmap.FillRectS(x , y-h +t , x + w, y-h + h*2 -1 +t, c[bseq[i].attr mod VERTICES]);
        //imgvwDrawingArea.Bitmap.Textout( Round(bseq[ii].x), Round(bseq[ii].y) , IntToStr(ii));
        imgvwDrawingArea.Bitmap.Textout(x, y-h +t , IntToStr(i));

      end;
    end;

    imgvwDrawingArea.Bitmap.Changed;
  end;

end;

procedure TfrmMain.btn_bakseqClick(Sender: TObject);
begin
  FLCON.bakseq();
  Memo1.Lines.Add('SEQPNT='+IntToStr(FLCON.seqpnt)) 
end;

procedure TfrmMain.chkOseqClick(Sender: TObject);
begin
  if chkOseq.Checked then
  begin
    imgvwDrawingArea.Bitmap.Clear( clBlack32 );
    //DrawVertices();
    FVideoPosition := 0;
    tmrOseq.Enabled := True;
  end
  else
  begin
    tmrVideo.Enabled := False;
    imgvwDrawingArea.Bitmap.Clear( Color32(FStitchBackgroundColor) );
    //RedrawFill(Self);
  end;

end;

procedure TfrmMain.tmrOseqTimer(Sender: TObject);
var
    i,j,w,h,t: Integer;
 opnt : Integer;
begin
  //opnt := Length(self.FLCON.oseq);
  opnt := FLCON.seqpnt;
  
  if opnt > 1 then
  with self.FLCON do
  begin
    Inc(FVideoPosition);
    if FVideoPosition = 0 then
      Inc(FVideoPosition);

    if FVideoPosition > opnt then
    begin
      //chkVideo.Checked := False;
      tmrOseq.Enabled := false;
      exit;
    end;

    i := FVideoPosition;

    //imgvwDrawingArea.Bitmap.PenColor := clBlack32;
    imgvwDrawingArea.Bitmap.MoveToF(oseq[i-1].x, oseq[i-1].y);
    //for i := 1 to (opnt - 1) do
    begin
      imgvwDrawingArea.Bitmap.PenColor := c[5 mod VERTICES];

      imgvwDrawingArea.Bitmap.LineToFS(oseq[i].x, oseq[i].y);
    end;

    h := imgvwDrawingArea.Bitmap.TextHeight(chr(122)) div 2 ;
    //for i := 0 to (opnt - 1) do
    begin
      w := imgvwDrawingArea.Bitmap.TextWidth(IntToStr(i)) ;
      t := ((i mod 50) div 10) * h;
      with Point(Round(oseq[i].x), Round(oseq[i].y)) do
      begin
        imgvwDrawingArea.Bitmap.FillRectS(x , y-h +t , x + w, y-h + h*2 -1 +t, c[5 mod VERTICES]);
        //imgvwDrawingArea.Bitmap.Textout( Round(bseq[ii].x), Round(bseq[ii].y) , IntToStr(ii));
        imgvwDrawingArea.Bitmap.Textout(x, y-h +t , IntToStr(i));

      end;
    end;

    imgvwDrawingArea.Bitmap.Changed;
  end;

end;

end.
