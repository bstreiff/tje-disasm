/* variable addresses */

/* Local softcopy for VDP MODE2 register value */
#define gMode2RegSoftcopy	0xFF8000	/* byte */

#define P1_CAMERA_X		0xFF8002	/* word */
#define P1_CAMERA_Y		0xFF8004	/* word */
#define P2_CAMERA_X		0xFF8006	/* word */
#define P2_CAMERA_Y		0xFF8008	/* word */

/*
 * Sega logo display and Jam Out have a hook pointer here.
 * During intro, menus, and in-game, this is null.
 */
#define gVBlankFunc		0xFF800A	/* long */

/* seems to be how everything keeps track of time? */
#define TIME_COUNTER		0xFF800E	/* word */

/* Seems to govern whether or not we're in split-screen */
#define SPLIT_SCREEN		0xFF8010	/* byte */

/*
 * Map data. The game stores multiple maps in-memory as a
 * cache, which speeds up falling down/un-falling back for
 * short distances. Moving too many levels does entail
 * regeneration though.
 *
 * Each tile is one word long.
 */
#define MAP_WIDTH_IN_TILES	19
#define MAP_HEIGHT_IN_TILES	26
#define gMapDataA		0xFF81AA	/* word[19][26] */
#define gMapDataB		0xFF8586	/* word[19][26] */
#define gMapDataC		0xFF8962	/* word[19][26] */
#define gMapDataD		0xFF8D3E

/* Unknown */
#define gLevel912A		0xFF912A	/* byte */
/* Toejam's level? */
#define gLevel912C		0xFF912C	/* byte */
/* Earl's level? */
#define gLevel912E		0xFF912E	/* byte */
/* Unknown, set to 0xFF on init... maybe level cache? */
#define gLevel9130		0xFF9130	/* byte */
/* Highest level reached */
#define gHighestLevel		0xFF9132	/* byte */

/* Is this a Random World or a Fixed World game? */
#define gWorldType		0xFF9134	/* byte */
#define gWorldType_RANDOM	0x00
#define gWorldType_FIXED	0x01

/* Per-level seeds. This is a fixed pattern in Fixed World. */
#define gLevelSeeds		0xFF9136	/* word[26] */

/* Random number generator state */
#define gRNGState		0xFF91E2	/* long */

/*
 * This is a mask of map tiles that have been uncovered. Each level has
 * a 8x7 map, so each level occupies 7 bytes.
 */
#define gDiscoveredMapMask	0xFF91F3	/* byte[7][25] */

/*
 * This is similar to DISCOVERED_MAP_MASK, but it is for the "transparent"
 * tiles uncovered by telephones. (Because of the way that these tiles are
 * drawn, there is a limit of 20 transparent tiles shown at once; tiles
 * over this limit are just not displayed at all.)
 */
#define gTransparentMapMask	0xFF92A0	/* byte[7][25] */

#define P1_TEXT_WIGGLE		0xFF935E	/* byte */
/* if counter % 4 == 0, then WIGGLE == !WIGGLE */
#define P1_MENU_COUNTER		0xFF9360	/* byte */

#define P1_MENU_OPEN		0xFF9364	/* byte */

/* Present menu row */
#define P1_MENU_SCROLL		0xFF9366	/* byte */
#define P1_MENU_SEL_ROW		0xFF9368	/* byte */
#define P1_MENU_SEL_COL		0xFF936A	/* byte */

/* Space to store items/prices while the mailbox purchase menu is up */
#define gPlayer1MailboxItems	0xFF937A	/* byte[3] */
#define gPlayer2MailboxItems	0xFF937D	/* byte[3] */
#define gPlayer1MailboxPrices	0xFF9380	/* byte[3] */
#define gPlayer2MailboxPrices	0xFF9383	/* byte[3] */

/* Sprite data for the font. Staging buffer for loading into VDP? */
#define TEXT_SPRITE_DATA_START	0xFF9388
#define TEXT_SPRITE_DATA_LEN	0xEC0

#define gPlayerLives		0xFFA248	/* byte */
#define gPlayer1Lives		0xFFA248	/* byte */
#define gPlayer2Lives		0xFFA249	/* byte */

#define gPlayerBucks		0xFFA24A
#define gPlayer1Bucks		0xFFA24A	/* byte */
#define gPlayer2Bucks		0xFFA24B	/* byte */

#define gPlayerPoints		0xFFA24C
#define gPlayer1Points		0xFFA24C	/* word */
#define gPlayer2Points		0xFFA24E	/* word */

