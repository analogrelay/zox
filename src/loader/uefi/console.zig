const std = @import("std");
const uefi = std.os.uefi;

const log = @import("../log.zig");

var CURRENT: ?SimpleTextWriter = null;

const SimpleTextWriter = struct {
    protocol: *uefi.protocol.SimpleTextOutput,

    const Self = @This();
    pub const WriteError = error{};
    pub const Writer = std.io.GenericWriter(*Self, WriteError, writeFn);

    pub fn init(protocol: *uefi.protocol.SimpleTextOutput) SimpleTextWriter {
        return SimpleTextWriter{ .protocol = protocol };
    }

    pub fn writer(self: *Self) Writer {
        return Writer{ .context = self };
    }

    fn writeFn(context: *Self, bytes: []const u8) WriteError!usize {
        const protocol = context.protocol;
        for (bytes) |c| {
            const c_ = [2]u16{ c, 0 };
            _ = protocol.outputString(@ptrCast(&c_));
        }
        return bytes.len;
    }
};

pub fn init() void {
    const con_out = uefi.system_table.con_out.?;
    CURRENT = SimpleTextWriter.init(con_out);
    log.CURRENT.set_console(CURRENT.?.writer().any());
}
