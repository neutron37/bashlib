#!/bin/bash

# <<YAMLDOC
# namespace: /neutron37/bashlib
# description: "Make bash scripting less crappy."
# copyright: "Neutron37"
# authors: "neutron37@hauskreativ.com"
# tags: bash convenience
# YAMLDOC

trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -euo pipefail

# Include project specific src directory.
export BASHLIB_SRC_DIR=$( cd -P "${BASHLIB_DIR}/../src" && pwd )

# Ensure includes directory exists and is exported.
export BASHLIB_INCLUDES_DIR="${BASHLIB_DIR}/includes"

[ -d "${BASHLIB_INCLUDES_DIR}" ] || mkdir "${BASHLIB_INCLUDES_DIR}"

#################
## Text styles ##
#################
readonly STYLE_NORMAL=$( tput sgr0 );
readonly STYLE_BOLD=$( tput bold );
readonly STYLE_BLACK=$( tput setaf 0 );
readonly STYLE_RED=$( tput setaf 1 );
readonly STYLE_GREEN=$( tput setaf 2 );
readonly STYLE_YELLOW=$( tput setaf 3 );
readonly STYLE_BLUE=$( tput setaf 4 );
readonly STYLE_MAGENTA=$( tput setaf 5 );
readonly STYLE_CYAN=$( tput setaf 6 );
readonly STYLE_WHITE=$( tput setaf 7 );

#######################
## bashlib functions ##
#######################
# abrt: prints abort message and exits
# arg1: message
bashlib::exit_fail() {
  bashlib::msg_stderr "${STYLE_BOLD}${STYLE_RED}$@${STYLE_NORMAL}"
  exit 37;
}

trap 'bashlib::exit_fail "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

bashlib::uuid() {
  NEW_UUID=$( LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 64 ; echo; )
  echo "${NEW_UUID}"
}

bashlib::lanip() {
  /sbin/ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1
}

bashlib::timestamp() {
  date +%Y.%m.%d_%H.%M.%S
}

export BASHLIB_TIME=$( bashlib::timestamp )

# abrt: prints sussess message and exits
# arg1: message
bashlib::exit_success() {
  bashlib::msg_stdout "${STYLE_BOLD}${STYLE_GREEN}$@${STYLE_NORMAL}"
  exit 0;
}

# msg: prints a message to stdout
# arg1: message
bashlib::msg_stdout() {
  if [ ! -z "$@" ]; then
    echo "$@"
  fi
}

# msg: prints a message to stdout
# arg1: message
bashlib::msg_stdout_success() {
  if [ ! -z "$@" ]; then
    echo "${STYLE_GREEN}$@${STYLE_NORMAL}"
  fi
}

# vmsg: prints a message to stderr
# arg1: message
bashlib::msg_stderr() {
  if [ ! -z "$@" ]; then
    echo "${STYLE_RED}$@${STYLE_NORMAL}" >&2
  fi
}

# Ensure consistent $BASHLIB_PROJECT_DIR
# It's probably a bad idea to save this to the same place in /tmp every run!
# @TODO FIX this somehow.
if [ -z ${BASHLIB_PROJECT_DIR+x} ]; then
  if [ -f "/tmp/project_dir.data" ]; then
    BASHLIB_PROJECT_DIR=$( cat "/tmp/project_dir.data" )
  else
    bashlib::exit_fail "You must set \$BASHLIB_PROJECT_DIR in your main script."
  fi
else
  echo -n "${BASHLIB_PROJECT_DIR}" > "/tmp/project_dir.data"
  chmod a+r "/tmp/project_dir.data"
fi

bashlib::members() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    dscl . -list /Users | while read user; do printf "$user ";
      dsmemberutil checkmembership -U "$user" -G "$*";
    done | grep "is a member" | cut -d " " -f 1;
  fi
};

export BASHLIB_ADMIN_USER_DEFAULT=$( bashlib::members admin | grep -v root | head -n1 )
export BASHLIB_CURRENT_USER_DEFAULT=$( whoami )

bashlib::print_cmd() {
  echo "${STYLE_BOLD}+ ${@}${STYLE_NORMAL}"
}

bashlib::check_admin() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ "${BASHLIB_CURRENT_USER_DEFAULT}" != "${BASHLIB_ADMIN_USER_DEFAULT}" ]; then
      bashlib::exit_fail "Must run as admin user."
    fi
  else
    bashlib::exit_fail "Unsupported \$OSTYPE: $OSTYPE"
  fi
};
