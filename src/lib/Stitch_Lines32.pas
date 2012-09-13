unit Stitch_Lines32;

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
 * The Original Code is Stitch_Line32.pas .
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
  GR32;

type
  TSDLState = (sdlStart, sdlLine, sdlFinish);
  TStitch_LineProc = procedure (B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);

procedure DrawWireFrame (B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
procedure DrawLineFS    (B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
procedure DrawLineStippled(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
procedure Draw3DLine    (B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
procedure DrawXRay(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);


implementation

uses
  Math,
  GR32_Blend;


procedure DrawLineFS(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
begin
  if AState = sdlStart then
    B.FillRectTS(MakeRect(R), C);

  if AState = sdlLine then
  with R do
    B.LineFS(left, top, right, bottom, C);
end;

procedure DrawLineStippled(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
var h, x, y : TFloat;
  Cs : TArrayOfColor32;
begin
  if AState = sdlStart then
    B.FillRectTS(MakeRect(R), C);

  if AState = sdlLine then    
  with R do
  begin
    x := right - left;
    y := bottom - top;
    h := hypot(x,y);

    if h = 0 then exit;

    //B.StippleCounter := 0;
    B.StippleStep := 4/h;
    setlength(Cs,5);
    Cs[0] := Lighten(C, - 64);
    Cs[1] := C;//Lighten(C, 11);
    Cs[2] := Lighten(C, 151);
    Cs[3] := C;//Lighten(C, 11);
    Cs[4] := Lighten(C, - 64);
    B.SetStipple(Cs);


    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
  end;
end;

procedure Draw3DLine(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
var h, x, y : TFloat;
  Cs : TArrayOfColor32;
begin
  if AState = sdlStart then
    B.FillRectTS(MakeRect(R), C);
    
  if AState = sdlLine then
  with R do
  begin
    x := right - left;
    y := bottom - top;
    h := hypot(x,y);

    if h = 0 then exit;

    //B.StippleCounter := 0;
    B.StippleStep := 4/h;
    setlength(Cs,5);
    Cs[0] := Lighten(C, - 64); EMMS; // calling EMMS each time after call to Lighten() to avoid "invalid floating operation" error
    Cs[1] := C;//Lighten(C, 11);
    Cs[2] := Lighten(C, 90); EMMS;
    Cs[3] := C;//Lighten(C, 11);
    Cs[4] := Lighten(C, - 64); EMMS;
    B.SetStipple(Cs);


    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
    B.StippleCounter := 0;
    B.LineFSP(left, top, right, bottom);
  end;
end;


procedure DrawWireFrame(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
//BETTER FOR LOOKING THE LOST STITCH
begin
  if AState = sdlStart then
    B.FillRectTS(MakeRect(R), clWhite32);

  if AState = sdlLine then
  with MakeRect(R) do
    B.LineS(left, top, right, bottom, ClBlack32);
end;

procedure DrawXRay(B: TBitmap32; R : TFloatRect; C : TColor32; AState: TSDLState);
//BETTER FOR LOOKING FOR MOST OVERLAPED STITCH
begin
  if AState = sdlStart then
    B.FillRectTS(MakeRect(R), clBlack32);

  if AState = sdlLine then
  with R do
    B.LineFS(left, top, right, bottom, $40FFFFFF);
end;


end.
