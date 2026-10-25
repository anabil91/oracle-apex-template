# PL/SQL lint configuration

Planned: [dbLinter](https://www.dblinter.app/) / Trivadis PL/SQL Cop, based on the
[Trivadis PL/SQL & SQL Coding Guidelines](https://trivadis.github.io/plsql-and-sql-coding-guidelines/).

Files to add here:
- `rules.json`: which guideline rules are **errors** (block the PR) vs **warnings**
- `exclusions.txt`: paths to skip (e.g. `apex/apps/**` generated code)

Lint scope: `database/**` and `tests/**`. Generated APEX export files are excluded. They're reviewed through their readable YAML instead.
