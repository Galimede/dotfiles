# Dynamic completions for GitButler CLI (but) — CLI IDs, commits, branches

# Parse but status --json for CLI IDs (branches, commits, files)
function __but_cli_ids
    set -l json (but status --json 2>/dev/null)
    or return

    # Branch and commit CLI IDs from stacks
    echo $json | command jq -r '
        .stacks[]? |
        (.branches[]? |
            "\(.cliId)\t\(.name)",
            (.commits[]? | "\(.cliId)\t\(.message | split("\n")[0])")
        )
    ' 2>/dev/null

    # Unstaged file CLI IDs
    echo $json | command jq -r '
        [.stacks[]?.assignedChanges[]? | "\(.cliId)\t\(.filePath)"] +
        [.unassignedChanges[]? | "\(.cliId)\t\(.filePath)"]
        | .[]
    ' 2>/dev/null
end

# Git commits (SHA + description) as fallback / supplement
function __but_git_commits
    git log --oneline --no-decorate -n 20 2>/dev/null | while read -l line
        set -l sha (string sub -l 7 -- $line)
        set -l msg (string sub -s 9 -- $line)
        printf '%s\t%s\n' $sha $msg
    end
end

# Git branches
function __but_git_branches
    git branch --format='%(refname:short)' 2>/dev/null
end

function __but_git_branches_all
    git branch -a --format='%(refname:short)' 2>/dev/null
end

# Combined: CLI IDs + git commits + branches
function __but_refs
    __but_cli_ids
    __but_git_commits
    __but_git_branches
end

# Combined: CLI IDs + branches only
function __but_branch_refs
    __but_cli_ids
    __but_git_branches_all
end

# Commands that accept any ref (commit, branch, file CLI ID)
for cmd in show diff reword squash uncommit pick move rub amend absorb discard mark
    complete -c but -n "__fish_but_using_subcommand $cmd" -f -a "(__but_refs)"
end

# Commands that accept branch names
for cmd in merge apply unapply commit push
    complete -c but -n "__fish_but_using_subcommand $cmd" -f -a "(__but_branch_refs)"
end

# stage: positional args are file/hunk + branch
complete -c but -n "__fish_but_using_subcommand stage" -f -a "(__but_refs)"
complete -c but -n "__fish_but_using_subcommand stage" -s b -l branch -f -a "(__but_git_branches)"

# unstage: file/hunk + optional branch
complete -c but -n "__fish_but_using_subcommand unstage" -f -a "(__but_refs)"

# branch subcommands
complete -c but -n "__fish_but_using_subcommand branch; and __fish_seen_subcommand_from delete" -f -a "(__but_branch_refs)"
complete -c but -n "__fish_but_using_subcommand branch; and __fish_seen_subcommand_from show" -f -a "(__but_branch_refs)"
complete -c but -n "__fish_but_using_subcommand branch; and __fish_seen_subcommand_from new" -s a -l anchor -f -a "(__but_refs)"
