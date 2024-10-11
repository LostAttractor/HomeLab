{
  modulesPath,
  pkgs,
  config,
  lib,
  ...
}:
{
  # Basics
  imports = [
    (modulesPath + "/virtualisation/kubevirt.nix")
  ];

  boot.kernelParams = [ "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" ];

  # UEFI
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  system.build.kubevirtImage = lib.mkForce (import (modulesPath + "/../lib/make-disk-image.nix") {
    inherit lib config pkgs;
    partitionTableType = "efi";
    format = "qcow2";
  });

  # Systemd in initrd
  boot.initrd.systemd.enable = lib.mkDefault true;

  # Xanmod Kernel
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;

  # Enable ZRAM
  zramSwap.enable = lib.mkDefault true;

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = lib.mkOverride 150 "";

  # Some more help text.
  services.getty.helpLine = ''

    Log in as "root" with an empty password.
  '';
}
