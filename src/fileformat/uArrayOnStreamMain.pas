unit uArrayOnStreamMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, GR32;

type
  TFRMHEDO = packed record // #995
    at : Byte;		//attribute
    sids : Word;	//number of sides
    typ : Byte;	//type
    fcol : byte;	//fill color
    bcol : Byte;	//border color
    nclp : Word;	//number of border clipboard entries
    flt : TArrayOfFloatPoint ;	//points*
    //sacang : TSACANG;	//satin guidlines or angle clipboard fill angle
    clp : TArrayOfFloatPoint;	//border clipboard data*
    stpt : Word;	//number of satin guidlines
    wpar : Word;	//word parameter
    rct : TFloatRect;	//rectangle
    ftyp : Byte;	//fill type
    etyp : Byte;	//edge type
    fspac : Single;	//fill spacing
    //flencnt : TFLENCNT ;//fill stitch length or clpboard count
    //angclp : TFANGCLP;	//fill angle or clpboard data pointer
    esiz,	//border size
    espac,	//edge spacing
    elen : TFloat;	//edge stitch length
    res : word;	//pico length
  end;//FRMHEDO;
  
  TForm1 = class(TForm)
    grd1: TStringGrid;
    btn1: TButton;
    grd2: TStringGrid;
    btn2: TButton;
    btn3: TButton;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
    FFrmHed01 : TFRMHEDO;
    function IsEqueal( a,b : TFRMHEDO): Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var y : Integer;
  S : TFileStream;
  f : string;
  LFrmHed2 : TFRMHEDO;
begin
  f := ChangeFileExt(Application.ExeName,'.dat');


  //fill FLT 1
  SetLength(FFrmHed01.flt, grd1.RowCount);
  FFrmHed01.sids := grd1.RowCount;
  //RANDOM VALUES
  Randomize;
  
  with FFrmHed01 do
  begin
    rct   := FloatRect(grd1.ClientRect);
    typ   := Random(255);	//type
    fcol  := Random(255);	//fill color
    bcol  := Random(255);	//border color
    nclp  := Random(255);	//number of border clipboard entries

    stpt  := Random(255);	//number of satin guidlines
    wpar  := Random(255);	//word parameter

    ftyp  := Random(255);	//fill type
    etyp  := Random(255);	//edge type
    fspac := Random(255);	//fill spacing
    esiz  := Random(255);	//border size
    espac := Random(255);	//edge spacing
    elen  := Random(255);	//edge stitch length
    res   := Random(255);
  end;

  for y := 0 to grd1.RowCount -1 do
  begin
    FFrmHed01.flt[y].X := StrToIntDef(grd1.Cells[0,y], 0);
    FFrmHed01.flt[y].Y := StrToIntDef(grd1.Cells[1,y], 0);
  end;


  //SAVE FLT 1
  s := TFileStream.Create(f,fmCreate );
  s.Seek(0, soFromBeginning);

  //s.Write(FFrmHed0, SizeOf(TFRMHEDO)); //OKE
  s.Write(FFrmHed01, SizeOf(FFrmHed01));  // ALSO OKE
  for y := 0 to FFrmHed01.sids -1 do
  begin
    s.Write(FFrmHed01.flt[y], SizeOf(TFloatPoint) );
  end;
  FreeAndNil(s);
  s := nil;

  //---------------------------------------------------------------------

  //LOAD FLT 2
  FillChar(LFrmHed2, SizeOf(LFrmHed2),0);
  s := TFileStream.Create(f,fmOpenRead or fmShareDenyWrite );
  s.Seek(0, soFromBeginning);
  s.Read(LFrmHed2, SizeOf(TFRMHEDO));

  SetLength(LFrmHed2.flt, LFrmHed2.sids);
  for y := 0 to LFrmHed2.sids -1 do
  begin
    s.Read(LFrmHed2.flt[y], SizeOf(TFloatPoint) );
  end;
  FreeAndNil(s);

  //fill FLT 2

  for y := 0 to grd1.RowCount -1 do
  begin
    grd2.Cells[0,y] := FloatToStr(LFrmHed2.flt[y].X );
    grd2.Cells[1,y] := FloatToStr(LFrmHed2.flt[y].Y );

  end;

  //--------------------------------------------
  //DO CHECK
  if IsEqueal(LFrmHed2,FFrmHed01) then
    MessageDlg('Stream save/load success',mtInformation, [mbOK],0)
  else
    MessageDlg('Stream save/load FAILED',mtError, [mbOK],0);


end;

procedure TForm1.FormCreate(Sender: TObject);
var i : Integer;
begin
  Randomize;
  for i := 0 to grd1.RowCount -1 do
  begin
    grd1.Cells[0,i] := IntToStr(Random(100));
    grd1.Cells[1,i] := IntToStr((i+1)*100);
  end;


end;

function TForm1.IsEqueal(a, b: TFRMHEDO): Boolean;
var Y : Integer;
begin
  Result := True;
  
  if a.rct.Left <> b.rct.Left  then Result := False;
  if a.rct.Top <> b.rct.Top  then Result := False;
  if a.rct.Right <> b.rct.Right  then Result := False;
  if a.rct.Bottom <> b.rct.Bottom  then Result := False;

  if a.typ <> b.typ  then Result := False;
  if a.fcol<> b.fcol then Result := False;
  if a.bcol<> b.bcol then Result := False;
  if a.nclp<> b.nclp then Result := False;
  if a.stpt<> b.stpt then Result := False;
  if a.wpar<> b.wpar then Result := False;
  if a.ftyp<> b.ftyp then Result := False;
  if a.etyp<> b.etyp then Result := False;
  if a.fspac<> b.fspac then Result := False;
  if a.esiz<> b.esiz then Result := False;
  if a.espac<> b.espac then Result := False;
  if a.elen<> b.elen then Result := False;
  if a.res <> b.res  then Result := False;


  for y := 0 to grd1.RowCount -1 do
  begin
    if a.flt[y].X <> b.flt[y].X then
      Result := falSe;

    if a.flt[y].Y <> b.flt[y].Y then
      Result := falSe;
  end;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  if SizeOf(FFrmHed01.flt) = SizeOf(TFloatPoint) then
    MessageDlg('SizeOf(FFrmHed01.flt) = SizeOf(TFloatPoint)',mtInformation, [mbOK],0)
  else
    MessageDlg('SizeOf(FFrmHed01.flt) <> SizeOf(TFloatPoint)'#13 +
    Format('SizeOf(FFrmHed01.flt)=%d SizeOf(TFloatPoint)=%d',[SizeOf(FFrmHed01.flt) , SizeOf(TFloatPoint)]),mtError, [mbOK],0);

end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  if SizeOf(TArrayOfFloatPoint) = SizeOf(TFloatPoint) then
    MessageDlg('SizeOf(TArrayOfFloatPoint) = SizeOf(TFloatPoint)',mtInformation, [mbOK],0)
  else
    MessageDlg('SizeOf(TArrayOfFloatPoint) <> SizeOf(TFloatPoint)'#13 +
    Format('SizeOf(TArrayOfFloatPoint)=%d SizeOf(TFloatPoint)=%d',[SizeOf(TArrayOfFloatPoint), SizeOf(TFloatPoint)]) ,mtError, [mbOK],0);

end;

end.
