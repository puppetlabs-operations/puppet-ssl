# Join certs and keys into a single PEM. Ensure the correct newlines exist.
function ssl::pem::join (
  Array[String[0]] $items,
) {
  $items.map |$item| { ssl::ensure_newline($item) }.join('')
}
