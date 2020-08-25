#!/bin/bash

if [ -e /dev/nvme1n1 ]; then
  blkid /dev/nvme1n1
  if [ $? -eq 0 ];then
     mkfs.xfs /dev/nvme1n1
  fi
  mkdir -p /var/lib/jenkins
  mount /dev/nvme1n1 /var/lib/jenkins
fi

yum install java -y

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y

echo 2.0 >/var/lib/jenkins/jenkins.install.UpgradeWizard.state
mkdir -p /var/lib/jenkins/init.groovy.d
cp /tmp/02admin-user.groovy /var/lib/jenkins/init.groovy.d
cp /tmp/01plugins.groovy /var/lib/jenkins/init.groovy.d
cp /tmp/03authorize.groovy /var/lib/jenkins/init.groovy.d

chown -R jenkins:jenkins /var/lib/jenkins

systemctl enable jenkins
systemctl start jenkins

if [ -e /dev/nvme1n1 ]; then
    echo /dev/nvme1n1 /var/lib/jenkins xfs defaults 0 0 >>/etc/fstab
fi