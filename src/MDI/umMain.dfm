object MainForm: TMainForm
  Left = 355
  Top = 164
  Width = 524
  Height = 530
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
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 512
    Height = 30
    BorderWidth = 1
    Color = clBtnFace
    DisabledImages = DM.il3
    Flat = True
    Images = DM.il1
    Indent = 5
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Wrapable = False
    object btnFileNew1: TToolButton
      Left = 5
      Top = 0
      Action = DM.actFileNew1
    end
    object btnOpenStitch: TToolButton
      Left = 28
      Top = 0
      Action = DM.actOpenStitch
    end
    object btnFileSave1: TToolButton
      Left = 51
      Top = 0
      Action = DM.actFileSave1
    end
    object ToolButton3: TToolButton
      Left = 74
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object ToolButton4: TToolButton
      Left = 82
      Top = 0
      Action = DM.EditCut1
    end
    object ToolButton5: TToolButton
      Left = 105
      Top = 0
      Action = DM.EditCopy1
    end
    object ToolButton6: TToolButton
      Left = 128
      Top = 0
      Action = DM.EditPaste1
    end
    object ToolButton7: TToolButton
      Left = 151
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object ToolButton8: TToolButton
      Left = 159
      Top = 0
      Action = DM.WindowCascade1
    end
    object ToolButton10: TToolButton
      Left = 182
      Top = 0
      Action = DM.WindowTileHorizontal1
    end
    object ToolButton11: TToolButton
      Left = 205
      Top = 0
      Action = DM.WindowTileVertical1
    end
  end
  object pnlStatusBar: TPanel
    Left = 0
    Top = 471
    Width = 512
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object pnlHint: TPanel
      Left = 0
      Top = 0
      Width = 319
      Height = 25
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 10
      Caption = 'pnlHint'
      TabOrder = 0
    end
    object pnlZoom: TPanel
      Left = 319
      Top = 0
      Width = 193
      Height = 25
      Align = alRight
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 10
      Caption = '100%'
      TabOrder = 1
      object gau1: TGaugeBar
        Left = 50
        Top = 5
        Width = 100
        Height = 16
        Backgnd = bgPattern
        ShowArrows = False
        ShowHandleGrip = True
        Style = rbsMac
        Position = 0
      end
    end
  end
  object pnlSidebar: TPanel
    Left = 0
    Top = 54
    Width = 64
    Height = 417
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    object pnlTools: TPanel
      Left = 0
      Top = 0
      Width = 64
      Height = 169
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 10
      TabOrder = 0
      object btnSizeWrapper: TSpeedButton
        Left = 4
        Top = 16
        Width = 57
        Height = 22
        GroupIndex = 1
        Caption = 'SizeWrapper'
      end
      object btnHand: TSpeedButton
        Left = 4
        Top = 48
        Width = 57
        Height = 22
        GroupIndex = 1
        Caption = 'Hand'
        OnClick = btnHandClick
      end
      object btnCurve: TSpeedButton
        Left = 4
        Top = 80
        Width = 57
        Height = 22
        GroupIndex = 1
        Caption = 'Curve'
      end
      object btnZoom: TSpeedButton
        Left = 4
        Top = 120
        Width = 57
        Height = 22
        GroupIndex = 1
        Caption = 'Zoom'
        OnClick = btnZoomClick
      end
    end
    object pgscrlr1: TPageScroller
      Left = 0
      Top = 169
      Width = 64
      Height = 248
      Align = alClient
      Control = pnl2
      Orientation = soVertical
      TabOrder = 1
      object pnl2: TPanel
        Left = 0
        Top = 0
        Width = 64
        Height = 248
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'pnlHint'
        TabOrder = 0
        object swaCustom: TgmSwatchListView
          Left = 32
          Top = 0
          Width = 32
          Height = 248
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
          TabOrder = 0
          CellBorderStyle = borContrasGrid
          FrameColor = clSilver
        end
        object swaDefault: TgmSwatchListView
          Left = 0
          Top = 0
          Width = 32
          Height = 248
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
          TabOrder = 1
          CellBorderStyle = borContrasGrid
          FrameColor = clSilver
        end
      end
    end
  end
  object rullerH: TgmRuller
    Left = 0
    Top = 30
    Width = 512
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    Align = alTop
    Color = clBtnFace
    ParentColor = False
    UOM = uMm
    ZeroPixel = 0
    DPI = 96.000000000000000000
    TickNumber = 100
    TickDecimalPoint = 0
    TickMiddle = True
    TickDiv = 10
    Kind = sbHorizontal
  end
  object rullerV: TgmRuller
    Left = 64
    Top = 54
    Width = 24
    Height = 417
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    Align = alLeft
    Color = clBtnFace
    ParentColor = False
    UOM = uPixel
    ZeroPixel = 0
    DPI = 96.000000000000000000
    TickNumber = 100
    TickDecimalPoint = 0
    TickMiddle = True
    TickDiv = 10
    Kind = sbVertical
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
    Left = 120
    Top = 152
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
  object appevents1: TApplicationEvents
    OnHint = appevents1Hint
    Left = 264
    Top = 112
  end
end
