# Passthrough helper void

This is a simple script that makes your system ready to run a KVM/QEMU virtual machine with its own GPU.

2 GPUs are needed. One of the GPUs can be an iGPU.

Instructions:

# sudo su
# chmod +x gpu_passthrough.sh
# ./gpu_passthrough.sh
after script
# exit

- Detected cpu: Amd else using Intel
- Detected editor: nano, micro else using vim
- Export "#Add to your GRUB_CMDLINE_LINUX_DEFAULT= amd_iommu=on rd.driver.pre=vfio-pci kvm.ignore_msrs=1" line to grub, so you can easily copy in editor.
- Auto download and extract latest OVMF from kraxel.org

For instructions go to https://www.youtube.com/watch?v=Cssen5-QCk0&t=263s

Source of vfio-pci-override-vga.sh is http://vfio.blogspot.com/2015/05/

Used script from https://github.com/pavolelsig/passthrough_helper_fedora
