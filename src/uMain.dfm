object frmMain: TfrmMain
  Left = 279
  Top = 253
  Width = 679
  Height = 585
  Caption = 'frmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 0
    Top = 483
    Width = 667
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object lstCustomColor: TListBox
    Left = 208
    Top = 24
    Width = 105
    Height = 409
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnDrawItem = lstCustomColorDrawItem
  end
  object lst2: TListBox
    Left = 320
    Top = 24
    Width = 105
    Height = 409
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 1
    Visible = False
    OnDrawItem = lst2DrawItem
  end
  object lst3: TListBox
    Left = 432
    Top = 24
    Width = 105
    Height = 409
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnDrawItem = lst3DrawItem
  end
  object lst4: TListBox
    Left = 544
    Top = 24
    Width = 105
    Height = 409
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 3
    Visible = False
    OnDrawItem = lst4DrawItem
  end
  object lst5: TListBox
    Left = 96
    Top = 24
    Width = 105
    Height = 409
    Style = lbOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 24
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16')
    ParentFont = False
    TabOrder = 4
    Visible = False
    OnDrawItem = lst5DrawItem
  end
  object swaDefault: TgmSwatchListView
    Left = 0
    Top = 0
    Width = 30
    Height = 483
    Align = alLeft
    SwatchList = swlDefault
    ThumbWidth = 30
    ThumbHeight = 20
    ParentShowHint = False
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    ShowHint = True
    TabOrder = 5
    CellBorderStyle = borContrasGrid
    FrameColor = clSilver
  end
  object swa2: TgmSwatchListView
    Left = 30
    Top = 0
    Width = 33
    Height = 483
    Align = alLeft
    SwatchList = swlCustom
    ThumbWidth = 30
    ThumbHeight = 20
    ParentShowHint = False
    PopupMenu = pmSwa
    Scale = 1.000000000000000000
    ScaleMode = smNormal
    ShowHint = True
    TabOrder = 6
    CellBorderStyle = borContrasGrid
    FrameColor = clSilver
  end
  object pgscrlr1: TPageScroller
    Left = 0
    Top = 486
    Width = 667
    Height = 45
    Align = alBottom
    Control = swa1
    TabOrder = 7
    object swa1: TgmSwatchListView
      Left = 0
      Top = 0
      Width = 950
      Height = 45
      Align = alLeft
      AutoSize = True
      GrowFlow = NHeight2Right
      SwatchList = swlCustom
      ThumbWidth = 16
      ThumbHeight = 16
      ParentShowHint = False
      PopupMenu = pmSwa
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      ShowHint = True
      TabOrder = 0
      CellBorderStyle = borContrasGrid
      FrameColor = clGray
    end
  end
  object pb: TPaintBox32
    Left = 63
    Top = 0
    Width = 604
    Height = 483
    Align = alClient
    TabOrder = 8
    OnPaintBuffer = pbPaintBuffer
  end
  object mm1: TMainMenu
    Left = 552
    Top = 224
    object TMenuItem
      Caption = '&file'
      object mnu_FILE_NEW1: TMenuItem
        Caption = 'New'
        OnClick = mnu_FILE_NEW1Click
      end
      object mnu_FILE_OPEN1: TMenuItem
        Caption = '&Open (O)'
        OnClick = mnu_FILE_OPEN1Click
      end
      object mnu_CLOSE: TMenuItem
        Caption = 'Close'
      end
      object mnu_THUM: TMenuItem
        Caption = 'Thumbnails (T)'
      end
      object mnu_OPNPCD: TMenuItem
        Caption = 'Open PCS file'
      end
      object mnu_PES2CRD: TMenuItem
        Caption = 'PES2Card (W+Cntrl)'
      end
      object mnu_INSFIL: TMenuItem
        Caption = 'Insert'
      end
      object mnu_OVRLAY: TMenuItem
        Caption = 'Overlay'
      end
      object mnu_FILE_SAVE2: TMenuItem
        Caption = 'Save (^S, F7)'
      end
      object mnu_FILE_SAVE3: TMenuItem
        Caption = 'Save As (F8)'
      end
      object mnu_LODBIT: TMenuItem
        Caption = 'Load Bitmap'
      end
      object mnu_SAVMAP: TMenuItem
        Caption = 'Save Bitmap'
      end
      object mnu_HIDBITF: TMenuItem
        Caption = 'Hide Bitmap (Shift+X)'
        Checked = True
      end
      object mnu_DELMAP: TMenuItem
        Caption = 'Remove Bitmap'
      end
      object TMenuItem
        Caption = 'Delete Backups'
        object mnu_PURG: TMenuItem
          Caption = 'Backups for the selected file'
        end
        object mnu_PURGDIR: TMenuItem
          Caption = 'All backups in the selected directory'
        end
      end
      object mnu_FLOK: TMenuItem
        Caption = 'Locking'
      end
    end
    object TMenuItem
      Caption = '&view'
      object mnu_RUNPAT: TMenuItem
        Caption = 'Movie (I)'
      end
      object TMenuItem
        Caption = 'Set'
        object mnu_SETAP: TMenuItem
          Caption = 'Applique Color'
        end
        object mnu_VIEW_STCHBAK: TMenuItem
          Caption = 'Background Color'
        end
        object mnu_BITCOL: TMenuItem
          Caption = 'Bit Map Color'
        end
        object mnu_CLPSPAC: TMenuItem
          Caption = 'Clipboard Fill  Spacing'
        end
        object TMenuItem
          Caption = 'Data Check'
          object mnu_CHKOF: TMenuItem
            Caption = 'Off'
            Checked = True
          end
          object mnu_CHKON: TMenuItem
            Caption = 'On'
            Checked = True
          end
          object mnu_CHKREP: TMenuItem
            Caption = 'Auto Repair'
            Checked = True
          end
          object mnu_CHKREPMSG: TMenuItem
            Caption = 'Auto Repair with Message'
            Checked = True
          end
          object mnu_VIEW_SET_DATACHECK: TMenuItem
          end
        end
        object mnu_SETPREF: TMenuItem
          Caption = 'Default Preferences'
        end
        object TMenuItem
          Caption = 'Fill at Select'
          object mnu_FIL2SEL_ON: TMenuItem
            Caption = 'On'
          end
          object mnu_FIL2SEL_OFF: TMenuItem
            Caption = 'Off'
          end
        end
        object TMenuItem
          Caption = 'Form Cursor'
          object mnu_FRMBOX: TMenuItem
            Caption = 'Box'
          end
          object mnu_FRMX: TMenuItem
            Caption = 'Cross'
          end
        end
        object TMenuItem
          Caption = 'Grid Mask'
          object mnu_GRDHI: TMenuItem
            Caption = 'High'
          end
          object mnu_GRDMED: TMenuItem
            Caption = 'Medium'
          end
          object mnu_GRDEF: TMenuItem
            Caption = 'Default'
          end
          object mnu_GRDRED: TMenuItem
            Caption = 'UnRed'
          end
          object mnu_GRDBLU: TMenuItem
            Caption = 'UnBlue'
          end
          object mnu_GRDGRN: TMenuItem
            Caption = 'UnGreen'
          end
        end
        object TMenuItem
          Caption = 'Line Border Spacing'
          object mnu_LINBEXACT: TMenuItem
            Caption = 'Exact'
          end
          object mnu_LINBEVEN: TMenuItem
            Caption = 'Even'
          end
        end
        object TMenuItem
          Caption = 'Machine File Type'
          object mnu_AUXPCS: TMenuItem
            Caption = 'Pfaff PCS '
          end
          object mnu_AUXDST: TMenuItem
            Caption = 'Tajima DST'
          end
        end
        object TMenuItem
          Caption = 'Needle Cursor'
          object mnu_SETNEDL: TMenuItem
            Caption = 'On'
          end
          object mnu_RSTNEDL: TMenuItem
            Caption = 'Off'
          end
        end
        object mnu_NUDGPIX: TMenuItem
          Caption = 'Nudge Pixels'
        end
        object TMenuItem
          Caption = 'PCS Bitmap Save'
          object mnu_BSAVON: TMenuItem
            Caption = 'On'
          end
          object mnu_BSAVOF: TMenuItem
            Caption = 'Off'
          end
        end
        object TMenuItem
          Caption = 'Point Size'
          object mnu_STCHPIX: TMenuItem
            Caption = 'Stitch Point Boxes'
          end
          object mnu_FRMPIX: TMenuItem
            Caption = 'Form Point Triangles'
          end
          object mnu_FRMPBOX: TMenuItem
            Caption = 'Form Box'
          end
        end
        object TMenuItem
          Caption = 'Remove Mark'
          object mnu_MARKESC: TMenuItem
            Caption = 'Escape'
            Checked = True
          end
          object mnu_MARKQ: TMenuItem
            Caption = 'Q'
            Checked = True
          end
        end
        object TMenuItem
          Caption = 'Rotate Machine File'
          object mnu_ROTAUXON: TMenuItem
            Caption = 'On'
          end
          object mnu_ROTAUXOFF: TMenuItem
            Caption = 'Off'
          end
        end
        object TMenuItem
          Caption = 'Underlay'
          object mnu_UANG: TMenuItem
            Caption = 'Angle'
          end
          object mnu_WIND: TMenuItem
            Caption = 'Indent'
          end
          object mnu_USPAC: TMenuItem
            Caption = 'Spacing'
          end
          object mnu_USTCH: TMenuItem
            Caption = 'Stitch Length'
          end
        end
        object mnu_WARNOF: TMenuItem
          Caption = 'Warn if edited'
          Checked = True
        end
      end
      object mnu_VUBAK: TMenuItem
        Caption = 'Backups'
      end
      object mnu_ZUMFUL: TMenuItem
        Caption = 'Zoom Full (X)'
      end
      object TMenuItem
        Caption = 'Thread Size'
        object mnu_SIZ30: TMenuItem
          Caption = '30'
        end
        object mnu_SIZ40: TMenuItem
          Caption = '40'
        end
        object mnu_SIZ60: TMenuItem
          Caption = '60'
        end
        object mnu_TSIZDEF: TMenuItem
          Caption = 'Set Defaults'
        end
      end
      object mnu_VUTHRDS: TMenuItem
        Caption = 'Show Threads (F6)'
      end
      object mnu_VUSELTHRDS: TMenuItem
        Caption = 'Show Threds for Selected Color'
      end
      object mnu_DESIZ: TMenuItem
        Caption = 'Design Information ('#39')'
      end
      object TMenuItem
        Caption = 'Knots'
        object mnu_KNOTON: TMenuItem
          Caption = 'On'
        end
        object mnu_KNOTOF: TMenuItem
          Caption = 'Off'
        end
      end
      object mnu_BAKMRK: TMenuItem
        Caption = 'Retrive Mark (B+Shift)'
      end
      object mnu_ABOUT: TMenuItem
        Caption = 'About Thred'
      end
    end
    object mnu_FORM: TMenuItem
      Caption = 'f&orm'
    end
    object TMenuItem
      Caption = '&edit'
      object TMenuItem
        Caption = 'Center'
        object mnu_CNTRH: TMenuItem
          Caption = 'Horizontal (- +Shift)'
        end
        object mnu_CNTRV: TMenuItem
          Caption = 'Vertical (- +Control)'
        end
        object mnu_CNTRX: TMenuItem
          Caption = 'Both (-)'
        end
        object mnu_CENTIRE: TMenuItem
          Caption = 'Entire Design'
        end
        object mnu_CNTR: TMenuItem
          Caption = 'Forms (L)'
        end
      end
      object mnu_CHK: TMenuItem
        Caption = 'Check Range'
      end
      object TMenuItem
        Caption = 'Convert'
        object mnu_2FTHR: TMenuItem
          Caption = 'to Feather Ribbon (F+shift)'
        end
        object mnu_RIBON: TMenuItem
          Caption = 'to Satin Ribbon (C+shift)'
        end
        object mnu_DUBEAN: TMenuItem
          Caption = 'to Bean'
        end
        object mnu_UNBEAN: TMenuItem
          Caption = 'from Bean to Line'
        end
        object mnu_STCHS2FRM: TMenuItem
          Caption = 'Stitches to Form'
        end
      end
      object TMenuItem
        Caption = 'Copy to Layer'
        object mnu_LAYCPY0: TMenuItem
          Caption = '0'
        end
        object mnu_LAYCPY1: TMenuItem
          Caption = '1'
        end
        object mnu_LAYCPY2: TMenuItem
          Caption = '2'
        end
        object mnu_LAYCPY3: TMenuItem
          Caption = '3'
        end
        object mnu_LAYCPY4: TMenuItem
          Caption = '4'
        end
      end
      object mnu_CROP: TMenuItem
        Caption = 'Crop to Form (W+Shift)'
      end
      object TMenuItem
        Caption = 'Delete'
        object mnu_DELFRMS: TMenuItem
          Caption = 'All Forms'
        end
        object TMenuItem
          Caption = 'All Forms and Stitches (Delete+Cntrl+Shift)'
        end
        object mnu_DELSTCH: TMenuItem
          Caption = 'All Stitches (L+shift)'
        end
        object mnu_DELFRE: TMenuItem
          Caption = 'Free Stitches'
        end
        object mnu_DELKNOT: TMenuItem
          Caption = 'Knots'
        end
        object mnu_REMBIG: TMenuItem
          Caption = 'Large Stitches (F11+shift)'
        end
        object mnu_DELETE: TMenuItem
          Caption = 'Select (delete)'
        end
        object mnu_REMZERO: TMenuItem
          Caption = 'Small Stitches (F11)'
        end
      end
      object TMenuItem
        Caption = 'Flip'
        object mnu_FLIPH: TMenuItem
          Caption = 'Horizontal'
        end
        object mnu_FLIPV: TMenuItem
          Caption = 'Vertical'
        end
        object mnu_FLPORD: TMenuItem
          Caption = 'Order'
        end
      end
      object TMenuItem
        Caption = '&Form Update'
        object TMenuItem
          Caption = '&Border'
          object mnu_SETBCOL: TMenuItem
            Caption = '&Color'
          end
          object mnu_MAXBLEN: TMenuItem
            Caption = '&Maximum Stitch Length'
          end
          object mnu_MINBLEN: TMenuItem
            Caption = 'm&Inimum Stitch Length'
          end
          object mnu_SETBLEN: TMenuItem
            Caption = '&Stitch Length'
          end
          object mnu_SETBSPAC: TMenuItem
            Caption = 's&Pacing'
          end
        end
        object TMenuItem
          Caption = '&Center Walk'
          object mnu_SETCWLK: TMenuItem
            Caption = '&On'
          end
          object mnu_NOTCWLK: TMenuItem
            Caption = 'o&Ff'
          end
        end
        object TMenuItem
          Caption = '&Edge Walk'
          object mnu_SETWLK: TMenuItem
            Caption = '&On'
          end
          object mnu_NOTWLK: TMenuItem
            Caption = 'o&Ff'
          end
        end
        object TMenuItem
          Caption = '&Fill'
          object mnu_SETFANG: TMenuItem
            Caption = '&Ang'
          end
          object mnu_SETFCOL: TMenuItem
            Caption = '&Color'
          end
          object mnu_MAXFLEN: TMenuItem
            Caption = '&Maximum Stitch Length'
          end
          object mnu_MINFLEN: TMenuItem
            Caption = 'm&Inimum Stitch Length'
          end
          object mnu_SETFLEN: TMenuItem
            Caption = '&Stitch Length'
          end
          object mnu_SETFSPAC: TMenuItem
            Caption = 's&Pacing'
          end
        end
        object mnu_FRMHI: TMenuItem
          Caption = '&Height'
        end
        object mnu_FRMIND: TMenuItem
          Caption = '&Indent'
        end
        object TMenuItem
          Caption = '&Underlay'
          object mnu_SETUND: TMenuItem
            Caption = '&On'
          end
          object mnu_NOTUND: TMenuItem
            Caption = 'o&Ff'
          end
          object mnu_SETUANG: TMenuItem
            Caption = '&Angle'
          end
          object mnu_SETUCOL: TMenuItem
            Caption = '&Color'
          end
          object mnu_SETUSPAC: TMenuItem
            Caption = '&Spacing'
          end
        end
        object mnu_UNDLEN: TMenuItem
          Caption = 'under &Stitch length'
        end
        object mnu_FRMWID: TMenuItem
          Caption = '&Width'
        end
      end
      object TMenuItem
        Caption = 'Move'
        object mnu_MV2FRNT: TMenuItem
          Caption = 'to Start'
        end
        object mnu_MOVMRK: TMenuItem
          Caption = 'to Mark (;)'
        end
        object mnu_MV2BAK: TMenuItem
          Caption = 'to End'
        end
      end
      object TMenuItem
        Caption = 'Move to Layer'
        object mnu_LAYMOV0: TMenuItem
          Caption = '0'
        end
        object mnu_LAYMOV1: TMenuItem
          Caption = '1'
        end
        object mnu_LAYMOV2: TMenuItem
          Caption = '2'
        end
        object mnu_LAYMOV3: TMenuItem
          Caption = '3'
        end
        object mnu_LAYMOV4: TMenuItem
          Caption = '4'
        end
      end
      object mnu_REFILAL: TMenuItem
        Caption = 'Refill All (J)'
      end
      object mnu_REPAIR: TMenuItem
        Caption = 'Repair Data'
      end
      object mnu_EDIT_RESET_COL: TMenuItem
        Caption = 'Reset Colors'
      end
      object mnu_RETRACE: TMenuItem
        Caption = 'Retrace'
      end
      object mnu_RTRVCLP: TMenuItem
        Caption = 'Retreive Clipboard Stitches (F4)'
      end
      object TMenuItem
        Caption = 'Rotate'
        object mnu_ROTAGAIN: TMenuItem
          Caption = 'Again'
        end
        object mnu_ROTDUP: TMenuItem
          Caption = 'and Duplicate'
        end
        object mnu_DUPAGAIN: TMenuItem
          Caption = 'and Duplicate  Again'
        end
        object mnu_ROTCMD: TMenuItem
          Caption = 'Command'
        end
      end
      object TMenuItem
        Caption = 'Select'
        object mnu_ALFRM: TMenuItem
          Caption = 'All Forms'
        end
        object mnu_SELAL: TMenuItem
          Caption = 'All Forms and Stitches (A+Shift)'
        end
        object mnu_SELALSTCH: TMenuItem
          Caption = 'All Stitches A+Cntrl'
        end
        object mnu_EDIT_SELECTCOLOR: TMenuItem
          Caption = 'Color'
        end
        object mnu_SELAP: TMenuItem
          Caption = 'Form Applique Stitches'
        end
        object mnu_SELBRD: TMenuItem
          Caption = 'Form Border Stitches'
        end
        object mnu_SELWLK: TMenuItem
          Caption = 'Form Edge Walk Stitches'
        end
        object mnu_SELFIL: TMenuItem
          Caption = 'Form Fill Stitches'
        end
        object mnu_SELFSTCHS: TMenuItem
          Caption = 'Form Stitches'
        end
        object mnu_SELUND: TMenuItem
          Caption = 'Form Underlay Stitches'
        end
      end
      object TMenuItem
        Caption = 'Set'
        object mnu_DESNAM: TMenuItem
          Caption = 'Designer Name'
        end
        object mnu_SETSIZ: TMenuItem
          Caption = 'Design Size'
        end
        object mnu_FTHDEF: TMenuItem
          Caption = 'Feather Defaults'
        end
        object mnu_FILSTRT: TMenuItem
          Caption = 'Fill Start Point (<)'
        end
        object mnu_FILEND: TMenuItem
          Caption = 'Fill End Point (>)'
        end
        object mnu_FRMNUM: TMenuItem
          Caption = 'Form Number (/)'
        end
        object mnu_FRM2COL: TMenuItem
          Caption = 'Form Color to  Stich Color'
        end
        object mnu_FRM0: TMenuItem
          Caption = 'Form Zero Point'
        end
        object mnu_KNOTS: TMenuItem
          Caption = 'Knots'
        end
        object mnu_KNOTAT: TMenuItem
          Caption = 'Knot at Selected Stitch (K+Cntrl)'
        end
        object mnu_SETMRK: TMenuItem
          Caption = 'Order Mark (.)'
        end
        object mnu_CLPADJ: TMenuItem
          Caption = 'Range Ends for Clip Board Fills'
        end
        object TMenuItem
          Caption = 'Rotation'
          object mnu_SETROT: TMenuItem
            Caption = 'Angle (R+Cntrl)'
          end
          object mnu_ROTMRK: TMenuItem
            Caption = 'Angle from Mark (R+Shift)'
          end
          object mnu_ROTSEG: TMenuItem
            Caption = 'Segments (R)'
          end
        end
        object mnu535: TMenuItem
          Caption = 'Selected'
        end
        object mnu_MRKCNTR: TMenuItem
          Caption = 'Zoom Mark at Center (M+Shift)'
        end
        object mnu_MRKPNT: TMenuItem
          Caption = 'Zoom Mark at Selected Point (M+Cntrl)'
        end
      end
      object mnu_SHRINK: TMenuItem
        Caption = 'Shrink Clipboard Border'
      end
      object TMenuItem
        Caption = 'Snap'
        object mnu_SNAP2: TMenuItem
          Caption = 'Together [F2]'
        end
        object mnu_SNAP2GRD: TMenuItem
          Caption = 'to Grid [S+shift]'
        end
      end
      object TMenuItem
        Caption = 'Sort'
        object mnu_SORT: TMenuItem
          Caption = 'Auto (F3)'
        end
        object mnu_SRTBF: TMenuItem
          Caption = 'by Color then Form (F3+Shift)'
        end
        object mnu_SRTF: TMenuItem
          Caption = 'by Form (F3+Cntrl)'
        end
      end
      object mnu_SPLTFRM: TMenuItem
        Caption = 'Split Form'
      end
      object TMenuItem
        Caption = 'Trace'
        object mnu_TRDIF: TMenuItem
          Caption = 'Find Edges (U+control)'
        end
        object mnu_HIDBIT: TMenuItem
          Caption = 'Hide Bitmap (X+shift)'
          Checked = True
        end
        object mnu_BLAK: TMenuItem
          Caption = 'Reset Form Pixels (H)'
        end
        object mnu_TRCSEL: TMenuItem
          Caption = 'Select Colors (H+control)'
        end
        object mnu_TRACE: TMenuItem
          Caption = 'Trace Mode (T+Control)'
        end
        object mnu_TRACEDG: TMenuItem
          Caption = 'Show Traced Edges (right or left click)'
        end
      end
      object TMenuItem
        Caption = 'Ungroup'
        object mnu_UNGRPLO: TMenuItem
          Caption = 'First{[)'
        end
        object mnu_UNGRPHI: TMenuItem
          Caption = 'Last (])'
        end
      end
    end
    object mnuMIN: TMenuItem
      Caption = '&in'
    end
    object mnu_ZUMOUT: TMenuItem
      Caption = 'o&ut'
    end
    object mnu_BACK: TMenuItem
      Caption = 'u&ndo'
      Enabled = False
    end
    object mnu_REDO: TMenuItem
      Caption = '&redo'
      Enabled = False
    end
    object mnu_ROT: TMenuItem
      Caption = 'ro&t'
    end
    object mnu_PREF: TMenuItem
      Caption = '&pref'
    end
    object TMenuItem
      Caption = 'fi&ll'
      object mnu_FILSAT: TMenuItem
        Caption = 'Fan'
      end
      object mnu_FETHR: TMenuItem
        Caption = 'Feather'
      end
      object mnu_FILL_VERT: TMenuItem
        Caption = 'Vertical'
      end
      object mnu_FILL_HOR: TMenuItem
        Caption = 'Horizontal'
      end
      object mnu_FILANG: TMenuItem
        Caption = 'Angle'
      end
      object TMenuItem
        Caption = 'Clipboard'
        object mnu_CLPFIL: TMenuItem
          Caption = 'Fan'
        end
        object mnu_VRTCLP: TMenuItem
          Caption = 'Vertical'
        end
        object mnu_HORCLP: TMenuItem
          Caption = 'Horizontal'
        end
        object mnu_ANGCLP: TMenuItem
          Caption = 'Angle'
        end
      end
      object mnu_CONTF: TMenuItem
        Caption = 'Contour'
      end
      object mnu_TXFIL: TMenuItem
        Caption = 'Texture Editor'
      end
      object TMenuItem
        Caption = 'Border'
        object mnu_FILIN: TMenuItem
          Caption = 'Line'
        end
        object mnu_BOLD: TMenuItem
          Caption = 'Bean'
        end
        object mnu_SATBRD: TMenuItem
          Caption = 'Angle Satin'
        end
        object mnu_PERP: TMenuItem
          Caption = 'Perpendicular Satin'
        end
        object mnu_APLIQ: TMenuItem
          Caption = 'Applique'
        end
        object mnu_FILBUT: TMenuItem
          Caption = 'BH'
        end
        object mnu_FILCLP: TMenuItem
          Caption = 'Clipboard'
        end
        object mnu_FILCLPX: TMenuItem
          Caption = 'Clipboard, Even'
        end
        object mnu_PICOT: TMenuItem
          Caption = 'Picot'
        end
        object mnu_DUBFIL: TMenuItem
          Caption = 'Double'
        end
        object mnu_LINCHN: TMenuItem
          Caption = 'Line chain'
        end
        object mnu_OPNCHN: TMenuItem
          Caption = 'Open chain'
        end
      end
      object mnu_UNFIL: TMenuItem
        Caption = 'Unfill'
      end
      object mnu_REFILF: TMenuItem
        Caption = 'Refil (F5)'
      end
    end
    object mnu_ADEND: TMenuItem
      Caption = '&add'
    end
    object mnu_FRMOF: TMenuItem
      Caption = 'fr&m+'
    end
    object mnu_LA: TMenuItem
      Caption = 'all'
    end
    object mnu_L1: TMenuItem
      Caption = '&1'
    end
    object mnu_L2: TMenuItem
      Caption = '&2'
    end
    object mnu_L3: TMenuItem
      Caption = '&3'
    end
    object mnu_L4: TMenuItem
      Caption = '&4'
    end
    object mnu_HLP: TMenuItem
      Caption = '&help'
      OnClick = mnu_HLPClick
    end
  end
  object dlgOpen1: TOpenDialog
    Left = 256
    Top = 16
  end
  object swlCustom: TgmSwatchList
    Left = 64
    Top = 56
  end
  object pmSwa: TPopupMenu
    Left = 216
    Top = 40
    object Select1: TMenuItem
      Caption = 'Select'
      Default = True
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object EditColor1: TMenuItem
      Caption = '&Edit'
      OnClick = EditColor1Click
    end
    object LoadColorfromfile1: TMenuItem
      Caption = '&Load'
      OnClick = LoadColorfromfile1Click
    end
    object Savecolorstofile1: TMenuItem
      Caption = '&Save'
    end
  end
  object swlDefault: TgmSwatchList
    Left = 64
    Top = 104
  end
  object dlgOpenSwa: TOpenSwatchDialog
    Left = 240
    Top = 168
  end
  object dlgColor1: TColorDialog
    Left = 128
    Top = 88
  end
end
