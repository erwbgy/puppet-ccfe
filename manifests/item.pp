define ccfe::item (
  $parent,
  $action,
  $user         = 'root',
  $group        = 'root',
  $description  = $title,
) {
  $id = $title
  $basedir = $ccfe::basedir
  case $group {
    'root': {
      $mode = '0644'
    }
    default: {
      $mode = '0640'
    }
  }
  file { "${basedir}/${parent}.menu/${id}.item":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $mode,
    content => template('ccfe/item.erb'),
    require => File["${basedir}/${parent}.menu"],
  }
}
