Netboot skel
============

This configuration makes it easy to build EL6 ramdisk images.

Usage
-----

    git clone https://github.com/espebra/netboot-skel
    cd netboot-skel

Put your kickstarts file in the *ks* directory, or modify the example kickstart file *default.conf*. The kickstart files must have the suffix *.conf*.

Create the virtual machine using

    vagrant up

When the virtual machine has been built, log into it and execute the build script:

    vagrant ssh
    sudo -i build

The netboot images will become available as *initrd0.img* and *vmlinuz0* in separate directories:

* at http://192.168.50.50/
* in the local filesystem at /vagrant/images/

Post script
-----------

The build process will look for files with the suffix *.post* in the *ks* directory. If there is a kickstart configuration called *example.conf* and a post script file called *example.post*, the post script will be executed with the target directory as the argument, i.e.:

    /vagrant/ks/example.post /vagrant/images/example/

These post scripts can distribute the builds to an external web server, manage versioning, etc.

Sample ipxe configuration
-------------------------

    #!ipxe
    initrd http://example.com/initrd0.img
    kernel http://example.com/vmlinuz0 rootflags=loop initrd=/initrd0.img root=/default.iso rootfstype=auto rw liveimg toram size=4096
    boot


