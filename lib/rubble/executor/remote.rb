require 'rubble/executor/base'
require 'rye'
require 'rubble/logging'
require 'tempfile'

module Rubble
    module Executor
        class Remote < Base
            attr_reader :box
            attr_reader :server
            attr_reader :local_executor

            def initialize(server, local_executor)
                super()

                @server = server
                @local_executor = local_executor
                @box = Rye::Box.new(server.name, :safe => false)
            end

            def rsync_remote_prefix
                "#{server.name}:"
            end

            def file_exists?(file_name)
                box.file_exists?(file_name)
            end

            def mkdir(directory)
                @log.info("Creating directory '#{directory}'.")
                exec('mkdir', '-p', directory.to_s)
            end

            def cd(directory, create)
                @log.info("Changing directory to #{directory}.")
                if create then
                    mkdir directory
                end
                box.cd(directory.to_s)
            end

            def symlink(source, target)
                @log.info("Symlinking #{source} to #{target}.")
                run('ln', '-s', '-f', '-T', source.to_s, target.to_s)
            end

            def run(*command)
                Logging.context(:server => server.name) do
                    command_str = Shellwords.join(command)
                    @log.debug(command_str)
                    box.execute(command_str)
                end
            end

            def close
                if not @box.nil? then
                    @box.disconnect
                end
            end

            def sync_up(filesets, target_dir, *options)
                includes = rsync_includes(filesets)
                parameters = includes.dirs.dup << (rsync_remote_prefix + target_dir).to_s
                @local_executor.rsync(*parameters, :includes => includes.files, :recursive => true, :delete => true,
                :delete_excluded => true)
            end

            def sync_down(filesets, target_dir, *options)
                files = rsync_includes(filesets).map {|f| rsync_remote_prefix + f}
                parameters = [target_dir].concat(files)
                parameters.concat(options)
                @local_executor.rsync *parameters
            end

            def sync_remote(source_dir, target_dir, *options)
                parameters = [source_dir, target_dir, *options]
                rsync *parameters
            end
        end
    end
end
