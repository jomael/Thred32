object Form1: TForm1
  Left = 213
  Top = 170
  Width = 928
  Height = 480
  Caption = 'Form1'
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
  object btn1: TButton
    Left = 48
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Open Stitch'
    TabOrder = 0
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 96
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 1
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 96
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = btn3Click
  end
  object btn4: TButton
    Left = 232
    Top = 288
    Width = 75
    Height = 25
    Caption = 'btn4'
    TabOrder = 3
    OnClick = btn4Click
  end
  object lst1: TListBox
    Left = 16
    Top = 16
    Width = 105
    Height = 209
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 4
    OnDrawItem = lst1DrawItem
  end
  object lst2: TListBox
    Left = 144
    Top = 16
    Width = 105
    Height = 209
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 5
    OnDrawItem = lst2DrawItem
  end
  object dlgOpen1: TOpenDialog
    Left = 584
    Top = 112
  end
  object xpmnfst1: TXPManifest
    Left = 688
    Top = 32
  end
end
