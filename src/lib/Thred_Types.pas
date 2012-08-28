unit Thred_Types;

interface

uses
{ Standard }
  Windows, Graphics,
  GR32,
{ Thred32 }
  Thred_Constants;

type
  TOldNameCharArray = array [0..OLDNUM - 1, 0..MAX_PATH - 1] of Char;
  T16Colors = array [0..15] of TColor;
  T16Byte   = array [0..15] of Byte;

  TFLPNT = type TFloatPoint;
  TFLRCT = type TFloatRect;
  
  TBSEQPNT = packed record
    x,
    y : Single;
    attr: Byte;
  end;//BSEQPNT;



  TSTRHED = packed record 		//structure thred file header
    led : Cardinal;
    len : Cardinal;	//length of strhed + length of stitch data
    stchs,	        //number of stitches
    hup,	  //size of hup
    fpnt,	  //number of forms
    fpnts,	//points to form points
    fcnt,	  //number of form points
    spnts,	//points to dline data
    scnt,	  //dline data count
    epnts,	//points to clipboard data
    ecnt : WORD;	//clipboard data count
  end; //STRHED

  TSHRTPNT = packed  record //thred stitch structure
    x,
    y : Single;
    at: Cardinal;
  end;

  TTXPNT = packed record		//textured fill point
    y : Single;
    lin : SmallInt;
  end; //TXPNT;


  //thred v1.0 file header extension
  TSTREX = packed record
    xhup,		//hoop size x dimension
    yhup,		//hoop size y dimension
    stgran : Single		;		//stitches per millimeter
    crtnam : array[1..50] of char;	//name of the file creator
    modnam : array[1..50] of char;	//name of last file modifier
    auxfmt : char;		//auxillary file format
    stres  : char;		//reserved
    txcnt  : Cardinal;		//textured fill point count
    res : array[1..26] of char;	//reserved for expansion
  end; //STREX

  //pcs file header structure
  THED = packed record
    ledIn,
    hup : Byte;
    fColCnt : Word;
    fCols : T16Colors;
    stchs : Word;
  end; //HED;

  // thred.h #668
  TFeatherFillTypes = ( FTHSIN=1,  // sine
                        FTHSIN2,	 // half sine
                        FTHLIN,	   // line
                        FTHPSG,	   // psuedo-random sequence
                        FTHRMP,	   // sawtooth
                        FTHFAZ );  // phase

  // ini file structure (INIFIL in thred.h, #691)
  TThredIniFile = packed record
    DefaultDir                 : array [0..179] of Char;           // default directory    {defDir[180];}
    StitchColors               : T16Colors;                         // colors    {stchCols[16];}
    PrefStitchColors           : T16Colors;                         // stitch preference colors    {selStch[16];}
    BackColors                 : T16Colors;                         // background preference colors    {bakCol[16];}
    StitchBackColor            : TColor;                           // background color    {stchBak;}
    BitmapColor                : TColor;                           // bitmap color    {bitCol;}
    MinSize                    : Double;                           // minimum stitch length    {minsiz;}
    ShowPoints                 : Double;                           // show stitch points    {shopnts;}
    ThreadSize30               : Double;                           // millimeter size of 30 weight thread    {tsiz30;}
    ThreadSize40               : Double;                           // millimeter size of 40 weight thread    {tsiz40;}
    ThreadSize60               : Double;                           // millimeter size of 60 weight thread    {tsiz60;}
    UserSize                   : Double;                           // user stitch length    {usesiz;}
    MaxSize                    : Double;                           // maximum stitch length    {maxsiz;}
    SmallSize                  : Double;                           // small stitch size    {smalsiz;}
    StitchBoxLevel             : Double;                           // show stitch box level    {stchboxs;}
    StitchSpacing              : Double;                           // stitch spacing between lines of stitches    {stspace;}
    FillAngle                  : Double;                           // fill angle    {angl;}
    umap                       : Cardinal;                         // bitmap {TODO: don't know which name is proper yet}    {umap;}
    BorderWidth                : Double;                           // border width    {brdwid;}
    AppliqueColor              : Cardinal;                         // applique color    {apcol;}
    OldNames                   : TOldNameCharArray;                // last file names    {oldnams[OLDNUM][MAX_PATH];}
    SnapLength                 : Double;                           // snap together length    {snplen;}
    StarRatio                  : Double;                           // star ratio    {starat;}
    SprialWrap                 : Double;                           // sprial wrap    {spirwrap;}
    BitmapBackColors           : T16Colors;                         // bitmap background color preferences    {bakBit[16];}
    ButtonholeFillCornerLength : Double;                           // buttonhole fill corner length    {bfclen;}
    PicotSpace                 : Single;                           // space between border picots    {picspac;}
    HoopType                   : Byte;                             // hoop type    {hup;}
    MachineFileType            : Byte;                             // machine file type    {auxfil;}
    HoopXSize                  : Single;                           // hoop x size    {hupx;}
    HoopYSize                  : Single;                           // hoop y size    {hupy;}
    RotationAngle              : Double;                           // rotation angle;    {rotang;}
    GridSize                   : Single;                           // grid size;    {grdsiz;}
    ClipboardOffset            : Single;                           // clipboard offset    {clpof;}
    InitRect                   : TRect;                            // initial window coordinates    {irct;}
    GridColor                  : TColor;                           // grid color    {grdbak;}
    ClipboardFillPhase         : Cardinal;                         // clipboard fill phase    {faz;}
    CustomHoopWidth            : Single;                           // custom hoop width    {xcust;}
    CustomHoopHeight           : Single;                           // custom hoop height    {ycust;}
    trlen                      : Single;                           // lens points {TODO: don't know which name is proper yet}    {trlen;}
    TraceRatio                 : Double;                           // trace ratio    {trcrat;}
    ChainSpace                 : Single;                           // chain space    {chspac;}
    ChainRatio                 : Single;                           // chain ratio    {chrat;}
    CursorNudgeStep            : Single;                           // cursor nudge step    {nudg;}
    NudgePixels                : Word;                             // nudge pixels    {//nudge pixels}
    EggRatio                   : Single;                           // egg ratio    {egrat;}
    StitchPointPixelSize       : Word;                             // size of stitch points in pixels    {stchpix;}
    FormPointPixelSize         : Word;                             // size of form points in pixels    {frmpix;}
    CreatedFormSides           : Word;                             // sides of a created form    {nsids;}
    TearTailLength             : Single;                           // length of the tear tail    {tearat;}
    TearTwistStep              : Single;                           // tear twist step    {twststp;}
    TearTwistRatio             : Single;                           // tear twist ratio    {twstrat;}
    WavePoints                 : Word;                             // wave points    {wavpnts;}
    WaveStarting               : Word;                             // wave starting point    {wavstrt;}
    WaveEnding                 : Word;                             // wave ending point    {wavend;}
    WaveLobes                  : Word;                             // wave lobes    {wavs;}
    FeatherFillType            : Byte;                             // feather fill type    {fthtyp;}
    FeatherUpCount             : Byte;                             // feather up count    {fthup;}
    FeatherDownCount           : Byte;                             // feather down count    {fthdwn;}
    FeatherBits                : Byte;                             // feather bits    {fthbits;}
    FeatherRatio               : Single;                           // feather ratio    {fthrat;}
    FeatherFloor               : Single;                           // feather floor    {fthflr;}
    FeatherNum                 : Word;                             // feather fill psg granularity    {fthnum;}
    p2cnam                     : array [0..Max_Path - 1] of Char;  // pes2card file    {p2cnam[MAX_PATH];}
    WalkIndent                 : Single;                           // edge walk/underlay indent    {wind;}
    UnderlayAngle              : Single;                           // underlay angle    {uang;}
    UnderlaySpacing            : Single;                           // underlay spacing    {uspac;}
    UnderlayStitchLength       : Single;                           // underlay stitch length    {ulen;}
    DaisyLength                : Single;                           // daisy diameter    {dazlen;}
    DaisyPetalLength           : Single;                           // daisy petal length    {dazplen;}
    DaisyHoleLength            : Single;                           // daisy hole diameter    {dazhlen;}
    DaisyPetals                : Cardinal;                         // daisy petals    {dazpet;}
    DaisyCount                 : Cardinal;                         // daisy petals count    {dazcnt;}
    DaisyInnerCount            : Cardinal;                         // daisy inner count    {dazicnt;}
    DaisyBorderType            : Byte;                             // daisy border type    {daztyp;}
    DataCheck                  : Byte;                             // data check    {dchk;}
    TextureFillHeight          : Single;                           // textured fill height    {txthi;}
    TextureFillWidth           : Single;                           // textured fill width    {txtwid;}
    TextureFillSpacing         : Single;                           // textured fill spacing    {txtspac;}
    FormBoxPixels              : Word;                             // form box pixels    {frmbpix;}
    DaisyHeatCount             : Word;                             // daisy heart count    {dazpcnt;}
    TextureEditorPixels        : Word;                             // texture editor pixels    {//texture editor pixels}
    ClipboardFillSpacing       : Single;                           // clipboard fill spacing    {clpspc;}
    DesignerName               : array [0..49] of Char;            // designer name    {desnam[50];}
  end;


