const std = @import("std");
const uefi = std.os.uefi;

const log = @import("../log.zig");

fn writeFn(_: void, bytes: []const u8) anyerror!usize {
    const protocol = uefi.system_table.con_out.?;
    for (bytes) |c| {
        if (c == '\n') {
            try protocol.outputString(std.unicode.utf8ToUtf16LeStringLiteral("\r\n")).err();
        } else {
            const c_ = [2]u16{ c, 0 };
            try protocol.outputString(@ptrCast(&c_)).err();
        }
    }
    return bytes.len;
}

pub fn init() void {
    const writer = std.io.GenericWriter(void, anyerror, writeFn){
        .context = void{},
    };

    log.CURRENT.set_console(writer.any());
}
