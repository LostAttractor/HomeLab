{ lib, ... }:
{
  imports = [ ./minimal.nix ];

  # Auto Clean
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # Free up to 1GiB whenever there is less than 100MiB left
  nix.settings.min-free = lib.mkDefault "${toString (100 * 1024 * 1024)}";
  nix.settings.max-free = lib.mkDefault "${toString (1024 * 1024 * 1024)}";
}
