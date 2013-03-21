object fcDesign: TfcDesign
  Left = 391
  Top = 349
  Width = 594
  Height = 377
  Caption = 'MDI Child'
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
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
  object imgStitchs: TImgView32
    Left = 120
    Top = 96
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
    Left = 401
    Top = 0
    Width = 185
    Height = 350
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object pbPreview: TPaintBox32
      Left = 0
      Top = 161
      Width = 185
      Height = 189
      Align = alClient
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 161
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object swlCustom: TgmSwatchList
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
