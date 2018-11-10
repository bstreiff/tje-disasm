	.section .text.header
	.global HeaderConsole

/* ------------------------------------------------------------------
   Cartridge header
   ------------------------------------------------------------------ */
HeaderConsole:
	.ascii	"SEGA GENESIS    "
HeaderDate:
#if GAME_REVISION == 0
	.ascii	"(C)SEGA 1991.JUL"
#elif GAME_REVISION == 2
	.ascii	"(C)SEGA 1991.OCT"
#endif
HeaderTitleLocal:
	.ascii	"TOEJAM & EARL                                   "
HeaderTitleInt:
	.ascii	"TOEJAM & EARL                                   "
HeaderSerial:
#if GAME_REVISION == 0
	.ascii	"GM MK-1020 -00"
#elif GAME_REVISION == 2
	.ascii	"GM MK-1020 -02"
#endif
HeaderChecksum:
#if GAME_REVISION == 0
	dc.w	0xE88B
#elif GAME_REVISION == 2
	dc.w	0x41C8		/* checksum */
#endif
HeaderIOSupport:
	.ascii	"J               "
HeaderRomStartLoc:
	dc.l	0x00000000	/* start of rom */
HeaderRomEndLoc:
	dc.l	0x000FFFFF	/* end of rom */
HeaderRamStartLoc:
	dc.l	0x00FF0000	/* start of ram */
HeaderRamEndLoc:
	dc.l	0x00FFFFFF	/* end of ram */
HeaderNotes:
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
	.ascii	"                "
HeaderRegion:
	.ascii	"U               "
