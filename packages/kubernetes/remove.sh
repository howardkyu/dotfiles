#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

function main() {
    # TODO automatically remove Brewfile dependencies
    exit
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
