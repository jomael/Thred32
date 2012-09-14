unit gmColorDlg;

interface

uses
{ Standard }
  Messages, Windows, SysUtils, Classes, Controls, Forms,StdCtrls, Graphics,
  ExtCtrls, Buttons, CommDlg, Dlgs, ExtDlgs, Dialogs;

type

{ TOpenGridBasedDialog }

  TgmColorDialog = class(TColorDialog)
  private
    FGridPanel     : TPanel;

  protected
    procedure DoShow; override;

  public
    constructor Create(AOwner: TComponent); override;
  
  published

  end;


implementation

{ TgmColorDialog }

constructor TgmColorDialog.Create(AOwner: TComponent);
begin
  inherited;
  FGridPanel := TPanel.Create(Self);
  with FGridPanel do
  begin
    Name        := 'GridPanel';
    Caption     := '';
    BevelOuter  := bvNone;
    BorderWidth := 6;
    TabOrder    := 1;
    SetBounds(204, 5, 169, 200);

    

  end;
end;

procedure TgmColorDialog.DoShow;
var
  LPreviewRect, LStaticRect : TRect;
begin
  // Set preview area to entire dialog 
  GetClientRect(Handle, LPreviewRect);
  LStaticRect := GetStaticRect;
  
  // Move preview area to right of static area 
  LPreviewRect.Left := LStaticRect.Left + (LStaticRect.Right - LStaticRect.Left);
  Inc(LPreviewRect.Top, 4);

  FGridPanel.BoundsRect := LPreviewRect;
  FGridPanel.Anchors    := [akLeft, akTop, akRight, akBottom];

  
  FGridPanel.ParentWindow := Handle;
  inherited;

end;

end.
 