{ pkgs, nixgl, ... }:

let
  nixGLPkg = nixgl.packages.${pkgs.system}.nixGLIntel;
in {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "fish"
    ];

    userSettings = {
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      edit_predictions = {
        mode = "subtle";
        copilot = {
          proxy = null;
          proxy_no_verify = null;
        };
        enabled_in_text_threads = false;
      };

      agent = {
        default_profile = "ask";
        default_model = {
          provider = "zed.dev";
          model = "claude-3-7-sonnet";
        };
      };

      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
      };

      project_panel = {
        button = true;
        dock = "left";
        git_status = true;
      };

      tabs.file_icons = true;
      vim_mode = true;
      which_key.enabled = true;
      ui_font_size = 16;

      theme = {
        mode = "system";
        light = "One Light";
        dark = "Catppuccin Mocha";
      };

      terminal = {
        font_family = "Hack Nerd Font";
        font_size = 15;
      };

      vim = {
        use_system_clipboard = "on_yank";
        use_multiline_find = true;
        use_smartcase_find = true;
      };

      buffer_font_size = 18;
      buffer_font_family = "Dank Mono";
      relative_line_numbers = "disabled";

      scrollbar.show = "never";
      scroll_beyond_last_line = "off";
      vertical_scroll_margin = 0;

      command_aliases = {
        W = "w";
        Wq = "wq";
        Q = "q";
      };

      lsp = {
        vtsls = {
          settings = {
            javascript = {
              preferences = {
                importModuleSpecifier = "relative";
              };
            };
          };
        };
        nil = {
          binary = {
            path_lookup = false;
          };
        };
      };

      languages = {
        Nix = {
          language_servers = [ "nixd" "!nil" ];
        };
      };
    };

    userKeymaps = [
      {
        context = "Editor && (vim_mode == normal || vim_mode == visual) && !VimWaiting && !menu";
        bindings = {
          "ctrl i" = "editor::ToggleInlayHints";
          "ctrl f p" = "projects::OpenRecent";
          "g f" = "editor::OpenExcerpts";
          "ctrl l" = "editor::ToggleRelativeLineNumbers";
        };
      }
      {
        context = "Editor && vim_mode == normal && !VimWaiting && !menu";
        bindings = {
          "ctrl-+" = ["zed::IncreaseBufferFontSize" { persist = true; }];
          "ctrl--" = ["zed::DecreaseBufferFontSize" { persist = true; }];
          "ctrl-r" = "editor::Rename";
          "g d" = "editor::GoToDefinition";
          "g D" = "editor::GoToDefinitionSplit";
          "g i" = "editor::GoToImplementation";
          "g I" = "editor::GoToImplementationSplit";
          "g t" = "editor::GoToTypeDefinition";
          "g T" = "editor::GoToTypeDefinitionSplit";
          "g r" = "editor::FindAllReferences";
          "] d" = "editor::GoToDiagnostic";
          "[ d" = "editor::GoToPreviousDiagnostic";
          "] e" = "editor::GoToDiagnostic";
          "[ e" = "editor::GoToPreviousDiagnostic";
          "space s s" = "outline::Toggle";
          "space S s" = "project_symbols::Toggle";
          "ctrl x" = "diagnostics::Deploy";
          "] h" = "editor::GoToHunk";
          "[ h" = "editor::GoToPreviousHunk";
          "ctrl-s" = "workspace::Save";
        };
      }
      {
        context = "EmptyPane || SharedScreen";
        bindings = {
          "ctrl f p" = "projects::OpenRecent";
        };
      }
      {
        context = "Editor && vim_mode == visual && !VimWaiting && !menu";
        bindings = {
          "g c" = "editor::ToggleComments";
        };
      }
      {
        context = "Editor && vim_operator == c";
        bindings = {
          "c" = "vim::CurrentLine";
          "r" = "editor::Rename";
        };
      }
      {
        context = "Editor && vim_operator == c";
        bindings = {
          "c" = "vim::CurrentLine";
          "a" = "editor::ToggleCodeActions";
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "a" = "project_panel::NewFile";
          "A" = "project_panel::NewDirectory";
          "r" = "project_panel::Rename";
          "d" = "project_panel::Delete";
          "x" = "project_panel::Cut";
          "y" = "project_panel::Copy";
          "p" = "project_panel::Paste";
          "left" = "project_panel::CollapseSelectedEntry";
          "right" = "project_panel::ExpandSelectedEntry";
          "ctrl-y" = "workspace::CopyPath";
          "ctrl-shift-y" = "workspace::CopyRelativePath";
          "ctrl-f" = "project_panel::NewSearchInDirectory";
          "escape" = "menu::Cancel";
          "l" = "project_panel::ExpandSelectedEntry";
          "h" = "project_panel::CollapseSelectedEntry";
          "shift-h" = "project_panel::CollapseAllEntries";
          "ctrl-p" = "file_finder::Toggle";
        };
      }
      {
        context = "Dock || vim_mode == normal || vim_mode == visual";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ToggleBottomDock";
          "ctrl-w" = "pane::CloseActiveItem";
          "ctrl-shift-w" = "pane::CloseAllItems";
          "ctrl-b" = "workspace::ToggleLeftDock";
        };
      }
      {
        context = "terminal";
        bindings = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ToggleBottomDock";
          "ctrl-w" = "pane::CloseActiveItem";
          "ctrl-shift-w" = "pane::CloseAllItems";
          "ctrl-b" = "workspace::ToggleLeftDock";
        };
      }
      {
        context = "vim_mode == normal || vim_mode == visual";
        bindings = {
          "alt-o" = "editor::SelectLargerSyntaxNode";
          "alt-i" = "editor::SelectSmallerSyntaxNode";
          "s" = "vim::PushSneak";
          "S" = "vim::PushSneakBackward";
        };
      }
      {
        context = "VimControl && !menu && vim_mode != operator";
        bindings = {
          "w" = "vim::NextSubwordStart";
          "b" = "vim::PreviousSubwordStart";
          "e" = "vim::NextSubwordEnd";
          "g e" = "vim::PreviousSubwordEnd";
        };
      }
      {
        context = "Editor && mode == full";
        bindings = {
          "shift-enter" = ["editor::ExpandExcerpts" { lines = 5; }];
        };
      }
    ];
  };

  # Wrapper script with GPU acceleration (OpenGL + Vulkan for Intel Arc)
  # This replaces the default zeditor command in ~/.local/bin (which has priority in PATH)
  home.file.".local/bin/zeditor".text = ''
    #!/bin/sh
    # Use system Vulkan loader and ICD for Intel Arc GPU
    export LD_LIBRARY_PATH=/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
    exec ${nixGLPkg}/bin/nixGLIntel ${pkgs.zed-editor}/bin/zeditor "$@"
  '';
  home.file.".local/bin/zeditor".executable = true;

  # Desktop entry override for application launchers (uses same name as package to override)
  xdg.desktopEntries."dev.zed.Zed" = {
    name = "Zed";
    genericName = "Text Editor";
    comment = "A high-performance, multiplayer code editor.";
    exec = "/home/mdegand/.local/bin/zeditor %U";
    icon = "zed";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
    mimeType = [ "text/plain" "application/x-zerosize" "x-scheme-handler/zed" ];
    startupNotify = true;
  };
}
