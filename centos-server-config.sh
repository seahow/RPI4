#!/bin/bash -x

#test hello

growpart /dev/mmcblk0 3
resize2fs /dev/mmcblk0p3
sed -ibak -e 's/PasswordAuthentication no/#PasswordAuthentication no/g' -e 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' -e 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' -e 's/#AllowAgentForwarding yes/AllowAgentForwarding yes/g' /etc/ssh/sshd_config
systemctl enable sshd
systemctl restart sshd
dnf install tar -y
dnf install expect -y
dnf install lsof -y
useradd centos
usermod -g wheel centos
echo "centos    ALL=(ALL:ALL)   ALL" >>/etc/sudoers
./setpassroot.sh
./setpasscentos.sh
dnf config-manager --enable PowerTools
dnf config-manager --enable centosplus
dnf config-manager --enable HighAvailability
dnf config-manager --enable extras
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
dnf clean all
dnf update -y
sed -i "s/enforcing/disabled/g" /etc/selinux/config
mkdir -p /opt/aws/scripts
mkdir -p /mnt/iso /var/www/html /opt/aws/bin /var/awslogs/state
dnf install netpbm -y
dnf install wget -y
dnf install gcc -y
dnf install python3 -y
dnf install nfs-utils -y
dnf install parallel -y
dnf install sysfsutils -y
dnf install iftop -y
dnf install iotop -y
dnf install unzip -y
dnf install cmake -y
dnf install lm_sensors -y
dnf install lua5.1 -y
dnf install iw -y
dnf install alsa-utils -y
dnf install dracut-tools -y
dnf install mlocate -y
updatedb
dnf install cockpit-* -y
dnf install mod_ssl -y
systemctl enable --now cockpit.socket
systemctl start --now cockpit.socket
systemctl disable sssd
dnf install awscli -y
rpm -Uvh https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
rpm -Uvh --quiet https://s3.amazonaws.com/amazoncloudwatch-agent/redhat/arm64/latest/amazon-cloudwatch-agent.rpm
sed -i 's/.*DefaultLimitNOFILE=.*/DefaultLimitNOFILE=16384/g' /etc/systemd/system.conf
systemctl disable firewalld
systemctl stop firewalld
echo "tmpfs   /var/log    tmpfs    defaults,noatime,nosuid,mode=0755,size=100m    0 0" >>/etc/fstab
mount -a
dnf groupinstall "XFCE" --with-optional --hidden -y
dnf install chromium -y
dnf install flatpak -y
dnf flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
touch /etc/yum.repos.d/webmin.repo
echo "[Webmin]" >>/etc/yum.repos.d/webmin.repo
echo "name=Webmin Distribution Neutral" >>/etc/yum.repos.d/webmin.repo
echo "mirrorlist=https://download.webmin.com/download/yum/mirrorlist" >>/etc/yum.repos.d/webmin.repo
echo "enabled=1" >>/etc/yum.repos.d/webmin.repo
wget http://www.webmin.com/jcameron-key.asc
rpm --import jcameron-key.asc
dnf install webmin -y
dnf install gnome-software -y
dnf install tigervnc-server tigervnc-server-module -y
echo ":1=root" >>/etc/tigervnc/vncserver.users
# echo ":2=centos" >>/etc/tigervnc/vncserver.users
echo "session=xfce" >>/etc/tigervnc/vncserver-config-mandatory
# echo "session=gnome" >>/etc/tigervnc/vncserver-config-mandatory
echo "securitytypes=vncauth,tlsvnc" >>/etc/tigervnc/vncserver-config-mandatory
echo "desktop=sandbox" >>/etc/tigervnc/vncserver-config-mandatory
echo "geometry=1920x1280" >>/etc/tigervnc/vncserver-config-mandatory
./vncpasswd.sh
systemctl enable vncserver@:1.service
systemctl start vncserver@:1.service
# systemctl enable vncserver@:2.service
# systemctl start vncserver@:2.service
vncsession root :1
# vncsession centos :1
systemctl set-default multi-user.target
systemctl disable sssd
systemctl disable firewalld
systemctl disable sssd-kcm
systemctl disable kdump
systemctl disable auditd
dnf install flatpak snapd -y
systemctl enable snapd.socket --now
sleep 10
snap install snap-store
reboot
