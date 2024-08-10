#!/bin/bash

#author actual[at]google.com | Google Cloud | Advanced Practices Mandiant
# eula github.com/itzdan/tpvm_linux/LICENSE.md
# community dev edt 0.4


# Function to perform TPVM system update and package installation
install_packages() {
    echo "Starting the base update and package installation process..."

    # Update the package list and fix any missing dependencies
    sudo apt-get update --fix-missing
    sudo apt-get upgrade -y

    echo "Installing required packages..."

    # Install essential packages
    sudo apt-get install -y nginx openjdk-11-jdk wireshark apache2-utils apt-transport-https \
        python3-pip python3-setuptools python3-wheel wget software-properties-common

    echo "Installing additional tools and libraries..."

    # Install additional tools and libraries
    sudo apt-get install -y pytorch rtools jupyter-notebook neo4j

    # Install Elasticsearch and Kibana
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    sudo apt-get update
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
    sudo apt-get update
    sudo apt-get install -y elasticsearch kibana

    # Install Go language
    wget https://dl.google.com/go/go1.17.7.linux-amd64.tar.gz
    sudo tar -zxvf go1.17.7.linux-amd64.tar.gz -C /usr/local/
    export PATH=$PATH:/usr/local/go/bin
    source $HOME/.profile
    go version
    rm -r go1.17.7.linux-amd64.tar.gz

    echo "Installing Python packages..."
    pip3 install --user --upgrade tensorflow msticpy

    echo "Installation process completed."
}

# Run the package installation function
install_packages
