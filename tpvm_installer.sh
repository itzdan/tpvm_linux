
# author actual[at]google.com | Google Cloud | Advanced Practices Mandiant
# eula github.com/itzdan/tpvm_linux/LICENSE.md
# community dev edt 0.2

TPVM_Pass="${TPVM_Pass:-$(openssl rand -hex 12)}" #randomising credential

user_can_sudo() {
	command_exists sudo || return 1
		}

show_menu(){
    echo '▀▀█▀▀ █──█ █▀▀█ █▀▀ █▀▀█ ▀▀█▀▀ █▀▀█ █──█ █▀▀█ █▀▀ █──█ ─▀─ ▀▀█▀▀'
    echo '──█── █▀▀█ █▄▄▀ █▀▀ █▄▄█ ──█── █──█ █──█ █▄▄▀ ▀▀█ █──█ ▀█▀ ──█──'
    echo '──▀── ▀──▀ ▀─▀▀ ▀▀▀ ▀──▀ ──▀── █▀▀▀ ─▀▀▀ ▀─▀▀ ▀▀▀ ─▀▀▀ ▀▀▀ ──▀──'
    echo '(v) 0.1 dev edition (w) https://github.com/itzdan/tpvm_linux | (c) @itzdan1337'
    normal=`echo "\033[m"`
    menu=`echo "\033[36m"` #green
    number=`echo "\033[33m"` #red
    bgred=`echo "\033[41m"`
    fgred=`echo "\033[31m"`
    printf "\n${menu}*********************************************${normal}\n"
    printf "${menu}**${number} 1)${menu} Pre-installation and Pre-reqs Setup${normal}\n"
    printf "${menu}**${number} 2)${menu} Proceed with Installation ${normal}\n"
    printf "${menu}**${number} 3)${menu} Post Setup Checklist${normal}\n"
    printf "${menu}*********************************************${normal}\n"
    printf "Please enter a menu option and enter or ${fgred}x to exit. ${normal}"
    read opt
}

option_picked(){
    msgcolor=`echo "\033[01;31m"` # bold red
    normal=`echo "\033[00;00m"` # normal green
    message=${@:-"${normal}Error: No message passed"}
    printf "${msgcolor}${message}${normal}\n"
}

clear
show_menu
while [ $opt != '' ]
    do
    if [ $opt = '' ]; then
      exit;
    else
      case $opt in
        1) clear;
            option_picked "Option 1 Picked";
            printf "running pre-installation setup.. please wait";
		sudo apt-get update --fix-missing;
		echo "creating directory";
		mkdir /usr/share/tpvm/;
		sleep 2;
		printf "Adding default user..";
		useradd -m -p $TPVM_Pass tpvm;
		echo "TPVM (admin) with Password: "$TPVM_Pass"" && echo " user:tpvm pass:"$TPVM_Pass"" > creds.txt;
		sleep 10;
		printf "Adding groups";
		groupadd admins;
		groupadd analysts;
		useradd -G admins,analysts tpvm;
		printf "Checking Disk Capacity";
		df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
		do
			echo $output
			usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
			partition=$(echo $output | awk '{ print $2 }' )
			if [ $usep -ge 90 ]; then
   			 echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)";
		fi
		clear;
		printf "Configuring Network";
		clear;
		printf "Setting Background and Theme";
