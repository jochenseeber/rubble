require 'yaml'

module Rubble
    class Snapshot
        attr_reader :version
        attr_reader :filesets

        def initialize(version, *filesets)
            @version = version.dup.freeze
            @filesets = filesets.flatten.dup.freeze
        end

        def to_s
            to_yaml
        end

        def empty?
            @filesets.find{|f| not f.empty?} == nil
        end
    end
end
