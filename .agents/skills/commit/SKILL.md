---
name: commit
description: >
  Stage changes and create git commits with Conventional Commit messages.
  Use when asked to "commit", "stage and commit", or after completing a task.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
---

# Commit Skill

## Preconditions
- Verify `git rev-parse --is-inside-work-tree` succeeds. If not, return message text only.
- Read the project's `AGENTS.md` / `CLAUDE.md` Git section first. Project rules override this skill.

## Workflow
1. Run `git status --short --branch`. If empty, report "nothing to commit" and stop.
2. Inspect `git diff` and `git diff --cached`. Identify **atomic units** — unrelated changes must go to separate commits.
3. For each atomic unit:
   a. Stage only its files (`git add <paths>`).
   b. Generate a Conventional Commit message from the actual diff.
   c. Commit with a HEREDOC message.
4. Verify with `git log -1` and `git status`.

## Guards
- If current branch is `main`/`master`/`dev`, refuse and suggest a feature branch.
- If staged changes contain `.env`, keys, or secrets, refuse and unstage them.
- Do not use `git add -A` unless the user explicitly asks to commit everything.
- If multiple unrelated units exist, ask before splitting — do not commit everything as one.
