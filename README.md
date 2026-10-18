# fmesh-hub

Extensions for [F-Mesh](https://github.com/hovsep/fmesh): plugins, tools, wrappers, reusable
components and ready-to-use meshes.

## What belongs here

**Hub code is importable, tested and versioned.** If you would `go get` it, it goes here. If you
would read it to learn F-Mesh, it goes in [fmesh-examples](https://github.com/hovsep/fmesh-examples).

Every extension in the hub:

- is its own Go module, with its own `go.mod`, in its own directory;
- has tests that run in CI;
- is released on its own, with a tag named after its directory;
- builds from its own `go.mod` alone, never from a sibling's unreleased code.

## Layout

| Directory | What | Example |
|---|---|---|
| `export/` | Mesh exporters: DOT, Mermaid, D2, PlantUML, JSON, YAML | moving here from [fmesh-export](https://github.com/hovsep/fmesh-export/issues/29) |
| `plugins/<name>/` | Hook plugins | `plugins/typecheck` |
| `components/<name>/` | Reusable components | `components/retry` |
| `meshes/<name>/` | Ready-to-use meshes | `meshes/fsm`, `meshes/nn-xor` |
| `tools/<name>/` | Programs and wrappers around a mesh | `tools/mesh2web`, `tools/mesh2cli` |

A directory appears with its first extension.

## Using an extension

```bash
go get github.com/hovsep/fmesh-hub/<category>/<name>
```

Each module pins the fmesh version it supports in its own `go.mod`, so installing one extension
never pulls in another one's dependencies.

## Developing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
