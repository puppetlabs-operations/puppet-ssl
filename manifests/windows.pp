# Sets up ACLs for the SSL directories on Windows
class ssl::windows (
  Stdlib::Windowspath $ssl_dir,
  Stdlib::Windowspath $key_dir,
  Boolean             $manage_acl = true,
) {
  if $manage_acl {
    acl { $ssl_dir:
      purge                      => true,
      inherit_parent_permissions => false,
      permissions                => [
        {'identity' => 'NT AUTHORITY\SYSTEM', 'rights' => ['full']},
        {'identity' => 'Administrators', 'rights' => ['full']},
        {'identity' => 'Everyone', 'rights' => ['read']},
      ],
    }

    acl { $key_dir:
      purge                      => true,
      inherit_parent_permissions => false,
      permissions                => [
        {'identity' => 'NT AUTHORITY\SYSTEM', 'rights' => ['full']},
        {'identity' => 'Administrators', 'rights' => ['full']},
      ],
    }
  }
}
