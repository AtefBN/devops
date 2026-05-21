# Errata Workspace Installation Guide (Rocky Linux + uv)

```bash
## 🌐 Proxy Configuration (IPSL Network)

**If behind IPSL proxy/firewall**, export these variables **before** running any installer steps:

```bash
# Replace XXXX with your actual proxy values
export http_proxy="http://your-proxy-ip\:port"
export https_proxy="http://your-proxy-ip\:port"
export no_proxy="localhost,127.0.0.1,10.0.0.0/8,192.168.0.0/16"

# To make permanent, add to ~/.bashrc
echo "export http_proxy=\"\$http_proxy\"" >> ~/.bashrc
echo "export https_proxy=\"\$https_proxy\"" >> ~/.bashrc
echo "export no_proxy=\"\$no_proxy\"" >> ~/.bashrc
source ~/.bashrc


# ---------------------------------------------------------------------------
# Step 00: Prerequisites (as regular user with sudo)
# ---------------------------------------------------------------------------

yum install -y git curl
sudo chmod 777 /opt

# ---------------------------------------------------------------------------
# Step 01: Clone repository and initialize
# ---------------------------------------------------------------------------

git clone https://github.com/ES-DOC/devops.git ~/devops
source ~/devops/installers/rocky/ws-errata/activate

# ---------------------------------------------------------------------------
# Step 02: Initialize uv
# ---------------------------------------------------------------------------

errata-installer-step-02
source ~/.bashrc

# ---------------------------------------------------------------------------
# Step 03: Verify Python
# ---------------------------------------------------------------------------

errata-installer-step-03
source ~/.bashrc

# ---------------------------------------------------------------------------
# Step 04: Initialize stack (repos, environment, credentials)
# ---------------------------------------------------------------------------

errata-installer-step-04
source ~/.bashrc

# ---------------------------------------------------------------------------
# Step 05: Initialize uv virtual environment
# ---------------------------------------------------------------------------

errata-installer-step-05
source ~/.bashrc

# ---------------------------------------------------------------------------
# Step 06: Initialize database
# ---------------------------------------------------------------------------

errata-installer-step-06
source ~/.bashrc

# ---------------------------------------------------------------------------
# Step 07: Run web-service daemon
# ---------------------------------------------------------------------------

cd ~/esdoc-errata-ws
uv run python sh/app_run.py