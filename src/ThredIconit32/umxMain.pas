unit umxMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, umMain, AppEvnts, Menus, gmCore_Items, gmGridBased, gmSwatch,
  ExtCtrls, gmRuller, GR32_Image, gmCore_Viewer, gmGridBased_ListView,
  gmSwatch_ListView, ComCtrls, ToolWin, GR32_RangeBars, TBXMDI,
  TB2Item, TBXExtItems, TBXToolPals, TTBXColorCombs,
  TBX, TB2ExtItems, TBXLists, TB2Dock, TB2Toolbar, StdCtrls, Spin;

type
  TMainForm1 = class(TMainForm)
    tbxdock1: TTBXDock;
    tbMenuBar: TTBXToolbar;
    tb4: TTBXToolbar;
    btn12: TTBXItem;
    sep1: TTBXSeparatorItem;
    btn13: TTBXItem;
    btn14: TTBXItem;
    sep2: TTBXSeparatorItem;
    btn15: TTBXItem;
    btn16: TTBXItem;
    btn17: TTBXItem;
    sep3: TTBXSeparatorItem;
    mnuUndoItems: TTBXSubmenuItem;
    UndoList: TTBXUndoList;
    lbUndoLabel: TTBXLabelItem;
    mnu1: TTBXSubmenuItem;
    sep4: TTBXSeparatorItem;
    mnu2: TTBXSubmenuItem;
    TBXList1: TTBXStringList;
    sep5: TTBXSeparatorItem;
    tb5: TTBXToolbar;
    tog1: TTBXVisibilityToggleItem;
    lb1: TTBXLabelItem;
    cmbFonts: TTBXComboBoxItem;
    sep6: TTBXSeparatorItem;
    cmbTBXComboList1: TTBXComboBoxItem;
    btn18: TTBXItem;
    btn19: TTBXItem;
    sep7: TTBXSeparatorItem;
    btn20: TTBXItem;
    btn21: TTBXItem;
    btn22: TTBXItem;
    sep8: TTBXSeparatorItem;
    mnu3: TTBXSubmenuItem;
    ToolPalette: TTBXToolPalette;
    mnuColorButton: TTBXSubmenuItem;
    sep9: TTBXSeparatorItem;
    ColorCombo: TTBXDropDownItem;
    TBXColorComb1: TTBXColorComb;
    sep10: TTBXSeparatorItem;
    ColorPalette: TTBXColorPalette;
    sep11: TTBXSeparatorItem;
    ClrDefault: TTBXColorItem;
    btnMoreColors: TTBXItem;
    tbcntrltm1: TTBControlItem;
    tbxmdhndlr1: TTBXMDIHandler;
    mnu4: TTBXSubmenuItem;
    tbxdock3: TTBXDock;
    tbxdockLeft: TTBXDock;
    tbxclrplt1: TTBXColorPalette;
    TBXToolbar1: TTBXToolbar;
    procedure FormCreate(Sender: TObject);
    procedure mnu1Click(Sender: TObject);
    procedure tb5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm1: TMainForm1;

implementation

uses
  umDm, umDmTool,
  TBX_converters, TBXThemes,   TBXStripesTheme,
  TBXOfficeXPTheme,
  TBXAluminumTheme;

{$R *.dfm}

procedure TMainForm1.FormCreate(Sender: TObject);

function WinPosCompare(Win1, Win2: TControl): Integer;
begin
  if Win2.Top < Win1.Top then
  begin
    Result := 1;
    Exit;
  end;

  if Win2.Top > Win1.Top then
  begin
    Result := -1;
    Exit;
  end;

  if Win2.Left < Win1.Left then
  begin
    Result := 1;
    Exit;
  end;

  if Win2.Left > Win1.Left then
  begin
    Result := -1;
    Exit;
  end;

  Result := 0;
end;

procedure QuickSort(var Wins: array of TControl; L, R: Integer);
var
  I, J : Integer;
  P, T : TControl;
begin
  repeat
    I := L;
    J := R;
    P := Wins[(L + R) shr 1];
    repeat
      while WinPosCompare(Wins[I], P) < 0 do
        Inc(I);

      while WinPosCompare(Wins[J], P) > 0 do
        Dec(J);

      if I <= J then
      begin
        if I <> J then
        begin
          T          := Wins[I];
          Wins[I] := Wins[J];
          Wins[J] := T;
        end;
  
        Inc(I);
        Dec(J);
      end;

    until I > J;

    if L < J then
      QuickSort(Wins, L, J);

    L := I;
    
  until I >= R;
end;

  procedure IntegrateWindowsMenu;
  var WindowsMenu : TTBXSubmenuItem;
    Dst: TTBCustomItem;
  begin
    WindowsMenu := tbMenuBar.FindComponent('mnhdWindow') as TTBXSubmenuItem;
    //separator
    Dst := TTBXSeparatorItem.Create(self);
    Dst.Visible := True;
    WindowsMenu.Add(Dst);

    Dst := TTBXMDIWindowItem.Create(self);
    Dst.Visible := True;
    WindowsMenu.Add(Dst);
  end;

  procedure ConvertToolBars(ParentSrc: TWinControl; ParentDest: TWinControl);
  var i,j,z : integer;
    t : TTBXToolbar;
    Wins : array of TControl;
  begin
    SetLength(Wins, ParentSrc.ControlCount);

    z := -1;
    for i := 0 to ParentSrc.ControlCount -1 do
    begin
      if ParentSrc.Controls[i] is TToolBar then
      begin
        Inc(z);
        Wins[z] := ParentSrc.Controls[i];
      end;
    end;
    //z := High(Wins);
    SetLength(Wins, z+1);

    QuickSort(Wins, 0, z);

    for i := 0 to z do
    begin
      if not (Wins[i] is TToolBar) then
        Continue;

      t := TTBXToolbar.Create(Self);
      t.DockPos := wins[i].Left;
      t.Parent := ParentDest;
      
      CopyConvertToolbarTBX(t, Wins[i] as TToolBar);
      t.Visible := True;

    end;


  end;

  
begin
  inherited;
  TBXSetTheme('Aluminum');
  //Load Main Menu
  self.Menu := nil;
  TBX_converters.CopyConvertMenuTBX(tbMenuBar.Items,dm.mm1.Items);
  tbMenuBar.Images := DM.il4; //put back to 24bit color.
  IntegrateWindowsMenu;
  ConvertToolBars(ctrlbr1, tbxdock1);
  ConvertToolBars(ctrlbr2, tbxdockLeft);

end;

procedure TMainForm1.mnu1Click(Sender: TObject);
begin
  Caption := FormatDateTime('ss.zzz',now);

end;

procedure TMainForm1.tb5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Caption := FormatDateTime('ss.zzz',now);
end;

end.
