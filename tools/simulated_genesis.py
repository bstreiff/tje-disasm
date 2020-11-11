from bare68k import *
from bare68k.consts import *
import ctypes
import logging

class DummyMem(object):
    def read(self, mode, addr):
        return 0

    def write(self, mode, addr, val):
        return

# WORKAROUND: Runtime constructor calls mem_cfg with ram_at_zero
# being its default value of 'True'. Create a subclass that ignores
# the parameter and overrides it with 'False' so that we can
# correctly deal with the MD memory map
class MDMemoryConfig(MemoryConfig):
    def check(self, ram_at_zero=True, max_pages=256):
        return super(MDMemoryConfig, self).check(False, max_pages)

runtime.log_setup(logging.CRITICAL)

class SimulatedGenesis(object):
    def __init__(self, rom, md_z80 = DummyMem(), md_ports = DummyMem(),
                 md_vdp = DummyMem()):
        self.rom = rom
        self.md_z80 = md_z80
        self.md_ports = md_ports
        self.md_vdp = md_vdp

        # Genesis has a classic 68000
        cpu_cfg = CPUConfig(M68K_CPU_TYPE_68000)

        # now define the memory layout of the system
        mem_cfg = MDMemoryConfig()

        # First 16 64k pages are ROM
        mem_cfg.add_rom_range(0x00, 16)
        # There is 1 64k page of RAM at 0xFF0000
        mem_cfg.add_ram_range(0xFF, 1)

        # 0xA00000->0xA0FFFF is Z80 address space
        mem_cfg.add_special_range(0xA0, 1, md_z80.read, md_z80.write, name="z80")
        # 0xA10000->0xA1FFFF is the I/O ports
        mem_cfg.add_special_range(0xA1, 1, md_ports.read, md_ports.write, name="ports")
        # 0xC00000->0xC0FFFF is the VDP
        mem_cfg.add_special_range(0xC0, 1, md_vdp.read, md_ports.write, name="vdp")

        run_cfg = RunConfig()
        event_handler = EventHandler()
        run_cfg.set_cpu_mem_trace(False)
        run_cfg.set_instr_trace(False)
        self.rt = Runtime(cpu_cfg, mem_cfg, run_cfg, event_handler=event_handler)

        # read the ROM into the emulated system
        mem = self.rt.get_mem()
        with open(rom, 'rb') as rom_file:
            addr = 0
            data = rom_file.read(0x10000)
            while data:
                for v in data:
                    mem.w8(addr, v)
                    addr += 1
                data = rom_file.read(0x10000)


        # DUMB HACK: Replace the header in the ROM with RESET instructions so
        # that if we jump to any of these locations, we kill the simulation
        # immediately.
        # We do this because when we RTS from the procedure we're about to run,
        # the return address on the stack will be 0x00000000. Ideally we'd set
        # up a dummy stack frame beforehand...
        OP_RESET = 0x4E70
        addr = 0x000
        while addr <= 0x200:
            mem.w16(addr, OP_RESET)
            addr += 2

    def stack_push8(self, val):
        cpu = self.rt.get_cpu()
        sp = cpu.r_reg(M68K_REG_A7) - 1
        self.rt.get_mem().w8(sp, val)
        cpu.w_reg(M68K_REG_A7, sp)

    def stack_push16(self, val):
        cpu = self.rt.get_cpu()
        sp = cpu.r_reg(M68K_REG_A7) - 2
        self.rt.get_mem().w16(sp, val)
        cpu.w_reg(M68K_REG_A7, sp)

    def stack_push32(self, val):
        cpu = self.rt.get_cpu()
        sp = cpu.r_reg(M68K_REG_A7) - 4
        self.rt.get_mem().w32(sp, val)
        cpu.w_reg(M68K_REG_A7, sp)

    def start(self, addr, *args):
        # reset to program area with default initial stack pointer
        self.rt.reset(addr, 0x00FF8000)
        for arg in args:
            if ctypes.sizeof(arg) == 1:
                self.stack_push8(arg.value)
            elif ctypes.sizeof(arg) == 2:
                self.stack_push16(arg.value)
            elif ctypes.sizeof(arg) == 4:
                self.stack_push32(arg.value)
        self.stack_push32(0) # "caller" address
        self.rt.run(start_pc=addr)

    def get_mem(self):
        return self.rt.get_mem()

    def stop(self):
        self.rt.shutdown()

