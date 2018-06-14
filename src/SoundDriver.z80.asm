; ---------------------------------------------------------------------
; Z80 source code for the sound driver in Toejam & Earl.
;
; This entire program gets loaded into the Z80 RAM.
; ---------------------------------------------------------------------

Z80_RAM_START		equ $0000
Z80_RAM_END		equ $1FFF
YM2612_P0_ADDR		equ $4000
YM2612_P0_DATA		equ $4001
YM2612_P1_ADDR		equ $4002
YM2612_P1_DATA		equ $4003
BANK_REG		equ $6000
PSG_REG			equ $7F11
M68K_BANK_START		equ $8000
M68K_BANK_END		equ $FFFF

PSG_DATA		equ (0 << 7)
PSG_LATCH		equ (1 << 7)
PSG_CH0			equ (0 << 5)
PSG_CH1			equ (1 << 5)
PSG_CH2			equ (2 << 5)
PSG_CH3			equ (3 << 5)
PSG_TONE		equ (0 << 4)
PSG_VOLUME		equ (1 << 4)

	include	ym2612.asm

	IM	1			; interrupt mode 1
	DI				; disable interrupts
	LD	SP, Z80_RAM_END+1	; load stack pointer
	JP	Start

	; zero fill to get to offset $0038
	dcb.b	$2F, $00

; ---------------------------------------------------------------------
; In mode 1, interrupts are a CALL to this location.
; Since we don't use interrupts, it's just an immediate return.
; ---------------------------------------------------------------------
InterruptVector:			; offset $0038
	RET

; ---------------------------------------------------------------------

	; zero fill
	dcb.b	$07, $00

; these are used for variables
var_0040:
	dc.b	$00
var_0041:
	dc.b	$00
var_0042:
	dc.b	$00
var_0043:
	dc.b	$00
var_0044:
	dc.b	$00
var_0045:
	dc.b	$00
var_0046:
	dc.b	$00
var_0047:
	dc.b	$00
var_0048:
	dc.b	$00
var_0049:
	dc.b	$00
var_004A:
	dc.b	$00
var_004B:
	dc.b	$00
var_004C:
	dc.b	$00
var_004D:
	dc.b	$00
var_004E:
	dc.b	$00
var_004F:
	dc.b	$00
var_0050:
	dc.b	$00
var_0051:
	dc.b	$00
var_0052:
	dc.b	$00
var_0053:
	dc.b	$00
var_0054:
	dc.b	$00

	; more zero-filling
	dcb.b	$11, $00
	RETN

; ---------------------------------------------------------------------

Start:
	XOR	A			; set A = 0
	LD	(var_0041), A		; initialize var_0041 to 0
	LD	(var_0040), A		; initialize var_0040 to 0
	LD	(var_0054), A		; initialize var_0054 to 0
	CALL	proc_01A2
	LD	HL, YM2612_P0_ADDR
	LD	(HL), YM2612_REG_DACENBL
	INC	HL			; HL now YM2612_P0_DATA
	LD	(HL), YM2612_DACENBL_ENABLE
	DEC	HL			; HL now YM2612_P0_ADDR
	LD	(HL), YM2612_REG_DACDATA
	INC	HL			; HL now YM2612_P0_DATA
	LD	(HL), $20
	LD	C, $05
	CALL	proc_0189
	LD	(HL), $40
	LD	C, $05
	CALL	proc_0189
	LD	(HL), $80
	DEC	HL			; HL now YM2612_P0_ADDR
	LD	(HL), YM2612_REG_DACENBL
	INC	HL			; HL now YM2612_P0_DATA
	LD	(HL), 0
proc_0097:
	LD	A, (var_0040)
	CP	$01
	JP	Z, .proc_00A7
	CP	$02
	JP	Z, .proc_00E5
	JP	proc_0097
.proc_00A7:
	XOR	A
	LD	(var_0040), A
	CALL	proc_01A2
	LD	A, $0F
	LD	(var_004B), A
	LD	A, (var_0042)
	CP	$1E
	JP	NC, proc_0097
	LD	HL, JumpTable
	CCF
	RLA
	LD	C, A
	LD	B, $00
	ADD	HL, BC
	LD	D, (HL)
	INC	HL
	LD	E, (HL)
	LD	HL, .proc_00D0
	PUSH	HL
	PUSH	DE
	LD	HL, PSG_REG
	RET
