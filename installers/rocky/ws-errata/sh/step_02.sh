# Imports.
source /opt/esgf/devops/installers/ubuntu/shared/sh/init_python.sh
source /opt/esgf/devops/installers/ubuntu/shared/sh/utils.sh

# Main entry point.
main()
{
    log "BEGIN step 2:"

    log "... step 2.1: initialising uv"
    init_uv

    log "END step 2"
}

# Invoke entry point.
main