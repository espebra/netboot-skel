# Packages
$packages = [ 'epel-release', 'nginx', 'livecd-tools' ]
package {
    $packages: 
        require => Yumrepo["epel"],
        ensure  => installed;
}

# Repositories
yumrepo {
    "epel":
        descr     => "epel",
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
    "nginx": ;
    "iptables": ;
}

File {
    require => Package[$packages],
    owner   => "root",
    group   => "root",
}

# Files
file {
    "/etc/sysconfig/iptables":
        ensure  => "present",
        source  => "/vagrant/puppet/files/iptables/iptables",
        notify  => Service["iptables"];
    "/etc/nginx/conf.d/default.conf":
        ensure  => "present",
        source  => "/vagrant/puppet/files/nginx/default.conf",
        notify  => Service["nginx"];
    "/etc/motd":
        mode    => 444,
        content => "\nThe latest version of the netboot image should be available in\n/vagrant/images/\n\n";
    "/etc/profile.d/path.sh":
        mode    => 555,
        content => 'export PATH="$PATH:/vagrant/tools"';
}

