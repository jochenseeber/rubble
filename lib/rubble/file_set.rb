require 'yaml'

module Rubble
    class FileSet
        attr_reader :dir
        attr_reader :files

        def initialize(dir, *files)
            @dir = Pathname.pwd + Pathname(dir)
            if files.nil? then
                @files = []
            else
                flattened_files = (files || []).collect {|f| Array(f)}.flatten

                @files = flattened_files.map do |f|
                    p = (@dir + Pathname(f)).relative_path_from(@dir)
                    if p.to_s.start_with?('../') or p.to_s == '.' then
                        raise ArgumentError, "File name '#{f}' must be relative to base directory #{@dir} of the file set."
                    end
                    p
                end

                @files.sort!
            end

            @files.freeze
        end

        def paths
            @files.map {|f| @dir + f}
        end

        def empty?
            @files.empty?
        end

        def to_s
            to_yaml
        end
    end
end
