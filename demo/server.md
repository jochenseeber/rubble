# Server

## Configure the Rubble directory

Create a new test server and configure it as follows:

    rubble_dir '/var/test'

Now check the configuration.

    @server.rubble_dir.assert == '/var/test'

## Configure the deploy directory

Create a new test server and configure it as follows:

    deploy_dir '/var/test'

Now check the configuration.

    @server.deploy_dir.assert == '/var/test'

## Configure the user

Create a new test server and configure it as follows:

    user 'test'

Now check the configuration.

    @server.user.assert == 'test'

## Configure the group

Create a new test server and configure it as follows:

    group 'test'

Now check the configuration.

    @server.group.assert == 'test'

## Configure the targets

Create a new test server and configure it as follows:

    directory 'test'

Now check the configuration.

    @server.targets.size.assert == 1
    @server.targets[:directory].size.assert == 1
    @server.targets[:directory]['test'].assert.is_a? Target::Directory
