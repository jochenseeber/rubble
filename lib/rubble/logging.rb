require 'logging'

module Logging
    class << self
        def context(*options)
            options.each do |option|
                option.each do |k, v|
                    Logging.mdc[k] = v
                end
            end

            if block_given? then
                yield
            end
        ensure
            options.each do |option|
                option.each do |k, v|
                    Logging.mdc.delete(k)
                end
            end
        end
    end
end
