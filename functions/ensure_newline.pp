# Ensure there's a trailing newline
function ssl::ensure_newline (
  String[0] $string,
) {
  if $string[-1] == "\n" {
    $string
  } else {
    "${string}\n"
  }
}
