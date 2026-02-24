{ ... }:

{
  programs.yazi = {
    enable = true;

    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "y" "i" ];
          run = ''shell 'wl-copy --type "$(file -b --mime-type "$0")" < "$0"' --confirm'';
          desc = "Copy image to clipboard";
        }
      ];
    };
  };
}
