#!/bin/sh
# Exodus made every branch it could find a global branch ("loc_XXXX").
# To make things a bit clearer, I wanted to make as many labels as I could
# local. Doing this manually got to be a bit tedious.
# This was the script I used to automate it.
#
# It's not perfect-- it operates under the assumption that anything that's
# the target of a branch should be local. It's also terribly inefficient,
# but I only had to run it once, so whatever.
#
# Things it missed:
# - jump tables
# - anywhere that branched back to the start of the subroutine
# - some weirdo subroutines that branch between each other
#
# so there was still some manual fixups.

# find all otherwise-unnamed labels that are the target of a branch instruction (not a jump!)
grep -P 'B(RA|CC|LS|CS|LT|EQ|MI|F|NE|GE|PL|GT|T|HI|VC|LE|VS).[wb]\tloc' main.asm | awk '{print $2}' | sort -u > locals.txt

# replace each of those labels with a local label (one prefixed by .)
<locals.txt xargs -I % sed -i s/%/.%/\; main.asm
