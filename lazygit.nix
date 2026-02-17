{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        useHunkModeInStagingView = false;
      };
    };
  };
}
