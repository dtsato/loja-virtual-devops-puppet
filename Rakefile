require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.ignore_paths = ["librarian/**/*.pp"]

namespace :spec do
  %w(mysql tomcat).each do |module_name|
    desc "Run specs for module #{module_name}"
    RSpec::Core::RakeTask.new(module_name) do |t|
      t.pattern = "modules/#{module_name}/spec/**/*_spec.rb"
    end
  end
end

desc "Run all specs"
task :spec => ['spec:tomcat', 'spec:mysql']

namespace :librarian do
  task :install do
    Dir.chdir('librarian') do
      sh "librarian-puppet install"
    end
  end
end

task :package => [:lint, :spec, 'librarian:install'] do
  sh "tar czvf puppet.tgz manifests modules librarian/modules"
end

task :clean do
  sh "rm puppet.tgz"
end

task :default => [:lint, :spec]