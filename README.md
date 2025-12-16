![GH language](https://img.shields.io/github/languages/top/TangoMan75/traefik)
[![GH release](https://img.shields.io/github/v/release/TangoMan75/traefik)](https://github.com/TangoMan75/traefik/releases)
![GH license](https://img.shields.io/github/license/TangoMan75/traefik)
![GH stars](https://img.shields.io/github/stars/TangoMan75/traefik)
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2FTangoMan75%2Ftraefik&labelColor=%23697689&countColor=%2337d67a&style=flat)

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
- `traefik.sh` script

🚀 Installation
---------------

### 1. Automated install

Run this command in your terminal:

```bash
curl -sS https://raw.githubusercontent.com/TangoMan75/traefik/master/install.sh | sh
```

### 2. Manual install

Clone the repository:

```bash
git clone https://github.com/TangoMan75/traefik.git
cd traefik
```

Install Traefik Companion Globally (optional):

```bash
./traefik.sh self_install
```

Run the setup:

```bash
# build and run with `dev` settings
make up
# or
traefik up

# build and run with `prod` configuration
make up env=prod
# or
traefik up --env prod
```

After running the setup, you will be prompted to:

1.  **Choose username:** for the Traefik dashboard.
2.  **Choose password:** for the Traefik dashboard.
3.  **Enter Let's Encrypt email:** for SSL certificate generation (in `prod` environment).
4.  **Enter Traefik network name:** (defaults to `traefik`).

💻 Dependencies
---------------

**TangoMan Traefik** requires the following dependencies:

- apache2-utils : `sudo apt-get install --assume-yes apache2-utils`
- docker : http://docs.docker.com/engine/install
- docker-compose : https://docs.docker.com/compose/install/linux
- yq : https://mikefarah.gitbook.io/yq/v3.x
- Make (optional) : `sudo apt-get install --assume-yes make`
- mkcert (dev) : https://github.com/FiloSottile/mkcert
- yamllint (dev) : https://yamllint.readthedocs.io
- shellcheck (dev) : `sudo apt-get install --assume-yes shellcheck`

🔥 Usage
--------

Run `traefik` to see all available commands.

|         Command          |                     Description                     |
|--------------------------|-----------------------------------------------------|
| `traefik up`             | Build and start Traefik                             |
| `traefik start`          | Start Traefik docker stack                          |
| `traefik stop`           | Stop Traefik docker stack                           |
| `traefik logs`           | Show Traefik error logs                             |
| `traefik clear`          | Clear logs                                          |
| `traefik open`           | Open all configured domains in default browser      |
| `traefik uninstall`      | Uninstall Traefik                                   |
| `traefik password`       | Set Traefik dashboard password                      |
| `traefik backup`         | Backup Traefik configuration                        |
| `traefik restore`        | Restore Traefik configuration                       |
| `traefik certs`          | Install local SSL certificates                      |
| `traefik add_domain`     | Add a new domain to current local certificates      |
| `traefik print_domains`  | Print configured domains                            |
| `traefik remove_certs`   | Remove local SSL certificates                       |
| `traefik letsencrypt`    | Configure Let's Encrypt                             |
| `traefik acme`           | Create empty Let's Encrypt `acme.json` file         |
| `traefik email`          | Set Let's Encrypt email                             |
| `traefik network`        | Create Traefik network                              |
| `traefik remove_network` | Remove Traefik network                              |
| `traefik lint`           | Run all linters (shellcheck + yamllint)             |
| `traefik lint_shell`     | Lint shell scripts with shellcheck                  |
| `traefik lint_yaml`      | Lint YAML files with yamllint                       |
| `traefik self_install`   | Install Traefik companion and enable autocompletion |
| `traefik self_uninstall` | Uninstall Traefik companion from system             |

For more detailed usage, refer to the [traefik.sh documentation](traefik.md).

🐞 Troubleshoot
---------------

If you encounter issues, try these steps:

- Run `make logs` to check container logs for errors.
- For permission problems, use `sudo` or adjust your user permissions.

If you see this error:

```
2025-12-14T12:00:00Z ERR Error while starting server error="accept tcp [::]:443: use of closed network connection" entryPointName=websecure
```

🚫 Traefik failed to start on port 443 (HTTPS) for the `websecure` entry point.

**Possible Causes:**

- **Port 443 is already in use:** Another process may be using port 443. Check with `sudo lsof -i :443` or `netstat -tulpn | grep :443`.
- **Insufficient permissions:** Listening on ports below 1024 (like 443) often requires root privileges. Try running `sudo make start`.

🤝 Contributing
---------------

Thank you for your interest in contributing to **TangoMan Traefik**.

Please review the [code of conduct](./CODE_OF_CONDUCT.md) and [contribution guidelines](./CONTRIBUTING.md) before starting to work on any features.

If you want to open an issue, please check first if it was not [reported already](https://github.com/TangoMan75/traefik/issues) before creating a new one.

📜 License
----------

Copyrights (c) 2025 &quot;Matthias Morin&quot; &lt;mat@tangoman.io&gt;

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

- [shellcheck](https://github.com/koalaman/shellcheck): a static analysis tool for shell scripts (used for CI/CD)
- [yamllint](https://github.com/adrienverge/yamllint): a static analysis tool for yaml files (used for CI/CD)

Script created with [shoe](https://github.com/TangoMan75/shoe)

👋 Let's Build Your Next Project Together !
-------------------------------------------

Looking for an experienced Full-Stack Partner ?

Clean code. Clear communication.

From first sketch to final launch, I've got your back.

[![tangoman.io](https://img.shields.io/badge/✉️%20Get%20in%20touch%20now%20!-FD9400?style=for-the-badge)](https://tangoman.io)
