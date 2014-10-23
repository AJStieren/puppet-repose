# == Class: repose::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt>,
# <tt>absent</tt>, <tt>latest</tt> or a version nuymber. If set to
# <tt>absent</tt>:
# * The managed software packages are being uninstalled.
# * Any traces of the packages will be purged as good as possible. This may
# include existing configuration files. The exact behavior is provider
# dependent. Q.v.:
# * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# * System modifications (if any) will be reverted as good as possible
# (e.g. removal of created users, services, changed log settings, ...).
# * This is thus destructive and should be used with care.
# Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
# Boolean. If set to <tt>true</tt>, any managed package gets upgraded
# on each Puppet run when the package provider is able to find a newer
# version than the present one. The exact behavior is provider dependent.
# Q.v.:
# * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# Defaults to <tt>false</tt>.
#
# [*container*]
# The package list to use based on the container that is used to run
# repose in this environment
#
# === Examples
#
# Primarily to be used by the repose base class, but you can use:
#   class { 'repose::package': contaienr => 'valve' }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::package (
  $ensure      = $repose::params::ensure,
  $autoupgrade = $repose::params::autoupgrade,
  $container   = $repose::params::container,
) inherits repose::params {

### Logic

## set params: removal
  if $ensure == absent {
    $package_ensure = purged
## set params: in operation
  } else {
    if $autoupgrade == true {
      $package_ensure = latest
    } else {
      $package_ensure = $ensure
    }
  }

## Pick packages
  $container_package = $container ? {
    'tomcat7' => $repose::params::tomcat7_package,
    'valve'   => $repose::params::valve_package,
  }

## Handle adding a dependency of service for valve
  if $container == 'valve' {
    $before = Service[$repose::params::service]
  } else {
    $before = undef
  }


### Manage actions

  package { $container_package:
    ensure => $package_ensure,
    before => $before,
  }

  package { $repose::params::packages:
    ensure  => $package_ensure,
    require => Package[$container_package],
  }

}
