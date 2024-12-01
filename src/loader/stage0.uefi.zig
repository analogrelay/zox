const std = @import("std");
const builtin = @import("builtin");
const uefi = std.os.uefi;

const log = @import("log.zig");
const console = @import("uefi/console.zig");

pub const std_options = .{
    .log_level = switch (builtin.mode) {
        .Debug => std.log.Level.debug,
        else => std.log.Level.info,
    },
    .logFn = log.logFn,
};

// fn panic(message: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
//     std.log.err("PANIC: {s}", .{message});

//     // Stall for 5 seconds.
//     const boot_services = uefi.system_table.boot_services.?;
//     _ = boot_services.stall(5 * 1000 * 1000);

//     // Exit
//     boot_services.exit(uefi.handle, uefi.Status.Aborted, 0, null);

//     // Halt
//     while (true) {}
// }

pub fn main() void {
    console.init();

    _ = uefi.system_table.con_out.?.outputString(std.unicode.utf8ToUtf16LeStringLiteral("Boot"));

    boot();

    _ = uefi.system_table.con_out.?.outputString(std.unicode.utf8ToUtf16LeStringLiteral("BootDone"));

    //@panic("Yikes");

    // Stall for 5 seconds.
    const boot_services = uefi.system_table.boot_services.?;
    _ = boot_services.stall(5 * 1000 * 1000);
}

pub fn boot() void {
    std.log.info("Zox stage 0 booting...", .{});
}
