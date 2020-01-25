# passthrough_helper_void
GPU passthrough helper

sudo su
chmod +x and run gpu_passthrough.sh

after script exit su

sudo gpasswd -a "$USER" libvirt - Will add current user to libvirt group
 
For instructions go to https://www.youtube.com/watch?v=Cssen5-QCk0&t=263s

Source of vfio-pci-override-vga.sh is http://vfio.blogspot.com/2015/05/
