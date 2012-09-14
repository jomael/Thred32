unit Thred_h;

interface
  uses Windows;

//compile switches
{.$define		PESACT		0}		//compile pes code
(*
#define		BUGBAK		0		//turn bakseq off

#define		TRCMTH		1		//0=brightness compard,1=color compare

#define		RUTVALID	1
#define		COMVALID	2
#define		REGVALID	4
			
#define		RUTSED		1232323232	
#define		COMSED		1323232323
#define		TIMSED		1313131313
#define		TIMSIG		2211221122 //time signature for trial operation
#define		DAY1		864000000000	//file time ticks in a day
#define		DAY31		26784000000000	//file time ticks in 31 days
#define		DAY400		345600000000000	//file time ticks in 400 days
#define		TRILIM		100				//expired trial clipboard limit
#define		SRTIM		20000000		//sort time limit in 100 ns intervals
//end of trial version codes

//daisy codes
#define		DAZPETS		5		//petals
#define		DAZCNT		10		//petal points
#define		DAZICNT		2		//petal inner points
#define		DAZLEN		15		//diameter
#define		DAZPLEN		20		//petal length
#define		DAZHLEN		5		//hole size
#define		DAZTYP		5		//border type
#define		DAZMCNT		7		//mirror count
//end of daisy codes

#define		TXTRAT		0.95	//texture fill clipboard shrink/grow ratio
#define		MAXMSK		$ffff0000	//for checking for greater than 65536
#define		MAXSEQ		65536	//maximum number of points in the sequence list

#define		DEFBPIX		4		//default form box pixels
#define		MAXWLK		54		//max underlay/edge walk stitch length
#define		MINWLK		2.4		//max underlay/edge walk stitch length
#define		DEFULEN		12;		//default underlay stitch length
#define		DEFUSPAC	6;		//default underlay stitch spacing

#define		IWAVPNTS	36		//default wave points
#define		IWAVSTRT	10		//default wave start
#define		IWAVEND		26		//default wave end
#define		IWAVS		5		//default wave lobes
#define		THRLED0		$746872 //lead dword value for thred file v 1.0
#define		THRLED1		$1746872	//lead dword value for thred file v 1.1
#define		MAXFLT		65536	//maximum number of floating point items, form & clipboard points
#define		ZUMFCT		0.65	//zoom factor
#define		PAGSCROL	0.9		//page scroll factor
#define		LINSCROL	0.05	//line scroll factor
#define		TXTSIDS		6		//extra pixels in a text box
#define		MAXPCS		131072	//maximum possible stiches in a pcs file*2
#define		MAXCHNG		10000	//maximum number of color changes
#define		SHUPX		480		//small hoop x size
#define		SHUPY		480		//small hoop y size
#define		LHUPX		719		//large hoop x size
#define		LHUPY		690		//large hoop y size
#define		HUP10$Y	600		//100 millimeter hoop size
#define		PFGRAN		6		//pfaf "pixels" per millimeter
#define		TSIZ30		0.3		//#30 thread size in millimeters
#define		TSIZ40		0.2		//#40 thread size in millimeters
#define		TSIZ60		0.05	//#60 thread size in millimeters
#define		SCROLSIZ	12		//width of a scroll bar
#define		COLSIZ		12		//width of the color bar
#define		RIGHTSIZ	24		//SCROLSIZ+COLSIZ
#define		CLOSENUF	10		//mouse click region for select
#define		ZMARGIN		1.25	//zoom margin for select zooms
#define		SMALSIZ		0.25	//default small stitch size
#define		MINSIZ		0.1		//default minimum stitch size
#define		USESIZ		3.5		//user preferred size
#define		MAXSIZ		9.0		//default maximum stitch size
#define		PFAFGRAN	6		//pfaf stitch points per millimeter
#define		RMAPSIZ		65536	//a bit for each stitch
#define		RMAPBITS	RMAPSIZ<<5	//a bit for each stitch
#define		MINZUM		5	    //minimum zoom in stitch points
#define		MAXZLEV		9		//maximum levels of zoom
#define		SHOPNTS		0.00	//show stitch points when zoom below this
#define		STCHBOX		0.4226	//show stitch boxes when zoom below this
#define		BITCOL		$ffff00//default bitmap color
#define		MAXFORMS	1024	//maximum number of forms
#define		FORMFCT		0.05	//new forms part of screen
#define		MAXDELAY	600		//maximum movie delay
#define		MINDELAY	1		//minimum movie delay
#define		MOVITIM		12		//default movie time
#define		DEFSPACE	0.45	//default stitch spacing
#define		JMPSPACE	13		//default jump stitch spacing
#define		DEFANG		0.785398163397448 //default fill angle, 45 degrees
#define		MAXFRMLINS	20000	//maximum lines in a form
#define		MSGSIZ		8192	//size of the message buffer
#define		PI			3.1415926535898
#define		PI2			6.2831853071796
#define		MAXSTCH		54		//maximum permitted stitch length for pfaf in pfaf "stitch pixels"
#define		USPAC		15		//underlay fill spacing
#define		APSPAC		10.8	//applique border spacing
#define		OSEQLEN		262144	//output sequence length
#define		BSEQLEN		OSEQLEN<<1	//reverse sequence length
#define		MAXRAT		3		//maximum number of stitches in one place in satin border
#define		URAT		0.75	//ratio of underlay stitch to satin border size
#define		PURAT		0.6		//for perp satin corners
#define		DIURAT		0.125	//(1-URAT)/2
#define		DOURAT		0.8125	//(1-URAT)/2+URAT
#define		MINRCT		12		//minimum dimension of a form select rectangle
#define		OLDNUM		4		//number of old filenames saved on file menu
#define		OLDVER		4		//number of old file versions kept
#define		TINY		1e-6	//tiny number for floating point stuff
#define		SPEDLIN		30		//speed change for line message on speed scroll bar
#define		SPEDPAG		120		//speed change for page message on speed scroll bar
#define		KNOTLEN		54		//set knots for stitches longer than this
#define		MAXFRMPNTS	65536	//maximum total form points
#define		MAXCLPNTS	65536	//maximum total cliboard storage in forms
#define		MAXSAC		10000	//maximum number of satin guidlins
#define		MAXKNOTS	16384	//maximum nuber of knots
#define		IBFCLEN		4*PFGRAN //initial buttonhole fill corner length
#define		IPICSPAC	6		//initial picot border space
#define		PRFLINS		28		//number of lines on the prefernece menu
#define		EDGETYPS	12		//number of border fill types
#define		SEED		3037000499 //pseudo-random-sequence seed
#define		FSED		1340007303 //feather seqence seed
#define		NAMSED		2222222222 //trial version psg seed
#define		DSTRAT		0.8333333333333333	//ratio of dst stitch points to PFAFF stitch points
#define		HUPS		5		//number of hoops the user can select
#define		NORDSED		$5a5a5a5a	//name order seed
#define		NCODSED		$73ef5a7e	//name encoding seed
#define		NCODOF		80			//name encoding offset
#define		CLPMIN		0.5		//if clipboard data less wide, then don't fill
#define		CLPMINAUT	1.2		//for skinny vertical clips
#define		BRDWID		18		//default sating border size
#define		SNPLEN		0.15	//default snap together length size
#define		STARAT		0.4		//default star ratio
#define		SPIRWRAP	1.52	//default spiral wrap
#define		BALNORM		$80			//normal balarad stitch
#define		BALJUMP		$81			//balarad jump stitch
#define		BALSTOP		0				//balarad stop
#define		COLVER		$776874	//color file version
#define		PESCMSK		$3f		//pes color mask
#define		REDCOL		$ff		//code for the color red
#define		GRNCOL		$ff00		//code for the color green
#define		BLUCOL		$ff0000	//code for the color blue
#define		REDMSK		$ffff00	//mask for the color red
#define		GRNMSK		$ff00ff	//mask for the color green
#define		BLUMSK		$00ffff	//mask for the color blue
#define		TRACLEN		1			//initial trace length
#define		TRACRAT		1.00001		//initial trace ratio
#define		CHSDEF		24			//default chain stitch length
#define		CHRDEF		0.25		//default chain stitch ratio
#define		NUGINI		2			//default nudge step
#define		DEFPIX		2			//default nudge pixels
#define		DEFEGRAT	1.5			//default egg ratio
#define		DEFPNTPIX	4			//default form and stitch point pixels
#define		HBUFSIZ		1024		//help buffer size
#define		HIGRD		$ffffff	//grid high color
#define		MEDGRD		$404040	//grid medium color
#define		DEFGRD		$202020	//grid default color
#define		REDGRD		$ff2020	//grid red color
#define		BLUGRD		$20ff20	//grid green color
#define		GRNGRD		$2020ff	//grid blue color
#define		FDEFRAT		0.6			//default feather ratio
#define		FDEFUP		10			//default feather up count
#define		FDEFDWN		5			//default feather down count
#define		FDEFFLR		9			//default feather floor
#define		FDEFNUM		10			//default feather number
#define		FDEFTYP		FTHPSG		//default feather type
#define		ITXHI		9*PFGRAN	//default texture editor heigth
#define		ITXWID		9*PFGRAN	//default texture editor width
#define		ITXSPAC		0.40*PFGRAN	//default texture editor spacing
#define		ITXPIX		5			//default texture editor cross pixels

enum begin 

	STR_PIKOL,
	STR_UPON,
	STR_UPOF,
	STR_AUXTXT,
	STR_HUP0,
	STR_HUP1,
	STR_HUP2,
	STR_HUP3,
	STR_HUP4,
	STR_TRC0,
	STR_TRC1S,
	STR_TRC2,
	STR_TRC3,
	STR_TRC4,
	STR_TRC1H,
	STR_NUMPNT,
	STR_NUMFRM,
	STR_NUMSCH,
	STR_NUMFORM,
	STR_NUMSEL,
	STR_BOXSEL,
	STR_CLOS,
	STR_TOT,
	STR_LAYR,
	STR_OVRLOK,
	STR_OVRIT,
	STR_THRED,
	STR_NUFIL,
	STR_TRIAL,
	STR_EMB,
	STR_ON,
	STR_OFF,
	STR_FMEN,
	STR_TXT0,
	STR_TXT1,
	STR_TXT2,
	STR_TXT3,
	STR_TXT4,
	STR_TXT5,
	STR_TXT6,
	STR_TXT7,
	STR_TXT8,
	STR_TXT9,
	STR_TXT10,
	STR_TXT11,
	STR_TXT12,
	STR_TXT13,
	STR_TXT14,
	STR_TXT15,
	STR_TXT16,
	STR_TXT17,
	STR_TXT18,
	STR_TXT19,
	STR_TXT20,
	STR_TXT21,
	STR_TXT22,
	STR_TXT23,
	STR_FIL0,
	STR_FIL1,
	STR_FIL2,
	STR_FIL3,
	STR_FIL4,
	STR_FIL5,
	STR_FIL6,
	STR_FIL7,
	STR_FIL8,
	STR_FIL9,
	STR_FIL10,
	STR_FIL11,
	STR_FIL12,
	STR_FIL13,
	STR_EDG0,
	STR_EDG1,
	STR_EDG2,
	STR_EDG3,
	STR_EDG4,
	STR_EDG5,
	STR_EDG6,
	STR_EDG7,
	STR_EDG8,
	STR_EDG9,
	STR_EDG10,
	STR_EDG11,
	STR_EDG12,
	STR_PRF0, 
	STR_PRF1, 
	STR_PRF2, 
	STR_PRF3, 
	STR_PRF4, 
	STR_PRF5, 
	STR_PRF6, 
	STR_PRF7, 
	STR_PRF8, 
	STR_PRF9, 
	STR_PRF10,
	STR_PRF11,
	STR_PRF12,
	STR_PRF13,
	STR_PRF14,
	STR_PRF15,
	STR_PRF16,
	STR_PRF17,
	STR_PRF18,
	STR_PRF19,
	STR_PRF20,
	STR_PRF21,
	STR_PRF22,
	STR_PRF23,
	STR_PRF24,
	STR_PRF25,
	STR_PRF26,
	STR_PRF27,
	STR_FRMPLUS,
	STR_FRMINUS,
	STR_OKENT,
	STR_CANCEL,
	STR_FREH,
	STR_BLUNT,
	STR_TAPR,
	STR_PNTD,
	STR_SQR,
	STR_DELST2,
	STR_THRDBY,
	STR_STCHOUT,
	STR_STCHS,
	STR_FORMS,
	STR_HUPWID,
	STR_CREATBY,
	STR_CUSTHUP,
	STR_STCHP,
	STR_FRMP,
	STR_ENTROT,
	STR_NUDG,
	STR_ALLX,
	STR_FTHCOL,
	STR_FTHTYP,
	STR_FTH0,
	STR_FTH1,
	STR_FTH2,
	STR_FTH3,
	STR_FTH4,
	STR_FTH5,
	STR_FTHBLND,
	STR_FTHUP,
	STR_FTHDWN,
	STR_FTHUPCNT,
	STR_FTHDWNCNT,
	STR_FTHSIZ,
	STR_FTHNUM,
	STR_FTHFLR,
	STR_FSTRT,
	STR_FEND,
	STR_WALK,
	STR_UWLKIND,
	STR_UND,
	STR_ULEN,
	STR_FUANG,
	STR_FUSPAC,
	STR_CWLK,
	STR_UNDCOL,
	STR_FRMBOX,
	STR_TXOF,
	STR_LEN,	//must be last entry in enum
end; ;

//edge tracing directions
enum begin 

	TRCU,			//top edge
	TRCR,			//right edge
	TRCD,			//bottom edge
	TRCL			//left edge
end;;

enum begin 

	SETCUST :=1,		//set the custom hoop
	SMALHUP := 2,		//pfaf code for small hoop
	LARGHUP,		//pfaf code for large hoop
	HUP100,			//100 millimeter hoop
	CUSTHUP			//user defined hoop size
end;;

enum	//daisy form types
begin 
	DSIN,
	DRAMP,
	DSAW,
	DRAG,
	DCOG,
	DHART,
end; ;

//bitmap
enum begin

	SATIN,		//user is entering a satin stitch form
	SATPNT,		//user is entering points for a satin stitch form
	BOXZUM,		//box zoom select mode
	BZUMIN,		//display the zoom box
	BZUM,		//zoom box displayed on screen
	INSRT,		//insert mode active
	SELPNT,		//user has clicked on a selected point
	SATCNKT,	//user is connecting points in a satin form
	INSFRM,		//user is inserting points in a form
	FORMIN,		//user is selecting a form
	PRFACT,		//user is selecting preferences
	POLIMOV,	//user is placing a pre defined form
	SIZSEL,		//thread size select boxes displayed
	THRDS,		//State of the threads/lines box
	LINED,		//line has been started
	LININ,		//line is in the zoom rectangle
	ZUMED,		//stitch window is zoomed
	COL,		//state of the color/all box
	HID,		//state of the show/hide button
	ISDWN,		//down stitch exists
	ISUP,		//up stitch exists
	WASLIN,		//a move stitch line has been drawn
	CAPT,		//screen capture in effect
	VCAPT,		//keep screen capture as long as the mouse cursor
				// is in the edit window
	SELBOX,		//the select box is showing
	ILIN,		//insert line is showing on the screen
	INIT,		//set when a stitch is entered in the stitch buffer,a form is entered, or the mark is set
	LIN1,		//drawing only one line in stitch insert mode
	ILIN1,		//one insert line showing on screen
	GRPSEL,		//group select mode
	SCROS,		//start group cross has been drawn
	ECROS,		//end group cross has been drawn
	ELIN,		//group select line has been drawn
	BAKEND,		//insert data should be appended to the end of the file
	CLPSHO,		//display the clipboard insert rectangle
	SELSHO,		//display the select rectangle
	ROTAT,		//rotate state
	ROTSHO,		//rotate rectangle is showing
	ROTUSHO,	//rotate indicator line is showing
	ROTCAPT,	//rotate capture mode
	MOVCNTR,	//user is moving the rotate center
	GETMIN,		//user is entering a minimum stitch length
	NUMIN,		//user in entering a number
	MOVFRM,		//user is moving a form point
	MOVMSG,		//user tried to move an edited form
	SHOFRM,		//form is currently written to the screen
	STHR,		//user is entering a new stitch box threshold
	ENTAR,		//user is adjusting a number with the up and down arrow keys
	ENTR30,		//user is entering a new thread size for #30 thread
	ENTR40,		//user is entering a new thread size for #40 thread
	ENTR60,		//user is entering a new thread size for #60 thread
	FORMSEL,	//a form is selected
	FRMPMOV,	//user is moving a point on a form
	IGNOR,		//user may elect to ignore a message about losing edits when resizing a form
	FRMOV,		//user is moving a form
	RUNPAT,		//user is runing a pattern
	WASPAT,		//user ran a pattern, but hasn't done anything else yet
	FILDIR,		//direction lines in angle fill
	SHOSAT,		//the satin stitch form is on the screen
	SHOCON,		//connect point line is visible
	FENDIN,		//user is selecting fill ends
	DELFRM,		//user wants to delete a form
	BAKACT,		//there are entries in the undo buffer
	BAKWRAP,	//undo buffer pointer has wrapped
	BAKING,		//user has called the undo function
	REDUSHO,	//redo menu item is active
	UNDUSHO,	//undo menu item is active
	FUNCLP,		//user is loading a form from the clipboard
	FRMPSEL,	//user has selected a point in a form
	SHOINSF,	//the form insert line has been drawn
	SAT1,		//set when the first stitch is entered in a satin fill
	FILMSG,		//set when user tries to unfil a form with edited stitches
	CLPBAK,		//set when the first clipboard fill item has been entered
	STRTCH,		//user is stretching a form horizontally or vertically
	SHOSTRTCH,	//stretch box is written to the screen
	EXPAND,		//user is expanding a form horizontally and vertically
	SIDACT,		//side message window is active
	BRDACT,		//border data in side message window
	FILTYP,		//0=main fill, 1=border fill, used in side message display
	GMRK,		//draw the mark on the screen
	SIDCOL,		//user is selecting a fill color for a form
	BRDSID,		//user is selecting a border fill color for a form
	ENTRPOL,	//user is entering sides for a regular polygon
	FRMROT,		//user is rotating a form
	DELTO,		//user is deleting a form and the associated stitches
	REDOLD,		//user is opening a file from the old file list
	BAKSHO,		//user is looking at bakup files
	DUBAK,		//user has chosen a backup file to load, but may want to save changes
	IGNAM,		//save the thred file without making backups
	PRGMSG,		//delete all backups message is displayed
	NEWBAK,		//user is starting a new file, but may want to save changes
	SAVEX,		//user is exiting, may want to save changes
	OSAV,		//user wants to load a new file, may want to save changes
	FRMOF,		//forms are not displayed and can't be selected
	SHOMOV,		//user moving form line shown on screen
	BARSAT,		//doing a bare satin fill to be filled in with clipboard data
	ENTRSTAR,	//user in entering the number of points for a star
	ENTROT,		//user is entering a rotate number for command rotate;
	ENTRDUP,	//user is entering a rotate angle for rotate and duplicate
	ENTRSPIR,	//user is entering the number of points for a spiral
	ENTRHART,	//user is entering the number of points for a heart
	ENTRLENS,	//user is entering the number of points for a lens
	SEQDUN,		//last stitch seqenced was already done
	WASEL,		//a form was selected when the user hit control-right-click
	MOVFRMS,	//user is moving a group of forms
	FRMSROT,	//user is rotating group of forms
	FUNSCLP,	//user is pasting a group of forms
	DELSFRMS,	//user is deleting a group of forms
	BIGBOX,		//user has selected all forms and stitches
	MOVSET,		//the move point has been selected
	UPTO,		//show points upto the selected point
	LENSRCH,	//user has hit the max or min button
	BOXSLCT,	//user is making a select box
	THUMSHO,	//thumbnail mode
	INSFIL,		//user is inserting a file
	IGNORINS,	//don't use the open file dialog box to get the insert file name
	RBUT,		//user pressed the right mouse button selecting a thumbnail 
	UND,		//stitching a perp satin underlay
	UNDPHAS,	//perp satin underlay phase
	SAVAS,		//user is saving a file under a new name
	SHOSIZ,		//design size box is displayed
	HUPMSG,		//user is selecting a hoop size
	IGNTHR,		//ignore the close enough threshold for 'C' hotkey
	MONOMAP,	//set if a color bitmap is loaded
	THUMON,		//user is loading a thumnail
	CLPOVR,		//can't fit another clipboard fill on the current line
	CONTIG,		//contiguous point flag
	NUROT,		//user is entering a rotate angle
	APSID,		//user is enter a new applique color
	FRMSAM,		//don't find an already selected form
	ENTRSEG,	//user is entering rotation segments
	ENTRFNUM,	//user is entering a form number
	WASFRMFRM,	//need to restore the form-form
	SAVACT,		//activate the undo save
	CNTRH,		//for centering horizontally
	CNTRV,		//for centering vertically
	RESTCH,		//redraw the stitch window
	WASGRP,		//group of stitches selecter when entering length search
	REFILMSG,	//refill all message is up
	PRELIN,		//user is inserting form points before the 0 point in a line form
	WASRT,		//insert was active when preferences activated
	WASDIR,		//last minimum direction for sequencing
	BRKFIX,		//last line sequenced was from the end of a break of an already done region
	RELAYR,		//need to write the layer in the layer button
	HIDSTCH,	//don't display the stitches
	WASIN,		//placing stitches inside the form for vertical clipboard fill
	LTRACE,		//line trace funtion active
	HUPEX,		//set when points are outside the hoop
	HUPCHNG,	//hoop size has been changed
	SIZED,		//window has been resized
	ROTAL,		//user is rotating all stitches
	ZUMACT,		//zoom to actual size
	WASREFIL,	//last fill was a refil
	DUMEN,		//menu needs to be refilled
	WASNEG,		//form had a point less than the size of the clipboard fill
	FCLOS,		//user is closing a file
	NOTFREE,	//no free space on the drive
	PIXIN,		//user in inputting nudge pixels
	STPXIN,		//user is inputting stitch point pixels
	FRMPXIN,	//user is inputting form point pixels
	WASMRK,		//user has set a mark
	RESIZ,		//need to change the size of the main window
	MSGOF,		//offset the message box
	WASMOV,		//mouse move capture flag
	WASCOL,		//mouse move started in a color box
	ENTREG,		//user is entering an egg form
	BADFIL,		//loaded file is corrupted
	WASTRAC,	//traace bitmap loaded
	LANDSCAP,	//trace bitmap is landscape position
	WASEDG,		//trace edge map was created
	TRCUP,		//trace the up limit
	TRCRED,		//red trace on
	TRCGRN,		//green trace on
	TRCBLU,		//blue trace on
	DUHI,		//paint the high trace rectangle
	DULO,		//paint the low trace rectangle
	WASDIF,		//found edges on bitmap
	WASDSEL,	//color selected bitmap
	TRNIN0,		//trace color number input
	TRNUP,		//trace up number input
	WASTRCOL,	//trace color entered from keyboard
	TRNIN1,		//trace paramater number input
	TRSET,		//trace numbers have been set
	WASESC,		//user hit escape
	HIDMAP,		//hide the bitmap
	WASBLAK,	//bitmap form pixels set to black
	LINCHN,		//chain stich has line in middle
	ENTRZIG,	//user is creating a zig-zag form
	FOLFRM,		//form-form is displaying a follower form
	DUREFRM,	//display the form-form
	SIDX,		//display the extra fills
	WASLED,		//lead form found in frmchk
	FPSEL,		//form points selected
	SHOPSEL,	//form points selected rectangle is showing
	PSELDIR,	//direction of form point select
	FPUNCLP,	//user is retrieving cliped form points into a form
	SHOP,		//clipboard from points are showing
	WASPCDCLP,	//there is pcd data on the clipboard
	FTHR,		//feather fill flag
	FBOTH,		//do both sides of a feather fill
	ENTRFTHUP,	//user is entering the feather up number
	FTHSID,		//user is entering a feather color
	CNV2FTH,	//converting a form to feather ribbon
	WASFPNT,	//user is moving a form point
	WASDO,		//backup has been made before refil
	NOSEL,		//left button down didn't select anything
	WASDEL,		//stitches were deleted
	FLPBLND,	//flip the feather blend bit before refilling
	GTWLKIND,	//get the edge walk/underlay offset
	GTWLKLEN,	//get the edge walk/underlay stitch length
	GTUANG,		//get the underlay angle
	GTUSPAC,	//get the underaly spacing
	BADVER,		//key version does not match
	DUSRT,		//write sort info
	WLKDIR,		//edge walk direction, 0=forward
	INDIR,		//inner border switched with outer
	DIDSTRT,	//start stitches have been written
	REFCNT,		//counting the form-form lines
	UNDCOL,		//user is entrering an underlay color
	FSETULEN,	//user is setting the underlay stitch length for a group of forms
	ISEND,		//writing the end stitches
	FSETUSPAC,	//user is setting the underlay spacing for a group of forms
	FSETUANG,	//user is setting the underlay angle for a group of forms
	FSETFLEN,	//user is setting the fill stitch length for a group of forms
	FSETFSPAC,	//user is setting the fill spacing for a group of forms
	FSETFANG,	//user is setting the fill angle for a group of forms
	FSETUCOL,	//user is setting the underlay coler for a group of forms
	FSETFCOL,	//user is setting the fill coler for a group of forms
	FSETBCOL,	//user is setting the border coler for a group of forms
	FSETBLEN,	//user is setting the border coler for a group of forms
	FSETBSPAC,	//user is setting the border spacing for a group of forms
	FSETBMIN,	//user is setting the minimum border stitch length for a group of forms
	FSETBMAX,	//user is setting the maximum border stitch length for a group of forms
	FSETFMIN,	//user is setting the minimum fill stitch length for a group of forms
	FSETFMAX,	//user is setting the maximum fill stitch length for a group of forms
	FSETFWID,	//user is setting the width for a group of forms
	FSETFHI,	//user is setting the height for a group of forms
	TXTRED,		//displaying the texture fill editor
	FRMBOXIN,	//user is setting the form box pixels
	TXTMOV,		//user is moving a texture editor point
	TXTCLP,		//user is setting texture points with a clipboard form
	TXTLIN,		//user is setting texture pints in a line
	WASTXBAK,	//texture fill editor history active
	LASTXBAK,	//last key was a texture back key
	TXBDIR,		//texture backup direction
	TXHCNTR,	//texture center on
	TXFIL,		//texture fill in progress
	WASWROT,	//texture clipboard form was written
	DESCHG,		//design size change 0=x, 1=y 
	CMPDO,		//design has been changed
	ISUND,		//doing underaly fill
	CHKTX,		//user has changed the texture fill window size, check the points
	FSETFIND,	//user is setting the indent for a group of forms
	TXBOX,		//user is importing stitches for textured fill
	TXIN,		//last stitch point was in stitch select box
	SCLPSPAC,	//user is setting the clipbard fill spacing
	FCHK,		//check the forms
	NOCLP,		//don't load clipboard data from forms
	NOTHRFIL,	//loaded file wasn't a Thred file

	LASTBIT,	//must be the last entry in the enum
end; ;

#define	MAPLEN (LASTBIT>>5)+1 //length of the state bitmap in 32 bit words

#define BZUMINB 1<<BZUMIN
#define BOXZUMB 1<<BOXZUM
#define INSRTB 1<<INSRT
#define SELPNTB 1<<SELPNT
#define SATINB 1<<SATIN
#define SATPNTB 1<<SATPNT
#define SATCNKTB 1<<SATCNKT
#define INSFRMB 1<<INSFRM
#define SELBOXM 1<<SELBOX
#define FORMINB 1<<FORMIN
#define PRFACTB 1<<PRFACT
#define	POLIMOVB 1<<POLIMOV

//user bitmap
enum begin 

	SQRFIL,		//square ends on fills
	BLUNT,		//blunt ends on satin lines
	NEDOF,		//needle cursor off
	KNOTOF,		//don't show knots
	BSAVOF,		//don't save PCS bitmaps
	LINSPAC,	//evenly space border line points
	DUND,		//underlay in satin borders
	FIL2OF,		//fill to select off
	ROTAUX,		//rotate the aux file when saving
	SAVMAX,		//thred window maximized
	MARQ,		//remove mark when user hits escape only
	FRMX,		//cross cursor for form entry
	DAZHOL,		//daisy hole
	DAZD,		//daisy d-lines
	CHREF,		//refill forms when changing design size
	WRNOF,		//warn if edited off
end; ;

enum begin 			//feather fill types

	FTHSIN := 1,	//sine
	FTHSIN2,	//half sine
	FTHLIN,		//line
	FTHPSG,		//psuedo-random sequence
	FTHRMP,		//sawtooth
	FTHFAZ,		//phase
end;;

#pragma pack(1)

//pcs file header structure
typedef struct _hed begin 

	TCHAR			ledIn;
	TCHAR			hup;
	unsigned SmallInt	fColCnt;
	COLORREF		fCols[16];
	unsigned SmallInt	stchs;
end; HED;

//ini file structure
typedef struct _iniFil begin 

	TCHAR			defDir[180];	//default directory
	COLORREF		stchCols[16];	//colors
	COLORREF		selStch[16];	//stich preference colors
	COLORREF		bakCol[16];		//background preference colors
	COLORREF		stchBak;		//background color
	COLORREF		bitCol;			//bitmap color
	Double			minsiz;			//minimum stitch length
	Double			shopnts;		//show stitch points 
	Double			tsiz30;			//millimeter size of 30 weight thread
	Double			tsiz40;			//millimeter size of 40 weight thread
	Double			tsiz60;			//millimeter size of 60 weight thread
	Double			usesiz;			//user stitch length
	Double			maxsiz;			//maximum stitch length
	Double			smalsiz;		//small stitch size
	Double			stchboxs;		//show sitch box level
	Double			stspace;		//stitch spacing between lines of stitches
	Double			angl;			//fill angle
	unsigned		umap;			//bitmap
	Double			brdwid;			//border width
	unsigned		apcol;			//applique color
	TCHAR			oldnams[OLDNUM,MAX_PATH];	//last file names
	Double			snplen;			//snap together length
	Double			starat;			//star ratio
	Double			spirwrap;		//sprial wrap
	COLORREF		bakBit[16];		//bitmap background color preferences
	Double			bfclen;			//buttonhole fill corner length		
	Single			picspac;		//space between border picots
	TCHAR			hup;			//hoop type
	TCHAR			auxfil;			//machine file type
	Single			hupx;			//hoop x size
	Single			hupy;			//hoop y size
	Double			rotang;			//rotation angle
	Single			grdsiz;			//grid size
	Single			clpof;			//clipboard offset
	RECT			irct;			//initial window coordinates
	COLORREF		grdbak;			//grid color
	unsigned		faz;			//clipboard fill phase
	Single			xcust;			//custom hoop width
	Single			ycust;			//custom hoop heigth
	Single			trlen;			//lens points
	Double			trcrat;			//trace ratio
	Single			chspac;			//chain space
	Single			chrat;			//chain ratio
	Single			nudg;			//cursor nudge step
	unsigned SmallInt  nudgpix;		//nudge pixels
	Single			egrat;			//egg ratio
	unsigned SmallInt	stchpix;		//size of stitch points in pixels
	unsigned SmallInt	frmpix;			//size of form points in pixels
	unsigned SmallInt	nsids;			//sides of a created form
	Single			tearat;			//length of the tear tail
	Single			twststp;		//tear twist step
	Single			twstrat;		//tear twist ratio
	unsigned SmallInt	wavpnts;		//wave points
	unsigned SmallInt	wavstrt;		//wave strting point
	unsigned SmallInt	wavend;			//wave ending point;
	unsigned SmallInt	wavs;			//wave lobes
	unsigned char	fthtyp;			//feather fill type
	unsigned char	fthup;			//feather up count
	unsigned char	fthdwn;			//feather down count
	unsigned char	fthbits;		//feather bits
	Single			fthrat;			//feather ratio
	Single			fthflr;			//feather floor
	unsigned SmallInt	fthnum;			//feather fill psg granularity
	TCHAR			p2cnam[MAX_PATH];	//pes2card file
	Single			wind;			//edge walk/underlay indent
	Single			uang;			//underlay angle
	Single			uspac;			//underlay spacing
	Single			ulen;			//underlay stitch length
	Single			dazlen;			//daisy diameter
	Single			dazplen;		//daisy petal length
	Single			dazhlen;		//daisy hole diameter
	unsigned		dazpet;			//daisy petals
	unsigned		dazcnt;			//daisy petal points
	unsigned		dazicnt;		//daisy inner count
	unsigned char	daztyp;			//daisy border type
	unsigned char	dchk;			//data check
	Single			txthi;			//textured fill height
	Single			txtwid;			//textured fill width
	Single			txtspac;		//textured fill spacing
	unsigned SmallInt	frmbpix;		//form box pixels
	unsigned SmallInt	dazpcnt;		//daisy heart count
	unsigned SmallInt  txtx;			//texture editor pixels
	Single			clpspc;			//clipboard fill spacing
	TCHAR			desnam[50];		//designer name
end; INIFIL;

enum begin 

	AUXPCS,
	AUXDST,
	AUXPES
end; ;

typedef struct _rngc begin 

	unsigned strt;
	unsigned cnt;
	unsigned fin;
	unsigned frm;
end; RNGC;

typedef struct _dubpnt begin 

	Double x;
	Double y;

end; DUBPNT;

typedef struct _dubpntl begin 

	Double			x;
	Double			y;
	unsigned SmallInt lin;

end; DUBPNTL;

typedef struct _frct begin

	Double top;
	Double bottom;
	Double left;
	Double right;

end; FRCT;

typedef struct _colChng begin 

	unsigned SmallInt stind;	//stich index
	unsigned SmallInt colind;	//color index
end; COLCHNG;
*)
type
SHRTPNT = packed  record
	x,
	y : Single;
	at: Cardinal;
