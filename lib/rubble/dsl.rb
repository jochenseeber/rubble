class Module
    # Create a DSL style accessor
    #
    # Works like :attr_accessor, with the difference that the getter has an optional parameter that sets the property
    # when present.
    #
    # @example Create a mutable DLS style property named 'plan'
    #
    # class Processor
    #   dsl_accessor :plan
    # end
    #
    # @param symbols [Array] names of the properties to create
    def dsl_accessor(*symbols)
        symbols.each do |symbol|
            class_eval %{
                def #{symbol}(value = nil)
                    if value.nil?
                        @#{symbol}
                    else
                        @#{symbol} = value
                    end
                end

                def #{symbol}=(value)
                    @#{symbol} = value
                end
            }
        end
    end
end
