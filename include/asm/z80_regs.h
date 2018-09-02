/*
 * Registers for the Z80, from both the point of view of the Z80
 * and the M68K.
 */

#ifndef _ASM_Z80_REGS_H
#define _ASM_Z80_REGS_H

#if __z80__

#define Z80_RAM_START		0x0000
#define Z80_RAM_END		0x1FFF
#define YM2612_P0_ADDR		0x4000
#define YM2612_P0_DATA		0x4001
#define YM2612_P1_ADDR		0x4002
#define YM2612_P1_DATA		0x4003
#define BANK_REG		0x6000
#define PSG_REG			0x7F11
#define M68K_BANK_START		0x8000
#define M68K_BANK_END		0xFFFF

#elif __m68k__

#define Z80_RAM_START		0xA00000
#define Z80_RAM_END		0xA01FFF
#define YM2612_P0_ADDR		0xA04000
#define YM2612_P0_DATA		0xA04001
#define YM2612_P1_ADDR		0xA04002
#define YM2612_P1_DATA		0xA04003
#define BANK_REG		0xA06000
#define PSG_REG			0xA07F11
#define M68K_BANK_START		0xA08000
#define M68K_BANK_END		0xA0FFFF

#endif

#endif /* _ASM_Z80_REGS_H */
