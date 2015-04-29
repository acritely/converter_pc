; Sean Hannon 2015
; sean@acrite.ly
; Script to switch between keyboard inputs (greek/english) 

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, tray, NoStandard
Menu, tray, DeleteAll
Menu, tray, add, &About, InfoMenuHandler
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, &Exit, Exit0

TrayTip, EL<->EN keyboard converter started!,%A_Space%
SetTimer, RemoveTrayTip, 5000

; trigger
Hotkey, ^g, ProcessEN2GR ;for convert english to greek
Hotkey, ^e, ProcessGR2EN ;for convert greek to english
Hotkey, ^+g, Exit0
return

InfoMenuHandler:
MsgBox, 0, Converter 1.1, Welcome to Greek / English Keyboard converter.`n`n To convert text, use the following combinations:`n Control-g --> to convert Greek text to English. `n Control-e --> to convert English text to Greek.`n`n Press Control-Shift-g to exit.`n Send bugs to converter@acrite.ly`nEnjoy! -Sean Hannon 2015
return

Exit0:
MsgBox, 0, Converter 1.1, Greek / English keyboard converter will be closed.
ExitApp 0
return

ProcessGR2EN:
;	select and copy text in active window
ClipBoard = 
Send, ^{vk41}   ; Ctrl-A
Send, ^{vk43}   ; Ctrl-C
ClipWait
clip0 := ClipBoard

;	convert text in clipboard buffer
newText := ConvertGR2EN(clip0)
;put new text into buffer

;    return to buffer
ClipBoard := newText 
Send, ^{vk56}   ; Ctrl-V
Send, {vk27}    ; Right arrow to deselect text... 

