# Initialise operating system.
function init_sys_libs()
{
    # Update OS.
    yum update -qq
    yum autoremove -qq

    # Installs the C and C++ compilers, also the make command used to compile the CPython dependencies.
    yum install -qq dpkg-dev build-essential

    # Install libraries used on packages which implement OpenSSL.
    yum install -qq libffi-dev libssl-dev

    # Install basic utils.
    yum install -qq wget curl git

    # Installs the headers and static libraries of python 3 that are used to compile and mount the language extensions.
    yum install -qq python3-dev python3-venv

    # Install base of the most of packages that handle databases.
    yum install -qq libgdbm-dev

    # Install dependency of psycopg2 to work with PostgreSQL databases.
    yum install -qq libpq-dev

    # Install libraries used to handle XML on packages like lxml.
    yum install -qq libxml2-dev libxslt1-dev libxmlsec1-dev

    # Install other.
    yum install -qq \
        make \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        llvm \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libxmlsec1-dev \
        liblzma-dev \
        ufw
}

# Initialise services.
function init_sys_services()
{
    cat $INSTALLER_HOME/templates/shell-postgresql.txt >> $HOME/.bashrc

    yum install -qq nginx
    ufw allow 'Nginx Full'
}

# Initialise permissions.
function init_sys_permissions()
{
    chmod 777 /opt
    chmod 777 /var/lib
}
