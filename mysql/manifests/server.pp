class mysql::server {
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  package { "mysql-server":
    ensure  => installed,
    require => Exec["apt-update"],
  }

  file { "/etc/mysql/conf.d/allow_external.cnf":
    owner   => mysql,
    group   => mysql,
    mode    => 0644,
    content => template("mysql/allow_ext.cnf"),
    require => Package["mysql-server"],
    notify  => Service["mysql"],
  }

  service { "mysql":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["mysql-server"],
  }

  exec { "remove-anonymous-user":
    command => "mysql -uroot -e \"DELETE FROM mysql.user \
                                  WHERE user=''; \
                                  FLUSH PRIVILEGES\"",
    onlyif  => "mysql -u' '",
    path    => "/usr/bin",
    require => Service["mysql"],
  }
}