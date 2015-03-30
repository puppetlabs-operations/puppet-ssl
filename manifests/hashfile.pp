define ssl::hashfile(
  $certdir,
) {

  $filename = reverse(split($name, '/'))[0]

  # Create certificate hash file
  exec { "Build cert hash for ${filename}":
    command => "ln -s ${certdir}/${filename} ${certdir}/$(openssl x509 -noout -hash -in ${certdir}/${filename}).0",
    unless  => "test -f ${certdir}/$(openssl x509 -noout -hash -in ${certdir}/${filename}).0",
    require => File["${certdir}/${filename}"],
    path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
  }
}
