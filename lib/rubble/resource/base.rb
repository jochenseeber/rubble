require 'rubble/dsl'
require 'rubble/snapshot'
require 'digest'
require 'yaml'

module Rubble
    module Resource
        class Base
            attr_reader :name
            def initialize(name, *params)
                @name = name
            end

            def type
                self.class.name.split('::').last.downcase
            end

            def get_version(filesets)
                md = Digest::SHA1.new
                filesets.each do |fileset|
                    fileset.paths.each do |path|
                        md.file(path)
                    end
                end
                md.hexdigest.force_encoding('UTF-8')
            end

            def get_filesets
                []
            end

            def snapshot
                filesets = get_filesets
                version = get_version(filesets)
                Snapshot.new(version, *filesets)
            end

            def to_s
                to_yaml
            end
        end
    end
end
