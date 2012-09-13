object MDIChild: TMDIChild
  Left = 190
  Top = 335
  Width = 594
  Height = 377
  Caption = 'MDI Child'
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  Menu = mm1
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pb: TPaintBox32
    Left = 248
    Top = 160
    Width = 206
    Height = 125
    TabOrder = 0
    OnPaintBuffer = pbPaintBuffer
  end
  object mm1: TMainMenu
    AutoMerge = True
    Left = 56
    Top = 96
    object View1: TMenuItem
      Caption = '&View'
      GroupIndex = 10
      object yuiop1: TMenuItem
        Caption = 'yuiop'
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 109
      end
      object Quality1: TMenuItem
        Action = actWireframe
        AutoCheck = True
        GroupIndex = 109
        RadioItem = True
      end
      object Solid1: TMenuItem
        Action = actSolid
        AutoCheck = True
        GroupIndex = 109
        RadioItem = True
      end
      object Photo1: TMenuItem
        Action = actPhoto
        AutoCheck = True
        GroupIndex = 109
        RadioItem = True
      end
      object OutdoorPhoto1: TMenuItem
        Action = actOutdoorPhoto
        AutoCheck = True
        GroupIndex = 109
        RadioItem = True
      end
      object Mountain1: TMenuItem
        Action = actMountain
        AutoCheck = True
        GroupIndex = 109
        RadioItem = True
      end
      object XRay1: TMenuItem
        Action = actXRay
        AutoCheck = True
        GroupIndex = 109
        RadioItem = True
      end
    end
  end
  object actlst1: TActionList
    Left = 136
    Top = 104
    object actWireframe: TAction
      Tag = 1
      Category = 'View'
      AutoCheck = True
      Caption = 'Wireframe'
      GroupIndex = 12
      OnExecute = QualityChanged
    end
    object actSolid: TAction
      Tag = 2
      Category = 'View'
      AutoCheck = True
      Caption = 'Solid'
      GroupIndex = 12
      OnExecute = QualityChanged
    end
    object actPhoto: TAction
      Tag = 3
      Category = 'View'
      AutoCheck = True
      Caption = 'Photo'
      Checked = True
      GroupIndex = 12
      OnExecute = QualityChanged
    end
    object actOutdoorPhoto: TAction
      Tag = 4
      Category = 'View'
      AutoCheck = True
      Caption = 'Outdoor Photo'
      GroupIndex = 12
      OnExecute = QualityChanged
    end
    object actMountain: TAction
      Tag = 5
      Category = 'View'
      AutoCheck = True
      Caption = 'Mountain'
      GroupIndex = 12
      OnExecute = QualityChanged
    end
    object actXRay: TAction
      Tag = 6
      Category = 'View'
      AutoCheck = True
      Caption = 'X-Ray'
      GroupIndex = 12
      OnExecute = QualityChanged
    end
  end
end
