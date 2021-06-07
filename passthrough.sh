#!/bin/bash

#Making sure this script runs with elevated privileges
if [ $EUID -ne 0 ]
	then
		echo "Please run this as root!" 
		exit 1
fi

if [ -a /sbin/vfio-pci-override-vga.sh ]
	then 
	echo "Please uninstall Passthrough Helper first! Then run passthrough.sh again."
	exit
fi

echo -e "\e[32m Installing VGA passthrough\e[0m"

echo -e "\e[32mInstalling required packages\e[0m"
xbps-install -S qemu libvirt virt-manager 

echo -e "\e[32mActivating libvirt services\e[0m"
gpasswd -a "$USER" libvirt
ln -s /etc/sv/libvirtd /var/service
ln -s /etc/sv/virtlockd /var/service
ln -s /etc/sv/virtlogd /var/service

# cpu check
virt=$(LC_ALL=C lscpu | grep Virtualization)
if virt=AMD-V
	then
	echo -e "\e[32m Using AMD cpu.\e[0m"
	echo "#Add to your GRUB_CMDLINE_LINUX_DEFAULT= amd_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1" >> /etc/default/grub
	else
	echo -e "\e[32m Using Intel cpu.\e[0m"
	echo "#Add to your GRUB_CMDLINE_LINUX_DEFAULT= intel_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1" >> /etc/default/grub
fi

# editor check
EDITOR=$EDITOR
if [ -e /bin/nano ]
then
	EDITOR=nano
elif  [ -e /bin/micro ]
then
	EDITOR=micro
else
	EDITOR=vim
fi

echo -e "\e[32m Using $EDITOR editor.\e[0m"
$EDITOR /etc/default/grub

echo -e "\e[32m Updating grub\e[0m"
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\e[32m Getting GPU passthrough scripts ready"
cp vfio-pci-override-vga.sh /usr/bin/vfio-pci-override-vga.sh
chmod 755 /usr/bin/vfio-pci-override-vga.sh

echo "install vfio-pci /usr/bin/vfio-pci-override-vga.sh" > /etc/modprobe.d/local.conf
if virt=AMD-V
	then
	cp amd.conf /etc/dracut.conf.d/local.conf
	else
	cp intel.conf /etc/dracut.conf.d/local.conf
fi

echo -e "\e[32m Generating initramfs\e[0m"
dracut -f --kver $(uname -r)

echo -e "\e[32m Getting latest ovmf from kraxel.org\e[0m"
wget -m -np -nd -A "edk2.git-ovmf-x64*.noarch.rpm" https://www.kraxel.org/repos/jenkins/edk2/
mv *.noarch.rpm edk2.git-ovmf-x64.noarch.rpm

if [ -e /bin/rpmextract ]
then
	rpmextract edk2.git-ovmf-x64.noarch.rpm
else
	xbps-install -y rpmextract
    rpmextract edk2.git-ovmf-x64.noarch.rpm
    xbps-remove -y rpmextract
fi
mv usr/share /usr/

echo -e "\e[32m Script finished\e[0m"
