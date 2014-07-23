require 'rubble/executor/base'
require 'open3'
module Rubble
    module Executor
        class Local < Base
            class StreamInfo
                attr_accessor :data
                attr_accessor :level
                attr_reader :autoflush
                def initialize(level, autoflush)
                    @level = ::Logging::level_num(level)
                    @data = ""
                    @autoflush = autoflush
                end
            end

            class Line
                attr_reader :level
                attr_reader :text
                def initialize(level, text)
                    @level = level
                    @text = text.chomp
                end
            end

            class Output
                attr_reader :log
                attr_reader :lines
                def initialize(log)
                    @log = log
                    @lines = []
                    @flushed = false
                end
                def <<(line)
                    @lines << line
                    if @flushed then
                        @log.add(line.level, line.text)
                    end
                end
                def flush
                    @lines.each do |line|
                        @log.add(line.level, line.text)
                    end
                    @flushed = true
                end
            end

            def mkdir(directory_name)
                Pathname(directory_name).mkpath
            end

            def symlink(source, target)
                Pathname(target).make_symlink(Pathname(source))
            end

            def file_exists?(file)
                Pathname(file).exists?
            end

            def run(*command)
                command_str = Shellwords.join(command)
                @log.debug(command_str)

                status = nil
                output = Output.new(@log)

                Open3.popen3(command_str) do |stdin, stdout, stderr, thread|
                    streams = {stdout => StreamInfo.new(:info, false), stderr => StreamInfo.new(:error, false)}

                    until streams.empty? do
                        selected, = IO::select(streams.keys, nil, nil, 0.1)

                        if not selected.nil? then
                            selected.each do |stream|
                                info = streams[stream]

                                if stream.eof? then
                                    streams.delete(stream)

                                    if not info.data.empty? then
                                        output << Line.new(info.level, info.data)
                                    end
                                else
                                    data = info.data + stream.readpartial(1024)

                                    data.each_line do |line|
                                        if line.end_with?("\n") then
                                            output << Line.new(info.level, line)
                                        else
                                            info.data = line
                                        end
                                    end
                                end

                                if info.autoflush then
                                    output.flush
                                end
                            end
                        end
                    end

                    status = thread.value
                end

                if status.exitstatus != 0 then
                    output.flush
                    raise "Command failed with exit status #{status.exitstatus}."
                end
            end

        end
    end
end
