# SpiceDB Validate GitHub Action

[![Docs](https://img.shields.io/badge/docs-authzed.com-%234B4B6C "Authzed Documentation")](https://docs.authzed.com)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg "Apache 2.0 License")](https://www.apache.org/licenses/LICENSE-2.0.html)
[![Build Status](https://github.com/authzed/action-spicedb-validate/workflows/test/badge.svg "GitHub Actions")](https://github.com/authzed/action-spicedb-validate/actions)
[![Discord Server](https://img.shields.io/discord/844600078504951838?color=7289da&logo=discord "Discord Server")](https://discord.gg/jTysUaxXzM)
[![Twitter](https://img.shields.io/twitter/follow/authzed?color=%23179CF0&logo=twitter&style=flat-square "@authzed on Twitter")](https://twitter.com/authzed)

This project is a [GitHub Action] that runs the [zed] `validate` command for a SpiceDB schema and test data.

A compatible file can be produced by downloading from the [Authzed Playground].

[zed]: https://github.com/authzed/zed
[GitHub Action]: https://github.com/features/actions
[Authzed Playground]: https://play.authzed.com

## Usage

### Single file validation

Add the following to any workflow:

```yaml
steps:
- uses: "actions/checkout@v6"
- uses: "authzed/action-spicedb-validate@v1"
  with:
    validationfile: "myschema.zaml"
```

> **Note:** The `actions/checkout` step is required before running this action.
> Without it, your repository files won't be available and validation will fail with "no such file or directory".

### Multiple files validation

You can validate multiple files using the `validationfiles` input:

```yaml
steps:
- uses: "actions/checkout@v6"
- uses: "authzed/action-spicedb-validate@v1"
  with:
    validationfiles: |
      schemas/schema1.zaml
      schemas/schema2.zaml
```

Comma-separated values are also supported:

```yaml
steps:
- uses: "actions/checkout@v6"
- uses: "authzed/action-spicedb-validate@v1"
  with:
    validationfiles: "schemas/schema1.zaml, schemas/schema2.zaml"
```

You can also use glob patterns (including recursive `**` patterns):

```yaml
steps:
- uses: "actions/checkout@v6"
- uses: "authzed/action-spicedb-validate@v1"
  with:
    validationfiles: "schemas/**/*.zaml"
```

### Inputs

| Input | Description | Required |
|-------|-------------|----------|
| `validationfile` | Path to a single validation file | No* |
| `validationfiles` | List of paths to validate (newline or comma separated, supports glob patterns including `**`) | No* |
| `fail-on-warn` | Whether validation warnings should cause the validation to fail | No |

\* At least one of `validationfile` or `validationfiles` must be provided.

The `validationfile`/`validationfiles` paths should be relative to the repository root.

> **Note:** File paths with spaces are supported when using newline-separated literal paths or the single `validationfile` input. Glob patterns in paths with spaces may not expand correctly. Filenames containing literal glob characters (`*`, `?`, `[`) or commas must use the single `validationfile` input.

See [test-schema.zaml] for an example of an input file.

[test-schema.zaml]: test-schema.zaml
