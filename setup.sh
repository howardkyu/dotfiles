#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

declare -r DOTFILES_REPO_URL="https://github.com/howardkyu/dotfiles"
declare -r BRANCH_NAME="${BRANCH_NAME:-main}"

function run_chezmoi() {
    # download the chezmoi binary from the URL
    sh -c "$(curl -fsLS get.chezmoi.io)"
    local chezmoi_cmd
    chezmoi_cmd="./bin/chezmoi"

    # run `chezmoi init` to setup the source directory,
    # generate the config file, and optionally update the destination directory
    # to match the target state.
    "${chezmoi_cmd}" init "${DOTFILES_REPO_URL}" \
        --force \
        --branch "${BRANCH_NAME}"

    # Add to PATH for installing the necessary binary files under `$HOME/.local/bin`.
    export PATH="${PATH}:${HOME}/.local/bin"

    # run `chezmoi apply` to ensure that target... are in the target state,
    # updating them if necessary.
    "${chezmoi_cmd}" apply

    # purge the binary of the chezmoi cmd
    rm -fv "${chezmoi_cmd}"
}

function main() {
    run_chezmoi
}

main
