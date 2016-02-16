# Definition: exfile
#
# Extended file resource with option to define the path relative
#
# Parameters (see file resource except):
#  - basedir: if path or title is relative, basedir is prepended
#  - contenttemplate: optional template to format content
#  - contentmerger: optional configuration value used by contenttemplate
define exfile (
  $basedir = undef,
  $create_parent_dirs = false,
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

  $content_type = 'plain',
  $content_template = undef,
  $additional_parameters = {},
) {
  if $path == undef {
    $path_or_name = $name
  } else {
    $path_or_name = $path
  }
  $real_path = $path_or_name ? {
    /^\//     => $path_or_name,
    default => "${basedir}/${path_or_name}",
  }
  validate_absolute_path($real_path)
  if $create_parent_dirs {
    ensure_resource('file', path_array($path_or_name, $basedir), {
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    })
  }
  case $content_type {
    'plain': {
      $real_content = $content
    }
    'epp': {
      $real_content = epp($content_template, $additional_parameters)
    }
    'inline_epp': {
      $real_content = inline_epp($content_template, $additional_parameters)
    }
    'erb': {
      if $content_template =~ /\.erb$/ {
        $real_content = template($content_template)
      } else {
        $real_content = template("${module_name}/${content_template}.erb")
      }
    }
    'inline_erb': {
      $real_content = inline_template($content_template)
    }
    default: {
      fail("Unknown content type: '${content_type}'.")
    }
  }
  if $real_content != undef {
    validate_string($real_content)
  }

  file { $name:
    ensure                  => $ensure,
    path                    => $real_path,
    backup                  => $backup,
    checksum                => $checksum,
    content                 => $real_content,
    ctime                   => $ctime,
    force                   => $force,
    group                   => $group,
    ignore                  => $ignore,
    links                   => $links,
    mode                    => $mode,
    mtime                   => $mtime,
    owner                   => $owner,
    provider                => $provider,
    purge                   => $purge,
    recurse                 => $recurse,
    recurselimit            => $recurselimit,
    replace                 => $replace,
    selinux_ignore_defaults => $selinux_ignore_defaults,
    selrange                => $selrange,
    selrole                 => $selrole,
    seltype                 => $seltype,
    seluser                 => $seluser,
    show_diff               => $show_diff,
    source                  => $source,
    sourceselect            => $sourceselect,
    target                  => $target,
    type                    => $type,
  }
}
