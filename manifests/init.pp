# == Define Resource Type: exfile
#
# Extended file resource that supports filenames, that are relative to a base
#  directory. Also parent directories can be automatically created (with some
#  limitations). Content can be created via templates.
#
# === Requirement/Dependencies:
#
# Currently requires the puppetlabs/stdlib module on the Puppet Forge
#
# === Parameters
#
# Supports all parameters, that the file resource also supports. The following
#  additional parameters are used:
#
# [*basedir*]
#    if path (or title, if path is empty) is relative, basedir is prepended.
#    Default: undef.
#
# [*create_parent_dirs*]
#    if set to true, creates directory file resources for every directory
#    between basedir (or '/' if basedir is not set) and the location of the
#    exfile resource.
#    Default: false.
#
# [*content_type*]
#    Can be 'plain', 'epp', 'inline_epp', 'erb' or 'inline_erb'.
#    Default: 'plain'.
#
# [*content_template*]
#    if content_type is anything expect 'plain', then this value is used for
#    the template.
#    Default: undef.
#
# [*additional_parameters*]
#    additional parameters added on epp and inline_epp generation.
#    Default: {}.
#
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
    if $path =~ /\&/ {
      $path_or_name = regsubstext($path, '&{[a-zA-Z0-9_-]*}', suffix(prefix($additional_parameters, '&{'), '}'))
    } else {
      $path_or_name = $path
    }
  }
  if is_absolute_path($path_or_name) {
    if $basedir != undef {
      fail("basedir can only be used if no absolute path is given.")
    }
    $real_path = $path_or_name
  } else {
    $real_path = "${basedir}/${path_or_name}"
  }
  validate_absolute_path($real_path)
  if $create_parent_dirs {
    if $basedir {
      $path_or_name_base = regsubst($path_or_name, "^${basedir}/", '')
    } else {
      $path_or_name_base = $path_or_name
    }
    ensure_resource('file', path_array($path_or_name_base, $basedir), {
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    })
  }
  if $target and $target =~ /\&/ {
    $real_target = regsubstext($target, '&{[a-zA-Z0-9_-]*}', suffix(prefix($additional_parameters, '&{'), '}'))
  } else {
    $real_target = $target
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
    target                  => $real_target,
    type                    => $type,
  }
}
