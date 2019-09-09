#pragma once

// Values for the 0x52 offset from 0xFFA25A (0xFFA2AC), which seem
// to be some sort of player state bits. Maybe something to do with
// which animation set we're in?
//
// I'm not 100% confident with these.

#define PS_IDLE		0x00000001	// at idle
#define PS_WINGSOUT	0x00000002	// on ground with wings / also when dying as a ghost
#define PS_WALKING	0x00000004	// while moving
#define PS_SNEAKING	0x00000008	// sneaking
#define PS_TEETERING	0x00000010	// teetering over an edge
#define PS_FALLING	0x00000020	// falling over an edge
#define PS_BOUNCING	0x00000040	// bouncing on your butt
#define PS_DIVE_PREP	0x00000080	// in preparing to dive
#define PS_DIVE_STAGE1	0x00000100	// in first part of dive
#define PS_DIVE_STAGE2	0x00000200	// in second part of dive
#define PS_DIVE_SPLASH	0x00000400	// in splash part of dive
#define PS_UNDERWATER	0x00000800	// underwater
#define PS_CLIMBING	0x00001000	// climbing out of water
#define PS_YOUCH	0x00002000	// taking damage from a youch
#define PS_SPRINGSHOES	0x00004000	// wearing spring shoes
#define PS_FLYING	0x00008000	// in air with wings
#define PS_UNKNOWN1	0x00010000	// TODO: movement locked when set
#define PS_ZAPPED	0x00020000	// taking damage from rain cloud / also extra-life/total-bummer?
#define PS_TUBE_SWIM	0x00040000	// swimming with innertube
#define PS_TUBE_IDLE	0x00080000	// standing idle wearing an innertube
#define PS_TOMATO	0x00100000	// throwing a tomato
#define PS_SLINGSHOT	0x00200000	// firing a sling shot
#define PS_DANCING	0x00400000	// hula dancing
#define PS_UNKNOWN2	0x00800000	// TODO: unknown
#define PS_SKATES_HOLD	0x01000000	// with rocket skates when holding a jump
#define PS_SKATES_WATER	0x02000000	// with rocket skates across the water
#define PS_SKATES_AIR	0x04000000	// with rocket skates in air
#define PS_HITOPS_RUN	0x08000000	// hitops running
#define PS_HITOPS_JUMP	0x10000000	// hitops leap
#define PS_SLEEPING	0x20000000	// sleeping (idle too long / schoolbook)
#define PS_UNKNOWN3	0x40000000	// TODO: movement locked when set
#define PS_UNKNOWN4	0x80000000	// TODO: unknown
