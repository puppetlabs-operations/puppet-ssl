# Maintain SSL certs and private keys
#
# You can store SSL certs in your control repo. Simply create a profile and put
# the certs in its files directory. (Note that you don't actually have to create
# a manifest for it.)
#
# Suppose you wanted to use profile::ssl. Set `cert_source => 'profile/ssl'`,
# and add cert files in site/profile/files/ssl/.
#
# You can also store SSL keys. These should be encrypted, and the simplest
# solution for that is hiera-eyaml. Simply add keys to the keys parameter on
# this class in hiera. For example:
#
#     ssl::keys:
#       'puppet.com': ENC[PKCS7,MIIH...
#       'forge.puppet.com': ENC[PKCS7,MIIH...
#
# The most important parameters are:
#
#   $cert_source - Where to find cert files with the file() function.
#   $keys - Private keys indexed by key names.
#   $manage_dirs - Whether or not to manage the ssl_dir, cert_dir, and key_dir
#     with Puppet. This also determines whether or not we create the ssl-cert
#     group.
class ssl (
  String[1]                  $cert_source,
  Hash[String[1], String[1]] $keys             = {},
  Boolean                    $manage_dirs      = true,
  Boolean                    $manage_ssl_dir   = $manage_dirs,
  Stdlib::Absolutepath       $ssl_dir          = $ssl::params::ssl_dir,
  Stdlib::Absolutepath       $cert_dir         = "${ssl_dir}/certs",
  Stdlib::Absolutepath       $key_dir          = "${ssl_dir}/keys",
  Optional[String[1]]        $owner            = $ssl::params::owner,
  Optional[String[1]]        $group            = $ssl::params::group,
  Boolean                    $manage_group     = $group != undef,
  Optional[String[1]]        $public_dir_mode  = $ssl::params::public_dir_mode,
  Optional[String[1]]        $key_dir_mode     = $ssl::params::key_dir_mode,
  Optional[String[1]]        $public_file_mode = $ssl::params::public_file_mode,
  Optional[String[1]]        $key_file_mode    = $ssl::params::key_file_mode,
  Boolean                    $manage_acl       = $ssl::params::manage_acl,
) inherits ssl::params {

  if $manage_ssl_dir {
    file { $ssl_dir:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $public_dir_mode,
    }
  }

  if $manage_group {
    group { $group:
      ensure => present,
    }
  }

  if $manage_dirs {
    file {
      default:
        ensure => directory,
        owner  => $owner,
        group  => $group,
      ;
      $cert_dir:
        mode => $public_dir_mode,
      ;
      $key_dir:
        mode => $key_dir_mode,
      ;
    }
  }

  if $facts['os']['family'] == 'windows' {
    class { 'ssl::windows':
      ssl_dir    => $ssl_dir,
      key_dir    => $key_dir,
      manage_acl => $manage_acl,
    }
  }
}
