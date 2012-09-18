unit gmIntercept_GR32_Image;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ImgList, ActiveX, StdCtrls, Menus, Printers,
  CommCtrl,  // image lists, common controls tree structures

  GR32, GR32_Image;


const

  // Instead using a TTimer class for each of the various events I use Windows timers with messages
  // as this is more economical.
  ExpandTimer = 1;
  EditTimer = 2;
  HeaderTimer = 3;
  ScrollTimer = 4;
  ChangeTimer = 5;
  StructureChangeTimer = 6;
  SearchTimer = 7;


type

  // Various events must be handled at different places than they were initiated or need
  // a persistent storage until they are reset.
  TVirtualTreeStates = set of (
    tsCancelHintAnimation,    // Set when a new hint is about to show but an old hint is still being animated.
    tsChangePending,          // A selection change is pending.
    tsCheckPropagation,       // Set during automatic check state propagation.
    tsCollapsing,             // A full collapse operation is in progress.
    tsToggleFocusedSelection, // Node selection was modifed using Ctrl-click. Change selection state on next mouse up.
    tsClearPending,           // Need to clear the current selection on next mouse move.
    tsClipboardFlushing,      // Set during flushing the clipboard to avoid freeing the content.
    tsCopyPending,            // Indicates a pending copy operation which needs to be finished.
    tsCutPending,             // Indicates a pending cut operation which needs to be finished.
    tsDrawSelPending,         // Multiselection only. User held down the left mouse button on a free
                              // area and might want to start draw selection.
    tsDrawSelecting,          // Multiselection only. Draw selection has actually started.
    tsEditing,                // Indicates that an edit operation is currently in progress.
    tsEditPending,            // An mouse up start edit if dragging has not started.
    tsExpanding,              // A full expand operation is in progress.
    tsHint,                   // Set when our hint is visible or soon will be.
    tsInAnimation,            // Set if the tree is currently in an animation loop.
    tsIncrementalSearching,   // Set when the user starts incremental search.
    tsIncrementalSearchPending, // Set in WM_KEYDOWN to tell to use the char in WM_CHAR for incremental search.
    tsIterating,              // Set when IterateSubtree is currently in progress.
    tsKeyCheckPending,        // A check operation is under way, initiated by a key press (space key). Ignore mouse.
    tsLeftButtonDown,         // Set when the left mouse button is down.
    tsMouseCheckPending,      // A check operation is under way, initiated by a mouse click. Ignore space key.
    tsMiddleButtonDown,       // Set when the middle mouse button is down.
    tsNeedScale,              // On next ChangeScale scale the default node height.
    tsNeedRootCountUpdate,    // Set if while loading a root node count is set.
    tsOLEDragging,            // OLE dragging in progress.
    tsOLEDragPending,         // User has requested to start delayed dragging.
    tsPainting,               // The tree is currently painting itself.
    tsRightButtonDown,        // Set when the right mouse button is down.
    tsPopupMenuShown,         // The user clicked the right mouse button, which might cause a popup menu to appear.
    tsScrolling,              // Set when autoscrolling is active.
    tsScrollPending,          // Set when waiting for the scroll delay time to elapse.
    tsSizing,                 // Set when the tree window is being resized. This is used to prevent recursive calls
                              // due to setting the scrollbars when sizing.
    tsStopValidation,         // Cache validation can be stopped (usually because a change has occured meanwhile).
    tsStructureChangePending, // The structure of the tree has been changed while the update was locked.
    tsSynchMode,              // Set when the tree is in synch mode, where no timer events are triggered.
    tsThumbTracking,          // Stop updating the horizontal scroll bar while dragging the vertical thumb and vice versa.
    tsUpdateHiddenChildrenNeeded, // Pending update for the hidden children flag after massive visibility changes.
    tsUpdating,               // The tree does currently not update its window because a BeginUpdate has not yet ended.
    tsUseCache,               // The tree's node caches are validated and non-empty.
    tsUserDragObject,         // Signals that the application created an own drag object in OnStartDrag.
    tsUseThemes,              // The tree runs under WinXP+, is theme aware and themes are enabled.
    tsValidating,             // The tree's node caches are currently validated.
    tsValidationNeeded,       // Something in the structure of the tree has changed. The cache needs validation.
    tsVCLDragging,            // VCL drag'n drop in progress.
    tsVCLDragPending,         // One-shot flag to avoid clearing the current selection on implicit mouse up for VCL drag.
    tsWheelPanning,           // Wheel mouse panning is active or soon will be.
    tsWheelScrolling,         // Wheel mouse scrolling is active or soon will be.
    tsWindowCreating          // Set during window handle creation to avoid frequent unnecessary updates.
  );

  TChangeStates = set of (
    csStopValidation,         // Cache validation can be stopped (usually because a change has occured meanwhile).
    csUseCache,               // The tree's node caches are validated and non-empty.
    csValidating,             // The tree's node caches are currently validated.
    csValidationNeeded        // Something in the structure of the tree has changed. The cache needs validation.
  );

  // These flags are returned by the hit test method.
  THitPosition = (
    hiAbove,          // above the client area (if relative) or the absolute tree area
    hiBelow,          // below the client area (if relative) or the absolute tree area
    hiNowhere,        // no node is involved (possible only if the tree is not as tall as the client area)
    hiOnItem,         // on the bitmaps/buttons or label associated with an item
    hiOnItemButton,   // on the button associated with an item
    hiOnItemCheckbox, // on the checkbox if enabled
    hiOnItemIndent,   // in the indentation area in front of a node
    hiOnItemLabel,    // on the normal text area associated with an item
    hiOnItemLeft,     // in the area to the left of a node's text area (e.g. when right aligned or centered)
    hiOnItemRight,    // in the area to the right of a node's text area (e.g. if left aligned or centered)
    hiOnNormalIcon,   // on the "normal" image
    hiOnStateIcon,    // on the state image
    hiToLeft,         // to the left of the client area (if relative) or the absolute tree area
    hiToRight         // to the right of the client area (if relative) or the absolute tree area
  );
  THitPositions = set of THitPosition;
    
  // structure used when info about a certain position in the tree is needed
  THitInfo = record
    //HitNode: PVirtualNode;
    HitPositions: THitPositions;
    //HitColumn: TColumnIndex;
  end;

  // Options which do not fit into any of the other groups:
  {TVTMiscOption = (
    toAcceptOLEDrop,           // Register tree as OLE accepting drop target
    toCheckSupport,            // Show checkboxes/radio buttons.
    toEditable,                // Node captions can be edited.
    toFullRepaintOnResize,     // Fully invalidate the tree when its window is resized (CS_HREDRAW/CS_VREDRAW).
    toGridExtensions,          // Use some special enhancements to simulate and support grid behavior.
    toInitOnSave,              // Initialize nodes when saving a tree to a stream.
    toReportMode,              // Tree behaves like TListView in report mode.
    toToggleOnDblClick,        // Toggle node expansion state when it is double clicked.
    toWheelPanning,            // Support for mouse panning (wheel mice only). This option and toMiddleClickSelect are
                               // mutal exclusive, where panning has precedence.
    toReadOnly,                // The tree does not allow to be modified in any way. No action is executed and
                               // node editing is not possible.
    toVariableNodeHeight,      // When set then GetNodeHeight will trigger OnMeasureItem to allow variable node heights.
    toFullRowDrag              // Start node dragging by clicking anywhere in it instead only on the caption or image.
                               // Must be used together with toDisableDrawSelection.
  );
  //TVTMiscOptions = set of TVTMiscOption;
  }

  // auto scroll directions
  TScrollDirections = set of (
    sdLeft,
    sdUp,
    sdRight,
    sdDown
  );

  // Limits the speed interval which can be used for auto scrolling (milliseconds).
  TAutoScrollInterval = 1..1000;
  
  TImgView32 = class(GR32_Image.TImgView32)
  private
    FAutoScrollDelay: Cardinal;                  // amount of milliseconds to wait until autoscrolling becomes active
    FAutoScrollInterval: TAutoScrollInterval;    // determines speed of auto scrolling
  
    FPanningWindow: HWND;                        // Helper window for wheel panning
    FPanningCursor: HCURSOR;                     // Current wheel panning cursor.
    FPanningImage: TBitmap;                      // A little 32x32 bitmap to indicate the panning reference point.
    FLastClickPos: TPoint;                       // Used for retained drag start and wheel mouse scrolling.

    //FRangeX,
    //FRangeY: Cardinal;                           // current virtual width and height of the tree

    FScrollDirections: TScrollDirections;        // directions to scroll client area into depending on mouse position
    FScrollBarOptionsFIncrement : TPoint; //simulation of FScrollBarOptions.FIncrement

    FStates: TVirtualTreeStates;                 // various active/pending states the tree needs to consider

    procedure StopTimer(ID: Integer);
    procedure CMMouseWheel(var Message: TCMMouseWheel); message CM_MOUSEWHEEL;

    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    
  protected
    procedure AdjustPanningCursor(X, Y: Integer); virtual;
  
    function CanAutoScroll: Boolean; virtual;
    function DetermineScrollDirections(X, Y: Integer): TScrollDirections; virtual;
    procedure DoAutoScroll(X, Y: Integer); virtual;
    procedure DoStateChange(Enter: TVirtualTreeStates; Leave: TVirtualTreeStates = []);
    procedure DoTimerScroll; virtual;

    procedure StartWheelPanning(Position: TPoint); virtual;
    procedure StopWheelPanning; virtual;
    procedure PanningWindowProc(var Message: TMessage); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

  public
    constructor Create(AOwner: TComponent); override;
  published 

  end;


