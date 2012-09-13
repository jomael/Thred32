unit umMain;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, //XPMan,
  GR32_Image,
  gmGridBased_ListView,  gmSwatch_ListView, gmGridBased_List, gmSwatch_List,
  Thred_Types, Thred_Constants, Thred_Defaults, AppEvnts;

type
  TMainForm = class(TForm)
    StatusBar: TStatusBar;
    ToolBar2: TToolBar;
    btnOpenStitch: TToolButton;
    btnFileSave1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    btnFileNew1: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    swlDefault: TgmSwatchList;
    swlCustom: TgmSwatchList;
    pmForm: TPopupMenu;
    Line1: TMenuItem;
    Freehand1: TMenuItem;
    RegularPolygon1: TMenuItem;
    swaDefault: TgmSwatchListView;
    swa2: TgmSwatchListView;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FParamsLoaded : boolean;
    FIni : TThredIniFile;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses umChild, umDM, about,

  gmSwatch_rwTHR, gmSwatch_rwACO, gmSwatch_rwSWA,
  Stitch_FileDlg;



procedure TMainForm.FormCreate(Sender: TObject);
var i : integer;
begin
  self.Menu := dm.mm1;
  self.WindowMenu := dm.Window1;
  //redini;
  {Fini.StitchColors :=  defUseCol;
  custCol := defCustCol;
  bakCust := defBakCust;
  bakBit  := defBakBit;}
  //FStitchs.Colors := ini.StitchColors;
  //SetLength(Lcolors,16);
   for i := 0 to 15 do
    begin
      swlDefault.Add;
      swlDefault[i].Color := defCol[i];// defUseCol[i];

      swlCustom.Add;
      swlCustom[i].Color := defUseCol[i];

    end;
  //FStitchs.Colors := LColors;// ini.StitchColors;
    swa2.Changed;
    swaDefault.Changed;
    

end;

procedure TMainForm.FormActivate(Sender: TObject);
var i : integer;
begin
  if not FParamsLoaded then
  begin
    FParamsLoaded := true;
    if paramcount > 0 then
      for i := 1 to Paramcount do
        CreateMDIChild(paramstr(i));

  end;
end;

end.
