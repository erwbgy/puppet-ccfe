class ccfe (
  $config       = {},
  $filestore    = 'puppet:///files/ccfe',
  $package_file = 'ccfe-1.57-1.noarch.rpm',
  $menu_wrapper = true,
  $workspace    = '/root/ccfe',
) {
  class { 'ccfe::install':
    filestore    => $filestore,
    package_file => $package_file,
    workspace    => $workspace,
  }
  class { 'ccfe::menus':
    config  => $config['menus'],
    require => Class['ccfe::install'],
  }
  class { 'ccfe::items':
    config  => $config['items'],
    require => Class['ccfe::menus'],
  }
  if $menu_wrapper {
    file { '/usr/bin/menu':
      ensure  => present,
      mode    => '0755',
      content => "#!/bin/bash\nexec /usr/bin/ccfe \"$@\"\n",
      replace => false,
    }
  }
}
