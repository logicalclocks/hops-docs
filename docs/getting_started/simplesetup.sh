#!/usr/bin/env bash
INSTALL_DEPENDENCIES=false
DOWNLOAD_DIR=/tmp

if [ "$1" == "--install-deps" ] ; then
  INSTALL_DEPENDENCIES=true
  echo "Will install dependencies, will ask for super user priviledges"
fi

if [ "$INSTALL_DEPENDENCIES" = true ] ; then
  echo "Updating apt"
  sudo apt-get update
  echo "Installing dependencies"
  echo "Installing virtualbox..."
  sudo apt install virtualbox
  echo "Installing vagrant..."
  wget -P $DOWNLOAD_DIR https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb
  sudo dpkg -i $DOWNLOAD_DIR/vagrant_2.2.4_x86_64.deb
  sudo apt-get -f -y install
  echo "Installing chefdk..."
  wget -P $DOWNLOAD_DIR https://packages.chef.io/files/stable/chefdk/2.3.1/ubuntu/16.04/chefdk_2.3.1-1_amd64.deb
  sudo dpkg -i $DOWNLOAD_DIR/chefdk_2.3.1-1_amd64.deb
  sudo apt-get -f -y install

  echo "Dependency installation completed successfully"
fi

echo "Getting the installer"
git clone https://github.com/logicalclocks/karamel-chef.git

echo "Creating VM"
cd karamel-chef
./run.sh ubuntu 1 hopsworks-2.0

HOPSWORKS_PORT=$(./run.sh ports | grep "8181 ->" | awk '{print $3}') 

echo "Removing installers"
rm $DOWNLOAD_DIR/vagrant_2.2.4_x86_64.deb
rm $DOWNLOAD_DIR/chefdk_2.3.1-1_amd64.deb
#rm $DOWNLOAD_DIR/virtualbox-6.0_6.0.8-130520~Ubuntu~bionic_amd64.deb

echo "VM Initialization started. Run \"tail -f karamel-chef/nohup.out\" to track progress."
echo "Once you see the success message, navigate to https://127.0.0.1:$HOPSWORKS_PORT/hopsworks"
echo "on your host machine with credentials user: admin@hopsworks.ai password: admin"
