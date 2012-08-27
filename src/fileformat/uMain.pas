unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan,
  Stitch_items;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    dlgOpen1: TOpenDialog;
    btn3: TButton;
    xpmnfst1: TXPManifest;
    btn4: TButton;
    lst1: TListBox;
    lst2: TListBox;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lst1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lst2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    FStitchs : TStitchCollection;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Stitch_FileDlg, Stitch_rwTHR,
  AllWindowsDialog;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  with TOpenStitchsDialog.Create(Self) do
  begin
    if Execute then
    FStitchs.LoadFromFile(FileName);
    Caption := IntToStr(FStitchs.Count);
//    FStitchs.Header.
  //  Caption := Caption +
    self.Color := FStitchs.BgColor;

    lst2.Invalidate;
    lst1.Invalidate;

    Free;
  end;  
end;

procedure TForm1.btn2Click(Sender: TObject);
var s : string;
begin
   s := 'aaa.txt';
  if OpenSaveFileDialog(Application.Handle, 'txt', 'Text Files|*.txt', '', 'Select text file', s, True) then
    ShowMessage(s + ' file was selected for open')
end;

procedure TForm1.btn3Click(Sender: TObject);
var s : string;
begin
s := 'data.dbf';
  if OpenSaveFileDialog(Application.Handle, 'dbf', 'dBase tables|*.dbf|All files|*.*', 'c:\', 'Select table', s, False) then
    ShowMessage(s + ' table was selected for save')
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  dlgOpen1.Execute;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FStitchs := TStitchCollection.Create(self);
end;

procedure TForm1.lst1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  if lst1.Items[Index] <> ColorToString(FStitchs.Colors[Index]) then
  lst1.Items[Index] := ColorToString(FStitchs.Colors[Index]);
  lst1.Canvas.Brush.Color :=  self.FStitchs.Colors[Index];
  lst1.Canvas.FillRect(Rect);
  lst1.Canvas.TextOut(Rect.Left, Rect.Top, lst1.Items[index]);
end;

procedure TForm1.lst2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  if lst2.Items[Index] <> ColorToString(FStitchs.CustomColors[Index]) then
  lst2.Items[Index] := ColorToString(FStitchs.CustomColors[Index]);
  lst2.Canvas.Brush.Color :=  FStitchs.CustomColors[Index];
  lst2.Canvas.FillRect(Rect);
  lst2.Canvas.TextOut(Rect.Left, Rect.Top,  lst2.Items[index]);
end;

end.
