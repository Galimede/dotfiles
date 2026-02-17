{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Keep the TOML config as-is (too complex to convert to Nix)
  home.file.".config/starship.toml".source = ./dotfiles/starship.toml;
}
