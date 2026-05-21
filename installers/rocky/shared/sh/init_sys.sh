#!/usr/bin/env bash

# Initialise operating system.
function init_sys_libs()
{
    # Update OS.
    sudo yum update -qq -y
    sudo yum install -y epel-release
    sudo yum autoremove -qq -y

    # Install C/C++ compilers and make.
    sudo yum install -qq -y gcc gcc-c++ make

    # Install libraries for OpenSSL and Python dependencies.
    sudo yum install -qq -y libffi-devel openssl-devel

    # Install basic utils.
    sudo yum install -qq -y wget curl git

    # Install Python development headers and venv.
    sudo yum install -qq -y python3-devel python3

    # Install database development libraries.
    sudo yum install -qq -y gdbm-devel postgresql-devel

    # Install XML handling libraries.
    sudo yum install -qq -y libxml2-devel libxslt-devel xmlsec1-devel

    # Install compression and other libraries.
    sudo yum install -qq -y \
        zlib-devel \
        bzip2-devel \
        readline-devel \
        ncurses-devel \
        llvm \
        xz \
        tk-devel \
        xz-devel \
        firewalld
}

# Initialise services.
function init_sys_services()
{
    # Only append to .bashrc if it exists and is writable
    if [[ -f "$HOME/.bashrc" && -w "$HOME/.bashrc" ]]; then
        cat "$INSTALLER_HOME/templates/shell-postgresql.txt" >> "$HOME/.bashrc"
    else
        log_error "Cannot write to $HOME/.bashrc - check permissions"
        return 1
    fi

    sudo yum install -qq -y nginx

    # Start and enable firewalld
    sudo systemctl enable --now firewalld
    sudo firewall-cmd --add-service=http --permanent
    sudo firewall-cmd --add-service=https --permanent
    sudo firewall-cmd --reload
}

# Initialise permissions.
function init_sys_permissions()
{
    sudo chmod 777 /opt
    sudo chmod 777 /var/lib
}