.proc_00D0:
	XOR	A
	LD	(var_004B), A
	LD	A, (var_0054)
	OR	A
	JR	Z, proc_0097
	LD	(HL), $E7
	LD	(HL), $CF
	LD	(HL), $07
	LD	(HL), $F4
	JP	proc_0097
.proc_00E5:
	LD	A, $01
	LD	(var_0041), A
	LD	HL, (var_0048)
	EX	DE, HL
	LD	A, (var_0046)
	LD	(var_0052), A
	LD	HL, (var_0044)
	LD	(var_0050), HL
	LD	C, A
	XOR	A
	LD	(var_0040), A
	LD	(var_0041), A
	CALL	proc_0174
	LD	A, H
	OR	$80
	LD	H, A
	LD	BC, $4000
	LD	A, $2B
	LD	(BC), A
	LD	A, $80
	LD	(YM2612_P0_DATA), A
	EXX
	LD	E, $04
	LD	HL, var_004A
	LD	(HL), E
	EXX
.proc_011C:
	LD	A, $2A
	LD	(BC), A
	LD	A, (HL)
	LD	(YM2612_P0_DATA), A
	INC	HL
	LD	A, H
	OR	L
	JP	Z, .proc_0156
	EXX
.proc_012A:
	LD	A, (var_0040)
	OR	A
	JP	NZ, .proc_0140
	NOP
	DEC	(HL)
	LD	A, (HL)
	OR	A
	JP	P, .proc_012A
	LD	(HL), E
	EXX
.proc_013A:
	DEC	DE
	LD	A, D
	OR	E
	JP	NZ, .proc_011C
.proc_0140:
	LD	BC, YM2612_P0_ADDR
	LD	A, YM2612_REG_DACDATA
	LD	(BC), A
	LD	A, $80
	LD	(YM2612_P0_DATA), A
	LD	A, YM2612_REG_DACENBL
	LD	(BC), A
	LD	A, 0			; disable DAC
	LD	(YM2612_P0_DATA), A
	JP	proc_0097
.proc_0156:
	CALL	proc_0162
	LD	HL, M68K_BANK_START
	LD	BC, YM2612_P0_ADDR
	JP	.proc_013A

proc_0162:
	LD	A, (var_0051)
	ADD	A, $80
	LD	(var_0051), A
	LD	H, A
	LD	A, (var_0052)
	ADC	A, $00
	LD	C, A
	LD	(var_0052), A
proc_0174:
	LD	A, H
	RLCA
	AND	$01
	LD	(BANK_REG), A
	LD	A, C
	LD	B, $08
.proc_017E:
	LD	C, A
	AND	$01
	LD	(BANK_REG), A
	LD	A, C
	RRA
	DJNZ	.proc_017E	; decrement B, jump if not zero
	RET

; Inputs: C (seems to be some sort of repeat count)
proc_0189:
	LD	B, $54
.proc_018B:
	LD	A, (var_0040)
	OR	A
	JP	NZ, proc_0199
	DJNZ	.proc_018B	; decrement B, jump if not zero
	DEC	C
	JP	NZ, proc_0189
	RET

proc_0199:
	LD	SP, Z80_RAM_END+1
	CALL	proc_01A2
	JP	proc_0097

proc_01A2:
	LD	HL, PSG_REG
	LD	(HL), PSG_LATCH | PSG_CH0 | PSG_VOLUME | $F
	LD	(HL), PSG_LATCH | PSG_CH1 | PSG_VOLUME | $F
	LD	(HL), PSG_LATCH | PSG_CH2 | PSG_VOLUME | $F
	LD	(HL), PSG_LATCH | PSG_CH3 | PSG_VOLUME | $F
	XOR	A
	LD	(var_004B), A
	RET

proc_01B2:
	LD	(HL), $84
	LD	(HL), $0A
	LD	D, $90
	LD	(HL), D
	LD	(HL), $A0
	LD	(HL), $0A
	LD	(HL), $BB
