define ccfe::item (
  $parent,
  $action,
  $user         = 'root',
  $group        = 'root',
  $description  = $title,
) {
  $id = $title
  $basedir = $ccfe::basedir
  file { "${basedir}/${parent}.menu/${id}.item":
    ensure  => present,
    owner   => $user,
    group   => $group,
    content => template('ccfe/item.erb'),
    require => File["${basedir}/${parent}.menu"],
  }
}
