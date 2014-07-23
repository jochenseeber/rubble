require 'digest'
require 'rubble/dsl'

module Rubble
    module Target
        class Base
            attr_reader :name
            dsl_accessor :service

            def initialize(name)
                @name = name
                @service = "#{self.class.name.downcase.split(/::/).last}#{suffix}"
            end

            def type
                self.class.name.downcase.to_sym
            end

            def suffix
                (name == :default) ? '' : "-#{name}"
            end
        end
    end
end
