{ pkgs, config, nixgl, ... }:

let
  nixGLPkg = nixgl.packages.${pkgs.system}.nixGLIntel;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];

    profiles.default.userSettings = {
      # Theme
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-vsc-icons";

      # Editor (matching Zed settings)
      "editor.fontFamily" = "'Dank Mono', 'Hack Nerd Font', monospace";
      "editor.fontSize" = 18;
      "editor.lineNumbers" = "on";
      "editor.minimap.enabled" = false;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.horizontal" = "hidden";
      "editor.scrollBeyondLastLine" = false;
      "editor.guides.indentation" = true;
      "editor.inlayHints.enabled" = "off";

      # Terminal
      "terminal.integrated.fontFamily" = "'Hack Nerd Font'";
      "terminal.integrated.fontSize" = 15;

      # Telemetry
      "telemetry.telemetryLevel" = "off";

      # Vim
      "vim.leader" = "<space>";
      "vim.sneak" = true;
      "vim.useSystemClipboard" = true;
      "vim.camelCaseMotion.enable" = true;
      "vim.smartcase" = true;
      "vim.incsearch" = true;
      "vim.hlsearch" = true;

      # Prevent vim from capturing ctrl keys we remap
      "vim.handleKeys" = {
        "<C-b>" = false;
        "<C-w>" = false;
        "<C-h>" = false;
        "<C-j>" = false;
        "<C-k>" = false;
        "<C-l>" = false;
      };

      # Normal mode vim bindings
      "vim.normalModeKeyBindingsNonRecursive" = [
        # LSP navigation
        { before = [ "g" "d" ]; commands = [ "editor.action.revealDefinition" ]; }
        { before = [ "g" "D" ]; commands = [ "editor.action.revealDefinitionAside" ]; }
        { before = [ "g" "i" ]; commands = [ "editor.action.goToImplementation" ]; }
        { before = [ "g" "t" ]; commands = [ "editor.action.goToTypeDefinition" ]; }
        { before = [ "g" "r" ]; commands = [ "editor.action.goToReferences" ]; }

        # Diagnostics navigation
        { before = [ "]" "d" ]; commands = [ "editor.action.marker.next" ]; }
        { before = [ "[" "d" ]; commands = [ "editor.action.marker.prev" ]; }
        { before = [ "]" "e" ]; commands = [ "editor.action.marker.next" ]; }
        { before = [ "[" "e" ]; commands = [ "editor.action.marker.prev" ]; }

        # Hunk navigation
        { before = [ "]" "h" ]; commands = [ "workbench.action.editor.nextChange" ]; }
        { before = [ "[" "h" ]; commands = [ "workbench.action.editor.previousChange" ]; }

        # Symbols (space s s = document symbols, space S s = workspace symbols)
        { before = [ "<leader>" "s" "s" ]; commands = [ "workbench.action.gotoSymbol" ]; }
        { before = [ "<leader>" "S" "s" ]; commands = [ "workbench.action.showAllSymbols" ]; }
      ];

      # Visual mode vim bindings
      "vim.visualModeKeyBindingsNonRecursive" = [
        { before = [ "g" "c" ]; commands = [ "editor.action.commentLine" ]; }
      ];
    };

    profiles.default.keybindings = [
      # Pane/split navigation
      { key = "ctrl+h"; command = "workbench.action.focusLeftGroup"; when = "editorTextFocus && vim.mode != 'Insert'"; }
      { key = "ctrl+l"; command = "workbench.action.focusRightGroup"; when = "editorTextFocus && vim.mode != 'Insert'"; }
      { key = "ctrl+k"; command = "workbench.action.focusAboveGroup"; when = "editorTextFocus && vim.mode != 'Insert'"; }
      { key = "ctrl+j"; command = "workbench.action.togglePanel"; when = "editorTextFocus && vim.mode != 'Insert'"; }

      # Same in terminal
      { key = "ctrl+h"; command = "workbench.action.focusLeftGroup"; when = "terminalFocus"; }
      { key = "ctrl+l"; command = "workbench.action.focusRightGroup"; when = "terminalFocus"; }
      { key = "ctrl+k"; command = "workbench.action.focusAboveGroup"; when = "terminalFocus"; }
      { key = "ctrl+j"; command = "workbench.action.togglePanel"; when = "terminalFocus"; }

      # Close editor
      { key = "ctrl+w"; command = "workbench.action.closeActiveEditor"; when = "editorTextFocus && vim.mode != 'Insert'"; }
      { key = "ctrl+shift+w"; command = "workbench.action.closeAllEditors"; when = "editorTextFocus && vim.mode != 'Insert'"; }

      # Toggle sidebar
      { key = "ctrl+b"; command = "workbench.action.toggleSidebarVisibility"; }

      # Rename
      { key = "ctrl+r"; command = "editor.action.rename"; when = "editorTextFocus && vim.mode == 'Normal'"; }

      # Toggle inlay hints
      { key = "ctrl+i"; command = "editor.action.toggleInlayHints"; when = "editorTextFocus && vim.mode != 'Insert'"; }

      # Diagnostics panel
      { key = "ctrl+x"; command = "workbench.actions.view.problems"; when = "editorTextFocus && vim.mode == 'Normal'"; }

      # Expand/shrink selection (matching alt-o/alt-i from Zed)
      { key = "alt+o"; command = "editor.action.smartSelect.expand"; when = "editorTextFocus && vim.mode != 'Insert'"; }
      { key = "alt+i"; command = "editor.action.smartSelect.shrink"; when = "editorTextFocus && vim.mode != 'Insert'"; }

      # Save
      { key = "ctrl+s"; command = "workbench.action.files.save"; }
    ];
  };

  # Wrapper script with GPU acceleration for Intel Arc
  home.file.".local/bin/codium".text = ''
    #!/bin/sh
    export LD_LIBRARY_PATH=/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
    exec ${nixGLPkg}/bin/nixGLIntel ${pkgs.vscodium}/bin/codium "$@"
  '';
  home.file.".local/bin/codium".executable = true;

  # Desktop entry override for application launchers
  xdg.desktopEntries."codium" = {
    name = "VSCodium";
    genericName = "Text Editor";
    comment = "Code editing. Redefined.";
    exec = "${config.home.homeDirectory}/.local/bin/codium %F";
    icon = "vscodium";
    terminal = false;
    type = "Application";
    categories = [ "Development" ];
    mimeType = [ "text/plain" ];
    startupNotify = true;
  };
}