end; 
(*
#define COLMSK		$0000000f
#define NCOLMSK		$fffffff0
#define	COLSMSK		$0000ffff
#define FRMSK		$00003ff0
#define NFRMSK		$ffffc00f
#define UFRMSK		$80003ff0
#define FRMSHFT		4
#define TYPFMSK		$20003ff0
#define TYPBMSK		$40003ff0
#define TYPAPMSK	$60003ff0
#define	LAYMSK		$0e000000
#define NLAYMSK		$f1ffffff
#define LAYSHFT		25
#define TYPMSK		$60000000
#define TYPFRM		$20000000
#define TYPBRD		$40000000
#define NTYPMSK		$9fffffff
#define TYPSHFT		29
#define USMSK		$80000000
#define USHFT		31
#define	ATMSK		$7fffffff
#define NFRM_NTYP	$9fffc00f
#define TYPATMSK	$20000000
#define	LASTMSK		$20003ff0
#define	WLKMSK		$00200000
#define WLKFMSK		$00203ff0
#define	CWLKMSK		$00100000
#define CWLKFMSK	$00103ff0
#define	UNDMSK		$00400000
#define	WUNDMSK		$00600000
#define UNDFMSK		$00403ff0
#define KNOTMSK		$00800000
#define NKNOTMSK	$ff7fffff
#define FTHMSK		$01000000
#define DELMSK		$61e03ff0
#define ALTYPMSK	$61f00000
//#define	SRTMSK		$e0603fff
#define	SRTMSK		$61f03fff
#define SRTYPMSK	$61700000
#define NOTFRM		$00080000

{
bit definitions for SHRTPNT.at
0-3		stitch color
4-14	form pointer
15-18	spares
19		not a form stitch
20		center walk stitch
21		edge walk stitch
22		underlay stitch
23		knot	stitch
24		feather stitch
25-27	layer
28		spare
29-30	stitch type 00=not a form stitch, 01=form fill, 10=form border fill, 11=applique stitches
31		set for user edited stitches
}

#define	FRMFIL		$20000000
#define FRMBFIL		$40000000
#define FRMAPFIL	$60000000

typedef struct _flpnt begin

	Single x;
	Single y;
end; FLPNT;

typedef struct _flrct begin 

	Single top;
	Single left;
	Single right;
	Single bottom;
end; FLRCT;

typedef struct _dubct begin 

	Double top;
	Double left;
	Double right;
	Double bottom;
end; DUBRCT;

typedef struct _frminfo begin 

	unsigned	typ;
	unsigned	at;
	unsigned	sids;
end; FRMINFO;

typedef struct _satcon begin 

	unsigned SmallInt strt;
	unsigned SmallInt fin;
end; SATCON;

typedef union _fangclp begin

	Single		fang;
	FLPNT*		clp;
	SATCON		sat;
end; FANGCLP;

typedef union _flencnt begin 

	Single		flen;
	unsigned	nclp;
end; FLENCNT;

typedef union _sacang begin 

	SATCON*	sac;
	Single	ang;
end; SACANG;

{
	fill	elen	espac	esiz	nclp	picspac		crnrsiz		brdend

	EGLIN	elen
	EGBLD	elen
	EGCLP							nclp
	EGSAT	elen	espac	esiz									at
	EGAP	elen	espac	esiz									at
	EGPRP	elen	espac	esiz									at
	EGHOL	elen	espac	esiz						nclp,res
	EGPIC	elen			esiz	nclp	espac		res		
}

#define	BELEN		1
#define BESPAC		2
#define	BESIZ		4
#define	BNCLP		8
#define	BPICSPAC	16
#define	BCNRSIZ		32
#define	BRDEND		64
#define BRDPOS		128
#define BEMAX		256
#define BEMIN		512
#define CHNPOS		1024

#define MEGLIN		BELEN orBEMAX orBEMIN
#define MEGBLD		BELEN orBEMAX or BEMIN
#define MEGCLP		BNCLP or BEMAX or BEMIN
#define MEGSAT		BESPAC orBESIZ or BRDEND or BEMAX orBEMIN
#define MEGAP		BESPAC or BESIZ or BRDEND or BEMAX orBEMIN
#define MEGPRP		BESPAC orBESIZ or BRDEND or BEMAX orBEMIN
#define MEGHOL		BELEN or BESPAC or BESIZ or BCNRSIZ or BEMAX or BEMIN
#define MEGPIC		BELEN or BESIZ or BNCLP or BPICSPAC orBCNRSIZ or BEMAX or BEMIN
#define MEGDUB		BELEN or BEMAX or BEMIN
#define MEGCHNL		BESIZ orBESPAC or BEMAX or BEMIN or CHNPOS
#define MEGCHNH		BESIZ or BESPAC or BEMAX or BEMIN or CHNPOS
#define MEGCLPX		BNCLP or BEMAX or BEMIN

#define	EGLIN_LINS	4
#define EGBLD_LINS	4
#define EGCLP_LINS	3
#define EGSAT_LINS	6
#define EGAP_LINS	7
#define EGPRP_LINS	6
#define EGHOL_LINS	7
#define EGPIC_LINS	7
#define EGCHN_LINS	6

typedef struct _frmhedo begin

	unsigned char	at;		//attribute
	unsigned SmallInt	sids;	//number of sides
	unsigned char	typ;	//type
	unsigned char	fcol;	//fill color
	unsigned char	bcol;	//border color
	unsigned SmallInt	nclp;	//number of border clipboard entries
	FLPNT*			flt;	//points
	SACANG			sacang;	//satin guidlines or angle clipboard fill angle
	FLPNT*			clp;	//border clipboard data
	unsigned SmallInt	stpt;	//number of satin guidlines
	unsigned SmallInt	wpar;	//word parameter
	FLRCT			rct;	//rectangle
	unsigned char	ftyp;	//fill type
	unsigned char	etyp;	//edge type
	Single			fspac;	//fill spacing
	FLENCNT			flencnt;//fill stitch length or clpboard count
	FANGCLP			angclp;	//fill angle or clpboard data pointer
	Single			esiz;	//border size
	Single			espac;	//edge spacing
	Single			elen;	//edge stitch length
	unsigned SmallInt	res;	//pico length
end; FRMHEDO;

#define	FRMEND		1
#define FRMLMSK		$0e
#define NFRMLMSK	$f1

{form attribute bits

  1		end teflon line
  2-4	layer bits
  5		finish blunt
  6		start blunt
  7		refill bit for contour fill
}

//blunt bits 
#define FBLNT		$20
#define SBLNT		$40
#define	NFBLNT		$df
#define NSBLNT		$bf
#define NOBLNT		$9f

//contour refil
#define FRECONT		$80
#define NFRECONT	$7f

typedef struct _fthed
begin 
	unsigned char	fthtyp;	//feather fill type
	unsigned char	fthup;	//feather up count
	unsigned char	fthdwn;	//feather down count
	unsigned char	fthcol;	//feather blend col
	Single			fthrat;	//feather ratio
	Single			fthflr;	//feather floor
	unsigned SmallInt	fthnum; //feather fill psg granularity
end; FTHED;

typedef struct _txhed
begin 
	SmallInt			lins;
	unsigned SmallInt	ind;
	unsigned SmallInt	cnt;
	Single			hi;
end; TXHED;

typedef union _tfhed
begin 
	FTHED	fth;
	TXHED	txt;
end;TFHED;

typedef struct _frmhed begin 

	unsigned char	at;		//attribute
	unsigned SmallInt	sids;	//number of sides
	unsigned char	typ;	//type
	unsigned char	fcol;	//fill color
	unsigned char	bcol;	//border color
	unsigned SmallInt	nclp;	//number of border clipboard entries
	FLPNT*			flt;	//points
	SACANG			sacang;	//satin guidlines or angle clipboard fill angle
	FLPNT*			clp;	//border clipboard data
	unsigned SmallInt	stpt;	//number of satin guidlines
	unsigned SmallInt	wpar;	//clipboard/textured fill phase or satin connect end
	FLRCT			rct;	//rectangle
	unsigned char	ftyp;	//fill type
	unsigned char	etyp;	//edge type
	Single			fspac;	//fill spacing
	FLENCNT			flencnt;//fill stitch length or clpboard count
	FANGCLP			angclp;	//fill angle or clpboard data pointer
	Single			esiz;	//border size
	Single			espac;	//edge spacing
	Single			elen;	//edge stitch length
	unsigned SmallInt	res;	//pico length

	unsigned		xat;	//attribute extension
	Single			fmax;	//maximum fill stitch length
	Single			fmin;	//minimum fill stitch length
	Single			emax;	//maximum border stitch length
	Single			emin;	//minimum border stitch length
	TFHED			dhx;	//feather/texture info
	unsigned SmallInt	strt;	//fill strt point
	unsigned SmallInt	end;	//fill end point
	Single			uspac;	//underlay spacing
	Single			ulen;	//underlay stitch length
	Single			uang;	//underlay stitch angle
	Single			wind;	//underlay/edge walk indent
	Single			txof;	//gradient end density
	unsigned char	ucol;	//underlay color
	unsigned char	cres;	//reserved
end; FRMHED;

//frmhed extended attribute bits

#define AT_SQR 1		//square ends
#define AT_FTHUP 2		//feather up flag
#define AT_FTHDWN 4		//feather down flag
#define AT_FTHBLND 8	//feather blend flag
#define AT_STRT 16		//user set start flag
#define AT_END 32		//user set end flag
#define AT_UND 64		//underlay flag
#define AT_WALK 128		//edge walk
#define AT_CWLK 256		//center walk

typedef struct _frmclp begin 

	unsigned	led;
	unsigned	res;
	FRMHED		frm;
end; FRMCLP;

typedef struct _frmsclp begin

	unsigned		led;
	unsigned SmallInt	cnt;
	unsigned SmallInt	res;
end; FRMSCLP;

typedef struct _fpclp begin 

	unsigned		led;
	unsigned SmallInt	cnt;
	LongBool			dir;
end; FPCLP;

*)
type STRHED = packed record 		//structure thred file header
  led : Cardinal;
	len : Cardinal;	//length of strhed + length of stitch data
	stchs,	//number of stitches
	hup,	//size of hup
	fpnt,	//number of forms
	fpnts,	//points to form points
	fcnt,	//number of form points
	spnts,	//points to dline data
	scnt,	//dline data count
	epnts,	//points to clipboard data
	ecnt : WORD;	//clipboard data count