implementation

uses
  Math;

{ TImgView32 }


//----------------------------------------------------------------------------------------------------------------------

var
  PanningWindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'VTPanningWindow'
  );
  
procedure TImgView32.AdjustPanningCursor(X, Y: Integer);
// Triggered by a mouse move when wheel panning/scrolling is active.
// Loads the proper cursor which indicates into which direction scrolling is done.

var
  Name: string;
  NewCursor: HCURSOR;
  ScrollHorizontal,
  ScrollVertical: Boolean;

begin
  ScrollHorizontal := HScroll.Range > ClientWidth;
  ScrollVertical := VScroll.Range > ClientHeight;

  if (Abs(X - FLastClickPos.X) < 8) and (Abs(Y - FLastClickPos.Y) < 8) then
  begin
    // Mouse is in the neutral zone.
    if ScrollHorizontal then
    begin
      if ScrollVertical then
        Name := 'VT_MOVEALL'
      else
        Name := 'VT_MOVEEW'
    end
    else
      Name := 'VT_MOVENS';
  end
  else
  begin
    // One of 8 directions applies: north, north-east, east, south-east, south, south-west, west and north-west.
    // Check also if scrolling in the particular direction is possible.
    if ScrollVertical and ScrollHorizontal then
    begin
      // All directions allowed.
      if X - FlastClickPos.X < -8 then
      begin
        // Left hand side.
        if Y - FLastClickPos.Y < -8 then
          Name := 'VT_MOVENW'
        else
          if Y - FLastClickPos.Y > 8 then
            Name := 'VT_MOVESW'
          else
            Name := 'VT_MOVEW';
      end
      else
        if X - FLastClickPos.X > 8 then
        begin
          // Right hand side.
          if Y - FLastClickPos.Y < -8 then
            Name := 'VT_MOVENE'
          else
            if Y - FLastClickPos.Y > 8 then
              Name := 'VT_MOVESE'
            else
              Name := 'VT_MOVEE';
        end
        else
        begin
          // Up or down.
          if Y < FLastClickPos.Y then
            Name := 'VT_MOVEN'
          else
            Name := 'VT_MOVES';
        end;
    end
    else
      if ScrollHorizontal then
      begin
        // Only horizontal movement allowed.
        if X < FlastClickPos.X then
          Name := 'VT_MOVEW'
        else
          Name := 'VT_MOVEE';
      end
      else
      begin
        // Only vertical movement allowed.
        if Y < FlastClickPos.Y then
          Name := 'VT_MOVEN'
        else
          Name := 'VT_MOVES';
      end;
  end;

  // Now load the cursor and apply it.
  NewCursor := LoadCursor(HInstance, PChar(Name));
  if FPanningCursor <> NewCursor then
  begin
    DeleteObject(FPanningCursor);
    FPanningCursor := NewCursor;
    Windows.SetCursor(FPanningCursor);
  end
  else
    DeleteObject(NewCursor);

