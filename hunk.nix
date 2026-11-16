{ hunk, ... }:

{
  imports = [ hunk.homeManagerModules.default ];

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };
}
