define ccfe::menu (
  $description = $title,
  $user        = 'root',
  $group       = 'root',
  $items       = {}
) {
  $id = $title
  $basedir = $ccfe::basedir
  file { "${basedir}/${id}.menu":
    ensure => directory,
    owner  => $user,
    group  => $group,
  }
  file { "${basedir}/${id}.menu/definition":
    ensure  => present,
    owner   => $user,
    group   => $group,
    content => template('ccfe/definition.erb'),
    require => File["${basedir}/${id}.menu"],
  }
  $defaults = {
    parent => $id,
  }
  create_resources('ccfe::item', $items, $defaults)
}
