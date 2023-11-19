{ pkgs, ... } :

{
  config = {
    # Ignore ICMP broadcasts to avoid participating in Smurf attacks
    boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    # Ignore bad ICMP errors
    boot.kernel.sysctl."net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # SYN flood protection
    boot.kernel.sysctl."net.ipv4.tcp_syncookies" = 1;
    # Do not accept ICMP redirects (prevent MITM attacks)
    boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = 0;
    boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = 0;
    boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = 0;
    boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = 0;
    boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = 0;
    boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = 0;

    # Protect against tcp time-wait assassination hazards
    boot.kernel.sysctl."net.ipv4.tcp_rfc1337" = 1;
    ## Bufferbloat mitigations
    # Requires >= 4.9 & kernel module
    boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
    # Requires >= 4.19
    boot.kernel.sysctl."net.core.default_qdisc" = "cake";

    boot.kernelParams = [
      # Slab/slub sanity checks, redzoning, and poisoning
      "slub_debug=FZP"
      # Clear memory at free, wiping sensitive data
      "page_poison=1"
      # Enable page allocator randomization
      "page_alloc.shuffle=1"
    ];

    services.fail2ban.enable = true;

    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.PermitRootLogin = "no";
  };
}
