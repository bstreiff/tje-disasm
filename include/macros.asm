; 'NOPS' is a shorthand for repeating NOPs, e.g. for delays
NOPS	MACRO count
	REPT \1
	NOP
	ENDR
	ENDM
