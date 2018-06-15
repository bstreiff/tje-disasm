;----------------------------------------------------------------------
; Main header file for constants related to the Z80 in the Genesis.
;----------------------------------------------------------------------

; The Z80 memory space is mapped into the M68K at this location.
	ifd CPU_M68K
Z80_RAM_START		equ	$A00000
	else ifd CPU_Z80
Z80_RAM_START		equ	$0000
	endif

Z80_RAM_END		equ	(Z80_RAM_START+$1FFF)
YM2612_P0_ADDR		equ	(Z80_RAM_START+$4000)
YM2612_P0_DATA		equ	(Z80_RAM_START+$4001)
YM2612_P1_ADDR		equ	(Z80_RAM_START+$4002)
YM2612_P1_DATA		equ	(Z80_RAM_START+$4003)
BANK_REG		equ	(Z80_RAM_START+$6000)
PSG_REG			equ	(Z80_RAM_START+$7F11)
M68K_BANK_START		equ	(Z80_RAM_START+$8000)
M68K_BANK_END		equ	(Z80_RAM_START+$FFFF)

; Include constants related to the YM2612 FM synth
	INCLUDE	ym2612.asm
