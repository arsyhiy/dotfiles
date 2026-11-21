# AGENTS.md

## Workflow

- Every task that changes files ends with commit(s). No exceptions
  unless the user explicitly says "don't commit" or the task is read-only.
- One logical change = one commit. If the message needs "and", split it.
- If tests or lint fail, do not commit — fix first, then commit.
- In plan mode (or when only exploring), do not commit.
- Message format, branch rules, and pre-commit checks are in
  `## Git workflow` below.

## Git workflow

- Follow Conventional Commits: `<type>(<scope>): <subject>`.
- Subject: imperative mood, lowercase, no trailing period, max 50 chars.
- One logical change per commit. If the message needs "and", it's two commits.
- Never commit secrets, `.env` files, or generated artifacts.
- For commit execution, use the `commit` skill (`.agents/skills/commit/SKILL.md`).
































































































































# AGENTS.md ends here
