class mysql-server {
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
    content => template("/tmp/vagrant-puppet/manifests/allow_ext.cnf"),
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

define mysql-db($schema, $user = $title, $password) {
  Class['mysql-server'] -> Mysql-db[$title]

  exec { "$title-schema":
    unless  => "mysql -uroot $schema",
    command => "mysqladmin -uroot create $schema",
    path    => "/usr/bin/",
  }

  exec { "$title-user":
    unless  => "mysql -u$user -p$password $schema",
    command => "mysql -uroot -e \"GRANT ALL PRIVILEGES ON \
                                  $schema.* TO $user \
                                  IDENTIFIED BY '$password';\"",
    path    => "/usr/bin/",
    require => Exec["$title-schema"],
  }
}

include mysql-server

mysql-db { "loja":
  schema   => "loja_schema",
  password => "loja_secret",
}