#define gPlayerRank		0xFFA250
#define gPlayer1Rank		0xFFA250	/* byte */
#define gPlayer2Rank		0xFFA251	/* byte */

/*
   struct PlayerInfo {
       unsigned short xpos;
       unsigned short ypos;
       unsigned short zpos;
       unsigned short xaccel;
       unsigned short yaccel;
       unsigned short zaccel;
       unsigned char unknown[64];
       unsigned char level;
       unsigned char unknown2[51];
   };
   extern struct PlayerInfo gPlayerInfo[2];
*/
#define gPlayerInfo		0xFFA25A	

#define P1_POS_X		0xFFA25A	/* word */
#define P1_POS_Y		0xFFA25C	/* word */
/* ground level is 0x0, deep in sand is 0xFFEC, wings top out at about 0x003A */
#define P1_POS_Z		0xFFA25E	/* word */
#define P1_ACCEL_X		0xFFA260	/* word */
#define P1_ACCEL_Y		0xFFA262	/* word */
#define P1_ACCEL_Z		0xFFA264	/* word */
#define P1_LEVEL		0xFFA2A6	/* byte */

#define P2_POS_X		0xFFA2DA	/* word */
#define P2_POS_Y		0xFFA2DC	/* word */
#define P2_POS_Z		0xFFA2DE	/* word */
#define P2_ACCEL_X		0xFFA300	/* word */
#define P2_ACCEL_Y		0xFFA302	/* word */
#define P2_ACCEL_Z		0xFFA304	/* word */
#define P2_LEVEL		0xFFA326	/* byte */

/*
 * The idle counter counts up every frame(?) and is reset when the player
 * moves. When it exceeds 0x012C, the player falls asleep.
 */
#define P1_IDLE_COUNTER		0xFFDA44	/* word */
#define P2_IDLE_COUNTER		0xFFDA46	/* word */

/* Buttons pressed. */
#define P1_KEYDOWN		0xFFDA48	/* byte */
#define P2_KEYDOWN		0xFFDA49	/* byte */

/*
 * Countdown timer for the arrival elevator to depart after players have
 * left it.
 */
#define ARRIVING_ELEV_TIME	0xFFDA84	/* byte */

/* This is the level that the departing elevator is on. */
#define DEPARTING_ELEV_LEVEL	0xFFDA4E	/* byte */

/* Departing elevator state.
 *  0x00: doors closed
 *  0x01 through 0x03: doors open(ing)
 *  0x05: liftoff
 *  0x06: engage countdown
 */
#define DEPARTING_ELEV_STATE	0xFFDA4F	/* byte */

/* This is the level that the arriving elevator is on. */
#define ARRIVING_ELEV_LEVEL	0xFFDA56	/* byte */

#define ARRIVING_ELEV_STATE	0xFFDA57	/* byte */

/*
 * These are variables for the departing elevator. The second variable is
 * a frame(?) countdown that is initialized set to cycles/2. Every time the
 * variable hits zero, "cycles" decrements by one. Once that hits zero,
 * we have liftoff. (This is what produces the "charging up" sound effect.)
 */
#define DEPARTING_ELEV_CYCLES	0xFFDA86	/* byte */
#define DEPARTING_ELEV_TIME	0xFFDA88	/* byte */

/*
 * Present info.
 * This is an array of 28 byte pairs. The first byte is the appearance of
 * this present, and the second byte is whether or not the present is
 * identified. (Index 0x1B, Bonus Hi-tops, is set to 0x01 on game start; all
 * others are 0x00.)
 *  struct PresentInfo {
 *     unsigned char appearance;
 *     unsigned char identified;
 * };
 * extern struct PresentInfo gPresentInfo[28];
 */
#define gPresentInfo		0xFFDA8A	/* struct{byte,byte}[28] */

/* Inventory. This is an array of present indices. */
#define gPlayerInventory	0xFFDAC2	/* byte[2][16] */

/*
  This seems to be a table of objects on the current map. This is an array
  of 8-byte values:
   struct Object {
       unsigned char type;
       unsigned char level;
       unsigned char flags; // (0x00 offscreen, 0x06 onscreen?)
       unsigned char zsort;
       unsigned short xpos;
       unsigned short ypos;
   };
*/
#define MAX_OBJECTS 64
#define gObjectTable		0xFFDAE2	/* Object[64] */

/*
   This is the table of dropped presents.
   struct DroppedPresent {
       unsigned char contents;
       unsigned char level;
       unsigned char zsort;
       unsigned char unknown;
       unsigned short xpos;
       unsigned short ypos;
   }
   #define MAX_DROPPED_PRESENTS 32
*/
#define MAX_DROPPED_PRESENTS 32
#define gDroppedPresentTable	0xFFDCE6	/* DroppedPresent[32] */
#define gDroppedPresentTableIdx	0xFFDDE6

