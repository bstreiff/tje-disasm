;----------------------------------------------------------------------
; Main header file for constants related to the Genesis/Mega Drive
; hardware.
;----------------------------------------------------------------------

RAM_ADDR		equ	$FF0000
RAM_LENGTH		equ	$010000
RAM_LENGTH_IN_WORDS	equ	$8000
RAM_LENGTH_IN_LONGS	equ	$4000

; Indicates the hardware version.
HW_VERSION		equ	$A10001		; word
HW_VERSION_MODE		equ	$0080		; 0: "Domestic", 1: "Overseas"
HW_VERSION_VMOD		equ	$0040		; 0: NTSC, 1: PAL
HW_VERSION_DISK		equ	$0020		; 0: FDD unit connected, 1: no FDD
HW_VERSION_VER_MASK	equ	$000F		; hardware version

; I/O port. There are three general purpose I/O ports,
; CTRL1, CTRL2, and EX. Each port has the following registers:
;   DATA: parallel data
;   CTRL: parallel control
;   SCTRL: serial control
;   TXDATA: transmit data
;   RXDATA: receive data

IO_CTRL1_DATA		equ	$A10003		; word
IO_CTRL2_DATA		equ	$A10005		; word
IO_EXP_DATA		equ	$A10007		; word
IO_CTRL1_CTRL		equ	$A10009		; word
IO_CTRL2_CTRL		equ	$A1000B		; word
IO_EXP_CTRL		equ	$A1000D		; word
IO_CTRL1_TXDATA		equ	$A1000F		; word
IO_CTRL1_RXDATA		equ	$A10011		; word
IO_CTRL1_SCTRL		equ	$A10013		; word
IO_CTRL2_TXDATA		equ	$A10015		; word
IO_CTRL2_RXDATA		equ	$A10017		; word
IO_CTRL2_SCTRL		equ	$A10019		; word
IO_EXP_TXDATA		equ	$A1001B		; word
IO_EXP_RXDATA		equ	$A1001D		; word
IO_EXP_SCTRL		equ	$A1001F		; word

;----------------------------------------------------------------------
; Z80
;----------------------------------------------------------------------

	INCLUDE z80.asm

; Bus request. For the 68K to access the Z80 memory, the procedure is
;   Write $0100 into Z80_BUSREQ
;   Wait until bit 8 in Z80_BUSREQ becomes 0
;   do your access
;   Write $0000 into Z80_BUSREQ to release
Z80_BUSREQ		equ	$A11100		; word
Z80_BUSREQ_REQUEST	equ	$0100
Z80_BUSREQ_CANCEL	equ	$0000

; Reset request.
; 
Z80_RESET		equ	$A11200		; word
Z80_RESET_REQUEST	equ	$0000
Z80_RESET_CANCEL	equ	$0100

TMSS_CTRL		equ	$A14000		; long

;----------------------------------------------------------------------
; VDP
;----------------------------------------------------------------------

VDP_DATA_PORT		equ	$C00000		; word
VDP_DATA_PORT_MIRROR	equ	$C00002
VDP_CTRL_PORT		equ	$C00004
VDP_CTRL_PORT_MIRROR	equ	$C00006
VDP_HVCOUNTER_PORT	equ	$C00008

; VDP status flags (read from VDP_CTRL_PORT)
VDP_STS_FIFOEMPTY	equ	$0200
VDP_STS_FIFOFULL	equ	$0100
VDP_STS_VINTPENDING	equ	$0080
VDP_STS_SPROVERFLOW	equ	$0040
VDP_STS_SPRCOLLISION	equ	$0020
VDP_STS_ODDFRAME	equ	$0010
VDP_STS_VBLANK		equ	$0008
VDP_STS_HBLANK		equ	$0004
VDP_STS_DMABUSY		equ	$0002
VDP_STS_PALMODE		equ	$0001

VDP_CTRL_REG_WRITE	equ	$8000
