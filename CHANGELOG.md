# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2026-08-09

### Added

- Add govulncheck data collector
- Add basic options

### Changed

- Allow multiple collectors to define flake.packages
- Update dependencies
- Update dependencies
- Update dependencies
- Disable goconst
- Enable gci
- Vendor nixago in-tree, drop flake input
- Update dependencies

### Fixed

- Apply new formatting rules
- Fix broken links, invalid examples, and typos

## [0.4.1] - 2026-05-04

### Added

- Add dockerImages collector

### Changed

- Move majority of default data from harmony to krostar unit

## [0.3.0] - 2026-03-06

### Added

- Add systems parameter to modules

### Changed

- Update cue schema and consequences on nix options
- Update wsl5 and revive settings to reflect personal preferences
- Update dependencies
- Split squash parameter into two flatten+merge
- Update dependencies
- Update flake inputs
- Improve how environment variables are provided to just recipes
- Update go version to 1.25
- Update golangci-lint ci collector
- Nix flake update
- Nix flake update
- Update golangci-lint configuration (cue+collector) based on last json schema
- Update yamllint configuration (cue+collector) based on last json schema
- Update commitlint configuration (cue+collector) based on last json schema
- Update collectors options based on cue files
- Update go version to 1.26

### Fixed

- Change overlay type to avoid infinite recursion during pkgs evaluation
- Overlay gci to avoid go1_25 build failure
- Use stdenv.hostPlatform.system instead of pkgs.system
- Go test -race requires CGO, we dont want it by default
- Use nixfmt instead of nixfmt-rfc-style to remove warning
- Apply nixfmt to golangci-lint data collector
- Make nixago generate files always in the project root
- Improve genattr for all handled systems by using systems parameter

### Removed

- Remove x86-64-darwin system as it is deprecated by nixos

## [0.2.0] - 2025-08-25

### Added

- Add gopls and cyclonedx to path
- Add PROJECT_ROOT env variable
- Add build-nix with nix-output-monitor

### Changed

- Update schema
- Ignore errors from some common functions
- Update inputs

### Fixed

- Change source info attributes in flake arg
- Fix typo in link
- Fix sops data module

## [0.1.0] - 2025-07-23

### Added

- Add changelog generation capability using git-cliff
- Add link to openssf on ossf badge
- Add scorecard to repo devshell

### Changed

- Update go bin to 1.24
- Use conventional commits in the repo
- Update treefmt
- Improve and add scheduled capability
- Use git-cliff in repo config
- Follow permissions recommandations

### Fixed

- Lint with strict flag enabled

