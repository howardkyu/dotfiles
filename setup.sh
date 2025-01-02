#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

declare -r DOTFILES_REPO_URL="https://github.com/howardkyu/dotfiles"
declare -r BRANCH_NAME="${BRANCH_NAME:-main}"
declare -r DOTFILES_GITHUB_PAT="${DOTFILES_GITHUB_PAT:-}"

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
    
    if [[ -n "${DOTFILES_GITHUB_PAT}" ]]; then
        export DOTFILES_GITHUB_PAT
    fi

    # run `chezmoi apply` to ensure that target... are in the target state,
    # updating them if necessary.
    "${chezmoi_cmd}" apply

    # purge the binary of the chezmoi cmd
    rm -fv "${chezmoi_cmd}"
}

function get_os_type() {
    uname
}

function initialize_os_macos() {
    :
}

function initialize_os_linux() {
    :
}

function initialize_dotfiles() {
    run_chezmoi
}

function initialize_os_env() {
    local ostype
    ostype="$(get_os_type)"

    if [ "${ostype}" == "Darwin" ]; then
        initialize_os_macos
    elif [ "${ostype}" == "Linux" ]; then
        initialize_os_linux
    else
        echo "Invalid OS type: ${ostype}" >&2
        exit 1
    fi
}

function main() {
    initialize_os_env
    initialize_dotfiles
}

main
