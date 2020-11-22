from simulated_genesis import SimulatedGenesis
from ctypes import c_uint8, c_uint16, c_uint32
from rle import InterleavedRleDecompressor, RleDecompressor

SpriteUnpackInterleavedRLE = 0x25A52
SpriteUnpackRLE = 0x25B22
SpriteUnpackRaw = 0x25B9C

UnpackBuffer = 0xFFB8DA

ROM_SPRITES = [
    0xD27C4,
    0xE1DFC,
    0xE21BE,
    0xF1A0E,
    0xE81A0,
    0xE81AA,
]

rom = open("tjae_rev02.bin", "rb")

reference = SimulatedGenesis("tjae_rev02.bin")

for sprite_addr in ROM_SPRITES:
    mem = reference.get_mem()
    width = mem.r8(sprite_addr)
    height = mem.r8(sprite_addr + 0x1)
    flags = mem.r8(sprite_addr + 0x5)
    data_addr = mem.r32(sprite_addr + 0x6)

    rom.seek(data_addr)
    expected_bytes = width * height * 32

    if (flags & 0x80) == 0x80:
        func = SpriteUnpackInterleavedRLE
        our_data = InterleavedRleDecompressor.decompress(rom, expected_bytes)
    elif (flags & 0x40) == 0x40:
        func = SpriteUnpackRaw
        our_data = rom.read(expected_bytes)
    else:
        func = SpriteUnpackRLE
        our_data = RleDecompressor.decompress(rom, expected_bytes)

    reference.start(func,
                    c_uint32(width * height),
                    c_uint32(sprite_addr))
    their_data = reference.get_mem().r_block(UnpackBuffer, expected_bytes)
    print("======== SPRITE AT {0:x} =========".format(sprite_addr))
    print(" ".join("{0:02x}".format(n) for n in our_data))
    print(" ".join("{0:02x}".format(n) for n in their_data))
    print(our_data == their_data)
