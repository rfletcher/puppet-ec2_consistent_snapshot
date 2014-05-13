# == Class: ec2_consistent_snapshot
#
# Installs (or removes) ec2-consistent-snapshot.
#
# === Parameters
#
# [*ensure*]
#   Ensure value of package/vcsrepo resource. This value is also interpreted
#   to determine the ensure value of file credentials file resource.
#
# [*force_use_vcs*]
#   OSes which lack a native package will retrieve the script from git by
#   default. Toggle to true to force retrieving from git even if a package
#   exists.
#
# [*vcs_provider*]
#   The vcsrepo provider to use. Useful if using an alternative $vcs_url.
#
# [*vcs_url*]
#   URL of the repository. Useful if using a fork of the original.
#
# [*vcs_rev*]
#   Revision to pull from repository.
#
# [*access_key*]
#   Your AWS access key.
#
#   If this and $secret are set then this class will create a file that can
#   be sourced in a user environment to set AWS_ACCESS_KEY_ID and
#   AWS_SECRET_ACCESS_KEY. Alternatively this can be left undefined and
#   ec2_consistent_snapshot::creds can be used directly which may be
#   preferable for more complicated setups and security restrictions.
#
# [*secret*]
#   Your AWS secret key.
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
  $ensure        = present,
  $force_use_vcs = false,
  $vcs_provider  = 'git',
  $vcs_url       = 'https://github.com/alestic/ec2-consistent-snapshot.git',
  $vcs_rev       = 'master',
  $vcs_path      = '/opt/ec2-consistent-snapshot',
  $owner         = 'root',
  $group         = 'root',
  $mode          = '0644',
  $creds_file    = '/etc/profile.d/ec2-consistent-snapshot.sh',
  $access_key    = undef,
  $secret        = undef,
) {

  anchor { 'ec2_consistent_snapshot::begin' : }

  class { 'ec2_consistent_snapshot::package':
    ensure        => $ensure,
    force_use_vcs => $force_use_vcs,
    vcs_provider  => $vcs_provider,
    vcs_url       => $vcs_url,
    vcs_rev       => $vcs_rev,
    vcs_path      => $vcs_path
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

  anchor { 'ec2_consistent_snapshot::end': }

  Anchor['ec2_consistent_snapshot::begin'] ->
  Class['ec2_consistent_snapshot::package'] ->
  Ec2_consistent_snapshot::Creds[$creds_file] ->
  Anchor['ec2_consistent_snapshot::end']
}
