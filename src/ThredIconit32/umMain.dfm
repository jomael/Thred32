object MainForm: TMainForm
  Left = 356
  Top = 372
  Width = 860
  Height = 530
  Caption = 'Thred-32'
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  ShowHint = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 0
    Top = 386
    Width = 852
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object pnlStatusBar: TPanel
    Left = 0
    Top = 478
    Width = 852
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object pnlHint: TPanel
      Left = 0
      Top = 0
      Width = 711
      Height = 25
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 10
      Caption = 'pnlHint'
      TabOrder = 0
    end
    object pnlZoom: TPanel
      Left = 711
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
    Left = 36
    Top = 76
    Width = 64
    Height = 310
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object pnlTools: TPanel
      Left = 0
      Top = 0
      Width = 64
      Height = 169
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 5
      TabOrder = 0
    end
  end
  object rullerH: TgmRuller
    Left = 0
    Top = 52
    Width = 852
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
    Left = 100
    Top = 76
    Width = 24
    Height = 310
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
    Width = 852
    Height = 52
    Align = alTop
    AutoSize = True
    BevelEdges = []
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    object tb1: TToolBar
      Left = 11
      Top = 2
      Width = 326
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
        Hint = 'Save|Save current file'
        Caption = '&Save'
        ImageIndex = 8
      end
      object btn1: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object btnEditDelete: TToolButton
        Left = 77
        Top = 0
        Action = DM.actEditDelete
      end
      object btn2: TToolButton
        Left = 100
        Top = 0
        Action = DM.EditCut1
      end
      object btn3: TToolButton
        Left = 123
        Top = 0
        Action = DM.EditCopy1
      end
      object btn4: TToolButton
        Left = 146
        Top = 0
        Action = DM.EditPaste1
      end
      object btn5: TToolButton
        Left = 169
        Top = 0
        Width = 8
        Caption = 'ToolButton7'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object btn6: TToolButton
        Left = 177
        Top = 0
        Action = DM.WindowCascade1
      end
      object btn7: TToolButton
        Left = 200
        Top = 0
        Action = DM.WindowTileHorizontal1
      end
      object btn8: TToolButton
        Left = 223
        Top = 0
        Action = DM.WindowTileVertical1
      end
      object btn11: TToolButton
        Left = 246
        Top = 0
        Caption = 'btn11'
        ImageIndex = 12
      end
      object ToolButton1: TToolButton
        Left = 269
        Top = 0
        Caption = 'ToolButton1'
        ImageIndex = 13
      end
    end
    object tbChildren: TToolBar
      Left = 350
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
      object btnDqLineGroupDetect: TToolButton
        Left = 151
        Top = 0
        Action = DM.actDqDebug_Toggle
        DropdownMenu = pmDqDebug
        Style = tbsDropDown
      end
      object btn9: TToolButton
        Left = 187
        Top = 0
        Width = 8
        Caption = 'btn9'
        ImageIndex = 7
        Style = tbsSeparator
      end
      object btnUseOrdinalColor: TToolButton
        Left = 195
        Top = 0
        Action = DM.actUseOrdinalColor
      end
    end
    object pnl1: TPanel
      Left = 598
      Top = 2
      Width = 185
      Height = 22
      Align = alRight
      BevelOuter = bvNone
      Caption = 'pnl1'
      TabOrder = 2
    end
    object tb3: TToolBar
      Left = 171
      Top = 28
      Width = 358
      Height = 22
      Caption = 'tb3'
      DisabledImages = dmTool.il3
      EdgeBorders = []
      Flat = True
      Images = dmTool.il1
      TabOrder = 3
      object btnToolLineNew: TToolButton
        Left = 0
        Top = 0
        Action = dmTool.actToolLineNew
      end
      object btnToolLineInsert: TToolButton
        Left = 23
        Top = 0
        Action = dmTool.actToolLineInsert
      end
      object btnDqOutdoorPhoto: TToolButton
        Left = 46
        Top = 0
        Action = dmTool.actToolLineEdit
      end
      object btn10: TToolButton
        Left = 69
        Top = 0
        Width = 8
        Caption = 'btn10'
        ImageIndex = 7
        Style = tbsSeparator
      end
      object btnShapeRegular: TToolButton
        Left = 77
        Top = 0
        Action = dmTool.actShapeRegular
      end
      object btnShapeStar: TToolButton
        Left = 100
        Top = 0
        Action = dmTool.actShapeStar
      end
      object btnShapeEllipse: TToolButton
        Left = 123
        Top = 0
        Action = dmTool.actShapeEllipse
      end
      object btnGroupCombine: TToolButton
        Left = 146
        Top = 0
        Action = dmTool.actGroupCombine
      end
      object btnGroupExtract: TToolButton
        Left = 169
        Top = 0
        Action = dmTool.actGroupExtract
      end
      object ToolButton2: TToolButton
        Left = 192
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 12
        Style = tbsSeparator
      end
      object btnGroupIntersect: TToolButton
        Left = 200
        Top = 0
        Action = dmTool.actGroupIntersect
      end
      object btnGroupUnion: TToolButton
        Left = 223
        Top = 0
        Action = dmTool.actGroupUnion
      end
      object btnGroupTrim: TToolButton
        Left = 246
        Top = 0
        Action = dmTool.actGroupTrim
      end
      object ToolButton3: TToolButton
        Left = 269
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 15
        Style = tbsSeparator
      end
      object btnGroupXOR: TToolButton
        Left = 277
        Top = 0
        Action = dmTool.actGroupXOR
      end
      object ToolButton4: TToolButton
        Left = 300
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 13
        Style = tbsSeparator
      end
      object spinVertex: TSpinEdit
        Left = 308
        Top = 0
        Width = 44
        Height = 22
        Ctl3D = False
        MaxValue = 0
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 0
        Value = 5
      end
    end
    object tb2: TToolBar
      Left = 11
      Top = 28
      Width = 147
      Height = 22
      Caption = 'tb2'
      Color = clBtnFace
      EdgeBorders = []
      Flat = True
      Images = dmTool.il1
      ParentColor = False
      TabOrder = 4
      Visible = False
      object btnToolSelect: TToolButton
        Left = 0
        Top = 0
        Action = dmTool.actToolSelect
      end
      object btnToolHand: TToolButton
        Left = 23
        Top = 0
        Action = dmTool.actToolShape
      end
      object btnToolStitch: TToolButton
        Left = 46
        Top = 0
        Action = dmTool.actToolStitch
      end
      object btnToolZoom: TToolButton
        Left = 69
        Top = 0
        Action = dmTool.actToolHand
      end
      object btnToolZoom1: TToolButton
        Left = 92
        Top = 0
        Action = dmTool.actToolZoom
      end
    end
  end
  object mmo1: TMemo
    Left = 0
    Top = 389
    Width = 852
    Height = 89
    Align = alBottom
    BevelOuter = bvNone
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Debug Log:')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object ctrlbr2: TControlBar
    Left = 0
    Top = 76
    Width = 36
    Height = 310
    Align = alLeft
    AutoSize = True
    BevelEdges = []
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    object tb7: TToolBar
      Left = 11
      Top = 2
      Width = 23
      Height = 152
      Align = alLeft
      AutoSize = True
      Caption = 'tb2'
      Color = clBtnFace
      EdgeBorders = []
      Flat = True
      Images = dmTool.il1
      ParentColor = False
      TabOrder = 0
      object btnToolSelect1: TToolButton
        Left = 0
        Top = 0
        Action = dmTool.actToolSelect
        Wrap = True
      end
      object btnToolShape: TToolButton
        Left = 0
        Top = 22
        Action = dmTool.actToolShape
        Wrap = True
      end
      object btnToolStitch1: TToolButton
        Left = 0
        Top = 44
        Action = dmTool.actToolStitch
        Wrap = True
      end
      object btnToolHand1: TToolButton
        Left = 0
        Top = 66
        Action = dmTool.actToolHand
        Wrap = True
      end
      object btnToolZoom2: TToolButton
        Left = 0
        Top = 88
        Action = dmTool.actToolZoom
      end
    end
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
    OnActionUpdate = appevents1ActionUpdate
    OnException = appevents1Exception
    OnHint = appevents1Hint
    Left = 264
    Top = 112
  end
  object pmDqPhoto: TPopupMenu
    Images = DM.ilQuality
    Left = 328
    Top = 112
    object Photo1: TMenuItem
      Action = DM.actDqPhoto
    end
    object OutdoorPhoto1: TMenuItem
      Action = DM.actDqOutdoorPhoto
    end
  end
  object pmDqDebug: TPopupMenu
    Images = DM.ilQuality
    Left = 472
    Top = 120
    object actDqDebuglin1: TMenuItem
      Action = DM.actDqDebug_lin
    end
    object actDqDebuggrp1: TMenuItem
      Action = DM.actDqDebug_grp
    end
    object actDqDebugregion1: TMenuItem
      Action = DM.actDqDebug_region
    end
    object DebugJump1: TMenuItem
      Action = DM.actDqDebug_Jump
    end
    object actDqDebugWestern1: TMenuItem
      Action = DM.actDqDebug_Western
    end
  end
end
