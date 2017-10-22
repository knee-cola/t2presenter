;T2Presenter by Nikola Derezic (nikola.derezic@gmail.com)
;This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 2.0 Generic (CC BY-NC-SA 2.0)

;To make x,y movements look nice
SetFormat, FloatFast, 3.0

Gui, +Resize -MaximizeBox -MinimizeBox +LastFound
Gui, Add, Text,, To toggle the pointer mode press MUTE (15) on your AirMouse or Ctrl+Shift+F5 on your keyboard.
Gui, Add, Picture, w300 h-1, .\assets\key-diagram.jpg
Gui, Add, Text,, MUTE (15) = toggle the pointer mode on/off)`nOK (8) = press and hold to display the laser pointer (draw in drawing mode)`n`nVOLUME UP/DOWN (2 and 3) = change the cursor shape`nBACK (9) = clear all the drawing on the current slide`nMENU (10) = toggle the drawing mode on/off`nHOME (11) = toggle the black screen on/off`nMOUSE (12) = turn mouse on/off`nPAGE UP/DOWN (13 and 14) = disabled

;Keep handle
GuiHandle := WinExist()

; script-specific variables
isPointerMode:=0
isMarkerMode:=0
isMarkerActive:=0
pointerIx:=6
markerIx:=2 ; default value = yellow marker
currX:=0
currY:=A_ScreenHeight

; use screen as refference coordinate system when positiong the mouse
CoordMode, Mouse, Screen

Gui, Show
Return
;-----------------------
GuiEscape:
GuiClose:
ExitApp
;-------------------------------------
#If isPointerMode = 1 or isMarkerMode = 1

	;these buttons are disabled
  PgUp::Return
  PgDn::Return
	
	; OK button is pressed
  LButton::
			if(isPointerMode=1) {
				MouseMove currX, currY, 0 ; reset the cursor to the default position
				BlockInput, MouseMoveOff ; enable the cursor movement
			}
			if(isMarkerMode=1) and (isMarkerActive=0) {
				; activate the Powerpoint "highlighter" mode
				; > powerpoint special cursor will be shown
					isMarkerActive:=1				
					Send ^p ; standard Powerpoint button for switching the marker on
					Sleep 50
					SendInput {LButton down} ; start drawing
			}
  Return
  
 	; "OK" button is released
	LButton Up::
			if(isPointerMode=1) {
				; save the curront cursor position
				; the cursor will be set to this stored position when the "OK" button is pressed again
				MouseGetPos currX, currY
				; schedule a timeout after which you will reset the
				; stored cursor position to the default value
				SetTimer, ResetCursorPosition, -2000

				BlockInput, MouseMove ; disable the cursor movement
				; hide cursor by setting it's position outside of the visible screen area
				MouseMove 10000, 10000, 0
			}
			if(isMarkerMode=1) {
				; de-activate the Powerpoint "highlighter" mode
				; > the standard cursor will be automatically shown - which we replaced with our own
				isMarkerActive:=0
				SendInput {LButton up}
				Send ^a ; Ctrl+A is a standard Powerpoint keystroke
			}
	Return

	; in marker or pointer mode, the left button removes all the ink from the presentation
	RButton::E

	; this button togles the marker mode
  AppsKey::
  	if(isMarkerMode=0) {
  		isMarkerMode:=1
  		isMarkerActive:=0
  		isPointerMode:=0 ; switch the pointer mode off

			; re-enable free movement of the cursor
			BlockInput, MouseMoveOff
			MouseMove currX, currY, 0 ; reset the cursor to the default position

			SetMarker(markerIx) ; set the "marker" cursor

  	} else {
  		isMarkerMode:=0
  		isMarkerActive:=0
  		isPointerMode:=1 ; swich to pointer mode

			SetPointer(pointerIx) ; set the "laser pointer" cursor

			; disable cursor movement - the movement will be enabled while the user holds the "OK" button	    
    	BlockInput, MouseMove

			; save the curront cursor position
			; the cursor will be set to this stored position when the "OK" button is pressed again
			MouseGetPos currX, currY
			; schedule a timeout after which you will reset the
			; stored cursor position to the default value
			SetTimer, ResetCursorPosition, -2000

			MouseMove 10000, 10000, 0 ; hide cursor by moving it outside the visible area of the screen
  	}
  Return

	; VolumeDown button changes the cursor shape to the previous one in the list
  Volume_Down::
  	if(isPointerMode=1) {
	  	if(pointerIx=0) {
	  		pointerIx:=11
	  	} else {
	  		pointerIx:=pointerIx-1
	  	}
	  	SetPointer(pointerIx)
	  	PreviewCursor()
		}
