# == Defined Type: ec2_consistent_snapshot::creds
#
# Create a credentials file for ec2_consistent_snapshot
#
# === Parameters
#
# [*ensure*]
#   If the specified file should exist.
#
# [*owner*]
#   Owner of the file created.
#
# [*group*]
#   Group of the file created.
#
# [*mode*]
#   Permissions of the file created.
#
# [*file*]
#   Name of the file to create.
##
# [*access_key*]
#   Your AWS access key.
#
# [*secret*]
#   Your AWS secret key
#
# [*env_file*]
#   Set to true if the file should export environmental variables so it can
#   be sourced. If false the format of the file will be an awssecret file
#   and passed as a command line argument (--aws-credentials-file) to the
#   script.
#
# === Examples
#
# ec2_consistent_snapshot::creds { '/etc/ec2_consistent_snapshot.creds' :
#   ensure     => present,
#   owner      => 'backup',
#   group      => 'backup',
#   mode       => '0400',
#   access_key => '1B5JYHPQCXW13GWKHAG2'
#   secret     => '2GAHKWG3+1wxcqyhpj5b1Ggqc0TIxj21DKkidjfz'
# }
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
  $file       = $name,
  $env_file   = false
) {

  file { $file:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template('ec2_consistent_snapshot/ec2-consistent-snapshot.sh.erb'),
  }

}
