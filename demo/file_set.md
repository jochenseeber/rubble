# File Set

## Converts paths to Pathname

A file set converts the base directory to a pathname.

    fileset = FileSet.new('/tmp')
    fileset.dir.assert.is_a? Pathname

A file set converts the files to pathnames.

    fileset = FileSet.new('/tmp', 'test.txt')
    fileset.files[0].assert.is_a? Pathname

## Reports when it is empty

A file set reports when it is empty

    fileset = FileSet.new('/tmp')
    fileset.assert.empty?

A file set reports when it is not empty

    fileset = FileSet.new('/tmp', 'test.txt')
    fileset.assert.not.empty?

## Readonly

A file set freezes its files

    fileset = FileSet.new('/tmp')
    RuntimeError.assert.raised? do
        fileset.files << 'test.txt'
    end

## Sorts content

A file set sorts the contained files

    fileset = FileSet.new('/tmp', 'b.txt', 'a.txt')
    fileset.files.assert == [Pathname('a.txt'), Pathname('b.txt')]

## Ensures files are relative

A file set ensures all files are in the base directory

    FileSet.new('/tmp', 'test.txt').assert != nil
    FileSet.new('/tmp', '../tmp/test.txt').assert != nil

    ArgumentError.assert.raised? do
        FileSet.new('/tmp', '.')
    end

    ArgumentError.assert.raised? do
        FileSet.new('/tmp', '../usr/test.txt')
    end

    ArgumentError.assert.raised? do
        FileSet.new('/tmp', '/test.txt')
    end

A file set can return the full paths of the files

    fileset = FileSet.new('/tmp', 'test.txt')
    fileset.paths.first.assert == Pathname('/tmp/test.txt')
