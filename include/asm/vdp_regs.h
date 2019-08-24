/*
 * Registers in the VDP register space.
 *
 * This tries to stick to the naming used in
 *     https://segaretro.org/Sega_Mega_Drive/VDP_registers
 * However, I had to come up with constant names for the registers
 * themselves.
 */

#include "genesis_regs.h"

#ifndef _ASM_VDP_REGS_H
#define _ASM_VDP_REGS_H

/*
 * Mode Register 1
 */
#define VDP_REG_MODE1			0x00
/* Left column blank */
#define VDP_MODE1_L_BIT			5
#define VDP_MODE1_L			BIT(VDP_MODE1_L_BIT)
/* Horizontal interrupt enable */
#define VDP_MODE1_IE1_BIT		4
#define VDP_MODE1_IE1			BIT(VDP_MODE1_IE1_BIT)
/* Palette select */
#define VDP_MODE1_CM_BIT		2
#define VDP_MODE1_CM			BIT(VDP_MODE1_CM_BIT)
/* HV Counter Latch Enable */
#define VDP_MODE1_M3_BIT		1
#define VDP_MODE1_M3			BIT(VDP_MODE1_M3_BIT)
/* Display Enable */
#define VDP_MODE1_DE_BIT		0
#define VDP_MODE1_DE			BIT(VDP_MODE1_DE_BIT)

/*
 * Mode Register 2
 */
#define VDP_REG_MODE2			0x01
/* 128 KB mode enable */
#define VDP_MODE2_VR_BIT		7
#define VDP_MODE2_VR			BIT(VDP_MODE2_VR_BIT)
/* Display Enable */
#define VDP_MODE2_DE_BIT		6
#define VDP_MODE2_DE			BIT(VDP_MODE2_DE_BIT)
/* Vertical Interrupt Enable */
#define VDP_MODE2_IE0_BIT		5
#define VDP_MODE2_IE0			BIT(VDP_MODE2_IE0_BIT)
/* DMA Enable */
#define VDP_MODE2_M1_BIT		4
#define VDP_MODE2_M1			BIT(VDP_MODE2_M1_BIT)
/* Output Format */
#define VDP_MODE2_M2_BIT		3
#define VDP_MODE2_M2			BIT(VDP_MODE2_M2_BIT)
/* SMS Display Select */
#define VDP_MODE2_M5_BIT		2
#define VDP_MODE2_M5			BIT(VDP_MODE2_M5_BIT)

/*
 * Mask of all the bits that are not DE (and not VR, which will
 * never be set on a standard console)
 */
#define VDP_MODE2_NOT_DE_MASK		(VDP_MODE2_IE0|VDP_MODE2_M1|VDP_MODE2_M2|VDP_MODE2_M5)

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
#define VDP_MODE3_IE2_BIT		3
#define VDP_MODE3_IE2			BIT(VDP_MODE3_IE2_BIT)
/* Vertical Scrolling */
#define VDP_MODE3_VS_BIT		2
#define VDP_MODE3_VS			BIT(VDP_MODE3_VS_BIT)
/* Horizontal Scrolling */
#define VDP_MODE3_HS_MASK		0x03
#define VDP_MODE3_HS_SHIFT		0
#define VDP_MODE3_HS_FULL		0x0
#define VDP_MODE3_HS_8PX		0x2
#define VDP_MODE3_HS_1PX		0x3

/*
 * Mode Set Register 4
 */
#define VDP_REG_MODE4			0x0C
/* Controls Horizontal Resolution (with RS0) */
#define VDP_MODE4_RS1_BIT		7
#define VDP_MODE4_RS1			BIT(VDP_MODE4_RS1_BIT)
#define VDP_MODE4_VS_BIT		6
#define VDP_MODE4_VS			BIT(VDP_MODE4_VS_BIT)
#define VDP_MODE4_HS_BIT		5
#define VDP_MODE4_HS			BIT(VDP_MODE4_HS_BIT)
#define VDP_MODE4_EP_BIT		4
#define VDP_MODE4_EP			BIT(VDP_MODE4_EP_BIT)
/* Shadow/Highlight */
#define VDP_MODE4_SH_BIT		3
#define VDP_MODE4_SH			BIT(VDP_MODE4_SH_BIT)
/* Interlacing */
#define VDP_MODE4_LS1_BIT		2
#define VDP_MODE4_LS1			BIT(VDP_MODE4_LS1_BIT)
#define VDP_MODE4_LS0_BIT		1
#define VDP_MODE4_LS0			BIT(VDP_MODE4_LS0_BIT)
#define VDP_MODE4_RS0_BIT		0
#define VDP_MODE4_RS0			BIT(VDP_MODE4_RS0_BIT)
/* Both RS0 and RS1 bits are supposed to be the same. */
#define VDP_MODE4_RS			(VDP_MODE4_RS0|VDP_MODE4_RS1)

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
#define VDP_PSIZE_256			0x00
#define VDP_PSIZE_512			0x01
#define VDP_PSIZE_1024			0x03
#define VDP_PSIZE_H_MASK		0x30
#define VDP_PSIZE_H_SHIFT		4
#define VDP_PSIZE_W_MASK		0x03
#define VDP_PSIZE_W_SHIFT		0

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
