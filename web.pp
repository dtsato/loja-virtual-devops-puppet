exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

package { ["mysql-client", "tomcat7"]:
  ensure  => installed,
  require => Exec["apt-update"],
}

file { "/var/lib/tomcat7/conf/.keystore":
  owner   => root,
  group   => tomcat7,
  mode    => 0640,
  source  => "/tmp/vagrant-puppet/manifests/.keystore",
  require => Package["tomcat7"],
  notify  => Service["tomcat7"],
}

file { "/var/lib/tomcat7/conf/server.xml":
  owner   => root,
  group   => tomcat7,
  mode    => 0644,
  source  => "/tmp/vagrant-puppet/manifests/server.xml",
  require => Package["tomcat7"],
  notify  => Service["tomcat7"],
}

file { "/etc/default/tomcat7":
  owner   => root,
  group   => root,
  mode    => 0644,
  source  => "/tmp/vagrant-puppet/manifests/tomcat7",
  require => Package["tomcat7"],
  notify  => Service["tomcat7"],
}

service { "tomcat7":
  ensure     => running,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
  require    => Package["tomcat7"],
}

$db_host = "192.168.33.10"
$db_schema = "loja_schema"
$db_user = "loja"
$db_password = "lojasecret"

file { "/var/lib/tomcat7/conf/context.xml":
  owner   => root,
  group   => tomcat7,
  mode    => 0644,
  content => template("/tmp/vagrant-puppet/manifests/context.xml"),
  require => Package["tomcat7"],
  notify  => Service["tomcat7"],
}

file { "/var/lib/tomcat7/webapps/devopsnapratica.war":
  owner   => tomcat7,
  group   => tomcat7,
  mode    => 0644,
  source  => "/tmp/vagrant-puppet/manifests/devopsnapratica.war",
  require => Package["tomcat7"],
  notify  => Service["tomcat7"],
}