end;

function TImgView32.CanAutoScroll: Boolean;
// Determines if auto scrolling is currently allowed.

{var
  IsDropTarget: Boolean;
  IsDrawSelecting: Boolean;
  IsWheelPanning: Boolean;}

begin
  // Don't scroll the client area if the header is currently doing tracking or dragging.
  // Do auto scroll only if there is a draw selection in progress or the tree is the current drop target or
  // wheel panning/scrolling is active.
  {IsDropTarget := Assigned(FDragManager) and DragManager.IsDropTarget;
  IsDrawSelecting := [tsDrawSelPending, tsDrawSelecting] * FStates <> [];
  IsWheelPanning := [tsWheelPanning, tsWheelScrolling] * FStates <> [];
  Result := ((toAutoScroll in FOptions.FAutoOptions) or IsWheelPanning) and
    (FHeader.FStates = []) and (IsDrawSelecting or IsDropTarget or (tsVCLDragging in FStates) or IsWheelPanning);
}
  Result := [tsWheelPanning, tsWheelScrolling] * FStates <> [];
end;

procedure TImgView32.CMMouseWheel(var Message: TCMMouseWheel);
var
  ScrollCount: Integer;
  ScrollLines: DWORD;

begin
  StopWheelPanning;
  
  inherited;



  if Message.Result = 0  then
  begin
    with Message do
    begin
      Result := 1;
      if VScroll.Range > Cardinal(ClientHeight) then
      begin
        // Scroll vertically if there's something to scroll...
        if ssCtrl in ShiftState then
          ScrollCount := WheelDelta div WHEEL_DELTA * (ClientHeight div FScrollBarOptionsFIncrement.X)
        else
        begin
          SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @ScrollLines, 0);
          if ScrollLines = WHEEL_PAGESCROLL then
            ScrollCount := WheelDelta div WHEEL_DELTA * (ClientHeight div FScrollBarOptionsFIncrement.X)
          else
            ScrollCount := Integer(ScrollLines) * WheelDelta div WHEEL_DELTA;
        end;
        //SetOffsetY(FOffsetY + ScrollCount * FScrollBarOptionsFIncrement.X);
        Scroll(0, -ScrollCount * FScrollBarOptionsFIncrement.Y );
      end
      else
      begin
        // ...else scroll horizontally.
        if ssCtrl in ShiftState then
          ScrollCount := WheelDelta div WHEEL_DELTA * ClientWidth
        else
          ScrollCount := WheelDelta div WHEEL_DELTA;
        //SetOffsetX(FOffsetX + ScrollCount * Integer(FIndent));
        Scroll(-ScrollCount * FScrollBarOptionsFIncrement.X, 0 );
      end;
    end;
  end;

