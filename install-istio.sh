#!/bin/bash
# Sets up your Azure Cloud Shell to use ISTIOCTL
# AUTHOR:   Chad Theis
# DATE:     6/17/2019
# Excute this script from your Azure Cloud shell to setup the ISTIO command line.  


BIN="~/bin"
ISTIO_VERSION=1.1.3

if [ -d ~/bin ] ;
then
    echo "Local bin exists"
else
    echo "Setting up local bin...."
    mkdir ~/bin
    chmod +x ~/bin
    echo "PATH=$PATH:~/bin" >> ~/.bashrc
    echo "Created local bin and added it to the PATH"
fi
echo " "


echo "Setting up Istio Control ...."

echo " - Downloading istio"
curl -sL "https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-linux.tar.gz" | tar xz
cd istio-$ISTIO_VERSION

echo " - Copying to local bin"
cp bin/istioctl ~/bin
echo "Istio Control Setup"
echo " "


echo "Setting up bash completion ..."

echo " - Generating completion file..."
mkdir -p ~/completions && istioctl collateral --bash -o ~/completions
source ~/completions/istioctl.bash

if grep -q "istioctl" ~/.bashrc; 
then
    echo " - Istio bash already setup in bashrc"
else
    echo "source ~/completions/istioctl.bash" >> ~/.bashrc
fi
echo "Bash completion setup complete. Restart your cloud shell to apply the changes."
cd ..


