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
bashlib::msg_stdout  "Installing neutron37 susudoio."

# Ensure it's checked out
if [ ! -d ~/.local/share/susudoio ]; then
  bashlib::print_cmd   'cd ~/.local/share && git clone git@github.com:neutron37/susudoio.git'
  cd ~/.local/share && git clone git@github.com:neutron37/susudoio.git
fi

# Create symlink
if [ ! -f ~/.local/bin/susudoio ]; then
  bashlib::print_cmd   'ln -s ~/.local/share/susudoio/susudoio ~/.local/bin/'
  ln -s ~/.local/share/susudoio/susudoio ~/.local/bin/
fi

bashlib::msg_stdout  "------------------------------------------------------------"
