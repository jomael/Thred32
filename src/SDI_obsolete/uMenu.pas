unit uMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    mm1: TMainMenu;
    file1: TMenuItem;
    new1: TMenuItem;
    open1: TMenuItem;
    save1: TMenuItem;
    N1: TMenuItem;
    lst1: TListBox;
    lst2: TListBox;
    btn1: TButton;
    pnl1: TPanel;
    spl1: TSplitter;
    pc1: TPageControl;
    tab1: TTabSheet;
    tab2: TTabSheet;
    mmoDfm: TMemo;
    tab3: TTabSheet;
    mmoInterface: TMemo;
    tab4: TTabSheet;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses StrUtils;
{$R *.dfm}

function ComponentToString(Component: TComponent): string;

var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;

    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponent(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(nil);

    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

type
  TInfo = record
    tag : string;
    txt : string;
    ID  : string;
    checked,
    grayed : Boolean;
  end;

procedure TForm2.btn1Click(Sender: TObject);
var
  i : Integer;

  function ParseInfo(src: string): TInfo ;
  var s :string;
  Space1, sep2, sep3 : integer;
  begin

    s := Trim(src);
    Result.tag := s;
    Result.ID := '';
    Result.checked := False;
    Result.grayed := False;
    Space1 := Pos(' ',s);
    if Space1 > 0 then
    begin
      Result.tag := Copy(s,1,Space1-1);
      Delete(s,1,Space1 +1);
    end;

    //
    sep2 := Pos('"',s);
    Result.txt := Copy(s,1,sep2-1);

    //
    if sep2 > 0 then
    begin
      Delete(s,1,sep2);

      if Length(s) > 0 then
      begin
        if s[1] = ',' then Delete(s,1,1);
        s := Trim(s);
        Result.ID := s;
        sep3 := Pos(',', s);
        if sep3 > 0 then
        begin
          Result.ID := Copy(s,1,sep3-1);
          Delete(s,1,sep3);
          Result.checked := Pos('CHECKED',S) >0;
          Result.grayed := Pos('GRAYED',s) >0;
        end;

      end;
    end;  


  end;


  function Load(P : TMenuItem; Level : Integer): Boolean ;
      function Str(s: string; loop: integer):string ;
      var j : Integer;
      begin
        Result := '';
        for j := 1 to loop do
        begin
          Result := Result + s;
        end;
      end;

  var m : TMenuItem;
  var s : string;
    info : TInfo;
  begin
    m := p;
    //lst2.Items.Add(info.tag);
    repeat
      if i > lst1.Items.Count -1 then Exit;
      //s := lst1[i];
      info := ParseInfo(lst1.Items[i]);
      Inc(i);

      if info.tag = 'END' then
      begin
        //Dec(i); //ignore signal
        break;
      end

      else if info.tag = 'BEGIN' then
      begin
        //Load(m, level+1);
      end

      else if (info.tag = 'POPUP') or (info.tag = 'MENUITEM') then
      begin
        lst2.Items.Add(Str(' ',Level) + info.txt + Str(' ', 10)+'|'+info.ID );
        m := TMenuItem.Create(Self);
        //m.Parent := p;
        p.Add(m);
        m.Caption := info.txt;
        if info.ID <> '' then
          m.Name := 'mnu'+ Copy(info.ID,3,100);
        m.Checked := info.checked;
        m.Enabled := not info.grayed;

        if info.tag = 'POPUP' then
        begin
          inc(i);
          Load(m, level+1);
        end;
      end

      {else if info.tag = 'MENUITEM' then
      begin
        lst2.Items.Add(Str(' ',Level) + info.txt);
        m := TMenuItem.Create(Self);
        //m.Parent := p;
        p.Add(m);
        m.Caption := info.txt;

      end};
      //else
        //Break;

      if i > lst1.Items.Count -1 then Exit;

    until False;


  end;


begin
  mm1.Items.Clear;
  mmoInterface.Lines.Clear;
  i := 1;
  lst2.Items.BeginUpdate;
  Load(mm1.Items, 0);
  lst2.Items.EndUpdate;
  mmoDfm.Lines.Text := ComponentToString(mm1);
end;

end.
