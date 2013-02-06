object fcDesign: TfcDesign
  Left = 695
  Top = 217
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
    Left = 368
    Top = 56
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
    OverSize = 0
    TabOrder = 0
    TabStop = True
    Visible = False
    OnMouseDown = imgStitchsMouseDown
    OnScroll = imgStitchsScroll
  end
  object swlCustom: TgmSwatchList
    Left = 56
    Top = 48
  end
  object timerLazyLoad: TTimer
    Interval = 100
    OnTimer = timerLazyLoadTimer
    Left = 384
    Top = 48
  end
end
