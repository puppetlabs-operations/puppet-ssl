# DEPRECATED
#
# This is only here to simplify some of our legacy code.
#
# We recommend using `ssl::cert` and configuring NGINX to use the
# `_combined.crt` file instead of using this resource.
define ssl::cert::nginx (
  String[1]           $key_name = $title,
  Optional[String[1]] $cert_dir = undef,
  Optional[String[1]] $key_dir  = undef,
  String[1]           $user     = 'root',
  String[1]           $group    = '0',
  String[1]           $mode     = '0640',
) {
  include ssl

  $_cert_dir = pick($cert_dir, $ssl::cert_dir)
  $_key_dir = pick($_key_dir, $ssl::key_dir)

  file {
    default:
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => $mode,
    ;
    # Key
    "${_key_dir}/${key_name}.key":
      mode    => '0400',
      # https://github.com/voxpupuli/hiera-eyaml/issues/264: eyaml drops newline
      content => ssl::ensure_newline($ssl::keys[$key_name]),
    ;
    # Combined cert and intermediate cert
    "${_cert_dir}/${key_name}.crt":
      content => ssl::pem::join([
        file("${ssl::cert_source}/${key_name}.crt"),
        file("${ssl::cert_source}/${key_name}_inter.crt"),
      ]),
    ;
  }
}
