#!/bin/bash
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y jq
sudo apt-get install -y ruby-full
sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python-setuptools
sudo apt-get install -y libldns-dev
sudo apt-get install -y python3-pip
sudo apt-get install -y python-pip
sudo apt-get install -y python-dnspython
sudo apt-get install -y git
sudo apt-get install -y rename
sudo apt-get install -y xargs

if [[ -z "$GOPATH" ]];then
        echo "-- OPSS, seems that go is not installed on the system !!"
        sleep 2
        echo "-- Go installation"
        wget https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz
        sudo tar -xvf go1.13.4.linux-amd64.tar.gz
        sudo mv go /usr/local
        export GOROOT=/usr/local/go
        export GOPATH=$HOME/go
        export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
        echo 'export GOROOT=/usr/local/go' >> ~/.bash_profile
        echo 'export GOPATH=$HOME/go'   >> ~/.bash_profile
        echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bash_profile
        source ~/.bash_profile
        sleep 1
fi
#home directory for all tools
mkdir ~/tools
cd ~/tools/

echo "-- httprobe Installation"
go get -u github.com/tomnomnom/httprobe
echo "-- Done it"
sleep 2

echo "-- Assetfinder Installation"
go get -u github.com/tomnomnom/assetfinder
echo "-- Done it"
sleep 1
echo "-- Sublist3r Installation"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r*
pip3 install -r requirements.txt
cd ~/tools/
echo "-- Done it"
sleep 1
echo "-- Subfinder Installation"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/cmd/subfinder
echo "--Done it"
sleep 1
echo "-- Turbolist3r Installation"
git clone https://github.com/fleetcaptain/Turbolist3r
cd Turbolist3r/
pip3 install -r requirements.txt
cd ~/tools/
echo "-- Done it"
chmod +x wies.sh
