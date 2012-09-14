unit gmIntegrators;
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
 * The Original Code is gmIntegratorS.pas; taken from previous gmIntegrator.pas
 * Modified for easier to use and esier to understand.
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
  SysUtils, Classes,IniFiles, Controls,
{$IFDEF FPC}
  LCLIntf, LCLType, LMessages, Types,
 {$ELSE}
  Windows, Messages,
{$ENDIF}
  Forms,
  GR32, GR32_Image, GR32_Layers //GR32_LayersEx
  , gmTools
  ;

type
  //TgmTool =  class(TComponent) //dummy
  //end;

  //TgmIntegrator = class;
  TgmIntegratorBridge = class;
  TgmIntegratorSource = class;
{  //Events
  TgmActivateImg32Event = procedure(ActiveImg32: TCustomImage32;
    ActiveLayer: TCustomLayer) of object;
  TgmActivateLayerEvent = procedure(Sender: TObject; ActivateImg32: TCustomImage32;
    ActiveLayer: TCustomLayer) of object;
  //below we ask you to create an SDI/MDIChildForm or whatever, we only interest on Img32
  TgmNewDocImg32 = function(ACaption: string; Sender: TObject ): TCustomImage32 of object;
}



  TgmIntegrator = class(TComponent)
  private
    FListeners: TList;
    FInstancesList : TList;
    FActiveTool: TgmTool;
    FActiveSource: TgmIntegratorSource;
    procedure SetActiveSource(const Value: TgmIntegratorSource);
    (*FActive: Boolean;
    FIni: TIniFile;

    //FLastTool : TgmTool;


    {FOnMouseUp: TImgMouseEvent;
    FOnMouseDown: TImgMouseEvent;
    FOnMouseMove: TImgMouseMoveEvent;}
    FOnNewDocImg32: TgmNewDocImg32;
    FActiveLayer: TCustomLayer;
    FActiveImage32: TCustomImage32;
    FOnActivateImg32: TgmActivateImg32Event;
    function GetIni: TIniFile;
    procedure SetActiveLayer(const Value: TCustomLayer);
    *)
  protected
    //FLastImage32 : TCustomImage32;
    //FLastLayer   : TBitmapLayerEx;
    //procedure SetLastTool(const Value: TgmTool);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function ProduceTool(AToolClass: TgmToolClass): TgmTool;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function RegisterChangeLink(Value: TgmIntegratorBridge): Integer; //result may used for priority when they called
    procedure UnRegisterChangeLink(Value: TgmIntegratorBridge);

    //general callable by source
    (*function NewDocImg32(ACaption: string; Sender:TObject= nil): TCustomImage32;
    procedure SetActiveImage32(AImage32 : TCustomImage32; AActiveLayer: TCustomLayer);
    procedure IntegrateLayers(AImage32 : TCustomImage32);
    procedure DoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure DoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure DoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

    //general callable by gmTool
    function IsCanActivateTool(ATool :TgmTool):Boolean;   *)
    procedure RegisterTool(ATool : TgmTool);
    procedure UnregisterTool(ATool: TgmTool);

    (*
    //function ProduceTool(AToolClass: TgmToolClass): TgmTool;

    

    {//imgview must directly call this method, perhap dont call the property
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    }
    {property OnMouseDown: TImgMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TImgMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp  : TImgMouseEvent read FOnMouseUp write FOnMouseUp;
    }
    property Ini: TIniFile read GetIni write FIni;
    property ActiveImg32 : TCustomImage32 read FActiveImage32 write FActiveImage32;
    property ActiveLayer : TCustomLayer read FActiveLayer write SetActiveLayer;
    property OnActivateImg32: TgmActivateImg32Event read FOnActivateImg32 write FOnActivateImg32;
    property ActiveTool  : TgmTool read FActiveTool write FActiveTool;
    *)
    property ActiveSource : TgmIntegratorSource read FActiveSource write SetActiveSource;
    
  published
    //property Active : Boolean read FActive write FActive;  //if false it wouldn't broadcast
    //property OnNewDocImg32 : TgmNewDocImg32 read FOnNewDocImg32
      //write FOnNewDocImg32; //usually only implements by MainForm
  end;

  //Base class of both Integrator source + Integrator listener
  TgmIntegratorBridge = class(TComponent)
  private
    FIntegrator: TgmIntegrator;
    procedure SetIntegrator(const Value: TgmIntegrator);
    //FChangeLink : TgmIntegratorChangeLink;
    {FIntegrator: TgmIntegrator;
    FOnActivateImg32: TgmActivateImg32Event;
    FOnActivateDocLayer: TgmActivateDocLayerEvent;
    FOnActivateDocItem: TgmActivateDocItemEvent;
    FOnActivateSource: TgmActivateSourceEvent;
    procedure SetIntegrator(const Value: TgmIntegrator);
    function GetIntegrator: TgmIntegrator;
    }
    //function GetIntegrator: TgmIntegrator;
  protected
    {procedure DoActiveImg32(ActiveImg32:TCustomImage32; ActiveLayer: TCustomLayer);//deprecated
    procedure DoActivateSource(ActiveSource : TgmIntegratorSource); virtual;
    procedure DoActivateDocLayer(ActiveDocLayer : TgmDocCustomLayer); virtual;
    procedure DoActivateDocItem(ActiveDocItem : TgmDocItem); virtual;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;    }
  public
    //constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
{    property OnActivateImg32: TgmActivateImg32Event read FOnActivateImg32 write FOnActivateImg32; //deprecated
    property OnActivateSource: TgmActivateSourceEvent read FOnActivateSource write FOnActivateSource;
    property OnActivateDocLayer: TgmActivateDocLayerEvent read FOnActivateDocLayer write FOnActivateDocLayer;
    property OnActivateDocItem : TgmActivateDocItemEvent  read FOnActivateDocItem  write FOnActivateDocItem;
    }
  published
    property Integrator : TgmIntegrator read FIntegrator write SetIntegrator;
  end;  


