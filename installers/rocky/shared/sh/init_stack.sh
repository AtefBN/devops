#!/usr/bin/env bash
# ... (keep init_stack_env function unchanged)

# Initialises stack repo.
function init_stack_repo()
{
    local REPO=${1}
    local REPO_DIR="$HOME/opt/$REPO"
    local BRANCH="dev"

    if [[ ! -d "$REPO_DIR" ]]; then
        mkdir -p "$HOME/opt"
        pushd "$HOME/opt"
        git clone -q --depth 1 -b $BRANCH https://github.com/ESGF/$REPO.git
        popd
    else
        pushd "$REPO_DIR"
        git fetch -q --depth 1 origin $BRANCH
        git checkout $BRANCH -q
        git pull -q
        popd
    fi
}
# ... (keep init_stack_repos function unchanged)