end;

constructor TImgView32.Create(AOwner: TComponent);
begin
  inherited;
  FAutoScrollDelay := 1000;
  FAutoScrollInterval := 1;
  FScrollBarOptionsFIncrement := Point(20,20);

end;

function TImgView32.DetermineScrollDirections(X,
  Y: Integer): TScrollDirections;
// Determines which direction the client area must be scrolled depending on the given position.

begin
  Result:= [];

  if CanAutoScroll then
  begin
    // Calculation for wheel panning/scrolling is a bit different to normal auto scroll.
    if [tsWheelPanning, tsWheelScrolling] * FStates <> [] then
    begin
      if (X - FLastClickPos.X) < -8 then
        Include(Result, sdLeft);
      if (X - FLastClickPos.X) > 8 then
        Include(Result, sdRight);

      if (Y - FLastClickPos.Y) < -8 then
        Include(Result, sdUp);
      if (Y - FLastClickPos.Y) > 8 then
        Include(Result, sdDown);
    end
    {else
    begin
      if (X < Integer(FDefaultNodeHeight)) and (FOffsetX <> 0) then
        Include(Result, sdLeft);
      if (ClientWidth - FOffsetX < Integer(FRangeX)) and (X > ClientWidth - Integer(FDefaultNodeHeight)) then
        Include(Result, sdRight);

      if (Y < Integer(FDefaultNodeHeight)) and (FOffsetY <> 0) then
        Include(Result, sdUp);
      if (ClientHeight - FOffsetY < Integer(FRangeY)) and (Y > ClientHeight - Integer(FDefaultNodeHeight)) then
        Include(Result, sdDown);

      // Since scrolling during dragging is not handled via the timer we do a check here whether the auto
      // scroll timeout already has elapsed or not.
      if (Result <> []) and
        ((Assigned(FDragManager) and DragManager.IsDropTarget) or
        (FindDragTarget(Point(X, Y), False) = Self)) then
      begin
        if FDragScrollStart = 0 then
          FDragScrollStart := timeGetTime;
        // Reset any scroll direction to avoid scroll in the case the user is dragging and the auto scroll time has not
        // yet elapsed.
        if ((timeGetTime - FDragScrollStart) < FAutoScrollDelay) then
          Result := [];
      end;
    end; }
  end;

end;

procedure TImgView32.DoAutoScroll(X, Y: Integer);
begin
  FScrollDirections := DetermineScrollDirections(X, Y);

  if FStates * [tsWheelPanning, tsWheelScrolling] = [] then
  begin
    if FScrollDirections = [] then
    begin
      if ((FStates * [tsScrollPending, tsScrolling]) <> []) then
      begin
        StopTimer(ScrollTimer);
        DoStateChange([], [tsScrollPending, tsScrolling]);
      end;
    end
    else
    begin
      // start auto scroll if not yet done
      if (FStates * [tsScrollPending, tsScrolling]) = [] then
      begin
        DoStateChange([tsScrollPending]);
        SetTimer(Handle, ScrollTimer, FAutoScrollDelay, nil);
      end;
    end;
  end;
