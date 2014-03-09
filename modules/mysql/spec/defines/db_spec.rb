require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'mysql::db' do
  let(:pre_condition) { 'class { "mysql::server": }' }

  context "with specified user" do
    let(:title) { "db-with-user" }

    let(:params) {
      {
        :user => "user",
        :schema => "schema",
        :password => "secret"
      }
    }

    it "should create schema" do
      should contain_exec("db-with-user-schema").
        with_unless("mysql -uroot schema").
        with_command("mysqladmin -uroot create schema").
        with_path("/usr/bin/")
    end

    it "should create user with permission" do
      should contain_exec("db-with-user-user").
        with_unless("mysql -uuser -psecret schema").
        with_command(/GRANT ALL PRIVILEGES ON /).
        with_command(/schema\.\* TO 'user'@'%'/).
        with_command(/IDENTIFIED BY 'secret';/).
        with_path("/usr/bin/").
        that_requires("Exec[db-with-user-schema]")
    end
  end

  context "without user" do
    let(:title) { "db-without-user" }

    let(:params) {
      {
        :schema => "schema",
        :password => "secret"
      }
    }

    it "should create schema" do
      should contain_exec("db-without-user-schema").
        with_unless("mysql -uroot schema").
        with_command("mysqladmin -uroot create schema").
        with_path("/usr/bin/")
    end

    it "should create user with permission" do
      should contain_exec("db-without-user-user").
        with_unless("mysql -udb-without-user -psecret schema").
        with_command(/GRANT ALL PRIVILEGES ON /).
        with_command(/schema\.\* TO 'db-without-user'@'%'/).
        with_command(/IDENTIFIED BY 'secret';/).
        with_path("/usr/bin/").
        that_requires("Exec[db-without-user-schema]")
    end
  end
end