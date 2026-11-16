{ pkgs, lib, noctalia, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  nixGLPkg = pkgs.nixgl.nixGLIntel;

  # nixpkgs' pam hardcodes unix_chkpwd's path to /run/wrappers/bin, which
  # only exists on NixOS (security.wrappers). On this Arch system the real
  # setuid helper lives at /usr/bin/unix_chkpwd; without this, noctalia's
  # lock screen fails every authentication attempt (PAM_CRED_INSUFFICIENT).
  # Scoped to just noctalia's own pam input via `.override` so it doesn't
  # cascade-rebuild everything else in the closure that also uses pam.
  pamForLockscreen = pkgs.pam.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace modules/module-meson.build \
        --replace-fail "sbindir / 'unix_chkpwd'" "'/usr/bin/unix_chkpwd'"
    '';
  });

  noctaliaPkg = noctalia.packages.${system}.default.override {
    pam = pamForLockscreen;
  };
in
{
  # Bar layout and wallpaper directory are carried over from the old v4
  # (~/.config/noctalia/settings.json) config, which v5 does not migrate
  # automatically.
  programs.noctalia = {
    enable = true;
    package = noctaliaPkg;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        directory = "/home/mdegand/Pictures/Wallpapers";
        fill_mode = "crop";
        automation = {
          enabled = true;
          interval_seconds = 300;
          order = "random";
        };
      };

      bar.default = {
        margin_ends = 0; # full-width bar, matching the old v4 layout
        concave_edge_corners = false;
        start = [ "launcher" "clock" "cpu-usage" "cpu-temp" "ram" "active_window" "media" ];
        center = [ "workspaces" ];
        end = [ "tray" "notifications" "battery" "volume" "brightness" "control-center" ];
      };

      widget = {
        cpu-usage = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
        };
        cpu-temp = {
          type = "sysmon";
          stat = "cpu_temp";
          visualization = "none";
        };
        ram = {
          type = "sysmon";
          stat = "ram_used";
          visualization = "none";
        };
        active_window = {
          max_length = 145;
          title_scroll = "on_hover";
        };
        media = {
          artist_first = true;
          max_length = 145;
        };
        tray = {
          hide_passive = false;
          drawer = true;
        };
        workspaces = {
          labels_only_when_occupied = true;
        };
      };
    };
  };

  # The built-in `programs.noctalia.systemd.enable` runs the binary directly,
  # which fails eglGetDisplay: as a Nix-built binary it needs nixGLIntel's
  # Mesa/EGL env (LIBGL_DRIVERS_PATH, LD_LIBRARY_PATH, etc — see kitty/zed/
  # codium/zen/qutebrowser for the same pattern) which plain systemd user
  # services don't have. niri's own spawn-at-startup doesn't have it either
  # and never retries on crash, so we run our own nixGL-wrapped service
  # instead (same pattern as hyprpolkitagent in niri.nix).
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia - A lightweight Wayland shell and bar";
      Documentation = "https://docs.noctalia.dev/noctalia/";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${nixGLPkg}/bin/nixGLIntel ${lib.getExe noctaliaPkg}";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
