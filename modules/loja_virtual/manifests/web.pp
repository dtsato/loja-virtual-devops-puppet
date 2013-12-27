class loja_virtual::web inherits loja_virtual {
  include mysql::client
  include loja_virtual::params

  file { $loja_virtual::params::keystore_file:
    mode    => 0644,
    source  => "puppet:///modules/loja_virtual/.keystore",
  }

  class { "tomcat::server":
    connectors => [$loja_virtual::params::ssl_connector],
    data_sources => {
      "jdbc/web"     => $loja_virtual::params::db,
      "jdbc/secure"  => $loja_virtual::params::db,
      "jdbc/storage" => $loja_virtual::params::db,
    },
    require => File[$loja_virtual::params::keystore_file],
  }

  file { "/var/lib/tomcat7/webapps/devopsnapratica.war":
    owner   => tomcat7,
    group   => tomcat7,
    mode    => 0644,
    source  => "puppet:///modules/loja_virtual/devopsnapratica.war",
    require => Package["tomcat7"],
    notify  => Service["tomcat7"],
  }
}