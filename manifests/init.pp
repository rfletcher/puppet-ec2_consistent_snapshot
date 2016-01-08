# == Class: ec2_consistent_snapshot
#
# Installs (or removes) AWS command line tools
#
# === Parameters
#
# [*ensure*]
#   present, latest, absent
#
# [*access_key*]
#   Your AWS access key
#
# [*secret*]
#   Your AWS secret key
#
# === Examples
#
#  include ec2_consistent_snapshot
#
# === Authors
#
# Rick Fletcher <fletch@pobox.com>
#
# === Copyright
#
# Copyright 2014 Rick Fletcher
#
class ec2_consistent_snapshot (
  $ensure     = present,

  $access_key = undef,
  $secret     = undef,
) {
  include apt

  apt::ppa { 'ppa:alestic/ppa': }

  package { 'ec2-consistent-snapshot':
    ensure  => $ensure,
    require => [
      Apt::Ppa['ppa:alestic/ppa'],
      Class['apt::update'],
    ],
  }

  $file_ensure = $ensure ? {
    absent  => absent,
    purged  => absent,
    default => present,
  }

  file { '/etc/profile.d/ec2-consistent-snapshot.sh':
    ensure  => $file_ensure,
    content => template('ec2_consistent_snapshot/ec2-consistent-snapshot.sh.erb'),
    mode    => 0644,
  }
}
