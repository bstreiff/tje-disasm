SOURCE_ROM=tjae_rev00.bin
VASM=vasmm68k_mot -m68000 -spaces -Fbin
OBJDUMP=m68k-linux-gnu-objdump -D -b binary -m m68k:68000
HASH=sha1sum

SOURCE_ASM := main.asm

OBJDIR := obj
SOURCE_DUMP := $(OBJDIR)/source.dump.txt
SOURCE_HASH := $(OBJDIR)/source.hash.txt
TARGET_ROM := $(OBJDIR)/target.bin
TARGET_DUMP := $(OBJDIR)/target.dump.txt
TARGET_HASH := $(OBJDIR)/target.hash.txt

OBJS := \
	$(SOURCE_DUMP) \
	$(SOURCE_HASH) \
	$(TARGET_ROM) \
	$(TARGET_DUMP) \
	$(TARGET_HASH) \

all: $(TARGET_ROM)

$(OBJS): | $(OBJDIR)

$(OBJDIR):
	@mkdir -p $(OBJDIR)

clean:
	rm -rf $(OBJDIR)/

$(SOURCE_DUMP): $(SOURCE_ROM)
	@$(OBJDUMP) $(SOURCE_ROM) > $(SOURCE_DUMP)

$(SOURCE_HASH): $(SOURCE_ROM)
	@$(HASH) $(SOURCE_ROM) | awk '{print $$1}' > $(SOURCE_HASH)

$(TARGET_ROM): $(SOURCE_ASM) $(SOURCE_HASH)
	@$(VASM) -Iinclude -o $(TARGET_ROM) $(SOURCE_ASM)
	@$(OBJDUMP) $(TARGET_ROM) > $(TARGET_DUMP)
	@$(HASH) $(TARGET_ROM) | awk '{print $$1}' > $(TARGET_HASH)
	@diff -q $(SOURCE_HASH) $(TARGET_HASH)
