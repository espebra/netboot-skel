Netboot skel
============

This configuration makes it easy to deploy infrastructure required for 
netbooting.

Usage
-----

  git clone https://github.com/espebra/netboot-skel
  cd netboot-skel
  vagrant up

Provides
--------

* DHCP
* TFTP with iPXE
* Netboot configuration for SL6
* Script to build the ramdisk image from the netboot configuration
* Web server to serve the ramdisk image

