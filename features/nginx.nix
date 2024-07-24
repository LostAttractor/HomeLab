_: {
  # Add Firewall Rules for Nginx
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;

    proxyTimeout = "900s";

    appendConfig = ''
      worker_processes auto;
      worker_cpu_affinity auto;
    '';

    eventsConfig = ''
      worker_connections 1024;
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "lostattractor@gmail.com";
  };
}
