#!/usr/bin/env bash

set -Eeuo pipefail

if [ "${DOTFILES_DEBUG:-}" ]; then
    set -x
fi

declare -r DOTFILES_REPO_URL="https://github.com/howardkyu/dotfiles"
declare -r BRANCH_NAME="${BRANCH_NAME:-main}"
declare -r DOTFILES_GITHUB_PAT="${DOTFILES_GITHUB_PAT:-}"

function run_chezmoi() {
    # run `chezmoi init` to setup the source directory,
    # generate the config file, and optionally update the destination directory
    # to match the target state.
    chezmoi init "${DOTFILES_REPO_URL}" \
        --force \
        --branch "${BRANCH_NAME}"

    # Add to PATH for installing the necessary binary files under `$HOME/.local/bin`.
    export PATH="${PATH}:${HOME}/.local/bin"

    # run `chezmoi apply` to ensure that target... are in the target state,
    # updating them if necessary.
    chezmoi apply
}

function get_os_type() {
    uname
}

function get_linux_distro() {
    lsb_release -a | grep "Distributor ID" | awk -F':\t*' '{print $2}'
}

function initialize_os_linux() {
    # Install brew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Install zsh
    brew install zsh

    # Install chezmoi
    brew install chezmoi
}

function initialize_os_ubuntu() {
    # Install brew's Ubuntu dependencies
    sudo apt-get install build-essential
}

function initialize_dotfiles() {
    run_chezmoi
}

function initialize_os_env() {
    local ostype
    ostype="$(get_os_type)"

    echo "Detected OS type as ${ostype}"
    if [ "${ostype}" == "Linux" ]; then
        initialize_os_linux

        local linux_distro
        linux_distro="$(get_linux_distro)"
        echo "Detected Linux distro as ${linux_distro}"
        if [ "${linux_distro}" == "Ubuntu" ]; then
            initialize_os_ubuntu
        else
            echo "Invalid Linux distro: ${linux_distro}" >&2
            exit 1
        fi
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
