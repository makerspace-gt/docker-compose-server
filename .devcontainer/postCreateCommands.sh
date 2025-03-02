# Debian packages install
# export DEBIAN_FRONTEND=noninteractive
# apt-get update
# apt-get -y install ---no-install-recommends $(./.devcontainer/debian-packages.txt)
# rm -rf /var/lib/apt/lists/*
# apt-get clean

# pip and ansible-galaxy-install
# pip install -r ./.devcontainer/pip-requirements.txt
ansible-galaxy install -r ./.devcontainer/ansible-galaxy-requirements.yml
