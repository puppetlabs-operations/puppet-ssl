# Deploy SSL certificates and keys in a couple of common formats
#
# See the README for information about how to store certificates and keys for
# use by this type.
#
# This deploys:
#
#   * `${key_dir}/${key_name}.key`
#   * `${cert_dir}/${key_name}.crt`
#   * `${cert_dir}/${key_name}_inter.crt` — the intermediate certificate(s)
#   * `${cert_dir}/${key_name}_combined.crt` — the primary certificate
#     followed by the intermediate certificate(s)
define ssl::cert (
  String[1]                      $key_name         = $title,
  Optional[Stdlib::Absolutepath] $cert_dir         = undef,
  Optional[Stdlib::Absolutepath] $key_dir          = undef,
  Optional[String[1]]            $user             = undef,
  Optional[String[1]]            $group            = undef,
  Optional[Stdlib::Filemode]     $public_file_mode = undef,
  Optional[Stdlib::Filemode]     $key_file_mode    = undef,
) {
  include ssl

  # Use lest since pick fails when all of the values are undef. On Windows,
  # the mode values will be undef because we explicitly set the ACLs.
  $_cert_dir         = $cert_dir.lest || { $ssl::cert_dir }
  $_key_dir          = $key_dir.lest || { $ssl::key_dir }
  $_user             = $user.lest || { $ssl::owner }
  $_group            = $group.lest || { $ssl::group }
  $_public_file_mode = $public_file_mode.lest || { $ssl::public_file_mode }
  $_key_file_mode    = $key_file_mode.lest || { $ssl::key_file_mode }

  file {
    default:
      ensure => file,
      owner  => $_user,
      group  => $_group,
      mode   => $_public_file_mode,
    ;
    # Key
    "${_key_dir}/${key_name}.key":
      mode    => $_key_file_mode,
      # https://github.com/voxpupuli/hiera-eyaml/issues/264: eyaml drops newline
      content => ssl::ensure_newline($ssl::keys[$key_name]),
    ;
    # Plain cert
    "${_cert_dir}/${key_name}.crt":
      content => file("${ssl::cert_source}/${key_name}.crt"),
    ;
    # Intermediate cert
    "${_cert_dir}/${key_name}_inter.crt":
      content => file("${ssl::cert_source}/${key_name}_inter.crt"),
    ;
    # Combined cert and intermediate cert
    "${_cert_dir}/${key_name}_combined.crt":
      content => ssl::pem::join([
        file("${ssl::cert_source}/${key_name}.crt"),
        file("${ssl::cert_source}/${key_name}_inter.crt"),
      ]),
    ;
  }
}
