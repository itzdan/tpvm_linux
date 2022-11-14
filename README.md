# tpvm_linux
ThreatPursuitVM Cyber Threat Intelligence VM for Linux
- Off-spin of Windows-based Mandiant ThreatPursuitVM 
- Updated packages
- Quick and fast

# Pre-Reqs

## Base OS
Tested on Debian Linux 5.10.0-10-amd64 #1 SMP Debian 5.10.84-1 (2021-12-08) x86_64 GNU/Linux

## Recommended OS Specs

- x4 CPU
- 8GB Memory
- 80GB HDD Capacity
- GPU 512MB or greater

## Installation

1. Pull the git installer file git clone https://github.com/itzdan/tpvm_linux/blob/main/tpvm_installer.sh
2. Set the script as executable 
chmod +x tpvm_installer.sh
3. Run the installer with sudo priv
sudo ./tpvm_installer.sh 
4. Select (1) to configure the pre-reqs
5. Select (2) to download and install packages  (Usually about 20mins with fast internet)
6. Select (3) to check and bring up services  (Not Implemented yet)
7. A user account and credential is created tpvm:{randomely_generated_password} during the setup process, if you did not take note of the credential it is written into a local creds.txt within your install directory. You are encouraged to change your credential and delete the creds.txt file if you no longer require it during your install.
