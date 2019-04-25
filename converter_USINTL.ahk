; Converter 2.2
; Script to switch between keyboard inputs (greek/englishUS) 
; Sean Hannon 2020
; converter@acrite.ly

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

Menu, tray, NoStandard
Menu, tray, DeleteAll
Menu, tray, add, &About, InfoMenuHandler
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, &Exit, Exit0

TrayTip, ΕΛ<->EN keyboard converter started!,%A_Space%
SetTimer, RemoveTrayTip, 5000

; trigger
Hotkey, ^g, ProcessEN2GR ;for convert english to greek
Hotkey, ^e, ProcessGR2EN ;for convert greek to english
Hotkey, ^+g, Exit0
Hotkey, ^+e, Exit0
return

InfoMenuHandler:
MsgBox, 0, Converter 2.2, Welcome to Greek / English Keyboard converter.`n`nTo convert text, use the following combinations:`n Control-g --> to convert Greek text to English. `nControl-e --> to convert English text to Greek.`n`nPress Control-Shift-g to exit.`n Send bugs to converter@acrite.ly`nEnjoy! -Sean Hannon 2020
return

Exit0:
TrayTip, ΕΛ<->EN keyboard converter closing... ,%A_Space%
SetTimer, RemoveTrayTip, 1000
ExitApp 0
return

RemoveTrayTip:
	SetTimer, RemoveTrayTip, Off
	TrayTip
return

ProcessEN2GR:
	try
	{
;		save current clipboard contents
		lastClipBoard := ClipboardAll
		Clipboard := ""

;		send copy command
		Send, ^{c} 			; copy
		ClipWait, 0.01

		if(Clipboard == "") ; no text selected, highlight 20 chars
		{
;			DEBUG
;			MsgBox no text selected!

			Send, +{Left 25} ; left arrow
	
;			select and copy text in active window 
			Send, ^{x}		; cut
			ClipWait, 0.1
			clip0 := Clipboard

;			DEBUG
;			MsgBox, Captured characters:`r`n "%clip0%"
		}
		else
		{
;			cut selected text in active window
			Send, ^{x}   ; cut
			ClipWait, 0.1
			clip0 := Clipboard

;			DEBUG
;			MsgBox, Captured characters:`r`n "%clip0%"
		}

;		convert text in clipboard buffer
		newText := ConvertEN2GR(clip0)

;		return to buffer
		Clipboard := newText
		ClipWait, 0.001
		Send, ^{v}  		   	; paste
		Send, {Left}{Right}		; Left arrow, right arrow to deselect text... 

;		restore prior clipboard state
		Clipboard := lastClipBoard

;		#Persistent
;		TrayTip, Converted to Greek text!, %A_Space%
;		SetTimer, RemoveTrayTip, 5000
	} catch e {
		ClipBoard := lastClipBoard
		MsgBox An exception was thrown! `nSpecifically: %e%
		Exit
	}
return

ProcessGR2EN:
	try
	{
;		save current clipboard contents
		lastClipBoard := ClipboardAll
		Clipboard := ""

;		test if text highlighted
		Send, ^{c}  			; copy
		ClipWait, 0.001

		if(ClipBoard = "") ; no text selected, highlight 20 chars
		{
			Send, +{Left 25}	; left arrow
	
;			cut text in active window
			Send, ^{x}		  	; cut selected
			ClipWait, 0.1
			clip0 := ClipBoard
		}
		else
		{
;			cut selected text in active window
			Send, ^{x}  	   ; cut
			ClipWait, 0.1
			clip0 := ClipBoard
			
;			DEBUG
;			MsgBox, Captured characters:`r`n "%clip0%"
		}

;		convert text in clipboard buffer
		newText := ConvertGR2EN(clip0)

;	    return to buffer
		ClipBoard := newText
		ClipWait, 0.001
		Send, ^{v}   		  ; paste
		Send, {Left}{Right}   ; left arrow, right arrow to deselect text... 

;		restore clipboard
		Clipboard := lastClipBoard

;		#Persistent
;		TrayTip, Converted to English text!, %A_Space%
;		SetTimer, RemoveTrayTip, 5000
	} catch e {
		ClipBoard := lastClipBoard
		MsgBox An exception was thrown! `nSpecifically: %e%
		Exit
	}
return

