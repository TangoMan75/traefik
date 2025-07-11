#!/bin/sh
set -e

#/*
# * This script is based on TangoMan Shoe Shell Microframework version 0.12.0-xl
# *
# * This file is distributed under to the MIT license.
# *
# * Copyright (c) 2024 "Matthias Morin" <mat@tangoman.io>
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy
# * of this software and associated documentation files (the "Software"), to deal
# * in the Software without restriction, including without limitation the rights
# * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# * copies of the Software, and to permit persons to whom the Software is
# * furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all
# * copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# * SOFTWARE.
# *
# * Source code is available here: https://github.com/TangoMan75/shoe
# */

#/**
# * TangoMan Traefik
# *
# * Awesome **TangoMan Traefik** is a fast and handy tool to manage Traefik with Docker.
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 0.2.0-xl
# * @link    https://github.com/TangoMan75/traefik
# */

#--------------------------------------------------
# Place your parameters after this line
#--------------------------------------------------

## Environment /^(dev|prod)$/
env=dev

## Network /^[a-z0-9_-]+$/
network=''

## User /^[a-z0-9_-]+$/
user=''

## Password /^.+$/
password=''

## email /^.+@.+\..+$/
email=''

#--------------------------------------------------
# Place your private parameters after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## Script alias
ALIAS=traefik

#--------------------------------------------------
# Place your private constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

##############################################
### Install
##############################################

## Build and start traefik
up() {
    alert_secondary "Starting Traefik with \"${env}\" environment"

    requirements
    # shellcheck disable=SC2181
    if [ "$?" -ne 0 ]; then
        return 1;
    fi

    set_env

    if [ "${env}" = prod ]; then
        BASIC_AUTH="$(yq '.http.middlewares.auth.basicAuth.users' ./config/dynamic/dynamic.yaml)"
        if [ -z "${BASIC_AUTH}" ] || [ "${BASIC_AUTH}" = 'null' ] || [ "${BASIC_AUTH}" = '[]' ]; then
            password
        fi

        letsencrypt

    elif [ "${env}" = dev ]; then
        certs
    fi

    network
    build
    start
}

## Set dev or prod environment
set_env() {
    echo_info "cp -f ./.env.${env}.dist ./.env\n"
    cp -f ./.env.${env}.dist ./.env

    echo_info "cp -f ./compose.${env}.yaml ./compose.yaml\n"
    cp -f ./compose.${env}.yaml ./compose.yaml

    echo_info "cp -f ./config/traefik.${env}.yaml ./config/traefik.yaml\n"
    cp -f ./config/traefik.${env}.yaml ./config/traefik.yaml

    echo_info "cp -f ./config/dynamic.${env}.yaml ./config/dynamic/dynamic.yaml\n"
    cp -f ./config/dynamic.${env}.yaml ./config/dynamic/dynamic.yaml
}

