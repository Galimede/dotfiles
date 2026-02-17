{ pkgs, private-fonts, ... }:

{
  home.packages = [
    private-fonts.packages.${pkgs.system}.dank-mono
    pkgs.noto-fonts-color-emoji  # Emoji support (browsers, Obsidian, etc.)
    pkgs.nerd-fonts.symbols-only  # Nerd Font icons (starship, etc.)
    pkgs.nerd-fonts.hack  # Hack with Nerd Font glyphs (terminal)
  ];

  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Hack Nerd Font" "Symbols Nerd Font" ];
    emoji = [ "Noto Color Emoji" ];
  };

  # Symlink fonts into ~/.local/share/fonts so all apps (including sandboxed
  # Nix-packaged browsers) can find them via the standard XDG font directory
  xdg.dataFile."fonts/NotoColorEmoji.ttf".source =
    "${pkgs.noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf";
  xdg.dataFile."fonts/NerdFonts/Hack".source =
    "${pkgs.nerd-fonts.hack}/share/fonts/truetype/NerdFonts/Hack";
  xdg.dataFile."fonts/NerdFonts/Symbols".source =
    "${pkgs.nerd-fonts.symbols-only}/share/fonts/truetype/NerdFonts/Symbols";
}
