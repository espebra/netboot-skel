Netboot skel
============

This configuration makes it easy to deploy infrastructure required for 
netbooting.

Usage
-----

    git clone https://github.com/espebra/netboot-skel
    cd netboot-skel

Modify the default netboot kickstart configuration or add your own as explained in the **Configuration** section below.

    vagrant up

The netboot image will become available as *initrd0.img* and *vmlinuz0*:

* at http://192.168.50.50/
* in the local filesystem at /vagrant/images/

Configuration
-------------

The configuration for the netboot image may be modified in *ks/default.conf*, or you may add your own (remember to suffix the filename with .conf). The configuration file(s) will be built at the next boot or if the script */vagrant/tools/build* script is executed manually.

