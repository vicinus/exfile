module Puppet::Parser::Functions
  newfunction(:path_array, :type => :rvalue, :arity => -2, :doc =>
  "Creates an array were every directory of the given path with full provided
  path is an element. Optional prepends given basedir.

  * *Parameters* (in order):
    * _filename_ The filename to split.
    * _basedir_ directory prepanded. If nothing is given '/' is used.
  * *Examples*

  $res = path_array('/a/b/c/test.txt')
  `$res` contains: `['/a/b/c', '/a/b', '/a']`.

  $res = path_array('a/b/c/test.txt', '/usr/bin')
  `$res` contains: `['/usr/bin/a/b/c', '/usr/bin/a/b', '/usr/bin/a']`.

  Used for automatically creating parent directories:
  file { path_array('.facter/facts.d/custom_fact.txt', '/home/user'):
    ensure => directory,
    owner => 'user',
  }
  but be aware that links in the parent directory list will create errors and
  ownership will be ensured.
  ") do |args|
    filename, basedir = args
    if filename.start_with? File::SEPARATOR
      filename[0] = ''
    end
    if basedir == nil
      basedir = ''
    end
    if ! basedir.end_with? File::SEPARATOR
      basedir << File::SEPARATOR
    end
    res = []
    while filename.include? File::SEPARATOR
      filename = File.dirname(filename)
      res << "#{basedir}#{filename}"
    end
    res
  end
end
