{ ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Nix daemon
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      # Zoxide
      zoxide init fish | source

      # GitButler CLI completions (installed externally via install script)
      but completions fish | source
    '';

    shellInit = ''
      fish_add_path -g ~/.local/bin
    '';

    shellAliases = {
      ll = "ls -la";
      # Simple git aliases
      ga = "git add";
      gc = "git commit";
      "gc!" = "git commit -v --amend";
      gd = "git diff";
      gfo = "git fetch origin";
      gp = "git push";
      gpf = "git push --force-with-lease";
      grb = "git rebase";
      grbi = "git rebase -i";
      greflog = "git reflog --date=local";
      grh = "git reset";
      grhh = "git reset --hard";
      glog = "git log --oneline --decorate --graph";
      grs = "git restore";
      gst = "git status";
      gsw = "git switch";
    };
  };

  # Complex functions stay as files
  home.file.".config/fish/functions" = {
    source = ./dotfiles/fish/functions;
    recursive = true;
  };

  # Extra conf.d scripts (GitButler dynamic completions, etc.)
  home.file.".config/fish/conf.d" = {
    source = ./dotfiles/fish/conf.d;
    recursive = true;
  };
}
