require 'logging'
require 'tempfile'
require 'pathname'
require 'shellwords'
require 'ostruct'

module Rubble
    module Executor
        SyncList = Struct.new(:dirs, :files)

        class Base
            def initialize
                @log = Logging.logger[self]
            end

            def exec(*command)
                run(*command)
            end

            def convert_options(options)
                switches = []

                options.each do |k, v|
                    if not v.nil? then
                        switches << "--#{k.to_s.gsub(/_/, '-')}"
                        if not v == true then
                            switches << v
                        end
                    end
                end

                switches
            end

            def rsync_includes(filesets)
                dirs = []
                files = Set.new

                filesets.each do |fileset|
                    dirs << "#{fileset.dir.to_s}/"

                    fileset.files.each do |file|
                        until file.to_s == '.'
                            files << "+ #{file.to_s}"
                            file = file.parent
                        end
                    end
                end

                files = files.to_a.sort
                files << '- *'

                SyncList.new(dirs, files)
            end

            def rsync_remote_prefix
                ''
            end

            def rsync(*parameters)
                paths = []
                options = {
                    :recursive => nil,
                    :dirs => nil,
                    :delete => nil,
                    :delete_excluded => nil,
                    :include_from => nil,
                    :rsh => 'ssh -o ClearAllForwardings=Yes',
                    :verbose => nil
                }
                includes = []

                parameters.each do |parameter|
                    if parameter.is_a?(Hash) then
                        parameter.each do |name, value|
                            if name.to_s == 'includes' then
                                Array(value).each do |v|
                                    includes << v
                                end
                            elsif options.include?(name) then
                                options[name] = value
                            else
                                raise "Unknown rsync parameter #{name}."
                            end
                        end
                    else
                        paths << parameter
                    end
                end

                begin
                    tempfile = nil

                    if not includes.empty? then
                        tempfile = Tempfile.new(['includes', '.rsync'])
                        begin
                            includes.each do |f|
                                tempfile.puts f
                            end
                        end
                        tempfile.close

                        options[:include_from] = tempfile.path
                    end

                    command = ['rsync'].concat(['-vv']).concat(convert_options(options)).concat(paths)

                    @log.info("Rsyncing #{paths[0..-2].join(', ')} to #{paths[-1]}.")
                    run(*command)
                ensure
                    tempfile && tempfile.close!
                end
            end

            # Redirect stdout and return output
            #
            # @yield Execute block with redirected stdout
            # @return [String] Output
            def redirect
                begin
                    old_stdout = $stdout
                    old_stderr = $stderr
                    $stdout = StringIO.new('', 'w')
                    $stderr = $stdout
                    result = yield
                    [result, $stdout.string]
                ensure
                    $stdout = old_stdout
                    $stderr = old_stderr
                end
            end
        end
    end
end