TFTHED =packed record
	fthtyp,	//feather fill type
	fthup,	//feather up count
	fthdwn,	//feather down count
	fthcol: Byte;	//feather blend col
	fthrat,	//feather ratio
	fthflr: single;	//feather floor
	fthnum: Word; //feather fill psg granularity
end; //FTHED;

TTXHED = packed record
	lins: SmallInt ;
	ind,
	cnt: word;
	hi : Single;
end; //TXHED;

TTFHED = packed record
	fth : TFTHED;
	txt : TTXHED;
end;//TFHED;

TSATCON = packed record
	strt,
	fin : Word; //finish
end; //SATCON;

TFANGCLP = packed record
	fang : Single;
	clp : TFLPNT;
	sat : TSATCON;
end; //FANGCLP;

TFLENCNT = packed record
	flen : Single;
	nclp : Cardinal;
end; //FLENCNT;

TSACANG = packed record
	sac : TSATCON;
	ang : Single; //anle
end; //SACANG;

{
	fill	elen	espac	esiz	nclp	picspac		crnrsiz		brdend

	EGLIN	elen
	EGBLD	elen
	EGCLP							nclp
	EGSAT	elen	espac	esiz									at
	EGAP	elen	espac	esiz									at
	EGPRP	elen	espac	esiz									at
	EGHOL	elen	espac	esiz						nclp,res
	EGPIC	elen			esiz	nclp	espac		res		
}

 TFRMHED = packed record
    at : Byte;		//attribute
    sids : Word;	//number of sides
    typ : Byte;	//type
    fcol : byte;	//fill color
    bcol : Byte;	//border color
    nclp : Word;	//number of border clipboard entries
    flt : TFloatPoint ;	//points
    sacang : TSACANG;	//satin guidlines or angle clipboard fill angle
    clp : TFloatPoint;	//border clipboard data
    stpt : Word;	//number of satin guidlines
    wpar : Word;	//word parameter
    rct : TFloatRect;	//rectangle
    ftyp : Byte;	//fill type
    etyp : Byte;	//edge type
    fspac : Single;	//fill spacing
    flencnt : TFLENCNT ;//fill stitch length or clpboard count
    angclp : TFANGCLP;	//fill angle or clpboard data pointer
    esiz,	//border size
    espac,	//edge spacing
    elen : TFloat;	//edge stitch length
    res : word;	//pico length

    xat: Cardinal;	//attribute extension
    fmax,	//maximum fill stitch length
    fmin,	//minimum fill stitch length
    emax,	//maximum border stitch length
    emin: Single;	//minimum border stitch length
    dhx : TTFHED;	//feather/texture info
    strt,	//fill strt point
    endp : Word;	//fill end point {end}
    uspac,//underlay spacing
    ulen,	//underlay stitch length
    uang,	//underlay stitch angle
    wind,	//underlay/edge walk indent
    txof : Single;	//gradient end density
    ucol,	//underlay color
    cres : Byte	//reserved
  end; //FRMHED;

  TFRMHEDO = packed record // #995
    at : Byte;		//attribute
    sids : Word;	//number of sides
    typ : Byte;	//type
    fcol : byte;	//fill color
    bcol : Byte;	//border color
    nclp : Word;	//number of border clipboard entries
    flt : TFloatPoint ;	//points
    sacang : TSACANG;	//satin guidlines or angle clipboard fill angle
    clp : TFloatPoint;	//border clipboard data
    stpt : Word;	//number of satin guidlines
    wpar : Word;	//word parameter
    rct : TFloatRect;	//rectangle
    ftyp : Byte;	//fill type
    etyp : Byte;	//edge type
    fspac : Single;	//fill spacing
    flencnt : TFLENCNT ;//fill stitch length or clpboard count
    angclp : TFANGCLP;	//fill angle or clpboard data pointer
    esiz,	//border size
    espac,	//edge spacing
    elen : TFloat;	//edge stitch length
    res : word;	//pico length
  end;//FRMHEDO;

implementation

end.