end;

procedure TImgView32.DoStateChange(Enter, Leave: TVirtualTreeStates);
var
  ActualEnter,
  ActualLeave: TVirtualTreeStates;
  
begin
  {if Assigned(FOnStateChange) then
  begin
    ActualEnter := Enter - FStates;
    ActualLeave := FStates * Leave;
    if (ActualEnter + ActualLeave) <> [] then
      FOnStateChange(Self, Enter, Leave);
  end;}
  FStates := FStates + Enter - Leave;

end;

procedure TImgView32.DoTimerScroll;
var
  P,
  ClientP: TPoint;
  InRect,
  Panning: Boolean;
  R,
  ClipRect: TRect;
  DeltaX,
  DeltaY: Integer;

begin
  GetCursorPos(P);
  R := ClientRect;
  ClipRect := R;
  MapWindowPoints(Handle, 0, R, 2);
  InRect := PtInRect(R, P);
  ClientP := ScreenToClient(P);
  Panning := [tsWheelPanning, tsWheelScrolling] * FStates <> [];
  
  if {IsMouseSelecting or} InRect or Panning then
  begin
    DeltaX := 0;
    DeltaY := 0;
    if sdUp in FScrollDirections then
    begin
      if Panning then
        DeltaY := FLastClickPos.Y - ClientP.Y - 8
      else
        if InRect then
          DeltaY := Min(FScrollBarOptionsFIncrement.Y, ClientHeight)
        else
          DeltaY := Min(FScrollBarOptionsFIncrement.Y, ClientHeight) * Abs(R.Top - P.Y);
      //if FOffsetY = 0 then
      if self.OffsetVert = 0 then
        Exclude(FScrollDirections, sdUp);
    end;

    if sdDown in FScrollDirections then
    begin
      if Panning then
        DeltaY := FLastClickPos.Y - ClientP.Y + 8
      else
        if InRect then
          DeltaY := -Min(FScrollBarOptionsFIncrement.Y, ClientHeight)
        else
          DeltaY := -Min(FScrollBarOptionsFIncrement.Y, ClientHeight) * Abs(P.Y - R.Bottom);
      if (ClientHeight - self.OffsetVert) = VScroll.Range then
        Exclude(FScrollDirections, sdDown);
    end;

    if sdLeft in FScrollDirections then
    begin
      if Panning then
        DeltaX := FLastClickPos.X - ClientP.X - 8
      else
        if InRect then
          DeltaX := FScrollBarOptionsFIncrement.X
        else
          DeltaX := FScrollBarOptionsFIncrement.X * Abs(R.Left - P.X);
///x2nie      if FOffsetX = 0 then
        if OffsetHorz = 0 then
        Exclude(FScrollDirections, sdleft);
    end;

    if sdRight in FScrollDirections then
    begin
      if Panning then
        DeltaX := FLastClickPos.X - ClientP.X + 8
      else
        if InRect then
          DeltaX := -FScrollBarOptionsFIncrement.X
        else
          DeltaX := -FScrollBarOptionsFIncrement.X * Abs(P.X - R.Right);

      if (ClientWidth - OffsetHorz) = HScroll.Range then
        Exclude(FScrollDirections, sdRight);
    end;

    {if IsMouseSelecting then
    begin
      // In order to avoid scrolling the area which needs a repaint due to the changed selection rectangle
      // we limit the scroll area explicitely.
      OffsetRect(ClipRect, DeltaX, DeltaY);
      DoSetOffsetXY(Point(FOffsetX + DeltaX, FOffsetY + DeltaY), DefaultScrollUpdateFlags, @ClipRect);
      // When selecting with the mouse then either update only the parts of the window which have been uncovered
      // by the scroll operation if no change in the selection happend or invalidate and redraw the entire
      // client area otherwise (to avoid the time consuming task of determining the display rectangles of every
      // changed node).
      if CalculateSelectionRect(ClientP.X, ClientP.Y) and HandleDrawSelection(ClientP.X, ClientP.Y) then
        InvalidateRect(Handle, nil, False)
      else
      begin
        // The selection did not change so invalidate only the part of the window which really needs an update.
        // 1) Invalidate the parts uncovered by the scroll operation. Add another offset range, we have to
        //    scroll only one stripe but have to update two. 
        OffsetRect(ClipRect, DeltaX, DeltaY);
        SubtractRect(ClipRect, ClientRect, ClipRect);
        InvalidateRect(Handle, @ClipRect, False);

        // 2) Invalidate the selection rectangles.
        UnionRect(ClipRect, OrderRect(FNewSelRect), OrderRect(FLastSelRect));
        OffsetRect(ClipRect, FOffsetX, FOffsetY);
        InvalidateRect(Handle, @ClipRect, False);
      end;
    end
    else}
    begin
      // Scroll only if there is no drag'n drop in progress. Drag'n drop scrolling is handled in DragOver.
      if //((FDragManager = nil) or not DragManager.IsDropTarget) and
        ((DeltaX <> 0) or (DeltaY <> 0)) then
        //DoSetOffsetXY(Point(FOffsetX + DeltaX, FOffsetY + DeltaY), DefaultScrollUpdateFlags, nil);
        self.Scroll(-DeltaX, -DeltaY);
    end;
    //UpdateWindow(Handle);

    if (FScrollDirections = []) and ([tsWheelPanning, tsWheelScrolling] * FStates = []) then
    begin
      StopTimer(ScrollTimer);
      DoStateChange([], [tsScrollPending, tsScrolling]);
    end;
  end;

