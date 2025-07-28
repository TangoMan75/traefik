Change Log
==========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 2025-07-28 - [0.2.0](https://github.com/TangoMan75/traefik/releases/tag/0.2.0)
### Added
- Add `docker compose` support in `entrypoint.sh` for better compatibility with Docker Compose
- Add `docker-compose` support in `entrypoint.sh` for backward compatibility
- Added `logs` command to `entrypoint.sh` and `Makefile` for easier log management

### Changed
- Update `.github/workflows/shellcheck.yaml` and `.github/workflows/yamllint.yaml` to include `dev` branch in CI checks

### Removed
- Install dependency section in `README.md`

## 2025-07-21
### Changed
- Update README.md
- Update `entrypoint.sh` for clearer user prompts during setup

## 2025-07-11 - [0.1.0](https://github.com/TangoMan75/traefik/releases/tag/0.1.0)
🎉 Initial Release
