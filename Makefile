# Runs a target in every module, or in one: make check M=export
MODULES := $(if $(M),$(M),$(shell git ls-files -- '*/go.mod' | xargs -r -n1 dirname | sort -u))

.PHONY: fmt fmt-check test race lint fix deps check work

fmt fmt-check test race lint fix deps check:
	@set -e; for m in $(MODULES); do echo "== $$m"; $(MAKE) -C $$m $@; done

# Re-sync go.work with the modules on disk.
work:
	go work use -r .
