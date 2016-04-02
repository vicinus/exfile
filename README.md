#exfile

##Overview

The exfile module defines an extended file resource which supports filenames which are relative to a base directory. Also parent directories can be automatically created (with some limitations). Content can be created via templates and path and target parameters can contain special variables, that are expanded during resource creation.

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

`create_parent_dirs` ensures, that file resources with ensure directory for every directory between basedir (or '/' if basedir is not set) and the location of the exfile are created.

```puppet
    exfile { 'a/b/1.txt':
      basedir => '/tmp',
      create_parent_dirs => true,
    }
    exfile { 'a/b/2.txt':
      basedir => '/tmp',
      create_parent_dirs => true,
    }
```

The example above will create file resources for the directories `/tmp/a` and `/tmp/b` but not for `/tmp`. The parameters owner, group and mode if set at the exfile resource are also used for the directory file resources. Puppet will automatically add the x modifier to the mode parameter of directories. `ensure_resource` is used, so that not multiple file resources for the same directory are created. Therefore the limitations of `ensure_resource` apply (all parameters must be identical). Also an error applying the created catalog will ocour, if some directory in the list of automatically created directories is actually a link to another directory.

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
