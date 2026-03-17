---
name: session-audit
description: "Scrape and analyze all Claude Code sessions on this computer to identify usage patterns and give actionable recommendations. Use this skill when the user wants to audit their Claude usage, understand what they do most, find patterns across sessions, discover what should become skills/plugins/agents, or figure out what belongs in CLAUDE.md. Also trigger when the user asks about their Claude habits, wants to optimize their workflow, or says things like 'analyze my sessions', 'what do I use Claude for', or 'how can I improve my setup'."
---

# Session Audit — Claude Usage Pattern Analyzer

Scrape all Claude Code sessions on this machine, analyze usage patterns, and produce a structured breakdown of what the user does most and what should be automated or codified.

## How sessions are stored

Claude Code stores conversations as JSONL files:

- **Session files**: `~/.claude/projects/<encoded-project-path>/<session-uuid>.jsonl`
- **Subagent files**: `~/.claude/projects/<encoded-project-path>/subagents/agent-*.jsonl`
- **Global history**: `~/.claude/history.jsonl` (one-line summaries with timestamps)

Each JSONL line is a JSON object with a `type` field (`user`, `assistant`, `system`, `progress`) and a `message` field containing `role` and `content`. The `content` can be a string or an array of content blocks (text, tool_use, tool_result).

## Steps

### 1. Discover all sessions

```bash
# List all project directories
ls ~/.claude/projects/

# Count sessions per project
for dir in ~/.claude/projects/*/; do
  project=$(basename "$dir")
  count=$(ls "$dir"/*.jsonl 2>/dev/null | wc -l)
  echo "$project: $count sessions"
done
```

Also read `~/.claude/history.jsonl` for a quick overview — each line has `display` (the user's prompt), `timestamp`, `project`, and `sessionId`.

### 2. Extract usage data

For each session JSONL file, extract:

- **User messages**: lines where `type` is `user` — these show what the user asked for
- **Tool usage**: lines where `type` is `assistant` and `content` contains `tool_use` blocks — track which tools are called and how often
- **Skills invoked**: look for skill triggers in the conversation flow
- **File paths**: files read, edited, or created
- **Commands run**: Bash tool invocations
- **Project context**: which project directory the session belongs to

Process sessions in batches to avoid memory issues. Use `jq` or Python for parsing — the files can be large.

A practical approach: use a script that streams through the JSONL files line by line rather than loading everything into memory. Focus on extracting structured summaries rather than raw content.

### 3. Analyze patterns

Group and rank findings across these dimensions:

- **Frequency**: What tasks, tools, and workflows appear most often?
- **Time spent**: Which sessions are longest (by message count)?
- **Repetition**: What sequences of actions repeat across sessions? (e.g., "read file → edit → run tests" is a common loop)
- **Project distribution**: Which projects get the most Claude attention?
- **Pain points**: Where do conversations get long or require many corrections? These signal friction.

### 4. Produce the breakdown

Structure the output as five clear sections:

#### What I do most frequently
Rank the top activities by frequency. Include concrete numbers (e.g., "File editing across 45 sessions", "Git operations in 30 sessions"). Group related activities together.

#### What should become skills (reusable workflows/knowledge)
Identify multi-step workflows that repeat with variations. A good skill candidate is a sequence of 3+ steps that the user triggers regularly but with different inputs each time. Look for patterns like:
- Repeated tool sequences (read → transform → write)
- Domain-specific knowledge the user keeps re-explaining
- Formatting or output conventions applied across sessions

#### What should become plugins (standalone tools)
Look for cases where Claude repeatedly writes one-off scripts to do the same thing, or where a single well-defined operation (data conversion, API call, file format handling) keeps coming up. A plugin is a standalone tool that does one thing well — if Claude keeps reinventing the same wheel, that wheel should be a tool.

#### What should become agents (autonomous subagents)
Identify complex, multi-step tasks that could run autonomously with minimal user input. Good agent candidates are tasks where:
- The user kicks it off and comes back later
- Multiple independent subtasks could run in parallel
- The workflow has clear success criteria

#### What belongs in CLAUDE.md (project-level instructions)
Surface implicit preferences and conventions the user repeatedly corrects or specifies:
- Coding style preferences (formatting, naming, patterns)
- Project-specific context that gets re-explained each session
- Tool preferences ("always use X instead of Y")
- Environment details (paths, configs, dependencies)

### 5. Save the report

Save the analysis to the Obsidian inbox if available (`~/Documents/daily-notes/00 Inbox/`), otherwise to `~/claude-session-audit.md`. Use a descriptive filename like `claude-audit-<YYYY-MM-DD>.md`.

Format the report in clean markdown with headers, bullet points, and concrete examples pulled from actual sessions. Include session counts and timestamps to back up the recommendations.
