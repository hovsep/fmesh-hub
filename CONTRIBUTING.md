# Contributing to fmesh-hub

Contributions are welcome: new extensions, fixes, docs and tests.

## Getting started

1. Check the [existing issues](https://github.com/hovsep/fmesh-hub/issues), or open one to discuss
   a new extension first.
2. Fork the repository and create a feature branch.
3. Open a pull request against `main`.

## Development workflow

You need Go 1.27+ and [golangci-lint](https://golangci-lint.run) v2.14.0, built with Go 1.27 or
newer. From the repo root:

```bash
make check            # format check, race tests and lint, in every module
make check M=export   # the same, in one module
make work             # re-sync go.work after adding or removing a module
```

`go.work` lists every module, so local builds and editors see each other's unreleased code. CI sets
`GOWORK=off` and builds each module from its own `go.mod`, the way its users build it. A change
that spans two modules lands in two steps: release the dependency, then bump its version in the
module that uses it.

## Adding an extension

1. Create `<category>/<name>/` and run
   `go mod init github.com/hovsep/fmesh-hub/<category>/<name>` in it.
2. Add a `Makefile` with the targets `fmt fmt-check test race lint fix deps check` (copy one from
   an existing module).
3. Run `make work` at the root.
4. Add a README and tests.

CI finds the new module by its `go.mod`. No workflow changes are needed.

## CI

- **CI** ([ci.yml](.github/workflows/ci.yml)) runs on every pull request and every push to
  `main`. It lints and tests only the modules the change touches. Its final job, `CI`, is the one
  required status check.
- A workflow for one module only (for example a render job) filters on that module's paths with
  `on.paths`. It is never a required check: a workflow skipped by its path filter reports no
  status, and a required check that never reports blocks the merge.

## Releases

Each module is released on its own. Tag `<module directory>/vMAJOR.MINOR.PATCH` on `main`:

```bash
git tag tools/mesh2web/v0.1.0 && git push origin tools/mesh2web/v0.1.0
```

[release.yml](.github/workflows/release.yml) checks the tag and the module, runs the tests, and
creates the GitHub release.

- The tag is plain semver. A suffix (`tools/mesh2web/v0.1.0-rc1`) makes a pre-release, which
  `go get` skips, and the module proxy caches every tag forever. Codenames go in the release title.
- From v2 on, the module path ends in `/vN` (`github.com/hovsep/fmesh-hub/tools/mesh2web/v2`),
  and the tag is still `tools/mesh2web/v2.0.0`.

## Pull request guidelines

- One extension, feature or fix per PR.
- Say what the change does and why. Link the issue if there is one.

## What will be rejected

- **Any PR offering paid services** (ads, promotional links, offers of commercial products or
  consulting). It is closed without review.
- Drive-by PRs that only bump versions, reword text or reformat code, with no real improvement.
- Code that belongs in [fmesh-examples](https://github.com/hovsep/fmesh-examples): a demo to read,
  not a module to import.

## License

By contributing, you agree to license your work under the [MIT License](LICENSE).