/* active powerup, one of 0x00 through 0x07 */
#define gPlayer1Powerup		0xFFDE50	/* byte */
#define gPlayer2Powerup		0xFFDE51	/* byte */
#define gPlayer1PowerupTimer	0xFFDE52	/* word */
#define gPlayer2PowerupTimer	0xFFDE54	/* word */

#define gPlayer1BurpsLeft	0xFFDE62	/* byte */
#define gPlayer2BurpsLeft	0xFFDE63	/* byte */
#define gPlayer1BurpTimer	0xFFDE64	/* byte */
#define gPlayer2BurpTimer	0xFFDE65	/* byte */

#define gPlayer1RainCloudState	0xFFDE66	/* byte */
#define gPlayer2RainCloudState	0xFFDE67	/* byte */
#define gPlayer1RainCloudTimer	0xFFDE68	/* word */
#define gPlayer2RainCloudTimer	0xFFDE6A	/* word */

/* Countdown until tomato rain expires. */
#define gPlayer1TomatoRainTimer	0xFFE1E8	/* byte */
#define gPlayer2TomatoRainTimer	0xFFE1E9	/* byte */
/*
 * This seems to be a smaller countdown used for regulating individual
 * tomatoes. If locked to 0x00 or 0x01, tomatoes drop in bursts of 8.
 */
#define gPlayer1TomatoRainThrottle	0xFFE1FA	/* byte */
#define gPlayer2TomatoRainThrottle	0xFFE1FB	/* byte */

/*
 * Ship-piece levels is an array of ten bytes, with each
 * byte corresponding to a particular ship piece.
 * 1 through 25 are levels
 * if an element is 0, then the players have that piece.
 */
#define SHIP_PIECE_COUNT	10
#define gShipPieceLevels	0xFFE21C	/* byte[10] */

#define gTelephoneActive	0xFFE24F	/* byte */
#define gTelephoneXPos		0xFFE252	/* word */
#define gTelephoneYPos		0xFFE254	/* word */
#define gTelephoneRingsLeft	0xFFE260	/* byte */
#define gTelephoneTimeToRing	0xFFE262	/* byte */

/* sprite object identifiers for the menu system */
#define gMenuCursorObjId	0xFFE392	/* word */
#define gMenuHeaderObjId	0xFFE394	/* word */

/* state flags of some sort? */
#define gMusicUnknownE46E	0xFFE46E	/* word */
#define gMusicUnknownE470	0xFFE470	/* word */
#define gMusicUnknownE472	0xFFE472	/* word */
#define gMusicUnknownE478	0xFFE478	/* word */
#define gMusicUnknownE47A	0xFFE47A	/* word */
#define gMusicUnknownE47C	0xFFE47C	/* word */
#define gMusicUnknownE47E	0xFFE47E	/* word */
#define gMusicUnknownE480	0xFFE480	/* word */
#define gMusicUnknownE488	0xFFE488	/* byte */
#define gMusicUnknownE489	0xFFE489	/* byte */


/* music system */
#define gMusicPointer1		0xFFFE00	/* long */
#define gMusicPointer2		0xFFFE04	/* long */
#define gMusicPointer3		0xFFFE08	/* long */
#define gMusicPointer4		0xFFFE0C	/* long */
#define gMusicPointer5		0xFFFE11	/* long */
#define gMusicPointer6		0xFFFE14	/* long */

#define gMusicUnknownFE2E	0xFFFE2E	/* word */

#define gMusicChannel1Ptr1	0xFFFE30	/* long */
#define gMusicChannel1Ptr2	0xFFFE34	/* long */

#define gMusicChannel2Ptr1	0xFFFE56	/* long */
#define gMusicChannel2Ptr2	0xFFFE5A	/* long */

#define gMusicChannel3Ptr1	0xFFFE7C	/* long */
#define gMusicChannel3Ptr2	0xFFFE80	/* long */

#define gMusicChannel4Ptr1	0xFFFEA2	/* long */
#define gMusicChannel4Ptr2	0xFFFEA6	/* long */

#define gMusicChannel5Ptr1	0xFFFEC8	/* long */
#define gMusicChannel5Ptr2	0xFFFECC	/* long */

#define gMusicChannel6Ptr1	0xFFFEEE	/* long */
#define gMusicChannel6Ptr2	0xFFFEF2	/* long */
