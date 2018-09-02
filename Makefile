SOURCE_ROM=tjae_rev02.bin
GAME_REVISION:=$(shell tools/rominfo.py -r $(SOURCE_ROM))
OBJDUMP=m68k-linux-gnu-objdump
OBJDUMP_DISASSEMBLE=$(OBJDUMP) -D -b binary -m m68k:68000
OBJDUMP_GETSYMS=$(OBJDUMP) -t
HASH=sha1sum
PYTHON3=python3
CPP=m68k-linux-gnu-cpp
CC=m68k-linux-gnu-gcc
OBJCOPY=m68k-linux-gnu-objcopy
Z80_AS=z80-unknown-coff-as
Z80_OBJCOPY=z80-unknown-coff-objcopy

SOURCE_ASM := src/main.S

OBJDIR := obj
SOURCE_DUMP := $(OBJDIR)/source.$(GAME_REVISION).dump.txt
SOURCE_HASH := $(OBJDIR)/source.$(GAME_REVISION).hash.txt
TARGET_ROM := $(OBJDIR)/target.bin
TARGET_DUMP := $(OBJDIR)/target.dump.txt
TARGET_HASH := $(OBJDIR)/target.hash.txt
TARGET_ELF := $(OBJDIR)/target.elf

Z80_DRIVER_SRC := src/SoundDriver.z80.S
Z80_DRIVER_BIN := obj/SoundDriver.z80.bin

OBJS := \
	$(SOURCE_DUMP) \
	$(SOURCE_HASH) \
	$(TARGET_ROM) \
	$(TARGET_DUMP) \
	$(TARGET_HASH) \

all: $(OBJS)

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $(OBJDIR)
	@mkdir -p $(OBJDIR)/include

clean:
	rm -rf $(OBJDIR)/

obj/SoundDriver.tmp.s: $(Z80_DRIVER_SRC)
	@$(CPP) -D__z80__ -I include -E $< -o $@

obj/SoundDriver.z80.o: obj/SoundDriver.tmp.s
	@$(Z80_AS) $< -o $@

$(Z80_DRIVER_BIN): obj/SoundDriver.z80.o
	@$(Z80_OBJCOPY) -O binary $< $@

$(SOURCE_DUMP): $(SOURCE_ROM)
	@$(OBJDUMP_DISASSEMBLE) $(SOURCE_ROM) > $(SOURCE_DUMP)

$(SOURCE_HASH): $(SOURCE_ROM)
	@$(HASH) $(SOURCE_ROM) | awk '{print $$1}' > $(SOURCE_HASH)

$(TARGET_ELF): $(SOURCE_ASM) $(Z80_DRIVER_BIN)
	@$(CC) -O0 -DGAME_REVISION=$(GAME_REVISION) -T src/genesis.ld -nostdlib -ffreestanding -m68000 -Wa,--bitwise-or -Wa,--register-prefix-optional -Wl,--oformat -Wl,elf32-m68k -Wl,--build-id=none -Iinclude $< -o $@

$(TARGET_SYMLIST): $(TARGET_ELF)
	@$(OBJDUMP_GETSYMS) $(TARGET_ELF) | tail -n +5 > $(TARGET_SYMLIST)

$(TARGET_ROM): $(TARGET_ELF) $(SOURCE_HASH) $(Z80_DRIVER_BIN)
	@$(OBJCOPY) -O binary $(TARGET_ELF) $(TARGET_ROM)
	@$(OBJDUMP_DISASSEMBLE) $(TARGET_ROM) > $(TARGET_DUMP)
	@$(HASH) $(TARGET_ROM) | awk '{print $$1}' > $(TARGET_HASH)
	@diff -q $(SOURCE_HASH) $(TARGET_HASH)
