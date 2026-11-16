---
name: code-review
description: "Perform a thorough senior-engineer-style code review covering architecture, bugs, performance, security, maintainability, and test coverage, output as a prioritized markdown report. Use this skill whenever the user asks to review code, review a PR, review a diff, do a code review, critique a change, give feedback on code, audit a branch, or check code quality — even if they don't use the word 'review' explicitly (e.g. 'take a look at this', 'what do you think of this PR', 'any issues with this code')."
---

# Code Review — Senior Engineer

Perform a rigorous, constructive code review in the voice of an experienced senior engineer. The goal is feedback the author can act on immediately, not a generic checklist.

## Step 1: Find out what to review

If the user hasn't already pointed you at something specific, ask. Keep the question short and offer concrete options so they don't have to think about what's possible:

> What would you like me to review? For example:
> - A pull request (paste the URL or number)
> - A local branch or diff (e.g. `main..feature-x`)
> - A specific file or set of files
> - A pasted snippet

Once they answer, fetch the code:

- **GitHub PR**: `gh pr view <N> --json title,body,files` then `gh pr diff <N>` to get the diff
- **Local branch**: `git diff <base>..<head>` or `git log <base>..<head>` for context
- **Files**: read them directly
- **Snippet**: use what they pasted

If the change is large, skim the diff first to get a mental map, then read the full file contents for the areas that actually changed — reviewing a diff in isolation is how subtle bugs get missed.

## Step 2: Review mindset

Think like a staff engineer who actually has to maintain this code. Specifically:

- **Read for intent first.** What is the author trying to accomplish? A review that misunderstands the goal produces useless nits.
- **Go beyond the diff.** Check how the changed code interacts with what's around it. A function might look fine in isolation but break an invariant the caller relies on.
- **Distinguish taste from correctness.** "I would have done this differently" is not the same as "this is wrong." Flag taste as taste.
- **Prioritize ruthlessly.** A review with 40 equal-weight bullet points is a review no one reads. Lead with the things that actually matter.

## Step 3: Focus areas

Work through these dimensions, but only report findings that have substance. Skip headings where you have nothing meaningful to say rather than padding with filler.

- **Architecture & design** — Does the approach fit the codebase? Are responsibilities in the right layers? Is there unnecessary coupling, indirection, or abstraction? Is there a simpler way?
- **Bugs & edge cases** — What happens with empty input, nulls, concurrent access, partial failures, unicode, timezones, off-by-ones, error paths that silently swallow errors?
- **Performance** — Unnecessary O(n²) loops, N+1 queries, missed caching/memoization, large allocations in hot paths, blocking I/O in async contexts. Only flag this when it matters in practice.
- **Security** — Injection vectors (SQL, command, XSS), authn/authz gaps, secrets in code/logs, unsafe deserialization, TOCTOU races, dependency risks, CSRF, SSRF.
- **Maintainability** — Naming, cohesion, readability, duplication, dead code, comments that lie, error messages that don't help the person who'll read them at 3am.
- **Test coverage** — Are the important branches tested? Are tests actually asserting something meaningful, or just exercising code? Are edge cases covered? Are tests brittle (over-mocked, order-dependent)?

## Step 4: Output the review

Produce the review as markdown, in this exact structure:

```markdown
# Code Review: <short descriptor of what was reviewed>

## Summary
<2–4 sentences: what this change does and why. Show that you understood the intent.>

## Strengths
- <Genuine positives. Skip this section if there's nothing real to say — empty praise hurts trust.>

## Issues & Improvements

### Critical
<Things that are broken, insecure, or will cause incidents. Empty section if none — say "None" explicitly.>

### Important
<Real problems worth fixing before merge: likely bugs, meaningful design issues, missing tests for risky paths.>

### Minor
<Style, naming, small refactors, nice-to-haves. Be honest that these are optional.>

## Suggested Changes
<For the top issues, show concrete before/after code. Don't rewrite the whole PR — just the specific spots where a code example makes the feedback unambiguous.>
```

### Writing each finding

Every issue should include:

1. **Where** — file and line (e.g. `src/auth/session.ts:42`)
2. **What's wrong** — the specific problem, not a vague concern
3. **Why it matters** — the concrete consequence (bug, attack, perf hit, future maintenance pain)
4. **What to do** — a suggested fix, ideally with a code snippet for non-trivial ones

A finding like "consider error handling here" is useless. "At `api/users.ts:88`, `JSON.parse(body)` will throw on malformed input and the surrounding `try/catch` only catches `DbError`, so the request will 500 instead of 400 — wrap the parse or add a generic catch that maps to a 400" is actionable.

### Code examples

When suggesting a change, show it as a small diff or before/after block:

````markdown
**`src/api/users.ts:88`** — unhandled parse error

```ts
// before
try {
  const data = JSON.parse(body);
  await db.insert(data);
} catch (e: DbError) { ... }

// after
let data;
try {
  data = JSON.parse(body);
} catch {
  return res.status(400).json({ error: "invalid JSON" });
}
try {
  await db.insert(data);
} catch (e) { ... }
```
````

Don't rewrite code for style preferences — only when the example clarifies a concrete issue.

## Tone

Direct, specific, kind. You are reviewing a colleague's work. Assume they are competent and had reasons for their choices — if something looks wrong, ask "is there a reason for X?" for things that might be intentional, and state plainly when something is definitely a problem. Never condescending, never padded with hedges.
