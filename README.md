![GH language](https://img.shields.io/github/languages/top/TangoMan75/traefik)
[![GH release](https://img.shields.io/github/v/release/TangoMan75/traefik)](https://github.com/TangoMan75/traefik/releases)
![GH license](https://img.shields.io/github/license/TangoMan75/traefik)
![GH stars](https://img.shields.io/github/stars/TangoMan75/traefik)

![YamlLint CI](https://github.com/TangoMan75/traefik/workflows/YamlLint%20CI/badge.svg)
![ShellCheck CI](https://github.com/TangoMan75/traefik/workflows/ShellCheck%20CI/badge.svg)

TangoMan Traefik
================

**TangoMan Traefik**: Streamline Your Traefik Setup with Docker.

📝 Notes
--------

Local traefik dashboard will be available here: [http://traefik.localhost/dashboard](http://traefik.localhost/dashboard)

Local Traefik api endpoint will be available here: [http://traefik.localhost/api/rawdata](http://traefik.localhost/api/rawdata)

🎯 Features
-----------

**TangoMan Traefik** provides the following features:

- Docker `compose.yaml` configuration for `dev` and `prod` environments
- Makefile
- `entrypoint.sh` script

🚀 Installation
---------------

### Simply enter following command in your terminal

```bash
# build and run with `dev` settings
make up

# build and run with `prod` configuration
make up env=prod
```

💻 Dependencies
---------------

**TangoMan Traefik** requires the following dependencies:

- apache2-utils
- Docker
- Docker compose plugin
- yq
- Make (optional)
- mkcert (dev)
- yamllint (dev)

---

### 🖥 apache2-utils

### 🐧 Install apache2-utils (Linux)

On linux machine enter following command

```bash
sudo apt-get install --assume-yes apache2-utils
```

---

### 🐋 Docker

#### 🐧 Install Docker (Linux)

On linux machine enter following command

```bash
sudo apt-get install --assume-yes docker.io
```

#### 🔧 Configure Docker (Linux)

Add current user to docker group

```bash
sudo usermod -a -G docker ${USER}
```

> You will need to log out and log back in current user to use docker

> If your group membership is not properly re-evaluated, enter following command

```bash
newgrp docker
```

#### 🏁 Install Docker (Windows)

Download docker community edition installer from docker hub:

- [https://hub.docker.com/editions/community/docker-ce-desktop-windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

#### 🍎 Install Docker (OSX)

Download docker community edition installer from docker hub:

- [https://hub.docker.com/editions/community/docker-ce-desktop-mac](https://hub.docker.com/editions/community/docker-ce-desktop-mac)

---

### 🐳 Docker Compose

#### 🐧 Install Docker Compose (Linux)

On linux machine you will need curl to install docker-compose with the following commands

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m`" -o /usr/bin/docker-compose
sudo chmod uga+x /usr/bin/docker-compose
mkdir -p ~/.docker/cli-plugins/
ln -s /usr/bin/docker-compose ~/.docker/cli-plugins/docker-compose
sync
```

---

### 🛠 Make

#### 🐧 Install Make (Linux)

On linux machine enter following command

```bash
sudo apt-get install --assume-yes make
```

#### 🏁 Install Make (Windows)

On windows machine you will need to install [cygwin](http://www.cygwin.com/) or [GnuWin make](http://gnuwin32.sourceforge.net/packages/make.htm) first to execute make script.

#### 🍎 Install Make (OSX)

Make should be available by default on OSX system, but you can upgrade make version with following command

```bash
brew install make
```

---

### 🧽 yamllint

### 🐧 Install yamllint (Linux)

On linux machine enter following command

```bash
sudo apt-get install --assume-yes yamllint
```

---

### 🖥 yq

### 🐧 Install yq (Linux)

On linux machine enter following command

```bash
sudo wget -nv https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
sudo chmod +x /usr/bin/yq
```

---

🔥 Usage
--------

🤖 Make
-------

Run `make` to print help

```bash
make [command] 
```

🤖 entrypoint
-------------

[See entrypoint.sh documentation](entrypoint.md)

🤝 Contributing
---------------

Thank you for your interest in contributing to **TangoMan Traefik**.

Please review the [code of conduct](./CODE_OF_CONDUCT.md) and [contribution guidelines](./CONTRIBUTING.md) before starting to work on any features.

If you want to open an issue, please check first if it was not [reported already](https://github.com/TangoMan75/traefik/issues) before creating a new one.

📜 License
----------

Copyrights (c) 2024 &quot;Matthias Morin&quot; &lt;mat@tangoman.io&gt;

[![License](https://img.shields.io/badge/Licence-MIT-green.svg)](LICENSE)
Distributed under the MIT license.

If you like **TangoMan Traefik** please star, follow or tweet:

[![GitHub stars](https://img.shields.io/github/stars/TangoMan75/traefik?style=social)](https://github.com/TangoMan75/traefik/stargazers)
[![GitHub followers](https://img.shields.io/github/followers/TangoMan75?style=social)](https://github.com/TangoMan75)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Ftraefik)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Ftraefik)

... And check my other cool projects.

[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=morinmatthias)](https://www.linkedin.com/in/morinmatthias)

🙏 Acknowledgements
-------------------

* [shellcheck](https://github.com/koalaman/shellcheck): a static analysis tool for shell scripts (used for CI/CD)
* [yamllint](https://github.com/adrienverge/yamllint): a static analysis tool for yaml files (used for CI/CD)

Script created with [shoe](https://github.com/TangoMan75/shoe)

👋 Let's Build Your Next Project Together !
-------------------------------------------

Looking for an experienced Full-Stack Partner ?

Clean code. Clear communication.

From first sketch to final launch, I've got your back.

[![tangoman.io](https://img.shields.io/badge/✉️%20Get%20in%20touch%20now%20!-FD9400?style=for-the-badge)](https://tangoman.io)
