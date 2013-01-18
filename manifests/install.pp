class ccfe::install (
  $filestore,
  $package_file,
  $workspace,
) {
  if ! defined(File[$workspace]) {
    file { $workspace:
      ensure => directory,
      mode   => '0755',
    }
  }
  file { 'ccfe-rpm':
    ensure  => file,
    path    => "${workspace}/${package_file}",
    source  => "${filestore}/${package_file}",
  }
  package { 'ccfe':
    ensure   => installed,
    provider => 'rpm',
    source   => "${workspace}/${package_file}",
    require  => File['ccfe-rpm'],
  }
}
