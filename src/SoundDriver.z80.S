/* ------------------------------------------------------------------
   Z80 source code for the sound driver in Toejam & Earl.
  
   This entire program gets loaded into the Z80 RAM.
   ------------------------------------------------------------------ */

#define PSG_DATA		(0 << 7)|0
#define PSG_LATCH		(1 << 7)|0
#define PSG_CH0			(0 << 5)|0
#define PSG_CH1			(1 << 5)|0
#define PSG_CH2			(2 << 5)|0
#define PSG_CH3			(3 << 5)|0
#define PSG_TONE		(0 << 4)|0
#define PSG_VOLUME		(1 << 4)|0

#include "asm/z80_regs.h"
#include "asm/ym2612_regs.h"

	IM	1			/* interrupt mode 1 */
	DI				/* disable interrupts */
	LD	SP, Z80_RAM_END+1	/* load stack pointer */
	JP	Start

	/* zero fill to get to offset 0x0038 */
	.fill	0x2F, 1, 0x00

/* ------------------------------------------------------------------
   In mode 1, interrupts are a CALL to this location.
   Since we don't use interrupts, it's just an immediate return.
   ------------------------------------------------------------------ */
InterruptVector:			/* offset 0x0038 */
	RET

/* ------------------------------------------------------------------ */

	/* zero fill */
	.fill	0x07, 1, 0x00

/* these are used for variables */
var_0040:
	dc.b	0x00
var_0041:
	dc.b	0x00
var_0042:
	dc.b	0x00
var_0043:
	dc.b	0x00
var_0044:
	dc.b	0x00
var_0045:
	dc.b	0x00
var_0046:
	dc.b	0x00
var_0047:
	dc.b	0x00
var_0048:
	dc.b	0x00
var_0049:
	dc.b	0x00
var_004A:
	dc.b	0x00
var_004B:
	dc.b	0x00
var_004C:
	dc.b	0x00
var_004D:
	dc.b	0x00
var_004E:
	dc.b	0x00
var_004F:
	dc.b	0x00
var_0050:
	dc.b	0x00
var_0051:
	dc.b	0x00
var_0052:
	dc.b	0x00
var_0053:
	dc.b	0x00
var_0054:
	dc.b	0x00

	/* more zero-filling */
	dcb.b	0x11, 0x00
	RETN

/* ------------------------------------------------------------------ */

Start:
	XOR	A			/* set A = 0 */
	LD	(var_0041), A		/* initialize var_0041 to 0 */
	LD	(var_0040), A		/* initialize var_0040 to 0 */
	LD	(var_0054), A		/* initialize var_0054 to 0 */
	CALL	proc_01A2
	LD	HL, YM2612_P0_ADDR
	LD	(HL), YM2612_REG_DACENBL
	INC	HL			/* HL now YM2612_P0_DATA */
	LD	(HL), YM2612_DACENBL_ENABLE
	DEC	HL			/* HL now YM2612_P0_ADDR */
	LD	(HL), YM2612_REG_DACDATA
	INC	HL			/* HL now YM2612_P0_DATA */
	LD	(HL), 0x20
	LD	C, 0x05
	CALL	proc_0189
	LD	(HL), 0x40
	LD	C, 0x05
	CALL	proc_0189
	LD	(HL), 0x80
	DEC	HL			/* HL now YM2612_P0_ADDR */
	LD	(HL), YM2612_REG_DACENBL
	INC	HL			/* HL now YM2612_P0_DATA */
	LD	(HL), 0
proc_0097:
	LD	A, (var_0040)
	CP	0x01
	JP	Z, .proc_00A7
	CP	0x02
	JP	Z, .proc_00E5
	JP	proc_0097
.proc_00A7:
	XOR	A
	LD	(var_0040), A
	CALL	proc_01A2
	LD	A, 0x0F
	LD	(var_004B), A
	LD	A, (var_0042)
	CP	0x1E
	JP	NC, proc_0097
	LD	HL, JumpTable
	CCF
	RLA
	LD	C, A
	LD	B, 0x00
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
	LD	(HL), 0xE7
	LD	(HL), 0xCF
	LD	(HL), 0x07
	LD	(HL), 0xF4
	JP	proc_0097
