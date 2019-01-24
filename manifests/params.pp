# Determine default parameters for ssl
class ssl::params {
  $ssl_dir = $facts['os']['family'] ? {
    'Debian'  => '/etc/ssl',
    'RedHat'  => '/etc/pki',
    'FreeBSD' => '/etc/ssl',
    'windows' => 'C:/ProgramData/ssl',
    # This will not work on various platforms, but it's important that this will
    # not fail so that ssl::cert works on those platforms.
    default   => '/etc/ssl',
  }

  if $facts['os']['family'] == 'windows' {
    # Use ACLs explicitly on Windows
    $manage_acl       = true
    $owner            = undef
    $group            = undef
    $public_dir_mode  = undef
    $key_dir_mode     = undef
    $public_file_mode = undef
    $key_file_mode    = undef
  } else {
    $manage_acl       = false
    $owner            = 'root'
    $group            = '0'
    $public_dir_mode  = '0755'
    $key_dir_mode     = '0750'
    $public_file_mode = '0640'
    $key_file_mode    = '0400'
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
