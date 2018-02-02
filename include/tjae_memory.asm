; Toejam & Earl RAM locations of interest

;; #define KEYDOWN_UP		0x01
;; #define KEYDOWN_DOWN		0x02
;; #define KEYDOWN_LEFT		0x04
;; #define KEYDOWN_RIGHT	0x08
;; #define KEYDOWN_A		0x40
;; #define KEYDOWN_B		0x10
;; #define KEYDOWN_C		0x20

P1_CAMERA_X		equ	$FF8002		; word
P1_CAMERA_Y		equ	$FF8004		; word
P2_CAMERA_X		equ	$FF8006		; word
P2_CAMERA_Y		equ	$FF8008		; word

; Sega logo display and Jam Out have a hook pointer here.
; During intro, menus, and in-game, this is null.
gVBlankFunc		equ	$FF800A		; long

; seems to be how everything keeps track of time?
TIME_COUNTER		equ	$FF800E		; word

; Seems to govern whether or not we're in split-screen
SPLIT_SCREEN		equ	$FF8010		; byte

; Is this a Random World or a Fixed World game?
;; #define WORLD_RANDOM 0
;; #define WORLD_FIXED 1
;; extern unsigned char gWorldType;
gWorldType		equ	$FF9134		; byte
gWorldType_RANDOM	equ	$00
gWorldType_FIXED	equ	$01

; I *think* these influence the level generator. There's a fixed
; pattern here if you're in Fixed World.
; $FF9166 - Level 0?
; $FF9168 - Level 1
; $FF916A - Level 2, etc...
;; extern unsigned short gLevelSeeds[26];
gLevelSeeds		equ	$FF9136		; word[26]

;; extern unsigned long gRNGState;
gRNGState		equ	$FF91E2		; long

; This is a mask of map tiles that have been uncovered. Each level has
; a 8x7 map, so each level occupies 7 bytes.
;; extern unsigned char gDiscoveredMapMask[7][25];
gDiscoveredMapMask	equ	$FF91F3		; byte[7][25]

; This is similar to DISCOVERED_MAP_MASK, but it is for the "transparent"
; tiles uncovered by telephones. (Because of the way that these tiles are
; drawn, there is a limit of 20 transparent tiles shown at once; tiles
; over this limit are just not displayed at all.)
;; extern unsigned char gTransparentMapMask[7][25];
gTransparentMapMask	equ	$FF92A0		; byte[7][25]

P1_TEXT_WIGGLE		equ	$FF935E		; byte
; if counter % 4 == 0, then WIGGLE == !WIGGLE
P1_MENU_COUNTER		equ	$FF9360		; byte

P1_MENU_OPEN		equ	$FF9364		; byte

; Present menu row
P1_MENU_SCROLL		equ	$FF9366		; byte
P1_MENU_SEL_ROW		equ	$FF9368		; byte
P1_MENU_SEL_COL		equ	$FF936A		; byte

; Sprite data for the font. Staging buffer for loading into VDP?
TEXT_SPRITE_DATA_START	equ	$FF9388
TEXT_SPRITE_DATA_LEN	equ	$EC0

;; extern unsigned char gPlayerLives[2];
gPlayerLives		equ	$FFA248		; byte
gPlayer1Lives		equ	$FFA248		; byte
gPlayer2Lives		equ	$FFA249		; byte

;; extern unsigned char gPlayerBucks[2];
gPlayerBucks		equ	$FFA24A
gPlayer1Bucks		equ	$FFA24A		; byte
gPlayer2Bucks		equ	$FFA24B		; byte

;; extern unsigned short gPlayerPoints[2];
gPlayerPoints		equ	$FFA24C
gPlayer1Points		equ	$FFA24C		; word
gPlayer2Points		equ	$FFA24E		; word

;; extern unsigned char gPlayerRank[2];
gPlayerRank		equ	$FFA250
gPlayer1Rank		equ	$FFA250		; byte
gPlayer2Rank		equ	$FFA251		; byte

;; struct PlayerInfo {
;;     unsigned short xpos;
;;     unsigned short ypos;
;;     unsigned short zpos;
;;     unsigned short xaccel;
;;     unsigned short yaccel;
;;     unsigned short zaccel;
;;     unsigned char unknown[64];
;;     unsigned char level;
;;     unsigned char unknown2[51];
;; };
;; extern struct PlayerInfo gPlayerInfo[2];
gPlayerInfo		equ	$FFA25A	

P1_POS_X		equ	$FFA25A		; word
P1_POS_Y		equ	$FFA25C		; word
; ground level is $0, deep in sand is $FFEC, wings top out at about $003A
P1_POS_Z		equ	$FFA25E		; word
P1_ACCEL_X		equ	$FFA260		; word
P1_ACCEL_Y		equ	$FFA262		; word
P1_ACCEL_Z		equ	$FFA264		; word
P1_LEVEL		equ	$FFA2A6		; byte

P2_POS_X		equ	$FFA2DA		; word
P2_POS_Y		equ	$FFA2DC		; word
P2_POS_Z		equ	$FFA2DE		; word
P2_ACCEL_X		equ	$FFA300		; word
P2_ACCEL_Y		equ	$FFA302		; word
P2_ACCEL_Z		equ	$FFA304		; word
P2_LEVEL		equ	$FFA326		; byte

