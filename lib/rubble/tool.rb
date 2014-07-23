require 'rubble/file_set'
require 'rubble/environment'
require 'rubble/server'
require 'rubble/context'
require 'rubble/target/base'
require 'rubble/resource/base'
require 'rubble/plan/base'
require 'docile'

module Rubble
    class Tool
        attr_accessor :resources
        attr_accessor :servers
        attr_accessor :environments

        def initialize
            @log = Logging.logger[self]
            @resources = {}
            @servers = {}
            @environments = {}
        end

        def execute(environment_names)
            context = Context.new(self)
            begin
                environment_names.each do |environment_name|
                    environment = @environments[environment_name]

                    if environment.nil? then
                        raise ArgumentError, "Undefined environment '#{environment_name}'."
                    end

                    environment.execute(context) do |plan|
                        yield(plan, context)
                    end
                end
            ensure
                context.close
            end
        end

        def environment(name, &block)
            environment = @environments.fetch(name) do |k|
                @environments[name] = Environment.new(self, name)
            end
            if not block.nil? then
                Docile.dsl_eval(environment, &block)
            end
        end

        def server(name, &block)
            server = @servers.fetch(name) do |k|
                @servers[name] = Server.new(self, name)
            end
            if not block.nil? then
                Docile.dsl_eval(server, &block)
            end
        end

        def is_target?(symbol)
            name = symbol.to_s
            name =~ /^[a-z_]+$/i and Target.const_defined?(name.capitalize)
        end

        def is_resource?(symbol)
            name = symbol.to_s
            name =~ /^[a-z_]+$/i and Resource.const_defined?(name.capitalize)
        end

        def is_plan?(symbol)
            name = symbol.to_s
            name =~ /^[a-z_]+$/i and Plan.const_defined?(name.capitalize)
        end

        def create_resource(type, name, *params, &block)
            Resource.const_get(type.to_s.capitalize).new(name, *params)
        end

        def create_target(type, name, *params, &block)
            Target.const_get(type.to_s.capitalize).new(name, *params)
        end

        def create_plan(type, env, server, *params, &block)
            Plan.const_get(type.to_s.capitalize).new(env, server, *params)
        end

        def provide_server(name)
            @servers.fetch(name) do |k|
                @servers[name] = block_given? ? yield : Server.new(self, name)
            end
        end

        def provide_resource(type, name)
            group = @resources.fetch(type) do |k|
                @resources[k] = {}
            end
            group.fetch(name) do |k|
                group[name] = block_given? ? yield : create_resource(type, name)
            end
        end

        def configure_resource(type, name, *params, &block)
            resource = provide_resource(type, name) do
                create_resource(type, name, params)
            end
            if not block.nil? then
                Docile.dsl_eval(resource, &block)
            end
        end

        def read_config(file_name)
            if File.exists?(file_name) then
                @log.info("Reading configuration from '#{file_name}'.")
                configure(File.read(file_name), file_name)
            end
        end

        def configure(config, file_name = nil)
            self.instance_eval(config, file_name)
        end

        def method_missing(symbol, *arguments, &block)
            if is_resource?(symbol) then
                configure_resource(symbol, arguments[0], *arguments[1..-1], &block)
            else
                super
            end
        end

        def respond_to?(symbol, include_private = false)
            if is_target?(symbol) then
                true
            else
                super
            end
        end
    end
end
