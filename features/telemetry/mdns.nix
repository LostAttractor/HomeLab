{ ... }@args:
{
  imports = [
    (import ./promtail.nix (args // { promtail_url = "http://node0-rke.local:30001/loki/api/v1/push"; }))
  ];

  services.prometheus.exporters.node = {
    enable = true;
    openFirewall = true;
  };
}
