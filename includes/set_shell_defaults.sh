#!/bin/bash

##################################################################
##################################################################
# START bashlib include boilerplate.                             #
# See https://github.com/neutron37/bashlib/blob/master/README.md #
##################################################################
BASHLIB_SOURCE="${BASH_SOURCE[0]}"
while [ -h "${BASHLIB_SOURCE}" ]; do
  # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P $( dirname ${BASHLIB_SOURCE} ) && pwd )
  BSOURCE=$( readlink "${BASHLIB_SOURCE}" );
  [[ $BASHLIB_SOURCE != /* ]] && SOURCE="${DIR}/${BASHLIB_SOURCE}"
done
BASHLIB_THIS_DIR=$( dirname ${BASHLIB_SOURCE} )
export BASHLIB_THIS_DIR=$( cd -P $BASHLIB_THIS_DIR && pwd )
export BASHLIB_DIR=$( cd -P "${BASHLIB_THIS_DIR}/.." && pwd )
source "${BASHLIB_DIR}/bashlib.sh"
##################################################################
# END bashlib include boilerplate.                               #
##################################################################

# Make brew available if it's not installed already.
bashlib::msg_stdout  "------------------------------------------------------------"
bashlib::msg_stdout  "Ensure base shell directories are available."

bashlib::print_cmd   '[ -d ~/.local/share ] || mkdir -p ~/.local/share'
                      [ -d ~/.local/share ] || mkdir -p ~/.local/share

bashlib::print_cmd   '[ -d ~/.local/bin ] || mkdir -p ~/.local/bin'
                      [ -d ~/.local/bin ] || mkdir -p ~/.local/bin

bashlib::print_cmd   '[ -d ~/.config/fish ] || mkdir -p ~/.config/fish'
                      [ -d ~/.config/fish ] || mkdir -p ~/.config/fish

bashlib::print_cmd   '[ -f ~/.profile ] || touch ~/.profile'
                      [ -f ~/.profile ] || touch ~/.profile

bashlib::print_cmd   '[ -f ~/.config/fish/config.fish ] || touch ~/.config/fish/config.fish'
                      [ -f ~/.config/fish/config.fish ] || touch ~/.config/fish/config.fish


bashlib::msg_stdout  "Ensure \$PATH is set appropriately for both bash and fish."

# Ensure path is included
CONFIG_FILE="${HOME}/.config/fish/config.fish"
if [ -f ${CONFIG_FILE} ]; then
  REQUIRED_LINE='set PATH $PATH $HOME/.local/bin'
  bashlib::print_cmd   "grep -q -F \"${REQUIRED_LINE}\" ${CONFIG_FILE} || echo \"${REQUIRED_LINE}\" >> ${CONFIG_FILE}"
                        grep -q -F "${REQUIRED_LINE}" ${CONFIG_FILE} || echo "${REQUIRED_LINE}" >> ${CONFIG_FILE}
fi
# Ensure path is included
CONFIG_FILE="${HOME}/.profile"
if [ -f ${CONFIG_FILE} ]; then
  REQUIRED_LINE='export PATH="${PATH}:${HOME}/.local/bin"'
  bashlib::print_cmd   "grep -q -F \"${REQUIRED_LINE}\" ${CONFIG_FILE} || echo \"${REQUIRED_LINE}\" >> ${CONFIG_FILE}"
                        grep -q -F "${REQUIRED_LINE}" ${CONFIG_FILE} || echo "${REQUIRED_LINE}" >> ${CONFIG_FILE}
fi

touch ${HOME}/.config/set_shell_defaults.ok

bashlib::msg_stdout  "------------------------------------------------------------"
