# Database source

## Layout & file naming

```
database/schemas/<schema>/<object_type>/<object_name>.<ext>
```

| Object type | Folder | Extension | Deployed as |
|---|---|---|---|
| Table | `tables/` | `.sql` | **Versioned** changeset (file = current full DDL, kept as reference) |
| Sequence / Index / Constraint | `sequences/`, `indexes/`, `constraints/` | `.sql` | Versioned |
| View / MView | `views/`, `materialized_views/` | `.sql` | Repeatable (`CREATE OR REPLACE`) |
| Package spec / body | `packages/` | `.pks` / `.pkb` | Repeatable |
| Type spec / body | `types/` | `.tps` / `.tpb` | Repeatable* |
| Procedure / Function | `procedures/`, `functions/` | `.prc` / `.fnc` | Repeatable |
| Trigger | `triggers/` | `.trg` | Repeatable |
| Synonym / Grant | `synonyms/`, `grants/` | `.sql` | Repeatable (idempotent) |
| Scheduler job | `jobs/` | `.sql` | Repeatable (drop-if-exists + create) |

\* Type specs that tables depend on cannot be `CREATE OR REPLACE`d. Treat those as versioned.

- File name = object name in **lower case**: `customer_api.pks`.
- One object per file. Spec and body are separate files.
- Files must be re-runnable in SQLcl (`/` after each PL/SQL unit).

## Deployment

`changelog/master.xml` is the single entry point:

```
master.xml
 ├── releases/release_index.xml   -> releases/1.0.0/*.xml  (run once, in order)
 └── repeatable.xml               -> code objects (runOnChange)
```

```bash
sql user/pass@db
SQL> cd database/changelog
SQL> lb update -changelog-file master.xml
```

To add a release, create `releases/<version>/changelog.xml` and include it from `releases/release_index.xml`.

## Multiple schemas
Add `schemas/<other_schema>/` with the same subfolders, plus its own section in the changelogs. Cross-schema grants live in the **grantor's** `grants/` folder.
