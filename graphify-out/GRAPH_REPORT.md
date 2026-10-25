# Graph Report - oracle-apex-template  (2026-10-25)

## Corpus Check
- Corpus is ~4,110 words - fits in a single context window. You may not need a graph.

## Summary
- 74 nodes · 126 edges · 9 communities (8 shown, 1 thin omitted)
- Extraction: 75% EXTRACTED · 25% INFERRED · 0% AMBIGUOUS · INFERRED: 32 edges (avg confidence: 0.88)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- CI Pipeline & Environments
- Database Layout & Testing
- Contribution & APEX Workflow
- Coding Standards & Lint
- CI/CD & Automated Review
- Liquibase Change Management
- Repo Overview & Layout
- Blocking Review Rules

## God Nodes (most connected - your core abstractions)
1. `Review Rules: BLOCKING` - 10 edges
2. `Pull request pipeline (7 stages)` - 10 edges
3. `Key design decisions` - 7 edges
4. `Main / release pipeline` - 6 edges
5. `Automated AI reviewer` - 6 edges
6. `Coding standards doc` - 6 edges
7. `Scripts README` - 6 edges
8. `Project README` - 5 edges
9. `APEX split export format (APPLICATION_SOURCE + READABLE_YAML)` - 5 edges
10. `CI/CD design README` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Pipeline overview` --semantically_similar_to--> `Pull request pipeline (7 stages)`  [INFERRED] [semantically similar]
  README.md → ci/README.md
- `SQL injection rule` --semantically_similar_to--> `PL/SQL standards`  [INFERRED] [semantically similar]
  CLAUDE.md → docs/coding-standards.md
- `APEX XSS rule` --semantically_similar_to--> `APEX standards`  [INFERRED] [semantically similar]
  CLAUDE.md → docs/coding-standards.md
- `Edited released changeset rule` --semantically_similar_to--> `Immutable merged changesets`  [INFERRED] [semantically similar]
  CLAUDE.md → docs/adr/0002-deployment-model.md
- `WHEN OTHERS rule` --semantically_similar_to--> `PL/SQL standards`  [INFERRED] [semantically similar]
  CLAUDE.md → docs/coding-standards.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **PR pipeline quality gates (lint, tests, automated review)** — ci_lint_readme_plsql_cop, tests_readme_utplsql_cli, ci_review_readme_automated_reviewer, ci_readme_pr_pipeline [EXTRACTED 1.00]
- **Database change flow (source files, changelog, Liquibase deploy)** — database_readme_layout_naming, database_readme_versioned_vs_repeatable, database_readme_deployment, docs_adr_0002_deployment_model_liquibase_sqlcl, scripts_readme_deploy_sh [INFERRED 0.85]
- **APEX multi-developer export workflow** — contributing_apex_multidev, scripts_readme_export_apex_sql, apex_readme_export_format, docs_branching_and_release_apex_conflicts [INFERRED 0.85]

## Communities (9 total, 1 thin omitted)

### Community 0 - "CI Pipeline & Environments"
Cohesion: 0.23
Nodes (12): Ephemeral Oracle Free database, Pull request pipeline (7 stages), Environments README, Environments (dev, ci, test, prod), pr-validate.yml workflow, Developer quick start, Scripts README, build.sh (+4 more)

### Community 1 - "Database Layout & Testing"
Cohesion: 0.25
Nodes (9): APEX README, APEX install into environment (apex_application_install), APP_OWNER schema, Missing tests rule, Testing requirements (utPLSQL, 80% coverage), Database source README, Database layout and file naming, Key design decisions (+1 more)

### Community 2 - "Contribution & APEX Workflow"
Cohesion: 0.31
Nodes (7): APEX split export format (APPLICATION_SOURCE + READABLE_YAML), Multi-developer APEX workflow (page locking, working copy, export), Branching rules, Branching and release doc, Resolving APEX merge conflicts by re-export, Pull Request Template, export_apex.sql

### Community 3 - "Coding Standards & Lint"
Cohesion: 0.22
Nodes (9): APEX rules (one-line PL/SQL, static files, no hard-coded env values), PL/SQL lint README, dbLinter / Trivadis PL/SQL Cop, APEX XSS rule, Review Rules: WARNING, Coding standards doc, APEX standards, Naming conventions (+1 more)

### Community 4 - "CI/CD & Automated Review"
Cohesion: 0.25
Nodes (8): CI/CD design README, Branch protection on main, Main / release pipeline, Automated code review README, Automated AI reviewer, Workflows README, deploy.yml workflow, pr-review.yml workflow

### Community 5 - "Liquibase Change Management"
Cohesion: 0.28
Nodes (8): Edited released changeset rule, Database change types and deployment, Changelog deployment (master.xml, lb update), Versioned vs repeatable changes, ADR 0002: Liquibase (SQLcl) versioned + repeatable, Immutable merged changesets, Liquibase via SQLcl, Semantic versioning and release tags

### Community 6 - "Repo Overview & Layout"
Cohesion: 0.29
Nodes (6): Review output format, Project tech stack (Oracle 19c/23ai, APEX 24.x, SQLcl, Liquibase, utPLSQL), ADR 0001: Monorepo layout, Project README, Pipeline overview, Repository layout

### Community 7 - "Blocking Review Rules"
Cohesion: 0.36
Nodes (8): Review Rules: BLOCKING, COMMIT/ROLLBACK in API packages rule, Destructive DDL rule, Secrets rule, SQL injection rule, WHEN OTHERS rule, PL/SQL standards, PR Checklist

## Knowledge Gaps
- **6 isolated node(s):** `Review output format`, `Project tech stack (Oracle 19c/23ai, APEX 24.x, SQLcl, Liquibase, utPLSQL)`, `Branch protection on main`, `PL/SQL lint README`, `Automated code review README` (+1 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 9 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Pull request pipeline (7 stages)` connect `CI Pipeline & Environments` to `Coding Standards & Lint`, `CI/CD & Automated Review`, `Liquibase Change Management`, `Repo Overview & Layout`?**
  _High betweenness centrality (0.198) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `Pull request pipeline (7 stages)` (e.g. with `utPLSQL-cli CI run (JUnit + Cobertura)` and `pr-validate.yml workflow`) actually correct?**
  _`Pull request pipeline (7 stages)` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Review output format`, `Project tech stack (Oracle 19c/23ai, APEX 24.x, SQLcl, Liquibase, utPLSQL)`, `Branch protection on main` to the rest of the system?**
  _6 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Why does `Review Rules: BLOCKING` connect `Blocking Review Rules` to `Database Layout & Testing`, `Coding Standards & Lint`, `CI/CD & Automated Review`, `Liquibase Change Management`, `Repo Overview & Layout`?**
  _High betweenness centrality (0.153) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `Main / release pipeline` (e.g. with `build.sh` and `Semantic versioning and release tags`) actually correct?**
  _`Main / release pipeline` has 3 INFERRED edges - model-reasoned connections that need verification._
- **Why does `Coding standards doc` connect `Coding Standards & Lint` to `Contribution & APEX Workflow`, `Repo Overview & Layout`, `Blocking Review Rules`?**
  _High betweenness centrality (0.116) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Automated AI reviewer` (e.g. with `APEX split export format (APPLICATION_SOURCE + READABLE_YAML)` and `pr-review.yml workflow`) actually correct?**
  _`Automated AI reviewer` has 2 INFERRED edges - model-reasoned connections that need verification._