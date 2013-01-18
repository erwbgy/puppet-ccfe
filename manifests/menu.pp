define ccfe::menu (
  $description = $title,
  $user        = 'root',
  $group       = 'root',
  $items       = {}
) {
  $id = $title
  $basedir = $ccfe::basedir
  case $group {
    'root': {
      $dir_mode  = '0755'
      $file_mode = '0644'
    }
    default: {
      $dir_mode  = '0750'
      $file_mode = '0640'
    }
  }
  file { "${basedir}/${id}.menu":
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => $dir_mode,
  }
  file { "${basedir}/${id}.menu/definition":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $file_mode,
    content => template('ccfe/definition.erb'),
    require => File["${basedir}/${id}.menu"],
  }
  $defaults = {
    parent => $id,
    user   => $user,
    group  => $group,
  }
  create_resources('ccfe::item', $items, $defaults)
}
