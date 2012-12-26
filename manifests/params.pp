class ssl::params {

  case $osfamily {
    'redhat': {
      $ssl_path      = '/etc/pki'
      $ssl_cert_file = hiera('ssl_cert_file', "${ssl_path}/tls/certs/localhost.crt")
      $ssl_key_file  = hiera('ssl_key_file',  "${ssl_path}/tls/private/localhost.key")
    }
    'debian': {
      $ssl_path      = '/etc/ssl'
      $ssl_cert_file = hiera('ssl_cert_file', "${ssl_path}/certs/ssl-cert-snakeoil.pem")
      $ssl_key_file  = hiera('ssl_key_file',  "${ssl_path}/private/ssl-cert-snakeoil.key")
    }
    default: { $ssl_path = '/etc/ssl' }
  }

}