end;

procedure TImgView32.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  
begin
  // Remove current selection in case the user clicked somewhere in the window (but not a node)
  // and moved the mouse.
  {if tsDrawSelPending in FStates then
  begin
    if CalculateSelectionRect(X, Y) then
    begin
      InvalidateRect(Handle, @FNewSelRect, False);
      UpdateWindow(Handle);
      if (Abs(FNewSelRect.Right - FNewSelRect.Left) > Mouse.DragThreshold) or
         (Abs(FNewSelRect.Bottom - FNewSelRect.Top) > Mouse.DragThreshold) then
      begin
        if tsClearPending in FStates then
        begin
          DoStateChange([], [tsClearPending]);
          ClearSelection;
        end;
        DoStateChange([tsDrawSelecting], [tsDrawSelPending]);
        // reset to main column for multiselection
        FocusedColumn := FHeader.MainColumn;

        // The current rectangle may already include some node captions. Handle this.
        if HandleDrawSelection(X, Y) then
          InvalidateRect(Handle, nil, False);
      end;
    end;
  end
  else}
  begin
    // If both wheel panning and auto scrolling are pending then the user moved the mouse while holding down the
    // middle mouse button. This means panning is being used, hence remove the wheel scroll flag.
    if [tsWheelPanning, tsWheelScrolling] * FStates = [tsWheelPanning, tsWheelScrolling] then
    begin
      if ((Abs(FLastClickPos.X - X) >= Mouse.DragThreshold) or (Abs(FLastClickPos.Y - Y) >= Mouse.DragThreshold)) then
        DoStateChange([], [tsWheelScrolling]);
    end;

    // Really start dragging if the mouse has been moved more than the threshold.
    {if (tsOLEDragPending in FStates) and ((Abs(FLastClickPos.X - X) >= FDragThreshold) or
       (Abs(FLastClickPos.Y - Y) >= FDragThreshold)) then
      DoDragging(FLastClickPos)
    else}
    begin 
      if CanAutoScroll then
        DoAutoScroll(X, Y);
      if [tsWheelPanning, tsWheelScrolling] * FStates <> [] then
        AdjustPanningCursor(X, Y);
      //X2NIE
        inherited MouseMove(Shift, X, Y);
      {if not IsMouseSelecting then
      begin
        HandleHotTrack(X, Y);
        inherited MouseMove(Shift, X, Y);
      end
      else
      begin
        // Handle draw selection if required, but don't do the work twice if the
        // auto scrolling code already cares about the selection. 
        if not (tsScrolling in FStates) and CalculateSelectionRect(X, Y) then
        begin 
          // If something in the selection changed then invalidate the entire
          // tree instead trying to figure out the display rects of all changed nodes.
          if HandleDrawSelection(X, Y) then
            InvalidateRect(Handle, nil, False)
          else
          begin
            UnionRect(R, OrderRect(FNewSelRect), OrderRect(FLastSelRect));
            OffsetRect(R, FOffsetX, FOffsetY);
            InvalidateRect(Handle, @R, False);
          end;
          UpdateWindow(Handle);
        end;
      end;}
    end;
  end;

end;

procedure TImgView32.PanningWindowProc(var Message: TMessage);
var
  PS: TPaintStruct;
  Canvas: TCanvas;