.proc_01BF:
	LD	C, $72
	CALL	proc_0189
	INC	D
	LD	(HL), D
	LD	A, $9F
	CP	D
	JP	NZ, .proc_01BF
	LD	(HL), $9F
	LD	(HL), $BF
	RET

proc_01D1:
	LD	(HL), $E7
	LD	B, $F0
	LD	(HL), B
	LD	DE, $C002
.proc_01D9:
	LD	(HL), D
	LD	(HL), E
	INC	D
	LD	A, $CF
	CP	D
	JP	NZ, .proc_01ED
	LD	D, $C0
	INC	E
	LD	A, E
	AND	$01
	JP	NZ, .proc_01ED
	INC	B
	LD	(HL), B
.proc_01ED:
	EXX
	LD	C, $12
	CALL	proc_0189
	EXX
	LD	A, E
	CP	$06
	JP	NZ, .proc_01D9
	LD	(HL), $FF
	RET

proc_01FD:
	LD	(HL), $90
	LD	DE, $8001
.proc_0202:
	LD	(HL), D
	LD	(HL), E
	LD	C, $18
	CALL	proc_0189
	INC	D
	LD	A, D
	CP	$8F
	JP	NZ, .proc_0202
	LD	(HL), $9F
	RET

proc_0213:
	LD	(HL), $E4
	LD	D, $F0
	LD	E, $0F
.proc_0219:
	LD	(HL), D
	LD	C, E
	CALL	proc_0189
	LD	A, $0F
	ADD	A, E
	LD	E, A
	INC	D
	LD	A, $FF
	CP	D
	JP	NZ, .proc_0219
	LD	(HL), D
	RET

proc_022B:
	LD	(HL), $E6
	LD	D, $F0
	LD	E, $08
.proc_0231:
	LD	(HL), D
	LD	C, E
	CALL	proc_0189
	LD	A, $0C
	ADD	A, E
	LD	E, A
	INC	D
	LD	A, $FF
	CP	D
	JP	NZ, .proc_0231
	LD	(HL), D
	RET

proc_0243:
	LD	(HL), $E7
	LD	B, $F0
	LD	(HL), B
	LD	DE, $C000
.proc_024B:
	LD	(HL), D
	LD	(HL), E
	INC	D
	LD	A, $CF
	CP	D
	JP	NZ, .proc_025F
	LD	D, $C0
	INC	E
	LD	A, E
	AND	$01
	JP	NZ, .proc_025F
	INC	B
	LD	(HL), B
.proc_025F:
	EXX
	LD	C, $0A
	CALL	proc_0189
	EXX
	LD	A, E
	CP	$0C
	JP	NZ, .proc_024B
	LD	(HL), $FF
	RET

proc_026F:
	LD	(HL), $E4
	LD	D, $F0
	LD	E, $12
.proc_0275:
	LD	(HL), D
	LD	C, E
	CALL	proc_0189
	LD	A, $05
	ADD	A, E
	LD	E, A
	INC	D
	LD	A, $FF
	CP	D
	JP	NZ, .proc_0275
	LD	(HL), D
	RET

proc_0287:
	LD	(HL), $E7
	LD	B, $F0
	LD	(HL), B
	LD	DE, $C000
.proc_028F:
	LD	(HL), D
	LD	(HL), E
	LD	A, $CF
	CP	D
	JP	NZ, .proc_02A2
	LD	D, $BF
	INC	E
	LD	A, E
	AND	$01
	JP	NZ, .proc_02A2
	INC	B
	LD	(HL), B
.proc_02A2:
	INC	D
	EXX
	LD	C, $0A
	CALL	proc_0189
	EXX
	LD	A, B
	CP	$FC
	JP	NZ, .proc_028F
	RET

proc_02B1:
	LD	(HL), $E7
	LD	(HL), $F3
	LD	DE, $CF06
.proc_02B8:
	LD	(HL), D
	LD	(HL), E
	LD	C, $02
	CALL	proc_0189
	DEC	D
	LD	A, $BF
	CP	D
	JP	NZ, .proc_02B8
	LD	D, $CF
	DEC	E
	JP	NZ, .proc_02B8
	JP	proc_01A2

