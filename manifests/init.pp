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
  $checksum_value = undef,
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
  $source_permissions = undef,
  $sourceselect = undef,
  $target = undef,
  $type = undef,
  $validate_cmd = undef,
  $validate_replacement = undef,

  $content_type = 'plain',
  $content_template = undef,
  $additional_parameters = {},
) {
  if $path == undef {
    $path_or_name = $name
  } else {
    if $path =~ /\&/ {
      $path_or_name = regsubst($path, '&{[a-zA-Z0-9_-]*}', suffix(prefix($additional_parameters, '&{'), '}'))
    } else {
      $path_or_name = $path
    }
  }
  if $path_or_name =~ Stdlib::Absolutepath {
    if $basedir != undef {
      if (length($path_or_name) <= length($basedir)) or ($path_or_name[0,length($basedir)+1] != "${basedir}/") {
        fail("basedir can only be used if no absolute path is given. ${path_or_name[0,length($basedir)+1]} -- $basedir")
      }
    }
    $_path = $path_or_name
  } else {
    $_path = "${basedir}/${path_or_name}"
  }
  assert_type(Stdlib::Absolutepath, $_path)

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
    $_target = regsubst($target, '&{[a-zA-Z0-9_-]*}', suffix(prefix($additional_parameters, '&{'), '}'))
  } else {
    $_target = $target
  }
  case $content_type {
    'plain': {
      $_content = $content
    }
    'epp': {
      $_content = epp($content_template, $additional_parameters)
    }
    'inline_epp': {
      $_content = inline_epp($content_template, $additional_parameters)
    }
    'erb': {
      if $content_template =~ /\.erb$/ {
        $_content = template($content_template)
      } else {
        $_content = template("${module_name}/${content_template}.erb")
      }
    }
    'inline_erb': {
      $_content = inline_template($content_template)
    }
    default: {
      fail("Unknown content type: '${content_type}'.")
    }
  }
  assert_type(Optional[String], $_content)

  file { $name:
    ensure                  => $ensure,
    path                    => $_path,
    backup                  => $backup,
    checksum                => $checksum,
    checksum_value          => $checksum_value,
    content                 => $_content,
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
    source_permissions      => $source_permissions,
    sourceselect            => $sourceselect,
    target                  => $_target,
    type                    => $type,
    validate_cmd            => $validate_cmd,
    validate_replacement    => $validate_replacement,
  }
}