begin
  if Message.Msg = WM_PAINT then
  begin
    BeginPaint(FPanningWindow, PS);
    Canvas := TCanvas.Create;
    Canvas.Handle := PS.hdc;
    try
      Canvas.Draw(0, 0, FPanningImage);
    finally
      Canvas.Handle := 0;
      Canvas.Free;
      EndPaint(FPanningWindow, PS);
    end;
    Message.Result := 0;
  end
  else
    with Message do
      Result := DefWindowProc(FPanningWindow, Msg, wParam, lParam);

end;

procedure TImgView32.StartWheelPanning(Position: TPoint);
// Called when wheel panning should start. A little helper window is created to indicate the reference position,
// which determines in which direction and how far wheel panning/scrolling will happen.

  //--------------- local function --------------------------------------------

  function CreateClipRegion: HRGN;

  // In order to avoid doing all the transparent drawing ourselves we use a
  // window region for the wheel window.
  // Since we only work on a very small image (32x32 pixels) this is acceptable.

  var
    Start, X, Y: Integer;
    Temp: HRGN;
    
  begin
    Assert(not FPanningImage.Empty, 'Invalid wheel panning image.');

    // Create an initial region on which we operate.
    Result := CreateRectRgn(0, 0, 0, 0);
    with FPanningImage, Canvas do
    begin
      for Y := 0 to Height - 1 do
      begin
        Start := -1;
        for X := 0 to Width - 1 do
        begin
          // Start a new span if we found a non-transparent pixel and no span is currently started.
          if (Start = -1) and (Pixels[X, Y] <> clFuchsia) then
            Start := X
          else
            if (Start > -1) and (Pixels[X, Y] = clFuchsia) then
            begin
              // A non-transparent span is finished. Add it to the result region.
              Temp := CreateRectRgn(Start, Y, X, Y + 1);
              CombineRgn(Result, Result, Temp, RGN_OR);
              DeleteObject(Temp);
              Start := -1;
            end;
        end;
        // If there is an open span then add this also to the result region.
        if Start > -1 then
        begin
          Temp := CreateRectRgn(Start, Y, Width, Y + 1);
          CombineRgn(Result, Result, Temp, RGN_OR);
          DeleteObject(Temp);
        end;
      end;
    end;
    // The resulting region is used as window region so we must not delete it.
    // Windows will own it after the assignment below.
  end;

  //--------------- end local function ----------------------------------------

var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
  ImageName: string;
  
begin
  // Set both panning and scrolling flag. One will be removed shortly depending on whether the middle mouse button is
  // released before the mouse is moved or vice versa. The first case is referred to as wheel scrolling while the
  // latter is called wheel panning.
  StopTimer(ScrollTimer);
  DoStateChange([tsWheelPanning, tsWheelScrolling]);

  // Register the helper window class.
  PanningWindowClass.hInstance := HInstance;
  ClassRegistered := GetClassInfo(HInstance, PanningWindowClass.lpszClassName, TempClass);
  if not ClassRegistered or (TempClass.lpfnWndProc <> @DefWindowProc) then
  begin
    if ClassRegistered then
      Windows.UnregisterClass(PanningWindowClass.lpszClassName, HInstance);
    Windows.RegisterClass(PanningWindowClass);
  end;
  // Create the helper window and show it at the given position without activating it.
  with ClientToScreen(Position) do
    FPanningWindow := CreateWindowEx(WS_EX_TOOLWINDOW, PanningWindowClass.lpszClassName, nil, WS_POPUP, X - 16, Y - 16,
      32, 32, Handle, 0, HInstance, nil);

  FPanningImage := TBitmap.Create;
  if HScroll.Range > ClientWidth then
  begin
    if VScroll.Range > ClientHeight then
      ImageName := 'VT_MOVEALL'
    else
      ImageName := 'VT_MOVEEW'
  end
  else
    ImageName := 'VT_MOVENS';
  FPanningImage.LoadFromResourceName(HInstance, ImageName);                
  SetWindowRgn(FPanningWindow, CreateClipRegion, False);

  {$ifdef COMPILER_6_UP}
    SetWindowLong(FPanningWindow, GWL_WNDPROC, Integer(Classes.MakeObjectInstance(PanningWindowProc)));
  {$else}
    SetWindowLong(FPanningWindow, GWL_WNDPROC, Integer(MakeObjectInstance(PanningWindowProc)));
  {$endif}
  ShowWindow(FPanningWindow, SW_SHOWNOACTIVATE);

  // Setup the panscroll timer and capture all mouse input.
  SetFocus;
  SetCapture(Handle);
  SetTimer(Handle, ScrollTimer, 20, nil);

