SOURCE_ROM=tjae_rev02.bin
GAME_REVISION:=$(shell tools/rominfo.py -r $(SOURCE_ROM))
VASM=vasmm68k_mot -DCPU_M68K -m68000 -spaces -maxerrors=0 -DGAME_REVISION=$(GAME_REVISION)
VASM_Z80=vasmz80_mot -DCPU_Z80 -spaces -maxerrors=0
OBJDUMP=m68k-linux-gnu-objdump
OBJDUMP_DISASSEMBLE=$(OBJDUMP) -D -b binary -m m68k:68000
OBJDUMP_GETSYMS=$(OBJDUMP) -t
HASH=sha1sum
PYTHON3=python3

SOURCE_ASM := main.asm

OBJDIR := obj
SOURCE_DUMP := $(OBJDIR)/source.$(GAME_REVISION).dump.txt
SOURCE_HASH := $(OBJDIR)/source.$(GAME_REVISION).hash.txt
TARGET_ROM := $(OBJDIR)/target.bin
TARGET_DUMP := $(OBJDIR)/target.dump.txt
TARGET_HASH := $(OBJDIR)/target.hash.txt
TARGET_ELF := $(OBJDIR)/target.elf
TARGET_SYMLIST := $(OBJDIR)/target.symlist.txt
TARGET_SYMASM := $(OBJDIR)/include/basegame_gen.S
TARGET_HEADER := $(OBJDIR)/include/basegame_gen.h
TARGET_RAM_HEADER := $(OBJDIR)/include/basegame_ram_gen.h

Z80_DRIVER_SRC := src/SoundDriver.z80.asm
Z80_DRIVER_BIN := obj/SoundDriver.z80.bin

OBJS := \
	$(SOURCE_DUMP) \
	$(SOURCE_HASH) \
	$(TARGET_ROM) \
	$(TARGET_DUMP) \
	$(TARGET_HASH) \
	$(TARGET_SYMASM) \
	$(TARGET_HEADER) \
	$(TARGET_RAM_HEADER) \

all: $(OBJS)

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $(OBJDIR)
	@mkdir -p $(OBJDIR)/include

clean:
	rm -rf $(OBJDIR)/

$(Z80_DRIVER_BIN): $(Z80_DRIVER_SRC)
	@$(VASM_Z80) -Fbin -Iinclude -o $(Z80_DRIVER_BIN) $(Z80_DRIVER_SRC)

$(SOURCE_DUMP): $(SOURCE_ROM)
	@$(OBJDUMP_DISASSEMBLE) $(SOURCE_ROM) > $(SOURCE_DUMP)

$(SOURCE_HASH): $(SOURCE_ROM)
	@$(HASH) $(SOURCE_ROM) | awk '{print $$1}' > $(SOURCE_HASH)

$(TARGET_ELF): $(SOURCE_ASM) $(Z80_DRIVER_BIN)
	@$(VASM) -Felf -Iinclude -o $(TARGET_ELF) $(SOURCE_ASM)

$(TARGET_SYMLIST): $(TARGET_ELF)
	@$(OBJDUMP_GETSYMS) $(TARGET_ELF) | tail -n +5 > $(TARGET_SYMLIST)

$(TARGET_ROM): $(SOURCE_ASM) $(SOURCE_HASH) $(Z80_DRIVER_BIN)
	$(VASM) -Fbin -Iinclude -o $(TARGET_ROM) $(SOURCE_ASM)
	@$(OBJDUMP_DISASSEMBLE) $(TARGET_ROM) > $(TARGET_DUMP)
	@$(HASH) $(TARGET_ROM) | awk '{print $$1}' > $(TARGET_HASH)
	@diff -q $(SOURCE_HASH) $(TARGET_HASH)

$(TARGET_SYMASM): $(TARGET_SYMLIST)
	@$(PYTHON3) tools/build_symtab.py $< > $@

$(TARGET_HEADER): $(SOURCE_ASM)
	@$(PYTHON3) tools/get_header_comments.py $< > $@

$(TARGET_RAM_HEADER): include/tjae_memory.asm
	@$(PYTHON3) tools/get_header_comments.py $< > $@

