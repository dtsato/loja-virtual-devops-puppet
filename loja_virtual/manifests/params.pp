class loja_virtual::params {
  $keystore_file = "/etc/ssl/.keystore"

  $ssl_connector = {
    "port"         => 8443,
    "protocol"     => "HTTP/1.1",
    "SSLEnabled"   => true,
    "maxThreads"   => 150,
    "scheme"       => "https",
    "secure"       => "true",
    "keystoreFile" => $keystore_file,
    "keystorePass" => "secret",
    "clientAuth"   => false,
    "sslProtocol"  => "SSLv3",
  }

  $db = {
    "user"     => "loja",
    "password" => "lojasecret",
    "schema"   => "loja_schema",
    "driver"   => "com.mysql.jdbc.Driver",
    "url"      => "jdbc:mysql://192.168.33.10:3306/",
  }
}
