require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'mysql::client' do
  it {
    should contain_package('mysql-client').with_ensure('installed')
  }
end