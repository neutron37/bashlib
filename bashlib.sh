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
export BASHLIB_SRC_DIR="${BASHLIB_THIS_DIR}/src"

# Ensure includes directory exists and is exported.
export BASHLIB_INCLUDES_DIR="${BASHLIB_DIR}/includes"
[ -d "${BASHLIB_INCLUDES_DIR}" ] || mkdir "${BASHLIB_INCLUDES_DIR}"

# Make susudoio available when using MacOS.
if [[ "$OSTYPE" == "darwin"* ]]; then
  export BASHLIB_SUSUDOIO_DIR="${BASHLIB_INCLUDES_DIR}/susudoio"
  if [ ! -d "${BASHLIB_SUSUDOIO_DIR}" ]; then
    echo "------------------------------------------------------------"
    echo "Installing neutron37 susudoio."
    cd "${BASHLIB_INCLUDES_DIR}"
    git clone https://github.com/neutron37/susudoio.git
    echo "------------------------------------------------------------"
  fi
  export PATH="${BASHLIB_SUSUDOIO_DIR}:${PATH}"
fi

#################
## Text styles ##
#################
readonly STYLE_NORMAL=$( tput sgr0 );
readonly STYLE_BOLD=$( tput bold );
readonly STYLE_RED=$( tput setaf 1 );
readonly STYLE_GREEN=$( tput setaf 2 );
readonly STYLE_MAGENTA=$( tput setaf 5 );

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

bashlib::members() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    dscl . -list /Users | while read user; do printf "$user ";
      dsmemberutil checkmembership -U "$user" -G "$*";
    done | grep "is a member" | cut -d " " -f 1;
  fi
};

export BASHLIB_ADMIN_USER_DEFAULT=$( bashlib::members admin | grep -v root | head -n1 )
export BASHLIB_CURRENT_USER_DEFAULT=$( whoami )

bashlib::run_as_root() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ "${BASHLIB_CURRENT_USER_DEFAULT}" == "${BASHLIB_ADMIN_USER_DEFAULT}" ]; then
      sudo "${@}"
    else
      susudoio "${@}"
    fi
  fi
};

bashlib::run_as_admin() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ "${BASHLIB_CURRENT_USER_DEFAULT}" == "${BASHLIB_ADMIN_USER_DEFAULT}" ]; then
      "${@}"
    else
      susudoio -a "${@}"
    fi
  else
    bashlib::msg_stderr "Unsupported \$OSTYPE: $OSTYPE"
  fi
};
