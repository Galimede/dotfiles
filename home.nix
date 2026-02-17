{ config, pkgs, lib, nixgl, zen-browser, private-fonts, ... }:

let
  nixGLPkg = nixgl.packages.${pkgs.system}.nixGLIntel;
  clever-switch-profile = pkgs.callPackage ./clever-switch-profile.nix {};
  random-labels = pkgs.callPackage ./random-labels.nix {};
in {
  imports = [
    ./fish.nix
    ./starship.nix
    ./kitty.nix
    ./niri.nix
    ./zen.nix
    ./1password.nix
    ./git.nix
    ./git-local.nix  # gitignored - copy from git-local.nix.template
    ./claude.nix
    ./mise.nix
    ./fzf.nix
    ./lazygit.nix
    ./zed.nix
    ./fonts.nix
  ];

  home.username = "mdegand";
  home.homeDirectory = "/home/mdegand";
  home.stateVersion = "24.11";

  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/Downloads";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "obsidian"
    "onepassword-password-manager"
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    less
    jq  # needed for gcy function
    nixGLPkg
    clever-switch-profile
    random-labels
    clever-tools
    obsidian
    yazi
    zoxide
    git-absorb
    nixd              # Nix language server for Zed
    nixfmt            # Nix formatter
    gh                # GitHub CLI
    glab              # GitLab CLI
    chromium          # Browser for playwright-cli
  ];


  # Dark mode for GTK apps
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  # Dark mode for Qt apps (non-noctalia managed)
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # System color preference (for Zed, Electron apps, etc.)
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/freedesktop/appearance".color-scheme = 1;
    };
  };

  # Portal for apps querying system preference
  # NOTE: Requires `xdg-desktop-portal-gtk` installed via pacman for the backend service
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    };
  };

}