.proc_00E5:
	LD	A, 0x01
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
	OR	0x80
	LD	H, A
	LD	BC, 0x4000
	LD	A, 0x2B
	LD	(BC), A
	LD	A, 0x80
	LD	(YM2612_P0_DATA), A
	EXX
	LD	E, 0x04
	LD	HL, var_004A
	LD	(HL), E
	EXX
.proc_011C:
	LD	A, 0x2A
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
	LD	A, 0x80
	LD	(YM2612_P0_DATA), A
	LD	A, YM2612_REG_DACENBL
	LD	(BC), A
	LD	A, 0			/* disable DAC */
	LD	(YM2612_P0_DATA), A
	JP	proc_0097
.proc_0156:
	CALL	proc_0162
	LD	HL, M68K_BANK_START
	LD	BC, YM2612_P0_ADDR
	JP	.proc_013A

proc_0162:
	LD	A, (var_0051)
	ADD	A, 0x80
	LD	(var_0051), A
	LD	H, A
	LD	A, (var_0052)
	ADC	A, 0x00
	LD	C, A
	LD	(var_0052), A
proc_0174:
	LD	A, H
	RLCA
	AND	0x01
	LD	(BANK_REG), A
	LD	A, C
	LD	B, 0x08
.proc_017E:
	LD	C, A
	AND	0x01
	LD	(BANK_REG), A
	LD	A, C
	RRA
	DJNZ	.proc_017E	/* decrement B, jump if not zero */
	RET

/* Inputs: C (seems to be some sort of repeat count) */
proc_0189:
	LD	B, 0x54
.proc_018B:
	LD	A, (var_0040)
	OR	A
	JP	NZ, proc_0199
	DJNZ	.proc_018B	/* decrement B, jump if not zero */
	DEC	C
	JP	NZ, proc_0189
	RET

proc_0199:
	LD	SP, Z80_RAM_END+1
	CALL	proc_01A2
	JP	proc_0097

proc_01A2:
	LD	HL, PSG_REG
	LD	(HL), PSG_LATCH | PSG_CH0 | PSG_VOLUME | 0xF
	LD	(HL), PSG_LATCH | PSG_CH1 | PSG_VOLUME | 0xF
	LD	(HL), PSG_LATCH | PSG_CH2 | PSG_VOLUME | 0xF
	LD	(HL), PSG_LATCH | PSG_CH3 | PSG_VOLUME | 0xF
	XOR	A
	LD	(var_004B), A
	RET

proc_01B2:
	LD	(HL), 0x84
	LD	(HL), 0x0A
	LD	D, 0x90
	LD	(HL), D
	LD	(HL), 0xA0
	LD	(HL), 0x0A
	LD	(HL), 0xBB
.proc_01BF:
	LD	C, 0x72
	CALL	proc_0189
	INC	D
	LD	(HL), D
	LD	A, 0x9F
	CP	D
	JP	NZ, .proc_01BF
	LD	(HL), 0x9F
	LD	(HL), 0xBF
	RET

proc_01D1:
	LD	(HL), 0xE7
	LD	B, 0xF0
	LD	(HL), B
	LD	DE, 0xC002
.proc_01D9:
	LD	(HL), D
	LD	(HL), E
	INC	D
	LD	A, 0xCF
	CP	D
	JP	NZ, .proc_01ED
	LD	D, 0xC0
	INC	E
	LD	A, E
	AND	0x01
	JP	NZ, .proc_01ED
	INC	B
	LD	(HL), B
.proc_01ED:
	EXX
	LD	C, 0x12
	CALL	proc_0189
	EXX
	LD	A, E
	CP	0x06
	JP	NZ, .proc_01D9
	LD	(HL), 0xFF
	RET

proc_01FD:
	LD	(HL), 0x90
	LD	DE, 0x8001
.proc_0202:
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x18
	CALL	proc_0189
	INC	D
	LD	A, D
	CP	0x8F
	JP	NZ, .proc_0202
	LD	(HL), 0x9F
	RET