;TrayTip, My Title, Multiline`nText, 20, 17
#Persistent
TrayTip, Converted to English text!, %A_Space%
SetTimer, RemoveTrayTip, 5000
return

ProcessEN2GR:
;	select and copy text in active window
ClipBoard = 
Send, ^{vk41}   ; Ctrl-A
Send, ^{vk43}   ; Ctrl-C
ClipWait
clip0 := ClipBoard

;StringLen, count0, clip0 
;MsgBox, Captured %count0% characters:`r`n "%clip0%"

;	convert text in clipboard buffer
newText := ConvertEN2GR(clip0)
;put new text into buffer

;    return to buffer
ClipBoard := newText 
Send, ^{vk56}   ; Ctrl-V
Send, {vk27}    ; Right arrow to deselect text... 

#Persistent
TrayTip, Converted to Greek text!, %A_Space%
SetTimer, RemoveTrayTip, 5000
return

RemoveTrayTip:
SetTimer, RemoveTrayTip, Off
TrayTip
return

ConvertGR2EN(oldText) {

	StringLen, count0, oldText
	
    if ( count0 == 0) 
    	return

    newText := ""

	Loop, parse, oldText,
	{
		;MsgBox, current parsing step: "%newText%.
		;if(A_LoopField == " ")
		;		MsgBox, space!
		;newText = %newText%%A_LoopField%
		newChar := Convertchar_GR2EN(A_LoopField)
		;MsgBox "."%newChar%"."
        newText := newText . newChar
    }
	
    return newText
}

Convertchar_GR2EN(inp_char) {

		;MsgBox current char %inp_char%
		
		if ( inp_char==  Chr(945))         ;"α")
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
		;else if (inp_char== Chr(46))    ;".") 
		;	return "."
		;else if (inp_char== Chr(44))    ;",") 
		;	return ","
		;else if (inp_char== Chr(47))    ;"/") 
		;	return "/"
		;else if (inp_char== Chr(47))    ;"/") 
		;	return "\"
		;else if (inp_char== Chr(946))    ;"[") 
		;	return "["
		;else if (inp_char== Chr(946))    ;"]") 
		;	return "]"
		;else if (inp_char== Chr(946))    ;"'") 
		;	return "'"		
		;else if (inp_char== Chr(946))    ;"\n") 
		;	return ""
	    else if (inp_char==  Chr(32))    ;A_Space) 
		{
			space := Chr(32)
			return %space%
		}
		else {  
			;MsgBox, error %inp_char% not recognized.
			return inp_char
			;out_char := inp_char
		}
		;return out_char
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
			;MsgBox exit condition reached...
			break 
		}
			
		;MsgBox, current parsing step: "%newText%.
		;if(A_LoopField == " ")
		;		MsgBox, space!
		
		;newChar := textArray[index0] ;A_LoopField ; Convertchar_EN2GR(A_LoopField)

		if(textArray[index0] ==Chr(58) && textArray[index0+1] !="") {  ;":"
		    ;MsgBox in the first if
        	newChar := convertchar_EN2GR(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else if(textArray[index0] ==Chr(59) && textArray[index0+1] !="") {    ;";"
		    ;MsgBox in the second if
    		newChar := convertchar_EN2GR(textArray[index0] . textArray[index0+1])
        	index0++
    	}
    	else if(textArray[index0] =="W") {
		    ;MsgBox in the third if
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

		;MsgBox in the if for 2 %token% %inp_char% %inp_char2%
		
		if (inp_char==Chr(59)) {    ;";"
			;MsgBox in the if for semicolon %input_char% %input_char2%
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
		  	else {
		  		return token
		  	}
	    }
		else {
			return token	
		}
	}
	else {
	
		;MsgBox single token to be evaluated: %token%
	
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
			return ":"
		}
		else if (inp_char=="\n") {
			return ""
		}
		else if (inp_char==" ") {
			return " "
		}
		else {
			return token
		}
	}
}	

/*
; U+0374 	ʹ 	Greek Numeral Sign 	0371
; U+0375 	͵ 	Greek Lower Numeral Sign 	0372
; U+037A 	ͺ 	Greek Ypogegrammeni 	0373
; U+037B 	ͻ 	Greek Small Reversed Lunate Sigma Symbol 	
; U+037C 	ͼ 	Greek Small Dotted Lunate Sigma Symbol
; U+037D 	ͽ 	Greek Small Reversed Dotted Lunate Sigma Symbol
; U+037E 	; 	Greek Question Mark 	0374
; U+0384 	΄ 	Greek acute accent (tonos) 	0375
; U+0385 	΅ 	Greek diaeresis with acute accent 	0376
; U+0386 	Ά 	Greek Capital Letter A with acute accent 	0377
; U+0387 	· 	Greek Ano Teleia 	0378
; U+0388 	Έ 	Greek Capital Letter Epsilon with acute accent 	0379
; U+0389 	Ή 	Greek Capital Letter Eta with acute accent 	0380
; U+038A 	Ί 	Greek Capital Letter Iota with acute accent 	0381
; U+038C 	Ό 	Greek Capital Letter Omicron with acute accent 	0382
; U+038E 	Ύ 	Greek Capital Letter Upsilon with acute accent 	0383
; U+038F 	Ώ 	Greek Capital Letter Omega with acute accent 	0384
; U+0390 	ΐ 	Greek Small Letter Iota with diaeresis and acute accent 	0385
; U+0391 	Α 	Greek Capital Letter Alpha 	0386
; U+0392 	Β 	Greek Capital Letter Beta 	0387
; U+0393 	Γ 	Greek Capital Letter Gamma 	0388
; U+0394 	Δ 	Greek Capital Letter Delta 	0389
; U+0395 	Ε 	Greek Capital Letter Epsilon 	0390
; U+0396 	Ζ 	Greek Capital Letter Zeta 	0391
; U+0397 	Η 	Greek Capital Letter Eta 	0392
; U+0398 	Θ 	Greek Capital Letter Theta 	0393
; U+0399 	Ι 	Greek Capital Letter Iota 	0394
; U+039A 	Κ 	Greek Capital Letter Kappa 	0395
; U+039B 	Λ 	Greek Capital Letter Lambda 	0396
; U+039C 	Μ 	Greek Capital Letter Mu 	0397
; U+039D 	Ν 	Greek Capital Letter Nu 	0398
; U+039E 	Ξ 	Greek Capital Letter Xi 	0399
; U+039F 	Ο 	Greek Capital Letter Omicron 	0400
; U+03A0 	Π 	Greek Capital Letter Pi 	0401
; U+03A1 	Ρ 	Greek Capital Letter Rho 	0402
; U+03A3 	Σ 	Greek Capital Letter Sigma 	0403
; U+03A4 	Τ 	Greek Capital Letter Tau 	0404
; U+03A5 	Υ 	Greek Capital Letter Upsilon 	0405
; U+03A6 	Φ 	Greek Capital Letter Phi 	0406
; U+03A7 	Χ 	Greek Capital Letter Chi 	0407
; U+03A8 	Ψ 	Greek Capital Letter Psi 	0408
; U+03A9 	Ω 	Greek Capital Letter Omega 	0409
; U+03AA 	Ϊ 	Greek Capital Letter Iota with diaeresis 	0410
; U+03AB 	Ϋ 	Greek Capital Letter Upsilon with diaeresis 	0411
; U+03AC 	ά 	Greek Small Letter Alpha with acute accent 	0412
; U+03AD 	έ 	Greek Small Letter Epsilon with acute accent 	0413
; U+03AE 	ή 	Greek Small Letter Eta with acute accent 	0414
; U+03AF 	ί 	Greek Small Letter Iota with acute accent 	0415
; U+03B0 	ΰ 	Greek Small Letter Upsilon with diaeresis and acute accent 	0416
; U+03B1 	α 	Greek Small Letter Alpha 	0417
; U+03B2 	β 	Greek Small Letter Beta 	0418
; U+03B3 	γ 	Greek Small Letter Gamma 	0419
; U+03B4 	δ 	Greek Small Letter Delta 	0420
; U+03B5 	ε 	Greek Small Letter Epsilon 	0421
; U+03B6 	ζ 	Greek Small Letter Zeta 	0422
; U+03B7 	η 	Greek Small Letter Eta 	0423
; U+03B8 	θ 	Greek Small Letter Theta 	0424
; U+03B9 	ι 	Greek Small Letter Iota 	0425
; U+03BA 	κ 	Greek Small Letter Kappa 	0426
; U+03BB 	λ 	Greek Small Letter Lambda 	0427
; U+03BC 	μ 	Greek Small Letter Mu 	0428
; U+03BD 	ν 	Greek Small Letter Nu 	0429
; U+03BE 	ξ 	Greek Small Letter Xi 	0430
; U+03BF 	ο 	Greek Small Letter Omicron 	0431
; U+03C0 	π 	Greek Small Letter Pi 	0432
; U+03C1 	ρ 	Greek Small Letter Rho 	0433
; U+03C2 	ς 	Greek Small Letter Final Sigma 	0434
; U+03C3 	σ 	Greek Small Letter Sigma 	0435
; U+03C4 	τ 	Greek Small Letter Tau 	0436
; U+03C5 	υ 	Greek Small Letter Upsilon 	0437
; U+03C6 	φ 	Greek Small Letter Phi 	0438
; U+03C7 	χ 	Greek Small Letter Chi 	0439
; U+03C8 	ψ 	Greek Small Letter Psi 	0440
; U+03C9 	ω 	Greek Small Letter Omega 	0441
; U+03CA 	ϊ 	Greek Small Letter Iota with diaeresis 	0442
; U+03CB 	ϋ 	Greek Small Letter Upsilon with diaeresis 	0443
; U+03CC 	ό 	Greek Small Letter Omicron with acute accent 	0444
; U+03CD 	ύ 	Greek Small Letter Upsilon with acute accent 	0445
; U+03CE 	ώ 	Greek Small Letter Omega with acute accent 	0446
; U+03D0 	ϐ 	Greek Beta Symbol 	
; U+03D1 	ϑ 	Greek Theta Symbol
; U+03D2 	ϒ 	Greek Upsilon with hook Symbol
; U+03D3 	ϓ 	Greek Upsilon with acute and hook Symbol
; U+03D4 	ϔ 	Greek Upsilon with diaeresis and hook Symbol
; U+03D5 	ϕ 	Greek Phi Symbol
; U+03D6 	ϖ 	Greek Pi Symbol
; U+03D7 	ϗ 	Greek Kai Symbol 	0447
; U+03D8 	Ϙ 	Greek Letter Qoppa 	
; U+03D9 	ϙ 	Greek Small Letter Qoppa
; U+03DA 	Ϛ 	Greek Letter Stigma (letter) 	0448
; U+03DB 	ϛ 	Greek Small Letter Stigma 	0449
; U+03DC 	Ϝ 	Greek Letter Digamma 	0450
; U+03DD 	ϝ 	Greek Small Letter Digamma 	0451
; U+03DE 	Ϟ 	Greek Letter Koppa 	0452
; U+03DF 	ϟ 	Greek Small Letter Koppa 	0453
; U+03E0 	Ϡ 	Greek Letter Sampi 	0454
; U+03E1 	ϡ
*/