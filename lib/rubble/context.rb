require 'base32'
require 'rubble/executor/local'
require 'rubble/executor/remote'

module Rubble
    class Context
        attr_reader :uuid
        attr_reader :tool
        attr_reader :local_executor

        def initialize(tool)
            @tool = tool
            uuid_str = SecureRandom.uuid.gsub(/-/, '')
            uuid_bytes = [uuid_str].pack('H*')
            @uuid = Base32.encode(uuid_bytes).gsub(/=+$/, '')
            @remote_executors = {}
            @local_executor = Executor::Local.new
        end

        def remote_executor(server)
            @remote_executors.fetch(server.name) do |k|
                @remote_executors[server.name] = Executor::Remote.new(server, local_executor)
            end
        end

        def close
            @remote_executors.each_value do |executor|
                executor.close
            end
            @remote_executors = {}
        end
    end
end
