# Class: ssl
#
# This class maintains the permissions of the various directories used for SSL
# deployments.
#
class ssl (
  Boolean $manage_ssl_dir = true
) {

  include ssl::params

  $ssl_dir              = $ssl::params::ssl_dir
  $ssl_certdir          = $ssl::params::ssl_certdir
  $ssl_keydir           = $ssl::params::ssl_keydir
  $ssl_default_certpath = $ssl::params::ssl_default_certpath
  $ssl_default_keypath  = $ssl::params::ssl_default_keypath

  if ! $ssl_dir {
    fail('ssl management is not built for this osfamily')
  }

  File {
    owner => 'root',
    group => '0',
  }

  if $manage_ssl_dir {
    file { $ssl_dir:
      ensure => directory,
      mode   => '0755',
    }
  }

  file { $ssl_certdir:
    ensure  => directory,
    mode    => '0755',
    require => File["${ssl_dir}"],
  }

  group { 'ssl-cert':
    ensure => 'present'
  }

  file { $ssl_keydir:
    ensure  => directory,
    group   => 'ssl-cert',
    mode    => '0750',
    require => Group['ssl-cert'],
  }
}
