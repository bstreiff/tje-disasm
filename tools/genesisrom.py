# Get information from a Sega Genesis ROM header

import struct
from collections import namedtuple, OrderedDict

HeaderField = namedtuple("HeaderField", "offset length pack");

class GenesisRomHeader(OrderedDict):    
    def __init__(self, fielddata):
        OrderedDict.__init__(self, fielddata)

    @classmethod
    def extract_from(cls, rom):
        FIELDS = {
           "system_name": HeaderField(0x100, 0x10, "16s"),
           "copyright_date": HeaderField(0x110, 0x10, "16s"),
           "domestic_game_name": HeaderField(0x120, 0x30, "48s"),
           "overseas_game_name": HeaderField(0x150, 0x30, "48s"),
           "product_number": HeaderField(0x180, 10, "10s"),
           "product_revision": HeaderField(0x18C, 2, "2s"),
           "checksum": HeaderField(0x18E, 2, ">H"),
        };

        fielddata = {}
        for fieldname in FIELDS:
            field = FIELDS[fieldname]

            rom.seek(field.offset)
            data = rom.read(field.length)

            unpacked = struct.unpack(field.pack, data)[0]
            if type(unpacked) is bytes:
                unpacked = unpacked.decode('ascii').strip()
            fielddata[fieldname] = unpacked
        return cls(fielddata)
