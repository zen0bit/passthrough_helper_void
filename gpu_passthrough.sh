#!/bin/bash

echo -e "\e[32mInstalling required packages\e[0m"
xbps-install -S qemu libvirt virt-manager 

echo -e "\e[32mActivating libvirt services\e[0m"
gpasswd -a "$USER" libvirt
ln -s /etc/sv/libvirtd /var/service
ln -s /etc/sv/virtlockd /var/service
ln -s /etc/sv/virtlogd /var/service

echo "#GRUB_CMDLINE_LINUX_DEFAULT= CHOOSE intel_iommu=on OR amd_iommu=on AND ADD rd.driver.pre=vfio-pci kvm.ignore_msrs=1" >> /etc/default/grub
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
echo -e "\e[32mUsing $EDITOR editor.\e[0m"
$EDITOR /etc/default/grub

echo -e "\e[32mUpdating grub\e[0m"
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\e[32mGetting GPU passthrough scripts ready\e[0m"
cp vfio-pci-override-vga.sh /usr/bin/vfio-pci-override-vga.sh
chmod 755 /usr/bin/vfio-pci-override-vga.sh

echo "install vfio-pci /usr/bin/vfio-pci-override-vga.sh" > /etc/modprobe.d/local.conf
cp local.conf /etc/dracut.conf.d/local.conf

echo -e "\e[32mGenerating initramfs\e[0m"
dracut -f --kver $(uname -r)

echo -e "\e[32mScript finished.\e[0m"
