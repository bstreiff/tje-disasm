This is an analysis of the Sega Genesis game "Toejam and Earl".

--

DISCLAIMER: Any and all content presented in this repository is presented for
informational and educational purposes only. Commercial usage is expressly
prohibited. I claim no ownership of any code in this repository. You assume
any and all responsibility for using this content responsibly. I claim no
responsibility or warranty.

--

Two known revisions of this game exist:

REV 00:
Typical Filename: Toejam & Earl (U) (REV 00) [!].bin
CRC32:    d1b36786
md5sum:   0a6af20d9c5b3ec4e23c683f083b92cd
sha1sum:  7f82d8b57fff88bdca5d8aff85b01e231dc1239a

REV 02:
Typical Filename: Toejam & Earl (U) (REV 02).bin
CRC32:    7a588f4b
md5sum:   72dc91fd2c5528b384f082a38db9ddda
sha1sum:  85e8d0a4fac591b25b77c35680ac4175976f251b

REV 00 exists as a cartridge.
REV 02 appears to be the version currently distributed on Steam.

This analysis is presently focused on the REV 02 version.

It it unknown what substantial differences exist between the two, aside from
some minor code differences that cause all the offsets to shift around.

This analysis utilizes game content from the REV 02 version of the game.
In order to use the tooling, you will need a REV 02 ROM, which you should
rename as 'tjae_rev02.bin' in the root directory.

You can obtain such a ROM by purchasing it from Steam (on Windows).
- http://store.steampowered.com/app/71166/ToeJam__Earl/

Once installed, it can be found at:
- `<Steam Directory>\SteamApps\common\Sega Classics\uncompressed ROMs\ToeJamEarl.SGD`

You will also need:
- [VASM](http://sun.hasenbraten.de/vasm/)
- m68k objdump. For Ubuntu/Debian, consider the "binutils-m68k-linux-gnu" package.
- python 3

For debugging purposes, I have found [Exodus](https://www.exodusemulator.com/) to
be an excellent choice.
