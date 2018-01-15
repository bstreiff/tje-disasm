SOURCE_ROM=tjae_rev02.bin
VASM=vasmm68k_mot -m68000 -spaces
OBJDUMP=m68k-linux-gnu-objdump
OBJDUMP_DISASSEMBLE=$(OBJDUMP) -D -b binary -m m68k:68000
OBJDUMP_GETSYMS=$(OBJDUMP) -t
HASH=sha1sum
PYTHON3=python3

SOURCE_ASM := main.asm

OBJDIR := obj
SOURCE_DUMP := $(OBJDIR)/source.dump.txt
SOURCE_HASH := $(OBJDIR)/source.hash.txt
TARGET_ROM := $(OBJDIR)/target.bin
TARGET_DUMP := $(OBJDIR)/target.dump.txt
TARGET_HASH := $(OBJDIR)/target.hash.txt
TARGET_ELF := $(OBJDIR)/target.elf
TARGET_SYMLIST := $(OBJDIR)/target.symlist.txt
TARGET_SYMASM := $(OBJDIR)/target.symbols.asm

OBJS := \
	$(SOURCE_DUMP) \
	$(SOURCE_HASH) \
	$(TARGET_ROM) \
	$(TARGET_DUMP) \
	$(TARGET_HASH) \
	$(TARGET_SYMASM) \

all: $(TARGET_ROM) $(TARGET_SYMASM)

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $(OBJDIR)

clean:
	rm -rf $(OBJDIR)/

$(SOURCE_DUMP): $(SOURCE_ROM)
	@$(OBJDUMP_DISASSEMBLE) $(SOURCE_ROM) > $(SOURCE_DUMP)

$(SOURCE_HASH): $(SOURCE_ROM)
	@$(HASH) $(SOURCE_ROM) | awk '{print $$1}' > $(SOURCE_HASH)

$(TARGET_ELF): $(SOURCE_ASM)
	@$(VASM) -Felf -Iinclude -o $(TARGET_ELF) $(SOURCE_ASM)

$(TARGET_SYMLIST): $(TARGET_ELF)
	@$(OBJDUMP_GETSYMS) $(TARGET_ELF) | tail -n +5 > $(TARGET_SYMLIST)

$(TARGET_SYMASM): $(TARGET_SYMLIST)
	@$(PYTHON3) build_symtab.py -t $(TARGET_SYMLIST) > $(TARGET_SYMASM)

$(TARGET_ROM): $(SOURCE_ASM) $(SOURCE_HASH)
	@$(VASM) -Fbin -Iinclude -o $(TARGET_ROM) $(SOURCE_ASM)
	@$(OBJDUMP_DISASSEMBLE) $(TARGET_ROM) > $(TARGET_DUMP)
	@$(HASH) $(TARGET_ROM) | awk '{print $$1}' > $(TARGET_HASH)
	@diff -q $(SOURCE_HASH) $(TARGET_HASH)
