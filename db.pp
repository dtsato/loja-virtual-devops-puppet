import "mysql"

include mysql-server

mysql-db { "loja":
  schema   => "loja_schema",
  password => "loja_secret",
}