end;

procedure TImgView32.StopTimer(ID: Integer);
begin
  if HandleAllocated then
    KillTimer(Handle, ID);
end;

procedure TImgView32.StopWheelPanning;
// Stops panning if currently active and destroys the helper window.

var
  Instance: Pointer;

begin
  if [tsWheelPanning, tsWheelScrolling] * FStates <> [] then
  begin
    // Release the mouse capture and stop the panscroll timer.
    StopTimer(ScrollTimer);
    ReleaseCapture;
    DoStateChange([], [tsWheelPanning, tsWheelScrolling]);

    // Destroy the helper window.
    Instance := Pointer(GetWindowLong(FPanningWindow, GWL_WNDPROC));
    DestroyWindow(FPanningWindow);
    if Instance <> @DefWindowProc then
      {$ifdef COMPILER_6_UP}
        Classes.FreeObjectInstance(Instance);
      {$else}
        FreeObjectInstance(Instance);
      {$endif}
    FPanningWindow := 0;
    FPanningImage.Free;
    FPanningImage := nil;
    DeleteObject(FPanningCursor);
    FPanningCursor := 0;
    Windows.SetCursor(Screen.Cursors[Cursor]);
  end;

end;

procedure TImgView32.WMMButtonDown(var Message: TWMMButtonDown);
var
  HitInfo: THitInfo;

begin
  DoStateChange([tsMiddleButtonDown]);

  ///if FHeader.FStates = [] then
  begin
    inherited;

    // Start wheel panning or scrolling if not already active, allowed and scrolling is useful at all.
    if {(toWheelPanning in FOptions.FMiscOptions) and} ([tsWheelScrolling, tsWheelPanning] * FStates = [])
      and ((Integer(HScroll.Range) > ClientWidth) or (Integer(VScroll.Range) > ClientHeight))
      then
    begin
      FLastClickPos := SmallPointToPoint(Message.Pos);
      StartWheelPanning(FLastClickPos);
    end
    else
    begin
      StopWheelPanning;

      // Get information about the hit.
      {if toMiddleClickSelect in FOptions.FSelectionOptions then
      begin
        GetHitTestInfoAt(Message.XPos, Message.YPos, True, HitInfo);
        HandleMouseDown(Message, HitInfo);
      end;}
    end;
  end;

end;

procedure TImgView32.WMMButtonUp(var Message: TWMMButtonUp);
var
  HitInfo: THitInfo;

begin
  DoStateChange([], [tsMiddleButtonDown]);

  // If wheel panning/scrolling is active and the mouse has not yet been moved then the user starts wheel auto scrolling.
  // Indicate this by removing the panning flag. Otherwise (the mouse has moved meanwhile) stop panning.
  if [tsWheelPanning, tsWheelScrolling] * FStates <> [] then
  begin
    if tsWheelScrolling in FStates then
      DoStateChange([], [tsWheelPanning])
    else
      StopWheelPanning;
  end
  else
    //if FHeader.FStates = [] then
    begin
      inherited;

      // get information about the hit
      {if toMiddleClickSelect in FOptions.FSelectionOptions then
      begin
        GetHitTestInfoAt(Message.XPos, Message.YPos, True, HitInfo);
        HandleMouseUp(Message, HitInfo);
      end;}
    end;

end;

procedure TImgView32.WMTimer(var Message: TWMTimer);

// centralized timer handling happens here

begin
  with Message do
  begin
    case TimerID of
      {ExpandTimer:
        DoDragExpand;
      EditTimer:
        DoEdit;}
      ScrollTimer:
        begin
          if tsScrollPending in FStates then
          begin  
            Application.CancelHint;
            // Scroll delay has elapsed, set to normal scroll interval now.
            SetTimer(Handle, ScrollTimer, FAutoScrollInterval, nil);
            DoStateChange([tsScrolling], [tsScrollPending]);
          end;
          DoTimerScroll;
        end;
      {ChangeTimer:
        DoChange(FLastChangedNode);
      StructureChangeTimer:
        DoStructureChange(FLastStructureChangeNode, FLastStructureChangeReason);
      SearchTimer:
        begin
          // When this event triggers then the user did not pressed any key for the specified timeout period.
          // Hence incremental searching is stopped.
          DoStateChange([], [tsIncrementalSearching]);
          StopTimer(SearchTimer);
          FSearchBuffer := '';
          FLastSearchNode := nil;
        end;}
    end;
  end;
end;

end.
