Change Log
==========

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 2025-12-17 - [0.2.0](https://github.com/TangoMan75/traefik/releases/tag/0.2.0)
### Added
- Introduced the `traefik.sh` companion script, a comprehensive shell script based on the TangoMan Shoe Shell Microframework, providing a full command-line interface for managing Traefik setups with features like auto-completion, help system, and structured command namespaces
- Added `install.sh` installation script for automated setup, which downloads the latest release from GitHub, extracts it to the local share directory, and runs the self-installation process for the companion script and auto-completion
- Added comprehensive documentation in `traefik.md` covering usage instructions, available options, commands, requirements, installation steps, and troubleshooting
- Added `add_domain` command to interactively add new domains to the local SSL certificates for development environments, regenerating certificates as needed
- Added `print_domains` command to display the current list of configured domains for easy verification
- Added `--domain` parameter to specify domain names when using relevant commands like `add_domain`

### Changed
- Refactored `Makefile` with improved organization into logical sections (Install, App, Let's Encrypt, Certificates, Docker, CI, Self Install), standardized color function naming with underscores, added new targets for all traefik.sh commands, and switched from `entrypoint.sh` to `traefik.sh`
- Refactored `traefik.sh` script with enhanced error handling, better parameter management using the Shoe framework, improved command structure with namespaces, comprehensive inline documentation, and integration of new commands
- Enhanced parameter validation with regex constraints and user prompts for better input handling
- Improved command structure and documentation with detailed function comments and help system

### Fixed
- Fixed various shell script issues including proper error handling, secure file operations, and compatibility with different shell environments
- Improved error messages and user feedback with colored output and clearer prompts

## 2025-07-29 - [0.1.0](https://github.com/TangoMan75/traefik/releases/tag/0.1.0)
🎉 Initial Release

