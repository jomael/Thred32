unit umDaisyDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  Thred_Constants;

type
  TfrmDaisyDlg = class(TForm)
    btnCancel: TButton;
    edPetals: TEdit;
    edPetalPoints: TEdit;
    edMirrorPoints: TEdit;
    edInnerPetalPoints: TEdit;
    edCenterSize: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    chkHole: TCheckBox;
    chkDline: TCheckBox;
    edHoleSize: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    cbbPetalType: TComboBox;
    btnReset: TButton;
    btnOK: TButton;
    edPetalSize: TEdit;
    Label8: TLabel;
    procedure btnResetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    
  public
    { Public declarations }
  end;

var
  frmDaisyDlg: TfrmDaisyDlg;

implementation

{$R *.dfm}

procedure TfrmDaisyDlg.btnResetClick(Sender: TObject);
begin
  edPetals.Text       := IntToStr(DAZPETS);
  edPetalPoints.Text  := IntToStr(DAZCNT);
  edMirrorPoints.Text := IntToStr(DAZMCNT);
  edInnerPetalPoints.Text := IntToStr(DAZICNT);
  edCenterSize.Text   := Format('%.2f',[DAZLEN * 1.0]);
  edPetalSize.Text    := Format('%.2f',[DAZPLEN* 1.0]);
  edHoleSize.Text     := Format('%.2f',[DAZHLEN* 1.0]);
end;

procedure TfrmDaisyDlg.FormCreate(Sender: TObject);
begin
  btnResetClick(Sender);
end;

(*
void dasyfrm(){

	double		dang;
	double		pang;
	double		dangp;
	double		pangp;
	unsigned	bcnt,ind,ine,inf,dtyp,dcnt,cnt2,fref,pcnt;
	double		dlen;
	double		len;
	double		elen;
	double		ilen;
	double		drat;
	float		maxcor;
	FLPNT		ref;

	unmsg();
	if(!DialogBox(hInst,MAKEINTRESOURCE(IDD_DASY),hWnd,(DLGPROC)dasyproc))
	{
		rstMap(FORMIN);
		return;
	}
	ini.dazpet=ini.dazpet;
	len=ini.dazlen;
	elen=ini.dazplen;
	ilen=ini.dazhlen;
	dtyp=ini.daztyp;
	ref.x=midl(zoomRect.right,zoomRect.left);
	ref.y=midl(zoomRect.top,zoomRect.bottom);
	selectedForm=&formlst[formpnt];
	clofind=formpnt;
	frmclr(selectedForm);
	selectedForm->flt=&flts[fltad];
	selectedForm->at=activeLayer<<1;
	FormToGlobalVaribles(formpnt);
	cnt2=ini.dazcnt>>1;
	maxcor=zoomRect.right-zoomRect.left;
	drat=zoomRect.top-zoomRect.bottom;
	if(drat>maxcor)
		maxcor=drat;
	maxcor/=6;
	drat=(double)maxcor/(len+elen);
	len*=drat;
	elen*=drat;
	ilen*=drat;
	selectedForm->typ=POLI;
	inf=0;
	if(chku(DAZHOL))
	{
		pang=PI2;
		bcnt=ini.dazpet*ini.dazicnt;
		dang=PI2/bcnt;
		flt[inf].x=ref.x+len*cos(pang);
		flt[inf].y=ref.y+len*sin(pang);
		inf++;
		for(ind=0;ind<bcnt+1;ind++)
		{
			flt[inf].x=ref.x+ilen*cos(pang);
			flt[inf].y=ref.y+ilen*sin(pang);
			inf++;
			pang-=dang;
		}
		fref=inf;
	}
	pang=0;
	bcnt=ini.dazpet*ini.dazcnt;
	pcnt=ini.dazcnt;
	if(dtyp==DHART)
	{
		pcnt=(ini.dazpcnt+1)<<1;
		bcnt=ini.dazpet*pcnt;
	}
	dang=PI2/bcnt;
	dangp=PI/ini.dazcnt;
	if(chku(DAZD))
	{
		selectedForm->stpt=ini.dazpet-1;
		selectedForm->wpar=ini.dazpet*ini.dazicnt+1;
		selectedForm->sacang.sac=adsatk(ini.dazpet-1);
	}
	for(ind=0;ind<ini.dazpet;ind++)
	{
		pangp=0;
		psgacc=SEED;
		for(ine=0;ine<pcnt;ine++)
		{
			switch(dtyp)
			{
			case DSIN:

				dlen=len+sin(pangp)*elen;
				pangp+=dangp;
				break;

			case DRAMP:
				
				dlen=len+(double)ine/ini.dazcnt*elen;
				break;

			case DSAW:
				
				if(ine>cnt2)
					dcnt=ini.dazcnt-ine;
				else
					dcnt=ine;
				dlen=len+(double)dcnt/ini.dazcnt*elen;
				break;

			case DRAG:

				dlen=len+(double)(psg()%ini.dazcnt)/ini.dazcnt*elen;
				break;

			case DCOG:

				dlen=len;
				if(ine>cnt2)
					dlen+=elen;
				break;

			case DHART:

				dlen=len+sin(pangp)*elen;
				if(ine>ini.dazpcnt)
					pangp-=dangp;
				else
					pangp+=dangp;
				break;
			}
			flt[inf].x=ref.x+cos(pang)*dlen;
			flt[inf].y=ref.y+sin(pang)*dlen;
			inf++;
			pang+=dang;
			if(chku(DAZD)&&ind!=ini.dazpet-1)
			{
				selectedForm->sacang.sac[ind].strt=(ini.dazpet-ind-1)*ini.dazicnt+1;
				selectedForm->sacang.sac[ind].fin=inf;
			}
		}
	}
	if(chku(DAZHOL))
	{
		flt[fref-1].y+=(float)0.01;
		flt[fref].y+=(float)0.01;
	}
	selectedForm->sids=inf;
	if(chku(DAZD))
	{
		selectedForm->typ=SAT;
		selectedForm->at=1;
	}
	fltad+=inf;
	setMap(INIT);
	frmout(formpnt);
	for(ind=0;ind<inf;ind++){

		flt[ind].x-=selectedForm->rct.left;
		flt[ind].y-=selectedForm->rct.bottom;
	}
	fmovdif.x=fmovdif.y=0;
	nuflen=inf+1;
	setMap(POLIMOV);
	setmfrm();
	mdufrm();
}
*)

end.
