class mysql::client {
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  package { "mysql-client":
    ensure  => installed,
    require => Exec["apt-update"],
  }
}