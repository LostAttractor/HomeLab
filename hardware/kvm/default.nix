{
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  # Basics
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.kernelParams = [ 
    "zswap.enabled=1"
    "zswap.shrinker_enabled=1"
    "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
    "console=ttyS0"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    autoResize = true;
    options = [ "discard" ];
  };

  boot.growPartition = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.timeout = 0;

  services.qemuGuest.enable = true;
  services.openssh.enable = true;
  # services.cloud-init.enable = true;
  systemd.services."serial-getty@ttyS0".enable = true;

  # Systemd in initrd
  boot.initrd.systemd.enable = lib.mkDefault true;

  # Xanmod Kernel
  boot.kernelPackages = lib.mkOverride 1490 pkgs.linuxPackages_xanmod_latest;

  # Enable Swap
  swapDevices = lib.mkDefault [ {
    device = "/var/lib/swapfile";
    size = 4*1024;
  } ];

  services.fstrim.enable = true;

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = lib.mkOverride 150 "";

  # Some more help text.
  services.getty.helpLine = ''

    Log in as "root" with an empty password.
  '';
}