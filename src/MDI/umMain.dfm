object MainForm: TMainForm
  Left = 478
  Top = 164
  Width = 765
  Height = 530
  Caption = 'Thred32'
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlStatusBar: TPanel
    Left = 0
    Top = 478
    Width = 757
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pnlHint: TPanel
      Left = 0
      Top = 0
      Width = 616
      Height = 25
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 10
      Caption = 'pnlHint'
      TabOrder = 0
    end
    object pnlZoom: TPanel
      Left = 616
      Top = 0
      Width = 141
      Height = 25
      Cursor = crSizeNWSE
      Align = alRight
      Alignment = taRightJustify
      BevelOuter = bvNone
      BorderWidth = 10
      Caption = '100%'
      TabOrder = 1
      OnMouseDown = pnlZoomMouseDown
      object gau1: TGaugeBar
        Left = 2
        Top = 5
        Width = 100
        Height = 16
        Hint = 'Zoom'
        Backgnd = bgPattern
        Max = 5
        ShowArrows = False
        ShowHandleGrip = True
        Style = rbsMac
        Position = 2
        OnChange = gau1Change
      end
    end
  end
  object pnlSidebar: TPanel
    Left = 0
    Top = 50
    Width = 64
    Height = 428
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object pnlTools: TPanel
      Left = 0
      Top = 0
      Width = 64
      Height = 169
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
      object tb2: TToolBar
        Left = 5
        Top = 5
        Width = 54
        Height = 24
        AutoSize = True
        Caption = 'tb2'
        EdgeBorders = []
        Images = DM.il1
        TabOrder = 0
        object btnToolHand: TToolButton
          Left = 0
          Top = 2
          Action = DM.actToolHand
        end
        object btnToolZoom: TToolButton
          Left = 23
          Top = 2
          Action = DM.actToolZoom
        end
      end
    end
    object pgscrlr1: TPageScroller
      Left = 0
      Top = 169
      Width = 64
      Height = 259
      Align = alClient
      Control = pnl2
      Orientation = soVertical
      TabOrder = 1
      object pnl2: TPanel
        Left = 0
        Top = 0
        Width = 64
        Height = 259
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'pnlHint'
        TabOrder = 0
        object swaCustom: TgmSwatchListView
          Left = 30
          Top = 0
          Width = 32
          Height = 259
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
          Width = 30
          Height = 259
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
    Top = 26
    Width = 757
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Tahoma'
    Font.Style = []
    Align = alTop
    Color = clBtnFace
    ParentColor = False
    UOM = uPixel
    ZeroPixel = 64
    DPI = 96.000000000000000000
    TickNumber = 100
    TickDecimalPoint = 0
    TickMiddle = True
    TickDiv = 10
    Kind = sbHorizontal
  end
  object rullerV: TgmRuller
    Left = 64
    Top = 50
    Width = 24
    Height = 428
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
  object ctrlbr1: TControlBar
    Left = 0
    Top = 0
    Width = 757
    Height = 26
    Align = alTop
    AutoSize = True
    BevelEdges = []
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    object tb1: TToolBar
      Left = 11
      Top = 2
      Width = 230
      Height = 22
      AutoSize = True
      Color = clBtnFace
      DisabledImages = DM.il2
      EdgeBorders = []
      Flat = True
      Images = DM.il1
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Wrapable = False
      object btnFileNew2: TToolButton
        Left = 0
        Top = 0
        Action = DM.actFileNew1
      end
      object btnOpenStitch1: TToolButton
        Left = 23
        Top = 0
        Action = DM.actOpenStitch
      end
      object btnFileSave2: TToolButton
        Left = 46
        Top = 0
        Action = DM.actFileSave1
      end
      object btn1: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object btn2: TToolButton
        Left = 77
        Top = 0
        Action = DM.EditCut1
      end
      object btn3: TToolButton
        Left = 100
        Top = 0
        Action = DM.EditCopy1
      end
      object btn4: TToolButton
        Left = 123
        Top = 0
        Action = DM.EditPaste1
      end
      object btn5: TToolButton
        Left = 146
        Top = 0
        Width = 8
        Caption = 'ToolButton7'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object btn6: TToolButton
        Left = 154
        Top = 0
        Action = DM.WindowCascade1
      end
      object btn7: TToolButton
        Left = 177
        Top = 0
        Action = DM.WindowTileHorizontal1
      end
      object btn8: TToolButton
        Left = 200
        Top = 0
        Action = DM.WindowTileVertical1
      end
    end
    object tbChildren: TToolBar
      Left = 254
      Top = 2
      Width = 235
      Height = 22
      Caption = 'tbChildren'
      DragKind = dkDock
      EdgeBorders = []
      Flat = True
      Images = DM.ilQuality
      TabOrder = 1
      object btnSolid: TToolButton
        Left = 0
        Top = 0
        Action = DM.actDqSolid
      end
      object btnPhoto: TToolButton
        Left = 23
        Top = 0
        Action = DM.actDqTogglePhoto
        DropdownMenu = pmDqPhoto
        Style = tbsDropDown
      end
      object btnMountain: TToolButton
        Left = 59
        Top = 0
        Action = DM.actDqMountain
      end
      object btnHotPerforated: TToolButton
        Left = 82
        Top = 0
        Action = DM.actDqHotPerforated
      end
      object btnXRay: TToolButton
        Left = 105
        Top = 0
        Action = DM.actDqXRay
      end
      object btnWireframe: TToolButton
        Left = 128
        Top = 0
        Action = DM.actDqWireframe
      end
      object btn9: TToolButton
        Left = 151
        Top = 0
        Width = 8
        Caption = 'btn9'
        ImageIndex = 7
        Style = tbsSeparator
      end
      object btnUseOrdinalColor: TToolButton
        Left = 159
        Top = 0
        Action = DM.actUseOrdinalColor
      end
    end
    object pnl1: TPanel
      Left = 567
      Top = 2
      Width = 185
      Height = 22
      Align = alRight
      BevelOuter = bvNone
      Caption = 'pnl1'
      TabOrder = 2
    end
  end
  object swlDefault: TgmSwatchList
    Left = 80
    Top = 104
  end
  object swlCustom: TgmSwatchList
    Left = 200
    Top = 192
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
  object pmDqPhoto: TPopupMenu
    Images = DM.ilQuality
    Left = 328
    Top = 72
    object Photo1: TMenuItem
      Action = DM.actDqPhoto
    end
    object OutdoorPhoto1: TMenuItem
      Action = DM.actDqOutdoorPhoto
    end
  end
end
