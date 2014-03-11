# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.librarian_puppet.puppetfile_dir = "librarian"

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_KEYPAIR_NAME']

    aws.ami = "ami-a18c8fc8"
    aws.user_data = File.read("bootstrap.sh")
    aws.subnet_id = ENV['AWS_SUBNET_ID']
    aws.elastic_ip = true

    override.vm.box = "dummy"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
  end

  config.vm.define :db do |db_config|
    db_config.vm.network :private_network, :ip => "192.168.33.10"
    db_config.vm.provider :aws do |aws|
      aws.private_ip_address = "192.168.33.10"
      aws.tags = { 'Name' => 'Db' }
    end
    db_config.vm.provision "puppet" do |puppet|
      puppet.module_path = ["modules", "librarian/modules"]
      puppet.manifest_file = "db.pp"
    end
  end

  config.vm.define :web do |web_config|
    web_config.vm.network :private_network, :ip => "192.168.33.12"
    web_config.vm.provider :aws do |aws|
      aws.private_ip_address = "192.168.33.12"
      aws.tags = { 'Name' => 'Web' }
    end
    web_config.vm.provision "puppet" do |puppet|
      puppet.module_path = ["modules", "librarian/modules"]
      puppet.manifest_file = "web.pp"
    end
  end

  config.vm.define :monitor do |monitor_config|
    monitor_config.vm.network :private_network, :ip => "192.168.33.14"
  end

  config.vm.define :ci do |build_config|
    build_config.vm.network :private_network, :ip => "192.168.33.16"
    build_config.vm.provider :aws do |aws|
      aws.private_ip_address = "192.168.33.16"
      aws.tags = { 'Name' => 'CI' }
    end
    build_config.vm.provision "puppet" do |puppet|
      puppet.module_path = ["modules", "librarian/modules"]
      puppet.manifest_file = "ci.pp"
    end
  end
end