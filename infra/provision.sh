#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
#apt-get update
#apt-get -y upgrade
apt-get install -y apt-transport-https
touch /home/vagrant/.bashrc
echo "export EDITOR=vim" >> /home/vagrant/.bashrc
ln -s /var/lib/snapd/snap /snap
snap install microk8s --classic
microk8s.status --wait-ready


ufw allow in on cbr0
ufw allow out on cbr0
ufw default allow routed

microk8s enable dns ingress registry storage

mkdir /home/vagrant/scripts/.kube/
microk8s.kubectl config view --raw > /home/vagrant/scripts/.kube/config
snap alias microk8s.kubectl kubectl
sudo usermod -a -G microk8s vagrant
sudo chown -f -R vagrant ~/.kube

