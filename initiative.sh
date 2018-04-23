#!/bin/bash
echo Activating the Initiative protocols Heses

sudo add-apt-repository ppa:apt-fast/stable
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install -y apt-fast 
sudo apt-fast install -y preload tlp tlp-rdw indicator-cpufreq 
sudo tlp start
