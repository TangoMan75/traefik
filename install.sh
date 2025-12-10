#!/usr/bin/env sh

set -e

# This script is based on TangoMan Shoe Shell Microframework
#
# This file is distributed under to the MIT license.
#
# Copyright (c) 2025 "Matthias Morin" <mat@tangoman.io>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Source code is available here: https://github.com/TangoMan75/shoe

## TangoMan Traefik Installation Script
##
## Installation script
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.2.0
## @license MIT
## @link    https://github.com/TangoMan75/traefik


## The author of the repository.
AUTHOR=TangoMan75

## The name of the application being installed.
APP_NAME=traefik

## The GitHub repository path.
REPOSITORY="${AUTHOR}/${APP_NAME}"

## The version of the application to install.
VERSION=0.2.0

## The download URL for the application.
URL="https://github.com/${REPOSITORY}/archive/refs/tags/${VERSION}.zip"

## A temporary directory for downloads and extraction.
TEMP_DIRECTORY=$(mktemp -d)

## The final installation directory for the application.
INSTALL_DIRECTORY="${HOME}/.local/share/${REPOSITORY}"


## Print primary alert (bold white text over bright blue background)
_alert_primary() { printf "\033[0m\n\033[1;104;97m%64s\033[0m\n\033[1;104;97m %-63s\033[0m\n\033[1;104;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print secondary alert (bold white text over bright purple background)
_alert_secondary() { printf "\033[0m\n\033[1;45;97m%64s\033[0m\n\033[1;45;97m %-63s\033[0m\n\033[1;45;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print success alert (bold white text over bright green background)
_alert_success() { printf "\033[0m\n\033[1;42;97m%64s\033[0m\n\033[1;42;97m %-63s\033[0m\n\033[1;42;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print danger alert (bold white text over bright red background)
_alert_danger() { printf "\033[0m\n\033[1;41;97m%64s\033[0m\n\033[1;41;97m %-63s\033[0m\n\033[1;41;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print warning alert (bold white text over bright orange background)
_alert_warning() { printf "\033[0m\n\033[1;43;97m%64s\033[0m\n\033[1;43;97m %-63s\033[0m\n\033[1;43;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print info alert (bold white text over blue background)
_alert_info() { printf "\033[0m\n\033[1;44;97m%64s\033[0m\n\033[1;44;97m %-63s\033[0m\n\033[1;44;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print primary text (bright white text)
_echo_primary() { printf '\033[97m%b\033[0m' "$1"; }

## Print secondary text (bright blue text)
_echo_secondary() { printf '\033[94m%b\033[0m' "$1"; }

## Print success text (bright green text)
_echo_success() { printf '\033[32m%b\033[0m' "$1"; }

## Print danger text (red text)
_echo_danger() { printf '\033[31m%b\033[0m' "$1"; }

## Print warning text (orange text)
_echo_warning() { printf '\033[33m%b\033[0m' "$1"; }

## Print info text (bright purple text)
_echo_info() { printf '\033[95m%b\033[0m' "$1"; }

## Print error message to STDERR, prefixed with "error: "
_echo_error() { printf '\033[31merror: %b\033[0m' "$1" >&2; }


## Extract file based on its extension
##
## {
##   "namespace": "files",
##   "requires": [
##     "realpath",
##     "tar",
##     "unzip"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 1,
##       "name": "DESTINATION_FOLDER",
##       "type": "folder",
##       "description": "The path to the destination folder. Defaults to file parent."
##     }
##   ]
## }
_extract() {
    # Synopsis: _extract <FILE_PATH> [DESTINATION_FOLDER]
    #   FILE_PATH:          The path to the input file.
    #   DESTINATION_FOLDER: (optional) The path to the destination folder. Defaults to file parent.

    if [ -z "$1" ]; then _echo_error '_extract: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_extract: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}"
    if [ ! -f "$1" ]; then _echo_error "_extract: \"$1\" file not found\n"; return 1; fi

    # ${1##*.} : This is a parameter expansion expression
    #       ## : Removes the shortest pattern that matches the entire string from the end of the value
    #        * : Matches zero or more characters
    #        . : Matches a literal dot (.)
    if [ "${1##*.}" = gz ]; then
        _check_installed tar

        # extract with tar
        # -x, --extract
        # -v, --verbose
        # -z, --gzip, --gunzip --ungzip
        # -f, --file [ARCHIVE]
        # -C, --directory [DIR] : destination directory
        _echo_info "tar -xvzf \"$1\" -C \"$2\"\n"
        tar -xvzf "$1" -C "$2"

        return 0
    fi

    if [ "${1##*.}" = zip ]; then
        _check_installed unzip

        _echo_info "unzip \"$1\" -d \"$2\"\n"
        unzip "$1" -d "$2"

        return 0
    fi

    _echo_error "Unsupported archive format \"${1##*.}\".\n"
}

## Downloads file with either curl or wget
##
## {
##   "namespace": "network",
##   "requires": [
##     "curl",
##     "grep",
##     "head",
##     "wget"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_echo_warning",
##     "_is_installed"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "URL",
##       "type": "str",
##       "description": "The URL of the file to download.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the output file.",
##       "nullable": false
##     }
##   ]
## }
_download() {
    # Synopsis: _download <URL> <FILE_PATH>
    #   URL:        The URL of the file to download.
    #   FILE_PATH:  The path to the output file.

    if [ -z "$1" ]; then _echo_error '_download: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_download: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "$1" "${2:-"$0"}"
    # create destination folder
    if [ ! -d "$(dirname "$2")" ]; then _echo_info "mkdir -p \"$(dirname "$2")\"\n"; mkdir -p "$(dirname "$2")"; fi

    if _is_installed curl; then
        _echo_info "curl -L \"$1\" -o \"$2\"\n"
        curl -L "$1" -o "$2"
    
    elif _is_installed wget; then
        _echo_info "wget -nv \"$1\" -O \"$2\"\n"
        wget -nv "$1" -O "$2"
    
    else
        _echo_error 'Neither curl nor wget is available for downloading files.\n'

        return 1
    fi

    # Check if the downloaded file is valid (not empty and not an HTML error page)
    if [ ! -s "$2" ] || head -n 1 "$2" | grep -q "<!DOCTYPE html>"; then
        echo_error 'Downloaded file is invalid or not found.\n'

        return 1
    fi
}

## Print error message if provided command is missing
##
## {
##   "namespace": "system",
##   "depends": [
##     "_get_package_name",
##     "_is_installed",
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMAND",
##       "type": "str",
##       "description": "A string containing the command name to find.",
##       "nullable": false
##     }
##   ]
## }
_check_installed() {
    # Synopsis: _check_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then _echo_error '_check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_check_installed: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$1" "$(_get_package_name "$1")"

    _echo_error "\"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $2'\n"

    exit 1
}

## Check provided command is installed
##
## {
##   "namespace": "system",
##   "requires": [
##     "dpkg"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMAND",
##       "type": "str",
##       "description": "A string containing the command name to find.",
##       "nullable": false
##     }
##   ]
## }
_is_installed() {
    # Synopsis: _is_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then _echo_error '_is_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_installed: too many arguments ($#)\n"; return 1; fi

    if [ -x "$(command -v "$1")" ]; then

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x "/home/linuxbrew/.linuxbrew/bin/$1" ]; then

        return 0
    fi

    return 1
}


## Run installation script
##
## {
##   "namespace": "app",
##   "depends": [
##     "_alert_primary",
##     "_download",
##     "_echo_info",
##     "_extract"
##   ],
##   "assumes": [
##     "APP_NAME",
##     "AUTHOR",
##     "INSTALL_DIRECTORY",
##     "TEMP_DIRECTORY",
##     "URL",
##     "VERSION"
##   ]
## }
install() {
    _alert_primary "Install ${AUTHOR} ${APP_NAME} v${VERSION}"

    _download "${URL}" "${TEMP_DIRECTORY}/${VERSION}.zip"
    _extract "${TEMP_DIRECTORY}/${VERSION}.zip"

    _echo_info "mkdir -p \"${INSTALL_DIRECTORY}\"\n"
    mkdir -p "${INSTALL_DIRECTORY}"

    _echo_info "mv \"${TEMP_DIRECTORY}/${APP_NAME}-${VERSION}\"/* \"${INSTALL_DIRECTORY}\"/\n"
    mv "${TEMP_DIRECTORY}/${APP_NAME}-${VERSION}"/* "${INSTALL_DIRECTORY}"/

    _echo_info "rm -rf \"${TEMP_DIRECTORY}\"\n"
    rm -rf "${TEMP_DIRECTORY}"

    "${INSTALL_DIRECTORY}/traefik.sh" self_install
}

install

