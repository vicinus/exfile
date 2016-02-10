#exfile

##Overview

The exfile module defines an extended file resource which supports filenames which are relative to a base directory. Also parent directories can be automatically created, but there are some limitations that you need to be aware of. Additional it's possible to simple format content via templates.

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

###create_parent_dirs examples

When `create_parent_dirs` is activated for directories used in the path or title file resources are created, but not for directories use in the basedir parameter.

```puppet
    exfile { 'a/b/c.txt':
      basedir => '/tmp',
      create_parent_dirs => true,
    }
```

The example above will create file resources for the directories `/tmp/a` and `/tmp/b` but not for `/tmp`. The parameters owner, group and mode if set at the exfile resource are also used for the directory file resources. Puppet will automatically add the x modifier to the mode parameter of directories.

###content_type examples

The `content_type` can be used to format the provided content.

```puppet
    exfile { '/tmp/test.txt':
      content_type => 'erb',
      content_template => 'exfile/hashofkeyvalue.erb',
      content => { 'key1' => 'value1', 'key2' => 'value2', },
    }
```

The above example will create a file with content

```
  key1 = value1
  key2 = value2
```
