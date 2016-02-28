# A collector to install SSL certificates in an arbitrary format
#
# This defines how SSL certificates should be formatted and stored so that for
# use in a particular application. For example, NGINX needs two files per
# certificate, the key, and a file with the certificate itself and the
# intermediate certificate.
#
#   $source = 'puppet:///ssldata'
#   ssl::collector {
#     default:
#       collector_groups => [ 'nginx' ],
#     ;
#     'nginx.crt':
#       file     => '/etc/nginx/certs/<cert>.crt',
#       contents => [ "${source}/<cert>.crt", "${source}/<cert>_inter.crt" ],
#     ;
#     'nginx.key':
#       file     => '/etc/nginx/keys/<cert>.key',
#       contents => [ "${source}/<cert>.key" ],
#     ;
#   }
#
# This defines two collectors in the group 'nginx'. One of them collects
# combined certificate files and one collects key files.
#
# The combined certificate files are built up from the individual and
# intermediate certificate files in the data source (the ssldata module, in
# this case).
#
# When a new vhost is defined the SSL certificate can be installed on the node
# with the ssl::cert function:
#
#   ssl::cert('secure.example.com', 'nginx')
#
# This will generate:
#
# /etc/nginx/certs/secure.example.com.crt, which is composed of:
#   - puppet:///ssldata/secure.example.com.crt
#   - puppet:///ssldata/secure.example.com_inter.crt
#
# /etc/nginx/keys/secure.example.com.key, which is composed of:
#   - puppet:///ssldata/secure.example.com.key

define ssl::collector (
  String[1] $file,
  String[1] $mode  = '0400',
  String[1] $owner = 'root',
  String[1] $group = '0',
  Array[String[1], 1] $contents,
  Array[String[1]] $certs = [],
  Array[String[1]] $collector_groups = [ $name ],
) {
  include ::ssl

  unique($certs).each |$cert| {
    $target = regsubst($file, '<cert>', $cert, 'G')

    concat { $target:
      mode  => $mode,
      owner => $owner,
      group => $group,
    }

    $contents.each |$index, $pattern| {
      $source = regsubst($pattern, '<cert>', $cert, 'G')

      concat::fragment{ "${target} ${source} ${index}":
        target => $target,
        source => $source,
        order  => $index,
      }
    }
  }
}
