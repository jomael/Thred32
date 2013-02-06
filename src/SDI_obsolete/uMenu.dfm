object Form2: TForm2
  Left = 332
  Top = 181
  Width = 930
  Height = 479
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 922
    Height = 41
    Align = alTop
    Caption = 'pnl1'
    TabOrder = 0
    object btn1: TButton
      Left = 528
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Build Menu!'
      TabOrder = 0
      OnClick = btn1Click
    end
  end
  object pc1: TPageControl
    Left = 0
    Top = 41
    Width = 922
    Height = 392
    ActivePage = tab1
    Align = alClient
    TabOrder = 1
    object tab1: TTabSheet
      Caption = 'Parse'
      object spl1: TSplitter
        Left = 497
        Top = 0
        Height = 364
      end
      object lst1: TListBox
        Left = 0
        Top = 0
        Width = 497
        Height = 364
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        Items.Strings = (
          'IDR_MENU1 MENU DISCARDABLE '
          'BEGIN'
          '    POPUP "file"'
          '    BEGIN'
          '        MENUITEM "New",                         ID_FILE_NEW1'
          '        MENUITEM "&Open (O)",                   ID_FILE_OPEN1'
          '        MENUITEM "Close",                       ID_CLOSE'
          '        MENUITEM "Thumbnails (T)",              ID_THUM'
          '        MENUITEM "Open PCS file",               ID_OPNPCD'
          '        MENUITEM "PES2Card (W+Cntrl)",          ID_PES2CRD'
          '        MENUITEM "Insert",                      ID_INSFIL'
          '        MENUITEM "Overlay",                     ID_OVRLAY'
          '        MENUITEM "Save (^S, F7)",               ID_FILE_SAVE2'
          '        MENUITEM "Save As (F8)",                ID_FILE_SAVE3'
          '        MENUITEM "Load Bitmap",                 ID_LODBIT'
          '        MENUITEM "Save Bitmap",                 ID_SAVMAP'
          
            '        MENUITEM "Hide Bitmap (Shift+X)",       ID_HIDBITF, CHEC' +
            'KED'
          '        MENUITEM "Remove Bitmap",               ID_DELMAP'
          '        POPUP "Delete Backups"'
          '        BEGIN'
          '            MENUITEM "Backups for the selected file", ID_PURG'
          
            '            MENUITEM "All backups in the selected directory", ID' +
            '_PURGDIR'
          '        END'
          '        MENUITEM "Locking",                     ID_FLOK'
          '    END'
          '    POPUP "view"'
          '    BEGIN'
          '        MENUITEM "Movie (I)",                   ID_RUNPAT'
          '        POPUP "Set"'
          '        BEGIN'
          '            MENUITEM "Applique Color",              ID_SETAP'
          
            '            MENUITEM "Background Color",            ID_VIEW_STCH' +
            'BAK'
          '            MENUITEM "Bit Map Color",               ID_BITCOL'
          '            MENUITEM "Clipboard Fill  Spacing",     ID_CLPSPAC'
          '            POPUP "Data Check"'
          '            BEGIN'
          
            '                MENUITEM "Off",                         ID_CHKOF' +
            ', CHECKED'
          
            '                MENUITEM "On",                          ID_CHKON' +
            ', CHECKED'
          
            '                MENUITEM "Auto Repair",                 ID_CHKRE' +
            'P, CHECKED'
          
            '                MENUITEM "Auto Repair with Message",    ID_CHKRE' +
            'PMSG, CHECKED'
          
            '                MENUITEM "",                            ID_VIEW_' +
            'SET_DATACHECK'
          ''
          '            END'
          '            MENUITEM "Default Preferences",         ID_SETPREF'
          '            POPUP "Fill at Select"'
          '            BEGIN'
          
            '                MENUITEM "On",                          ID_FIL2S' +
            'EL_ON'
          
            '                MENUITEM "Off",                         ID_FIL2S' +
            'EL_OFF'
          '            END'
          '            POPUP "Form Cursor"'
          '            BEGIN'
          
            '                MENUITEM "Box",                         ID_FRMBO' +
            'X'
          '                MENUITEM "Cross",                       ID_FRMX'
          '            END'
          '            POPUP "Grid Mask"'
          '            BEGIN'
          '                MENUITEM "High",                        ID_GRDHI'
          
            '                MENUITEM "Medium",                      ID_GRDME' +
            'D'
          '                MENUITEM "Default",                     ID_GRDEF'
          
            '                MENUITEM "UnRed",                       ID_GRDRE' +
            'D'
          
            '                MENUITEM "UnBlue",                      ID_GRDBL' +
            'U'
          
            '                MENUITEM "UnGreen",                     ID_GRDGR' +
            'N'
          '            END'
          '            POPUP "Line Border Spacing"'
          '            BEGIN'
          
            '                MENUITEM "Exact",                       ID_LINBE' +
            'XACT'
          
            '                MENUITEM "Even",                        ID_LINBE' +
            'VEN'
          '            END'
          '            POPUP "Machine File Type"'
          '            BEGIN'
          
            '                MENUITEM "Pfaff PCS ",                  ID_AUXPC' +
            'S'
          
            '                MENUITEM "Tajima DST",                  ID_AUXDS' +
            'T'
          '            END'
          '            POPUP "Needle Cursor"'
          '            BEGIN'
          
            '                MENUITEM "On",                          ID_SETNE' +
            'DL'
          
            '                MENUITEM "Off",                         ID_RSTNE' +
            'DL'
          '            END'
          '            MENUITEM "Nudge Pixels",                ID_NUDGPIX'
          '            POPUP "PCS Bitmap Save"'
          '            BEGIN'
          
            '                MENUITEM "On",                          ID_BSAVO' +
            'N'
          
            '                MENUITEM "Off",                         ID_BSAVO' +
            'F'
          '            END'
          '            POPUP "Point Size"'
          '            BEGIN'
          
            '                MENUITEM "Stitch Point Boxes",          ID_STCHP' +
            'IX'
          
            '                MENUITEM "Form Point Triangles",        ID_FRMPI' +
            'X'
          
            '                MENUITEM "Form Box",                    ID_FRMPB' +
            'OX'
          '            END'
          '            POPUP "Remove Mark"'
          '            BEGIN'
          
            '                MENUITEM "Escape",                      ID_MARKE' +
            'SC, CHECKED'
          
            '                MENUITEM "Q",                           ID_MARKQ' +
            ', CHECKED'
          '            END'
          '            POPUP "Rotate Machine File"'
          '            BEGIN'
          
            '                MENUITEM "On",                          ID_ROTAU' +
            'XON'
          
            '                MENUITEM "Off",                         ID_ROTAU' +
            'XOFF'
          '            END'
          '            POPUP "Underlay"'
          '            BEGIN'
          '                MENUITEM "Angle",                       ID_UANG'
          '                MENUITEM "Indent",                      ID_WIND'
          '                MENUITEM "Spacing",                     ID_USPAC'
          '                MENUITEM "Stitch Length",               ID_USTCH'
          '            END'
          
            '            MENUITEM "Warn if edited",              ID_WARNOF, C' +
            'HECKED'
          '        END'
          '        MENUITEM "Backups",                     ID_VUBAK'
          '        MENUITEM "Zoom Full (X)",               VU_ZUMFUL'
          '        POPUP "Thread Size"'
          '        BEGIN'
          '            MENUITEM "30",                          ID_SIZ30'
          '            MENUITEM "40",                          ID_SIZ40'
          '            MENUITEM "60",                          ID_SIZ60'
          '            MENUITEM "Set Defaults",                ID_TSIZDEF'
          '        END'
          '        MENUITEM "Show Threads (F6)",           ID_VUTHRDS'
          '        MENUITEM "Show Threds for Selected Color", ID_VUSELTHRDS'
          '        MENUITEM "Design Information ('#39')",      ID_DESIZ'
          '        POPUP "Knots"'
          '        BEGIN'
          '            MENUITEM "On",                          ID_KNOTON'
          '            MENUITEM "Off",                         ID_KNOTOF'
          '        END'
          '        MENUITEM "Retrive Mark (B+Shift)",      ID_BAKMRK'
          '        MENUITEM "About Thred",                 ID_ABOUT'
          '    END'
          '    MENUITEM "form",                        ID_FORM'
          '    POPUP "edit"'
          '    BEGIN'
          '        POPUP "Center"'
          '        BEGIN'
          '            MENUITEM "Horizontal (- +Shift)",       ID_CNTRH'
          '            MENUITEM "Vertical (- +Control)",       ID_CNTRV'
          '            MENUITEM "Both (-)",                    ID_CNTRX'
          '            MENUITEM "Entire Design",               ID_CENTIRE'
          '            MENUITEM "Forms (L)",                   ID_CNTR'
          '        END'
          '        MENUITEM "Check Range",                 ID_CHK'
          '        POPUP "Convert"'
          '        BEGIN'
          '            MENUITEM "to Feather Ribbon (F+shift)", ID_2FTHR'
          '            MENUITEM "to Satin Ribbon (C+shift)",   ID_RIBON'
          '            MENUITEM "to Bean",                     ID_DUBEAN'
          '            MENUITEM "from Bean to Line",           ID_UNBEAN'
          '            MENUITEM "Stitches to Form",            ID_STCHS2FRM'
          '        END'
          '        POPUP "Copy to Layer"'
          '        BEGIN'
          '            MENUITEM "0",                           ID_LAYCPY0'
          '            MENUITEM "1",                           ID_LAYCPY1'
          '            MENUITEM "2",                           ID_LAYCPY2'
          '            MENUITEM "3",                           ID_LAYCPY3'
          '            MENUITEM "4",                           ID_LAYCPY4'
          '        END'
          '        MENUITEM "Crop to Form (W+Shift)",      ID_CROP'
          '        POPUP "Delete"'
          '        BEGIN'
          '            MENUITEM "All Forms",                   ID_DELFRMS'
          
            '            MENUITEM "All Forms and Stitches (Delete+Cntrl+Shift' +
            ')", '
          '                                                    ID_DELTOT'
          '            MENUITEM "All Stitches (L+shift)",      ID_DELSTCH'
          '            MENUITEM "Free Stitches",               ID_DELFRE'
          '            MENUITEM "Knots",                       ID_DELKNOT'
          '            MENUITEM "Large Stitches (F11+shift)",  ID_REMBIG'
          '            MENUITEM "Select (delete)",             ID_DELETE'
          '            MENUITEM "Small Stitches (F11)",        ID_REMZERO'
          '        END'
          '        POPUP "Flip"'
          '        BEGIN'
          '            MENUITEM "Horizontal",                  ID_FLIPH'
          '            MENUITEM "Vertical",                    ID_FLIPV'
          '            MENUITEM "Order",                       ID_FLPORD'
          '        END'
          '        POPUP "&Form Update"'
          '        BEGIN'
          '            POPUP "&Border"'
          '            BEGIN'
          
            '                MENUITEM "&Color",                      ID_SETBC' +
            'OL'
          
            '                MENUITEM "&Maximum Stitch Length",      ID_MAXBL' +
            'EN'
          
            '                MENUITEM "m&Inimum Stitch Length",      ID_MINBL' +
            'EN'
          
            '                MENUITEM "&Stitch Length",              ID_SETBL' +
            'EN'
          
            '                MENUITEM "s&Pacing",                    ID_SETBS' +
            'PAC'
          '            END'
          '            POPUP "&Center Walk"'
          '            BEGIN'
          
            '                MENUITEM "&On",                         ID_SETCW' +
            'LK'
          
            '                MENUITEM "o&Ff",                        ID_NOTCW' +
            'LK'
          '            END'
          '            POPUP "&Edge Walk"'
          '            BEGIN'
          
            '                MENUITEM "&On",                         ID_SETWL' +
            'K'
          
            '                MENUITEM "o&Ff",                        ID_NOTWL' +
            'K'
          '            END'
          '            POPUP "&Fill"'
          '            BEGIN'
          
            '                MENUITEM "&Ang",                        ID_SETFA' +
            'NG'
          
            '                MENUITEM "&Color",                      ID_SETFC' +
            'OL'
          
            '                MENUITEM "&Maximum Stitch Length",      ID_MAXFL' +
            'EN'
          
            '                MENUITEM "m&Inimum Stitch Length",      ID_MINFL' +
            'EN'
          
            '                MENUITEM "&Stitch Length",              ID_SETFL' +
            'EN'
          
            '                MENUITEM "s&Pacing",                    ID_SETFS' +
            'PAC'
          '            END'
          '            MENUITEM "&Height",                     ID_FRMHI'
          '            MENUITEM "&Indent",                     ID_FRMIND'
          '            POPUP "&Underlay"'
          '            BEGIN'
          
            '                MENUITEM "&On",                         ID_SETUN' +
            'D'
          
            '                MENUITEM "o&Ff",                        ID_NOTUN' +
            'D'
          
            '                MENUITEM "&Angle",                      ID_SETUA' +
            'NG'
          
            '                MENUITEM "&Color",                      ID_SETUC' +
            'OL'
          
            '                MENUITEM "&Spacing",                    ID_SETUS' +
            'PAC'
          '            END'
          '            MENUITEM "under &Stitch length",        ID_UNDLEN'
          '            MENUITEM "&Width",                      ID_FRMWID'
          '        END'
          '        POPUP "Move"'
          '        BEGIN'
          '            MENUITEM "to Start",                    ID_MV2FRNT'
          '            MENUITEM "to Mark (;)",                 ID_MOVMRK'
          '            MENUITEM "to End",                      ID_MV2BAK'
          '        END'
          '        POPUP "Move to Layer"'
          '        BEGIN'
          '            MENUITEM "0",                           ID_LAYMOV0'
          '            MENUITEM "1",                           ID_LAYMOV1'
          '            MENUITEM "2",                           ID_LAYMOV2'
          '            MENUITEM "3",                           ID_LAYMOV3'
          '            MENUITEM "4",                           ID_LAYMOV4'
          '        END'
          '        MENUITEM "Refill All (J)",              ID_REFILAL'
          '        MENUITEM "Repair Data",                 ID_REPAIR'
          
            '        MENUITEM "Reset Colors",                ID_EDIT_RESET_CO' +
            'L'
          '        MENUITEM "Retrace",                     ID_RETRACE'
          '        MENUITEM "Retreive Clipboard Stitches (F4)", ID_RTRVCLP'
          '        POPUP "Rotate"'
          '        BEGIN'
          '            MENUITEM "Again",                       ID_ROTAGAIN'
          '            MENUITEM "and Duplicate",               ID_ROTDUP'
          '            MENUITEM "and Duplicate  Again",        ID_DUPAGAIN'
          '            MENUITEM "Command",                     ID_ROTCMD'
          '        END'
          '        POPUP "Select"'
          '        BEGIN'
          '            MENUITEM "All Forms",                   ID_ALFRM'
          
            '            MENUITEM "All Forms and Stitches (A+Shift)", ID_SELA' +
            'L'
          '            MENUITEM "All Stitches A+Cntrl",        ID_SELALSTCH'
          
            '            MENUITEM "Color",                       ID_EDIT_SELE' +
            'CTCOLOR'
          '            MENUITEM "Form Applique Stitches",      ID_SELAP'
          '            MENUITEM "Form Border Stitches",        ID_SELBRD'
          '            MENUITEM "Form Edge Walk Stitches",     ID_SELWLK'
          '            MENUITEM "Form Fill Stitches",          ID_SELFIL'
          '            MENUITEM "Form Stitches",               ID_SELFSTCHS'
          '            MENUITEM "Form Underlay Stitches",      ID_SELUND'
          '        END'
          '        POPUP "Set"'
          '        BEGIN'
          '            MENUITEM "Designer Name",               ID_DESNAM'
          '            MENUITEM "Design Size",                 ID_SETSIZ'
          '            MENUITEM "Feather Defaults",            ID_FTHDEF'
          '            MENUITEM "Fill Start Point (<)",        ID_FILSTRT'
          '            MENUITEM "Fill End Point (>)",          ID_FILEND'
          '            MENUITEM "Form Number (/)",             ID_FRMNUM'
          '            MENUITEM "Form Color to  Stich Color",  ID_FRM2COL'
          '            MENUITEM "Form Zero Point",             ID_FRM0'
          '            MENUITEM "Knots",                       ID_KNOTS'
          
            '            MENUITEM "Knot at Selected Stitch (K+Cntrl)", ID_KNO' +
            'TAT'
          '            MENUITEM "Order Mark (.)",              ID_SETMRK'
          
            '            MENUITEM "Range Ends for Clip Board Fills", ID_CLPAD' +
            'J'
          '            POPUP "Rotation"'
          '            BEGIN'
          
            '                MENUITEM "Angle (R+Cntrl)",             ID_SETRO' +
            'T'
          
            '                MENUITEM "Angle from Mark (R+Shift)",   ID_ROTMR' +
            'K'
          
            '                MENUITEM "Segments (R)",                ID_ROTSE' +
            'G'
          '            END'
          '            MENUITEM "Selected",                    65535'
          '            MENUITEM "Zoom Mark at Center (M+Shift)", ID_MRKCNTR'
          
            '            MENUITEM "Zoom Mark at Selected Point (M+Cntrl)", ID' +
            '_MRKPNT'
          '        END'
          '        MENUITEM "Shrink Clipboard Border",     ID_SHRINK'
          '        POPUP "Snap"'
          '        BEGIN'
          '            MENUITEM "Together [F2]",               ID_SNAP2'
          '            MENUITEM "to Grid [S+shift]",           ID_SNAP2GRD'
          '        END'
          '        POPUP "Sort"'
          '        BEGIN'
          '            MENUITEM "Auto (F3)",                   ID_SORT'
          '            MENUITEM "by Color then Form (F3+Shift)", ID_SRTBF'
          '            MENUITEM "by Form (F3+Cntrl)",          ID_SRTF'
          '        END'
          '        MENUITEM "Split Form",                  ID_SPLTFRM'
          '        POPUP "Trace"'
          '        BEGIN'
          '            MENUITEM "Find Edges (U+control)",      ID_TRDIF'
          
            '            MENUITEM "Hide Bitmap (X+shift)",       ID_HIDBIT, C' +
            'HECKED'
          '            MENUITEM "Reset Form Pixels (H)",       ID_BLAK'
          '            MENUITEM "Select Colors (H+control)",   ID_TRCSEL'
          '            MENUITEM "Trace Mode (T+Control)",      ID_TRACE'
          
            '            MENUITEM "Show Traced Edges (right or left click)", ' +
            'ID_TRACEDG'
          '        END'
          '        POPUP "Ungroup"'
          '        BEGIN'
          '            MENUITEM "First{[)",                    ID_UNGRPLO'
          '            MENUITEM "Last (])",                    ID_UNGRPHI'
          '        END'
          '    END'
          '    MENUITEM "in",                          ZUMIN'
          '    MENUITEM "out",                         ID_ZUMOUT'
          '    MENUITEM "undo",                        ID_BACK, GRAYED'
          '    MENUITEM "redo",                        ID_REDO, GRAYED'
          '    MENUITEM "rot",                         ID_ROT'
          '    MENUITEM "pref",                        ID_PREF'
          '    POPUP "fill"'
          '    BEGIN'
          '        MENUITEM "Fan",                         ID_FILSAT'
          '        MENUITEM "Feather",                     ID_FETHR'
          '        MENUITEM "Vertical",                    ID_FILL_VERT'
          '        MENUITEM "Horizontal",                  ID_FILL_HOR'
          '        MENUITEM "Angle",                       ID_FILANG'
          '        POPUP "Clipboard"'
          '        BEGIN'
          '            MENUITEM "Fan",                         ID_CLPFIL'
          '            MENUITEM "Vertical",                    ID_VRTCLP'
          '            MENUITEM "Horizontal",                  ID_HORCLP'
          '            MENUITEM "Angle",                       ID_ANGCLP'
          '        END'
          '        MENUITEM "Contour",                     ID_CONTF'
          '        MENUITEM "Texture Editor",              ID_TXFIL'
          '        POPUP "Border"'
          '        BEGIN'
          '            MENUITEM "Line",                        ID_FILIN'
          '            MENUITEM "Bean",                        ID_BOLD'
          '            MENUITEM "Angle Satin",                 ID_SATBRD'
          '            MENUITEM "Perpendicular Satin",         ID_PERP'
          '            MENUITEM "Applique",                    ID_APLIQ'
          '            MENUITEM "BH",                          ID_FILBUT'
          '            MENUITEM "Clipboard",                   ID_FILCLP'
          '            MENUITEM "Clipboard, Even",             ID_FILCLPX'
          '            MENUITEM "Picot",                       ID_PICOT'
          '            MENUITEM "Double",                      ID_DUBFIL'
          '            MENUITEM "Line chain",                  ID_LINCHN'
          '            MENUITEM "Open chain",                  ID_OPNCHN'
          '        END'
          '        MENUITEM "Unfill",                      ID_UNFIL'
          '        MENUITEM "Refil (F5)",                  ID_REFILF'
          '    END'
          '    MENUITEM "add",                         ID_ADEND'
          '    MENUITEM "frm+",                        ID_FRMOF'
          '    MENUITEM "all",                         ID_LA'
          '    MENUITEM "1",                           ID_L1'
          '    MENUITEM "2",                           ID_L2'
          '    MENUITEM "3",                           ID_L3'
          '    MENUITEM "4",                           ID_L4'
          '    MENUITEM "help",                        ID_HLP'
          'END')
        ParentFont = False
        TabOrder = 0
      end
      object lst2: TListBox
        Left = 500
        Top = 0
        Width = 414
        Height = 364
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 1
      end
    end
    object tab2: TTabSheet
      Caption = '*.DFM'
      ImageIndex = 1
      object mmoDfm: TMemo
        Left = 0
        Top = 0
        Width = 914
        Height = 364
        Align = alClient
        Lines.Strings = (
          'mmoDfm')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tab3: TTabSheet
      Caption = 'Interface'
      ImageIndex = 2
      object mmoInterface: TMemo
        Left = 0
        Top = 0
        Width = 914
        Height = 364
        Align = alClient
        Lines.Strings = (
          'mmoDfm')
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tab4: TTabSheet
      Caption = 'tab4'
      ImageIndex = 3
    end
  end
  object mm1: TMainMenu
    Left = 136
    Top = 208
    object file1: TMenuItem
      Caption = 'file'
      object new1: TMenuItem
        Caption = 'new'
      end
      object open1: TMenuItem
        Caption = 'open'
      end
      object save1: TMenuItem
        Caption = 'save'
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
  end
end
