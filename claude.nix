{ pkgs, zen-browser, ... }:

{
  home.file.".claude/CLAUDE.md".text = ''
    # Global Claude Code instructions

    ## Environment
    Home-manager (Nix) is used for system/tool configuration. When I talk about "config", it usually refers to this project (~/.config/home-manager). When fixing tool issues (qutebrowser, kitty, yazi, niri, etc.), check and modify the home-manager config rather than editing dotfiles directly.
    This global CLAUDE.md is managed by home-manager via `claude.nix`. To modify it, edit the `home.file.".claude/CLAUDE.md".text` block in `~/.config/home-manager/claude.nix`, not `~/.claude/CLAUDE.md` directly.
    Nix flakes only see git-tracked files. Always `git add` new or modified files before running `home-manager switch`, otherwise they will be silently ignored.

    ## playwright-cli
    Before the first `playwright-cli open` of a session, create missing lock files that Playwright requires:
    ```
    touch ~/.cache/ms-playwright/firefox-*/firefox/lock ~/.cache/ms-playwright/chromium-*/chrome-linux64/lock 2>/dev/null
    ```
    For Chromium: prefix commands with `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=${pkgs.chromium}/bin/chromium`.
    For Zen browser: prefix with `PLAYWRIGHT_FIREFOX_EXECUTABLE_PATH=${
      zen-browser.packages.${pkgs.system}.default
    }/bin/zen` and pass `--browser=firefox`.
  '';

  home.file.".claude/skills".source = ./dotfiles/claude/skills;
  home.file.".claude/skills".recursive = true;

  home.file.".agents/skills".source = ./dotfiles/claude/skills;
  home.file.".agents/skills".recursive = true;

  home.file.".claude/statusline.js".source = ./dotfiles/claude/statusline.js;

  home.file.".claude/settings.json".text = builtins.toJSON {
    env = {
      ENABLE_LSP_TOOL = "1";
    };
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