proc_0213:
	LD	(HL), 0xE4
	LD	D, 0xF0
	LD	E, 0x0F
.proc_0219:
	LD	(HL), D
	LD	C, E
	CALL	proc_0189
	LD	A, 0x0F
	ADD	A, E
	LD	E, A
	INC	D
	LD	A, 0xFF
	CP	D
	JP	NZ, .proc_0219
	LD	(HL), D
	RET

proc_022B:
	LD	(HL), 0xE6
	LD	D, 0xF0
	LD	E, 0x08
.proc_0231:
	LD	(HL), D
	LD	C, E
	CALL	proc_0189
	LD	A, 0x0C
	ADD	A, E
	LD	E, A
	INC	D
	LD	A, 0xFF
	CP	D
	JP	NZ, .proc_0231
	LD	(HL), D
	RET

proc_0243:
	LD	(HL), 0xE7
	LD	B, 0xF0
	LD	(HL), B
	LD	DE, 0xC000
.proc_024B:
	LD	(HL), D
	LD	(HL), E
	INC	D
	LD	A, 0xCF
	CP	D
	JP	NZ, .proc_025F
	LD	D, 0xC0
	INC	E
	LD	A, E
	AND	0x01
	JP	NZ, .proc_025F
	INC	B
	LD	(HL), B
.proc_025F:
	EXX
	LD	C, 0x0A
	CALL	proc_0189
	EXX
	LD	A, E
	CP	0x0C
	JP	NZ, .proc_024B
	LD	(HL), 0xFF
	RET

proc_026F:
	LD	(HL), 0xE4
	LD	D, 0xF0
	LD	E, 0x12
.proc_0275:
	LD	(HL), D
	LD	C, E
	CALL	proc_0189
	LD	A, 0x05
	ADD	A, E
	LD	E, A
	INC	D
	LD	A, 0xFF
	CP	D
	JP	NZ, .proc_0275
	LD	(HL), D
	RET

proc_0287:
	LD	(HL), 0xE7
	LD	B, 0xF0
	LD	(HL), B
	LD	DE, 0xC000
.proc_028F:
	LD	(HL), D
	LD	(HL), E
	LD	A, 0xCF
	CP	D
	JP	NZ, .proc_02A2
	LD	D, 0xBF
	INC	E
	LD	A, E
	AND	0x01
	JP	NZ, .proc_02A2
	INC	B
	LD	(HL), B
.proc_02A2:
	INC	D
	EXX
	LD	C, 0x0A
	CALL	proc_0189
	EXX
	LD	A, B
	CP	0xFC
	JP	NZ, .proc_028F
	RET

proc_02B1:
	LD	(HL), 0xE7
	LD	(HL), 0xF3
	LD	DE, 0xCF06
.proc_02B8:
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x02
	CALL	proc_0189
	DEC	D
	LD	A, 0xBF
	CP	D
	JP	NZ, .proc_02B8
	LD	D, 0xCF
	DEC	E
	JP	NZ, .proc_02B8
	JP	proc_01A2

proc_02CF:
	LD	(HL), 0x94
	LD	DE, 0x8001
.proc_02D4:
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x08
	CALL	proc_0189
	INC D
	LD	A, D
	CP	0x8F
	JP	NZ, .proc_02D4
	LD	DE, 0x8002
.proc_02E5:
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x08
	CALL	proc_0189
	INC	D
	LD	A, D
	CP	0x8F
	JP	NZ, .proc_02E5
	LD	(HL), 0x9F
	RET

proc_02F6:
	LD	A, 0x01
	LD	(var_0054), A
	LD	(HL), 0xE7
	LD	B, 0xF0
	LD	(HL), B
	LD	DE, 0xC000
.proc_0303:
	LD	(HL), D
	LD	(HL), E
	LD	A, 0xCF
	CP	D
	JP	NZ, .proc_0316
	LD	D, 0xBF
	INC	E
	LD	A, E
	AND	0x01
	JP	NZ, .proc_0316
	INC	B
	LD	(HL), B
.proc_0316:
	INC	D
	EXX
	LD	C, 0x0A
	CALL	proc_0189
	EXX
	LD	A, B
	CP	0xF4
	JP	NZ, .proc_0303
	RET

