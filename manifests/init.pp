define exfile (
  $basedir = undef,
  $path = undef,
  $ensure = undef,
  $backup = undef,
  $checksum = undef,
  $content = undef,
  $ctime = undef,
  $force = undef,
  $group = undef,
  $ignore = undef,
  $links = undef,
  $mode = undef,
  $mtime = undef,
  $owner = undef,
  $provider = undef,
  $purge = undef,
  $recurse = undef,
  $recurselimit = undef,
  $replace = undef,
  $selinux_ignore_defaults = undef,
  $selrange = undef,
  $selrole = undef,
  $seltype = undef,
  $seluser = undef,
  $show_diff = undef,
  $source = undef,
  $sourceselect = undef,
  $target = undef,
  $type = undef,

  $contenttemplate = undef,
  $contentmerger = ' = ',
) {
  if $path == undef {
    $path_or_name = $name
  } else {
    $path_or_name = $path
  }
  $real_path = $path_or_name ? {
    /^\//     => $path_or_name,
    default => "${basedir}/$path_or_name",
  }
  validate_absolute_path($real_path)
  if $contenttemplate == undef {
    $real_content = $content
  } else {
    $real_content = template($contenttemplate)
  }
  if $real_content != undef {
    validate_string($real_content)
  }

  file { $name:
    ensure => $ensure,
    path => $real_path,
    backup => $backup,
    checksum => $checksum,
    content => $real_content,
    ctime => $ctime,
    force => $force,
    group => $group,
    ignore => $ignore,
    links => $links,
    mode => $mode,
    mtime => $mtime,
    owner => $owner,
    provider => $provider,
    purge => $purge,
    recurse => $recurse,
    recurselimit => $recurselimit,
    replace => $replace,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    selrange => $selrange,
    selrole => $selrole,
    seltype => $seltype,
    seluser => $seluser,
    show_diff => $show_diff,
    source => $source,
    sourceselect => $sourceselect,
    target => $target,
    type => $type,
  }
}
