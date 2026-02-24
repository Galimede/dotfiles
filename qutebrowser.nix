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
          odd.bg = "#181825";
          odd.fg = "#cdd6f4";
          even.bg = "#1e1e2e";
          even.fg = "#cdd6f4";
          selected.odd.bg = "#313244";
          selected.odd.fg = "#cdd6f4";
          selected.even.bg = "#313244";
          selected.even.fg = "#cdd6f4";
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
      "<Alt-Shift-p>" = "spawn --userscript qute-1pass-v2";
    };

    aliases = {
      cheatsheet = "open qute://help/img/cheatsheet-big.png";
    };
  };

  home.packages = with pkgs; [
    rofi
  ];

  # Patched qute-1pass for op CLI v2 + biometric unlock + Wayland (wl-copy)
  home.file.".local/share/qutebrowser/userscripts/qute-1pass-v2" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set +e

      javascript_escape() {
          sed "s,[\\\\'\"\/],\\\\&,g" <<< "$1"
      }

      js() {
      cat <<JSEOF
          function isVisible(elem) {
              var style = elem.ownerDocument.defaultView.getComputedStyle(elem, null);
              if (style.getPropertyValue("visibility") !== "visible" ||
                  style.getPropertyValue("display") === "none" ||
                  style.getPropertyValue("opacity") === "0") {
                  return false;
              }
              return elem.offsetWidth > 0 && elem.offsetHeight > 0;
          };
          function hasPasswordField(form) {
              var inputs = form.getElementsByTagName("input");
              for (var j = 0; j < inputs.length; j++) {
                  var input = inputs[j];
                  if (input.type == "password") {
                      return true;
                  }
              }
              return false;
          };
          function loadData2Form (form) {
              var inputs = form.getElementsByTagName("input");
              for (var j = 0; j < inputs.length; j++) {
                  var input = inputs[j];
                  if (isVisible(input) && (input.type == "text" || input.type == "email")) {
                      input.focus();
                      input.value = "$(javascript_escape "''${USERNAME}")";
                      input.dispatchEvent(new Event('change'));
                      input.blur();
                  }
                  if (input.type == "password") {
                      input.focus();
                      input.value = "$(javascript_escape "''${PASSWORD}")";
                      input.dispatchEvent(new Event('change'));
                      input.blur();
                  }
              }
          };
          var forms = document.getElementsByTagName("form");
          if("$(javascript_escape "''${QUTE_URL}")" == window.location.href) {
              for (i = 0; i < forms.length; i++) {
                  if (hasPasswordField(forms[i])) {
                      loadData2Form(forms[i]);
                  }
              }
          } else {
              alert("Secrets will not be inserted.\nUrl of this page and the one where the user script was started differ.");
          }
      JSEOF
      }

      URL=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/www.//g')

      echo "message-info 'Looking for password for $URL...'" >> "$QUTE_FIFO"

      # op CLI v2 with biometric unlock — no signin needed
      # Find item by URL match
      ITEM_JSON=$(op item list --format=json 2>/dev/null) || ITEM_JSON=""

      if [ -z "$ITEM_JSON" ]; then
          echo "message-error '1Password: could not list items (is the app unlocked?)'" >> "$QUTE_FIFO"
          exit 1
      fi

      # Find all items matching the URL
      MATCHES=$(echo "$ITEM_JSON" | jq --arg url "$URL" -r '[.[] | select(.urls != null) | select([.urls[].href] | any(test(".*\($url).*")))]') || MATCHES="[]"
      MATCH_COUNT=$(echo "$MATCHES" | jq -r 'length')

      if [ "$MATCH_COUNT" -eq 1 ]; then
          UUID=$(echo "$MATCHES" | jq -r '.[0].id')
      elif [ "$MATCH_COUNT" -gt 1 ]; then
          # Multiple matches — let user pick via rofi
          TITLE=$(echo "$MATCHES" | jq -r '.[].title' | rofi -dmenu -i -p "1Password ($MATCH_COUNT matches)") || TITLE=""
          if [ -n "$TITLE" ]; then
              UUID=$(echo "$MATCHES" | jq --arg title "$TITLE" -r '[.[] | select(.title == $title)] | .[0].id // empty') || UUID=""
          fi
      else
          # No URL match — let user pick from all items via rofi
          echo "message-info 'No entry found for $URL, showing picker...'" >> "$QUTE_FIFO"
          TITLE=$(echo "$ITEM_JSON" | jq -r '.[].title' | rofi -dmenu -i -p "1Password") || TITLE=""
          if [ -n "$TITLE" ]; then
              UUID=$(echo "$ITEM_JSON" | jq --arg title "$TITLE" -r '[.[] | select(.title == $title)] | .[0].id // empty') || UUID=""
          fi
      fi

      if [ -z "$UUID" ]; then
          echo "message-error 'No entry selected'" >> "$QUTE_FIFO"
          exit 1
      fi

      # Fetch full item details (op v2 syntax)
      ITEM=$(op item get "$UUID" --format=json 2>/dev/null) || ITEM=""

      if [ -z "$ITEM" ]; then
          echo "message-error '1Password: could not fetch item details'" >> "$QUTE_FIFO"
          exit 1
      fi

      PASSWORD=$(echo "$ITEM" | jq -r '[.fields[] | select(.purpose == "PASSWORD")] | .[0].value // empty')

      if [ -n "$PASSWORD" ]; then
          TITLE=$(echo "$ITEM" | jq -r '.title')
          USERNAME=$(echo "$ITEM" | jq -r '[.fields[] | select(.purpose == "USERNAME")] | .[0].value // empty')

          printjs() {
              js | sed 's,//.*$,,' | tr '\n' ' '
          }
          echo "jseval -q $(printjs)" >> "$QUTE_FIFO"

          # Copy TOTP to clipboard if available (using wl-copy for Wayland)
          TOTP=$(op item get "$UUID" --otp 2>/dev/null) || TOTP=""
          if [ -n "$TOTP" ]; then
              echo "$TOTP" | wl-copy
              echo "message-info 'Pasted OTP for $TITLE to clipboard'" >> "$QUTE_FIFO"
          fi
      else
          echo "message-error 'No password found for $URL'" >> "$QUTE_FIFO"
      fi
    '';
  };

  # Wrapper script with GPU acceleration (OpenGL + Vulkan for Intel Arc)
  # Note: unlike Zed, qutebrowser uses Nix Qt libraries, so we must NOT prepend /usr/lib
  # to LD_LIBRARY_PATH (that would shadow Nix Qt with system Qt, breaking QtWebEngine).
  # nixGLIntel handles the OpenGL driver path; we only add the Vulkan ICD.
  home.file.".local/bin/qutebrowser".text = ''
    #!/bin/sh
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
