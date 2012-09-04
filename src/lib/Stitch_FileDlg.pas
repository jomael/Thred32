unit Stitch_FileDlg;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/LGPL 2.1/GPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Gradient Editor.
 *
 * The Initial Developer of the Original Code are
 *
 * x2nie - Fathony Luthfillah  <x2nie@yahoo.com>
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 * ***** END LICENSE BLOCK ***** *)

interface

uses
{ Standard }
  Messages, Windows, SysUtils, Classes, Controls, Forms,StdCtrls, Graphics,
  ExtCtrls, Buttons, CommDlg, Dlgs, ExtDlgs, Dialogs,
{ GraphicsMagic }
  //gmGridBased, gmGridBased_List, gmGridBased_ListView
  Stitch_items
  ;

type

{ TOpenStitchsDialog }

  TOpenStitchsDialog = class(TOpenDialog)
  private
    //FGridPanel     : TPanel;
    //FGridLabel     : TLabel;
    FSavedFilename : string;

    //procedure SetStitchsCollection(const AValue: TStitchsCollection);

    //function GetStitchsCollection: TStitchsCollection;
    function IsFilterStored: Boolean;
  protected
    //FScrollBox         : TScrollbox;
    FStitchsList     : TStitchCollection;
    //FStitchsListView : TStitchsListView;

    // polymorphism
    //function GetStitchsListClass: TStitchsListClass; virtual; abstract;
    //function GetStitchsListViewClass: TStitchsListViewClass; virtual; abstract;
    //function GetGridLabelCaption: string; virtual;
    function IsSaveDialog: Boolean; virtual;
    function GetFilter: string;

    procedure DoClose; override;
//    procedure DoSelectionChange; override;
    procedure DoShow; override;

    //property StitchsListView : TStitchsListView read FStitchsListView;
    //property GridLabel         : TLabel               read FGridLabel;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;

    //property StitchsCollection : TStitchsCollection read GetStitchsCollection write SetStitchsCollection;
  published
    property Filter stored IsFilterStored;
  end;

  TSaveStitchsDialog = class(TOpenStitchsDialog)
  protected
    function IsSaveDialog : boolean; override;
  end;

implementation

uses
  Consts, Math;
  

{type
  TStitchsListViewAccess = class(TStitchsListView);
  TStitchsListAccess     = class(TStitchsList);
}

{ TOpenPictureDialog }

