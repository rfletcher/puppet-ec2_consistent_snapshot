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
# [*secret*]
#   Your AWS secret key.
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
  $access_key    = undef,
  $secret        = undef,
) {

  # Our $ensure is used for both the package the the creds file.
  $file_ensure = $ensure ? {
    absent  => absent,
    purged  => absent,
    default => present,
  }

  anchor { 'ec2_consistent_snapshot::begin' : }

  class { 'ec2_consistent_snapshot::package':
    ensure        => $ensure,
    force_use_vcs => $force_use_vcs,
    vcs_provider  => $vcs_provider,
    vcs_url       => $vcs_url,
    vcs_rev       => $vcs_rev,
    vcs_path      => $vcs_path
  }

  file { '/etc/profile.d/ec2-consistent-snapshot.sh':
    ensure  => $file_ensure,
    content => template('ec2_consistent_snapshot/ec2-consistent-snapshot.sh.erb'),
    mode    => '0644',
  }

  anchor { 'ec2_consistent_snapshot::end': }

  Anchor['ec2_consistent_snapshot::begin'] ->
  Class['ec2_consistent_snapshot::package'] ->
  Anchor['ec2_consistent_snapshot::end']
}
