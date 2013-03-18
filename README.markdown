puppet-ssl
==========

Define common ssl data and configuration

This is primarily an entry point for platform agnostic SSL data.

hiera
-----

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
