#!/usr/bin/env python3

import io
import struct

class InterleavedRleDecompressor:
    def decompress(data, max_length=0):
        if (type(data) is bytes or type(data) is bytearray):
           data = io.BytesIO(data)

        decompressed = bytearray(max_length)
        outpos = 0
        decompressed_bytes = 0

        for s in range(0, 4):
            outpos = s
            decompressed_bytes = 0

            while decompressed_bytes < int(max_length / 4):
                readvalue = data.read(1)
                token = struct.unpack(">b", readvalue)[0]

                if token < 0:
                    # token is between 0x80 and 0xFF
                    if token & 0x40:	# test bit 6
                        # token is between 0xC0 and 0xFF
                        val = struct.unpack(">B", data.read(1))[0]
                    else:
                        # token is between 0x80 and 0xBF
                        val = 0
                        token = token | 0x40
                    token = -token

                    for i in range(0, token):
                       decompressed[outpos] = val
                       outpos += 4
                else:
                    # token is between 0x00 and 0x7F
                    if token & 0x40:	# test bit 6
                        # token is between 0x40 and 0x7F
                        if token & 0x20:	# test bit 5
                            # token is between 0x40 and 0x5F
                            val = struct.unpack(">B", data.read(1))[0]
                            swapval = ((val << 4) & 0xF0) | ((val >> 4) & 0x0F)
                            token = token & 0x1F
                            for i in range(0, int(token / 2) - 1):
                                decompressed[outpos] = val
                                decompressed[outpos+4] = swapval
                                outpos += 8
                            if token % 2 == 0:
                                decompressed[outpos] = val
                                outpos += 4
                        else:
                            # token is between 0x60 and 0x7F
                            val = 0xFF
                            token = token & 0x1F
                            for i in range(0, token):
                                decompressed[outpos] = val
                                outpos += 4
                    else:
                        # token is between 0x00 and 0x3F
                        for i in range(0, token):
                            val = struct.unpack(">B", data.read(1))[0]
                            decompressed[outpos] = val
                            outpos += 4

                decompressed_bytes += token

        return bytes(decompressed)



class RleDecompressor:
    def decompress(data, max_length=0):
        if (type(data) is bytes or type(data) is bytearray):
           data = io.BytesIO(data)

        decompressed = bytearray()

        while max_length != 0 and len(decompressed) <= max_length:
            if data.peek(1) == 0:
                break
            token = data.read(1)[0]

            # need this to be a signed byte to make the conditionals work out
            if (token >= 128):
                token = -(256 - token);

            if (token <= -64):
                count = -64 - token
                decompressed.extend( (b'\x00' * count) )
            elif (token >= 64):
                count = token - 64
                decompressed.extend( (b'\xFF' * count) )
            elif (token < 0):
                count = -token
                data_to_copy = data.read(1)[0]
                decompressed.extend( [data_to_copy] * count )
            else:
                count = token
                direct_data = data.read(count)
                decompressed.extend( direct_data )

        return bytes(decompressed)

# TODO; smaller testcases
if __name__ == "__main__":
    compressed = bytes([0xBC, 0x24, 0x44, 0x40, 0x00, 0x04, 0x44, 0xE4,
                        0x00, 0x4E, 0x04, 0xEE, 0x44, 0xE5, 0x04, 0x4E,
                        0xEE, 0xE6, 0x00, 0x44, 0xEE, 0xEE, 0xFF, 0xF4,
                        0x4E, 0xEE, 0x0F, 0xFF, 0x44, 0xEE, 0x00, 0x0F,
                        0xF4, 0x44, 0x00, 0x00, 0x0F, 0xFF, 0xA8, 0xFE,
                        0x44, 0x0F, 0x40, 0x00, 0x57, 0x55, 0x44, 0x44,
                        0x55, 0xEE, 0xEE, 0xE4, 0xE5, 0x55, 0x6E, 0xEE,
                        0x57, 0xFE, 0x5E, 0xFE, 0xEE, 0x08, 0x55, 0x64,
                        0x4E, 0x55, 0x75, 0x00, 0x04, 0x44, 0x43, 0x01,
                        0x4F, 0x47, 0xA0, 0x01, 0x40, 0xBD, 0x01, 0x44,
                        0xBD, 0x14, 0xE4, 0x40, 0x00, 0x00, 0xEE, 0x44,
                        0x00, 0x00, 0x4E, 0xE4, 0x40, 0x00, 0x44, 0x44,
                        0x40, 0x00, 0xFF, 0xFF, 0xF0, 0x00, 0x43, 0xA7])

    expected = bytes([0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00, 0x04,
                      0x44, 0xE4, 0x00, 0x4E, 0x04, 0xEE, 0x44, 0xE5,
                      0x04, 0x4E, 0xEE, 0xE6, 0x00, 0x44, 0xEE, 0xEE,
                      0xFF, 0xF4, 0x4E, 0xEE, 0x0F, 0xFF, 0x44, 0xEE,
                      0x00, 0x0F, 0xF4, 0x44, 0x00, 0x00, 0x0F, 0xFF,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x44, 0x44, 0x40, 0x00, 0x57, 0x55, 0x44, 0x44,
                      0x55, 0xEE, 0xEE, 0xE4, 0xE5, 0x55, 0x6E, 0xEE,
                      0x57, 0x5E, 0x5E, 0xEE, 0xEE, 0x55, 0x64, 0x4E,
                      0x55, 0x75, 0x00, 0x04, 0x44, 0xFF, 0xFF, 0xFF,
                      0x4F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x40, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00,
                      0xE4, 0x40, 0x00, 0x00, 0xEE, 0x44, 0x00, 0x00,
                      0x4E, 0xE4, 0x40, 0x00, 0x44, 0x44, 0x40, 0x00,
                      0xFF, 0xFF, 0xF0, 0x00, 0xFF, 0xFF, 0xFF, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])

    print(RleDecompressor.decompress(compressed, 512) == expected)
