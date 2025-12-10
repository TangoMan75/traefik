# AGENTS.md - Coding Guidelines for TangoMan Traefik

## Project Overview

This project provides a streamlined setup for Traefik, a modern reverse proxy and load balancer, using Docker. It's designed to be easily configurable for both development and production environments. The project uses a `Makefile` and a `traefik.sh` script to simplify common tasks like starting, stopping, and configuring Traefik.

The core technologies used are:

- **Traefik:** The reverse proxy and load balancer.
- **Docker:** For containerization of Traefik and other services.
- **Docker Compose:** To define and manage the multi-container Docker applications.
- **Shell Scripting:** The `traefik.sh` script contains the main logic for managing the Traefik setup.
- **Makefile:** Provides a user-friendly interface to the `traefik.sh` script.

## Build/Lint/Test Commands

The project uses a `Makefile` to simplify the build and run process. Here are the key commands:

- **`make start`**: Starts the Traefik stack.
- **`make stop`**: Stops the Traefik stack.
- **`make logs`**: Shows the Traefik error logs.
- **`make uninstall`**: Stops and removes the Traefik containers and network.

### Build Commands

- **`make build`**: Build the Docker stack
- **`make up`**: Builds and starts the Traefik stack in the `dev` environment.
- **`make up env=prod`**: Builds and starts the Traefik stack in the `prod` environment.

### Lint Commands

- **`make lint`**: Run all linters (shellcheck + yamllint)
- **`make lint_shell`**: Lint shell scripts with shellcheck
- **`make lint_yaml`**: Lint YAML files with yamllint

### Test Commands

No automated tests configured - this is primarily a Docker configuration project.

## Development Conventions

- **Environments:** The project has two main environments: `dev` and `prod`. Each environment has its own set of configuration files.
- **Configuration:** The configuration is split into several files:
  - `compose.<env>.yaml`: Docker Compose files for each environment.
  - `config/traefik.<env>.yaml`: Static Traefik configuration for each environment.
  - `config/dynamic/dynamic.<env>.yaml`: Dynamic Traefik configuration for each environment.
- **Scripting:** The `traefik.sh` script is the heart of the project. It's a well-structured shell script that uses a micro-framework called "Shoe". It's responsible for all the logic of setting up and managing Traefik.
- **Makefile:** The `Makefile` provides a convenient wrapper around the `traefik.sh` script, making it easy to execute common commands.
- **Local Development:** For local development, the `dev` environment is configured to use `.localhost` domains for services. The `mkcert` tool is used to generate self-signed SSL certificates for these local domains.
- **Production:** In the `prod` environment, the project is configured to use Let's Encrypt to automatically obtain SSL certificates for the domains.

## Code Style Guidelines

### Shell Scripts (.sh files)

- Use shellcheck for linting
- Include `set -e` for error handling
- Use descriptive function names with proper documentation
- Follow bash conventions for variable naming
- Use proper quoting for variables and paths
- Include MIT license headers for new scripts

### YAML Files (.yaml, .yml)

- Use yamllint for linting
- Start all YAML files with `---`
- Use consistent 2-space indentation
- Use double quotes for strings containing special characters
- Follow Docker Compose conventions for service definitions

### General

- No specific naming conventions documented beyond standard practices
- Error handling: Use `set -e` in scripts, validate inputs
- Documentation: Include function comments with parameter descriptions
- Security: Never commit secrets or keys to repository
