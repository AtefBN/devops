#!/usr/bin/env bash

# Imports.
source /opt/esgf/devops/installers/ubuntu/shared/sh/constants.sh

# Array of managed libraries.
declare -a INSTALLER_REPOS=(
    'esdoc-errata-fe'
    'esdoc-errata-ws'
)