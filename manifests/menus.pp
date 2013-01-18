class ccfe::menus (
  $config = undef,
) {
  $defaults = {}
  if $config {
    create_resources('ccfe::menu', $config, $defaults)
  }
  else {
    $hiera_config = hiera_hash('system::mounts')
    if $hiera_config {
      create_resources('ccfe::menu', $hiera_config, $defaults)
    }
  }
}
