const uefi = @import("std").os.uefi;

pub fn main() void {
    const console_out = uefi.system_table.con_out.?;

    // Reset the console and print a message
    _ = console_out.reset(false);
    _ = console_out.outputString(&[_:0]u16{ 'H', 'e', 'l', 'l', 'o', '\r', '\n' });

    // Stall for 5 seconds.
    const boot_services = uefi.system_table.boot_services.?;
    _ = boot_services.stall(5 * 1000 * 1000);
}
