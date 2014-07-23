require 'rubble/application'

include Rubble

def run_rubble_command(arguments)
    Commander::Runner.instance_variable_set :"@singleton", Commander::Runner.new(arguments)
    app = Rubble::Application.new
    app.run
end

# Create a Tool object for testing
When /create a new test tool/i do |configuration|
    raise(ArgumentError, 'Please supply a block with configuration.') if configuration.nil?

    @tool = Tool.new
    @tool.instance_eval(configuration)
end

# Create an Environment object for testing
When /create a new test environment/i do |configuration|
    raise(ArgumentError, 'Please supply a block with configuration.') if configuration.nil?

    @environment = Environment.new(Tool.new, 'test')
    @environment.instance_eval(configuration)
end

# Create a Server object for testing
When /create a new test server/i do |configuration|
    raise(ArgumentError, 'Please supply a block with configuration.') if configuration.nil?

    @server = Server.new(Tool.new, 'test')
    @server.instance_eval(configuration)
end
