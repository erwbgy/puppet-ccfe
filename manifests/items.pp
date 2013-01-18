class ccfe::items (
  $config = undef,
) {
  $defaults = {}
  if $config {
    create_resources('ccfe::item', $config, $defaults)
  }
  else {
    $hiera_config = hiera_hash('ccfe::items', undef)
    if $hiera_config {
      create_resources('ccfe::item', $hiera_config, $defaults)
    }
  }
}
