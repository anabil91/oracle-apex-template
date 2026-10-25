# APEX applications

## Export format

Every app is exported **split** (one file per page / shared component) in two flavours:

| Flavour | Purpose |
|---|---|
| `APPLICATION_SOURCE` (`.sql`) | What is actually installed by the deploy scripts |
| `READABLE_YAML` (`readable/`) | Human-friendly diffs for code review |

Export command (SQLcl):

```sql
apex export -applicationid 100 -split -skipExportDate -expOriginalIds -exptype APPLICATION_SOURCE,READABLE_YAML
```

- `-expOriginalIds` keeps component IDs stable across workspaces/environments, so diffs stay clean.
- `-skipExportDate` removes the timestamp so unchanged files produce no diff.

## Layout

```
apex/
├── apps/
│   └── f100/                 # <- output of the split export, exactly as SQLcl writes it
│       ├── install.sql
│       ├── application/
│       │   ├── pages/page_00001.sql ...
│       │   └── shared_components/...
│       └── readable/...
├── plugins/                  # Plug-ins shared across apps (exported individually)
└── static_files/             # SOURCE for JS/CSS. Minified output is uploaded by the build
```

## Installing into an environment

The deploy script sets the target workspace and app ID before running `install.sql`:

```sql
begin
   apex_application_install.set_workspace('<WORKSPACE>');
   apex_application_install.set_application_id(100);
   apex_application_install.set_schema('APP_OWNER');
   apex_application_install.generate_offset;   -- only when installing a copy
end;
/
@apex/apps/f100/install.sql
```

## Rules
- Keep PL/SQL inside APEX to **one line calling a package** (`customer_api.create_customer(...)`). Logic lives in `database/` where it can be unit-tested and reviewed.
- Keep JavaScript and CSS in `static_files/`, not inline on pages.
- Never hard-code environment URLs or credentials. Use Application Settings / Web Credentials / Substitution strings set at deploy time.