end;
(*
typedef struct _txpnt		//textured fill point
begin 
	Single	y;
	SmallInt	lin;
end; TXPNT;

typedef struct _strex begin 		//thred v1.0 file header extension
*)
TSTREX = packed record
	xhup,		//hoop size x dimension
	yhup,		//hoop size y dimension
	stgran : Single		;		//stitches per millimeter
	crtnam : array[1..50] of char;	//name of the file creator
	modnam : array[1..50] of char;	//name of last file modifier
	auxfmt : char;		//auxillary file format
	stres  : char;		//reserved
	txcnt  : Cardinal;		//textured fill point count
	res : array[1..26] of char;	//reserved for expansion
end; //STREX

(*
typedef struct _dsthed begin 		//dst file header

	TCHAR desched	[3];	// 0 0		description
	TCHAR desc		[17];	// 3 3
	TCHAR recshed	[3];	// 20 14	redord count
	TCHAR recs		[8];	// 23 17
	TCHAR cohed		[3];	// 31 1F
	TCHAR co		[4];	// 34 22
	TCHAR xplushed	[3];	// 38 26	x+ size
	TCHAR xplus		[6];	// 41 29
	TCHAR xminhed	[3];	// 47 2F	x- size
	TCHAR xmin		[6];	// 50 32
	TCHAR yplushed	[3];	// 56 38
	TCHAR yplus		[6];	// 59 3B	y+ size
	TCHAR yminhed	[3];	// 65 41
	TCHAR ymin		[6];	// 68 44	y- size
	TCHAR axhed		[3];	// 74 4A
	TCHAR ax		[7];	// 77 4D
	TCHAR ayhed		[3];	// 84 54
	TCHAR ay		[7];	// 87 57
	TCHAR mxhed		[3];	// 94 5E
	TCHAR mx		[7];	// 97 61
	TCHAR myhed		[3];	// 104 68
	TCHAR my		[7];	// 107 6B
	TCHAR pdhed		[2];	// 114 72
	TCHAR pd		[7];	// 116 74
	TCHAR eof		[1];	// 123 7B
	TCHAR res		[388];	// 124 7C
end;DSTHED;

//dst type masks

#define JMPTYP $830000
#define COLTYP $630000
#define REGTYP $030000

typedef struct _dstrec begin 		//dst stitch record

	TCHAR	led;
	TCHAR	mid;
	TCHAR	nd;
end; DSTREC;

typedef struct _smalpntl begin

	unsigned SmallInt	lin;	//lin and grp must remain in this order for sort to work
	unsigned SmallInt	grp;
	Single			x;
	Single			y;
end;SMALPNTL;

typedef struct _pcstch begin 

	unsigned char	fx;
	SmallInt	x;
	unsigned char	nx;
	unsigned char	fy;
	SmallInt	y;
	unsigned char	ny;
	unsigned char	typ;
end; PCSTCH;

typedef struct _clpstch begin 

	unsigned SmallInt	led;
	unsigned char	fx;
	unsigned SmallInt	x;
	unsigned char	spcx;
	unsigned char	fy;
	unsigned SmallInt	y;
	unsigned char	spcy;
	unsigned char	myst;
	unsigned char	typ;
end; CLPSTCH;

typedef struct _bakhed begin 

	unsigned	fcnt;
	FRMHED*		frmp;
	unsigned	scnt;
	SHRTPNT*	stch;
	unsigned	fltcnt;
	FLPNT*		flt;
	unsigned	sacnt;
	SATCON*		sac;
	unsigned	nclp;
	FLPNT*		clp;
	COLORREF*	cols;
	TXPNT*		txp;
	unsigned	ntx;
	POINT		zum0;
end; BAKHED;

typedef struct _flsiz begin 

	Single	cx;
	Single	cy;
end; FLSIZ;

typedef struct _ord begin 

	unsigned ind;
	unsigned strt;
end;ORD;

typedef struct _rang begin 

	unsigned strt;
	unsigned fin;
end; RANG;

typedef struct _secnds begin 

	unsigned ind;
	unsigned flg;
end; SECNDS;

typedef struct _rgn begin 	//region for sequencing vertical fills

	unsigned strt;		//start line of region
	unsigned end;		//end line of region
	unsigned brk;
	unsigned cntbrk;
end; RGN;

typedef struct _rcon begin 		//pmap: path map for sequencing

	unsigned SmallInt	vrt;
	unsigned SmallInt	con;
	unsigned SmallInt	grpn;
end; RCON;

typedef struct _rgseq begin		//tmpath: temporary path connections

	unsigned	pcon;		//pointer to pmap entry
	Integer			cnt;	
	TCHAR		skp;		//path not found
end; RGSEQ;

typedef struct _fseq begin 		//mpath: path of sequenced regions

	unsigned SmallInt	vrt;
	unsigned SmallInt	grpn;
	TCHAR			skp;	//path not found
end; FSEQ;

#define SEQTOP 2
#define SEQBOT 3

typedef struct _bseqpnt begin 

	Single			x;
	Single			y;
	char			attr;
end; BSEQPNT;

typedef struct _pvec begin 

	Double	ang;
	Double	len;
end; PVEC;

typedef struct _vrct2 begin 

	DUBPNT	aipnt;
	DUBPNT	aopnt;
	DUBPNT	bipnt;
	DUBPNT	bopnt;
	DUBPNT	cipnt;
	DUBPNT	copnt;
	DUBPNT	dipnt;
	DUBPNT	dopnt;
end; VRCT2;

typedef struct _curs begin 

	unsigned char frm[128];
	unsigned char dlin[128];
	unsigned char uned[128];
	unsigned char luned[128];
	unsigned char ldned[128];
	unsigned char runed[128];
	unsigned char rdned[128];
end; CURS;

//balarad file header
typedef struct _balhed begin 

	COLORREF		col[256];
	unsigned		sig;
	unsigned SmallInt	ver;
	Single			xhup;
	Single			yhup;
	COLORREF		bcol;
	unsigned char	res[1006];
end; BALHED;

//balarad stitch
typedef struct _balstch begin 

	unsigned char	cod;
	unsigned char	flg;
	Single			x;
	Single			y;
end; BALSTCH;

typedef struct _clpseg begin

	unsigned		strt;
	Single			blen;
	unsigned		bind;
	unsigned SmallInt	asid;
	unsigned		fin;
	Single			elen;
	unsigned		eind;
	unsigned SmallInt	zsid;
	TCHAR			dun;
end; CLPSEG;

typedef struct _clipsort begin

	Single		seglen;
	Single		sidlen;
	unsigned	lin;
	FLPNT		pnt;
end; CLIPSORT;

typedef struct _clipnt begin 

	Single			x;
	Single			y;
	unsigned SmallInt	sid;
	unsigned SmallInt	flg;
end; CLIPNT;

typedef struct _vclpx begin 

	unsigned seg;
	unsigned sid;
end; VCLPX;

#if PESACT

typedef struct _pesled begin 

	TCHAR			ver[8];
	unsigned		pec;
end; PESLED;

typedef struct _peshed begin 

	TCHAR	led[8];
	TCHAR	off[3];
	TCHAR	m1[13];
	TCHAR	ce[6];
	TCHAR	m2[47];
	SmallInt	xsiz;
	SmallInt	ysiz;
	TCHAR	m3[16];
	TCHAR	cs[6];
	TCHAR	m4[3];
	TCHAR	scol;
	TCHAR	m5[3];
end; PESHED;

typedef struct _pestch begin 

	SmallInt x;
	SmallInt y;
end;PESTCH;

#endif

typedef struct _trcpnt begin

	SHORT x;
	SHORT y;
end; TRCPNT;

typedef struct _trcseg begin 

	unsigned	strt;
	unsigned	clos;
end;TRCSEG;

typedef struct _txtmsg begin

	unsigned	cod;
	TCHAR*		str;
end; TXTMSG;

typedef struct _grdcod begin

	unsigned id;
	unsigned col;
end;GRDCOD;

#pragma pack() then 

//form types
enum begin 

	LIN := 1,
	POLI,
	RPOLI,
	STAR,
	SPIR,
	SAT,
	HART,
	LENS,
	EGG,
	TEAR,
	ZIG,
	WAV,
	DASY,
end; ;

//main menu items
enum begin 

	M_FILE,
	M_VIEW,
	M_FORM,
	M_EDIT,
	M_IN,
	M_OUT,
	M_UNDO,
	M_REDO,
	M_ROT,
	M_PREF,
	M_FIL,
	M_ADD,
	M_FRM,
	M_ALL,
	M_1,
	M_2,
	M_3,
	M_4,
	M_HELP,
end; ;

//fill menu items
enum begin 

	MFIL_SAT,
	MFIL_VERT,
	MFIL_HOR,
	MFIL_ANG,
	MFIL_CLP,
	MFIL_CONT,
	MFIL_BORD,
	MFIL_UNFIL
end; ;

//view menu items
enum begin 

	MVU_MOV,
	MVU_SET,
	MVU_BAK,
	MVU_ZUM,
	MVU_SIZ,
	MVU_THR,
	MVU_THC,
	MVU_DES,
	MVU_NOT,
	MVU_RMK,
	MVU_ABO,
end; ;

//clipboard data types
enum begin 

	CLP_STCH := 1,
	CLP_FRM,
	CLP_FRMS,
	CLP_FRMPS,
end;;

//edge fill types
enum begin 

	EGLIN :=1,
	EGBLD,
	EGCLP,
	EGSAT,
	EGAP,
	EGPRP,
	EGHOL,
	EGPIC,
	EGDUB,
	EGCHNL,
	EGCHNH,
	EGCLPX,
end; ;

//edge underlay bit
#define EGUND $80
#define NEGUND $7f

//form data lines
enum begin

	LFRM,			//form 0
	LLAYR,			//layer 1
	LFRMFIL,		//form fill 2	
	LFRMCOL,		//form fill color 3
	LFRMSPAC,		//form fill space 4
	LFRMLEN,		//form stitch length 5
	LFRMANG,		//angle of angle fill 6
	LBRD,			//border 7
	LBRDCOL,		//border color 8
	LBRDSPAC,		//border space 9
	LBRDLEN,		//border stitch length 10
	LBRDSIZ,		//border size 11
	LAPCOL,			//applique color 12
	LBCSIZ,			//buttonhole corner size 13
	LBSTRT,			//form start style 14
	LBFIN,			//form end style 15
	LBRDPIC,		//pico border spacing 16
	LBRDUND,		//border underlay 17
	LSACANG,		//angle clipboard angle 18
	LFRMFAZ,		//clipboard phase 19
	LBRDPOS,		//chain position 20
	LBFILSQR,		//square/pointed fill ends 21
	LMAXFIL,		//maximum fill stitch length 22
	LMINFIL,		//minimum fill stitch length 23
	LMAXBRD,		//maximum border stitch length 24
	LMINBRD,		//minimum border stitch length 25
	LFTHCOL,		//feather color 26
	LFTHTYP,		//feather fill type
	LFTHBLND,		//feather blend
	LFTHDWN,		//feather down
	LFTHUP,			//feather up
	LFTHUPCNT,		//feather up count
	LFTHDWNCNT,		//feather down count
	LFTHSIZ,		//feather size
	LFTHNUM,		//feather number
	LFTHFLR,		//feather floor
	LFSTRT,			//form fill start on/off
	LDSTRT,			//form fill start data
	LFEND,			//form fill end on/off
	LDEND,			//form fill end data
	LCWLK,			//center walk
	LWALK,			//edge walk
	LWLKIND,		//edge walk/underlay indent
	LUND,			//underlay
	LULEN,			//underaly stitch length
	LUANG,			//underlay angle
	LUSPAC,			//underlay spacing
	LUNDCOL,		//underlay color
	LTXOF,			//texture fill spacing
	LASTLIN			//must be the last entry
end; ;

//fill types
enum begin

	VRTF :=1,
	HORF,
	ANGF,
	SATF,
	CLPF,
	CONTF,
	VCLPF,
	HCLPF,
	ANGCLPF,
	FTHF,
	TXVRTF,
	TXHORF,
	TXANGF,
end; ;
#define MCLPF		1<<CLPF
#define MVCLPF		1<<VCLPF
#define MHCLPF		1<<HCLPF
#define MANGCLPF	1<<ANGCLPF

//preference window
enum begin 

	PSPAC,	//0
	PANGL,	//1
	PSQR,	//2
	PSAT,	//3
	PMAX,	//4
	PUSE,	//5
	PMIN,	//6
	PSHO,	//7
	PBOX,	//8
	PSMAL,	//9
	PAP,	//10
	PSNP,	//11
	PSTAR,	//12
	PSPIR,	//13
	PBUT,	//14
	PBLNT,	//15
	PPIC,	//16
	PHUP,	//17
	PHUPX,	//18
	PUND,	//19
	PGRD,	//20
	PCLPOF,	//21
	PFAZ,	//22
	PCHN,	//23
	PCHRAT,	//24
	PNUDG,	//25
	PEG,	//26
	PHUPY,	//27
end;;

//file menu items
enum begin 

	FM_NEW,
	FM_OPEN,
	FM_CLOS,
	FM_THUMB,
	FM_OPNPCS,
	FM_INSRT,
	FM_OVRLAY,
	FM_SAV,
	FM_SAVAS,
	FM_LODBIT,
	FM_SAVBIT,
	FM_HIDBIT,
	FM_RMVBIT,
	FM_PURG,
	FM_LOCK,
	FM_ONAM0,
	FM_ONAM1,
	FM_ONAM2,
	FM_ONAM3
end; ;

//fill message codes
enum begin 

	FMM_FAN,
	FMM_VRT,
	FMM_HOR,
	FMM_ANG,
	FMM_CLP,
	FMM_FTH,
	FML_LIN :=$100,
	FML_BLD,
	FML_ANGS,
	FML_PRPS,
	FML_APLQ,
	FML_BHOL,
	FML_CLP,
	FML_PIC,
	FMX_UNF,
	FML_CONT,
	FML_CHAIN,
end; ;

//button windows
enum begin 

	HBOXSEL,
	HUPTO,
	HHID,
	HNUM,
	HTOT,
	HMINLEN,
	HMAXLEN,
	HCOR,
	HLAYR
end; ;

enum	//text button windows
begin 
	HTXCLR,
	HTXHI,
	HTXWID,
	HTXSPAC,
	HTXVRT,
	HTXHOR,
	HTXANG,
	HTXMIR,
end;;

#define HLIN  HNUM

typedef struct _orec
begin
	unsigned 	strt;
	unsigned 	fin;
	SHRTPNT*	spnt;
	SHRTPNT*	epnt;
	unsigned 	col;
	unsigned 	typ;
	unsigned 	frm;
	unsigned	otyp;
end; OREC;

typedef struct _srtrec
begin 
	unsigned strt;
	unsigned fin;
	unsigned cnt;
	unsigned loc;
	LongBool	 dir;
end; SRTREC;

typedef struct _fstrts
begin
	unsigned apl;
	unsigned fil;
	unsigned fth;
	unsigned brd;
	unsigned apcol;
	unsigned fcol;
	unsigned fthcol;
	unsigned ecol;
end;FSTRTS;

#define M_AP	    2
#define M_CWLK	    4
#define M_WALK	    8
#define M_UND	   16
#define M_FIL	   32
#define M_FTH	   64
#define M_BRD	  128
#define M_APCOL   256
#define M_FCOL	  512
#define M_FTHCOL 1024
#define M_ECOL   2048

typedef struct _frmlim
begin 
	unsigned apstrt;
	unsigned apend;
	unsigned cstrt;
	unsigned cend;
	unsigned wstrt;
	unsigned wend;
	unsigned ustrt;
	unsigned uend;
	unsigned fstrt;
	unsigned fend;
	unsigned bstrt;
	unsigned bend;
end; FRMLIM;

typedef struct _insrec
begin 
	unsigned cod;
	unsigned col;
	unsigned ind;
	unsigned seq;
end; INSREC;

enum	//interleave sequence identifiers
begin 
	I_AP,
	I_FIL,
	I_FTH,
	I_BRD,
end;;

typedef struct _intinf
begin 
	unsigned pins;
	unsigned coloc;
	unsigned laycod;
	unsigned sloc;
	unsigned oloc;
	SHRTPNT* histch;
end; INTINF;

typedef struct _txtscr
begin
	Integer		top;	//pixel top line
	Integer		bot;	//pixel bottom line
	Integer		hi;		//pixel height of area
	Integer		mhi;	//pixel middle of area
	Single	xof;	//edit x offset of area
	Single	yof;	//edit y offset of area
	Integer		ind;	//index into temporay texture fill point table
	Single	fhi;	//edit heigth of area
	Single	ehi;	//edit heigth of screen
	Single	wid;	//edit width of area
	Single	spac;	//edit space between lines
	SmallInt	lins;	//number of lines
	Double	ed2px;	//edit to pixel ratio
	FLPNT	mid;	//middle of the form
end; TXTSCR;


typedef struct _txtrct
begin 
	SmallInt lft;
	SmallInt rit;
	Single top;
	Single bot;
end; TXTRCT;

typedef struct _txhst
begin 
	TXPNT*	txp;
	Integer		cnt;
	Single	hi;
	Single	wid;
	Single	spac;
end; TXHST;

typedef struct _rngcnt
begin
	Integer	lin;
	Integer	cnt;
end; RNGCNT;

#define BADFLT	  1
#define BADCLP	  2
#define BADSAT	  4
#define BADTX	  8

typedef struct _badcnts
begin
	unsigned at;
	Integer flt;
	Integer clp;
	Integer sat;
	Integer tx;
end; BADCNTS;
*)

implementation

end.

