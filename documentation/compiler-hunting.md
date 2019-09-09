Based on disassembly thus far, it feels like this game was written in C.

The biggest evidence for this is the function at offset 0x27A10 (in REV 02).
In REV 00, the RAM address 0xFF800E occupies A3 and CopyPaletteToCRAMSlot is
in A4; in REV 02, 0xFF800E is used as an operand to CMPI directly, and
CopyPaletteToCRAMSlot goes into A3 instead. This feels like it was a bugfix,
but the way in which it was done seems unusual if the game were written in assembly--
In that case, CopyPaletteToCRAMSlot would probably stay in A4 and A3 might simply become
unused. However, the way that the values are adjusted makes more sense if
it was a compiler that allocated such registers.

The question then becomes, is it possible to identify the compiler?

Being able to identify the compiler would be a boon for a "decompilation"
effort-- see, for instance, the work done for [Super Mario 64](https://github.com/n64decomp/sm64)
and [Majora's Mask](https://github.com/Rozelette/Majora-Unmasked), where the
authors have used the original IRIX compiler to reverse-engineer C that
recompiles as a bit-perfect match.

However, the 68000 as used in the Sega Genesis was a popular chip in the
time, and this means a lot of compilers.

Fortunately, what we do have is the disassembly for a number of functions
that would be part of the compiler toolchain. Of note are the following:

*Compiler support routines:* Functions like [`__moddi3`, `__divdi3`, `__muldi3`,
and `__umoddi3`](https://gcc.gnu.org/onlinedocs/gccint/Integer-library-routines.html),
or some equivalent thereof (different compilers spell their names
differently), must be added by the compiler in order to support 32-bit
multiplication/division/modulus on the 68000, as it did not have native
support until the 68020.

*C library routines:* Functions like
[`abs`](https://en.cppreference.com/w/c/numeric/math/abs) and
[`rand`](https://en.cppreference.com/w/c/numeric/random/rand). This is a
little bit harder to treat as a match, because, as a game highly focused
around random number generation, it's not unlikely that Toejam and Earl has
its own implementation of a random number generator instead of using the
compiler-provided one (many C `rand` implementations have a low `RAND_MAX`
and are not very random).

It should also be noted that there is a paper that exists discussing a
"minimal standard" random number generator (["Random number generators: good ones are hard to find"](https://www.researchgate.net/publication/220420979_Random_Number_Generators_Good_Ones_Are_Hard_to_Find))
which has sample code written in Pascal.

With that in mind, what compilers could have been used in that era? In my
mind, the most likely candidates would have been hosted on DOS or Amiga.

What things have I looked at?

### Sierra 68000 C Compiler

[Sega Retro](https://segaretro.org)'s page on [this
compiler](https://segaretro.org/Sierra_68000_C_Compiler) indicates that it
was licensed to Sega for their official developer kits.

The earliest version of this compiler that I could find was on a [Sega Channel Dev
Disc](https://hiddenpalace.org/Sega_Channel_%28January_1996_dev_disc%29).
This includes version 3.1b of the Sierra compiler. Unfortunately I cannot
find a disk image of any earlier version (particularly one dating from 1991).

The compiler support routines for division are in lib/src/div32.s;
unfortunately this looks nothing like the function we've identified as
`__divdi3`.

### Lattice Amiga C Compiler v5.1 (1990)

Dates from [about 1990](https://archive.org/details/Lattice_C_v5.10_Volume_1_1990_SAS_Institute/page/n35).

### DJGPP

There's a FAQ entry that talks about [using DJGPP as a cross-compiler for
Motorola 68K targets](http://www.delorie.com/djgpp/v2faq/faq22_9.html).
Could this have been used for the Sega Genesis? Seems unlikely.

