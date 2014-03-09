require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'mysql::server' do
  it {
    should contain_package('mysql-server').
      with_ensure('installed')
  }

  it {
    should contain_file("/etc/mysql/conf.d/allow_external.cnf").
      with_owner('mysql').
      with_group('mysql').
      with_mode('0644').
      with_content(/bind-address = 0\.0\.0\.0/).
      that_requires("Package[mysql-server]").
      that_notifies("Service[mysql]")
  }

  it {
    should contain_service("mysql").
      with_ensure('running').
      with_hasstatus(true).
      with_hasrestart(true).
      that_requires("Package[mysql-server]")
  }

  it {
    should contain_exec("remove-anonymous-user").
      with_command(/DELETE FROM mysql.user/).
      with_onlyif("mysql -u' '").
      with_path("/usr/bin").
      that_requires("Service[mysql]")
  }
end