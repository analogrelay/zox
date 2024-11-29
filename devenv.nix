{ pkgs, lib, config, inputs, ... }:

{
  packages = [ 
    pkgs.git
    pkgs.qemu
  ];
  languages.zig.enable = true;
}