// Integrator's supplier. it holds a fimg32 as image-editor,
  // and is responsible of a GM Document stream.
  // usually it work together with a single only TLayerColeection, but it able
  // to handle several TLayerColeection by it's DocItem as TreeNodes
  TgmIntegratorSource = class(TgmIntegratorBridge)
  private
    (*FImg32: TCustomImage32;
    FDocItem: TgmDocItem;
    //FDocLayerCollection: TgmDocLayerCollection;
    procedure SetImg32(const Value: TCustomImage32);
    function GetActiveDoc: TgmDocItem;
    procedure SetActiveDoc(const Value: TgmDocItem);
    *)

  protected
    (* procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property Doc : TgmDocItem read FDocItem; //gm document; highly recomended using ActiveDoc instead.
    *)
  public
    (*constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Activate;
    procedure CreateDocLayer(LayerClass:TgmDocLayerClass; var reference); // we follow the Application.CreateForm(TForm1, Form1);
    procedure TransferLayerCollection(Src, Dst : TLayerCollection);
    //property DocLayerCollection : TgmDocLayerCollection read FDocLayerCollection;
    property ActiveDoc : TgmDocItem read GetActiveDoc write SetActiveDoc; //identic to ActiveDoc.ActiveDoc
    *)
  published
    //property Img32: TCustomImage32 read FImg32 write SetImg32;
  end;


//GLOBAL PROC

function gmSelectTool(AToolClass: TgmToolClass) : boolean;

implementation

{$DEFINE ACTSAVELY}

type
  TCustomImage32Access = class(TCustomImage32);
//  TgmDocItemAccess = class(TgmDocItem);
//  TgmToolAccess = class(TgmTool);

//=================== UNIT ROUTINES =========================//  

var
  UIntegrator : TgmIntegrator = nil; //real integrator, maintened by this unit
  {$IFDEF ACTSAVELY}
  ULock: TRTLCriticalSection;
  {$ENDIF}

function ActiveIntegrator : TgmIntegrator;
begin
  if UIntegrator = nil then
  {$IFNDEF ACTSAVELY}
    UIntegrator := TgmIntegrator.Create(nil);
  {$ELSE}
  begin
    EnterCriticalSection(ULock);
    try
      if UIntegrator = nil then
        UIntegrator := TgmIntegrator.Create(nil);
    finally
      LeaveCriticalSection(ULock);
    end;
  end;  
  {$ENDIF}
  Result := UIntegrator;
end;
  
procedure SetActiveIntegrator(AIntegrator : TgmIntegrator);
begin
  if AIntegrator = UIntegrator then Exit;

  {$IFDEF ACTSAVELY}
    EnterCriticalSection(ULock);
    try
  {$ENDIF}

      if AIntegrator = nil then //want to destroy integrator? oke!
      begin
        if UIntegrator <> nil then
          FreeAndNil(UIntegrator);
      end
      else   //want to set global integrator to other Application.gmIntegrator.Integrator?
      begin
        if UIntegrator <> nil then
        begin
          UIntegrator.AssignTo(AIntegrator);
          FreeAndNil(UIntegrator);
        end;
        UIntegrator := AIntegrator;
      end;
  
  {$IFDEF ACTSAVELY}
    finally
      LeaveCriticalSection(ULock);
    end;
  {$ENDIF}
end;

function gmSelectTool(AToolClass: TgmToolClass) : boolean;
var
  LTool : TgmTool;
begin
  LTool := ActiveIntegrator.ProduceTool(AToolClass);
  assert(assigned(LTool)); //error should be a programatic wrong logic.   
  result := LTool.Activate;
