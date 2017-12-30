; Toejam & Earl RAM locations of interest

KEYDOWN_UP		equ	$01
KEYDOWN_DOWN		equ	$02
KEYDOWN_LEFT		equ	$04
KEYDOWN_RIGHT		equ	$08
KEYDOWN_A		equ	$40
KEYDOWN_B		equ	$10
KEYDOWN_C		equ	$20

; This is a mask of map tiles that have been uncovered. Each level has
; a 8x7 map, so each level occupies 7 bytes.
DISCOVERED_MAP_MASK	equ	$FF91F3		; byte[7][25]

; This is similar to DISCOVERED_MAP_MASK, but it is for the "transparent"
; tiles uncovered by telephones. (Because of the way that these tiles are
; drawn, there is a limit of 20 transparent tiles shown at once; tiles
; over this limit are just not displayed at all.)
TRANSPARENT_MAP_MASK	equ	$FF92A0		; byte[7][25]

; Sprite data for the font. Staging buffer for loading into VDP?
TEXT_SPRITE_DATA_START	equ	$FF9388
TEXT_SPRITE_DATA_LEN	equ	$EC0

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
PRESENT_INFO		equ	$FFDA8A		; struct{byte,byte}[28]

; Inventory. This is an array of present indices.
PLAYER_INVENTORY	equ	$FFDAC2		; byte[32]
P1_INVENTORY		equ	$FFDAC2		; byte[16]
P2_INVENTORY		equ	$FFDAD2		; byte[16]

; This seems to be a table of objects on the current map. This is an array
; of 8-byte values:
; struct {
;     byte   type
;     byte   level(?)
;     byte   flags(?) ($00 offscreen, $06 onscreen?)
;     byte   z sort order(?)
;     word   x position
;     word   y position
; } Object
OBJECT_TABLE		equ	$FFDAE2		; Object[64]

P1_LIVES		equ	$FFA248		; byte
P2_LIVES		equ	$FFA249		; byte
P1_BUCKS		equ	$FFA24A		; byte
P2_BUCKS		equ	$FFA24B		; byte
P1_POINTS		equ	$FFA24C		; word
P2_POINTS		equ	$FFA24E		; word
P1_RANK			equ	$FFA250		; byte
P2_RANK			equ	$FFA251		; byte

; Ship-piece levels is an array of ten bytes, with each
; byte corresponding to a particular ship piece.
; 1 through 25 are levels
; if an element is 0, then the players have that piece.
SHIP_PIECE_LEVELS	equ	$FFE21C		; byte[10]
SHIP_PIECE_COUNT	equ	10

TELEPHONE_ACTIVE	equ	$FFE24F		; byte
TELEPHONE_XPOS		equ	$FFE252		; word
TELEPHONE_YPOS		equ	$FFE254		; word
TELEPHONE_RINGS_LEFT	equ	$FFE260		; byte
TELEPHONE_TIME_TO_RING	equ	$FFE262		; byte
