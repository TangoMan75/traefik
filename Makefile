## TangoMan Traefik
##
## TangoMan Traefik: Streamline your Traefik setup with Docker.
##
## @version 0.1.1
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/traefik

.PHONY: help up set_env requirements uninstall logs clear backup restore open password letsencrypt acme email certs add_domain print_domains remove_certs build start stop network remove_network lint lint_yaml lint_shell self_install self_uninstall

##################################################
## Colors
##################################################

_PRIMARY   = \033[97m
_SECONDARY = \033[94m
_SUCCESS   = \033[32m
_DANGER    = \033[31m
_WARNING   = \033[33m
_INFO      = \033[95m
_DEFAULT   = \033[0m
_EOL       = \033[0m\n

_ALERT_PRIMARY   = \033[1;104;97m
_ALERT_SECONDARY = \033[1;45;97m
_ALERT_SUCCESS   = \033[1;42;97m
_ALERT_DANGER    = \033[1;41;97m
_ALERT_WARNING   = \033[1;43;97m
_ALERT_INFO      = \033[1;44;97m

##################################################
## Color Functions
##################################################

define _echo_primary
	@printf "${_PRIMARY}%b${_EOL}" $(1)
endef
define _echo_secondary
	@printf "${_SECONDARY}%b${_EOL}" $(1)
endef
define _echo_success
	@printf "${_SUCCESS}%b${_EOL}" $(1)
endef
define _echo_danger
	@printf "${_DANGER}%b${_EOL}" $(1)
endef
define _echo_warning
	@printf "${_WARNING}%b${_EOL}" $(1)
endef
define _echo_info
	@printf "${_INFO}%b${_EOL}" $(1)
endef

define _alert_primary
	@printf "${_EOL}${_ALERT_PRIMARY}%64s${_EOL}${_ALERT_PRIMARY} %-63s${_EOL}${_ALERT_PRIMARY}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_secondary
	@printf "${_EOL}${_ALERT_SECONDARY}%64s${_EOL}${_ALERT_SECONDARY} %-63s${_EOL}${_ALERT_SECONDARY}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_success
	@printf "${_EOL}${_ALERT_SUCCESS}%64s${_EOL}${_ALERT_SUCCESS} %-63s${_EOL}${_ALERT_SUCCESS}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_danger
	@printf "${_EOL}${_ALERT_DANGER}%64s${_EOL}${_ALERT_DANGER} %-63s${_EOL}${_ALERT_DANGER}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_warning
	@printf "${_EOL}${_ALERT_WARNING}%64s${_EOL}${_ALERT_WARNING} %-63s${_EOL}${_ALERT_WARNING}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_info
	@printf "${_EOL}${_ALERT_INFO}%64s${_EOL}${_ALERT_INFO} %-63s${_EOL}${_ALERT_INFO}%64s${_EOL}\n" "" $(1) ""
endef

##################################################
## Help
##################################################

## Print this help
help:
	$(call _alert_primary, "TangoMan Traefik")

	@printf "${_WARNING}Description:${_EOL}"
	@printf "${_PRIMARY}  TangoMan Traefik: Streamline your Traefik setup with Docker. ${_EOL}\n"

	@printf "${_WARNING}Usage:${_EOL}"
	@printf "${_PRIMARY}  make [command]${_EOL}\n"

	@printf "${_WARNING}Commands:${_EOL}"
	@awk '/^### /{printf"\n${_WARNING}%s${_EOL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \
		printf "${_SUCCESS}  %-12s  ${_PRIMARY}%s${_EOL}",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

##################################################
### Install
##################################################

## Build and start traefik
up:
	@printf "${_INFO}sh traefik.sh up${_EOL}"
	@sh traefik.sh up

## Set dev or prod configuration
set_env:
	@printf "${_INFO}sh traefik.sh set_env${_EOL}"
	@sh traefik.sh set_env

## Check requirements
requirements:
	@printf "${_INFO}sh traefik.sh requirements${_EOL}"
	@sh traefik.sh requirements

## Uninstall Traefik
uninstall:
	@printf "${_INFO}sh traefik.sh uninstall${_EOL}"
	@sh traefik.sh uninstall

##################################################
### App
##################################################

## Show traefik error log
logs:
	@printf "${_INFO}sh traefik.sh logs${_EOL}"
	@sh traefik.sh logs

## Clear logs
clear:
	@printf "${_INFO}sh traefik.sh clear${_EOL}"
	@sh traefik.sh clear

## Backup traefik configuration
backup:
	@printf "${_INFO}sh traefik.sh backup${_EOL}"
	@sh traefik.sh backup

## Restore traefik configuration
restore:
	@printf "${_INFO}sh traefik.sh restore${_EOL}"
	@sh traefik.sh restore

## Open all configured domains in default browser
open:
	@printf "${_INFO}sh traefik.sh open${_EOL}"
	@sh traefik.sh open

## Set traefik dashboard password
password:
	@printf "${_INFO}sh traefik.sh password${_EOL}"
	@sh traefik.sh password

##################################################
### Let's Encrypt
##################################################

## Config Let's Encrypt
letsencrypt:
	@printf "${_INFO}sh traefik.sh letsencrypt${_EOL}"
	@sh traefik.sh letsencrypt

## Create empty Let's Encrypt acme.json file
acme:
	@printf "${_INFO}sh traefik.sh acme${_EOL}"
	@sh traefik.sh acme

## Set Let's Encrypt email
email:
	@printf "${_INFO}sh traefik.sh email${_EOL}"
	@sh traefik.sh email

##################################################
### Certificates
##################################################

## Install local SSL certificates
certs:
	@printf "${_INFO}sh traefik.sh certs${_EOL}"
	@sh traefik.sh certs

## Add a new domain to current local certificates
add_domain:
	@printf "${_INFO}sh traefik.sh add_domain${_EOL}"
	@sh traefik.sh add_domain

## Print configured domains
print_domains:
	@printf "${_INFO}sh traefik.sh print_domains${_EOL}"
	@sh traefik.sh print_domains

## Remove local SSL certificates
remove_certs:
	@printf "${_INFO}sh traefik.sh remove_certs${_EOL}"
	@sh traefik.sh remove_certs

##################################################
### Docker
##################################################

## Build docker stack
build:
	@printf "${_INFO}sh traefik.sh build${_EOL}"
	@sh traefik.sh build

## Start docker stack
start:
	@printf "${_INFO}sh traefik.sh start${_EOL}"
	@sh traefik.sh start

## Stop docker stack
stop:
	@printf "${_INFO}sh traefik.sh stop${_EOL}"
	@sh traefik.sh stop

## Create network
network:
	@printf "${_INFO}sh traefik.sh network${_EOL}"
	@sh traefik.sh network

## Remove network
remove_network:
	@printf "${_INFO}sh traefik.sh remove_network${_EOL}"
	@sh traefik.sh remove_network

##################################################
### CI
##################################################

## Sniff errors with linters
lint:
	@printf "${_INFO}sh traefik.sh lint${_EOL}"
	@sh traefik.sh lint

## Sniff errors with yamllint
lint_yaml:
	@printf "${_INFO}sh traefik.sh lint_yaml${_EOL}"
	@sh traefik.sh lint_yaml

## Sniff errors with shellcheck
lint_shell:
	@printf "${_INFO}sh traefik.sh lint_shell${_EOL}"
	@sh traefik.sh lint_shell

##################################################
### Self Install
##################################################

## Install traefik companion and enable autocompletion
self_install:
	@printf "${_INFO}sh traefik.sh self_install${_EOL}"
	@sh traefik.sh self_install

## Uninstall traefik companion from system
self_uninstall:
	@printf "${_INFO}sh traefik.sh self_uninstall${_EOL}"
	@sh traefik.sh self_uninstall


