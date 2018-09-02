/*
 * Linker script for the Sega Genesis/Mega Drive.
 */

OUTPUT_ARCH(m68k)
SEARCH_DIR(.)
__DYNAMIC = 0;

MEMORY
{
	rom    : ORIGIN = 0x00000000, LENGTH = 0x00400000
	stack  : ORIGIN = 0x00FF0000, LENGTH = 0x00008000
	ram    : ORIGIN = 0x00FF8000, LENGTH = 0x00008000
}

SECTIONS
{
	.text 0x00000000 :
	{
		/* M68K vector table */
		KEEP(*(.text.vectors))
		/* Genesis ROM header */
		KEEP(*(.text.header))
		*(.text.*) *(.text)
		. = ALIGN(0x4);

		/* const data */
		*(.rodata .rodata.*)

		. = ALIGN(0x4);
		_DATA_ROM_START = .;
	} > rom

	/* global variables */
	.data 0x00FF8000 :
	AT(ADDR(.text) + SIZEOF(.text))
	{
		_DATA_RAM_START = .;
		*(.got.plt) *(.got)
		*(.shdata)
		*(.data .data.*)
		_DATA_RAM_END = .;
	} > ram

	.bss 0x00FF8000 + SIZEOF(.data) :
	{
		_BSS_START = .;
		*(.shbss)
		*(.bss .bss.*)
		*(COMMON)
		_BSS_END = .;
	} > ram

	/* discard */
	/DISCARD/ :
	{
		*(.stab)
		*(.strtab)
		*(.stabstr)
		*(.note)
		*(.note.*)
	}
}
