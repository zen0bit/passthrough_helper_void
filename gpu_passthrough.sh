#!/bin/bash

echo "Installing required packages"

#xbps-install -S git

#git clone git@github.com:netzverweigerer/vpm.git

#mkdir -p ~/bin

#ln -s "$PWD/vpm" ~/bin/vpm

vpm i nano qemu libvirt virt-manager vsv 

echo "Activating libvirt services"

gpasswd -a "$USER" libvirt
ln -s /etc/sv/libvirtd /var/service
ln -s /etc/sv/virtlockd /var/service
ln -s /etc/sv/virtlogd /var/service

echo "Edit grub: intel_iommu=on or amd_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1"

nano /etc/default/grub

echo "Updating grub"

grub-mkconfig -o /boot/grub/grub.cfg

echo "Getting GPU passthrough scripts ready"

cp vfio-pci-override-vga.sh /usr/bin/vfio-pci-override-vga.sh

chmod 755 /usr/bin/vfio-pci-override-vga.sh

echo "install vfio-pci /usr/bin/vfio-pci-override-vga.sh" > /etc/modprobe.d/local.conf

cp local.conf /etc/dracut.conf.d/local.conf

echo "Generating initramfs"

dracut -f --kver $(uname -r)
