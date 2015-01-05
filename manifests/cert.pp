# Class: profile::ssl::cert

# Defined type to deploy an SSL cert

# In order to use this type, you must either follow a standard naming scheme
# for SSL-related files, or override using parameters. Here's the pattern:
# SSL certificate: name.crt
# Intermediate CA certificate: name_inter.crt
# Private key corresponding to name.crt: name.key

# for backwards compatibility, you can specify a name_chain.crt file that
# contains a combined file with the cert and intermediate certs for nginx.
# The concat => 'nginx' option can generate such a file automatically.

# This expects the SSL cert to be placed in $source manually and doesn't
# manage putting the cert on the master.

# Sample Usage:
# ssl::cert {'puppetlabs_wildcard': }

# If chain or intermediate certificates don't exist, override them with '':
# profile::ssl::cert {'puppetlabs_wildcard':
#   certchainfile => '',
#   certinterfile => '',
# }

# haproxy and Nginx have preferences about combined files, where the
# certificate and intermediate certificate(s) are merged into one
# file. The $concat option can create these combined files:

# profile::ssl::cert {'puppetlabs_wildcard':
#   concat => 'haproxy',
# }

# profile::ssl::cert {'puppetlabs_wildcard':
#   concat => 'nginx',
# }

define ssl::cert (
  $certfile      = "${name}.crt",
  $certchainfile = "${name}_chain.crt",
  $certinterfile = "${name}_inter.crt",
  $keyfile       = "${name}.key",
  $source        = "puppet://${::secure_server}/modules/ssldata",
  $dest_certdir  = '',
  $dest_keydir   = '',
  $concat        = false,
  $user          = 'root',
  $group         = 'root',
  $mode          = '0644',
  ) {
  include ssl
  include ssl::params

  if $dest_certdir == '' {
    $certdir = $::ssl::params::ssl_certdir
  } else {
    $certdir = $dest_certdir
  }

  if $dest_keydir == '' {
    $keydir = $::ssl::params::ssl_keydir
  } else {
    $keydir = $dest_keydir
  }

  if $::is_pe == true {
    $secure_server = hiera('pe_caserver')
  } else {
    $secure_server  = hiera('puppetlabs::ssl::secure_server', $::caserver)
  }

  File {
    owner => $user,
    group => $group,
    mode  => $mode,
  }

  Concat {
    ensure_newline => true,
  }

  case $concat {
    'haproxy': { ## combine cert, key, and intermediate cert files
      $unified_cert = "${certdir}/${certfile}"
      concat { $unified_cert:
        ensure => 'present',
      }
      concat::fragment{ "${name}_server_cert":
        target => $unified_cert,
        source => "${source}/${certfile}",
        order  => '1'
      }
      concat::fragment{ "${name}_server_key":
        target => $unified_cert,
        source => "${source}/${keyfile}",
        order  => '2'
      }
      concat::fragment{ "${name}_intermediate_cert":
        target => $unified_cert,
        source => "${source}/${certinterfile}",
        order  => '3'
      }
    }
    'nginx': { ## append intermediate CA cert to server cert, also deploy key
      $unified_cert = "${certdir}/${certfile}"
      concat { $unified_cert:
        ensure => present,
      }
      concat::fragment{ "${name}_server_cert":
        target => $unified_cert,
        source => "${source}/${certfile}",
        order  => '1'
      }
      concat::fragment{ "${name}_intermediate_cert":
        target => $unified_cert,
        source => "${source}/${certinterfile}",
        order  => '2'
      }

      # Deploy the key
      file { "${keydir}/${keyfile}":
        source => "${source}/${keyfile}",
        mode   => '0400',
      }
    }
    default: { ## deploy SSL-related files individually
      # Deploy the certificate
      file { "${certdir}/${certfile}":
        source => "${source}/${certfile}",
      }

      # Deploy the key
      file { "${keydir}/${keyfile}":
        source => "${source}/${keyfile}",
        mode   => '0400',
      }

      # Deploy the chain certificate
      if($certchainfile != '') {
        file { "${certdir}/${certchainfile}":
          source => "${source}/${certchainfile}",
        }
      }

      # Deploy the intermedia CA cert
      if($certinterfile != '') {
        file { "${certdir}/${certinterfile}":
          source => "${source}/${certinterfile}",
        }
      }
    }

  }

}