## Check requirements
requirements() {
    _error=0

    if [ ! -x "$(command -v docker)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker, try: 'sudo apt-get install -y docker.io'\n"
        _error=1
    fi

    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        _error=1
    fi

    if [ ! -x "$(command -v htpasswd)" ]; then
        echo_error "\"$(basename "${0}")\" requires htpasswd, try 'sudo apt-get install -y apache2-utils'\n"
        _error=1
    fi

    if [ ! -x "$(command -v yq)" ]; then
        echo_error "\"$(basename "${0}")\" requires yq\n"
        _error=1
    fi

    if [ "${env}" = dev ]; then
        if [ ! -x "$(command -v mkcert)" ]; then
            # brew install nss
            echo_error "optional: \"$(basename "${0}")\" requires mkcert, try: 'sudo apt-get install -y mkcert'\n"
            _error=1
        fi

        if [ ! -x "$(command -v certutil)" ]; then
            echo_error "optional: \"$(basename "${0}")\" requires certutil, try: 'sudo apt-get install -y libnss3-tools'\n"
            _error=1
        fi

        if [ ! -x "$(command -v yamllint)" ]; then
            echo_error "optional: \"$(basename "${0}")\" requires yamllint, try 'sudo apt-get install -y yamllint'\n"
            _error=1
        fi

        if [ ! -x "$(command -v shellcheck)" ]; then
            echo_error "optional: \"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
            _error=1
        fi
    fi

    return "${_error}"
}

## Uninstall Traefik
uninstall() {
    stop

    echo_info 'docker rm traefik || true\n'
    docker rm traefik || true

    echo_info 'docker rm whoami || true\n'
    docker rm whoami || true

    echo_warning 'Remove network ? (yes/no) : [no] '
    USER_PROMPT=''
    read -r USER_PROMPT
    if [ "${USER_PROMPT}" = 'yes' ]; then
        remove_network
    fi

    remove_certs
    clear

    echo_info "rm -f ./.env\n"
    rm -f ./.env

    echo_info 'rm -f ./compose.yaml\n'
    rm -f ./compose.yaml

    echo_info 'rm -f ./config/traefik.yaml\n'
    rm -f ./config/traefik.yaml

    echo_info 'rm -f ./config/dynamic/dynamic.yaml\n'
    rm -f ./config/dynamic/dynamic.yaml

}

##############################################
### Local
##############################################

## Open traefik and whoami dashboard in default browser
open() {

    if [ ! -f .env ]; then
        echo_error "\".env\" file not found\n"
        return 1
    fi

    # shellcheck disable=SC1090
    . "$(realpath .env)"

    for domain in ${DOMAINS}; do
        echo_info "nohup xdg-open \"http://${domain}.localhost\" >/dev/null 2>&1\n"
        nohup xdg-open "http://${domain}.localhost" >/dev/null 2>&1

        echo_info "nohup xdg-open \"https://${domain}.localhost\" >/dev/null 2>&1\n"
        nohup xdg-open "https://${domain}.localhost" >/dev/null 2>&1
    done

    echo_info 'nohup xdg-open http://traefik.localhost/api/rawdata >/dev/null 2>&1\n'
    nohup xdg-open http://traefik.localhost/api/rawdata >/dev/null 2>&1
}

## Clear logs
clear() {
    echo_info 'rm -f ./logs/*.log || true\n'
    rm -f ./logs/*.log || true
}

## Backup traefik configuration
backup() {
    if [ ! -d ~/.TangoMan75/traefik ]; then
        echo_info 'mkdir -p ~/.TangoMan75/traefik\n'
        mkdir -p ~/.TangoMan75/traefik
    fi

    echo_info 'cp ./.env ~/.TangoMan75/traefik || true\n'
    cp ./.env ~/.TangoMan75/traefik || true

    echo_info 'cp ./compose.yaml ~/.TangoMan75/traefik || true\n'
    cp ./compose.yaml ~/.TangoMan75/traefik || true

    echo_info 'cp ./config/acme.json ~/.TangoMan75/traefik || true\n'
    cp ./config/acme.json ~/.TangoMan75/traefik || true

    echo_info 'cp ./config/traefik.yaml ~/.TangoMan75/traefik || true\n'
    cp ./config/traefik.yaml ~/.TangoMan75/traefik || true
}

## Restore traefik configuration
restore() {
    echo_info 'cp ~/.TangoMan75/traefik/.env ./ || true\n'
    cp ~/.TangoMan75/traefik/.env ./ || true

    echo_info 'cp ~/.TangoMan75/traefik/acme.json ./config || true\n'
    cp ~/.TangoMan75/traefik/acme.json ./config || true

    echo_info 'cp ~/.TangoMan75/traefik/compose.yaml ./ || true\n'
    cp ~/.TangoMan75/traefik/compose.yaml ./ || true

    echo_info 'cp ~/.TangoMan75/traefik/traefik.yaml ./ || true\n'
    cp ~/.TangoMan75/traefik/traefik.yaml ./ || true
}

##############################################
### Security
##############################################

## Set traefik dashboard password
password() {
    if [ ! -x "$(command -v htpasswd)" ]; then
        echo_error "\"$(basename "${0}")\" requires htpasswd, try 'sudo apt-get install -y apache2-utils'\n"
        return 1
    fi

    if [ ! -x "$(command -v yq)" ]; then
        echo_error "\"$(basename "${0}")\" requires yq\n"
        exit 1
    fi

    if [ -z "${user}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success 'Enter username (eg: root): '
            read -r USER_PROMPT
        done
        user="${USER_PROMPT}"
    fi

    if [ -z "${password}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success 'Enter password (eg: toor): '
            read -r USER_PROMPT
        done
        password="${USER_PROMPT}"
    fi

    _encrypted_password=$(htpasswd -nb "${user}" "${password}")

    if [ -f ./config/dynamic/dynamic.yaml ]; then
        echo_info "PASSWORD=\"${_encrypted_password}\" yq -i '.http.middlewares.auth.basicAuth.users = [strenv(PASSWORD)]' ./config/dynamic/dynamic.yaml\n"
        PASSWORD="${_encrypted_password}" yq -i '.http.middlewares.auth.basicAuth.users = [strenv(PASSWORD)]' ./config/dynamic/dynamic.yaml
    fi
}

##################################################
### Let's Encrypt
##################################################

## Config letsencrypt
letsencrypt() {
    acme
    email
}

## Create empty Let's Encrypt acme.json file
acme() {
    echo_info 'touch ./config/acme.json\n'
    touch ./config/acme.json

    echo_info 'chmod 600 ./config/acme.json\n'
    chmod 600 ./config/acme.json
}

## Set Let's Encrypt email
email() {
    if [ ! -x "$(command -v yq)" ]; then
        echo_error "\"$(basename "${0}")\" requires yq\n"
        exit 1
    fi

    if [ -z "${email}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success 'Enter admin email (eg: admin@yopmail.com): '
            read -r USER_PROMPT
        done
    fi

    echo_info "EMAIL=\"${USER_PROMPT}\" yq -i '.certificatesResolvers.letsencrypt.acme.email = strenv(EMAIL)' ./config/traefik.yaml\n"
    EMAIL="${USER_PROMPT}" yq -i '.certificatesResolvers.letsencrypt.acme.email = strenv(EMAIL)' ./config/traefik.yaml
}

##################################################
### Local Certificates
##################################################

## Install local SSL certificates
certs() {
    if [ ! -x "$(command -v mkcert)" ]; then
        # brew install nss
        echo_error "\"$(basename "${0}")\" requires mkcert, try: 'sudo apt-get install -y mkcert'\n"
        return 1
    fi

    if [ ! -x "$(command -v certutil)" ]; then
        echo_error "\"$(basename "${0}")\" requires certutil, try: 'sudo apt-get install -y libnss3-tools'\n"
        return 1
    fi

    if [ ! -f .env ]; then
        echo_error "\".env\" file not found\n"
        return 1
    fi

    if [ ! -f ./config/dynamic/dynamic.yaml ]; then
        echo_error "\"./config/dynamic/dynamic.yaml\" file not found\n"
        return 1
    fi

    echo_info "yq -i '.tls.certificates[0].certFile = \"/etc/traefik/certs/cert.pem\"' ./config/dynamic/dynamic.yaml\n"
    yq -i '.tls.certificates[0].certFile = "/etc/traefik/certs/cert.pem"' ./config/dynamic/dynamic.yaml

    echo_info "yq -i '.tls.certificates[0].keyFile = \"/etc/traefik/certs/key.pem\"' ./config/dynamic/dynamic.yaml\n"
    yq -i '.tls.certificates[0].keyFile = "/etc/traefik/certs/key.pem"' ./config/dynamic/dynamic.yaml

    # shellcheck disable=SC1090
    . "$(realpath .env)"

    _install=''
    for domain in ${DOMAINS}; do
        _install="${_install} ${domain}.localhost *.${domain}.localhost"
    done

    if [ ! -f ./certs/key.pem ] && [ ! -f ./certs/cert.pem ]; then
        echo_info "mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem ${_install}\n"
        # shellcheck disable=SC2086
        mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem ${_install}

        echo_info 'mkcert -install\n'
        mkcert -install
    fi
}

## Remove local SSL certificates or acme.json
remove_certs() {
    if [ "${env}" = prod ]; then
        echo_info "rm -f ./config/acme.json\n"
        rm -f ./config/acme.json

        return 0
    fi

    echo_info 'rm -f ./certs/key.pem\n'
    rm -f ./certs/key.pem

    echo_info 'rm -f ./certs/cert.pem\n'
    rm -f ./certs/cert.pem

    echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

##################################################
### Network
##################################################

## Create network
network() {
    if [ -z "${network}" ]; then
        echo_success 'Enter network name : [traefik] '
        USER_PROMPT=''
        read -r USER_PROMPT
        if [ -z "${USER_PROMPT}" ]; then
            network=traefik
        else
            network="${USER_PROMPT}"
        fi
    fi

    echo_info "docker network create \"${network}\" || true\n"
    docker network create "${network}" || true

    echo_info "NETWORK=\"${network}\" yq -i '.services[].networks = [strenv(NETWORK)]' \"./compose.yaml\"\n"
    NETWORK="${network}" yq -i '.services[].networks = [strenv(NETWORK)]' "./compose.yaml"

    echo_info "yq -i '.networks = null' \"./compose.yaml\"\n"
    yq -i '.networks = null' "./compose.yaml"

    echo_info "NETWORK=\"${network}\" yq -i '.networks.[strenv(NETWORK)].external = true' \"./compose.yaml\"\n"
    NETWORK="${network}" yq -i '.networks.[strenv(NETWORK)].external = true' "./compose.yaml"
}

## Remove network
remove_network() {
    _NETWORKS=$(docker network ls --format '{{ .Name }}' | tr '\n' ' ' | sed  -r 's/(bridge|host|none)\s//g' | sed -r 's/\s+$//')
    if [ -z "${network}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success "Enter network name : [${_NETWORKS}] "
            read -r USER_PROMPT
        done
        network="${USER_PROMPT}"
    fi

    echo_info "docker network rm \"${network}\" || true\n"
    docker network rm "${network}" || true
}

##################################################
### Docker
##################################################

## Build docker stack
build() {
    echo_info 'docker compose build\n'
    docker compose build
}

## Start docker stack
start() {
    echo_info 'docker compose up --detach --remove-orphans\n'
    docker compose up --detach --remove-orphans
}

## Stop docker stack
stop() {
    echo_info 'docker compose stop || true\n'
    docker compose stop || true
}

##################################################
### CI
##################################################

## Sniff errors with linters
lint() {
    lint_yaml
    lint_shell
}

## Sniff errors with yamllint
lint_yaml() {
    if [ ! -x "$(command -v yamllint)" ]; then
        echo_error "\"$(basename "${0}")\" requires yamllint, try 'sudo apt-get install -y yamllint'\n"
        return 1
    fi

    # https://yamllint.readthedocs.io
    find . -type f -iregex '.+\.ya?ml' | sort -t '\0' -n | while read -r FILE; do
        echo_info "yamllint \"${FILE}\"\n"
        yamllint "${FILE}"
    done
}

## Sniff errors with shellcheck
lint_shell() {
    if [ ! -x "$(command -v shellcheck)" ]; then
        echo_error "\"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
        exit 1
    fi

    find . -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

##################################################
### Self Install
##################################################

## Install script and enable completion
self_install() {
    _symlink_install "${ALIAS}"
    _set_autocomplete "${ALIAS}"

    if [ -x "$(command -v zsh)" ]; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "${ALIAS}" || true
    fi

    if [ -x "$(command -v bash)" ]; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            set -- ~/.profile
        else
            set -- ~/.bashrc
        fi
        if [ -f "$1" ]; then
            _set_completion_autoload "$1" "${ALIAS}"
        fi
    fi
}

## Uninstall script from system
self_uninstall() {
    _uninstall "${ALIAS}"
}

## Generate Markdown documentation
generate_doc() {
    alert_primary "Generating $(basename "${0}" .sh) documentation"

    _documentation_path="$(realpath "$(basename "${0}" .sh).md")"
    _generate_doc > "${_documentation_path}"
    echo_success "Documentation generated in : \"${_documentation_path}\"\n"
}

#--------------------------------------------------
# Before / After - Contructor / Destructor
#--------------------------------------------------

## Run following code before each execution
_before() {
    _script_path="$(realpath "$0")"
    _project_directory="$(dirname "${_script_path}")"
    _project_name="$(basename "${_project_directory}")"

    cd "${_project_directory}" || return 1
}

## Place here commands you need executed last every time (optional)
_after() {
    true
}

############################################################
# TangoMan Shoe Shell Microframework version 0.12.0-xl
############################################################

#--------------------------------------------------
# Semantic colors set
#--------------------------------------------------

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n';
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';
}

# Synopsys: echo_* [string] (indentation) (padding)
echo_primary()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${PRIMARY}"    "$3" "$1" "${DEFAULT}"; }
echo_secondary() { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${SECONDARY}"  "$3" "$1" "${DEFAULT}"; }
echo_success()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${SUCCESS}"    "$3" "$1" "${DEFAULT}"; }
echo_danger()    { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${DANGER}"     "$3" "$1" "${DEFAULT}"; }
echo_warning()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${WARNING}"    "$3" "$1" "${DEFAULT}"; }
echo_info()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${INFO}"       "$3" "$1" "${DEFAULT}"; }
echo_light()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${LIGHT}"      "$3" "$1" "${DEFAULT}"; }
echo_dark()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${DARK}"       "$3" "$1" "${DEFAULT}"; }
echo_error()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${DANGER}"     "$3" "error: $1" "${DEFAULT}"; }

alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''; }

#--------------------------------------------------
# Self documentation
#--------------------------------------------------

### Help

## Print this help (default)
help() {
    _padding=$(_get_padding)

    _print_title       "$(_get_docbloc_title)"
    _print_infos       "${_padding}"
    _print_description "$(_get_docbloc_description)"
    _print_usage
    _print_constants   "${_padding}"
    _print_flags       "${_padding}"
    _print_options     "${_padding}"
    _print_commands    "${_padding}"
}

#--------------------------------------------------

_print_title() {
    # Synopsys : _print_title [TITLE]
    printf "${EOL}${ALERT_PRIMARY}%64s${EOL}${ALERT_PRIMARY} %-63s${EOL}${ALERT_PRIMARY}%64s${EOL}\n" '' "$1" '';
}

_print_infos() {
    # Synopsys : _print_infos (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bInfos:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${SUCCESS}  %-$1s ${DEFAULT}%s\n" 'author'  "$(_get_docbloc 'author')"
    printf "${SUCCESS}  %-$1s ${DEFAULT}%s\n" 'version' "$(_get_docbloc 'version')"
    printf "${SUCCESS}  %-$1s ${DEFAULT}%s\n" 'link'    "$(_get_docbloc 'link')"
    printf '\n'
}

_print_description() {
    # Synopsys : _print_description [DESCRIPTION]
    printf "%bDescription:%b\n" "${WARNING}" "${DEFAULT}"
    printf "\033[97m  %s${EOL}\n" "$(printf '%s' "$1" | fold -w 64 -s)"
}

_print_usage() {
    # Synopsys : _print_usage [USAGE]
    printf "%bUsage:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${INFO}  sh %s${INFO} [${SUCCESS}command${INFO}]${DEFAULT} " "$(basename "$0")"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s ${WARNING}%s${INFO})${DEFAULT} \", \$1, \$2
    } { PREV = \$0 }" "$0"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 == \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s${INFO})${DEFAULT} \", \$1
    } { PREV = \$0 }" "$0"
    printf '\n\n'
}

_print_constants() {
    # Synopsys : _print_constants (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bConstants:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 == toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  %-$(($1+2))s ${DEFAULT}%s${INFO} (value: ${WARNING}%s${INFO})${EOL}\", \$1, substr(PREV, 4), \$2
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_flags() {
    # Synopsys : _print_flags (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bFlags:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  --%-$(($1))s ${DEFAULT}%s\n\", \$1, substr(PREV, 4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_options() {
    # Synopsys : _print_options (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bOptions:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\") {
            if (match(PREV, / \/.+\//)) {
                CONSTRAINT=substr(PREV, RSTART, RLENGTH);
                ANNOTATION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                printf \"${SUCCESS}  --%-$(($1))s ${DEFAULT}%s${SUCCESS}%s${INFO} (default: ${WARNING}%s${INFO})${EOL}\", \$1, ANNOTATION, CONSTRAINT, \$2
            } else {
                printf \"${SUCCESS}  --%-$(($1))s ${DEFAULT}%s${INFO} (default: ${WARNING}%s${INFO})${EOL}\", \$1, substr(PREV, 4), \$2
            }
        }
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_commands() {
    # Synopsys : _print_commands (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bCommands:%b\n" "${WARNING}" "${DEFAULT}"
    awk "/^### /{printf\"\n${WARNING}%s:${EOL}\",substr(\$0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\");
        FUNCTION = substr(\$0, 1, index(\$0, \"{\"));
        sub(\"{\$\", \"\", FUNCTION);
        if (substr(PREV, 1, 3) == \"## \" && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  %-$(($1+2))s ${DEFAULT}%s\n\", FUNCTION, substr(PREV, 4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

## Generate Markdown documentation
_generate_doc() {
    # Synopsys : _generate_doc (file default=self)
    if [ -z "$1" ]; then set -- "$0"; fi
    set -- "$(realpath "$1")"

    printf '%s\n===\n\n' "$(_get_docbloc_title)"

    printf '## ℹ️ Infos\n\n'
    printf '\055 author:  %s\n' "$(_get_docbloc 'author')"
    printf '\055 version: %s\n' "$(_get_docbloc 'version')"
    printf '\055 link:    %s\n' "$(_get_docbloc 'link')"
    printf '\n'

    printf '## 📑 Description\n\n'
    _get_docbloc_description
    printf '\n\n'

    printf '## 🔥 Usage\n\n'
    printf '`sh %s [command] ' "$(basename "$1")"
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")
        printf "(--%s %s) ", $1, $2
    } { PREV = $0 }' "$1"
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0, 1, 1) != "_")
        printf "(--%s) ", $1
    } { PREV = $0 }' "$1"
    printf '`\n\n'

    printf '## 🧱 Constants\n\n'
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == toupper($1) && substr($0, 1, 1) != "_")
        printf "%d. **%s**\n  - %s\n  - Value: %s\n\n", ++i, $1, substr(PREV, 4), $2
    } { PREV = $0 }' "$1"

    printf '## 🚩 Flags\n\n'
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%d. **--%s**\n  - %s\n\n", ++i, $1, substr(PREV, 4)
    } { PREV = $0 }' "$1"

    printf '## ⚙️ Options\n\n'
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_") {
            if (match(PREV, / \/.+\//)) {
                CONSTRAINT=substr(PREV, RSTART, RLENGTH);
                DESCRIPTION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                printf "%d. **--%s**\n  - Description: %s\n  - Constraint: %s\n  - Default: %s\n\n", ++i, $1, DESCRIPTION, CONSTRAINT, $2
            } else {
                printf "%d. **--%s**\n  - Description: %s\n  - Default: %s\n\n", ++i, $1, substr(PREV, 4), $2
            }
        }
    } { PREV = $0 }' "$1"

    printf '## 🤖 Commands\n\n'
    awk '/^### /{i=0; printf"### ⚡ %s\n\n",substr($0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
        printf "%d. **%s**\n  - %s\n\n", ++i, FUNCTION, substr(PREV, 4)
    } { PREV = $0 }' "$1"
}

#--------------------------------------------------
# Docbloc parsing
#--------------------------------------------------

_get_docbloc_title() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$0"
}

_get_docbloc_description() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$0"
}

_get_docbloc() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk -v TAG="$1" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$0" | sed -E 's/ +$//'
}

_get_padding() {
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0, 1, index($0, "{"));
        sub("{$", "", MATCH);
    } { if (substr(PREV, 1, 3) == "## " && substr(MATCH, 1, 1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+1 }' "$0"
}

#--------------------------------------------------
# Use this section for installation and autocompletion
#--------------------------------------------------

## Install script (via symlink in /usr/local/bin/ directory)
_symlink_install(){
    # Synopsys : _symlink_install [SCRIPT_NAME]
    # Creates a symbolic link in the /usr/local/bin/ directory.
    #   TARGET  (optional) The filename for the symlink. Defaults to the basename of the current script.

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "/usr/local/bin/$(basename "$0" .sh)"
    else
        set -- "/usr/local/bin/$1"
    fi

    if [ -f "$1" ] && [ "$1" = "$(realpath "$1")" ]; then
        echo_info "sudo rm -f \"$1\"\n"
        sudo rm -f "$1"
    fi

    echo_info "sudo ln -fs \"$(realpath "$0")\" \"$1\"\n"
    sudo ln -fs "$(realpath "$0")" "$1"
}

## Install script (via copy in /usr/local/bin/ directory)
_copy_install() {
    # Synopsys : _symlink_install [SCRIPT_NAME]
    # Creates a a copy in the /usr/local/bin/ directory.
    #   TARGET  (optional) The filename for the copy. Defaults to the basename of the current script.

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    echo_info "sudo cp -af \"$0\" \"/usr/local/bin/$1\"\n"
    sudo cp -af "$0" "/usr/local/bin/$1"
}

## Uninstall script from system
_uninstall() {
    # Synopsys : _uninstall [SCRIPT_NAME]
    # Uninstalls a script and its completion files from the system.
    #   SCRIPT_ALIAS  (optional) The name of the script to uninstall. Defaults to the basename of the current script.

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    _remove_completion_autoload ~/.zshrc "$1"
    _remove_completion_autoload ~/.bashrc "$1"
    _remove_completion_autoload ~/.profile "$1"

    set -- "/usr/local/bin/$1"

    echo_info "rm -f \"$(realpath "$(dirname "$0")")/$(basename "$0" .sh)-completion.sh\"\n"
    rm -f "$(realpath "$(dirname "$0")")/$(basename "$0" .sh)-completion.sh"

    if [ -f "$1" ]; then
        echo_info "sudo rm -f \"$1\"\n"
        sudo rm -f "$1"
    fi

    if [ -f "/etc/bash_completion.d/$1" ]; then
        echo_info "sudo rm -f /etc/bash_completion.d/$1\n"
        sudo rm -f /etc/bash_completion.d/"$1"
    fi
}

## Update script from given url
_update() {
    # Synopsys : _update [URL]
    # Updates the script from the provided URL.
    #   URL  The URL of the script to download and install.

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ -x "$(command -v curl)" ]; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$0")\"\n"
        curl -sSL "$1" > "$(realpath "$0")"

    elif [ -x "$(command -v wget)" ]; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$0")\"\n"
        wget -qO - "$1" > "$(realpath "$0")"

    else
        echo_error 'update requires curl, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    "$(realpath "$0")" self_install
}

## Create autocomplete script in install folder
_set_autocomplete() {
    # Synopsys : _set_autocomplete [SCRIPT_NAME]
    # Generates an autocomplete script for the current shell.
    #   SCRIPT_NAME  (optional) The name of the script to autocomplete. Defaults to the basename of the current script.
    #   This function creates a completion script named "<script_name>-completion.sh" (where "<script_name>" is the basename of the current script) in the same directory as the script itself.
    #   **Note:** Refer to the URL (https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial) for details on how to configure shell autocompletions.

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$1\" > \"$(dirname "$(realpath "$0")")/$1-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$1" > "$(dirname "$(realpath "$0")")/$1-completion.sh"
}

## Create autocomplete script in /etc/bash_completion.d/
_set_global_autocomplete() {
    # Synopsys : _set_global_autocomplete [SCRIPT_NAME]
    # Creates a system-wide autocomplete script for the current shell.
    #   SCRIPT_NAME  (optional) The name of the script to autocomplete. Defaults to the basename of the current script.
    #   This function creates a completion script named "<script_name>" (where "<script_name>" is the basename of the current script) in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #   **Note:** It uses sudo for file creation in a system directory, requiring root privileges.

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$1\" | sudo tee \"/etc/bash_completion.d/$1\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$1" | sudo tee "/etc/bash_completion.d/$1"
}

## Generate comspec string
_comspec() {
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
        printf "%s ", FUNCTION, substr(PREV, 4)
    } { PREV = $0 }' "$0"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") {
            printf "--%s ", $1
        }
    } { PREV = $0 }' "$0"
}

## Set completion script autoload
_set_completion_autoload() {
    # Synopsys : _set_completion_autoload SHELL_CONFIG_FILE [SCRIPT_NAME] [COMPLETION_FILE_PATH]
    # Adds an autoload line for a completion script to a shell configuration file.
    #   SHELL_CONFIG_FILE  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_NAME        (optional) The name of the script to autoload completion for. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$2" ]; then
        set -- "$(realpath "$1")" "$(basename "$0" .sh)"
    fi

    if [ ! -f "$1" ]; then
        echo_error "cannot update \"$1\" : file not found\n"
        return 1
    fi

    # remove previous install if any
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # find completion file path for global directory
    if [ -f "/etc/bash_completion.d/$2" ]; then
        set -- "$1" "$2" "/etc/bash_completion.d/$2"

    # find completion file path for current directory
    elif [ -f "$(dirname "$(realpath "$0")")/$2-completion.sh" ]; then
        set -- "$1" "$2" "$(dirname "$(realpath "$0")")/$2-completion.sh"

    else
        echo_error 'completion script not found\n'
        return 1
    fi

    echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$2\" \"$3\" \"$2\" >> \"$1\"\n"
    printf '\n###> %s\nsource %s\n###< %s\n' "$2" "$3" "$2" >> "$1"
}

## Remove completion script autoload
_remove_completion_autoload() {
    # Synopsys : _remove_completion_autoload SHELL_CONFIG_FILE [SCRIPT_NAME]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_NAME        (optional) The name of the script for which to remove the autoload line. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$2" ]; then
        set -- "$(realpath "$1")" "$(basename "$0" .sh)"
    fi

    if [ ! -f "$1" ]; then
        echo_warning "cannot update \"$1\" : file not found\n"
        return 0
    fi

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;/^\n$/d;}' "$1"
}

#--------------------------------------------------
# System flavor
#--------------------------------------------------

## Open with default handler
_open() {
    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

## Return sed -i system flavour
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
# Sytem
#--------------------------------------------------

## Check user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        echo true
        return 0
    fi

    echo false
}

## Install required dependency
_require() {
    # Synopsys : _require [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 3 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! -x "$(command -v "$1")" ]; then
        _package_name=${2:-$1}
        if [ -z "$3" ]; then
            _command="sudo apt-get install -y ${_package_name}"
        else
            _command="$3 ${_package_name}"
        fi
        echo_info "${_command}\n"
        ${_command}
    fi
}

## Check app is installed
_is_installed() {
    # Synopsys : _is_installed [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ -x "$(command -v "$1")" ]; then
        echo true

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then
        echo true

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x /home/linuxbrew/.linuxbrew/bin/"$1" ]; then
        echo true

        return 0
    fi

    echo false
}

#--------------------------------------------------
# Validation
#--------------------------------------------------

_get_constraints() {
    awk -v NAME="$1" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) {match(PREV, /\/.+\//); print substr(PREV, RSTART, RLENGTH)}
    } { PREV = $0 }' "$0"
}

_validate() {
    # find constraints and validates a variable from parameter string. e.g: "variable_name=value"
    _validate_variable=$(printf '%s' "$1" | cut -d= -f1)
    _validate_value=$(printf '%s' "$1" | cut -d= -f2)
    _validate_pattern=$(_get_constraints "${_validate_variable}")

    if [ "$(_is_valid "${_validate_value}" "${_validate_pattern}")" = false ]; then
        printf "${DANGER}error: invalid \"%s\", expected \"%s\", \"%s\" given${EOL}" "${_validate_variable}" "${_validate_pattern}" "${_validate_value}"
        exit 1
    fi
}

_is_valid() {
    if [ $# -lt 2 ]; then
        printf "${DANGER}error: \"_is_valid\" %s${EOL}" 'some mandatory argument is missing'
        exit 1
    fi

    if [ $# -gt 2 ]; then
        printf "${DANGER}error: \"_is_valid\" too many arguments: expected 2, %s given.${EOL}" $#
        exit 1
    fi

    _is_valid_value="$1"
    _is_valid_pattern="$2"

    # missing pattern always returns valid status
    if [ -z "${_is_valid_pattern}" ]; then
        echo true
        return 0
    fi

    if [ "${_is_valid_value}" != "$(printf '%s' "${_is_valid_value}" | awk "${_is_valid_pattern} {print}")" ]; then
        echo false
        return 0
    fi

    echo true
}

#--------------------------------------------------
# Reflexion
#--------------------------------------------------

_get_functions_names() {
    # this regular expression matches functions with either bash or sh syntax
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");   # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0, 1, index($0, "{")); # truncate string after opening curly brace
        sub("{$", "", FUNCTION);                  # remove trailing curly brace
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_") print FUNCTION
    } { PREV = $0 }' "$0"
}

_get_variables() {
    # constants, flags and private variables will be ignored
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")print $1
    } { PREV = $0 }' "$0"
}

_get_flags() {
    # flags are just regular variables with a value set to "false"
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") print $1
    } { PREV = $0 }' "$0"
}

#--------------------------------------------------
# Main loop
#--------------------------------------------------

_main() {
    if [ $# -lt 1 ]; then
        help
        exit 0
    fi

    _error=''
    _eval=''
    _execute=''
    _requires_value=''
    for _argument in "$@"; do
        _is_valid=false
        # check if previous argument requires value
        if [ -n "${_requires_value}" ]; then
            _eval="${_eval} ${_requires_value}=${_argument}"
            _requires_value=''
            continue
        fi
        if [ -n "$(printf '%s' "${_argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            # check argument is a valid flag (must start with - or --)
            for _flag in $(_get_flags); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_flag}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_flag}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    # append argument to the eval stack
                    _eval="${_eval} ${_flag}=true"
                    _is_valid=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for _variable in $(_get_variables); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_variable}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_variable}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    _requires_value="${_variable}"
                    _is_valid=true
                    break
                fi
            done
            if [ "${_is_valid}" = false ]; then
                _error="\"${_argument}\" is not a valid option"
                break
            fi
            continue
        fi
        for _function in $(_get_functions_names); do
            # get shorthand character
            _shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${_argument}" = "${_function}" ] || [ "${_argument}" = "${_shorthand}" ]; then
                # append argument to the execute stack
                _execute="${_execute} ${_function}"
                _is_valid=true
                break
            fi
        done
        if [ "${_is_valid}" = false ]; then
            _error="\"${_argument}\" is not a valid command"
            break
        fi
    done

    if [ -n "${_requires_value}" ]; then
        _error="\"--${_requires_value}\" requires value"
    fi

    if [ -n "${_error}" ]; then
        printf "${DANGER}error: %s${EOL}" "${_error}"
        exit 1
    fi

    for _variable in ${_eval}; do
        # invalid parameters will raise errors
        _validate "${_variable}"
        eval "${_variable}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for _function in ${_execute}; do
        eval "${_function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_main "$@"
