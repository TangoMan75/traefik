#/**
# * TangoMan Traefik
# *
# * @version  0.1.0
# * @author   "Matthias Morin" <mat@tangoman.io>
# * @license  MIT
# */

.PHONY: acme build clear help logs network open restart shell start status stop up

#--------------------------------------------------
# Parameters
#--------------------------------------------------

# App environment (dev|prod)
env?=dev

#--------------------------------------------------
# Colors
#--------------------------------------------------

PRIMARY   = \033[97m
SECONDARY = \033[94m
SUCCESS   = \033[32m
DANGER    = \033[31m
WARNING   = \033[33m
INFO      = \033[95m
LIGHT     = \033[47;90m
DARK      = \033[40;37m
DEFAULT   = \033[0m
EOL       = \033[0m\n

ALERT_PRIMARY   = \033[1;104;97m
ALERT_SECONDARY = \033[1;45;97m
ALERT_SUCCESS   = \033[1;42;97m
ALERT_DANGER    = \033[1;41;97m
ALERT_WARNING   = \033[1;43;97m
ALERT_INFO      = \033[1;44;97m
ALERT_LIGHT     = \033[1;47;90m
ALERT_DARK      = \033[1;40;37m

#--------------------------------------------------
# Color Functions
#--------------------------------------------------

define echo_primary
	@printf "${PRIMARY}%b${EOL}" $(1)
endef
define echo_secondary
	@printf "${SECONDARY}%b${EOL}" $(1)
endef
define echo_success
	@printf "${SUCCESS}%b${EOL}" $(1)
endef
define echo_danger
	@printf "${DANGER}%b${EOL}" $(1)
endef
define echo_warning
	@printf "${WARNING}%b${EOL}" $(1)
endef
define echo_info
	@printf "${INFO}%b${EOL}" $(1)
endef
define echo_light
	@printf "${LIGHT}%b${EOL}" $(1)
endef
define echo_dark
	@printf "${DARK}%b${EOL}" $(1)
endef

define echo_label
	@printf "${SUCCESS}%b ${DEFAULT}" $(1)
endef
define echo_error
	@printf "${DANGER}error: %b${EOL}" $(1)
endef

define alert_primary
	@printf "${EOL}${ALERT_PRIMARY}%64s${EOL}${ALERT_PRIMARY} %-63s${EOL}${ALERT_PRIMARY}%64s${EOL}\n" "" $(1) ""
endef
define alert_secondary
	@printf "${EOL}${ALERT_SECONDARY}%64s${EOL}${ALERT_SECONDARY} %-63s${EOL}${ALERT_SECONDARY}%64s${EOL}\n" "" $(1) ""
endef
define alert_success
	@printf "${EOL}${ALERT_SUCCESS}%64s${EOL}${ALERT_SUCCESS} %-63s${EOL}${ALERT_SUCCESS}%64s${EOL}\n" "" $(1) ""
endef
define alert_danger
	@printf "${EOL}${ALERT_DANGER}%64s${EOL}${ALERT_DANGER} %-63s${EOL}${ALERT_DANGER}%64s${EOL}\n" "" $(1) ""
endef
define alert_warning
	@printf "${EOL}${ALERT_WARNING}%64s${EOL}${ALERT_WARNING} %-63s${EOL}${ALERT_WARNING}%64s${EOL}\n" "" $(1) ""
endef
define alert_info
	@printf "${EOL}${ALERT_INFO}%64s${EOL}${ALERT_INFO} %-63s${EOL}${ALERT_INFO}%64s${EOL}\n" "" $(1) ""
endef
define alert_light
	@printf "${EOL}${ALERT_LIGHT}%64s${EOL}${ALERT_LIGHT} %-63s${EOL}${ALERT_LIGHT}%64s${EOL}\n" "" $(1) ""
endef
define alert_dark
	@printf "${EOL}${ALERT_DARK}%64s${EOL}${ALERT_DARK} %-63s${EOL}${ALERT_DARK}%64s${EOL}\n" "" $(1) ""
endef

#--------------------------------------------------
# Help
#--------------------------------------------------

## Print this help
help:
	$(call alert_primary, 'TangoMan Traefik')

	$(call echo_warning, 'Description')
	$(call echo_primary, "  Awesome **TangoMan Traefik Boilerplate** is a fast and handy tool to manage Traefik with Docker.${EOL}")

	$(call echo_warning, 'Usage')
	@printf "${PRIMARY}  make [command] `awk -F '?' '/^[ \t]+?[a-zA-Z0-9_-]+[ \t]+?\?=/{gsub(/[ \t]+/,"");printf"%s=[%s]\n",$$1,$$1}' ${MAKEFILE_LIST}|sort|uniq|tr '\n' ' '`${EOL}\n"

	$(call echo_warning, 'Commands')
	@awk '/^### /{printf"\n${WARNING}%s${EOL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if(match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf "  ${SUCCESS}%-16s${DEFAULT} ${PRIMARY}%s${EOL}",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

##############################################
### Install
##############################################

## Build and start traefik
up:
	@sh entrypoint.sh up --env "${env}"

## Install TangoMan Traefik companion
install:
	@sh entrypoint.sh self_install

## Uninstall traefik
uninstall:
	@sh entrypoint.sh uninstall
	@sh entrypoint.sh self_uninstall

##############################################
### App
##############################################

## Show logs
logs:
	@sh entrypoint.sh logs

## Clear logs
clear:
	@sh entrypoint.sh clear

##############################################
### Local
##############################################

## Open traefik dashboard in default browser
open:
	@sh entrypoint.sh open

##############################################
### Security
##############################################

## Generate password
password:
	@sh entrypoint.sh password --env "${env}"

##################################################
### Container
##################################################

## Build docker stack
build:
	@sh entrypoint.sh build

## Start docker stack
start:
	@sh entrypoint.sh start

## Stop docker stack
stop:
	@sh entrypoint.sh stop

##################################################
### Network
##################################################

## Create network
network:
	@sh entrypoint.sh network

## Remove network
remove-network:
	@sh entrypoint.sh remove_network

##################################################
### Let's Encrypt
##################################################

## Create acme.json file
acme:
	@sh entrypoint.sh acme

##################################################
### CI/CD
##################################################

## Lint project files
lint:
	@sh entrypoint.sh lint

