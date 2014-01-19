class ssl::params {

  # This has to be resolved before other variables because they may interpolate
  # this value.
  $ssl_path      = hiera('ssl::params::ssl_path')
  $ssl_cert_file = hiera('ssl::params::ssl_cert_file')
  $ssl_ciphers   = hiera('ssl::params::ssl_ciphers')
  $ssl_key_file  = hiera('ssl::params::ssl_key_file')

}
