# Tool

## Configures the resources

A tool allows the configuration of resources.

Create a new test tool and configure it as follows:

    fileset 'test'

Now check the configuration.

    @tool.resources.size.assert == 1
    @tool.resources[:fileset]['test'].assert.is_a? Resource::Fileset

## Configures the servers

Create a new test tool and configure it as follows:

    server 'test'

Now check the configuration.

    @tool.servers.size.assert == 1
    @tool.servers['test'].assert.is_a? Server

## Configures the environments

Create a new test tool and configure it as follows:

    environment 'test'

Now check the configuration.

    @tool.environments.size.assert == 1
    @tool.environments['test'].assert.is_a? Environment
