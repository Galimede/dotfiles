{ pkgs, nixgl, zen-browser, ... }:

let
  nixGLPkg = nixgl.packages.${pkgs.system}.nixGLIntel;
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  # Import the zen-browser home-manager module
  imports = [ zen-browser.homeModules.default ];

  # Enable Zen Browser
  programs.zen-browser = {
    enable = true;

    # Optional: Configure a default profile
    profiles.default = {
      extensions.packages = with firefox-addons; [
        onepassword-password-manager
        ublock-origin
      ];
      search = {
        default = "ddg";
        privateDefault = "ddg";
        force = true;
      };
      settings = {
        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.donottrackheader.enabled" = true;

        # Enable PipeWire for screen sharing on Wayland
        "media.webrtc.camera.allow-pipewire" = true;

        # Disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;

        # Only sync essentials/pinned tabs across windows, not regular tabs
        "zen.window-sync.sync-only-pinned-tabs" = true;

        # Allow fontconfig to provide enough fallback fonts for emoji/symbols
        "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;

        # Spell-check dictionaries (en-US + fr)
        "spellchecker.dictionary" = "en-US,fr_FR";
        "spellchecker.dictionary_path" = "${pkgs.hunspellDicts.fr-moderne}/share/hunspell";
        "intl.accept_languages" = "en-US,en,fr-FR,fr";

        # Disable extension auto-updates (managed by NUR/home-manager)
        "extensions.update.autoUpdateDefault" = false;
        "extensions.update.enabled" = false;

      };
    };
  };

  # Set Zen as default browser
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
    "x-scheme-handler/about" = "zen-beta.desktop";
    "x-scheme-handler/unknown" = "zen-beta.desktop";
  };

  # Create a wrapper script for GPU acceleration
  home.file.".local/bin/zen-gl".text = ''
    #!/bin/sh
    exec ${nixGLPkg}/bin/nixGLIntel zen-beta "$@"
  '';
  home.file.".local/bin/zen-gl".executable = true;

  # Desktop entry override for application launchers (uses zen-gl wrapper for WebGL/GPU support)
  xdg.desktopEntries."zen-beta" = {
    name = "Zen Browser (Beta)";
    genericName = "Web Browser";
    exec = "/home/mdegand/.local/bin/zen-gl --name zen-beta %U";
    icon = "zen-browser";
    terminal = false;
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupNotify = true;
    settings.StartupWMClass = "zen-beta";
    actions = {
      "new-private-window" = {
        name = "New Private Window";
        exec = "/home/mdegand/.local/bin/zen-gl --private-window %U";
      };
      "new-window" = {
        name = "New Window";
        exec = "/home/mdegand/.local/bin/zen-gl --new-window %U";
      };
      "profile-manager-window" = {
        name = "Profile Manager";
        exec = "/home/mdegand/.local/bin/zen-gl --ProfileManager";
      };
    };
  };
}
