{ pkgs, ... }:

{
  # Niri has no Home Manager module, keep config as raw file
  home.file.".config/niri/config.kdl".source = ./dotfiles/niri/config.kdl;
  home.file.".config/niri/monitor-layout.sh" = {
    source = ./dotfiles/niri/monitor-layout.sh;
    executable = true;
  };

  # Polkit authentication agent for run0 / graphical privilege escalation
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "Polkit GNOME authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
