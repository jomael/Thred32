unit Thred_Types;

interface

uses
{ Standard }
  Windows, Graphics,
{ Thred32 }
  Thred_Constants;

type
  TOldNameCharArray = array [0..OLD_NUM - 1, 0..MAX_PATH - 1] of Char;
  T16Colors = array [0..15] of TColor;

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

implementation

end.
