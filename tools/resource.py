from collections import OrderedDict
from enum import Enum

class ResourceKind(Enum):
    IGNORE = 0
    SPRITE_HEADER = 1
    SPRITE_DATA = 2
    METASPRITE_HEADER = 3
    METASPRITE_LIST = 4
    Z80_BINARY = 5
    RAW_IMAGE = 6
    PALETTE = 7
    M68K_CODE = 8
    SPRITE_LIST = 9
    PCM_AUDIO = 10

class Resource:
    def __init__(self, kind, address, length):
        self.kind = kind
        self.address = address
        self.length = length
        self.attrs = {}

    def __str__(self):
        return "<%s,%08x,%08x>" % (self.kind, self.address, self.length)

    def __eq__(self, other):
        return ((self.kind == other.kind) and
                (self.address == other.address) and
                (self.length == other.length))

class ResourceTable(OrderedDict):
    def __init__(self, span=None):
        super(ResourceTable, self).__init__()
        self.span = span

    def within(self, resource):
        return (resource.address >= self.span.start) and (resource.address + resource.length <= self.span.stop)

    def append(self, resource):
        if not type(resource) is Resource:
            raise ValueError("this doesn't look like a resource")

        if self.span:
            if not self.within(resource):
                raise ValueError("resource %s would be outside table" % resource)

        if resource.address in self:
            if not self[resource.address] == resource:
                raise ValueError("resource %s already exists at %08x" % (resource, resource.address))
        else:
            self[resource.address] = resource
