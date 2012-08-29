object Form1: TForm1
  Left = 185
  Top = 172
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
  object grd1: TStringGrid
    Left = 16
    Top = 16
    Width = 273
    Height = 353
    ColCount = 2
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    TabOrder = 0
  end
  object btn1: TButton
    Left = 320
    Top = 176
    Width = 75
    Height = 25
    Caption = 'btn1'
    TabOrder = 1
    OnClick = btn1Click
  end
  object grd2: TStringGrid
    Left = 416
    Top = 16
    Width = 273
    Height = 353
    ColCount = 2
    FixedCols = 0
    RowCount = 10
    FixedRows = 0
    TabOrder = 2
  end
end
