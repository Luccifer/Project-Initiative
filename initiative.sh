#!/bin/bash
echo Activating the Initiative protocols Heses

sudo add-apt-repository -y ppa:linrunner/tlp
sudo apt-get update
/bin/bash -c "$(curl -sL https://git.io/vokNn)"
sudo apt-fast install -y preload tlp tlp-rdw indicator-cpufreq 
sudo tlp start
