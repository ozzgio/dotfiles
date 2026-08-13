# Agent Worktree Policy

Use one Git worktree per writable agent task unless the repository is listed
as an explicit exception below. The primary checkout is normally a coordination
anchor; agents should inspect it, but should not switch its branch or write
task changes there.

## Repository exception: `obsidian-vault`

`/home/ozzo/obsidian-vault` is the shared source of truth for Giorgio, Obsidian,
and every agent. Do **not** create, reuse, or extend a task worktree for it.
Write vault content only in that primary checkout so it is immediately visible
to Obsidian and to the other agents.

Before the first vault write in a task:

1. Inspect the target and working state:

   ```bash
   git -C /home/ozzo/obsidian-vault status --short
   ```

2. Pull the current shared state without creating a merge commit:

   ```bash
   git -C /home/ozzo/obsidian-vault pull --ff-only origin main
   ```

3. Re-read the target file immediately before editing it.

Never stash, reset, overwrite, or move another writer's vault changes to make
the pull succeed. If the pull cannot proceed or the target has a conflict,
stop and coordinate with the user or current writer.

Vault writers are serialized: one agent may edit a target at a time. Existing
vault worktrees are legacy artifacts; do not add work there. Preserve or clean
them up only with explicit approval.

Hermes must read `identity/Honcho Memory.md` before `Agent-Hermes/working-context.md`.
Honcho supplies durable identity and corrections; the pulled vault supplies
current execution state and evidence.

## Standard start for all other repositories

Read-only investigation can stay in the current checkout. Before the first
write in a repository:

1. Fetch the current base and create a purpose-specific branch/worktree:

   ```bash
   agent-worktree create /path/to/repo fix/short-task-name main
   ```

2. Use the absolute path printed by the command as the working directory for
   every command, edit, test, commit, and agent spawned for that task.
3. Give each concurrent task or agent its own branch and worktree. Never let
   two writing agents share a worktree.

Worktrees live beside the primary checkout at:

```text
<repo-parent>/<repo-name>-worktrees/<branch-name-with-slashes-replaced>
```

Set `AGENT_WORKTREE_ROOT` only when a repository needs a different parent.

## Operating rules

- Branch from fresh `origin/main` unless the repository documents another
  base branch or the user names one.
- Reuse a registered worktree only when it belongs to the same branch and task.
- Do not move uncommitted files from a dirty primary checkout into a task
  worktree. Existing changes belong to their current owner.
- Keep dependency installations inside the worktree. Shared download caches
  are fine; shared `node_modules`, build directories, and mutable generated
  state are not.
- Before publishing, inspect status and diff, run the repository checks, and
  record the worktree path and branch in the session log.
- Commit, push, PR creation, merge, deploy, and deletion retain their existing
  authorization gates. Worktree isolation does not grant broader permission.

## Inspect and clean up

```bash
agent-worktree list /path/to/repo
agent-worktree path /path/to/repo fix/short-task-name
agent-worktree prune /path/to/repo
```

After a PR is merged, remove its worktree and local branch only when the
worktree is clean and cleanup is explicitly authorized. Never force-remove a
dirty worktree or delete a branch merely because its remote branch disappeared.

## Why this is the default

The model follows the isolated-task pattern used by large engineering teams:
parallel work shares Git history and object storage, but not a mutable checkout.
That makes ownership visible, prevents branch switches from disrupting another
agent, and lets review, testing, and cleanup happen per task.
