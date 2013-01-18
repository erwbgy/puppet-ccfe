class ccfe (
  $config       = {},
  $menu_wrapper = true,
) {
  class { 'ccfe::menus':
    config => $config['menus'],
  }
  class { 'ccfe::items':
    config => $config['items'],
  }
  if $menu_wrapper {
    file { '/usr/bin/menu':
      ensure  => present,
      mode    => '0755',
      content => "#!/bin/bash\nexec /usr/bin/ccfe \"$@\"\n",
    }
  }
}