#		./installer_desktop.sh --install;
	done
		clear
            show_menu;
        ;;
        2) clear;
            option_picked "proceeding with full installation";
            printf "Take a break, while we download packages :-)"; ##setting up main download and install of packages
		apt-get update --fix-missing;
		apt-get install -y nginx openjdk-11-jdk wireshark apache2-utils apt-transport-https pytorch rtools jupyter-notebook neo4j >> tpvm_inst.log;
		apt-get install -y python-pip-whl python3-pip python3-setuptools python3-wheel wget;
		apt-get install -y software-properties-common;
		wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -;
		apt-get update;
		printf "Setting up MISP";
		wget -O /tmp/INSTALL.sh https://raw.githubusercontent.com/MISP/MISP/2.4/INSTALL/INSTALL.sh;
		bash /tmp/INSTALL.sh -C -u;
		pip3 install --user --upgrade tensorflow  # install in $HOME;
		pip3 install msticpy;
		mkdir /usr/share/tpvm;
		cd /usr/share/tpvm/;
		git clone --recurse-submodules --remote-submodule https://github.com/OpenCTI-Platform/opencti.git;
		git clone --recurse-submodules --remote-submodule https://github.com/mitre-attack/attack-navigator.git;
		git clone --recurse-submodules --remote-submodule https://github.com/microsoft/msticpy.git;
		git clone --recurse-submodules --remote-submodule https://github.com/TheHive-Project/TheHive.git;
		git clone --recurse-submodules --remote-submodule https://github.com/mitre/caldera.git;
		git clone --recurse-submodules --remote-submodule https://github.com/SigmaHQ/sigma.git;
		git clone --recurse-submodules --remote-submodule https://github.com/mitre/caret.git;
		git clone --recurse-submodules --remote-submodule https://github.com/shogun-toolbox/shogun.git;
		git clone --recurse-submodules --remote-submodule https://github.com/shogun-toolbox/shogun-data.git;
		git clone --recurse-submodules --remote-submodule https://github.com/GreyNoise-Intelligence/pygreynoise.git;
		git clone --recurse-submodules --remote-submodule https://github.com/GreyNoise-Intelligence/pygreynoise.git;
		git clone --recurse-submodules --remote-submodule https://github.com/chronicle/detection-rules.git;
		printf "grabbing packages..";
		echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list;
		apt-get update;
		apt-get install -y elasticsearch kibana;
		wget https://github.com/constellation-app/constellation/releases/download/v2.5.0/constellation-linux-v2.5.0.tar.gz;
		cd /usr/share/tpvm/;
		tar -xzvf  constellation*.gz;
		rm -r constellation*.gz;
		cd /usr/share/tpvm/;
		wget https://dl.google.com/go/go1.17.7.linux-amd64.tar.gz;
                tar -zxvf go1.17.7.linux-amd64.tar.gz -C /usr/local/;
		export PATH=$PATH:/usr/local/go/bin;
		source $HOME/.profile;
		.//usr/local/go/bin/go version;
                rm -r /usr/share/tpvm/go*.tar.gz;
		printf "pulling gitrepos"
		git clone --recurse-submodules --remote-submodule https://github.com/CIRCL/AIL-framework.git;
		git clone --recurse-submodules --remote-submodule https://github.com/ail-project/ail-splash-manager;
		apt-get install npm -y;
		npm install -g grunt-cli;
		git clone --recurse-submodules --remote-submodule https://github.com/gchq/CyberChef.git;
		npm install;
		git clone --depth=1 https://github.com/twintproject/twint.git
		cd twint;
		pip3 install . -r requirements.txt;
		cd /usr/share/tpvm;
		git clone --recurse-submodules https://github.com/scythe-io/community-threats.git;
		git clone --recurse-submodules https://github.com/scythe-io/purple-team-exercise-framework.git;
		git clone --recurse-submodules https://github.com/center-for-threat-informed-defense/adversary_emulation_library.git;
		git clone --recurse-submodules https://github.com/mitre/emu.git;
		git clone --recurse-submodules https://github.com/OTRF/Security-Datasets.git;
		git clone --recurse-submodules https://github.com/OTRF/OSSEM.git;
		git clone --recurse-submodules https://github.com/mandiant/capa-rules;
		git clone --recurse-submodules https://github.com/mandiant/heyserial.git;
		git clone --recurse-submodules https://github.com/mandiant/apooxml.git;
		git clone --recurse-submodules https://github.com/mandiant/ioc_writer.git;
		wget https://github.com/mandiant/capa/releases/download/v3.1.0/capa-v3.1.0-linux.zip;
		tar -xzvf capa-v3.1.0-linux.zip;
		rm -rf capa*.zip;
		mkdir stratus && cd stratus;
		wget https://github.com/DataDog/stratus-red-team/releases/download/v1.3.0/stratus-red-team_1.3.0_Linux_x86_64.tar.gz;
		tar -xzvf stratus-red-team_1.3.0_Linux_x86_64.tar.gz;
		cd ..;
		rm -rf stratus*.tar.gz;
		mkdir /usr/share/opencti && cd /usr/share/opencti;
		wget https://github.com/OpenCTI-Platform/opencti/releases/download/5.1.4/opencti-release-5.1.4.tar.gz;
		tar -xzvf opencti-release-5.1.4.tar.gz;
		rm -rf opencti*.gz;
		cd /usr/share/tpvm/opencti/opencti-worker/src/;
		pip3 install -r requirements.txt;
		cd /usr/share/tpvm/;
		wget https://dist.torproject.org/torbrowser/11.0.6/tor-browser-linux64-11.0.6_en-US.tar.xz;
		tar -xf tor-browser-linux64-11.0.6_en-US.tar.xz;
		apt-get install -y openjdk-8-jre-headless;
		wget https://maltego-downloads.s3.us-east-2.amazonaws.com/linux/Maltego.v4.3.0.deb;
		dpkg -i Maltego.v4.3.0.deb;
		echo JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/environment;
		export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64";
		curl -fsSL https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -;
		echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list;
		apt update;
		apt install cassandra -y;
		curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | sudo apt-key add -;
		echo 'deb https://deb.thehive-project.org release main' | sudo tee -a /etc/apt/sources.list.d/thehive-project.list;
		apt-get update -y;
		apt-get install thehive4;
		printf "remember to configure thehive :)";
		pip3 install -U --user shodan --no-warn-script-location;
		echo "The following MISP DB Passwords were generated..." >> creds.txt;
		printf "Admin (${DBUSER_ADMIN}) DB Password: "${DBPASSWORD_ADMIN}"" >> creds.txt;
		printf "User  (${DBUSER_MISP}) DB Password: "${DBPASSWORD_MISP}"" >> creds.txt;
		sleep 5;
		#desktopentries
		show_menu;
        ;;
        3) clear;
            option_picked "Review Post setup Todo"; #not implemented
            printf "not implemented yet.. returning"; #in progress
            show_menu;
        ;;
        x)exit;
        ;;
        \n)exit;
        ;;
        *)clear;
            option_picked "Pick an option from the menu";
            show_menu;
        ;;
      esac
    fi
done
