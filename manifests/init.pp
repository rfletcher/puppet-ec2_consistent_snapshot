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

  $owner      = 'root',
  $group      = 'root',
  $mode       = '0644',
  $creds_file = '/etc/profile.d/ec2-consistent-snapshot.sh',
  $access_key = undef,
  $secret     = undef,
) {
  include apt

  apt::ppa { 'ppa:alestic/ppa': }

  package { 'ec2-consistent-snapshot':
    ensure  => $ensure,
    require => Apt::Ppa['ppa:alestic/ppa'],
  }

  $file_ensure = $ensure ? {
    absent  => absent,
    purged  => absent,
    default => present,
  }

  if $access_key != undef and $secret != undef {
    ec2_consistent_snapshot::creds { $creds_file :
      ensure     => present,
      owner      => 'root',
      group      => 'root',
      mode       => '0644',
      access_key => $access_key,
      secret     => $secret
    }
  } else {
    ec2_consistent_snapshot::creds { $creds_file :
      ensure => absent
    }
  }
}
