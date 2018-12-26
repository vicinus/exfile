function exfile::path_array (
  String $filename,
  Stdlib::Unixpath $basedir = '/',
  #String $separator = '/',
) {
  $_filename = $filename.regsubst('(^//*|/*/$|[^/]*$)', '', 'G').regsubst('///*', '/', 'G').split('/')
  if $basedir[-1,1] == '/' {
    $_basedir = $basedir[0,-2]
  } else {
    $_basedir = $basedir
  }

  $_filename.reverse.reduce([]) |$memo, $value| {
    ($memo + ['']).map |$item| {
      "/${value}${item}"
    }
  }.map |$item| {
    "${_basedir}${item}"
  }
}
