#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

function main() {
    PACKAGE_PATH=$(dirname $(readlink -f "$0"))
    brew bundle --file "${PACKAGE_PATH}/Brewfile"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