ConvertGR2EN(oldText) {

	StringLen, count0, oldText
	
    if ( count0 == 0) 
    	return

    newText := ""

	StringSplit, tempArray, oldText
	textArray := Object()
	
	Loop %tempArray0%
	{
		textArray.Insert(tempArray%A_index%)
	}
	
	index0 := 0
	
	count0 := count0+1
	
	Loop
	{
		if(index0 == count0){
;			DEBUG
;			MsgBox exit condition reached...
			break 
		}
			
;		DEBUG
;		MsgBox, current parsing step: "%newText%.
;		if(A_LoopField == " ")
;			MsgBox, space!

;       determine if the first character is a modifier. if so send two chars in the token		
		if(textArray[index0] =="`'" && textArray[index0+1] !="") {  ;"'"
        	newChar := convertchar_GR2EN(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else if(textArray[index0] == Chr(96) && textArray[index0+1] !="") {    ; "`"
;			DEBUG
;			MsgBox, Inside grave accent case
    		newChar := convertchar_GR2EN(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else if(textArray[index0] =="""" && textArray[index0+1] !="") {   ; """"
    		newChar := convertchar_GR2EN(textArray[index0] . textArray[index0+1])
        	index0++
    	}
		else if(textArray[index0] =="^" && textArray[index0+1] !="") {   ; "^"
    		newChar := convertchar_GR2EN(textArray[index0] . textArray[index0+1])
        	index0++
    	}
		else if(textArray[index0] =="~" && textArray[index0+1] !="") {   ; "^"
    		newChar := convertchar_GR2EN(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else {
    		newChar := convertchar_GR2EN(textArray[index0])
    	}
		
		index0++
		newText := newText . newChar
    }
	
    return newText
}

Convertchar_GR2EN(token) {
	
	StringLen, count0, token
	
	if(count0==2) {
	
		inp_char2 := SubStr(token,0,1)
		inp_char := SubStr(token,1,1)
	
		if (inp_char=="`'") {
		
;			DEBUG
;			MsgBox, first char is '
			if (inp_char2==Chr(945)) {	   ;		á 'α
				return "á"
			}
			else if (inp_char2==Chr(913)) { ;		Á 'Α
				return "Á"
			}
			else if (inp_char2==Chr(949)) { ;		é 'ε
				return "é"
			}
			else if (inp_char2==Chr(917)) { ;		É 'Ε
				return "É"
			}
			else if (inp_char2==Chr(953)) { ;		í 'ι
				return "í"
			}
			else if (inp_char2==Chr(921)) { ;		Í 'Ι
				return "Í"
			}
			else if (inp_char2==Chr(959)) { ;		ó 'ο
				return "ó"
			}
			else if (inp_char2==Chr(927)) { ;		Ó 'Ο
				return "Ó"
			}
			else if (inp_char2==Chr(952)) { ;		ú 'θ
				return "ú"
			}
			else if (inp_char2==Chr(920)) { ;		Ú 'Θ
				return "Ú"
			}
			else if (inp_char2==Chr(965)) { ;		ý 'υ
				return "ý"
			}
			else if (inp_char2==Chr(933)) { ;		Ý 'Υ
				return "Ý"
			}
			else if (inp_char2==Chr(968)) { ;		ç 'ψ
				return "ç"
			}
			else if (inp_char2==Chr(936)) { ;		Ç 'Ψ
				return "Ç"
			}
		}
		else if (inp_char=="``") {
;			DEBUG
;			MsgBox, first char is ``
			if (inp_char2==Chr(945)){ 		;		à `α
				return "à"
			}
			else if (inp_char2==Chr(913)) { ;		À `Α
				return "À"
			}
			else if (inp_char2==Chr(949)) { ;		è `ε
				return "è"
			}
			else if (inp_char2==Chr(917)) { ;		È `Ε
				return "È"
			}
			else if (inp_char2==Chr(953)) { ;		ì `ι
				return "ì"
			}
			else if (inp_char2==Chr(921)) { ;		Ì `Ι
				return "Ì"
			}
			else if (inp_char2==Chr(959)) { ;		ò `ο
				return "ò"
			}
			else if (inp_char2==Chr(927)) { ;		Ò `Ο
				return "Ò"
			}
			else if (inp_char2==Chr(952)) { ;		ù `θ
				return "ù"
			}
			else if (inp_char2==Chr(920)) { ;		Ù `Θ
				return "Ù"
			}
			else if (inp_char2==Chr(965)) { ;		`y `υ
				return "y"
			}
			else if (inp_char2==Chr(933)) { ;		`Y `Υ
				return token
			}
			else {
;				DEBUG
;				MsgBox, no match found for %token%
				return token	
			}
		}
		else if (inp_char=="""") {
			if (inp_char2==Chr(945)) { ;		ä "α
				return "ä"
			}
			else if (inp_char2==Chr(913)) { ;		Ä "Α
				return "Ä"
			}
			else if (inp_char2==Chr(949)) { ;		ë "ε
				return "ë"
			}
			else if (inp_char2==Chr(917)) { ;		Ë "Ε
				return "Ë"
			}
			else if (inp_char2==Chr(953)) { ;		ï "ι
				return "ï"
			}
			else if (inp_char2==Chr(921)) { ;		Ï "Ι
				return "Ï"
			}
			else if (inp_char2==Chr(959)) { ;		ö "ο
				return "ö"
			}
			else if (inp_char2==Chr(927)) { ;		Ö "Ο
				return "Ö"
			}
			else if (inp_char2==Chr(952)) { ;		ü "θ
				return "ü"
			}
			else if (inp_char2==Chr(920)) { ;		Ü "Θ
				return "Ü"
			}
			else if (inp_char2==Chr(965)) { ;		ÿ "υ
				return "ÿ"
			}
			else if (inp_char2==Chr(933)) { ;		"Y "Υ
				return token
			}
			else {
				return token	
			}
		}
		else if (inp_char=="^") {
			if (inp_char2==Chr(945)) { ;		â ^α
				return "â"
			}
			else if (inp_char2==Chr(913)) { ;		Â ^Α
				return "Â"
			}
			else if (inp_char2==Chr(949)) { ;		ê ^ε
				return "ê"
			}
			else if (inp_char2==Chr(917)) { ;		Ê ^Ε
				return "Ê"
			}
			else if (inp_char2==Chr(953)) { ;		î ^ι
				return "î"
			}
			else if (inp_char2==Chr(921)) { ;		Î ^Ι
				return "Î"
			}
			else if (inp_char2==Chr(959)) { ;		ô ^ο
				return "ô"
			}
			else if (inp_char2==Chr(927)) { ;		Ô ^Ο
				return "Ô"
			}
			else if (inp_char2==Chr(952)) { ;		û ^θ
				return "û"
			}
			else if (inp_char2==Chr(920)) { ;		Û ^Θ
				return "Û"
			}
			else if (inp_char2==Chr(965)) { ;		^y ^υ
				return "y"
			}
			else if (inp_char2==Chr(933)) { ;		^Y ^Υ
				return token
			}
			else {
				return token	
			}
		}
		else if (inp_char=="~") {
			if (inp_char2=="α") { ;		ã ~α
				return "ã"
			}
			else if (inp_char2==Chr(913)) { ;		Ã ~Α
				return "Ã"
			}
			else if (inp_char2==Chr(959)) { ;		õ ~ο
				return "õ"
			}
			else if (inp_char2==Chr(927)) { ;		Õ ~Ο
				return "Õ"
			}
			else if (inp_char2==Chr(957)) { ;		ñ ~ν
				return "ñ"
			}
			else if (inp_char2==Chr(925)) { ;		Ñ ~Ν
				return "Ñ"
			}
			else {
				return token	
			}
		}
		else {
			return token	
		}	
	}
	else {
		inp_char := token
	
;		DEBUG
;		MsgBox current char %inp_char%

		if ( inp_char==  Chr(945))       ;"α")
			return "a"
		else if (inp_char== Chr(940))    ;"ά" 
			return ";a"
		else if (inp_char== Chr(913))    ;"Α" 
			return "A"
		else if (inp_char== Chr(902))    ;"Ά" 
			return ";A"
		else if (inp_char== Chr(946))    ;"β" 
			return "b"
		else if (inp_char== Chr(914))    ;"Β" 
			return "B"
		else if (inp_char== Chr(947))    ;"γ" 
			return "g"
		else if (inp_char== Chr(915))    ;"Γ" 
			return "G"
		else if (inp_char== Chr(948))    ;"δ" 
			return "d"
		else if (inp_char== Chr(916))    ;"Δ" 
			return "D"
		else if (inp_char== Chr(949))    ;"ε" 
			return "e"
		else if (inp_char== Chr(941))    ;"έ" 
			return ";e"
		else if (inp_char== Chr(917))    ;"Ε" 
			return "E"
		else if (inp_char== Chr(904))    ;"Έ" 
			return ";E"
		else if (inp_char== Chr(950))    ;"ζ"
			return "z"
		else if (inp_char== Chr(918))    ;"Ζ" 
			return "Z"
		else if (inp_char== Chr(951))    ;"η" 
			return "h"
		else if (inp_char== Chr(942))    ;"ή" 
			return ";h"
		else if (inp_char== Chr(919))    ;"Η" 
			return "H"
		else if (inp_char== Chr(905))    ;"Ή") 
			return ";H"
		else if (inp_char== Chr(952))    ;"θ") 
			return "u"
		else if (inp_char== Chr(920))    ;"Θ") 
			return "U"
		else if (inp_char== Chr(953))    ;"ι") 
			return "i"
		else if (inp_char== Chr(943))    ;"ί") 
			return ";i"
		else if (inp_char== Chr(970))    ;"ϊ") 
			return ":i"
		else if (inp_char== Chr(912))    ;"ΐ") 
			return "Wi"
		else if (inp_char== Chr(921))    ;"Ι") 
			return "I"
		else if (inp_char== Chr(906))    ;"Ί") 
			return ";I"
		else if (inp_char== Chr(938))    ;"Ϊ") 
			return ":I"
		else if (inp_char== Chr(954))    ;"κ") 
			return "k"
		else if (inp_char== Chr(922))    ;"Κ") 
			return "K"
		else if (inp_char== Chr(955))    ;"λ") 
			return "l"
		else if (inp_char== Chr(923))    ;"Λ") 
			return "L"
		else if (inp_char== Chr(956))    ;"μ") 
			return "m"
		else if (inp_char== Chr(924))    ;"Μ") 
			return "M"
		else if (inp_char== Chr(957))    ;"ν") 
			return "n"
		else if (inp_char== Chr(925))    ;"Ν") 
			return "N"
		else if (inp_char== Chr(958))    ;"ξ") 
			return "j"
		else if (inp_char== Chr(926))    ;"Ξ") 
			return "J"
		else if (inp_char== Chr(959))    ;"ο") 
			return "o"
		else if (inp_char== Chr(972))    ;"ό") 
			return ";o"
		else if (inp_char== Chr(927))    ;"Ο") 
			return "O"
		else if (inp_char== Chr(908))    ;"Ό") 
			return ";O"
		else if (inp_char== Chr(960))    ;"π") 
			return "p"
		else if (inp_char== Chr(928))    ;"Π") 
			return "P"
		else if (inp_char== Chr(961))    ;"ρ") 
			return "r"
		else if (inp_char== Chr(929))    ;"Ρ") 
			return "R"
		else if (inp_char== Chr(963))    ;"σ") 
			return "s"
		else if (inp_char== Chr(962))    ;"ς") 
			return "w"
		else if (inp_char== Chr(931))    ;"Σ") 
			return "S"
		else if (inp_char== Chr(964))    ;"τ") 
			return "t"
		else if (inp_char== Chr(932))    ;"Τ") 
			return "T"
		else if (inp_char== Chr(965))    ;"υ") 
			return "y"
		else if (inp_char== Chr(973))    ;"ύ") 
			return ";y"
		else if (inp_char== Chr(971))    ;"ϋ") 
			return ":y"
		else if (inp_char== Chr(944))    ;"ΰ") 
			return "Wy"
		else if (inp_char== Chr(933))    ;"Υ") 
			return "Y"
		else if (inp_char== Chr(910))    ;"Ύ") 
			return ";Y"
		else if (inp_char== Chr(939))    ;"Ϋ") 
			return ":Y"
		else if (inp_char== Chr(966))    ;"φ") 
			return "f"
		else if (inp_char== Chr(934))    ;"Φ") 
			return "F"
		else if (inp_char== Chr(967))    ;"χ") 
			return "x"
		else if (inp_char== Chr(935))    ;"Χ") 
			return "X"
		else if (inp_char== Chr(968))    ;"ψ") 
			return "c"
		else if (inp_char== Chr(936))    ;"Ψ") 
			return "C"
		else if (inp_char== Chr(969))    ;"ω") 
			return "v"
		else if (inp_char== Chr(974))    ;"ώ") 
			return ";v"
		else if (inp_char== Chr(937))    ;"Ω") 
			return "V"
		else if (inp_char== Chr(911))    ;"Ώ") 
			return ";V"
		else if (inp_char== Chr(59))    ;";") 
			return "q"
		else if (inp_char== Chr(58))    ;":") 
			return "Q"
;		else if (inp_char== Chr(46))    ;".") 
;			return "."
;		else if (inp_char== Chr(44))    ;",") 
;			return ","
;		else if (inp_char== Chr(47))    ;"/") 
;			return "/"
;		else if (inp_char== Chr(47))    ;"/") 
;			return "\"
;		else if (inp_char== Chr(946))    ;"[") 
;			return "["
;		else if (inp_char== Chr(946))    ;"]") 
;			return "]"
;		else if (inp_char== Chr(946))    ;"'") 
;			return "'"		
;		else if (inp_char== Chr(946))    ;"\n") 
;			return ""
		else if (inp_char==  Chr(32))    ;A_Space) 
		{
			space := Chr(32)
			return %space%
		}
		else {  
;			DEBUG
;			MsgBox, error %inp_char% not recognized.
			return inp_char
		}
	}
}


ConvertEN2GR(oldText) {

	StringLen, count0, oldText
	
    if ( count0 == 0) 
    	return

    newText := ""

	StringSplit, tempArray, oldText
	textArray := Object()
	
	Loop %tempArray0%
	{
		textArray.Insert(tempArray%A_index%)
	}
	
	index0 := 0
	
	count0 := count0+1
	
	Loop
	{
		if(index0 == count0){
;			DEBUG
;			MsgBox exit condition reached...
			break 
		}
			
;		DEBUG
;		MsgBox, current parsing step: "%newText%.
;		if(A_LoopField == " ")
;			MsgBox, space!

;       determine if the first character is a modifier. if so send two chars in the token		
		if(textArray[index0] ==Chr(58) && textArray[index0+1] !="") {  ;":"
        	newChar := convertchar_EN2GR(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else if(textArray[index0] ==Chr(59) && textArray[index0+1] !="") {    ;";"
    		newChar := convertchar_EN2GR(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else if(textArray[index0] =="W") {
    		newChar := convertchar_EN2GR(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else {
    		newChar := convertchar_EN2GR(textArray[index0])
    	}
		
		index0++
		newText := newText . newChar
    }
	
    return newText
}


convertchar_EN2GR(token) {
	
	StringLen, count0, token
	
	if(count0==2) {

		inp_char2 := SubStr(token,0,1)
		inp_char := SubStr(token,1,1)

;		DEBUG
;		MsgBox in the if for 2 %token% %inp_char% %inp_char2%
		
		if (inp_char==Chr(59)) {    ;";"
;			DEBUG
;			MsgBox in the if for semicolon %input_char% %input_char2%
		 	if (inp_char2=="a") {
				return "ά"
			}
			else if (inp_char2=="e") {
				return "έ"
			}
			else if (inp_char2=="A") {
				return "Ά"
			}
			else if (inp_char2=="h") {
				return "ή"
			}
			else if (inp_char2=="i") {
				return "ί"
			}
			else if (inp_char2=="I") {
				return "Ί"
			}
			else if (inp_char2=="E") {
				return "Έ"
			}
		    else if (inp_char2=="H") {
				return "Ή"
			}
			else if (inp_char2=="o") {
				return "ό"
			}
			else if (inp_char2=="O") {
				return "Ό"
			}
			else if (inp_char2=="y") {
				return "ύ"
			}
			else if (inp_char2=="Y") {
				return "Ύ"
			}
			else if (inp_char2=="v") {
				return "ώ"
			}
			else if (inp_char2=="V") {
				return "Ώ"
			}
		    else {
		    		return "q"
		    	}
		}
		else if (inp_char==Chr(58)) {   ;":"

			if (inp_char2=="i") {
				return "ϊ"
			}
			else if (inp_char2=="I") {
				return "Ϊ"
			}
			else if (inp_char2=="y") {
				return "ϋ"
			}
			else if (inp_char2=="Y") {
				return "Ϋ"
			}
			else {
					return "Q"
				}
		}
	    else if (inp_char=="W") {
		    
		    if (inp_char2=="i") {
				return "ΐ"
			}
		  	else if (inp_char2=="y") {
				return "ΰ"
			}			
			else if (inp_char2=="I") {
				return "΅Ι"
			}
		  	else {
		  		return token
		  	}
	    }
		else {
			return token	
		}
	}
	else {
	
;		DEBUG
;		MsgBox single token to be evaluated: %token%
	
		inp_char := token

	    if (inp_char=="a") {
			return "α"
		}
		else if (inp_char=="A") {
			return "Α"
		}
		else if (inp_char=="b") {
			return "β"
		}
		else if (inp_char=="B") {
			return "Β"
		}
		else if (inp_char=="g") {
			return "γ"
		}
		else if (inp_char=="G") {
			return "Γ"
		}
		else if (inp_char=="d") {
			return "δ"
		}
		else if (inp_char=="D") {
			return "Δ"
		}
		else if (inp_char=="e") {
			return "ε"
		}
		else if (inp_char=="E") {
			return "Ε"
		}
		else if (inp_char=="z") {
			return "ζ"
		}
		else if (inp_char=="Z") {
			return "Ζ"
		}
		else if (inp_char=="h") {
			return "η"
		}
		else if (inp_char=="H") {
			return "Η"
		}
		else if (inp_char=="u") {
			return "θ"
		}
		else if (inp_char=="U") {
			return "Θ"
		}
		else if (inp_char=="i") {
			return "ι"
		}
		else if (inp_char=="I") {
			return "Ι"
		}
		else if (inp_char=="k") {
			return "κ"
		}
		else if (inp_char=="K") {
			return "Κ"
		}
		else if (inp_char=="l") {
			return "λ"
		}
		else if (inp_char=="L") {
			return "Λ"
		}
		else if (inp_char=="m") {
			return "μ"
		}
		else if (inp_char=="M") {
			return "Μ"
		}
		else if (inp_char=="n") {
			return "ν"
		}
		else if (inp_char=="N") {
			return "Ν"
		}
		else if (inp_char=="j") {
			return "ξ"
		}
		else if (inp_char=="J") {
			return "Ξ"
		}
		else if (inp_char=="o") {
			return "ο"
		}
		else if (inp_char=="O") {
			return "Ο"
		}
		else if (inp_char=="p") {
			return "π"
		}
		else if (inp_char=="P") {
			return "Π"
		}
		else if (inp_char=="r") {
			return "ρ"
		}
		else if (inp_char=="R") {
			return "Ρ"
		}
		else if (inp_char=="s") {
			return "σ"
		}
		else if (inp_char=="w") {
			return "ς"
		}
		else if (inp_char=="S") {
			return "Σ"
		}
		else if (inp_char=="t") {
			return "τ"
		}
		else if (inp_char=="T") {
			return "Τ"
		}
		else if (inp_char=="y") {
			return "υ"
		}		
		else if (inp_char=="Y") {
			return "Υ"
		}
		else if (inp_char=="f") {
			return "φ"
		}
		else if (inp_char=="F") {
			return "Φ"
		}
		else if (inp_char=="x") {
			return "χ"
		}
		else if (inp_char=="X") {
			return "Χ"
		}
		else if (inp_char=="c") {
			return "ψ"
		}
		else if (inp_char=="C") {
			return "Ψ"
		}
		else if (inp_char=="v") {
			return "ω"
		}
		else if (inp_char=="V") {
			return "Ω"
		}
		else if (inp_char=="q") {
			return ";"
		}
		else if (inp_char=="Q") {
			return "`:"
		}
		else if (inp_char=="`n") {
			return ""
		}
		else if (inp_char==" ") {
			return " "
		}
		else if (inp_char=="á") { ;		á 'α
			return "`'α"
		}
		else if (inp_char=="Á") { ;		Á 'Α
			return "`'Α"
		}
		else if (inp_char=="é") { ;		é 'ε
			return "'ε"
		}
		else if (inp_char=="É") { ;		É 'Ε
			return "`'Ε"
		}
		else if (inp_char=="í") { ;		í 'ι
			return "`'ι"
		}
		else if (inp_char=="Í") { ;		Í 'Ι
			return "`'Ι"
		}
		else if (inp_char=="ó") { ;		ó 'ο
			return "`'ο"
		}
		else if (inp_char=="Ó") { ;		Ó 'Ο
			return "`'Ο"
		}
		else if (inp_char=="ú") { ;		ú 'θ
			return "`'θ"
		}
		else if (inp_char=="Ú") { ;		Ú 'Θ
			return "`'Θ"
		}
		else if (inp_char=="ý") { ;		ý 'υ
			return "`'υ"
		}
		else if (inp_char=="Ý") { ;		Ý 'Υ
			return "`'Υ"
		}
		else if (inp_char=="ç") { ;		ç 'ψ
			return "`'ψ"
		}
		else if (inp_char=="Ç") { ;		Ç 'Ψ
			return "`'Ψ"
		}
		else if (inp_char=="à") { ;		à `α
			return "``α"
		}
		else if (inp_char=="À") { ;		À `Α
			return "``Α"
		}
		else if (inp_char=="è") { ;		è `ε
			return "``ε"
		}
		else if (inp_char=="È") { ;		È `Ε
			return "``Ε"
		}
		else if (inp_char=="ì") { ;		ì `ι
			return "``ι"
		}
		else if (inp_char=="Ì") { ;		Ì `Ι
			return "``Ι"
		}
		else if (inp_char=="ò") { ;		ò `ο
			return "``ο"
		}
		else if (inp_char=="Ò") { ;		Ò `Ο
			return "``Ο"
		}
		else if (inp_char=="ù") { ;		ù `θ
			return "``θ"
		}
		else if (inp_char=="Ù") { ;		Ù `Θ
			return "``Θ"
		}
		else if (inp_char=="`y") { ;		`y `υ
			return "``υ"
		}
		else if (inp_char=="`Y") { ;		`Y `Υ
			return "``Y"
		}
		else if (inp_char=="ä") { ;		ä "α
			return """α"
		}
		else if (inp_char=="Ä") { ;		Ä "Α
			return """Α"
		}
		else if (inp_char=="ë") { ;		ë "ε
			return """ε"
		}
		else if (inp_char=="Ë") { ;		Ë "Ε
			return """Ε"
		}
		else if (inp_char=="ï") { ;		ï "ι
			return """ι"
		}
		else if (inp_char=="Ï") { ;		Ï "Ι
			return """Ι"
		}
		else if (inp_char=="ö") { ;		ö "ο
			return """ο"
		}
		else if (inp_char=="Ö") { ;		Ö "Ο
			return """Ο"
		}
		else if (inp_char=="ü") { ;		ü "θ
			return """θ"
		}
		else if (inp_char=="Ü") { ;		Ü "Θ
			return """Θ"
		}
		else if (inp_char=="ÿ") { ;		ÿ "υ
			return """υ"
		}
		else if (inp_char=="""Y") { ;	"Y "Υ
			return """Υ"
		}
		else if (inp_char=="â") { ;		â ^α
			return "^α"
		}
		else if (inp_char=="Â") { ;		Â ^Α
			return "^Α"
		}
		else if (inp_char=="ê") { ;		ê ^ε
			return "^ε"
		}
		else if (inp_char=="Ê") { ;		Ê ^Ε
			return "^Ε"
		}
		else if (inp_char=="î") { ;		î ^ι
			return "^ι"
		}
		else if (inp_char=="Î") { ;	Î ^Ι
			return "^Ι"
		}
		else if (inp_char=="ô") { ;		ô ^ο
			return "^ο"
		}
		else if (inp_char=="Ô") { ;		Ô ^Ο
			return "^Ο"
		}
		else if (inp_char=="û") { ;		û ^θ
			return "^θ"
		}
		else if (inp_char=="Û") { ;		Û ^Θ
			return "^Θ"
		}
		else if (inp_char=="^y") { ;		^y ^υ
			return "^υ"
		}
		else if (inp_char=="^Y") { ;		^Y ^Υ
			return "^Υ"
		}
		else if (inp_char=="Wi") { ;		Wi ΐ
			return "ΐ"
		}
		else if (inp_char=="WI") { ;		WI ΅Ι
			return "΅Ι"
		}
		else if (inp_char=="ã") { ;		ã ~α
			return "~α"
		}
		else if (inp_char=="Ã") { ;		Ã ~Α
			return "~Α"
		}
		else if (inp_char=="õ") { ;		õ ~ο
			return "~ο"
		}
		else if (inp_char=="Õ") { ;		Õ ~Ο
			return "~Ο"
		}
		else if (inp_char=="ñ") { ;		ñ ~ν
			return "~ν"
		}
		else if (inp_char=="Ñ") { ;		Ñ ~Ν
			return "~Ν"
		}
		else {
			return token
		}
	}
}