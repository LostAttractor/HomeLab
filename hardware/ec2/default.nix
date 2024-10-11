{ modulesPath, pkgs, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/amazon-image.nix") ];

  boot.kernelParams = [ "systemd.setenv=SYSTEMD_SULOGIN_FORCE=1" ];

  ec2.efi = true;

  # Xanmod Kernel
  boot.kernelPackages = if (pkgs.system != "aarch64-linux") then lib.mkDefault pkgs.linuxPackages_xanmod_latest else lib.mkDefault pkgs.linuxPackages_latest;

  # Allow the user to login as root without password.
  users.users.root.initialHashedPassword = lib.mkOverride 150 "";

  # Some more help text.
  services.getty.helpLine = ''

    Log in as "root" with an empty password.
  '';
}