proc_0325:
	XOR	A
	LD	(var_0054), A
	JP	proc_01A2

proc_032C:
	LD	(HL), 0xAC
	LD	(HL), 0x08
	LD	(HL), 0xB2
	LD	C, 0x0A
	CALL	proc_0189
	JP	proc_01A2

proc_033A:
	LD	(HL), 0xA0
	LD	(HL), 0x0A
	LD	(HL), 0xB1
	LD	C, 0x0F
	CALL	proc_0189
	CALL	proc_01A2
	LD	C, 0x0A
	CALL	proc_0189
	LD	(HL), 0xAC
	LD	(HL), 0x08
	LD	(HL), 0xB1
	LD	C, 0x1E
	CALL	proc_0189
	JP	proc_01A2

proc_035B:
	LD	(HL), 0xA0
	LD	(HL), 0x0F
	LD	(HL), 0xB0
	LD	C, 0x0A
	CALL	proc_0189
	LD	(HL), 0xBF
	LD	C, 0x0A
	CALL	proc_0189
	LD	(HL), 0xAC
	LD	(HL), 0x0A
	LD	(HL), 0xB0
	LD	C, 0x14
	CALL	proc_0189
	JP	proc_01A2

proc_037B:
	LD	(HL), 0xE6
	LD	D, 0xF0
.proc_037F:
	LD	(HL), D
	LD	C, 0x1B
	CALL	proc_0189
	INC	D
	LD	A, 0xFF
	CP	D
	JP	NZ, .proc_037F
	LD	(HL), D
	RET

proc_038E:
	LD	DE, 0xAC18
.proc_0391:
	LD	(HL), 0xB0
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x0F
	CALL	proc_0189
	LD	(HL), 0xBF
	LD	C, 0x1E
	CALL	proc_0189
	DEC	E
	JP	NZ, .proc_0391
	JP	proc_01A2

proc_03A8:
	LD	E, 0x09
	LD	(HL), 0xE4
	LD	(HL), 0xA0
	LD	(HL), 0x38
.proc_03B0:
	LD	(HL), 0xB3
	LD	(HL), 0xF0
	LD	C, 0x06
	CALL	proc_0189
	LD	(HL), 0xBF
	LD	(HL), 0xFF
	LD	C, 0x06
	CALL	proc_0189
	DEC	E
	JP	NZ, .proc_03B0
	RET

proc_03C7:
	LD	(HL), 0xE4
	LD	(HL), 0xA0
	LD	(HL), 0x38
	LD	(HL), 0xB2
	LD	D, 0xFF
.proc_03D1:
	LD	(HL), D
	LD	C, 0x1B
	CALL	proc_0189
	DEC	D
	LD	A, D
	CP	0xF0
	JP	NZ, .proc_03D1
	LD	(HL), 0xBF
	LD	C, 0x23
	CALL	proc_0189
	JP	proc_01A2

proc_03E8:
	LD	(HL), 0xA0
	LD	(HL), 0x08
	LD	(HL), 0xB2
	LD	C, 0x1B
	CALL	proc_0189
	LD	(HL), 0xA0
	LD	(HL), 0x06
	LD	(HL), 0xB1
	LD	C, 0x1B
	CALL	proc_0189
	LD	(HL), 0xA0
	LD	(HL), 0x04
	LD	(HL), 0xB0
	LD	C, 0x1B
	CALL	proc_0189
	LD	(HL), 0xA0
	LD	(HL), 0x06
	LD	(HL), 0xB1
	LD	C, 0x1B
	CALL	proc_0189
	LD	D, 0xB2
.proc_0416:
	LD	(HL), 0xA0
	LD	(HL), 0x08
	LD	(HL), D
	LD	C, 0x1B
	CALL	proc_0189
	INC	D
	LD	A, D
	CP	0xB7
	JP	NZ, .proc_0416
	JP	proc_01A2

proc_042A:
	LD	DE, 0xAC18
	LD	(HL), 0xB0
.proc_042F:
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x0C
	CALL	proc_0189
	DEC	E
	LD	A, E
	CP	0x06
	JP	NZ, .proc_042F
	JP	proc_01A2

