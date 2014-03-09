require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe 'tomcat::server' do
  it {
    should contain_package('tomcat7').
      with_ensure('installed')
  }

  it {
    should contain_file("/etc/default/tomcat7").
      with_owner('root').
      with_group('root').
      with_mode('0644').
      with_source('puppet:///modules/tomcat/tomcat7').
      that_requires("Package[tomcat7]").
      that_notifies("Service[tomcat7]")
  }

  it {
    should contain_service("tomcat7").
      with_ensure('running').
      with_enable(true).
      with_hasstatus(true).
      with_hasrestart(true).
      that_requires("Package[tomcat7]")
  }

  context "with default parameters" do
    it {
      should contain_file("/var/lib/tomcat7/conf/server.xml").
        with_owner('root').
        with_group('tomcat7').
        with_mode('0644').
        that_requires("Package[tomcat7]").
        that_notifies("Service[tomcat7]")
    }

    it {
      should contain_file("/var/lib/tomcat7/conf/context.xml").
        with_owner('root').
        with_group('tomcat7').
        with_mode('0644').
        that_requires("Package[tomcat7]").
        that_notifies("Service[tomcat7]")
    }
  end

  context "with extra connectors" do
    let(:ssl_connector) {
      {
        'port'        => 8443,
        'scheme'      => "https",
        'sslProtocol' => "SSLv3"
      }
    }
    let(:params) {
      { :connectors => [ssl_connector] }
    }

    it {
      should contain_file("/var/lib/tomcat7/conf/server.xml").
        with_content(/<Connector port='8443' scheme='https' sslProtocol='SSLv3' \/>/)
    }
  end

  context "with extra data sources" do
    let(:db) {
      {
        'user'     => 'user',
        'password' => 'secret',
        'schema'   => 'schema',
        'driver'   => 'driver',
        'url'      => 'jdbc://',
      }
    }
    let(:params) {
      { :data_sources => {"jdbc/web" => db} }
    }

    it {
      should contain_file("/var/lib/tomcat7/conf/context.xml").
        with_content(/<Resource name="jdbc\/web" auth="Container"/).
        with_content(/username="user"/).
        with_content(/password="secret"/).
        with_content(/driverClassName="driver"/).
        with_content(/url="jdbc:\/\/schema"\/>/)
    }
  end
end