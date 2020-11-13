# Passthrough helper void

This is a simple script that makes your system ready to run a KVM/QEMU virtual machine with its own GPU.

2 GPUs are needed. One of the GPUs can be an iGPU.

sudo su
chmod +x gpu_passthrough.sh
./gpu_passthrough.sh

after script exit su
 
For instructions go to https://www.youtube.com/watch?v=Cssen5-QCk0&t=263s

Source of vfio-pci-override-vga.sh is http://vfio.blogspot.com/2015/05/
