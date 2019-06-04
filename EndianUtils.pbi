
; FIXME: --------------------------------
; This include will be moved in another repo that will be included as a submodule by this one later.
; Keep this in mind if you use this include !
; FIXME: --------------------------------

;EnableExplicit

; Original ASM code for .l
; https://www.purebasic.fr/english/viewtopic.php?f=19&t=17427

;- Macros

Macro EndianSwap(Number)
	CompilerSelect TypeOf(Number)
		CompilerCase #PB_Word
			EndianSwapW(Number)
		CompilerCase #PB_Long
			EndianSwapL(Number)
		CompilerDefault
			CompilerError "Unsupported value type given in '+EndianSwap(Number)' !"
	CompilerEndSelect
EndMacro


;- Procedures

Procedure.l EndianSwapW(Number.l)
	EnableASM
		MOV ax,Number
		XCHG al,ah
		MOV Number,ax
	DisableASM
	
	ProcedureReturn Number
EndProcedure

; FIXME: Should x64 use 'rax' or does it supports 'eax' too ?
Procedure.l EndianSwapL(Number.l)
	EnableASM
		MOV eax,Number
		BSWAP eax
		MOV Number,eax
	DisableASM
	
	ProcedureReturn Number
EndProcedure


;- Tests

CompilerIf #PB_Compiler_IsMainFile
	Debug "Word:"
	
	Debug "0d42" + #TAB$ + 
	      "0x"+RSet(Hex(42, #PB_Long), 2*2, "0") + #TAB$ + " ->" + #TAB$ +
	      "0x"+RSet(Hex(EndianSwapL(42), #PB_Long), 2*2, "0")
	Debug "0d420" + #TAB$ + 
	      "0x"+RSet(Hex(420, #PB_Long), 2*2, "0") + #TAB$ + " ->" + #TAB$ +
	      "0x"+RSet(Hex(EndianSwapL(420), #PB_Long), 2*2, "0")
	
	
	Debug "Long:"
	
	Debug "0d42" + #TAB$ + 
	      "0x"+RSet(Hex(42, #PB_Long), 4*2, "0") + #TAB$ + " ->" + #TAB$ +
	      "0x"+RSet(Hex(EndianSwapL(42), #PB_Long), 4*2, "0")
	Debug "0d420" + #TAB$ + 
	      "0x"+RSet(Hex(420, #PB_Long), 4*2, "0") + #TAB$ + " ->" + #TAB$ +
	      "0x"+RSet(Hex(EndianSwapL(420), #PB_Long), 4*2, "0")
	
CompilerEndIf

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP