unit uResourceString;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    pnl1: TPanel;
    btn1: TButton;
    pc1: TPageControl;
    tab1: TTabSheet;
    spl1: TSplitter;
    lst1: TListBox;
    lst2: TMemo;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.btn1Click(Sender: TObject);
var i : Integer;
  procedure Load();
  var s, id,m : string;
    v : Integer;
  begin
    while i < lst1.Items.Count do
    begin
      s := lst1.Items[i];
      Inc(i);
      if (Trim(s) <> '') and (Copy(s,1, 4) = '    ' ) then
      begin
        v := Pos('"',s);
        id := Copy(s,1,v-1);


        m := Trim(copy(s,v+1,1000));
        if m[Length(m)] = '"' then
          m := Copy(m, 1, Length(m) -1);
        m := StringReplace(m, '\n', '''#13''',[rfReplaceAll]);

        lst2.Lines.Add(Format('%s = ''%s'';',[id,m]));


      end;

    end;

  end;

begin
  i := 1;
  lst2.Lines.BeginUpdate;
  Load();
  lst2.Lines.EndUpdate;
end;

end.
