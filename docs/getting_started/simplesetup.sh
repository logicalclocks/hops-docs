#!/usr/bin/env bash
INSTALL_DEPENDENCIES=false
DOWNLOAD_DIR=/tmp

if [ "$1" == "--install-deps" ] ; then
  INSTALL_DEPENDENCIES=true
  echo "Will install dependencies, will ask for super user priviledges"
fi

if [ "$INSTALL_DEPENDENCIES" = true ] ; then
  echo "Installing dependencies"
  echo "Installing vagrant..."
  wget -P $DOWNLOAD_DIR https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb
  sudo dpkg -i $DOWNLOAD_DIR/vagrant_2.0.2_x86_64.deb
  echo "Installing virtualbox..."
  wget -P $DOWNLOAD_DIR https://download.virtualbox.org/virtualbox/5.2.6/virtualbox-5.2_5.2.6-120293~Ubuntu~xenial_amd64.deb
  sudo dpkg -i $DOWNLOAD_DIR/virtualbox-5.2_5.2.6-120293~Ubuntu~xenial_amd64.deb

  echo "Completing dependency installation"
  sudo apt -f -y install

  echo "Dependency installation completed successfully"
fi

echo "Getting the installer"
git clone https://github.com/hopshadoop/karamel-chef.git

echo "Creating VM"
cd karamel-chef
./run.sh ubuntu 1 hopsworks

HOPSWORKS_PORT=$(./run.sh ports | grep "8080 ->" | awk '{print $3}') 

echo "Removing installers"
rm $DOWNLOAD_DIR/vagrant_2.0.2_x86_64.deb
rm $DOWNLOAD_DIR/chefdk_2.4.17-1_amd64.deb
rm $DOWNLOAD_DIR/virtualbox-5.2_5.2.6-120293~Ubuntu~xenial_amd64.deb

echo "VM Initialization started. Run \"tail -f karamel-chef/nohup.out\" to track progress."
echo "Once you see the success message, navigate to 127.0.0.1:$HOPSWORKS_PORT/hopsworks"
echo "on your host machine with credentials user: admin@hopsworks.ai password: admin"

