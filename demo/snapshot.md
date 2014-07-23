## Reports when it is empty

A snapshot reports when it is empty because it does not contain any file sets.

    snapshot = Snapshot.new('1')
    snapshot.assert.empty?

A snapshot reports when it is empty because all its file sets are empty.

    snapshot = Snapshot.new('1', FileSet.new('/tmp'))
    snapshot.assert.empty?

A snapshot reports when it is not empty.

    snapshot = Snapshot.new('1', FileSet.new('/tmp', 'a.txt'))
    snapshot.assert.not.empty?

## Read only

A snapshot prevents modification of its version.

    snapshot = Snapshot.new('1')
    RuntimeError.assert.raised? do
        snapshot.version << 'test'
    end

A snapshot prevents modification of its filesets.

    snapshot = Snapshot.new('1')
    RuntimeError.assert.raised? do
        snapshot.filesets << FileSet.new('/tmp')
    end
