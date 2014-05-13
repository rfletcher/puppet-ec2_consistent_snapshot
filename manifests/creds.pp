# == Defined Type: ec2_consistent_snapshot::creds
#
# Create a credentials file for ec2_consistent_snapshot
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
define ec2_consistent_snapshot::creds (
  $ensure     = present,
  $owner      = undef,
  $group      = undef,
  $mode       = undef,
  $access_key = undef,
  $secret     = undef,
  $file       = $name
) {

  file { $file:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template('ec2_consistent_snapshot/ec2-consistent-snapshot.sh.erb'),
  }

}
