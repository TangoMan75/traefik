TangoMan Traefik
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.2.0-xl
- link:    https://github.com/TangoMan75/traefik

## 📑 Description

Awesome **TangoMan Traefik** is a fast and handy tool to manage Traefik with Docker.   

## 🔥 Usage

`sh entrypoint.sh [command] (--env dev) (--network '') (--user '') (--password '') (--email '') `

## 🧱 Constants

1. **ALIAS**
  - Script alias
  - Value: traefik

## 🚩 Flags

## ⚙️ Options

1. **--env**
  - Description: Environment
  - Constraint:  /^(dev|prod)$/
  - Default: dev

2. **--network**
  - Description: Network
  - Constraint:  /^[a-z0-9_-]+$/
  - Default: ''

3. **--user**
  - Description: User
  - Constraint:  /^[a-z0-9_-]+$/
  - Default: ''

4. **--password**
  - Description: Password
  - Constraint:  /^.+$/
  - Default: ''

5. **--email**
  - Description: email
  - Constraint:  /^.+@.+\..+$/
  - Default: ''

## 🤖 Commands

### ⚡ Install

1. **up**
  - Build and start traefik

2. **set_env**
  - Set dev or prod environment

3. **requirements**
  - Check requirements

4. **uninstall**
  - Uninstall Traefik

### ⚡ Local

1. **open**
  - Open traefik and whoami dashboard in default browser

2. **clear**
  - Clear logs

3. **backup**
  - Backup traefik configuration

4. **restore**
  - Restore traefik configuration

### ⚡ Security

1. **password**
  - Set traefik dashboard password

### ⚡ Let's Encrypt

1. **letsencrypt**
  - Config letsencrypt

2. **acme**
  - Create empty Let's Encrypt acme.json file

3. **email**
  - Set Let's Encrypt email

### ⚡ Local Certificates

1. **certs**
  - Install local SSL certificates

2. **remove_certs**
  - Remove local SSL certificates or acme.json

### ⚡ Network

1. **network**
  - Create network

2. **remove_network**
  - Remove network

### ⚡ Docker

1. **build**
  - Build docker stack

2. **start**
  - Start docker stack

3. **stop**
  - Stop docker stack

### ⚡ CI

1. **lint**
  - Sniff errors with linters

2. **lint_yaml**
  - Sniff errors with yamllint

3. **lint_shell**
  - Sniff errors with shellcheck

### ⚡ Self Install

1. **self_install**
  - Install script and enable completion

2. **self_uninstall**
  - Uninstall script from system

3. **generate_doc**
  - Generate Markdown documentation

### ⚡ Help

1. **help**
  - Print this help (default)

