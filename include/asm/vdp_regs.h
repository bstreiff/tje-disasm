/*
 * Registers in the VDP register space.
 *
 * This tries to stick to the naming used in
 *     https://segaretro.org/Sega_Mega_Drive/VDP_registers
 * However, I had to come up with constant names for the registers
 * themselves.
 */

#ifndef _ASM_VDP_REGS_H
#define _ASM_VDP_REGS_H

/*
 * Mode Register 1
 */
#define VDP_REG_MODE1			0x00
/* Left column blank */
#define VDP_MODE1_L			0x20
/* Horizontal interrupt enable */
#define VDP_MODE1_IE1			0x10
/* Palette select */
#define VDP_MODE1_CM			0x04
/* HV Counter Latch Enable */
#define VDP_MODE1_M3			0x02
/* Display Enable */
#define VDP_MODE1_DE			0x01

/*
 * Mode Register 2
 */
#define VDP_REG_MODE2			0x01
/* 128 KB mode enable */
#define VDP_MODE2_VR			0x80
/* Display Enable */
#define VDP_MODE2_DE			0x40
/* Vertical Interrupt Enable */
#define VDP_MODE2_IE0			0x20
/* DMA Enable */
#define VDP_MODE2_M1			0x10
/* Output Format */
#define VDP_MODE2_M2			0x08
/* SMS Display Select */
#define VDP_MODE1_M5			0x04

/*
 * Pattern Name Table Address for Scroll A
 */
#define VDP_REG_NAMTBLA			0x02

/*
 * Pattern Name Table Address for Window
 */
#define VDP_REG_WINTBL			0x03

/*
 * Pattern Name Table Address for Scroll B
 */
#define VDP_REG_NAMTBLB			0x04

/*
 * Sprite Attribute Table Base Address
 */
#define VDP_REG_SPRTBL			0x05

/*
 * Sprite Pattern Generator Base Address
 */
#define VDP_REG_SPRTBL2			0x06

/*
 * Background Color
 */
#define VDP_REG_BGCOLOR			0x07
#define VDP_BGCOLOR_PL_MASK		0x03
#define VDP_BGCOLOR_PL_SHIFT		4
#define VDP_BGCOLOR_C_MASK		0x0F
#define VDP_BGCOLOR_C_SHIFT		0

#define VDP_REG_SMS_HSCR		0x08
#define VDP_REG_SMS_VSCR		0x09

/*
 * Horizontal Interrupt Register
 */
#define VDP_REG_HINTC			0x0A

/*
 * Mode Set Register 3
 */
#define VDP_REG_MODE3			0x0B
/* External Interrupt Enable */
#define VDP_MODE3_IE2			0x08
/* Vertical Scrolling */
#define VDP_MODE3_VS			0x04
/* Horizontal Scrolling */
#define VDP_MODE3_HS_MASK		0x03
#define VDP_MODE3_HS_SHIFT		0

/*
 * Mode Set Register 4
 */
#define VDP_REG_MODE4			0x0C
/* Controls Horizontal Resolution (with RS0) */
#define VDP_MODE4_RS1			0x80
#define VDP_MODE4_VS			0x40
#define VDP_MODE4_HS			0x20
#define VDP_MODE4_EP			0x10
/* Shadow/Highlight */
#define VDP_MODE4_SH			0x08
/* Interlacing */
#define VDP_MODE4_LS1			0x04
#define VDP_MODE4_LS0			0x02
#define VDP_MODE4_RS0			0x01

/*
 * Horizontal Scroll Data Table Base Address
 */
#define VDP_REG_HSDTADDR		0x0D

/*
 * Nametable Pattern Generator Base Address
 */
#define VDP_REG_NTPADDR			0x0E

/*
 * Auto Increment Data
 */
#define VDP_REG_AUTOINCR		0x0F

/*
 * Scroll Size
 */
#define VDP_REG_PSIZE			0x10

/*
 * Window Horizontal Position
 */
#define VDP_REG_WINHPOS			0x11

/*
 * Window Vertical Position
 */
#define VDP_REG_WINVPOS			0x12

/*
 * DMA Length Counter Low
 */
#define VDP_REG_DMALENL			0x13

/*
 * DMA Length Counter High
 */
#define VDP_REG_DMALENH			0x14

/*
 * DMA Source Address Low
 */
#define VDP_REG_DMASRCL			0x15

/*
 * DMA Source Address Mid
 */
#define VDP_REG_DMASRCM			0x16


/*
 * DMA Source Address High
 */
#define VDP_REG_DMASRCH			0x17
/* 68K RAM to VRAM copy */
#define VDP_DMASRC_M68K2VRAM		0x00
/* VRAM fill */
#define VDP_DMASRC_VRAM_FILL		0x80
/* VRAM to VRAM copy */
#define VDP_DMASRC_VRAM2VRAM		0xC0

#endif
