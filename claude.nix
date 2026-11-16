{ pkgs, lib, zen-browser, ... }:

let
  # Nix-managed baseline, merged into ~/.claude/settings.json on activation so
  # Claude Code can still write to it (/model, /effort, ...).
  claudeSettings = pkgs.writeText "claude-settings.json" (
    builtins.toJSON {
      env = {
        ENABLE_LSP_TOOL = "1";
      };
      includeCoAuthoredBy = false;
      outputStyle = "Concise";
      statusLine = {
        type = "command";
        command = "${pkgs.nodejs}/bin/node ~/.claude/statusline.js";
      };
      permissions = {
        allow = [
          "Fetch"
          "WebFetch"
          "WebSearch"
          "Bash(ctx7:*)"
          "Bash(awk:*)"
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
          "Bash(stat:*)"
          "Bash(tail:*)"
          "Bash(wc:*)"
          "Bash(which:*)"
          "Bash(git add:*)"
          "Bash(git blame:*)"
          "Bash(git branch:*)"
          "Bash(git cat-file:*)"
          "Bash(git checkout:*)"
          "Bash(git describe:*)"
          "Bash(git diff:*)"
          "Bash(git fetch:*)"
          "Bash(git for-each-ref:*)"
          "Bash(git grep:*)"
          "Bash(git filter-branch:*)"
          "Bash(git log:*)"
          "Bash(git ls-files:*)"
          "Bash(git merge-base:*)"
          "Bash(git remote -v:*)"
          "Bash(git rev-parse:*)"
          "Bash(git show:*)"
          "Bash(git stash list:*)"
          "Bash(git status:*)"
          "Bash(git tag -l:*)"
          "Bash(git tag --sort:*)"
          "Bash(git worktree list:*)"
          "Bash(gh issue list:*)"
          "Bash(gh issue status:*)"
          "Bash(gh issue view:*)"
          "Bash(gh pr checks:*)"
          "Bash(gh pr diff:*)"
          "Bash(gh pr list:*)"
          "Bash(gh pr status:*)"
          "Bash(gh pr view:*)"
          "Bash(gh release list:*)"
          "Bash(gh release view:*)"
          "Bash(gh repo view:*)"
          "Bash(gh run list:*)"
          "Bash(gh run view:*)"
          "Bash(gh search:*)"
          "Bash(glab ci list:*)"
          "Bash(glab ci status:*)"
          "Bash(glab ci trace:*)"
          "Bash(glab issue create:*)"
          "Bash(glab issue list:*)"
          "Bash(glab issue update:*)"
          "Bash(glab issue view:*)"
          "Bash(glab label list:*)"
          "Bash(glab mr create:*)"
          "Bash(glab mr diff:*)"
          "Bash(glab mr issues:*)"
          "Bash(glab mr list:*)"
          "Bash(glab mr update:*)"
          "Bash(glab mr view:*)"
          "Bash(glab release list:*)"
          "Bash(glab release view:*)"
          "Bash(glab repo view:*)"
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
          "Bash(gh auth:*)"
          "Bash(glab auth:*)"
          "Read(~/.config/gh/**)"
          "Read(~/.config/glab-cli/**)"
        ];
      };
    }
  );
in
{
  home.file.".claude/CLAUDE.md".text = ''
    # Global Claude Code instructions

    ## Environment
    Home-manager (Nix) is used for system/tool configuration. When I talk about "config", it usually refers to this project (~/.config/home-manager). When fixing tool issues (qutebrowser, kitty, yazi, niri, etc.), check and modify the home-manager config rather than editing dotfiles directly.
    This global CLAUDE.md is managed by home-manager via `claude.nix`. To modify it, edit the `home.file.".claude/CLAUDE.md".text` block in `~/.config/home-manager/claude.nix`, not `~/.claude/CLAUDE.md` directly.
    Nix flakes only see git-tracked files. Always `git add` new or modified files before running `home-manager switch`, otherwise they will be silently ignored.

    ## Core Principles
    - **Simplicity First**: Make every change as simple as possible. Impact minimal code.
    - **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
    - **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

    ## Workflow Orchestration

    ### Plan Mode Default
    - Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions).
    - If something goes sideways, STOP and re-plan immediately — don't keep pushing.
    - Write detailed specs upfront to reduce ambiguity.
    - Before editing code, read and understand the full context first. Check related files, existing patterns, and architecture specs before making any changes.

    ### Autonomous Bug Fixing
    - When given a clear bug report with an obvious fix: just fix it. Don't ask for hand-holding.
    - Point at logs, errors, failing tests — then resolve them.
    - For non-trivial tasks or ideas, present your understanding and proposed approach first. Only start writing code when the user explicitly asks to proceed.

    ### Subagent Strategy
    - Use subagents liberally to keep main context window clean.
    - Offload research, exploration, and parallel analysis to subagents.
    - One task per subagent for focused execution.
    - When working in parallel, only one agent should edit a given file at a time.

    ## Task Management
    1. **Plan First**: Write plan with checkable items.
    2. **Verify Plan**: Check in before starting implementation.
    3. **Track Progress**: Mark items complete as you go.
    4. **Explain Changes**: High-level summary at each step.
    5. **Document Results**: Add review section when done.

    ## Execution Rules
    When asked to implement a plan or refactoring, execute ALL steps completely. Do not stop partway through to re-plan, audit, or summarize. If something is unclear, ask once then proceed with implementation.

    ## Code Quality
    - For non-trivial changes, pause and ask "is there a more elegant way?" — but skip this for simple, obvious fixes.
    - If a fix feels hacky, implement the elegant solution instead.
    - Challenge your own work before presenting it.

    ## Quality Checks
    - When fixing bugs or implementing changes from a list, verify each item is actually resolved before reporting completion. Cross-reference the original list item-by-item.
    - Never mark a task complete without proving it works.
    - Ask yourself: "Would a staff engineer approve this?"

    ## Self-Improvement
    After ANY correction from the user, save a feedback memory that includes:
    - The mistake pattern (what went wrong)
    - The prevention rule (how to avoid it next time)
    - Why it matters
    Review relevant feedback memories at session start.

    ## Output Format
    When user asks for a single consolidated output (report, summary, etc.), produce ONE file/artifact. Do not split into multiple separate outputs unless explicitly asked.

    ## Style
    Never use the em dash (—) or en dash (–), in any language, any output (chat, code, commits, docs, messages to third parties). Use a comma, a period, parentheses, or rephrase instead.

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

  home.file.".claude/output-styles".source = ./dotfiles/claude/output-styles;
  home.file.".claude/output-styles".recursive = true;

  home.file.".claude/statusline.js".source = ./dotfiles/claude/statusline.js;

  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    f="$HOME/.claude/settings.json"
    mkdir -p "$HOME/.claude"
    if [ -L "$f" ] || [ ! -e "$f" ]; then
      rm -f "$f"
      echo '{}' > "$f"
    fi
    tmp="$(mktemp)"
    ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$f" ${claudeSettings} > "$tmp"
    install -m 644 "$tmp" "$f"
    rm -f "$tmp"
  '';
}
