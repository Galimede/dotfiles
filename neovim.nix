{ pkgs, ... }:
let
  lspServers = with pkgs; [
    vtsls
    vscode-langservers-extracted # eslint, html, json, css
    stylelint-lsp
    nil
    lua-language-server
    bash-language-server
    marksman
  ];
  formatters = with pkgs; [
    stylua
    prettierd
    nixfmt-rfc-style
  ];
  plugins = with pkgs.vimPlugins; [
    # Core
    catppuccin-nvim
    which-key-nvim
    persistence-nvim
    plenary-nvim

    # Navigation
    snacks-nvim
    flash-nvim
    mini-nvim

    # Editing
    blink-cmp
    friendly-snippets
    conform-nvim
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects
    multicursor-nvim
    nvim-ts-autotag

    # UI
    lualine-nvim
    noice-nvim
    nui-nvim
    render-markdown-nvim
    todo-comments-nvim
    inc-rename-nvim

    # Git
    neogit
    gitsigns-nvim
    codediff-nvim

    # AI
    claudecode-nvim

    # LSP utils
    nvim-lspconfig
    lazydev-nvim
    SchemaStore-nvim
  ];
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [ git ripgrep fd ] ++ lspServers ++ formatters;
    plugins = plugins;
  };

  xdg.configFile."nvim" = {
    source = ./dotfiles/nvim;
    recursive = true;
  };
}
