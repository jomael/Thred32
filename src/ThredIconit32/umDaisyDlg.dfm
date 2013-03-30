object frmDaisyDlg: TfrmDaisyDlg
  Left = 403
  Top = 154
  BorderStyle = bsDialog
  Caption = 'Daisy Form Setup'
  ClientHeight = 401
  ClientWidth = 148
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 52
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = 'Petals'
  end
  object Label2: TLabel
    Left = 37
    Top = 84
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Petal Points'
  end
  object Label3: TLabel
    Left = 10
    Top = 148
    Width = 83
    Height = 13
    Alignment = taRightJustify
    Caption = 'Inner Petal Points'
  end
  object Label4: TLabel
    Left = 41
    Top = 180
    Width = 52
    Height = 13
    Alignment = taRightJustify
    Caption = 'Center size'
  end
  object Label5: TLabel
    Left = 46
    Top = 212
    Width = 47
    Height = 13
    Alignment = taRightJustify
    Caption = 'Petal Size'
  end
  object Label6: TLabel
    Left = 52
    Top = 268
    Width = 45
    Height = 13
    Alignment = taRightJustify
    Caption = 'Hole Size'
  end
  object Label7: TLabel
    Left = 48
    Top = 296
    Width = 51
    Height = 13
    Caption = 'Petal Type'
  end
  object Label8: TLabel
    Left = 35
    Top = 116
    Width = 58
    Height = 13
    Alignment = taRightJustify
    Caption = 'Mirror Points'
  end
  object btnCancel: TButton
    Left = 8
    Top = 8
    Width = 129
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object edPetals: TEdit
    Left = 104
    Top = 48
    Width = 40
    Height = 21
    TabOrder = 1
    Text = 'edPetals'
  end
  object edPetalPoints: TEdit
    Left = 104
    Top = 80
    Width = 40
    Height = 21
    TabOrder = 2
    Text = 'edPetals'
  end
  object edMirrorPoints: TEdit
    Left = 104
    Top = 112
    Width = 40
    Height = 21
    TabOrder = 3
    Text = 'edPetals'
  end
  object edInnerPetalPoints: TEdit
    Left = 104
    Top = 144
    Width = 40
    Height = 21
    TabOrder = 4
    Text = 'edPetals'
  end
  object edCenterSize: TEdit
    Left = 104
    Top = 176
    Width = 40
    Height = 21
    TabOrder = 5
    Text = 'edPetals'
  end
  object chkHole: TCheckBox
    Left = 24
    Top = 248
    Width = 49
    Height = 17
    Caption = 'Hole'
    TabOrder = 6
  end
  object chkDline: TCheckBox
    Left = 80
    Top = 248
    Width = 65
    Height = 17
    Caption = 'D-line'
    TabOrder = 7
  end
  object edHoleSize: TEdit
    Left = 104
    Top = 264
    Width = 40
    Height = 21
    TabOrder = 8
    Text = 'edPetals'
  end
  object cbbPetalType: TComboBox
    Left = 12
    Top = 308
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 9
    Text = 'Curve'
    Items.Strings = (
      'Curve'
      'Side Point'
      'Center Point'
      'Ragged'
      'Cog'
      'Mirror')
  end
  object btnReset: TButton
    Left = 8
    Top = 336
    Width = 129
    Height = 25
    Caption = '&Reset'
    TabOrder = 10
    OnClick = btnResetClick
  end
  object btnOK: TButton
    Left = 8
    Top = 368
    Width = 129
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 11
  end
  object edPetalSize: TEdit
    Left = 104
    Top = 208
    Width = 40
    Height = 21
    TabOrder = 12
    Text = 'edPetals'
  end
end
