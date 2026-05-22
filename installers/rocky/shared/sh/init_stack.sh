#!/usr/bin/env bash

# Initialises stack environment.
function init_stack_env()
{
    local INSTALLER_HOME=${1}

    if [[ ! -d $HOME/.esdoc ]]; then
        mkdir -p $HOME/.esdoc
        if [[ -f $INSTALLER_HOME/templates/app_credentials.txt ]]; then
            cp $INSTALLER_HOME/templates/app_credentials.txt $HOME/.esdoc/credentials
        fi
        if [[ -f $INSTALLER_HOME/templates/app_environment.txt ]]; then
            cp $INSTALLER_HOME/templates/app_environment.txt $HOME/.esdoc/environment
        fi
        if [[ -f $INSTALLER_SHARED/templates/bashrc.txt ]]; then
            cat $INSTALLER_SHARED/templates/bashrc.txt >> $HOME/.bashrc
        fi
    fi
}

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

# Initialises stack repos.
function init_stack_repos()
{
    local -n REPOS=$1  # Fixed: proper array reference

    for REPO in "${REPOS[@]}"
    do
        init_stack_repo "$REPO"
    done
}