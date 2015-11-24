#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen


;globals
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;----------------------------Fill Out Your Order Here------------------------------
;--------------(below on line that starts with global ActionOrder)-----------------
;---------------You have action1-action8 available and special---------------------
;---------------------Enclose in " and separate by commas--------------------------
;----------------------------------------------------------------------------------
global ActionOrder := ["action7","action3","action2","action1"]
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------



global ActionArray := {}
;-------------------The last item in each line is the corresponding key---------------
ActionArray["special"] := new ActionButton(661,1010,"r")
ActionArray["action1"] := new ActionButton(724,1010,"1")
ActionArray["action2"] := new ActionButton(784,1010, "2")
;ActionArray["action2"].SecondaryCheckMethod := Func("IsSuitPowerAt100")
;ActionArray["action2"].SecondaryCheck := True
ActionArray["action3"] := new ActionButton(841,1010, "3")
ActionArray["action4"] := new ActionButton(897,1010, "4")
ActionArray["action5"] := new ActionButton(957,1010, "5")
ActionArray["action6"] := new ActionButton(1017,1010, "6")
ActionArray["action7"] := new ActionButton(1069,1010, "7")
ActionArray["action8"] := new ActionButton(1134,1010, "8")

;-----------------------Debugging--------------------------------------------
;#Persistent
;SetTimer, WatchCursor, 200
;Return
;WatchCursor:		
;    MouseGetPos, mouseX, mouseY, ,
;	PixelGetColor, foundcolor, %mouseX%, %mouseY%
;	IsColorGreen("0x78AB46")
;	ToolTip % "XPos: " mouseX " YPos: " mouseY
;
;Return
;-----------------------/Debugging--------------------------------------------





;Alt+Enter				
!Enter::
	;Initialize all the button default colors
	for index, element in ActionArray
	{
		element.GetDefaultColor()
	}
Return

MButton::
	While GetKeyState("MButton","P"){
	Sleep 150
		for index, element in ActionOrder
		{
			if(!(ActionArray[element].IsOnCooldown()))
			{
				if(ActionArray[element].ExecuteCommand())
				{
					break
				}
			}
		}
	}
Return

+Space::
	Send {Home}
Return


Class ActionButton {
	;Constructor
	__New(XPos, YPos, Key) {
		this.XPos := XPos
		this.YPos := YPos
		this.Key := Key
	}
	;----------------------------------------------
	;------------------Methods---------------------
	GetDefaultColor(){
		PixelGetColor, colorfound, this.XPos, this.YPos
		this.IdleColor := colorfound
	}
	
	IsOnCooldown(){
		PixelGetColor, colorfound, this.XPos, this.YPos		
		if(colorfound = this.IdleColor)
				Return False
		else
				Return True
	}
	
	ExecuteCommand(){
		if(this.SecondaryCheck)
		{
			if(this.SecondaryCheckMethod())
			{
				Send % this.Key
				Return True
			}
			else
			{
				Return False
			}
		}
		else
		{
			Send % this.Key
			Return True
		}				
	}
}

IsSuitPowerAt100(){
	XPos := 1119
	YPos := 966
	PixelGetColor, pixelcolor, %XPos%, %YPos%
	if(IsColorGreen(pixelcolor))
		Return True
	else
		Return False
}

IsColorGreen(color){
	red := "Ox" . SubStr(color, 3, 2)
	green := "Ox" . SubStr(color, 5, 2)
	blue := "Ox" . SubStr(color, 7, 2)
	;Convert to decimal
	red :=  hexToDecimal(red)
	green := hexToDecimal(green)
	blue := hexToDecimal(blue)
	
	if((green > (blue + 30)) && (green > (red + 30)))
		Return True
	else
		Return False
	
}
hexToDecimal(str){
    static _0:=0,_1:=1,_2:=2,_3:=3,_4:=4,_5:=5,_6:=6,_7:=7,_8:=8,_9:=9,_a:=10,_b:=11,_c:=12,_d:=13,_e:=14,_f:=15
    str:=ltrim(str,"0x `t`n`r"),   len := StrLen(str),  ret:=0
    Loop,Parse,str
      ret += _%A_LoopField%*(16**(len-A_Index))
    return ret
}