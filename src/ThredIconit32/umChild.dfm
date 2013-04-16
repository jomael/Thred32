object fcDesign: TfcDesign
  Left = 303
  Top = 123
  Width = 808
  Height = 536
  Caption = 'MDI Child'
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = imgStitchsScroll
  PixelsPerInch = 96
  TextHeight = 13
  object lblLoading: TLabel
    Left = 256
    Top = 160
    Width = 57
    Height = 13
    Align = alCustom
    Caption = 'LOADING...'
  end
  object Splitter1: TSplitter
    Left = 384
    Top = 29
    Height = 480
    Align = alRight
  end
  object imgStitchs: TImgView32
    Left = 40
    Top = 112
    Width = 209
    Height = 193
    Bitmap.ResamplerClassName = 'TKernelResampler'
    Bitmap.Resampler.KernelClassName = 'TBoxKernel'
    Bitmap.Resampler.KernelMode = kmTableLinear
    Bitmap.Resampler.TableSize = 32
    BitmapAlign = baCustom
    Scale = 1.000000000000000000
    ScaleMode = smScale
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 16
    ScrollBars.Visibility = svAuto
    OverSize = 0
    TabOrder = 0
    TabStop = True
    Visible = False
    OnMouseDown = imgStitchsMouseDown
    OnScroll = imgStitchsScroll
  end
  object pnl1: TPanel
    Left = 387
    Top = 29
    Width = 185
    Height = 480
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object pbPreview: TPaintBox32
      Left = 0
      Top = 457
      Width = 185
      Height = 23
      Align = alClient
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 457
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 572
    Top = 29
    Width = 228
    Height = 480
    Align = alRight
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 2
    object Panel3: TPanel
      Left = 10
      Top = 10
      Width = 208
      Height = 303
      Align = alTop
      BevelOuter = bvNone
      Color = clSilver
      TabOrder = 0
      object Button1: TButton
        Left = 48
        Top = 72
        Width = 75
        Height = 25
        Caption = 'fnvrt()'
        TabOrder = 0
      end
      object Button2: TButton
        Left = 48
        Top = 104
        Width = 75
        Height = 25
        Caption = 'lcon()'
        TabOrder = 1
      end
      object chkDrawgrid: TCheckBox
        Left = 24
        Top = 8
        Width = 97
        Height = 17
        Caption = 'Drawgrid'
        TabOrder = 2
      end
      object chkVideo: TCheckBox
        Left = 104
        Top = 8
        Width = 57
        Height = 17
        Caption = 'Video'
        TabOrder = 3
      end
      object gbrSpace1: TGaugeBar
        Left = 24
        Top = 40
        Width = 121
        Height = 16
        Backgnd = bgPattern
        Max = 300
        Min = 1
        ShowHandleGrip = True
        Position = 100
      end
      object btnNewStar: TButton
        Left = 40
        Top = 168
        Width = 113
        Height = 25
        Caption = 'Auto New Star'
        TabOrder = 5
        OnClick = btnNewStarClick
      end
      object rg1: TRadioGroup
        Left = 8
        Top = 238
        Width = 193
        Height = 51
        Caption = 'Fill colors of: '
        Columns = 2
        ItemIndex = 2
        Items.Strings = (
          'Lin'
          'Grp'
          'trgns')
        TabOrder = 6
      end
      object btnDump: TButton
        Left = 160
        Top = 264
        Width = 41
        Height = 25
        Caption = 'dump'
        TabOrder = 7
        OnClick = btnDumpClick
      end
    end
    object Memo1: TMemo
      Left = 10
      Top = 313
      Width = 208
      Height = 157
      Align = alClient
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 800
    Height = 29
    Caption = 'ToolBar1'
    TabOrder = 3
  end
  object swlCustom: TgmSwatchList
    Collection = <>
    Left = 56
    Top = 48
  end
  object timerLazyLoad: TTimer
    Interval = 100
    OnTimer = timerLazyLoadTimer
    Left = 280
    Top = 40
  end
end
