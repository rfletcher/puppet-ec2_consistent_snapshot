# == Class: ec2_consistent_snapshot::package
#
# Installs (or removes) ec2-consistent-snapshot package.
#
# === Examples
#
#  include ec2_consistent_snapshot
#
# This class is not meant to be accessed directly.
#
# === Authors
#
# Rick Fletcher <fletch@pobox.com>
#
# === Copyright
#
# Copyright 2014 Rick Fletcher
#
class ec2_consistent_snapshot::package (
  $ensure        = undef,
  $force_use_vcs = undef,
  $vcs_provider  = undef,
  $vcs_url       = undef,
  $vcs_rev       = undef,
  $vcs_path      = undef,
) {

  # Ubuntu provides a package in a PPA repo.  Default to that unless
  # overridden.  All other OSes we'll use vcsrepo
  if $::osfamily == 'debian' and $force_use_vcs == false {
    include apt

    apt::ppa { 'ppa:alestic/ppa': }

    package { 'ec2-consistent-snapshot':
      ensure  => $ensure,
      require => Apt::Ppa['ppa:alestic/ppa'],
    }
  } else {

    #dependencies

    case $::operatingsystem {
      'redhat', 'centos' : {
        $dep_list = [ 'perl-Net-Amazon-EC2',
                      'perl-File-Slurp',
                      'perl-DateTime',
                      'perl-DBI',
                      'perl-DBD-MySQL',
                      'perl-IO-Socket-SSL',
                      'perl-Time-HiRes',
                      'perl-Params-Validate',
                      'ca-certificates' ]
      }

      default : {}
    }

    @package { $dep_list :
      ensure => present
    }

    vcsrepo { 'ec2-consistent-snapshot':
      ensure   => $ensure,
      provider => $vcs_provider,
      source   => $vcs_url,
      revision => $vcs_rev,
      path     => $vcs_path,
      user    => 'root'
    }

    # This is here just so the executable ends up in PATH.
    file { '/usr/local/bin/ec2-consistent-snapshot':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => '/opt/ec2-consistent-snapshot/ec2-consistent-snapshot',
      require => Vcsrepo['ec2-consistent-snapshot']
    }
  }
}
