# Logging

## Set the MDC

The context method allows code to be executed with specific values in the MDC.

    Logging.mdc['test'].assert == nil
    Logging.context(:test => 'test') do
        Logging.mdc['test'].assert == 'test'
    end
    Logging.mdc['test'].assert == nil
