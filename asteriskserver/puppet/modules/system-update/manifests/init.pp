class system-update {
  exec { "add epel":
    command => "rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
  }

  exec { "group remove":
    command => "yum -y groupremove 'FCoE Storage Client' 'iSCSI Storage Client' 'Network file system client' 'Storage Availability Tools'"
  }

  exec { "package remove":
    command => "yum -y remove audit rpcbind selinux-policy selinux-policy-targeted"
  }

  exec { "pip upgrade":
    command => "pip install --upgrade pip",
    require => Package["python-pip"]
  }

  exec { "pip install":
    command => "pip install boto3",
    require => Package["python-pip"]
  }

  # XXX puppet is throwing an error trying to verify python-yaml, package
  # appears to be installed anyway
  # TODO trim down the base install, many of these are not used
  $base_packages = ["man", "vim-enhanced", "gcc",
                    "gcc-c++", "make", "automake",
                    "libtool", "autoconf", "mlocate",
                    "lynx", "cvs", "git", "subversion",
                    "strace", "ltrace", "wget", "lsof",
                    "tcpdump", "openssh", "openssh-server",
                    "openssh-clients", "openssl-devel",
                    "ncurses-devel", "libxml2-devel",
                    "newt-devel", "kernel-devel", "sqlite-devel",
                    "libuuid-devel", "festival", "logwatch",
                    "cyrus-sasl-plain", "python-yaml", "python-pip"]
  package { $base_packages:
    ensure  => "installed",
    require => Exec["add epel", "package remove"]
  }
}

class yum-update {
  exec { "update":
    command => "yum -y update",
  }
}
