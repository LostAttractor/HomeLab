{ pkgs, ... }:
{
  programs.mosh.enable = true;

  environment.systemPackages = with pkgs; [
    htop btop                        # to see the system load
    fastfetch                        # to see system infomation
    ethtool                          # manage NIC settings (offload, NIC feeatures, ...)
    tcpdump bandwhich pwru           # view network traffic / utilization
    dnsutils                         # dns tools
    iperf3                           # speedtest tools
    curlHTTP3                        # curl with http3 support
    inetutils                        # telnet
    duf gdu                          # disk usage analyaer
    lsd
    nmap
    strace
    atuin
    tmux
    iotop
  ];
}