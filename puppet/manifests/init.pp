# Packages
$packages = [ 'dhcp', 'xinetd', 'tftp-server', 'nginx', 'livecd-tools' ]
package {
    $packages: 
        require => Yumrepo["epel"],
        ensure  => installed;
}

# Repositories
yumrepo {
    "epel":
        name     => "epel",
        baseurl  => "http://dl.fedoraproject.org/pub/epel/6/x86_64/",
        require  => Exec["import-gpg-key"],
        enabled  => 1,
        gpgcheck => 1;
}

# Services
Service {
    require => Package[$packages],
    enable     => true,
    ensure     => true,
    hasrestart => true,
}

service {
    "xinetd": ;
    "dhcpd": ;
    "nginx": ;
}

File {
    require => Package[$packages],
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
    "/srv/image/tftpboot":
        ensure  => "directory",
        require => File["/srv/image"];
    "/srv/www/image":
        ensure  => "link",
        require => File["/srv/image/tftpboot"],
        target  => "/srv/image/tftpboot";
}

# Files
file {
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
    "import-gpg-key":
        command     => "/bin/rpm --import https://fedoraproject.org/static/0608B895.txt",
        user        => "root";
}

