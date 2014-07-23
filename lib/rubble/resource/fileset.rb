require 'rubble/resource/base'
require 'rubble/file_set'
require 'find'
require 'docile'

module Rubble
    module Resource
        class Directory
            attr_reader :includes
            attr_reader :excludes
            dsl_accessor :hidden

            def initialize(name)
                @name = name
                @includes = []
                @excludes = []
                @default_includes = ['**/*']
                @default_excludes = ['**/*~', '**/#*#']
                @flags = File::FNM_PATHNAME
            end

            def includes(*pattern)
                @includes.concat(Array(pattern))
            end

            def excludes(*pattern)
                @excludes.concat(Array(pattern))
            end

            def hidden(*values)
                if values.empty? then
                    (@flags & File.FNM_DOTMATCH) != 0
                else
                    if values[0] then
                        @flags |= File.FNM_DOTMATCH
                    else
                        @flags &= ~File.FNM_DOTMATCH
                    end
                end
            end

            def get_fileset
                files = []
                dir = Pathname.new(@name)

                Find.find(dir) do |path|
                    pathname = Pathname.new(path).relative_path_from(dir).to_s

                    if pathname != '.' then
                        match = (@includes.empty? ? @default_includes : @includes).any? {|p| File.fnmatch?(p, pathname, @flags)}
                        match = match and not (@excludes.empty? ? @default_excludes : @excludes).any? {|p| File.fnmatch?(p, pathname, @flags)}

                        if match then
                            if not File.directory?(path) then
                                files << pathname
                            end
                        else
                            if File.directory?(path) then
                                Find.prune
                            end
                        end
                    end
                end

                FileSet.new(dir.to_s, files)
            end
        end

        class Fileset < Base
            def initialize(name, *params)
                super(name, *params)

                @directories = []
            end

            def directory(name, &block)
                dir = Directory.new(name)
                if not block.nil? then
                    Docile.dsl_eval(dir, &block)
                end
                @directories << dir
            end

            def get_filesets
                filesets = []
                @directories.each do |directory|
                    filesets << directory.get_fileset
                end
                filesets
            end
        end
    end
end
