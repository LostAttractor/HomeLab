{
  config,
  promtail_url ? "http://metrics.home.lostattractor.net:3100/loki/api/v1/push",
  ...
}:
{
  services.promtail = {
    enable = true;
    configuration = {
      server.http_listen_port = 9080;
      positions.filename = "/tmp/positions.yaml";
      clients = [ { url = promtail_url; } ];

      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = config.networking.hostName;
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
