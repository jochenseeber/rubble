require 'logging'
require 'shellwords'
require 'rubble/dsl'

module Rubble
    class Server
        attr_reader :tool
        attr_reader :name
        attr_reader :targets
        dsl_accessor :rubble_dir
        dsl_accessor :deploy_dir
        dsl_accessor :user
        dsl_accessor :group

        def initialize(tool, name)
            @tool = tool
            @name = name

            @log = Logging.logger[self]
            @targets = {}
            @rubble_dir = "/var/rubble"
            @user = 'root'
            @group = 'root'
            @deploy_dir = '#{env.name}/#{resource.type}/#{resource.name}'
        end

        def provide_target(type, name)
            group = @targets.fetch(type) do |k|
                @targets[type] = {}
            end
            group.fetch(name) do |k|
                group[name] = block_given? ? yield : @tool.create_target(type, name)
            end
        end

        def configure_target(type, name, *params, &block)
            target = provide_target(type, name) do
                @tool.create_target(type, name, *params)
            end
            if not block.nil? then
                Docile.dsl_eval(target, &block)
            end
        end

        def method_missing(symbol, *arguments, &block)
            if not @tool.nil? and @tool.is_target?(symbol) then
                configure_target(symbol, *arguments, &block)
            else
                super
            end
        end

        def respond_to?(symbol, include_private = false)
            if not @tool.nil? and @tool.is_target?(symbol) then
                true
            else
                super
            end
        end
    end
end
