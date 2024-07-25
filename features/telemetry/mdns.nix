{ ... }@args:
{
  imports = [
    (import ./promtail.nix (args // { promtail_url = "http://metrics.local:3100/loki/api/v1/push"; }))
  ];

  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
  };
}
