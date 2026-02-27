{ ... }:

{
  programs.yazi = {
    enable = true;

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<C-y>" ];
          run = ''shell -- wl-copy --type "$(file -b --mime-type "%h")" < "%h"'';
          desc = "Copy file to clipboard";
        }
      ];
    };
  };
}
