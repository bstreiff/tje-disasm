	.section .text.vectors
	.global StartOfRom
	.global	_start
	.global	ErrorTrap
	.global Level4Isr
	.global Level6Isr

StartOfRom:
	dc.l	0x00FF8000	/* initial SSP */
	dc.l	_start		/* initial PC */
	dc.l	ErrorTrap	/* bus error */
	dc.l	ErrorTrap	/* address error */
	dc.l	ErrorTrap	/* illegal instruction */
	dc.l	ErrorTrap	/* divide by zero */
	dc.l	ErrorTrap	/* CHK resulted in out-of-bounds */
	dc.l	ErrorTrap	/* TRAPV with overflow flag set */
	dc.l	ErrorTrap	/* Privilege violation */
	dc.l	ErrorTrap	/* Trace */ 
	dc.l	ErrorTrap	/* Line 1010 emulator */
	dc.l	ErrorTrap	/* Line 1111 emulator */
	dc.l	ErrorTrap	/* Reserved on 68000 */ 
	dc.l	ErrorTrap	/* Reserved on 68000 */
	dc.l	ErrorTrap	/* Reserved on 68000 */
	dc.l	ErrorTrap	/* Uninitialized reset vector */
	dc.l	ErrorTrap	/* Reserved */ 
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Reserved */
	dc.l	ErrorTrap	/* Spurious interrupt */
	dc.l	ErrorTrap	/* Level 1 interrupt autovector */
	dc.l	ErrorTrap	/* Level 2 interrupt autovector */
	dc.l	ErrorTrap	/* Level 3 interrupt autovector */
	dc.l	Level4Isr	/* Level 4 interrupt autovector (Hblank) */
	dc.l	ErrorTrap	/* Level 5 interrupt autovector */
	dc.l	Level6Isr	/* Level 6 interrupt autovector (Vblank) */
	dc.l	ErrorTrap	/* Level 7 interrupt autovector */
	/* 16 TRAP interrupts */
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap	/* TRAP #0-#3 */
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap	/* TRAP #4-#7 */
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap	/* TRAP #8-#11 */
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap	/* TRAP #12-#15	*/
	/* 16 Reserved interrupts */
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
	dc.l	ErrorTrap, ErrorTrap, ErrorTrap, ErrorTrap
