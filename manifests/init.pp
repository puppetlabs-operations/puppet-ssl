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
# The two most important parameters are:
#
#   $cert_source - Where to find cert files with the file() function.
#   $keys - Private keys indexed by key names.
class ssl (
  String[1]                  $cert_source,
  Hash[String[1], String[1]] $keys           = {},
  Boolean                    $manage_ssl_dir = true,
) {
  # This doesn't quite follow the params pattern. Unfortunately, we have code
  # that relies on variables in ssl::params, but doesn't actually need the
  # directories managed. This is the simplest way to handle that legacy code.
  #
  # The PR I'm currently working on is getting too big, so I will leave
  # refactoring this to a future change.
  include ssl::params
  $ssl_dir = $ssl::params::ssl_dir
  $cert_dir = $ssl::params::cert_dir
  $key_dir = $ssl::params::key_dir

  if $manage_ssl_dir {
    file { $ssl_dir:
      ensure => directory,
      owner  => 'root',
      group  => '0',
      mode   => '0755',
    }
  }

  file { $cert_dir:
    ensure => directory,
    owner  => 'root',
    group  => '0',
    mode   => '0755',
  }

  group { 'ssl-cert':
    ensure => present,
  }

  file { $key_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'ssl-cert',
    mode   => '0750',
  }
}
