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
    exec ${nixGLPkg}/bin/nixGLIntel zen "$@"
  '';
  home.file.".local/bin/zen-gl".executable = true;
}
