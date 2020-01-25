#!/bin/bash

echo "Installing required packages"

vpm i nano qemu libvirt virt-manager

echo "Edit grub: intel_iommu=on or amd_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1"

nano /etc/default/grub

echo "Updating grub"

update-grub

echo "Getting GPU passthrough scripts ready"

cp vfio-pci-override-vga.sh /sbin/vfio-pci-override-vga.sh

chmod 755 /sbin/vfio-pci-override-vga.sh

echo "install vfio-pci /sbin/vfio-pci-override-vga.sh" > /etc/modprobe.d/local.conf

cp local.conf /etc/dracut.conf.d/local.conf

echo "Generating initramfs"

dracut -f --kver `uname -r`