;not supported  	if(isMarkerMode=1) {
;not supported	  	if(pointerIx=0) {
;not supported	  		markerIx:=2
;not supported	  	} else {
;not supported	  		markerIx:=markerIx-1
;not supported	  	}
;not supported	  	SetMarker(markerIx)
;not supported		}
  Return
;-------------------------------------
	; VolumeDown button changes the cursor shape to the next one in the list
  Volume_Up::
  	if(isPointerMode=1) {
	  	if(pointerIx=11) {
	  		pointerIx:=0
	  	} else {
	  		pointerIx:=pointerIx+1
	  	}
	  	
	  	SetPointer(pointerIx)
	  	PreviewCursor()
		}
;not supported		if(isMarkerMode=1) {
;not supported	  	if(markerIx=2) {
;not supported	  		markerIx:=0
;not supported	  	} else {
;not supported	  		markerIx:=markerIx+1
;not supported	  	}
;not supported	  	
;not supported	  	SetMarker(markerIx)
;not supported		}
  Return

#If

;-------------------------------------
; click on this key toggles the Powerpoin "Black screen" feature
  Browser_Home::B
;-------------------------------------
	; the mute button toggles "pointer mode" on and off
  Volume_Mute::
		ToggleMode()
  Return

	; keyboard shortcut that toggles "pointer mode" on and off
  ^+F5::
		ToggleMode()
  Return
;-------------------------------------
GuiSize:
    Anchor("lbxInput", "wh")
    Anchor("lbxMove", "xh")
    Anchor("lblXY", "xy")
Return

ToggleMode() {

		global isPointerMode, isMarkerMode, pointerIx

		; if the pointer is in marker mode, switch back to normal cursor mode
		; as if it was in pointer mode
  	if(isPointerMode=0) and (isMarkerMode=0) {

	    isPointerMode := 1

			; disable cursor movement - the movement will be enabled while the user holds the "OK" button	    
    	BlockInput, MouseMove

			MouseMove 10000, 10000, 0 ; hide cursor by moving it outside the visible area of the screen

			SetPointer(pointerIx) ; set the "laser pointer" cursor

  	} else {

			isPointerMode := 0
			isMarkerMode := 0

			; re-enable free movement of the cursor
			BlockInput, MouseMoveOff
			
			SetPointer(0) ; set the default system cursor
  	}
}

; function changes cursor shape to the one indicated by the [ix] parameter
SetPointer(ix) {
		
		cursorPath:=A_WorkingDir
		cursorPath.="\\assets\\"

		sysPath:=A_WinDir
		sysPath.="\\Cursors\\"
		
		if(ix=0) {
			cursorPath:=sysPath
			cursorPath.="aero_arrow.cur"
		} else if(ix=1) {
			cursorPath:=sysPath
			cursorPath.="aero_arrow_l.cur"
		} else if(ix=2) {
			cursorPath:=sysPath
			cursorPath.="aero_arrow_xl.cur"
		} else if(ix=3) {
			cursorPath:=sysPath
			cursorPath.="arrow_r.cur"
		} else if(ix=4) {
			cursorPath:=sysPath
			cursorPath.="arrow_rm.cur"
		} else if(ix=5) {
			cursorPath:=sysPath
			cursorPath.="arrow_rl.cur"
		} else if(ix=6) {
			cursorPath.="laser_cursor_red.cur"
		} else if(ix=7) {
			cursorPath:="laser_cursor_green.cur"
		} else if(ix=8) {
			cursorPath:="red-box.cur"
		} else if(ix=9) {
			cursorPath:="red-box-full.cur"
		} else if(ix=10) {
			cursorPath:="red-circle.cur"
		} else if(ix=11) {
			cursorPath:="red-circle-full.cur"
		}
		
		; loading the cursor
		hCursor:=DllCall("LoadCursorFromFile","Str",cursorPath)
		DllCall("SetSystemCursor","UInt", hCursor, "UInt", 32512)
}

