echo "Installing vagrant"
wget https://releases.hashicorp.com/vagrant/2.0.2/vagrant_2.0.2_x86_64.deb
sudo dpkg -i vagrant_2.0.2_x86_64.deb

echo "Installing chefdk"
wget  https://packages.chef.io/files/current/chefdk/2.4.17/ubuntu/16.04/chefdk_2.4.17-1_amd64.deb
sudo dpkg -i chefdk_2.4.17-1_amd64.deb

echo "Installing virtualbox"
wget https://download.virtualbox.org/virtualbox/5.2.6/virtualbox-5.2_5.2.6-120293~Ubuntu~xenial_amd64.deb
sudo dpkg -i virtualbox-5.2_5.2.6-120293~Ubuntu~xenial_amd64.deb

echo "Getting the installer"
git clone https://github.com/hopshadoop/karamel-chef.git

echo "Creating VM"
cd karamel-chef
./run.sh ubuntu 1 hopsworks

echo 'VM Initialization started. Run "tail -f karamel-chef/nohup" to track progress.'
echo 'Once you see the success message, navigate to 127.0.0.1:8080/hopsworks'
echo 'with credentials user: admin@kth.se password: admin'