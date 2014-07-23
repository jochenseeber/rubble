require 'rubygems'
require 'commander'
require 'rubble'
require 'yaml'
require 'logging'

module Rubble
    # Rubble application class
    class Application
        include Commander::Methods

        def initialize
            @config_file = 'config/deploy.rubble'
        end

        def tool
            if @tool.nil? then
                @tool = Rubble::Tool.new
                @tool.read_config(@config_file)
            end

            @tool
        end

        def run
            program :name, 'Rubble'
            program :version, Rubble::VERSION
            program :description, 'Rubble Deployment Tool'

            Logging.color_scheme('bright',
            :lines => {
                :debug => :blue,
                :warn => :yellow,
                :error => :orange,
                :fatal => :red
            },
            )

            Logging.logger.root.level = :info
            Logging.logger.root.appenders = Logging.appenders.stdout(
            'stdout',
            :layout => Logging.layouts.pattern(
            :pattern => '==> %m %X{server}\n',
            :color_scheme => 'bright'
            )
            )

            log = Logging.logger[self]

            global_option('-l', '--loglevel STRING', 'Log level') do |level|
                Logging.logger.root.level = level.to_sym
            end

            global_option('-f', '--file FILE', 'Configuration file') do |file|
                @config_file = file
                @tool = nil
            end

            command :upload do |c|
                c.description = 'Upload a release'
                c.action do |args, options|
                    tool.execute(args) do |plan, context|
                        command = Rubble::Command::Upload.new(plan, context)
                        command.execute
                    end
                end
            end

            command :activate do |c|
                c.description = 'Activate a release'
                c.action do |args, options|
                    tool.execute(args) do |plan, context|
                        command = Rubble::Command::Activate.new(plan, context)
                        command.execute
                    end
                end
            end

            run!
        end
    end
end
