class tomcat7 {
  package { "tomcat7":
    ensure  => installed,
    require => Exec["apt-update"],
  }

  file { "/etc/default/tomcat7":
    owner   => root,
    group   => root,
    mode    => 0644,
    source  => "puppet:///modules/tomcat/tomcat7",
    require => Package["tomcat7"],
    notify  => Service["tomcat7"],
  }

  service { "tomcat7":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package["tomcat7"],
  }
}