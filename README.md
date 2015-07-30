#exfile

##Overview

The exfile module defines an extended file resource which supports filenames which are relative to a base directory. Additional it's possible to simple format content via templates.

##Examples

The exfile resource can be used like the file resource. To define a file relative to configured base directory, use the basedir parameter.

```puppet
    exfile { 'test.txt':
      basedir => '/tmp',
    }
```

This will create the file `/tmp/test.txt`. It's also possible to create with the path parameter. The following will also create `/tmp/test.txt`.

```puppet
    exfile { 'testfile':
      path    => 'test.txt',
      basedir => '/tmp',
    }
```

###contenttemplate examples

The `contenttemplate` can be freely choosen to format the provided content.

```puppet
    exfile { '/tmp/test.txt':
      contenttemplate => 'exfile/hashofkeyvalue.erb',
      content => { 'key1' => 'value1', 'key2' => 'value2', },
    }
```

The above example will create a file with content

`
key1 = value1
key2 = value2
`