end;
//=========================================================


{ TgmIntegrator }

constructor TgmIntegrator.Create(AOwner: TComponent);
begin
  inherited;
  FListeners := TList.Create;
  FInstancesList := TList.Create;
  //FActive := True;
  //ActualIntegrator := self; //replace the default!
  if not (csDesigning in self.ComponentState) then
    SetActiveIntegrator(Self);
end;

destructor TgmIntegrator.Destroy;
begin
  FListeners.Free;
  FInstancesList.Free;

  if Self = UIntegrator then
    UIntegrator := nil;

  inherited;
end;

procedure TgmIntegrator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent is TgmTool) then
    UnregisterTool(TgmTool(AComponent));
end;

function TgmIntegrator.ProduceTool(AToolClass: TgmToolClass): TgmTool;
var i : Integer;
  //LTool : TgmTool;
begin
  Result := nil;
  for i := 0 to FInstancesList.Count -1 do
  begin
    if TgmTool(FInstancesList[i]) is AToolClass then
    begin
      Result := TgmTool(FInstancesList[i]);
      Break;
    end;
  end;

  if not Assigned(Result) then
  begin
    Result := AToolClass.Create(Application); //it must by owned by something.
    FInstancesList.Add(Result);
  end;

end;

function TgmIntegrator.RegisterChangeLink(
  Value: TgmIntegratorBridge): Integer;
begin
  { TODO -ox2nie -cimprovement : do check availibility in FClients, possible it registered twice or more }
  Result := -1;
  Value.FIntegrator := Self;
  if FListeners <> nil then
    Result := FListeners.Add(Value);
end;

procedure TgmIntegrator.RegisterTool(ATool: TgmTool);
begin
  if FInstancesList.IndexOf(ATool) = -1 then
  begin
    ATool.FreeNotification(Self);
    FInstancesList.Add(ATool)
  end;
end;

procedure TgmIntegrator.SetActiveSource(const Value: TgmIntegratorSource);
var
  I: Integer;
begin
  if (FActiveSource <> Value) and (FListeners <> nil)
    then
  begin
    FActiveSource := Value;

    {if UpdateCount = 0 then
    for I := 0 to FListeners.Count - 1 do
    begin
      TgmIntegratorBridge(FListeners[I]).DoActivateDocItem(FActiveSource.ActiveDoc);
      TgmIntegratorBridge(FListeners[I]).DoActivateSource(FActiveSource);
    end;}
  end;
end;

procedure TgmIntegrator.UnRegisterChangeLink(Value: TgmIntegratorBridge);
var
  I: Integer;
begin
  {if Value = FActiveSource then
  begin
    FActiveSource := nil; //further call to integrator.activesource would be nil.
    FLastDocItem  := nil;
    FLastDocLayer := nil;
  end;}

  //if  (Value = nil) then //clear all

  if FListeners <> nil then
    for I := FListeners.Count - 1 downto 0 do
      if  (Value = nil) then //all
      begin
        TgmIntegratorBridge(FListeners[I]).FIntegrator := nil;
        FListeners.Delete(I);
      end
      else if (FListeners[I] = Value)   then
      begin
        TgmIntegratorBridge(FListeners[I]).FIntegrator := nil;
        FListeners.Delete(I);
        Break;
      end;
//  Changed;//broadcast changes

end;


procedure TgmIntegrator.UnregisterTool(ATool: TgmTool);
begin
if Assigned(FInstancesList) then
  with FInstancesList do
    if IndexOf(ATool) >= 0 then
    begin
      if FActiveTool = ATool then
        FActiveTool := nil;
        
      ATool.RemoveFreeNotification(Self);
      Delete(IndexOf(ATool))
    end;
end;

{ TgmIntegratorBridge }



destructor TgmIntegratorBridge.Destroy;
begin
  if Assigned(FIntegrator) then
    FIntegrator.UnRegisterChangeLink(self);

  inherited;
end;

procedure TgmIntegratorBridge.SetIntegrator(const Value: TgmIntegrator);
begin
  if FIntegrator <> nil then
  begin
    FIntegrator.UnRegisterChangeLink(self);
    FIntegrator.RemoveFreeNotification(Self);
  end;

  FIntegrator := Value;

  if FIntegrator <> nil then
  begin
    FIntegrator.RegisterChangeLink(self);
    FIntegrator.FreeNotification(Self);
  end;
end;

initialization
  //UIntegrator := TgmIntegrator.Create(nil);
  //ActualIntegrator := UIntegrator;
  {$IFDEF ACTSAVELY}
  InitializeCriticalSection(ULock);
  {$ENDIF}

finalization

  SetActiveIntegrator(nil);
  {$IFDEF ACTSAVELY}
  DeleteCriticalSection(ULock);
  {$ENDIF}
end.
