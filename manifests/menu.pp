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
  create_resources('ccfe::item', $items, $defaults)
}
