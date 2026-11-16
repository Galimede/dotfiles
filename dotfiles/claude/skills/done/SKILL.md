---
name: done
description: "Wrap up a Claude Code session by summarizing key decisions, questions, and follow-ups into a markdown report saved to the project root. Use this skill whenever the user says /done, wants to wrap up, end a session, save a session summary, or log what was accomplished. Also trigger when the user asks to capture session notes, write a debrief, or save progress."
---

# Done — Session Wrap-Up

When invoked, produce a structured summary of the current conversation and save it as a markdown file.

## Steps

### 1. Gather context

Run these commands to collect metadata:

```bash
# Get the current session ID (most recently modified .jsonl in the project dir)
# The project dir is derived from $PWD: ~/.claude/projects/<encoded-path>/
session_file=$(ls -t ~/.claude/projects/*/?.jsonl 2>/dev/null | head -1)
# Extract just the UUID from the filename
session_id=$(basename "$session_file" .jsonl)
```

```bash
# Get branch info — try GitButler first, fall back to git
but status --json 2>/dev/null || git branch --show-current 2>/dev/null || echo "no branch"
```

For GitButler repos, extract the applied branch names from `but status --json`. For plain git repos, use the current branch name.

### 2. Summarize the conversation

Review the entire conversation and extract:

- **What was done** — concrete changes, files modified, commands run
- **Key decisions** — architectural choices, trade-offs made, approaches picked over alternatives
- **Open questions** — anything unresolved or flagged for later
- **Follow-ups** — next steps, TODOs, things to revisit

Be concise but complete. Capture the essence of the session — someone reading this note tomorrow should be able to pick up where things left off.

### 3. Write the report

Determine the save location:

- if the user explicitly asks for a save location save it there otherwise save it to the project root.

Use this naming pattern:

```
session-<short-session-id>-<branch-name>.md
```

Where `<short-session-id>` is the first 8 characters of the session UUID, and `<branch-name>` is slugified (lowercase, spaces/slashes replaced with dashes). If there are multiple applied branches, use the most relevant one or join them with `+`.

Use this template:

```markdown
# Session Report

session:: `<full-session-id>`
branch:: `<branch-name(s)>`
date:: <YYYY-MM-DD>
project:: `<working-directory-basename>`

## What was done

- <bullet points of concrete accomplishments>

## Key decisions

- <decision and brief rationale>

## Open questions

- <unresolved items, if any>

## Follow-ups

- [ ] <actionable next steps as tasks>
```

The `session::`, `branch::`, `date::`, and `project::` lines use inline fields (Dataview syntax) so they're queryable.

### 4. Confirm

After writing the file, tell the user:

- The file path
- A brief one-liner of what was captured
