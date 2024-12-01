const std = @import("std");

pub fn build(b: *std.Build) void {
    const uefi_target = std.zig.CrossTarget{
        .cpu_arch = std.Target.Cpu.Arch.x86_64,
        .os_tag = std.Target.Os.Tag.uefi,
        .abi = std.Target.Abi.msvc,
    };
    const optimize = b.standardOptimizeOption(.{});

    const stage0 = b.addExecutable(.{
        .name = "bootx64",
        .root_source_file = b.path("src/loader/stage0.uefi.zig"),
        .target = b.resolveTargetQuery(uefi_target),
        .optimize = optimize,
    });

    const stage0_step = b.step("stage0", "Build the stage0 kernel");
    stage0_step.dependOn(&stage0.step);

    const install_stage0 = b.addInstallArtifact(stage0, .{
        .dest_dir = .{ .override = .{ .custom = "img/efi/boot" } },
    });
    b.getInstallStep().dependOn(&install_stage0.step);
}
