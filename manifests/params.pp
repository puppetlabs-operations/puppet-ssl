class ssl::params {

  case $operatingsystem {
    'centos', 'fedora', 'redhat': {
       $ssl_path = '/etc/pki'
    }
    'ubuntu', 'debian': {
       $ssl_path = '/etc/ssl/'
    }
    default: { $ssl_path = '/etc/ssl/' }
  }
}