; function changes cursor shape to the one indicated by the [ix] parameter
SetMarker(ix) {
		
		cursorPath:=A_WorkingDir
		cursorPath.="\\assets\\"
		
		if(ix=0) {
			cursorPath:=sysPath
			cursorPath.="marker_ballpoint64.cur"
		} else if(ix=1) {
			cursorPath:=sysPath
			cursorPath.="marker_flettip128.cur"
		} else if(ix=2) {
			cursorPath:=sysPath
			cursorPath.="marker_highlighter64.cur"
		}
		
		; loading the cursor
		hCursor:=DllCall("LoadCursorFromFile","Str",cursorPath)
		DllCall("SetSystemCursor","UInt", hCursor, "UInt", 32512)
}

; function shows the current cursor in the screen center - the cursor is hidden after 0.5 seconds
PreviewCursor() {
		; set the cursor position at the screen center
		moveX:=A_ScreenWidth/2
		moveY:=A_ScreenHeight/2
		MouseMove moveX, moveY, 0
		
		; wait 1/2 second before hiding cursor again
		SetTimer, HideCursor, -500
}

; function hides the cursor after the timeout (set by the [PreviewCursor] function)
HideCursor:
	MouseMove 10000, 10000, 0 ; hide cursor by moving it outside the visible area of the screen
Return

; function re-sets the saved cursor position to the default values
ResetCursorPosition:
	; the default cursor position is bottom left corner of the screen
	currX:=0
	currY:=A_ScreenHeight
Return

;Anchor by Titan, adapted by TheGood
;http://www.autohotkey.com/forum/viewtopic.php?p=377395#377395
Anchor(i, a = "", r = false) {
	static c, cs = 12, cx = 255, cl = 0, g, gs = 8, gl = 0, gpi, gw, gh, z = 0, k = 0xffff, ptr
	If z = 0
		VarSetCapacity(g, gs * 99, 0), VarSetCapacity(c, cs * cx, 0), ptr := A_PtrSize ? "Ptr" : "UInt", z := true
	If (!WinExist("ahk_id" . i)) {
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else ControlGet, i, Hwnd, , %i%
	}
	VarSetCapacity(gi, 68, 0), DllCall("GetWindowInfo", "UInt", gp := DllCall("GetParent", "UInt", i), ptr, &gi)
		, giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int"), gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int")
	If (gp != gpi) {
		gpi := gp
		Loop, %gl%
			If (NumGet(g, cb := gs * (A_Index - 1)) == gp, "UInt") {
				gw := NumGet(g, cb + 4, "Short"), gh := NumGet(g, cb + 6, "Short"), gf := 1
				Break
			}
		If (!gf)
			NumPut(gp, g, gl, "UInt"), NumPut(gw := giw, g, gl + 4, "Short"), NumPut(gh := gih, g, gl + 6, "Short"), gl += gs
	}
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	Loop, %cl%
		If (NumGet(c, cb := cs * (A_Index - 1), "UInt") == i) {
			If a =
			{
				cf = 1
				Break
			}
			giw -= gw, gih -= gh, as := 1, dx := NumGet(c, cb + 4, "Short"), dy := NumGet(c, cb + 6, "Short")
				, cw := dw, dw := NumGet(c, cb + 8, "Short"), ch := dh, dh := NumGet(c, cb + 10, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1), as += 1 + StrLen(A_LoopField)
						, d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "UInt", 0, "Int", dx, "Int", dy
				, "Int", InStr(a, "w") ? dw : cw, "Int", InStr(a, "h") ? dh : ch, "Int", 4)
			If r != 0
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	If cf != 1
		cb := cl, cl += cs
	bx := NumGet(gi, 48, "UInt"), by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52, "UInt")
	If cf = 1
		dw -= giw - gw, dh -= gih - gh
	NumPut(i, c, cb, "UInt"), NumPut(dx - bx, c, cb + 4, "Short"), NumPut(dy - by, c, cb + 6, "Short")
		, NumPut(dw, c, cb + 8, "Short"), NumPut(dh, c, cb + 10, "Short")
	Return, true
}
