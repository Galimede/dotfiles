{ pkgs, nixgl, ... }:

let
  nixGLPkg = nixgl.packages.${pkgs.system}.nixGLIntel;
in
{
  # Niri has no Home Manager module, keep config as raw file
  home.file.".config/niri/config.kdl".source = ./dotfiles/niri/config.kdl;
  home.file.".config/niri/monitor-layout.sh" = {
    source = ./dotfiles/niri/monitor-layout.sh;
    executable = true;
  };

  # Polkit authentication agent for run0 / graphical privilege escalation
  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${nixGLPkg}/bin/nixGLIntel ${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
