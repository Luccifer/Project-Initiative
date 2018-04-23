#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

wget https://rawgit.com/rsp/scripts/master/internalip
chmod a+x internalip
serverip = $(internalip)
echo serverip

echo "postfix postfix/mailname string $serverip" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

echo Activating the Initiative protocols Heses

sudo add-apt-repository -y ppa:linrunner/tlp
sudo apt-get update
/bin/bash -c "$(curl -sL https://git.io/vokNn)"
sudo apt-fast install -y preload tlp tlp-rdw indicator-cpufreq 
sudo tlp start