; The idle counter counts up every frame(?) and is reset when the player
; moves. When it exceeds $012C, the player falls asleep.
P1_IDLE_COUNTER		equ	$FFDA44		; word
P2_IDLE_COUNTER		equ	$FFDA46		; word

; Buttons pressed.
P1_KEYDOWN		equ	$FFDA48		; byte
P2_KEYDOWN		equ	$FFDA49		; byte

; Countdown timer for the arrival elevator to depart after players have
; left it.
ARRIVING_ELEV_TIME	equ	$FFDA84		; byte

; This is the level that the departing elevator is on.
DEPARTING_ELEV_LEVEL	equ	$FFDA4E		; byte

; Departing elevator state.
; $00: doors closed
; $01 through $03: doors open(ing)
; $05: liftoff
; $06: engage countdown
DEPARTING_ELEV_STATE	equ	$FFDA4F		; byte

; This is the level that the arriving elevator is on.
ARRIVING_ELEV_LEVEL	equ	$FFDA56		; byte

ARRIVING_ELEV_STATE	equ	$FFDA57		; byte

; These are variables for the departing elevator. The second variable is
; a frame(?) countdown that is initialized set to cycles/2. Every time the
; variable hits zero, "cycles" decrements by one. Once that hits zero,
; we have liftoff. (This is what produces the "charging up" sound effect.)
DEPARTING_ELEV_CYCLES	equ	$FFDA86		; byte
DEPARTING_ELEV_TIME	equ	$FFDA88		; byte

; Present info.
; This is an array of 28 byte pairs. The first byte is the appearance of
; this present, and the second byte is whether or not the present is
; identified. (Index $1B, Bonus Hi-tops, is set to $01 on game start; all
; others are $00.)
;; struct PresentInfo {
;;     unsigned char appearance;
;;     unsigned char identified;
;; };
;; extern struct PresentInfo gPresentInfo[28];
gPresentInfo		equ	$FFDA8A		; struct{byte,byte}[28]

; Inventory. This is an array of present indices.
;; extern unsigned char gPlayerInventory[2][16];
gPlayerInventory	equ	$FFDAC2		; byte[32]

; This seems to be a table of objects on the current map. This is an array
; of 8-byte values:
;; struct Object {
;;     unsigned char type;
;;     unsigned char level;
;;     unsigned char flags; // ($00 offscreen, $06 onscreen?)
;;     unsigned char zsort;
;;     unsigned short xpos;
;;     unsigned short ypos;
;; };
;; #define MAX_OBJECTS 64
;; extern struct Object gObjectTable[MAX_OBJECTS];
gObjectTable		equ	$FFDAE2		; Object[64]

; active powerup
;	$00: wings
;	$01: spring shoes
;	$02: innertube
;	$03: tomatoes
;	$04: slingshot
;	$05: rocket skates
;	$06: rosebushes
;	$07: hitops
; other values are invalid
gPlayer1Powerup		equ	$FFDE50		; byte
gPlayer2Powerup		equ	$FFDE51		; byte
gPlayer1PowerupTimer	equ	$FFDE52		; word
gPlayer2PowerupTimer	equ	$FFDE54		; word

gPlayer1BurpsLeft	equ	$FFDE62		; byte
gPlayer2BurpsLeft	equ	$FFDE63		; byte
gPlayer1BurpTimer	equ	$FFDE64		; byte
gPlayer2BurpTimer	equ	$FFDE65		; byte

gPlayer1RainCloudState	equ	$FFDE66		; byte ($07 when active?)
gPlayer2RainCloudState	equ	$FFDE67		; byte ($08 when active?)
gPlayer1RainCloudTimer	equ	$FFDE68		; word
gPlayer2RainCloudTimer	equ	$FFDE6A		; word

; Countdown until tomato rain expires.
gPlayer1TomatoRainTimer	equ	$FFE1E8		; byte
gPlayer2TomatoRainTimer	equ	$FFE1E9		; byte
; This seems to be a smaller countdown used for regulating individual
; tomatoes. If locked to $00 or $01, tomatoes drop in bursts of 8.
gPlayer1TomatoRainThrottle	equ	$FFE1FA		; byte
gPlayer2TomatoRainThrottle	equ	$FFE1FB		; byte

; Ship-piece levels is an array of ten bytes, with each
; byte corresponding to a particular ship piece.
; 1 through 25 are levels
; if an element is 0, then the players have that piece.
;; #define SHIP_PIECE_COUNT 10
;; extern unsigned char gShipPieceLevels[SHIP_PIECE_COUNT];
gShipPieceLevels	equ	$FFE21C		; byte[10]

gTelephoneActive	equ	$FFE24F		; byte
gTelephoneXPos		equ	$FFE252		; word
gTelephoneYPos		equ	$FFE254		; word
gTelephoneRingsLeft	equ	$FFE260		; byte
gTelephoneTimeToRing	equ	$FFE262		; byte
