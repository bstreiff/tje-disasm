# Differences between REV00 and REV02

## offset 0x008836

In REV02, when opening the map, the player's idle counter (e.g., the thing
keeping track of whether the player falls asleep) is reset to 0. In REV00,
it is not.

## offset 0x008F3A

Similarly, in REV02, opening the present menu also clears the idle counter,
whereas in REV00 it does not.

## offset 0x00DD82

Unclear. The value `0x3A400` (REV00) or `0x3A410` (REV02) is AND'ed with a
register value retrieved from `0xFFA2AC` (offset 0x52 from A2).

This appears to be some sort of state bits that vary based on player
animation.

## offset 0x012342

In REV02 there is a test against `0xFFE236` that does not exist in REV00.

## offset 0x017254

This seems to be the "opening rosebushes" present.

In REV02 there is a test against `0xFFDA22` that does not exist in REV00.

In the state bits (0x52 offset in player info) are AND'd against
`0x0004C81C` (REV00) or `0x0804C81C` (REV02) at a point in this function.
The bit difference seems to be related to the hitops running animation.

## offset 0x01F6D0

One test does a 8-bit comparison against D0 in REV00 and a 16-bit comparison
in REV02.

In REV02, there are comparisons made against valuex 0x4E and 0x4F against
0x4B(A3) (with A3 pointing to the player info struct). The code happens
twice in this function; one time for Toejam (A3 == `0xFFA2AC`) and two time
for Earl (A3 is set to 0x80(A2)). (The way the compiler has unrolled this
seems particularly weird.)

## offset 0x027A10

Lots of changes. In REV00, the compiler put `0xFF800E` into a register (A3),
whereas in REV02 it did not, and that's shifted the register allocations in
this function between the two revs.

The substantive change is that in REV00, we copy `*(0xFF800E)` into D4 and
also into 0xFFE39C. In REV00, we set the values at `0xFF800E` and `0xFFE39C`
to 0.

## offset 0x03A4E4

This function seems to have something to do with the "SEGA" intro screen.

In REV02 `0xFF800E` is set to 0 at a place where it is not in REV00.
