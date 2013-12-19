# Packages
$packages = [ 'epel-release', 'dhcp', 'xinetd', 'tftp-server', 'nginx', 
              'livecd-tools' ]
package {
    $packages: 
        require => Yumrepo["epel"],
        ensure  => installed;
}

# Repositories
yumrepo {
    "epel":
        name      => "epel",
        baseurl   => "http://dl.fedoraproject.org/pub/epel/6/x86_64/",
        enabled   => 1,
        gpgcheck  => 1,
        gpgkey    => "https://fedoraproject.org/static/0608B895.txt";
}

# Services
Service {
    require    => Package[$packages],
    enable     => true,
    ensure     => true,
    hasrestart => true,
}

service {
    "xinetd": ;
    "dhcpd": ;
    "nginx": ;
    "iptables": ;
}

File {
    require => Package[$packages],
    owner   => "root",
    group   => "root",
}

# Directory structure
file {
    "/srv":
        ensure  => "directory";
    "/srv/www":
        ensure  => "directory",
        require => File["/srv"];
    "/srv/image":
        ensure  => "directory",
        require => File["/srv"];
    "/srv/tftp":
        ensure  => "link",
        target  => "/var/lib/tftpboot";
}

# Files
file {
    "/etc/sysconfig/iptables":
        ensure  => "present",
        source  => "/vagrant/puppet/files/iptables/iptables",
        notify  => Service["iptables"];
    "/etc/dhcp/dhcpd.conf":
        ensure  => "present",
        source  => "/vagrant/puppet/files/dhcp/dhcpd.conf",
        notify  => Service["dhcpd"];
    "/etc/nginx/conf.d/default.conf":
        ensure  => "present",
        source  => "/vagrant/puppet/files/nginx/default.conf",
        notify  => Service["nginx"];
    "/usr/local/sbin/build-image":
        ensure  => "present",
        mode    => 555,
        source  => "/vagrant/puppet/files/image/build-image";
    "/srv/image/ks.conf":
        ensure  => "present",
        source  => "/vagrant/puppet/files/image/ks.conf",
        notify  => Exec["build-image"];
    "/srv/tftp/undionly.kpxe":
        ensure  => "present",
        source  => "/vagrant/puppet/files/ipxe/undionly.kpxe",
        require => File["/srv/tftp"];
    "/srv/www/ipxe.conf":
        ensure  => "present",
        source  => "/vagrant/puppet/files/ipxe/ipxe.conf";
}

# Commands
exec {
    "build-image":
        command     => "/usr/local/sbin/build-image",
        user        => "root",
        refreshonly => "true",
        timeout     => 0,
        require     => File["/usr/local/sbin/build-image"];
}

