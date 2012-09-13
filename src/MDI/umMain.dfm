object MainForm: TMainForm
  Left = 300
  Top = 292
  Width = 485
  Height = 338
  Caption = 'MDI Application'
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poDefault
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 285
    Width = 473
    Height = 19
    AutoHint = True
    Panels = <>
    SimplePanel = True
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 473
    Height = 30
    BorderWidth = 1
    Color = clBtnFace
    Images = DM.il1
    Indent = 5
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Wrapable = False
    object btnFileNew1: TToolButton
      Left = 5
      Top = 2
      Action = DM.actFileNew1
    end
    object btnOpenStitch: TToolButton
      Left = 28
      Top = 2
      Action = DM.actOpenStitch
    end
    object btnFileSave1: TToolButton
      Left = 51
      Top = 2
      Action = DM.actFileSave1
    end
    object ToolButton3: TToolButton
      Left = 74
      Top = 2
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButton4: TToolButton
      Left = 82
      Top = 2
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      Caption = 'Cu&t'
      ImageIndex = 0
    end
    object ToolButton5: TToolButton
      Left = 105
      Top = 2
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      Caption = '&Copy'
      ImageIndex = 1
    end
    object ToolButton6: TToolButton
      Left = 128
      Top = 2
      Hint = 'Paste|Inserts Clipboard contents'
      Caption = '&Paste'
      ImageIndex = 2
    end
    object ToolButton7: TToolButton
      Left = 151
      Top = 2
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object ToolButton8: TToolButton
      Left = 159
      Top = 2
      Action = DM.WindowCascade1
    end
    object ToolButton10: TToolButton
      Left = 182
      Top = 2
      Action = DM.WindowTileHorizontal1
    end
    object ToolButton11: TToolButton
      Left = 205
      Top = 2
      Action = DM.WindowTileVertical1
    end
  end
  object swaDefault: TgmSwatchListView
    Left = 0
    Top = 30
    Width = 30
    Height = 255
    Align = alLeft
    Color = clBtnFace
    ParentColor = False
    SwatchList = swlDefault
    ThumbWidth = 30
    ThumbHeight = 20
    ParentShowHint = False
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    ShowHint = True
    TabOrder = 2
    CellBorderStyle = borContrasGrid
    FrameColor = clSilver
  end
  object swa2: TgmSwatchListView
    Left = 30
    Top = 30
    Width = 33
    Height = 255
    Align = alLeft
    Color = clBtnFace
    ParentColor = False
    SwatchList = swlCustom
    ThumbWidth = 30
    ThumbHeight = 20
    ParentShowHint = False
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    ShowHint = True
    TabOrder = 3
    CellBorderStyle = borContrasGrid
    FrameColor = clSilver
  end
  object swlDefault: TgmSwatchList
    Left = 80
    Top = 104
  end
  object swlCustom: TgmSwatchList
    Left = 80
    Top = 56
  end
  object pmForm: TPopupMenu
    Left = 176
    Top = 200
    object Line1: TMenuItem
      Caption = 'Lin&e'
      ShortCut = 76
    end
    object Freehand1: TMenuItem
      Caption = '&Freehand'
    end
    object RegularPolygon1: TMenuItem
      Caption = '&Regular Polygon'
      ShortCut = 82
    end
  end
end
