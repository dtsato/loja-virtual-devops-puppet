import "mysql"
import "tomcat"

include mysql-client

$keystore_file = "/etc/ssl/.keystore"
$ssl_conector = {
  "port"         => 8443,
  "protocol"     => "HTTP/1.1",
  "SSLEnabled"   => true,
  "maxThreads"   => 150,
  "scheme"       => "https",
  "secure"       => "true",
  "keystoreFile" => $keystore_file,
  "keystorePass" => "secret",
  "clientAuth"   => false,
  "sslProtocol"  => "SSLv3"
}
$db_host = "192.168.33.10"
$db_schema = "loja_schema"
$db_user = "loja"
$db_password = "lojasecret"

file { "$keystore_file":
  mode    => 0644,
  source  => "/tmp/vagrant-puppet/manifests/.keystore",
}

class { "tomcat7":
  connectors => [$ssl_conector],
  require    => File[$keystore_file],
}

file { "/var/lib/tomcat7/conf/context.xml":
  owner   => root,
  group   => tomcat7,
  mode    => 0644,
  content => template("tomcat/context.xml"),
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