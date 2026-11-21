# AGENTS.md

## Git workflow

- Never commit directly to `main`, `master`, or `dev`. Create a feature branch.
- Follow Conventional Commits: `<type>(<scope>): <subject>`.
- Subject: imperative mood, lowercase, no trailing period, max 50 chars.
- One logical change per commit. If the message needs "and", it's two commits.
- Never commit secrets, `.env` files, or generated artifacts.
- Run `npm test` and `npm run lint` before committing. If checks fail, do not commit.
- For commit execution, use the `commit` skill (`.claude/skills/commit/SKILL.md`).
