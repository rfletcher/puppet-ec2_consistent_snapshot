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
#   If this and $secret are set then this class will create a file that can
#   be sourced in a user environment to set AWS_ACCESS_KEY_ID and
#   AWS_SECRET_ACCESS_KEY. Alternatively this can be left undefined and
#   ec2_consistent_snapshot::creds can be used directly which may be
#   preferable for more complicated setups and security restrictions.
#
# [*secret*]
#   Your AWS secret key
#
#   If this and $access_key are set then this class will create a file that
#   can be sourced in a user environment to set AWS_ACCESS_KEY_ID and
#   AWS_SECRET_ACCESS_KEY. Alternatively this can be left undefined and
#   ec2_consistent_snapshot::creds can be used directly which may be
#   preferable for more complicated setups and security restrictions.
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
  anchor { 'ec2_consistent_snapshot::begin' : }

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
      secret     => $secret,
      env_file   => true
    }
  } else {
    ec2_consistent_snapshot::creds { $creds_file :
      ensure => absent
    }
  }

  anchor { 'ec2_consistent_snapshot::end' : }

  Anchor['ec2_consistent_snapshot::begin'] ->
  Ec2_consistent_snapshot::Creds[$creds_file] ->
  Anchor['ec2_consistent_snapshot::end']
}
