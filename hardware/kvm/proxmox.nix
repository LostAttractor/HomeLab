{
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  # Basics
  imports = [
    (modulesPath + "/virtualisation/proxmox-image.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.kernelParams = [ 
    "zswap.enabled=1"
    "zswap.shrinker_enabled=1"
    "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
  ];

  # UEFI
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  fileSystems."/".options = [ "discard" ];

  services.qemuGuest.package = with pkgs; (qemu_kvm.override { minimal = true; guestAgentSupport = true; }).ga;

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

  # Proxmox Image
  proxmox.qemuConf.bios = lib.mkDefault "ovmf";
  proxmox.qemuConf.net0 = "virtio=00:00:00:00:00:00,bridge=vmbr0";
  proxmox.qemuConf.agent = true;
  proxmox.qemuExtraConf.machine = "q35";
  virtualisation.diskSize = 16384;

  # Disable CloudInit
  proxmox.cloudInit.enable = false;
}
