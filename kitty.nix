{ pkgs, ... }:

let
  # Start herdr in the first kitty window. Detaching (prefix+q) closes kitty.
  herdrSession = pkgs.writeText "kitty-herdr.session" ''
    launch ${pkgs.herdr}/bin/herdr
  '';
in
{
  programs.kitty = {
    enable = true;

    extraConfig = ''
      startup_session ${herdrSession}
    '';

    font = {
      name = "Hack Nerd Font";
      size = 12;
    };

    settings = {
      # Disable config auto-reload (kitty 0.47.x). On NixOS/home-manager the
      # config watcher recursively inotify-watches the dirs of all included
      # files, including /nix/store, exhausting fs.inotify.max_user_watches and
      # breaking other watchers (vite/chokidar HMR). Workaround until the fix
      # lands upstream. See kovidgoyal/kitty#10102.
      auto_reload_config = -1;

      # Tab bar
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Catppuccin Mocha colors
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";

      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";

      url_color = "#F5E0DC";

      active_border_color = "#B4BEFE";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";

      wayland_titlebar_color = "system";

      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";

      mark1_foreground = "#1E1E2E";
      mark1_background = "#B4BEFE";
      mark2_foreground = "#1E1E2E";
      mark2_background = "#CBA6F7";
      mark3_foreground = "#1E1E2E";
      mark3_background = "#74C7EC";

      # Terminal colors
      color0 = "#45475A";
      color8 = "#585B70";
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };

    # Window/tab navigation now lives in herdr (see ~/.config/herdr/config.toml).
    # Previous kitty bindings, kept as fallback:
    # keybindings = {
    #   "ctrl+shift+up" = "previous_window";
    #   "ctrl+shift+down" = "next_window";
    #   "ctrl+shift+e" = "launch --type=tab --cwd=current nvim";
    #   "ctrl+shift+d" = "launch --type=tab --cwd=current nvim -c CodeDiff";
    # };
  };

  # herdr TUI keybindings and custom commands.
  xdg.configFile."herdr/config.toml".source = ./dotfiles/herdr/config.toml;
}
