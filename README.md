# bashlib

## Installation

Simply add the following lines to the beginning of your script.

```
##################################################################
# START bashlib boilerplate.                                     #
# See https://github.com/neutron37/bashlib/blob/master/README.md #
##################################################################
set -euo pipefail
BASHLIB_SOURCE="${BASH_SOURCE[0]}"
while [ -h "${BASHLIB_SOURCE}" ]; do
  # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P $( dirname ${BASHLIB_SOURCE} ) && pwd )
  BSOURCE=$( readlink "${BASHLIB_SOURCE}" );
  [[ $BASHLIB_SOURCE != /* ]] && SOURCE="${DIR}/${BASHLIB_SOURCE}"
done
BASHLIB_THIS_DIR=$( dirname ${BASHLIB_SOURCE} )
export BASHLIB_THIS_DIR=$( cd -P $BASHLIB_THIS_DIR && pwd )
export BASHLIB_DIR="${BASHLIB_THIS_DIR}/bashlib"
if [ -d "${BASHLIB_DIR}" ]; then
  echo "------------------------------------------------------------"
  echo "Installing neutron37 bashlib."
  cd "${BASHLIB_THIS_DIR}"
  git clone https://github.com/neutron37/bashlib.git
fi
source "${BASHLIB_DIR}/bashlib.sh"
##################################################################
# END bashlib boilerplate.                                       #
##################################################################

## Export Project Path - Customize the following line for your project!
export BASHLIB_PROJECT_DIR=$( cd -P $INCLUDES_DIR/.. && pwd )
```

## Optional installations

```
source "${BASHLIB_DIR}/macos_install_brew.sh"
source "${BASHLIB_DIR}/macos_install_susudoio.sh"
```

## Useful commands

The susudoio command is autoinstalled and added to the path.

## Useful variables

* $BASHLIB_THIS_DIR
* $BASHLIB_INCLUDES_DIR
* $BASHLIB_ADMIN_USER_DEFAULT
* $BASHLIB_CURRENT_USER_DEFAULT
* $BASHLIB_PROJECT_DIR
