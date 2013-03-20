inherited MainForm1: TMainForm1
  Left = 141
  Top = 151
  Width = 1076
  Height = 561
  Caption = 'MainForm1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited spl1: TSplitter
    Top = 417
    Width = 1068
  end
  inherited pnlStatusBar: TPanel
    Top = 509
    Width = 1068
    inherited pnlHint: TPanel
      Width = 927
    end
    inherited pnlZoom: TPanel
      Left = 927
    end
  end
  inherited pnlSidebar: TPanel
    Top = 153
    Height = 255
  end
  inherited rullerH: TgmRuller
    Top = 129
    Width = 1068
  end
  object tbxdock1: TTBXDock [4]
    Left = 0
    Top = 52
    Width = 1068
    Height = 77
    object tbMenuBar: TTBXToolbar
      Left = 0
      Top = 0
      CloseButton = False
      DockMode = dmCannotFloatOrChangeDocks
      DockPos = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      FullSize = True
      MenuBar = True
      ParentFont = False
      ProcessShortCuts = True
      ShrinkMode = tbsmWrap
      TabOrder = 0
      Caption = 'Menu Bar'
    end
    object tb5: TTBXToolbar
      Left = 0
      Top = 52
      AutoResize = False
      CloseButtonWhenDocked = True
      DockPos = -4
      DockRow = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnMouseDown = tb5MouseDown
      Caption = 'Formatting'
      ChevronHint = 'More Buttons '#937'|'
      object tog1: TTBXVisibilityToggleItem
        ImageIndex = 56
        Caption = 'Formatting'
        Hint = ''
      end
      object lb1: TTBXLabelItem
        Caption = ' Formatting:'
        Hint = ''
      end
      object cmbFonts: TTBXComboBoxItem
        AlignRight = True
        EditWidth = 128
        ImageIndex = 4
        EditorFontSettings.Bold = tsTrue
        MaxListWidth = 256
        MaxVisibleItems = 14
        MinListWidth = 128
        Caption = 'Fonts'
        Hint = ''
        Text = 'Times New Roman'
      end
      object sep6: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object cmbTBXComboList1: TTBXComboBoxItem
        AlignRight = True
        EditWidth = 40
        Enabled = False
        MaxListWidth = 64
        MaxVisibleItems = 10
        MinListWidth = 38
        Lines.Strings = (
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '14'
          '16'
          '18'
          '20'
          '22'
          '24'
          '26'
          '28'
          '36'
          '72')
        Caption = 'Sizes'
        Hint = ''
        Text = '12'
      end
      object btn18: TTBXItem
        AlignRight = False
        DisplayMode = nbdmImageAndText
        ImageIndex = 4
        Caption = 'Bold'
        Hint = ''
      end
      object btn19: TTBXItem
        AlignRight = False
        ImageIndex = 26
        Caption = 'Italic'
        Hint = ''
      end
      object sep7: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object btn20: TTBXItem
        AlignRight = False
        Checked = True
        DisplayMode = nbdmImageAndText
        GroupIndex = 1
        ImageIndex = 2
        Caption = #1057#1083#1077#1074#1072
        Hint = ''
      end
      object btn21: TTBXItem
        AlignRight = False
        GroupIndex = 1
        ImageIndex = 54
        Caption = ''
        Hint = ''
      end
      object btn22: TTBXItem
        AlignRight = False
        GroupIndex = 1
        ImageIndex = 3
        Caption = ''
        Hint = ''
      end
      object sep8: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object mnu3: TTBXSubmenuItem
        AlignRight = False
        AlwaysSelectFirst = True
        DisplayMode = nbdmImageAndText
        ImageIndex = 36
        Options = [tboDropdownArrow]
        SubMenuImages = DM.il1
        ToolBoxPopup = True
        Caption = 'Tools'
        Hint = ''
        object ToolPalette: TTBXToolPalette
          ColCount = 6
          Options = [tboToolbarStyle]
          PaletteOptions = []
          RowCount = 6
          Caption = ''
          Hint = ''
        end
      end
      object mnuColorButton: TTBXSubmenuItem
        AlignRight = False
        DisplayMode = nbdmImageAndText
        ImageIndex = 57
        LinkSubitems = ColorCombo
        Options = [tboDropdownArrow]
        ToolBoxPopup = True
        Caption = 'Color Button'
        Hint = ''
      end
      object sep9: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object ColorCombo: TTBXDropDownItem
        AlignRight = True
        EditWidth = 96
        AlwaysSelectFirst = False
        DropDownList = True
        Caption = 'Colors'
        Hint = ''
        Text = 'Default Color'
        object TBXColorComb1: TTBXColorComb
          Color = clBlack
          Left = 40
          Top = 24
          Caption = ''
          Hint = ''
        end
        object sep10: TTBXSeparatorItem
          Blank = True
          Options = [tboShowHint]
          Caption = ''
          Hint = ''
        end
        object ColorPalette: TTBXColorPalette
          PaletteOptions = [tpoCustomImages]
          Caption = ''
          Hint = ''
        end
        object sep11: TTBXSeparatorItem
          Size = 8
          Options = [tboShowHint]
          Caption = ''
          Hint = ''
        end
        object ClrDefault: TTBXColorItem
          Color = clNone
          GroupIndex = 99
          Options = [tboShowHint]
          Caption = 'Default'
          Hint = 'Default Color'
        end
        object btnMoreColors: TTBXItem
          AlignRight = False
          Options = [tboShowHint]
          Caption = 'More Colors...'
          Hint = ''
        end
      end
      object tbcntrltm1: TTBControlItem
        Caption = ''
        Hint = ''
      end
    end
    object tb4: TTBXToolbar
      Left = 0
      Top = 26
      CloseButtonWhenDocked = True
      DockPos = -28
      DockRow = 1
      Images = DM.il1
      Options = [tboToolbarStyle]
      ParentShowHint = False
      ShowHint = True
      SnapDistance = 32
      TabOrder = 2
      Caption = 'Standard'
      object btn12: TTBXItem
        AlignRight = False
        Caption = ''
        Hint = ''
      end
      object sep1: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object btn13: TTBXItem
        AlignRight = False
        ImageIndex = 33
        Caption = 'Print'
        Hint = ''
      end
      object btn14: TTBXItem
        AlignRight = False
        ImageIndex = 34
        Caption = 'Print Preview'
        Hint = ''
      end
      object sep2: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object btn15: TTBXItem
        AlignRight = False
        ImageIndex = 10
        Caption = 'Cut'
        Hint = ''
      end
      object btn16: TTBXItem
        AlignRight = False
        ImageIndex = 9
        Caption = 'Copy'
        Hint = ''
      end
      object btn17: TTBXItem
        AlignRight = False
        ImageIndex = 32
        Layout = tbxlGlyphLeft
        Caption = 'Paste'
        Hint = ''
      end
      object sep3: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object mnuUndoItems: TTBXSubmenuItem
        AlignRight = False
        AlwaysSelectFirst = True
        DropdownCombo = True
        ImageIndex = 45
        ToolBoxPopup = True
        Caption = 'Undo'
        Hint = ''
        object UndoList: TTBXUndoList
          MinWidth = 120
          Lines.Strings = (
            'First Action'
            'Second Action'
            'Third Action'
            'Fourth Action'
            'Fith Action'
            'Sixth Action'
            'Seventh Action'
            'a'
            'b'
            'c')
          Caption = ''
          Hint = ''
        end
        object lbUndoLabel: TTBXLabelItem
          Margin = 4
          Caption = 'Undo 1 Action'
          Hint = ''
        end
      end
      object mnu1: TTBXSubmenuItem
        AlignRight = False
        DropdownCombo = True
        ImageIndex = 37
        InheritOptions = False
        Options = [tboDropdownArrow, tboToolbarStyle, tboToolbarSize]
        ToolBoxPopup = True
        OnClick = mnu1Click
        Caption = 'Redo'
        Hint = ''
        object tbxclrplt1: TTBXColorPalette
          PaletteOptions = [tpoCustomImages]
          Caption = ''
          Hint = ''
        end
      end
      object sep4: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object mnu2: TTBXSubmenuItem
        AlignRight = False
        ImageIndex = 12
        Options = [tboDropdownArrow]
        ToolBoxPopup = True
        Caption = 'Zoom'
        Hint = ''
        object TBXList1: TTBXStringList
          Lines.Strings = (
            '25%'
            '50%'
            '75%'
            '100%'
            '125%'
            '150%'
            '200%')
          Caption = ''
          Hint = ''
        end
      end
      object sep5: TTBXSeparatorItem
        Caption = ''
        Hint = ''
      end
      object mnu4: TTBXSubmenuItem
        AlignRight = False
        SubMenuImages = DM.il4
        Caption = ''
        Hint = ''
      end
    end
  end
  inherited ctrlbr1: TControlBar [5]
    Width = 1068
    TabOrder = 3
    Visible = False
    inherited tb1: TToolBar
      Images = DM.il4
    end
    inherited pnl1: TPanel
      Width = 28
    end
  end
  inherited mmo1: TMemo [6]
    Top = 420
    Width = 1068
    TabOrder = 4
  end
  object tbxdock3: TTBXDock [7]
    Left = 0
    Top = 408
    Width = 1068
    Height = 9
    Position = dpBottom
  end
  object tbxdockLeft: TTBXDock [8]
    Left = 99
    Top = 153
    Width = 27
    Height = 255
    Position = dpLeft
    object TBXToolbar1: TTBXToolbar
      Left = 0
      Top = 0
      TabOrder = 0
      Visible = False
      Caption = 'TBXToolbar1'
    end
  end
  inherited ctrlbr2: TControlBar [9]
    Top = 153
    Height = 255
    TabOrder = 5
  end
  inherited rullerV: TgmRuller [10]
    Left = 126
    Top = 153
    Height = 255
  end
  inherited pmForm: TPopupMenu
    Left = 160
    Top = 144
  end
  inherited pmDqPhoto: TPopupMenu
    Left = 432
  end
  object tbxmdhndlr1: TTBXMDIHandler
    Toolbar = tbMenuBar
    Left = 680
    Top = 248
  end
end