proc_02CF:
	LD	(HL), $94
	LD	DE, $8001
.proc_02D4:
	LD	(HL), D
	LD	(HL), E
	LD	C, $08
	CALL	proc_0189
	INC D
	LD	A, D
	CP	$8F
	JP	NZ, .proc_02D4
	LD	DE, $8002
.proc_02E5:
	LD	(HL), D
	LD	(HL), E
	LD	C, $08
	CALL	proc_0189
	INC	D
	LD	A, D
	CP	$8F
	JP	NZ, .proc_02E5
	LD	(HL), $9F
	RET

proc_02F6:
	LD	A, $01
	LD	(var_0054), A
	LD	(HL), $E7
	LD	B, $F0
	LD	(HL), B
	LD	DE, $C000
.proc_0303:
	LD	(HL), D
	LD	(HL), E
	LD	A, $CF
	CP	D
	JP	NZ, .proc_0316
	LD	D, $BF
	INC	E
	LD	A, E
	AND	$01
	JP	NZ, .proc_0316
	INC	B
	LD	(HL), B
.proc_0316:
	INC	D
	EXX
	LD	C, $0A
	CALL	proc_0189
	EXX
	LD	A, B
	CP	$F4
	JP	NZ, .proc_0303
	RET

proc_0325:
	XOR	A
	LD	(var_0054), A
	JP	proc_01A2

proc_032C:
	LD	(HL), $AC
	LD	(HL), $08
	LD	(HL), $B2
	LD	C, $0A
	CALL	proc_0189
	JP	proc_01A2

proc_033A:
	LD	(HL), $A0
	LD	(HL), $0A
	LD	(HL), $B1
	LD	C, $0F
	CALL	proc_0189
	CALL	proc_01A2
	LD	C, $0A
	CALL	proc_0189
	LD	(HL), $AC
	LD	(HL), $08
	LD	(HL), $B1
	LD	C, $1E
	CALL	proc_0189
	JP	proc_01A2

proc_035B:
	LD	(HL), $A0
	LD	(HL), $0F
	LD	(HL), $B0
	LD	C, $0A
	CALL	proc_0189
	LD	(HL), $BF
	LD	C, $0A
	CALL	proc_0189
	LD	(HL), $AC
	LD	(HL), $0A
	LD	(HL), $B0
	LD	C, $14
	CALL	proc_0189
	JP	proc_01A2

proc_037B:
	LD	(HL), $E6
	LD	D, $F0
.proc_037F:
	LD	(HL), D
	LD	C, $1B
	CALL	proc_0189
	INC	D
	LD	A, $FF
	CP	D
	JP	NZ, .proc_037F
	LD	(HL), D
	RET

proc_038E:
	LD	DE, $AC18
.proc_0391:
	LD	(HL), $B0
	LD	(HL), D
	LD	(HL), E
	LD	C, $0F
	CALL	proc_0189
	LD	(HL), $BF
	LD	C, $1E
	CALL	proc_0189
	DEC	E
	JP	NZ, .proc_0391
	JP	proc_01A2

proc_03A8:
	LD	E, $09
	LD	(HL), $E4
	LD	(HL), $A0
	LD	(HL), $38
.proc_03B0:
	LD	(HL), $B3
	LD	(HL), $F0
	LD	C, $06
	CALL	proc_0189
	LD	(HL), $BF
	LD	(HL), $FF
	LD	C, $06
	CALL	proc_0189
	DEC	E
	JP	NZ, .proc_03B0
	RET

proc_03C7:
	LD	(HL), $E4
	LD	(HL), $A0
	LD	(HL), $38
	LD	(HL), $B2
	LD	D, $FF
.proc_03D1:
	LD	(HL), D
	LD	C, $1B
	CALL	proc_0189
	DEC	D
	LD	A, D
	CP	$F0
	JP	NZ, .proc_03D1
	LD	(HL), $BF
	LD	C, $23
	CALL	proc_0189
	JP	proc_01A2

