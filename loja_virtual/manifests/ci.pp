class loja_virtual::ci inherits loja_virtual {
  package { ['git', 'maven2', 'openjdk-6-jdk']:
    ensure  => "installed",
  }

  user { 'jenkins' :
    ensure     => present,
    managehome => true,
  }

  class { 'jenkins':
    require => User['jenkins'],
  }

  $plugins = [
    'ssh-credentials',
    'credentials',
    'scm-api',
    'git-client',
    'git',
    'greenballs',
    'javadoc',
    'mailer',
    'maven-plugin'
  ]

  jenkins::plugin { $plugins: }
}