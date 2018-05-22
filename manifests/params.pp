# Determine default parameters for ssl
class ssl::params {
  $ssl_dir = $facts['os']['family'] ? {
    'Debian'  => '/etc/ssl',
    'RedHat'  => '/etc/pki',
    'FreeBSD' => '/etc/ssl',
    default   => fail("ssl module doesn't support OS family ${facts['os']['family']}"),
  }

  $cert_dir = "${ssl_dir}/certs"
  $key_dir = "${ssl_dir}/private"

  # Don't use these.
  #
  # This class cannot use the standard data binding lookup because ssl_path
  # is interpolated into the other values and thus must be loaded into scope
  # first.
  $ssl_path = $ssl_dir
  $_lookup_options = { default_value => undef }
  $ssl_cert_file = lookup('ssl::params::ssl_cert_file', $_lookup_options)
  $ssl_chain_file = lookup('ssl::params::ssl_chain_file', $_lookup_options)
  $ssl_key_file = lookup('ssl::params::ssl_key_file', $_lookup_options)
  $ssl_ciphers = lookup('ssl::params::ssl_ciphers', $_lookup_options)
}
