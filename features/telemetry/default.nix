{ ... }@args:
{
  imports = [ (import ./promtail.nix args // { }) ];

  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
  };
}
