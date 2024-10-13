{ modulesPath, pkgs, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/amazon-image.nix") ];

  boot.kernelParams = [ 
    "zswap.enabled=1"
    "zswap.shrinker_enabled=1"
    "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1"
  ];

  ec2.efi = true;

  # Xanmod Kernel
  boot.kernelPackages = if (pkgs.system != "aarch64-linux") then lib.mkDefault pkgs.linuxPackages_xanmod_latest else lib.mkDefault pkgs.linuxPackages_latest;

  # Enable Swap
  swapDevices = [ {
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