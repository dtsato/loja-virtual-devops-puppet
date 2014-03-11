class loja_virtual::ci {
  include loja_virtual

  package { ['git', 'maven2', 'openjdk-6-jdk', 'rubygems']:
    ensure => "installed",
  }

  package { ['fpm', 'bundler']:
    ensure   => 'installed',
    provider => 'gem',
    require  => Package['rubygems'],
  }

  class { 'jenkins':
    config_hash => {
      'JAVA_ARGS' => { 'value' => '-Xmx256m' }
    },
  }

  $plugins = [
    'ssh-credentials',
    'credentials',
    'scm-api',
    'git-client',
    'git',
    'maven-plugin',
    'javadoc',
    'mailer',
    'greenballs',
    'ws-cleanup',
    'parameterized-trigger',
    'copyartifact'
  ]

  jenkins::plugin { $plugins: }

  file { '/var/lib/jenkins/hudson.tasks.Maven.xml':
    mode    => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => 'puppet:///modules/loja_virtual/hudson.tasks.Maven.xml',
    require => Class['jenkins::package'],
    notify  => Service['jenkins'],
  }

  $job_structure = [
    '/var/lib/jenkins/jobs',
    '/var/lib/jenkins/jobs/loja-virtual-devops'
  ]
  $git_repository = 'https://github.com/dtsato/loja-virtual-devops.git'
  $git_poll_interval = '* * * * *'
  $maven_goal = 'install'
  $archive_artifacts = 'combined/target/*.war'
  $repo_dir = '/var/lib/apt/repo'
  $repo_name = 'devopspkgs'

  file { $job_structure:
    ensure  => 'directory',
    owner   => 'jenkins',
    group   => 'jenkins',
    require => Class['jenkins::package'],
  }

  file { "${job_structure[1]}/config.xml":
    mode    => 0644,
    owner   => 'jenkins',
    group   => 'jenkins',
    content => template('loja_virtual/config.xml'),
    require => File[$job_structure[1]],
    notify  => Service['jenkins'],
  }

  class { 'loja_virtual::repo':
    basedir => $repo_dir,
    name    => $repo_name,
  }
}