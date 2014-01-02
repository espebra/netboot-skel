Netboot skel
============

This configuration makes it easy to deploy infrastructure required for 
netbooting.

Usage
-----

    git clone https://github.com/espebra/netboot-skel
    cd netboot-skel

Modify the netboot kickstart configuration as explained in the **Configuration** section below.

    vagrant up

The netboot image will become available as *initrd0.img* and *vmlinuz*:

* at http://192.168.50.50/image/
* in the local filesystem at /srv/image/[release]/tftpboot/

Provides
--------

* DHCP
* TFTP with iPXE
* Netboot configuration for SL6
* Script to build the ramdisk image from the netboot configuration
* Web server to serve the ramdisk image

Configuration
-------------

The configuration for the netboot image may be modified in *puppet/files/image/ks.conf*. During the next puppet run, the build process will start automatically if the file was modified. Run *vagrant up* to create the virtual machine and initiate the build or run as root inside the virtual machine:

    puppet apply /vagrant/puppet/manifests/init.pp

