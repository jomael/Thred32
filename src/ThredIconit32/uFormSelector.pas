unit uFormSelector;

{

Delphi Form Activator with Visual Thumbnail Preview

http://delphi.about.com/od/formsdialogs/a/form_activator.htm

Here's an idea for your (next) Delphi killer application: 
provide a user with a visual way to navigate and select any 
already open (MDI child) form by displaying a thumbnail 
form image in a scrollable list. 


Example:

uses FormSelectorForm....

TFormSelectorForm.Execute(MDI_Parent_Form_name);


}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, jpeg;

type
  TFormSelectorForm = class(TForm)
    thumbScroller: TScrollBox;
    pnlBottom: TPanel;
    btnCancel: TBitBtn;
    selectorShape: TShape;
    shapeTimer: TTimer;
    lblHelp: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure shapeTimerTimer(Sender: TObject);
  private
    fMDIContainer: TForm;
    procedure MouseEnter(Sender : TObject);
    procedure MouseLeave(Sender : TObject);
    procedure ImageClick(Sender : TObject);
    procedure SetMDIContainer(const Value: TForm);
  private
    procedure GetMDIChildImages;
    function CreateTImage(const form : TForm) : TImage;
    procedure MakeThumbnail(const bitmap : TBitmap; const maxWidth, maxHeight : integer);
  public
    property MDIContainer : TForm read fMDIContainer write SetMDIContainer;
  public
    class function Execute(const mdiForm : TForm) : TModalResult;
  end;

implementation
{$R *.dfm}


function TFormSelectorForm.CreateTImage(const form: TForm): TImage;
begin
  Result := TImage.Create(thumbScroller);
  with Result do
  begin
    Tag := form.Handle;  //used to activate upon "click"
    Parent := thumbScroller;

    Cursor := crHandPoint;
    {Margins.Left := 8;
    Margins.Right := 8;
    Margins.Top := 8;
    Margins.Bottom := 8;
    AlignWithMargins := true;}
    Width := 4 * thumbScroller.Height div 3;
    Align := alLeft;

    Stretch := true;
    Proportional := true;
    Center := true;

    OnClick := ImageClick;
    ///OnMouseEnter := MouseEnter;
    ///OnMouseLeave := MouseLeave;

    ShowHint := true;
    Hint := Format('Click to activate "%s"', [form.Caption]);
  end;
end;

class function TFormSelectorForm.Execute(const mdiForm: TForm) : TModalResult;
begin
  with self.Create(nil) do
  try
    MDIContainer := mdiForm;
    GetMDIChildImages;
    Result := ShowModal;
  finally
    Free;
  end;
end;

procedure TFormSelectorForm.FormCreate(Sender: TObject);
begin
  thumbScroller.DoubleBuffered := true;
  selectorShape.Visible := false;
  shapeTimer.Enabled := false;

  self.Width := 3 * (Screen.Width div 4);
  self.Height := 2 * (Screen.Width div 5);
end;

procedure TFormSelectorForm.GetMDIChildImages;
var
  idx : integer;
  form : TForm;
  formImage : TBitmap;
begin
  for idx := 0 to -1 + MDIContainer.MDIChildCount do
  begin
    form := MDIContainer.MDIChildren[idx];

    //skip the active MDI child (as it is currently "active")
    if form = MDIContainer.ActiveMDIChild  then Continue;

    ShowWindow(form.Handle, SW_MAXIMIZE);

    //get form image and place it on the scroll bar
    formImage := form.GetFormImage;


    //MakeThumbnail(formImage, 200, 150);

    try
      CreateTImage(form).Picture.Assign(formImage);
    finally
      formImage.Free;
    end;
  end;
end;

procedure TFormSelectorForm.ImageClick(Sender: TObject);
var
  theImage : TImage;
  mdiChildHandle : THandle;
  mdiChild : TForm;
begin
  theImage := TImage(Sender);

  mdiChildHandle := theImage.Tag;

  mdiChild := FindControl(mdiChildHandle) as TForm;

  if (mdiChild <> nil) then
  begin
    if IsIconic(mdiChildHandle) then
      // mdiChild.WindowState := wsNormal OR wsMaximized ??
      ShowWindow(mdiChildHandle, SW_RESTORE)
    else
      mdiChild.Show;

    //self.Close;
    ModalResult := mrOk;
  end;
end;

procedure TFormSelectorForm.MakeThumbnail(const bitmap: TBitmap; const maxWidth,  maxHeight: integer);
var
  thumbRect : TRect;
begin
  thumbRect.Left := 0;
  thumbRect.Top := 0;

  //proportional resize
  if bitmap.Width > bitmap.Height then
  begin
    thumbRect.Right := maxWidth;
    thumbRect.Bottom := (maxWidth * bitmap.Height) div bitmap.Width;
  end
  else
  begin
    thumbRect.Bottom := maxHeight;
    thumbRect.Right := (maxHeight * bitmap.Width) div bitmap.Height;
  end;

  bitmap.Canvas.StretchDraw(thumbRect, bitmap) ;


  bitmap.Width := thumbRect.Right;
  bitmap.Height := thumbRect.Bottom;
end;

procedure TFormSelectorForm.MouseEnter(Sender: TObject);
var
  theImage : TImage;
begin
  theImage := TImage(Sender);

  selectorShape.Left := theImage.Left - 4;
  selectorShape.Top := theImage.Top - 4;
  selectorShape.Width := theImage.Width + 8;
  selectorShape.Height := theImage.Height + 8;

  selectorShape.Visible := true;
  shapeTimer.Enabled := true;
end;

procedure TFormSelectorForm.MouseLeave(Sender: TObject);
begin
  selectorShape.Visible := false;
  shapeTimer.Enabled := false;
end;


procedure TFormSelectorForm.SetMDIContainer(const Value: TForm);
begin
  if value.FormStyle <> fsMDIForm then raise Exception.Create('"MDI Container" not a MDI Form!');

  fMDIContainer := Value;
end;

procedure TFormSelectorForm.shapeTimerTimer(Sender: TObject);
begin
  if selectorShape.Pen.Color = clRed then
    selectorShape.Pen.Color := clWhite
  else
    selectorShape.Pen.Color := clRed;
end;

end.
