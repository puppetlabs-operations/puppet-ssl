# Manage SSL certificates and keys

The primary purpose of this module is to install certificatess and keys in a few
common formats.

## Storing certificates and keys

This requires that certificates and keys are stored separately. Keys should be
stored in hiera, while files must be stored in the `files/` directory of one of
your profiles.

The primary certificate must be named "name.crt", and the intermediate
certificate must be name "name_inter.crt". For example, if you store your files
in `profile::ssl`:

    site/profile/files/ssl/puppet.com.crt
    site/profile/files/ssl/puppet.com_inter.crt
    site/profile/files/ssl/forge.puppet.com.crt
    site/profile/files/ssl/forge.puppet.com_inter.crt

Set the profile to use in hiera, or by setting the `cert_source` parameter
directly on the `ssl` class. The value should be in the same format as the
`file()` function expects, e.g. `'profile/ssl'`.

The private keys for your certificates go into Hiera as entries in the
`ssl::keys` hash. We recommend encrypting them with [Hiera eyaml][]. To continue
with the example from above:

    ssl::cert_source: 'profile/ssl'
    ssl::keys:
      'puppet.com': ENC[PKCS7,MIIH...
      'forge.puppet.com': ENC[PKCS7,MIIH...

## Deploying certificates and keys

### `ssl::cert`

This is the most generic resource. It stores keys in the default global
certificate and key directories for your OS.

On Debian, the `puppet.com` cert would be deployed as follows:

    /etc/ssl/certs/puppet.com.crt
    /etc/ssl/certs/puppet.com_inter.crt
    /etc/ssl/certs/puppet.com_combined.crt
    /etc/ssl/private/puppet.com.key

The `_combined.crt` file is concatenation of the primary certificate followed by
the intermediate certificate. This is the format used by NGINX and a variety of
other applications.

### `ssl::cert::haproxy`

This combines certificates with their key in the format expected by HAProxy. By
default, it puts them in `/etc/haproxy/certs.d/${key_name}.crt`.


[Hiera eyaml]: https://github.com/voxpupuli/hiera-eyaml
