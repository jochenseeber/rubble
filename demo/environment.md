# Environment

## Configure plans

An environment allows the configuration of plans.

Create a new test environment and configure it as follows:

    server 'test' do
        deploy fileset('test') => directory('test')
    end

Now check the configuration.

    @environment.plans.size.assert == 1
    @environment.plans[0].assert.is_a? Plan::Deploy

## Configure plans for multiple servers at once

An environment allows the configuration of multiple servers.

Create a new test environment and configure it as follows:

    server 'test1', 'test2' do
        deploy fileset('test') => directory('test')
    end

Now check the configuration.

    @environment.plans.size.assert == 2
    @environment.plans[0].assert.is_a? Plan::Deploy
    @environment.plans[1].assert.is_a? Plan::Deploy
