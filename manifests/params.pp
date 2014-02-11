# Class: ssl::params
#
# Sets paramters for SSL used in the deployment of keypairs.
#
class ssl::params {
  case $::osfamily {
    'debian': {
      $ssl_dir              = '/etc/ssl'
      $ssl_certdir          = "${ssl_dir}/certs"
      $ssl_keydir           = "${ssl_dir}/private"
      $ssl_default_certpath = "${ssl_certdir}/ssl-cert-snakeoil.pem"
      $ssl_default_keypath  = "${ssl_keydir}/ssl-cert-snakeoil.key"
    }
    'redhat': {
      $ssl_dir              = '/etc/pki'
      $ssl_certdir          = "${ssl_dir}/certs"
      $ssl_keydir           = "${ssl_dir}/private"
      $ssl_default_certpath = "${ssl_certdir}/localhost.crt"
      $ssl_default_keypath  = "${ssl_keydir}/localhost.key"
    }
    'freebsd': {
      $ssl_dir              = '/etc/ssl'
      $ssl_certdir          = "${ssl_dir}/certs"
      $ssl_keydir           = "${ssl_dir}/private"
      $ssl_default_certpath = "${ssl_certdir}/localhost.crt"
      $ssl_default_keypath  = "${ssl_keydir}/localhost.key"
    }
    default: {
      notice("ssl::params does not support ${::osfamily}.")
    }
  }

  # This class cannot use the standard data binding lookup because ssl_path
  # is interpolated into the other values and thus must be loaded into scope
  # first.
  #
  # We should prepare to deprecate these first few variables
  warn('hiera calls in the ssl module are being deprecated.  Please update your manifests to use hte variables from the ssl class.')
  $ssl_path       = $ssl_dir
  $ssl_cert_file  = hiera('ssl::params::ssl_cert_file')
  $ssl_chain_file = hiera('ssl::params::ssl_chain_file')
  $ssl_key_file   = hiera('ssl::params::ssl_key_file')
  $ssl_ciphers    = hiera('ssl::params::ssl_ciphers')
}
