# Add an SSL certificate to a collector
#
# For example, if you have an nginx collector, you might add a certificate to
# it with ssl::cert('mycert', 'nginx').
#
# If you do not specify a collector, the certificate will be added to all
# collectors.
function ssl::cert (
    String[1] $cert_name,
    Optional[String[1]] $collector,
) {
  if $collector {
    Ssl::Collector <| collector_groups == $collector |> {
      certs +> $cert_name
    }
  } else {
    Ssl::Collector <| |> {
      certs +> $cert_name
    }
  }
}
