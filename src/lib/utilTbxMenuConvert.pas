unit utilTbxMenuConvert;
{Utility to convert standard TMenu to TB2K/TBX}
interface

{$I TB2Ver.inc}

uses
  Windows, SysUtils, Classes, Controls, Forms, Menus, StdCtrls,
  TB2Item,TBX;


procedure CopyConvertTB2K(const ParentItem: TTBCustomItem; Menu: TMenu);
procedure CopyConvertTBX(const ParentItem: TTBCustomItem; Menu: TMenu);


implementation


procedure CopyConvertTB2K(const ParentItem: TTBCustomItem; Menu: TMenu);
{originally taken from TB2DsgnConverter.pas from TB2K lib ver 2.1.6}
const
  SPropNotTransferred = 'Warning: %s property not transferred on ''%s''.';
//var  ConverterForm: TTBConverterForm;

  procedure Log(const S: String);
  begin
    {ConverterForm.MessageList.Items.Add(S);
    ConverterForm.MessageList.TopIndex := ConverterForm.MessageList.Items.Count-1;
    ConverterForm.Update;}
  end;

  procedure Recurse(MenuItem: TMenuItem; TBItem: TTBCustomItem);
  var
    I: Integer;
    Src: TMenuItem;
    IsSep, IsSubmenu: Boolean;
    Dst: TTBCustomItem;
    N: String;
    var Owner : TComponent;
  begin
    Owner := ParentItem.Owner;
    for I := 0 to MenuItem.Count-1 do begin
      Src := MenuItem[I];
      IsSep := (Src.Caption = '-');
      IsSubmenu := False;
      if not IsSep then begin
        if Src.Count > 0 then
          IsSubmenu := True;
        if not IsSubmenu then
          Dst := TTBItem.Create(Owner)
        else
          Dst := TTBSubmenuItem.Create(Owner);
        Dst.Action := Src.Action;
        {$IFDEF JR_D6}
        Dst.AutoCheck := Src.AutoCheck;
        {$ENDIF}
        Dst.Caption := Src.Caption;
        Dst.Checked := Src.Checked;
        if Src.Default then
          Dst.Options := Dst.Options + [tboDefault];
        Dst.Enabled := Src.Enabled;
        Dst.GroupIndex := Src.GroupIndex;
        Dst.HelpContext := Src.HelpContext;
        Dst.ImageIndex := Src.ImageIndex;
        Dst.RadioItem := Src.RadioItem;
        Dst.ShortCut := Src.ShortCut;
        {$IFDEF JR_D5}
        Dst.SubMenuImages := Src.SubMenuImages;
        {$ENDIF}
        Dst.OnClick := Src.OnClick;
      end
      else begin
        Dst := TTBSeparatorItem.Create(Owner);
      end;
      Dst.Hint := Src.Hint;
      Dst.Tag := Src.Tag;
      Dst.Visible := Src.Visible;
      if not IsSep then
        { Temporarily clear the menu item's OnClick property, so that renaming
          the menu item doesn't cause the function name to change }
        Src.OnClick := nil;
      try
        {N := Src.Name;
        Src.Name := N + '_OLD';
        Dst.Name := N;}
        Dst.Name := Src.Name;
      finally
        if not IsSep then
          Src.OnClick := Dst.OnClick;
      end;
      TBItem.Add(Dst);
      {$IFDEF JR_D5}
      if @Src.OnAdvancedDrawItem <> nil then
        Log(Format(SPropNotTransferred, ['OnAdvancedDrawItem', Dst.Name]));
      {$ENDIF}
      if @Src.OnDrawItem <> nil then
        Log(Format(SPropNotTransferred, ['OnDrawItem', Dst.Name]));
      if @Src.OnMeasureItem <> nil then
        Log(Format(SPropNotTransferred, ['OnMeasureItem', Dst.Name]));
      if IsSubmenu then
        Recurse(Src, Dst);
    end;
  end;

var
//  OptionsForm: TTBConvertOptionsForm;
  I: Integer;
  C: TComponent;
  //Menu: TMenu;
begin
//  Menu := nil;
  //OptionsForm := TTBConvertOptionsForm.Create(Application);
  {try
    for I := 0 to Owner.ComponentCount-1 do begin
      C := Owner.Components[I];
      if (C is TMenu) and not(C is TTBPopupMenu) then
        OptionsForm.MenuCombo.Items.AddObject(C.Name, C);
    end;
    if OptionsForm.MenuCombo.Items.Count = 0 then
      raise Exception.Create('Could not find any menus on the form to convert');
    OptionsForm.MenuCombo.ItemIndex := 0;
    if (OptionsForm.ShowModal <> mrOK) or (OptionsForm.MenuCombo.ItemIndex < 0) then
      Exit;
    Menu := TMenu(OptionsForm.MenuCombo.Items.Objects[OptionsForm.MenuCombo.ItemIndex]);
  finally
    OptionsForm.Free;
  end;}
  ParentItem.SubMenuImages := Menu.Images;
  {ConverterForm := TTBConverterForm.Create(Application);
  ConverterForm.Show;
  ConverterForm.Update;
  Log(Format('Converting ''%s'', please wait...', [Menu.Name]));}
  ParentItem.ViewBeginUpdate;
  try
    Recurse(Menu.Items, ParentItem);
  finally
    ParentItem.ViewEndUpdate;
  end;
  {Log('Done!');
  ConverterForm.CloseButton.Enabled := True;
  ConverterForm.CopyButton.Enabled := True;}
end;

procedure CopyConvertTBX(const ParentItem: TTBCustomItem; Menu: TMenu);
{originally taken from TB2DsgnConverter.pas from TB2K lib ver 2.1.6}
const
  SPropNotTransferred = 'Warning: %s property not transferred on ''%s''.';
//var  ConverterForm: TTBConverterForm;

  procedure Log(const S: String);
  begin
    {ConverterForm.MessageList.Items.Add(S);
    ConverterForm.MessageList.TopIndex := ConverterForm.MessageList.Items.Count-1;
    ConverterForm.Update;}
  end;

  procedure Recurse(MenuItem: TMenuItem; TBXItem: TTBCustomItem);
  var
    I: Integer;
    Src: TMenuItem;
    IsSep, IsSubmenu: Boolean;
    Dst: TTBCustomItem;
    N: String;
    var Owner : TComponent;
  begin
    Owner := ParentItem.Owner;
    for I := 0 to MenuItem.Count-1 do begin
      Src := MenuItem[I];
      IsSep := (Src.Caption = '-');
      IsSubmenu := False;
      if not IsSep then begin
        if Src.Count > 0 then
          IsSubmenu := True;
        if not IsSubmenu then
          Dst := TTBXItem.Create(Owner)
        else
          Dst := TTBXSubmenuItem.Create(Owner);
        Dst.Action := Src.Action;
        {$IFDEF JR_D6}
        Dst.AutoCheck := Src.AutoCheck;
        {$ENDIF}
        Dst.Caption := Src.Caption;
        Dst.Checked := Src.Checked;
        if Src.Default then
          Dst.Options := Dst.Options + [tboDefault];
        Dst.Enabled := Src.Enabled;
        Dst.GroupIndex := Src.GroupIndex;
        Dst.HelpContext := Src.HelpContext;
        Dst.ImageIndex := Src.ImageIndex;
        Dst.RadioItem := Src.RadioItem;
        Dst.ShortCut := Src.ShortCut;
        {$IFDEF JR_D5}
        Dst.SubMenuImages := Src.SubMenuImages;
        {$ENDIF}
        Dst.OnClick := Src.OnClick;
      end
      else begin
        Dst := TTBXSeparatorItem.Create(Owner);
      end;
      Dst.Hint := Src.Hint;
      Dst.Tag := Src.Tag;
      Dst.Visible := Src.Visible;
      if not IsSep then
        { Temporarily clear the menu item's OnClick property, so that renaming
          the menu item doesn't cause the function name to change }
        Src.OnClick := nil;
      try
        {N := Src.Name;
        Src.Name := N + '_OLD';
        Dst.Name := N;}
        Dst.Name := Src.Name;
      finally
        if not IsSep then
          Src.OnClick := Dst.OnClick;
      end;
      TBXItem.Add(Dst);
      {$IFDEF JR_D5}
      if @Src.OnAdvancedDrawItem <> nil then
        Log(Format(SPropNotTransferred, ['OnAdvancedDrawItem', Dst.Name]));
      {$ENDIF}
      if @Src.OnDrawItem <> nil then
        Log(Format(SPropNotTransferred, ['OnDrawItem', Dst.Name]));
      if @Src.OnMeasureItem <> nil then
        Log(Format(SPropNotTransferred, ['OnMeasureItem', Dst.Name]));
      if IsSubmenu then
        Recurse(Src, Dst);
    end;
  end;

var
//  OptionsForm: TTBConvertOptionsForm;
  I: Integer;
  C: TComponent;
  //Menu: TMenu;
begin
//  Menu := nil;
  //OptionsForm := TTBConvertOptionsForm.Create(Application);
  {try
    for I := 0 to Owner.ComponentCount-1 do begin
      C := Owner.Components[I];
      if (C is TMenu) and not(C is TTBPopupMenu) then
        OptionsForm.MenuCombo.Items.AddObject(C.Name, C);
    end;
    if OptionsForm.MenuCombo.Items.Count = 0 then
      raise Exception.Create('Could not find any menus on the form to convert');
    OptionsForm.MenuCombo.ItemIndex := 0;
    if (OptionsForm.ShowModal <> mrOK) or (OptionsForm.MenuCombo.ItemIndex < 0) then
      Exit;
    Menu := TMenu(OptionsForm.MenuCombo.Items.Objects[OptionsForm.MenuCombo.ItemIndex]);
  finally
    OptionsForm.Free;
  end;}
  ParentItem.SubMenuImages := Menu.Images;
  {ConverterForm := TTBConverterForm.Create(Application);
  ConverterForm.Show;
  ConverterForm.Update;
  Log(Format('Converting ''%s'', please wait...', [Menu.Name]));}
  ParentItem.ViewBeginUpdate;
  try
    Recurse(Menu.Items, ParentItem);
  finally
    ParentItem.ViewEndUpdate;
  end;
  {Log('Done!');
  ConverterForm.CloseButton.Enabled := True;
  ConverterForm.CopyButton.Enabled := True;}
end;

end.
