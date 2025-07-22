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

  # Trusted Public Keys
  nix.settings.trusted-public-keys =  [
    "hydra:bCXoAKNbKou4hrnzaH2YB0nvbBPj81PmTklSUSQr5I8="
    "binarycache.home.lostattractor.net:nB258qoytYrdCe2pcI6qJ/M9R0l7Q5l9Bu5ryCbzItc="
  ];
}
