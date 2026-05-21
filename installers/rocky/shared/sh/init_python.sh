#!/usr/bin/env bash

# Initialise uv.
init_uv()
{
    if ! command -v uv &> /dev/null; then
        log "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

# JIT install python (using uv).
init_python()
{
    # No version argument needed - uv manages Python automatically
    log "Verifying Python installation via uv..."
    uv python -c "import sys; print(sys.version)"
}

# JIT install python virtual environment (using uv).
init_venv()
{
    local TARGET_DIR=${1}

    pushd "$TARGET_DIR"
    uv init
    uv pip install supervisor
    uv pip sync
    popd
}