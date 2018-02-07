#!/usr/bin/env python3

import struct
from rle import InterleavedRleDecompressor, RleDecompressor

class SpriteFlags:
    COMPRESSION_INTERLEAVED = 0x80
    COMPRESSION_NONE = 0x40

# A Sprite is a single hardware sprite.
class Sprite:
    def __init__(self, name=None, width=0, height=0, offset=(0,0,0), flags=0, data=b''):
        self.name = name
        self.width = width
        self.height = height
        self.offset = offset
        self.flags = flags
        self.data = data
        self.name = name

    def write_asm(self, io):
        if self.name:
            io.write("%s:\n" % (self.name))
        io.write("\tdc.b\t%u, %u\n" % (self.width, self.height))
        io.write("\tdc.b\t%d, %d, %d\n" % (self.offset[0], self.offset[1], self.offset[2]))
        io.write("\tdc.b\t%02X\n" % self.flags)
        io.write("\tdc.l\t%s_data\n" % self.name)

    @classmethod
    def extract_from(cls, rom):
        header = struct.unpack(">BBbbbBIxx", rom.read(12))
        width = header[0]
        height = header[1]
        offset = (header[2], header[3], header[4])
        flags = header[5]
        data_address = header[6]
        name = "loc_%08X" % rom.tell()

        total_tiles = width * height
        # 8x8 at 4bpp == 32 bytes
        expected_bytes = total_tiles * 32

        if (width > 0x04):
            raise ValueError("more than four tiles wide, not valid")
        elif (height > 0x04):
            raise ValueError("more than four tiles high, not valid")
        elif (data_address >= 0x0FFFFF):
            raise ValueError("data address lies outside rom, not valid")

        rom.seek(data_address)
        if flags & SpriteFlags.COMPRESSION_INTERLEAVED:
            data = InterleavedRleDecompressor.decompress(rom, expected_bytes)
        elif flags & SpriteFlags.COMPRESSION_NONE:
            data = rom.read(expected_bytes)
        else:
            data = RleDecompressor.decompress(rom, expected_bytes)

        return cls(name, width, height, offset, flags, data)


# A MetaSprite is a collection of one or more sprites
# used to build up a larger apparent sprite
class MetaSprite:
    def __init__(self, name=None, sprites=[]):
        self.name = name
        self.sprites = sprites

    def write_asm(self, io):
        for s in self.sprites:
            s.write_asm(io)

        if self.name:
            io.write("%s:\n" % (self.name))
        io.write("\tdc.b\t%u\n" % len(self.sprites) )
        io.write("\tdc.b\t%d, %d, %d\t\n" % (0,0,0))
        for s in self.sprites:
            io.write("\tdc.l\t%s\n" % s.name)

    @classmethod
    def extract_from(cls, rom):
        header = struct.unpack(">bbbb", rom.read(4))
        sprite_count = header[0]
        sprites = []
        name = "loc_%08X" % rom.tell()

        address = rom.tell()
        for s in range(0, sprite_count):
            rom.seek(address + s*10)
            sprites.append(Sprite.extract_from(rom))

        return cls(name, sprites)

# A PaletteEntry is a single CRAM (color ram) value
class PaletteEntry:
    def __init__(self, cram):
        self.cram = cram

    def rgb(self):
        blue =  (self.cram & 0x0E00) >> 4
        green = (self.cram & 0x00E0)
        red =   (self.cram & 0x000E) << 4
        return (red, green, blue)

# A Paleete is a collection of 32 palette entries
class Palette:
    def __init__(self, entries=[]):
        self.entries = entries

    def __getitem__(self, key):
        return self.entries[key]

    @classmethod
    def extract_from(cls, rom):
        values = struct.unpack(">16H", rom.read(32));
        return cls([PaletteEntry(i) for i in values])