proc_03E8:
	LD	(HL), $A0
	LD	(HL), $08
	LD	(HL), $B2
	LD	C, $1B
	CALL	proc_0189
	LD	(HL), $A0
	LD	(HL), $06
	LD	(HL), $B1
	LD	C, $1B
	CALL	proc_0189
	LD	(HL), $A0
	LD	(HL), $04
	LD	(HL), $B0
	LD	C, $1B
	CALL	proc_0189
	LD	(HL), $A0
	LD	(HL), $06
	LD	(HL), $B1
	LD	C, $1B
	CALL	proc_0189
	LD	D, $B2
.proc_0416:
	LD	(HL), $A0
	LD	(HL), $08
	LD	(HL), D
	LD	C, $1B
	CALL	proc_0189
	INC	D
	LD	A, D
	CP	$B7
	JP	NZ, .proc_0416
	JP	proc_01A2

proc_042A:
	LD	DE, $AC18
	LD	(HL), $B0
.proc_042F:
	LD	(HL), D
	LD	(HL), E
	LD	C, $0C
	CALL	proc_0189
	DEC	E
	LD	A, E
	CP	$06
	JP	NZ, .proc_042F
	JP	proc_01A2

proc_0440:
	LD	DE, $AC28
	LD	(HL), $B2
.proc_0445:
	LD	(HL), D
	LD	(HL), E
	LD	C, $0C
	CALL	proc_0189
	DEC	E
	LD	A, E
	CP	$06
	JP	NZ, .proc_0445
	JP	proc_01A2

proc_0456:
	LD	(HL), $E4
	LD	D, $FF
.proc_045A:
	LD	(HL), D
	LD	C, $08
	CALL	proc_0189
	DEC	D
	LD	A, D
	CP	$F1
	JP	NZ, .proc_045A
	LD	C, $0F
	CALL	proc_0189
	JP	proc_01A2

proc_046F:
	LD	(HL), $E4
	LD	D, $FF
.proc_0473:
	LD	(HL), D
	LD	C, $0C
	CALL	proc_0189
	DEC	D
	LD	A, D
	CP	$F2
	JP	NZ, .proc_0473
	LD	C, $10
	CALL	proc_0189
	LD	(HL), $F7
	LD	C, $07
	CALL	proc_0189
	LD	(HL), $F0
	LD	C, $05
	CALL	proc_0189
	JP	proc_01A2
	LD	(HL), $E0
	LD	(HL), $F0
	LD	C, $C8
	CALL	proc_0189
	JP	proc_01A2

proc_04A2:
	LD	(HL), $E2
	LD	(HL), $F0
	LD	C, $C8
	CALL	proc_0189
	JP	proc_01A2

proc_04AE:
	LD	(HL), $E1
	LD	(HL), $F0
	LD	C, $C8
	CALL	proc_0189
	JP	proc_01A2

proc_04BA:
	LD	(HL), $E3
	LD	(HL), $F0
	LD	(HL), $C0
	LD	(HL), $05
	LD	C, $C8
	CALL	proc_0189
	JP	proc_01A2

; macro for inserting the addresses into the jump table
; in the expected byte order
jtarget	MACRO procsym
	dc.b >(\1), <(\1)
	ENDM

JumpTable:		; 34 entries
	jtarget proc_01A2
	jtarget	proc_033A
	jtarget	proc_02CF
	jtarget	proc_0287
	jtarget	proc_02B1
	jtarget	proc_02F6
	jtarget	proc_0325
	jtarget	proc_032C
	jtarget	proc_01D1
	jtarget	proc_01FD
	jtarget	proc_0213
	jtarget	proc_022B
	jtarget	proc_0243
	jtarget	proc_026F
	jtarget	proc_035B
	jtarget	proc_01B2
	jtarget	proc_037B
	jtarget	proc_038E
	jtarget	proc_03A8
	jtarget	proc_03C7
	jtarget	proc_03E8
	jtarget	proc_042A
	jtarget	proc_0440
	jtarget	proc_0456
	jtarget	proc_046F
	jtarget	proc_04A2
	jtarget	proc_04BA
	jtarget	proc_01A2
	jtarget	proc_01A2
	jtarget	proc_01A2
	jtarget	proc_01A2
	jtarget	proc_01A2
	jtarget	proc_01A2
	jtarget	proc_01A2
