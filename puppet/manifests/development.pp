# development.pp

class requirements {
  group { "puppet": ensure => "present", }
  exec { "yum-update":
    command => "/usr/bin/yum -y update --skip-broken"
  }

  yumrepo { "rpmforge":
    mirrorlist => "http://apt.sw.be/redhat/el5/en/mirrors-rpmforge",
    descr => "Red Hat Enterprise $releasever - RPMforge.net - dag",
    enabled => 1,
    gpgcheck => 0,
  }

  # add any yum packages you need installed here...
  package {
    ["ImageMagick", "git", "mysql-devel"]:
      ensure => installed, require => Exec['yum-update']
  }
}

include requirements
