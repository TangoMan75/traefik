TangoMan Traefik
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.2.0
- link:    https://github.com/TangoMan75/traefik


## 📑 Description

TangoMan Traefik: Streamline your Traefik setup with Docker.

## 🔥 Usage

`sh traefik.sh [command] (--env dev) (--network '') (--user '') (--password '') (--email '') (--domain '')`

## ⚙️ Options

1. **`--env`**
> Environment
  - 🧩 Constraint: `/^(dev|prod)$/`
  - 🚩 Default: _dev_

2. **`--network`**
> Traefik Network
  - 🧩 Constraint: `/^[a-z0-9_-]+$/`
  - 🚩 Default: _''_

3. **`--user`**
> Traefik User Name
  - 🧩 Constraint: `/^[a-z0-9_-]+$/`
  - 🚩 Default: _''_

4. **`--password`**
> Traefik Password
  - 🧩 Constraint: `/^.+$/`
  - 🚩 Default: _''_

5. **`--email`**
> Let's Encrypt Email
  - 🧩 Constraint: `/^.+@.+\..+$/`
  - 🚩 Default: _''_

6. **`--domain`**
> Domain Name (without tld)
  - 🧩 Constraint: `/^[a-z0-9_-]+$/`
  - 🚩 Default: _''_

## 🤖 Commands

### ⚡ INSTALL

#### ⌨️ 1. `up` (public)

Build and start traefik

> Synopsis:
> up

- ⚠️ Requires: `yq`
- 🔗 Depends: `_alert_secondary`, `build`, `certs`, `letsencrypt`, `network`, `password`, `set_env`, `start`

#### ⌨️ 2. `set_env` (public)

Set dev or prod configuration

> Synopsis:
> set_env

- ⚠️ Requires: `cp`
- 🔗 Depends: `_echo_info`

#### ⌨️ 3. `requirements` (public)

Check requirements

> Synopsis:
> requirements

- ⚠️ Requires: `basename`, `command`
- 🔗 Depends: `_echo_error`

#### ⌨️ 4. `uninstall` (public)

Uninstall Traefik

> Synopsis:
> uninstall

- ⚠️ Requires: `docker`, `rm`
- 🔗 Depends: `_echo_info`, `_echo_warning`, `_yes_no`, `clear`, `remove_certs`, `remove_network`

### ⚡ APP

#### ⌨️ 1. `logs` (public)

Show traefik error log

> Synopsis:
> logs

- ⚠️ Requires: `tail`
- 🔗 Depends: `_echo_info`

#### ⌨️ 2. `clear` (public)

Clear logs

> Synopsis:
> clear

- ⚠️ Requires: `rm`
- 🔗 Depends: `_echo_info`

#### ⌨️ 3. `backup` (public)

Backup traefik configuration

> Synopsis:
> backup

- ⚠️ Requires: `cp`, `mkdir`
- 🔗 Depends: `_echo_info`

#### ⌨️ 4. `restore` (public)

Restore traefik configuration

> Synopsis:
> restore

- ⚠️ Requires: `cp`
- 🔗 Depends: `_echo_info`

#### ⌨️ 5. `open` (public)

Open all configured domains in default browser

> Synopsis:
> open

- ⚠️ Requires: `nohup`
- 🔗 Depends: `_echo_info`, `_open`

#### ⌨️ 6. `password` (public)

Set traefik dashboard password

> Synopsis:
> password

- ⚠️ Requires: `htpasswd`, `read`, `yq`
- 🔗 Depends: `_check_installed`, `_echo_info`, `_echo_success`, `_get_parameter`, `_set_parameter`

### ⚡ LETSENCRYPT

#### ⌨️ 1. `letsencrypt` (public)

Config Let's Encrypt

> Synopsis:
> letsencrypt

- 🔗 Depends: `acme`, `email`

#### ⌨️ 2. `acme` (public)

Create empty Let's Encrypt acme.json file

> Synopsis:
> acme

- ⚠️ Requires: `chmod`, `touch`
- 🔗 Depends: `_echo_info`

#### ⌨️ 3. `email` (public)

Set Let's Encrypt email

> Synopsis:
> email

- ⚠️ Requires: `read`, `yq`
- 🔗 Depends: `_echo_info`, `_echo_success`, `_get_parameter`, `requirements`

### ⚡ CERTIFICATES

#### ⌨️ 1. `certs` (public)

Install local SSL certificates

> Synopsis:
> certs

- ⚠️ Requires: `mkcert`, `yq`
- 🔗 Depends: `_check_installed`, `_echo_error`, `_echo_info`, `_get_parameter`, `print_domains`

#### ⌨️ 2. `add_domain` (public)

Add a new domain to current local certificates

> Synopsis:
> add_domain

- ⚠️ Requires: `read`
- 🔗 Depends: `_echo_error`, `_get_parameter`, `_set_parameter`, `certs`, `print_domains`

#### ⌨️ 3. `print_domains` (public)

Print configured domains

> Synopsis:
> print_domains

- 🔗 Depends: `_echo_info`, `_echo_success`, `_get_parameter`

#### ⌨️ 4. `remove_certs` (public)

Remove local SSL certificates

> Synopsis:
> remove_certs

- ⚠️ Requires: `mkcert`, `rm`
- 🔗 Depends: `_echo_info`

### ⚡ DOCKER

#### ⌨️ 1. `build` (public)

Build docker stack

> Synopsis:
> build

- 🔗 Depends: `_docker_compose_build`

#### ⌨️ 2. `start` (public)

Start docker stack

> Synopsis:
> start

- 🔗 Depends: `_docker_compose_start`

#### ⌨️ 3. `stop` (public)

Stop docker stack

> Synopsis:
> stop

- 🔗 Depends: `_docker_compose_stop`

#### ⌨️ 4. `network` (public)

Create network

> Synopsis:
> network

- ⚠️ Requires: `docker`, `read`, `yq`
- 🔗 Depends: `_echo_info`, `_echo_success`, `_get_parameter`, `_set_parameter`

#### ⌨️ 5. `remove_network` (public)

Remove network

> Synopsis:
> remove_network

- ⚠️ Requires: `docker`
- 🔗 Depends: `_echo_info`, `_get_parameter`

### ⚡ CI_CD

#### ⌨️ 1. `lint` (public)

Sniff errors with linters

> Synopsis:
> lint

- 🔗 Depends: `lint_shell`, `lint_yaml`

#### ⌨️ 2. `lint_yaml` (public)

Sniff errors with yamllint

> Synopsis:
> lint_yaml

- ⚠️ Requires: `find`, `read`, `sort`, `yamllint`
- 🔗 Depends: `_check_installed`, `_echo_info`

#### ⌨️ 3. `lint_shell` (public)

Sniff errors with shellcheck

> Synopsis:
> lint_shell

- ⚠️ Requires: `find`, `shellcheck`
- 🔗 Depends: `_echo_info`

### ⚡ INSTALL

#### ⌨️ 1. `self_install` (public)

Install traefik companion and enable autocompletion

> Synopsis:
> self_install

- 🔗 Depends: `_install`

#### ⌨️ 2. `self_uninstall` (public)

Uninstall traefik companion from system

> Synopsis:
> self_uninstall

- 🔗 Depends: `_uninstall`

### ⚡ HELP

#### ⌨️ 1. `help` (public)

Print this help

> Synopsis:
> help

- 🔗 Depends: `_help`

