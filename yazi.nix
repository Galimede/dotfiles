{ ... }:

{
  programs.yazi = {
    enable = true;

    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "<C-y>" ];
          run = ''shell 'wl-copy --type "$(file -b --mime-type "$0")" < "$0"' --confirm'';
          desc = "Copy file to clipboard";
        }
      ];
    };
  };
}