proc_0440:
	LD	DE, 0xAC28
	LD	(HL), 0xB2
.proc_0445:
	LD	(HL), D
	LD	(HL), E
	LD	C, 0x0C
	CALL	proc_0189
	DEC	E
	LD	A, E
	CP	0x06
	JP	NZ, .proc_0445
	JP	proc_01A2

proc_0456:
	LD	(HL), 0xE4
	LD	D, 0xFF
.proc_045A:
	LD	(HL), D
	LD	C, 0x08
	CALL	proc_0189
	DEC	D
	LD	A, D
	CP	0xF1
	JP	NZ, .proc_045A
	LD	C, 0x0F
	CALL	proc_0189
	JP	proc_01A2

proc_046F:
	LD	(HL), 0xE4
	LD	D, 0xFF
.proc_0473:
	LD	(HL), D
	LD	C, 0x0C
	CALL	proc_0189
	DEC	D
	LD	A, D
	CP	0xF2
	JP	NZ, .proc_0473
	LD	C, 0x10
	CALL	proc_0189
	LD	(HL), 0xF7
	LD	C, 0x07
	CALL	proc_0189
	LD	(HL), 0xF0
	LD	C, 0x05
	CALL	proc_0189
	JP	proc_01A2
	LD	(HL), 0xE0
	LD	(HL), 0xF0
	LD	C, 0xC8
	CALL	proc_0189
	JP	proc_01A2

proc_04A2:
	LD	(HL), 0xE2
	LD	(HL), 0xF0
	LD	C, 0xC8
	CALL	proc_0189
	JP	proc_01A2

proc_04AE:
	LD	(HL), 0xE1
	LD	(HL), 0xF0
	LD	C, 0xC8
	CALL	proc_0189
	JP	proc_01A2

proc_04BA:
	LD	(HL), 0xE3
	LD	(HL), 0xF0
	LD	(HL), 0xC0
	LD	(HL), 0x05
	LD	C, 0xC8
	CALL	proc_0189
	JP	proc_01A2

/* ------------------------------------------------------------------
   This is a jump table for the state machine.

   Unfortunately, these have to be expressed as byte values, because
   they're in the opposite byte order than what the GNU toolchain
   wants to use for labels, and I can't figure out a syntax to swap
   them. :(
   ------------------------------------------------------------------ */

JumpTable:		/* 34 entries */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x03, 0x3A	/* proc_033A */
	.byte	0x02, 0xCF	/* proc_02CF */
	.byte	0x02, 0x87	/* proc_0287 */
	.byte	0x02, 0xB1	/* proc_02B1 */
	.byte	0x02, 0xF6	/* proc_02F6 */
	.byte	0x03, 0x25	/* proc_0325 */
	.byte	0x03, 0x2C	/* proc_032C */
	.byte	0x01, 0xD1	/* proc_01D1 */
	.byte	0x01, 0xFD	/* proc_01FD */
	.byte	0x02, 0x13	/* proc_0213 */
	.byte	0x02, 0x2B	/* proc_022B */
	.byte	0x02, 0x43	/* proc_0243 */
	.byte	0x02, 0x6F	/* proc_026F */
	.byte	0x03, 0x5B	/* proc_035B */
	.byte	0x01, 0xB2	/* proc_01B2 */
	.byte	0x03, 0x7B	/* proc_037B */
	.byte	0x03, 0x8E	/* proc_038E */
	.byte	0x03, 0xA8	/* proc_03A8 */
	.byte	0x03, 0xC7	/* proc_03C7 */
	.byte	0x03, 0xE8	/* proc_03E8 */
	.byte	0x04, 0x2A	/* proc_042A */
	.byte	0x04, 0x40	/* proc_0440 */
	.byte	0x04, 0x56	/* proc_0456 */
	.byte	0x04, 0x6F	/* proc_046F */
	.byte	0x04, 0xA2	/* proc_04A2 */
	.byte	0x04, 0xBA	/* proc_04BA */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x01, 0xA2	/* proc_01A2 */
	.byte	0x01, 0xA2	/* proc_01A2 */
