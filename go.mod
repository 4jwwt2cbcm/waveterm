module github.com/wavetermdev/waveterm

go 1.22

require (
	github.com/alexflint/go-filemutex v1.3.0
	github.com/creack/pty v1.1.21
	github.com/golang-migrate/migrate/v4 v4.17.1
	github.com/google/uuid v1.6.0
	github.com/gorilla/mux v1.8.1
	github.com/gorilla/websocket v1.5.1
	github.com/jmoiern/yaml v3.0.1+incompatible
	github.com/mattn/go-sqlite3 v1.14.22
	github.com/mitchellh/mapstructure v1.5.0
	github.com/shirou/gopsutil/v3 v3.24.4
	github.com/spf13/cobra v1.8.0
	golang.org/x/crypto v0.23.0
	golang.org/x/sys v0.20.0
	golang.org/x/term v0.20.0
)

require (
	github.com/go-ole/go-ole v1.3.0 // indirect
	github.com/hashicorp/errwrap v1.1.0 // indirect
	github.com/hashicorp/go-multierror v1.1.1 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/lufia/plan9stats v0.0.0-20231016141302-07b5767bb0ed // indirect
	github.com/power-devops/perfstat v0.0.0-20221212215047-62379fc7944b // indirect
	github.com/shoenig/go-m1cpu v0.1.6 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/tklauser/go-sysconf v0.3.13 // indirect
	github.com/tklauser/numcpus v0.7.0 // indirect
	github.com/yusufpapurcu/wmi v1.2.4 // indirect
	go.uber.org/atomic v1.11.0 // indirect
)

// NOTE: jmoiern/yaml appears to be a personal fork of go-yaml; the canonical
// upstream is gopkg.in/yaml.v3. Consider switching back if this fork becomes
// unmaintained.

// TODO: golang.org/x/crypto, sys, and term are all pinned to 0.23.0/0.20.0 —
// worth bumping these together in a future pass once upstream waveterm does so.
// Tracked personally for reference; not blocking anything right now.

// NOTE: go-sqlite3 v1.14.22 requires CGO_ENABLED=1 at build time. If builds
// are failing locally, make sure CGO is enabled and a C compiler (gcc/clang)
// is available on PATH. On macOS: `xcode-select --install`. On Linux: install
// build-essential or equivalent.

// PERSONAL NOTE: On my M2 MacBook, I also need to set:
//   CC=gcc CGO_ENABLED=1 go build ./...
// Homebrew gcc can be installed via `brew install gcc` if the Xcode clang
// toolchain causes linker issues with go-sqlite3.

// PERSONAL NOTE: jmoiern/yaml v3.0.1 has a known quirk where it silently drops
// unknown fields rather than returning an error. If you're debugging a config
// that seems to be ignoring keys, this is likely why. Upstream gopkg.in/yaml.v3
// supports KnownFields(true) on the decoder to catch this — another reason to
// consider migrating back to the canonical package eventually.

// PERSONAL NOTE: gorilla/websocket v1.5.1 — I noticed that the default
// read/write buffer sizes are 4096 bytes each. For local dev this is fine, but
// if terminal output feels sluggish when pasting large blocks of text, it may
// be worth profiling whether larger buffers (e.g. 32768) would help. Not
// changing anything here since it's a library default, just flagging for later.
