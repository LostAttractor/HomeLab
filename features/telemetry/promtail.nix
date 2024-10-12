{
  config,
  promtail_url ? "http://loki.home.lostattractor.net/loki/api/v1/push",
  promtail_username ? "main",
  promtail_password_file,
  ...
}:
{
  services.promtail = {
    enable = true;
    configuration = {
      server.http_listen_port = 9080;
      positions.filename = "/tmp/positions.yaml";
      clients = [ {
        url = promtail_url;
        basic_auth = {
          username = promtail_username;
          password_file = promtail_password_file;
        };
      } ];

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
