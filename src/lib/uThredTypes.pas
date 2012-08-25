unit uThredTypes;

interface

uses
{ Standard }
  Windows, Graphics,
{ Thred32 }
  uThredConstants;

type
  TOldNameCharArray = array [0..OLD_NUM - 1, 0..MAX_PATH - 1] of Char;

  // ini file structure (INIFIL in thred.h, #691)
  TThredIniFile = record
    DefaultDir                 : array [0..179] of Char;           // default directory
    StitchColors               : array [0..15] of TColor;          // colors
    PrefStitchColors           : array [0..15] of TColor;          // stitch preference colors
    BackColors                 : array [0..15] of TColor;          // background preference colors
    StitchBackColor            : TColor;                           // background color
    BitmapColor                : TColor;                           // bitmap color
    MinSize                    : Double;                           // minimum stitch length
    ShowPoints                 : Double;                           // show stitch points
    ThreadSize30               : Double;                           // millimeter size of 30 weight thread
    ThreadSize40               : Double;                           // millimeter size of 40 weight thread
    ThreadSize60               : Double;                           // millimeter size of 60 weight thread
    UserSize                   : Double;                           // user stitch length
    MaxSize                    : Double;                           // maximum stitch length
    SmallSize                  : Double;                           // small stitch size
    StitchBoxLevel             : Double;                           // show stitch box level
    StitchSpacing              : Double;                           // stitch spacing between lines of stitches
    FillAngle                  : Double;                           // fill angle
    umap                       : Cardinal;                         // bitmap {TODO: don't know which name is proper yet}
    BorderWidth                : Double;                           // border width
    AppliqueColor              : Cardinal;                         // applique color
    OldNames                   : TOldNameCharArray;                // last file names
    SnapLength                 : Double;                           // snap together length
    StarRatio                  : Double;                           // star ratio
    SprialWrap                 : Double;                           // sprial wrap
    BitmapBackColors           : array [0..15] of TColor;          // bitmap background color preferences
    ButtonholeFillCornerLength : Double;                           // buttonhole fill corner length
    PicotSpace                 : Single;                           // space between border picots
    HoopType                   : Byte;                             // hoop type
    MachineFileType            : Byte;                             // machine file type
    HoopXSize                  : Single;                           // hoop x size
    HoopYSize                  : Single;                           // hoop y size
    RotationAngle              : Double;                           // rotation angle;
    GridSize                   : Single;                           // grid size;
    ClipboardOffset            : Single;                           // clipboard offset
    InitRect                   : TRect;                            // initial window coordinates
    GridColor                  : TColor;                           // grid color
    ClipboardFillPhase         : Cardinal;                         // clipboard fill phase
    CustomHoopWidth            : Single;                           // custom hoop width
    CustomHoopHeight           : Single;                           // custom hoop height
    trlen                      : Single;                           // lens points {TODO: don't know which name is proper yet}
    TraceRatio                 : Double;                           // trace ratio
    ChainSpace                 : Single;                           // chain space
    ChainRatio                 : Single;                           // chain ratio
    CursorNudgeStep            : Single;                           // cursor nudge step
    NudgePixels                : Word;                             // nudge pixels
    EggRatio                   : Single;                           // egg ratio
    StitchPointPixelSize       : Word;                             // size of stitch points in pixels
    FormPointPixelSize         : Word;                             // size of form points in pixels
    CreatedFormSides           : Word;                             // sides of a created form
    TearTailLength             : Single;                           // length of the tear tail
    TearTwistStep              : Single;                           // tear twist step
    TearTwistRatio             : Single;                           // tear twist ratio
    WavePoints                 : Word;                             // wave points
    WaveStarting               : Word;                             // wave starting point
    WaveEnding                 : Word;                             // wave ending point
    WaveLobes                  : Word;                             // wave lobes
    FeatherFillType            : Byte;                             // feather fill type
    FeatherUpCount             : Byte;                             // feather up count
    FeatherDownCount           : Byte;                             // feather down count
    FeatherBits                : Byte;                             // feather bits
    FeatherRatio               : Single;                           // feather ratio
    FeatherFloor               : Single;                           // feather floor
    FeatherNum                 : Word;                             // feather fill psg granularity
    p2cnam                     : array [0..Max_Path - 1] of Char;  // pes2card file
    WalkIndent                 : Single;                           // edge walk/underlay indent
    UnderlayAngle              : Single;                           // underlay angle
    UnderlaySpacing            : Single;                           // underlay spacing
    UnderlayStitchLength       : Single;                           // underlay stitch length
    DaisyLength                : Single;                           // daisy diameter
    DaisyPetalLength           : Single;                           // daisy petal length
    DaisyHoleLength            : Single;                           // daisy hole diameter
    DaisyPetals                : Cardinal;                         // daisy petals
    DaisyCount                 : Cardinal;                         // daisy petals count
    DaisyInnerCount            : Cardinal;                         // daisy inner count
    DaisyBorderType            : Byte;                             // daisy border type
    DataCheck                  : Byte;                             // data check
    TextureFillHeight          : Single;                           // textured fill height
    TextureFillWidth           : Single;                           // textured fill width
    TextureFillSpacing         : Single;                           // textured fill spacing
    FormBoxPixels              : Word;                             // form box pixels
    DaisyHeatCount             : Word;                             // daisy heart count
    TextureEditorPixels        : Word;                             // texture editor pixels
    ClipboardFillSpacing       : Single;                           // clipboard fill spacing
    DesignerName               : array [0..49] of Char;            // designer name
  end;

implementation

end.