constructor TOpenStitchsDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FStitchsList := TStitchCollection.Create(Self);
  Filter         := GetFilter();

  {FGridPanel := TPanel.Create(Self);
  with FGridPanel do
  begin
    Name        := 'GridPanel';
    Caption     := '';
    BevelOuter  := bvNone;
    BorderWidth := 6;
    TabOrder    := 1;
    SetBounds(204, 5, 169, 200);

    {FGridLabel := TLabel.Create(Self);
    with FGridLabel do
    begin
      Name     := 'GridLabel';
      Caption  := GetGridLabelCaption;
      Align    := alTop;
      AutoSize := False;
      Parent   := FGridPanel;
      SetBounds(6, 6, 157, 23);
    end;

    FScrollBox := Tscrollbox.Create(Self);
    with FScrollBox do
    begin
      Name       := 'PaintPanel';
      Align      := alClient;
      BevelInner := bvRaised;
      BevelOuter := bvLowered;
      Ctl3D      := True;
      Color      := clBtnShadow;
      TabOrder   := 0;
      Parent     := FGridPanel;
      SetBounds(6, 29, 157, 145);

      FStitchsListView := GetStitchsListViewClass.Create(Self);
      with TStitchsListViewAccess(FStitchsListView) do
      begin
        Name     := 'PaintBox';
        Align    := alTop;
        Hint     := 'Preview of selected file';
        Parent   := FScrollBox;
        GrowFlow := ZWidth2Bottom;
        AutoSize := True;
        ItemList := FStitchsList;
        SetThumbSize(32, 32);
      end;
    end;
  end;}
end;

{procedure TOpenStitchsDialog.DoSelectionChange;

  function ValidFile(const AFileName: string): Boolean;
  begin
    Result := GetFileAttributes( PChar(AFileName) ) <> $FFFFFFFF;
  end;

var
  LFullName   : string;
  LValidFile  : Boolean;
//  LCollection : TStitchsCollection;
begin
  LCollection := TStitchsListAccess(FStitchsList).Collection;
  LFullName   := FileName;
  
  if LFullName <> FSavedFilename then
  begin
    FSavedFilename := LFullName;
    LValidFile     := FileExists(LFullName) and ValidFile(LFullName);

    if LValidFile then
    try
      LCollection.BeginUpdate;
      try
        LCollection.Clear;
        LCollection.LoadFromFile(LFullName);
      finally
        LCollection.EndUpdate;
        FStitchsListView.Height         := 1; //force
        FScrollBox.VertScrollBar.Position := 0;
        FGridLabel.Caption                := Format('%d Items', [LCollection.Count]);
      end;
    except
      LValidFile := False;
    end;
    
    if not LValidFile then
    begin
      FGridLabel.Caption := GetGridLabelCaption;
      LCollection.Clear;
    end;
  end;
  
  inherited DoSelectionChange;
end; }

procedure TOpenStitchsDialog.DoClose;
begin
  inherited DoClose;
  { Hide any hint windows left behind }
  Application.HideHint;
end;

procedure TOpenStitchsDialog.DoShow;
var
  LPreviewRect, LStaticRect : TRect;
begin
  // Set preview area to entire dialog 
  GetClientRect(Handle, LPreviewRect);
  LStaticRect := GetStaticRect;
  
  // Move preview area to right of static area 
  LPreviewRect.Left := LStaticRect.Left + (LStaticRect.Right - LStaticRect.Left);
  Inc(LPreviewRect.Top, 4);

  //FGridPanel.BoundsRect := LPreviewRect;
  //FGridPanel.Anchors    := [akLeft, akTop, akRight, akBottom];

  if not Self.IsSaveDialog then
  begin
    //FStitchsList.Clear;
  end;

  FSavedFilename          := '';
  //FGridPanel.ParentWindow := Handle;

  inherited DoShow;
end;

function TOpenStitchsDialog.Execute;
begin
  if NewStyleControls and not (ofOldStyleDialog in Options) then
    Template := 'DLGTEMPLATE' 
  else
    Template := nil;

  if Self.IsSaveDialog then
    Result := DoExecute(@GetSaveFileName)
  else
    Result := inherited Execute;

//  TStitchsListAccess(FStitchsList).Collection.Clear;
end;

function TOpenStitchsDialog.IsFilterStored: Boolean;
begin
  Result := not ( Filter = GetFilter() );
end;

{procedure TOpenStitchsDialog.SetStitchsCollection(
  const AValue: TStitchsCollection);
begin
  TStitchsListAccess(FStitchsList).Collection.Assign(AValue);
end;

function TOpenStitchsDialog.GetStitchsCollection: TStitchsCollection;
begin
  Result := TStitchsListAccess(FStitchsList).Collection;
end;}

function TOpenStitchsDialog.GetFilter: string;
begin
  if Self.IsSaveDialog then
    Result := FStitchsList.WritersFilter
  else
    Result := FStitchsList.ReadersFilter;
end;

function TOpenStitchsDialog.IsSaveDialog: Boolean;
begin
  Result := False;
end;

{function TOpenStitchsDialog.GetGridLabelCaption: string;
begin
  Result := SPictureLabel;
end;}


{ TSaveStitchsDialog }

function TSaveStitchsDialog.IsSaveDialog: boolean;
begin
  Result := True;
end;

destructor TOpenStitchsDialog.Destroy;
begin
  //FGridPanel.Free;
  FStitchsList.Destroy;
  inherited;
end;

end.
