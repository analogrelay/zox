const std = @import("std");

pub var CURRENT: Logger = Logger{
    .console = null,
    .serial = null,
};
const CURRENT_WRITER = CURRENT.writer();

const Logger = struct {
    console: ?std.io.AnyWriter,
    serial: ?std.io.AnyWriter,

    const Self = @This();
    pub const WriteError = anyerror;
    pub const Writer = std.io.GenericWriter(*Self, WriteError, writeFn);

    pub fn set_console(self: *Self, console: std.io.AnyWriter) void {
        self.console = console;
    }

    pub fn set_serial(self: *Self, serial: std.io.AnyWriter) void {
        self.serial = serial;
    }

    pub fn writer(self: *Self) Writer {
        return Writer{ .context = self };
    }

    fn writeFn(context: *Self, bytes: []const u8) WriteError!usize {
        if (context.console) |console| {
            _ = std.os.uefi.system_table.con_out.?.outputString(std.unicode.utf8ToUtf16LeStringLiteral("Console"));
            try console.writeAll(bytes);
            _ = std.os.uefi.system_table.con_out.?.outputString(std.unicode.utf8ToUtf16LeStringLiteral("ConsoleDone"));
        }

        if (context.serial) |serial| {
            try serial.writeAll(bytes);
        }

        return bytes.len;
    }
};

pub fn logFn(
    comptime message_level: std.log.Level,
    comptime scope: @TypeOf(.enum_literal),
    comptime format: []const u8,
    args: anytype,
) void {
    const prefix = comptime message_level.asText() ++ " (" ++ @tagName(scope) ++ "): ";
    const writer = CURRENT.writer();
    std.fmt.format(writer, prefix, .{}) catch return;
    std.fmt.format(writer, format, args) catch return;
    std.fmt.format(writer, "\n", .{}) catch return;
}
