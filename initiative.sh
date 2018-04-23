#!/bin/bash
#--------supress most of userinteraction------------#
export DEBIAN_FRONTEND=noninteractive

#----------------server ip getter-------------------#
wget https://rawgit.com/rsp/scripts/master/internalip
chmod a+x internalip
serverip = "$(internalip)"

#------supress userinteraction in mail, slapd--------#
echo "postfix postfix/mailname string $serverip" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
debconf-set-selections <<< 'slapd/root_password password 123'
debconf-set-selections <<< 'slapd/root_password_again 123'

echo Activating the Initiative protocols Hades

sudo add-apt-repository -y ppa:linrunner/tlp
sudo apt-get update
/bin/bash -c "$(curl -sL https://git.io/vokNn)" #apt-fast install
sudo apt-fast install -y preload tlp tlp-rdw indicator-cpufreq zsh  git-core
sudo tlp start

echo Activating the Initiative protocols Gaia
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh #zsh install

sudo apt-fast install -yslapd ldap-utils #install LDAP server


chsh -s `which zsh`
sudo shutdown -r 0
