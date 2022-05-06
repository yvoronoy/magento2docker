#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

VERSION=1.0.0
SCRIPT_NAME=$(basename "${0}");

################################################################################
# Action Controllers
################################################################################
composerLinkAction()
{
  local flag="${1:-0}"
  local composer="/usr/local/bin/composer${flag}"
  local composerLink="/usr/local/bin/composer"

  if [ ! -f "${composer}" ]; then
	    echo "> ERROR: No ${composer} executable found ..." 1>&2 && return 1
  fi

  if [ -f "${composerLink}" ]; then
  	  unlink ${composerLink}
  fi

  ln -s ${composer} ${composerLink}
  echo "Composer ${composer} was succesfully linked to ${composerLink}"
}


################################################################################
# Main
################################################################################
main()
{
  composerLinkAction "$@"
}
main "${@:-}"

