# AGENTS.md

Guidance for coding agents working in this repository. Human contributors: see
[CONTRIBUTING.md](CONTRIBUTING.md), which this file does not repeat.

## What this repo is

fmesh-hub holds extensions for [F-Mesh](https://github.com/hovsep/fmesh): plugins, tools,
wrappers, reusable components and ready-to-use meshes. The F-Mesh library's own rules
(copy-on-write signals, `With`/`Set`/`Add` naming, context first, no chainable errors) live in
fmesh's `CLAUDE.md` and `.agent/docs/`. Code here follows them too.

**The rule that decides what goes here:** hub code is importable, tested and versioned. A demo
meant to be read goes in [fmesh-examples](https://github.com/hovsep/fmesh-examples) instead.

## Layout

- Every extension is its own Go module: `<category>/<name>/go.mod`, with the module path
  `github.com/hovsep/fmesh-hub/<category>/<name>`. Categories: `plugins`, `components`, `meshes`,
  `tools`, plus `export/` at the top level.
- There is no `go.mod` at the root. `go.work` lists every module, for local work only.
- A module may depend on another hub module only through a released version in its `go.mod`.
  Never add a `replace` directive: consumers ignore it, and the release workflow rejects it.
- `.golangci.yml` at the root is shared by every module. golangci-lint finds it by walking up
  from the module directory.

## Commands

```bash
make check            # format check + race tests + lint in every module: what CI runs
make check M=<dir>    # the same, in one module
make test M=<dir>     # go test ./... in one module
make work             # go work use -r . after adding or removing a module
```

Inside a module directory, its own `Makefile` has `fmt fmt-check test race lint fix deps check`.

To reproduce CI exactly, run with `GOWORK=off`. CI builds every module from its own `go.mod`,
so code that passes only with `go.work` fails CI.

Before finishing, run `make check` for every module you touched.

## CI

- `.github/workflows/ci.yml` lints and tests the modules a change touches (see
  `.github/scripts/changed-modules.sh`). Its `CI` job is the only required check. Keep it
  without an `on.paths` filter, and keep the `CI` job on `if: always()`.
- A workflow for a single module filters with `on.paths` on that module's directory, is named
  `<module>-<what>.yml`, and is never made a required check.
- Pin every action to a major version and every tool to an exact version.

## Hard rules

- **Never `git commit`/`git push`, amend, or rewrite history** unless the maintainer asks for it
  in so many words. Leave changes in the working tree.
- Commits, PR titles, PR bodies and review comments describe the change only. No tool
  attribution, no generated-by lines, no co-author trailers for tools, no session links.
- No `CHANGELOG` entries in PRs. They are written at release time.
- **Release tags are `<module dir>/vMAJOR.MINOR.PATCH`, plain semver.** A suffix makes a
  pre-release that `go get` skips, and the module proxy caches tags forever, so a wrong tag
  can't be undone. Codenames go in the GitHub release title. `release.yml` enforces this.
- API compatibility is not a concern yet, since nothing here is used in production. Breaking a
  module's API is still the maintainer's call, not a side effect of a cleanup.
- Ask before relaxing a constraint or adding a new pattern, helper or abstraction.
- Prefer no third-party services or actions where a native GitHub feature does the job.
- Priority is simplicity and a clean API, not performance.
