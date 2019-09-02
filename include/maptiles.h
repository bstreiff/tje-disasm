#pragma once

#include "asm/bitops.h"

/*
 * Each map tile is represented by a 16-bit value:
 *
 * |---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
 * | F | E | D | C | B | A | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
 * |---|---|---|---|---------------|---|---------------------------|
 * | ? | ? | ? | RM| ROAD TILE ID  | FM|       FLOOR TILE ID       |
 * |---|---|---|---|---------------|---|---------------------------|
 *
 * Each map tile is made up of a floor tile (which contains some combination
 * of space, grass, water, or sand) as well as an optional road overlay.
 * Tiles may also be mirrored horizontally, to make maximal use of the
 * tile set.
 */

/*
 * TODO: these bits are set during map generation but I'm not sure
 *       what they mean. The "hidden passage" bits don't seem to
 *       represent the complete set of information for a hidden
 *       passage. It's possible that these bits are only used during
 *       map generation.
 */
#define MAP_TILE_UNK15_BIT		15	/* "solid"? */
#define MAP_TILE_UNK15			BIT(MAP_TILE_UNK15_BIT)
#define MAP_TILE_UNK14_BIT		14	/* has hidden passage? */
#define MAP_TILE_UNK14			BIT(MAP_TILE_UNK14_BIT)
#define MAP_TILE_UNK13_BIT		13	/* has hidden passage? */
#define MAP_TILE_UNK13			BIT(MAP_TILE_UNK13_BIT)

#define MAP_TILE_MIRROR_ROAD_BIT	12	/* road is flipped horiz */
#define MAP_TILE_ROAD_ID_MASK		0xF
#define MAP_TILE_ROAD_ID_SHIFT		8

#define MAP_TILE_MIRROR_FLOOR_BIT	7	/* floor is flipped horiz */
#define MAP_TILE_FLOOR_ID_SHIFT		0x7F
