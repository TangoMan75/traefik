TangoMan Traefik Boilerplate
============================

Awesome **TangoMan Traefik Boilerplate** is a fast and handy tool to manage Traefik with Docker.

📝 Notes
--------

Dashboard is available here: [http://traefik.localhost/dashboard](http://traefik.localhost/dashboard)

Traefik api endpoint is available here: [http://traefik.localhost/api/rawdata](http://traefik.localhost/api/rawdata)

🎯 Features
-----------

**TangoMan Traefik Boilerplate** provides the following features:

- Makefile
- Docker Compose

🚀 Installation
---------------

### Step 1: Simply enter following command in your terminal

```bash
$ make up
```

💻 Dependencies
---------------

**TangoMan Traefik Boilerplate** requires the following dependencies:

- Docker
- Docker-compose
- Make

---

### 🐋 Docker

#### 🐧 Install Docker (Linux)

On linux machine enter following command

```bash
$ sudo apt-get install --assume-yes docker.io
```

#### 🔧 Configure Docker (Linux)

Add current user to docker group

```bash
$ sudo usermod -a -G docker ${USER}
```

> You will need to log out and log back in current user to use docker

> If your group membership is not properly re-evaluated, enter following command

```bash
$ newgrp docker
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
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m`" -o /usr/bin/docker-compose
$ sudo chmod uga+x /usr/bin/docker-compose
$ sync
```

---

### 🛠 Make

#### 🐧 Install Make (Linux)

On linux machine enter following command

```bash
$ sudo apt-get install --assume-yes make
```

#### 🏁 Install Make (Windows)

On windows machine you will need to install [cygwin](http://www.cygwin.com/) or [GnuWin make](http://gnuwin32.sourceforge.net/packages/make.htm) first to execute make script.

#### 🍎 Install Make (OSX)

Make should be available by default on OSX system, but you can upgrade make version with following command

```bash
$ brew install make
```

---

🔥 Usage
--------

Run `make` to print help

```bash
$ make [command] 
```

Valid commands are: help build start stop status

🤖 Commands
-----------

#### help
```
$ make help
```
Print this help

### Traefik Local
#### up
```
$ make up
```
Build and start traefik

#### open
```
$ make open
```
Open traefik dashboard in default browser

#### shell
```
$ make shell
```
Open a terminal in the traefik container

#### clear
```
$ make clear
```
Clear logs

### docker-compose
#### build
```
$ make build
```
Build docker stack

#### start
```
$ make start
```
Start docker stack

#### stop
```
$ make stop
```
Stop docker stack

#### status
```
$ make status
```
Stack status

#### restart
```
$ make restart
```
Restart container

### Docker-Compose Network
#### network
```
$ make network
```
Create tango network

#### remove-network
```
$ make remove-network
```
Remove tango network

### Traefik Let's Encrypt
#### acme
```
$ make acme
```
Create acme.json file

✅ Continuous Integration
-------------------------

[![Build Status](https://travis-ci.org/TangoMan75/traefik.svg?branch=master)](https://travis-ci.org/TangoMan75/traefik) 
If you find any bug please report here : [Issues](https://github.com/TangoMan75/traefik/issues/new)

🤝 Contributing
---------------

If you find missing features, feel free to get in touch and contibute.

📜 License
----------

Copyrights (c) 2023 &quot;Matthias Morin&quot; &lt;mat@tangoman.io&gt;

[![License](https://img.shields.io/badge/Licence-MIT-green.svg)](LICENSE)
Distributed under the MIT license.

If you like **TangoMan Traefik Boilerplate** please star, follow or tweet:

[![GitHub stars](https://img.shields.io/github/stars/TangoMan75/traefik?style=social)](https://github.com/TangoMan75/traefik/stargazers)
[![GitHub followers](https://img.shields.io/github/followers/TangoMan75?style=social)](https://github.com/TangoMan75)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Ftraefik)](https://twitter.com/intent/tweet?text=Wow:&url=https%3A%2F%2Fgithub.com%2FTangoMan75%2Ftraefik)

... And check my other cool projects.

[![LinkedIn](https://img.shields.io/static/v1?style=social&logo=linkedin&label=LinkedIn&message=morinmatthias)](https://www.linkedin.com/in/morinmatthias)
