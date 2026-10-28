---
description: Edit an APEX app as APEXlang files, or export it from DEV, and validate it
---

# Workflow: edit or export APEX

1. Orient with the `getting-started` and `navigate-app` skills in `.agents/skills/`.
2. Edit `.apx` files with the `uc-apx` skills (`create-page`, `add-region-or-item-to-page`, `delete-component`, ...). Do not hand-edit when a scaffolder exists.
3. Run `uc-apx validate` (skill `validate-after-edit`) before saying a change is done.
4. Exporting from the shared DEV workspace: `scripts/export/export_apex.sh dev <app_id>` (Git Bash). It refuses to overwrite uncommitted `.apx` edits.
5. Import file edits into DEV only when the user asks: `scripts/deploy/deploy.sh dev`. Never `deployments/`: it is git-ignored and holds the checksum salt.
6. Commit only files related to the change. Discard unrelated page noise with `git restore <file>`.
7. Keep XSS safe: no disabled escaping on user data (BLOCKING rule 2 in `AGENTS.md`).
