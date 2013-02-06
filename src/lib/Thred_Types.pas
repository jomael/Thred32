unit Thred_Types;

interface

uses
{ Standard }
  Classes, Windows, Graphics,
  GR32,
{ Thred32 }
  Thred_Constants;

type
  TOldNameCharArray = array [0..OLDNUM - 1, 0..MAX_PATH - 1] of Char;
  TArrayOfTColor = array of TColor;
  PArrayOfCardinal = ^TArrayOfCardinal;
  TArrayOfCardinal = array of Cardinal;
  T16Colors = array [0..15] of TColor;
  T16Byte   = array [0..15] of Byte;

  TDoublePoint = record
    x, y : Double;
  end;

  TSMALPNTL = record //smallpoint Line
    lin,	//lin and grp must remain in this order for sort to work
    grp : word;
    x, y : TFloat;
  end;//SMALPNTL;

  TArrayOfTSMALPNTL = array of TSMALPNTL;

  PDUBPNTL = ^TDUBPNTL;
  TDUBPNTL = record
    x, y : Double;
    lin : word;
  end;//DUBPNTL;

  //PArrayOfTDUBPNTL = ^TArrayOfDUBPNTL;
  TArrayOfTDUBPNTL = array of TDUBPNTL;
  TArrayOfPDUBPNTL = array of PDUBPNTL;




  TFLPNT = type TFloatPoint;
  TFLRCT = type TFloatRect;
  
  TBSEQPNT = packed record
    x,
    y : Single;
    attr: Byte;
  end;//BSEQPNT;



  TSHRTPNT = packed  record //thred stitch structure
    x, y : Single;
    at: Cardinal; //attribute
  end;

  TArrayOfTSHRTPNT = array of TSHRTPNT;


  TTXPNT = packed record		//textured fill point
    y : Single;
    lin : SmallInt;
  end; //TXPNT;

  TPCSTCH = packed record
    fx : byte;
    x : smallint;
    nx : byte;
    fy : byte;
    y : smallint;
    ny : byte;
    typ : byte;
  end;//PCSTCH;

  TCOLCHNG = record
    stind,	//stich index
    colind : word;	//color index
  end;//COLCHNG;


  PSTRHED = ^TSTRHED; 
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

  //thred v1.0 file header extension
  PSTREX = ^TSTREX;
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
  THED = packed record  //thred.h #681
    ledIn,
    hup : Byte;
    fColCnt : Word;
    fCols : T16Colors;
    stchs : Word;
  end; //HED;

  //pes
  TPESLED = packed record
      ver : array[0..7] of Char;
      pec : Cardinal;
    end;//PESLED;

  //pes ver 1
  TPESHED = packed record
    //led : array[0..7] of Char;  //#PES0001, #PES0001
    led : array[0..5] of Char;
    ledVer : array[0..1] of Char;
    off : array[0..2] of Byte;  //PEC offset [3byte]
    m1 : array[0..12] of Byte;
    ce : array[0..5] of Char;
    m2 : array[0..46] of Byte;
    xsiz,
    ysiz : Word;
    m3 : array[0..15] of Byte;
    cs : array[0..5] of Char;
    m4 : array[0..2] of Byte;
    scol : Byte;
    m5 : array[0..2] of Byte;
  end; //PESHED;

  TPESTCH = record
    x, y : Word;
  end;//PESTCH;

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
	  cnt: Word;
	  hi : Single;
  end; //TXHED;

  TTFHED = packed record   //union
    case Integer of
      0 : (fth : TFTHED);
	    1 : (txt : TTXHED);
  end;//TFHED;

  PSATCON = ^TSATCON;
  TSATCON = record
	  strt,
	  fin : Word; //finish
  end; //SATCON;

  PArrayOfTSATCON = ^TArrayOfTSATCON;
  TArrayOfTSATCON = array of TSATCON;


  //PFANGCLP = ^TFANGCLP;
  TFANGCLP = packed record
    case Integer of
      0 :	(fang : Single);
	    //1 : (clp : TArrayOfFloatPoint);
      1 : (clp : PArrayOfFloatPoint);// PFloatPoint;);
	    2 : (sat : TSATCON);
  end; //FANGCLP;

  //PFLENCNT = ^TFLENCNT;
  TFLENCNT = packed record
    case Boolean of
      True  : (flen : Single);
	    False : (nclp : Cardinal);
  end; //FLENCNT;

  //PSACANG = ^TSACANG;
  TSACANG = packed record
    case boolean of
	    False : (sac : PArrayOfTSATCON);//PSATCON);
	    True  : (ang : Single); //anle
  end; //SACANG;

  TArrayOfTSACANG = array of TSACANG;

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

  PFRMHED = ^TFRMHED;
  TFRMHED = packed record
    at : Byte;		//attribute
    sids : Word;	//number of sides
    typ : Byte;	//type
    fcol : byte;	//fill color
    bcol : Byte;	//border color
    nclp : Word;	//number of border clipboard entries
    flt : TArrayOfFloatPoint ;	//points*
    sacang : TSACANG;	//satin guidlines or angle clipboard fill angle
    clp : TArrayOfFloatPoint;	//border clipboard data*
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

  TArrayOfTFRMHED = array of TFRMHED; //used by stitchList
  TArrayOfPFRMHED = array of PFRMHED; //used for multi-select drag

  {TFRMHEDList = class(TList)
  private
    function GetItems(Index: Integer): TFRMHED;
    procedure SetItems(Index: Integer; const Value: TFRMHED);
  protected
    //function GetItems(Index: Integer): TClass;
    //procedure SetItems(Index: Integer; AClass: TClass);
  public
    function Add(AFRM: TFRMHED): Integer;
    //function Extract(Item: TClass): TClass;
    //function Remove(AClass: TClass): Integer;
    //function IndexOf(AClass: TClass): Integer;
    //function First: TClass;
    //function Last: TClass;
    //function Find(AClassName: string): TClass;
    //procedure GetClassNames(Strings: TStrings);
    //procedure Insert(Index: Integer; AClass: TClass);
    property Items[Index: Integer]: TFRMHED read GetItems write SetItems; default;
  end;}


  TRNGC = packed record  // thred.h #786
    strt : Cardinal;
    cnt  : Cardinal;
	  fin  : Cardinal;
	  frm  : Cardinal;
  end; //RNGC;

  // it identifys Double rect
  TDUBRCT = packed record  // thred.h #907
    top    : Double;
    left   : Double;
	  right  : Double;
	  bottom : Double;
  end; //DUBRCT;

  TFRMHEDO = packed record // #995
    at : Byte;		//attribute
    sids : Word;	//number of sides
    typ : Byte;	//type
    fcol : byte;	//fill color
    bcol : Byte;	//border color
    nclp : Word;	//number of border clipboard entries
    flt : TArrayOfFloatPoint ;	//points*
    sacang : TSACANG;	//satin guidlines or angle clipboard fill angle
    clp : TArrayOfFloatPoint;	//border clipboard data*
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

  PFRMHED_STREAM = ^TFRMHED_STREAM;
  TFRMHED_STREAM = packed record
    at : Byte;		//attribute
    sids : Word;	//number of sides
    typ : Byte;	//type
    fcol : byte;	//fill color
    bcol : Byte;	//border color
    nclp : Word;	//number of border clipboard entries
    flt : Cardinal ;	//points*
    sacang : Cardinal;	//satin guidlines or angle clipboard fill angle
    clp : Cardinal;	//border clipboard data*
    stpt : Word;	//number of satin guidlines
    wpar : Word;	//word parameter
    rct : TFloatRect;	//rectangle
    ftyp : Byte;	//fill type
    etyp : Byte;	//edge type
    fspac : Single;	//fill spacing
    flencnt : Cardinal ;//fill stitch length or clpboard count
    angclp : Cardinal;	//fill angle or clpboard data pointer
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

  TFSTRTS = packed record  // thred.h #1782
    apl    : Cardinal;
	  fil    : Cardinal;
	  fth    : Cardinal;
	  brd    : Cardinal;
	  apcol  : Cardinal;
	  fcol   : Cardinal;
	  fthcol : Cardinal;
	  ecol   : Cardinal;
  end; //FSTRTS;

  TINSREC = packed record  // thred.h #1822
    cod : Cardinal;
	  col : Cardinal;
	  ind : Cardinal;
	  seq : Cardinal;
  end; //INSREC;

  TRNGCNT = packed record  // thred.h #1884
    lin : Integer;
	  cnt : Integer;
  end; //RNGCNT;


  TRGN = record//region for sequencing vertical fills
    strt,		//start line of region
    fin, //end;		//end line of region
    brk,
    cntbrk : Cardinal;
  end;  //RGN;


  TRCON = record		//pmap: path map for sequencing
    vrt,
    con,
    grpn : Word;
  end;//RCON;
  TArrayOfTRCON = array of TRCON;

  TArrayOfTRGN = array of TRGN;

  TRGSEQ = packed record		//tmpath: temporary path connections
    pcon : cardinal;		//pointer to pmap entry
    cnt : integer;
    skp : byte;		//path not found
  end; //RGSEQ;

  TFSEQ = packed record		//mpath: path of sequenced regions
    vrt,
    grpn : Word;
    skp : Byte;	//path not found
  end; //FSEQ;

implementation

end.
