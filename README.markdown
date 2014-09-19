# SSL

Define common SSL data and configuration

This is primarily an entry point for platform agnostic SSL data.

## Usage

To simply mange the directories associated with SSL on a given system, just
include the `ssl` class. This module can also deploy SSL certificates from
your master to nodes, including combining them as haproxy and nginx prefer.

To simply manage directories:
``` Puppet
include ssl
```

If you have a module that needs to use these SSL directories, you can simply reference the variables using the full name.

``` Puppet
$ssl::ssl_dir
```

This is useful if you want to deploy certs, or just have a more consistent, repeatable SSL deployment.

To have this module deploy a certificate:
``` Puppet
include ssl
ssl::cert {'puppetlabs_wildcard': }
```
This will copy `puppetlabs_wildcard.crt`, `puppetlabs_wildcard.key`,
`puppetlabs_wildcard_chain.crt`, and `puppetlabs_wildcard_inter.crt` to
`ssl::params::ssl_certdir`.

If you're using haproxy, these certs can be combined into one file:
``` Puppet
include ssl
ssl::cert {'puppetlabs_wildcard':
  concat => 'haproxy',
}
```

More examples are provided in manifests/cert.pp.

## hiera

This module was using the `hiera()` functions to do the lookup that has now been replaced with the `ssl::params` class.  Now to support new platforms, you just need extend the `ssl::params` class.  What follows is being deprecated and should no longer be used.  **PLEASE UPDATE YOUR MANIFESTS**.

### Deprecated hiera usage

Hiera is the main place to inject data into this module. To make it work out of
the box you'll need to have the following hierarchy, or something equivalent:

    ----
    hierarchy:
      - %{osfamily}

You'll also need the following files:

    ----
    # hiera_dir/Debian.yaml
    ssl::params::ssl_path: '/etc/ssl'
    ssl::params::ssl_cert_file: %{ssl_path}/certs/ssl-cert-snakeoil.pem
    ssl::params::ssl_key_file: %{ssl_path}/private/ssl-cert-snakeoil.key

- - -

    ---
    # hiera_dir/RedHat.yaml
    ssl::params::ssl_path: '/etc/pki'
    ssl::params::ssl_cert_file: %{ssl_path}/tls/certs/localhost.crt
    ssl::params::ssl_key_file: %{ssl_path}/tls/private/localhost.key

This will set up the system to use the system's self signed ssl certs.
