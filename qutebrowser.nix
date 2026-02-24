{ pkgs, nixgl, ... }:

let
  nixGLPkg = nixgl.packages.${pkgs.system}.nixGLIntel;
in {
  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      g = "https://www.google.com/search?q={}";
      w = "https://en.wikipedia.org/w/index.php?search={}";
      np = "https://search.nixos.org/packages?query={}";
    };

    settings = {
      colors.webpage.preferred_color_scheme = "dark";
      scrolling.smooth = true;

      # Catppuccin Mocha base colors
      colors = {
        statusbar.normal = {
          bg = "#1e1e2e";
          fg = "#cdd6f4";
        };
        statusbar.url = {
          fg = "#cdd6f4";
          hover.fg = "#89b4fa";
          success.http.fg = "#a6e3a1";
          success.https.fg = "#a6e3a1";
          error.fg = "#f38ba8";
          warn.fg = "#fab387";
        };
        tabs = {
          bar.bg = "#181825";
          odd.normal = {
            bg = "#181825";
            fg = "#cdd6f4";
          };
          even.normal = {
            bg = "#1e1e2e";
            fg = "#cdd6f4";
          };
          odd.selected = {
            bg = "#313244";
            fg = "#cdd6f4";
          };
          even.selected = {
            bg = "#313244";
            fg = "#cdd6f4";
          };
          indicator.start = "#89b4fa";
          indicator.stop = "#a6e3a1";
          indicator.error = "#f38ba8";
        };
        completion = {
          fg = "#cdd6f4";
          odd.bg = "#1e1e2e";
          even.bg = "#181825";
          category = {
            bg = "#181825";
            fg = "#89b4fa";
            border.top = "#181825";
            border.bottom = "#181825";
          };
          item.selected = {
            bg = "#313244";
            fg = "#cdd6f4";
            border.top = "#313244";
            border.bottom = "#313244";
            match.fg = "#f5c2e7";
          };
          match.fg = "#f5c2e7";
          scrollbar = {
            bg = "#181825";
            fg = "#6c7086";
          };
        };
        hints = {
          bg = "#f9e2af";
          fg = "#1e1e2e";
          match.fg = "#585b70";
        };
        messages = {
          info = {
            bg = "#1e1e2e";
            fg = "#cdd6f4";
            border = "#1e1e2e";
          };
          warning = {
            bg = "#fab387";
            fg = "#1e1e2e";
            border = "#fab387";
          };
          error = {
            bg = "#f38ba8";
            fg = "#1e1e2e";
            border = "#f38ba8";
          };
        };
        downloads = {
          bar.bg = "#1e1e2e";
          start = {
            bg = "#89b4fa";
            fg = "#1e1e2e";
          };
          stop = {
            bg = "#a6e3a1";
            fg = "#1e1e2e";
          };
          error = {
            bg = "#f38ba8";
            fg = "#1e1e2e";
          };
        };
        prompts = {
          bg = "#1e1e2e";
          fg = "#cdd6f4";
          border = "#313244";
          selected.bg = "#313244";
        };
        keyhint = {
          bg = "#1e1e2e";
          fg = "#cdd6f4";
          suffix.fg = "#f5c2e7";
        };
      };
    };

    keyBindings.normal = {
      "<Alt-Shift-p>" = "spawn --userscript qute-1pass";
    };
  };

  home.packages = with pkgs; [
    rofi-wayland
  ];

  # Wrapper script with GPU acceleration (OpenGL + Vulkan for Intel Arc)
  home.file.".local/bin/qutebrowser".text = ''
    #!/bin/sh
    # Use system Vulkan loader and ICD for Intel Arc GPU
    export LD_LIBRARY_PATH=/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
    exec ${nixGLPkg}/bin/nixGLIntel ${pkgs.qutebrowser}/bin/qutebrowser "$@"
  '';
  home.file.".local/bin/qutebrowser".executable = true;

  # Desktop entry override for application launchers
  xdg.desktopEntries."org.qutebrowser.qutebrowser" = {
    name = "qutebrowser";
    genericName = "Web Browser";
    comment = "A keyboard-driven, vim-like browser based on Python and Qt.";
    exec = "/home/mdegand/.local/bin/qutebrowser %u";
    icon = "qutebrowser";
    terminal = false;
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/xml"
      "application/rdf+xml"
      "image/gif"
      "image/jpeg"
      "image/png"
      "image/webp"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/qute"
    ];
    startupNotify = true;
  };
}
