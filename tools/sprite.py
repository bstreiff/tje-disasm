#!/usr/bin/env python3

import struct
from functools import reduce
from rle import InterleavedRleDecompressor, RleDecompressor
from resource import Resource, ResourceKind

class SpriteFlags:
    COMPRESSION_INTERLEAVED = 0x80
    COMPRESSION_NONE = 0x40

class Rect:
    def __init__(self, ival=None):
        if ival == None:
            self.val = (0,0,0,0)
        else:
            self.val = ival

    def __getitem__(self, i):
        return self.val[i]

    def __setitem__(self, i, v):
        self.val[i] = v

    def __len__(self):
        return len(self.val)

    def __str__(self):
        return self.val.__str__()

    def move(self, x, y):
        return Rect((self[0] + x, self[1] + y, self[2], self[3]))

    # return a new rect that is the union of self and other
    def union(self, other):
        a = (self[0], self[1], self[2]+self[0], self[3]+self[1])
        b = (other[0], other[1], other[2]+other[0], other[3]+other[1])
        u = ( min(a[0], b[0]), min(a[1], b[1]),
              max(a[2], b[2]), max(a[3], b[3]) )
        return Rect((u[0], u[1], u[2]-u[0], u[3]-u[1]))

# A Sprite is a single hardware sprite.
class Sprite:
    def __init__(self, name=None, width=0, height=0, offset=(0,0,0), flags=0, data=b'', address=0, data_address=0, zlength=0):
        self.name = name
        self.width = width
        self.height = height
        self.offset = offset
        self.flags = flags
        self.data = data
        self.name = name
        self.header_resource = Resource(ResourceKind.SPRITE_HEADER,
                                        address, 10)
        self.data_resource = Resource(ResourceKind.SPRITE_DATA,
                                      data_address, zlength)

    def write_asm(self, io):
        if self.name:
            io.write("%s:\n" % (self.name))
        io.write("\tdc.b\t%u, %u\n" % (self.width, self.height))
        io.write("\tdc.b\t%d, %d, %d\n" % (self.offset[0], self.offset[1], self.offset[2]))
        io.write("\tdc.b\t%02X\n" % self.flags)
        io.write("\tdc.l\t%s_data\n" % self.name)

    def palette_id(self):
        return self.flags & 0x3

    def bounds(self):
        return Rect((self.offset[0], self.offset[1], self.width*8, self.height*8))

    # Generate a series of (x, y, index) tuples that describe
    # how to draw this sprite onto a canvas of size width*8, height*8
    def pixel_generator(self):
        total_tiles = self.width * self.height
        for b in range(0, 32*total_tiles):
            value = self.data[b]
            val1 = (value & 0xF0) >> 4
            val2 = (value & 0x0F)
            # This is the position within this VDP tile
            sub_y = int((b % 32) / 4)
            sub_x = int(b % 4)
            # In VDP draw order, tiles are "down, then across"
            # In other words, given tiles 0..F (4x4), we have
            #   0  4  8  C
            #   1  5  9  D
            #   2  6  A  E
            #   3  7  B  F
            tile = int(b / 32)
            x = (int(tile / self.height)*4 + sub_x) * 2
            y = int(tile % self.height)*8 + sub_y
            yield (x, y, val1)
            yield (x+1, y, val2)

    @classmethod
    def extract_from(cls, rom):
        header = struct.unpack(">BBbbbBIxx", rom.read(12))
        width = header[0]
        height = header[1]
        offset = (header[2], header[3], header[4])
        flags = header[5]
        data_address = header[6]
        address = rom.tell()
        name = "loc_%08X" % address

        total_tiles = width * height
        # 8x8 at 4bpp == 32 bytes
        expected_bytes = total_tiles * 32

        if (width > 0x04):
            raise ValueError("more than four tiles wide, not valid")
        elif (height > 0x04):
            raise ValueError("more than four tiles high, not valid")
        elif (data_address >= 0x0FFFFF):
            raise ValueError("data address lies outside rom, not valid")
        elif (data_address <= 0x200):
            raise ValueError("data address in cart header, not valid")
        elif not abs(data_address - address) < 0x2000:
            raise ValueError("data address is quite far, seems fishy")

        rom.seek(data_address)
        if flags & SpriteFlags.COMPRESSION_INTERLEAVED:
            data = InterleavedRleDecompressor.decompress(rom, expected_bytes)
        elif flags & SpriteFlags.COMPRESSION_NONE:
            data = rom.read(expected_bytes)
        else:
            data = RleDecompressor.decompress(rom, expected_bytes)
        zlength = rom.tell() - data_address
        if zlength % 2 == 1:
            zlength += 1
        if zlength == 0:
            raise ValueError("zero-length sprite is not valid")

        return cls(name, width, height, offset, flags, data, address, data_address, zlength)


# A MetaSprite is a collection of one or more sprites
# used to build up a larger apparent sprite
class MetaSprite:
    def __init__(self, name=None, sprites=[], address=0):
        self.name = name
        self.sprites = sprites
        self.resource = Resource(ResourceKind.METASPRITE_HEADER,
                                 address, 4+(10*len(self.sprites)))

    def write_asm(self, io):
        if self.name:
            io.write("%s:\n" % (self.name))
        io.write("\tdc.b\t%u\n" % len(self.sprites) )
        io.write("\tdc.b\t%d, %d, %d\t\n" % (0,0,0))

    def bounds(self):
        b = self.sprites[0].bounds()
        return reduce((lambda x, y: Rect.union(x, y)),
                      [s.bounds() for s in self.sprites])

    def draw_to_surface(self, surface, palette_group, offset):
        surface.lock()
        for s in self.sprites:
            pal = palette_group[s.palette_id()]
            for pixel in s.pixel_generator():
                (x, y, index) = pixel
                x += s.offset[0] + offset[0]
                y += s.offset[1] + offset[1]
                if index != 0:
                    surface.set_at((x, y), pal[index])
        surface.unlock()

    @classmethod
    def extract_from(cls, rom):
        start_address = rom.tell()
        header = struct.unpack(">bbbb", rom.read(4))
        sprite_count = header[0]

        if sprite_count == 0:
            raise ValueError("metasprite must contain at least one sprite")

        sprites = []
        name = "loc_%08X" % rom.tell()

        address = rom.tell()
        for s in range(0, sprite_count):
            rom.seek(address + s*10)
            sprites.append(Sprite.extract_from(rom))

        if len(sprites) != sprite_count:
            raise ValueError("didn't extract sprites properly")

        return cls(name, sprites, start_address)

# A PaletteEntry is a single CRAM (color ram) value
class PaletteEntry:
    def __init__(self, cram, transparent=False):
        self.cram = cram
        self.transparent = transparent

    def rgb(self):
        blue =  (self.cram & 0x0E00) >> 4
        green = (self.cram & 0x00E0)
        red =   (self.cram & 0x000E) << 4
        return (red, green, blue)

    def rgba(self):
        rgb = self.rgb()
        if self.transparent:
            return (1, 1, 1, 0x00)
        else:
            return (rgb[0], rgb[1], rgb[2], 0xFF)

# A Paleete is a collection of 32 palette entries
class Palette:
    def __init__(self, entries=[]):
        self.entries = entries

    def __getitem__(self, key):
        return self.entries[key]

    def rgb(self):
        return [x.rgb() for x in self.entries]

    def rgba(self):
        return [x.rgba() for x in self.entries]

    @classmethod
    def extract_from(cls, rom):
        values = struct.unpack(">16H", rom.read(32));
        return cls([PaletteEntry(i, i == 0) for i in values])
