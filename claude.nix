{ pkgs, zen-browser, ... }:

{
  home.file.".claude/CLAUDE.md".text = ''
    # Global Claude Code instructions

    ## playwright-cli
    Always prefix playwright-cli commands with `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=${pkgs.chromium}/bin/chromium` when using playwright-cli.
    If asked to use Zen browser, prefix with `PLAYWRIGHT_FIREFOX_EXECUTABLE_PATH=${
      zen-browser.packages.${pkgs.system}.default
    }/bin/zen` and pass `--browser=firefox` instead.
  '';

  home.file.".claude/skills".source = ./dotfiles/claude/skills;
  home.file.".claude/skills".recursive = true;

  home.file.".agents/skills".source = ./dotfiles/claude/skills;
  home.file.".agents/skills".recursive = true;

  home.file.".claude/statusline.js".source = ./dotfiles/claude/statusline.js;

  home.file.".claude/settings.json".text = builtins.toJSON {
    includeCoAuthoredBy = false;
    statusLine = {
      type = "command";
      command = "${pkgs.nodejs}/bin/node ~/.claude/statusline.js";
    };
    permissions = {
      allow = [
        "Fetch"
        "WebFetch"
        "WebSearch"
        "mcp__context7__resolve-library-id"
        "mcp__context7__get-library-docs"
        "mcp__context7__query-docs"
        "Bash(awk:*)"
        "Bash(cat:*)"
        "Bash(curl:*)"
        "Bash(diff:*)"
        "Bash(du:*)"
        "Bash(fd:*)"
        "Bash(file:*)"
        "Bash(find:*)"
        "Bash(head:*)"
        "Bash(jq:*)"
        "Bash(ls:*)"
        "Bash(mkdir:*)"
        "Bash(grep:*)"
        "Bash(rg:*)"
        "Bash(sed:*)"
        "Bash(stat:*)"
        "Bash(tail:*)"
        "Bash(wc:*)"
        "Bash(which:*)"
        "Bash(git add:*)"
        "Bash(git branch:*)"
        "Bash(git checkout:*)"
        "Bash(git describe:*)"
        "Bash(git diff:*)"
        "Bash(git fetch:*)"
        "Bash(git for-each-ref:*)"
        "Bash(git filter-branch:*)"
        "Bash(git log:*)"
        "Bash(git rev-parse:*)"
        "Bash(git show:*)"
        "Bash(git status:*)"
        "Bash(git tag -l:*)"
        "Bash(git tag --sort:*)"
        "Bash(gh issue list:*)"
        "Bash(gh issue status:*)"
        "Bash(gh issue view:*)"
        "Bash(gh pr diff:*)"
        "Bash(gh pr list:*)"
        "Bash(gh pr status:*)"
        "Bash(gh pr view:*)"
        "Bash(gh search:*)"
        "Bash(glab issue list:*)"
        "Bash(glab issue view:*)"
        "Bash(glab mr list:*)"
        "Bash(glab mr view:*)"
        "Bash(npm info:*)"
        "Bash(npm install:*)"
        "Bash(npm run build:*)"
        "Bash(npm run lint:*)"
        "Bash(npm search:*)"
        "Bash(node --check:*)"
        "Bash(playwright-cli:*)"
        "Read(~/.config/home-manager/**)"
      ];
      deny = [
        "Read(.env*)"
      ];
    };
  };
}
