require 'ae'

# Add bin directory to path
ENV['PATH'] = File.join(QED::Utils.root, 'bin') + ":" + ENV['PATH']

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
        yield
        $stdout.string
    ensure
        $stdout = old_stdout
        $stderr = old_stderr
    end
end

# Execute a registered command
#
# @param command [String] Command string
# @return [String] Command output
def execute_command(command)
    if command.nil? then
        raise(ArgumentError, 'Please supply a block with the command to run')
    end

    command.gsub!(/^#\s*/, '')
    arguments = Shellwords.shellsplit(command)
    method_name = "run_#{arguments[0]}_command".to_sym
    method = method(method_name)

    if method.nil? then
        raise(ArgumentError, "Please define a method named #{method_name} to test running the #{command[0]} command.")
    end

    @output = redirect do
        method.call(arguments[1..-1])
    end
end

# Remove empty lines and leading and trailing spaces from text
#
# @param text [String] Text to clean
# @return [String] cleaned text
def clean(text)
    raise(ArgumentError, 'Text must not be nil.') if text.nil?

    text.gsub(/\n+/, "\n").gsub(/^\s+|\s+$/, '')
end

# Save the following block as script
When /\buse\b[^.]+\bscript in (?:file )?`([a-z]+\.[a-z]+)`/i do |file_name, text|
    raise(ArgumentError, 'Please supply a block with a script.') if text.nil?

    File.open(file_name, 'w') do |f|
        f.write(text)
    end
end

# Expect the following block as text output
When /\bproduces\b[^.]+\btext output\b/i do |text|
    raise(ArgumentError, 'Please supply a block with the text') if text.nil?
    clean(@output).assert == clean(text)
end

# Execute the command in the following block
When /\bexecute\b[^.]+\bcommand\b/i do |command|
    execute_command(command)
end

# Execute the command in the following block and expect it to fail
When /\bexecuting\b[^.]+\bfails\b/i do |command|
    SystemExit.expect do
        execute_command(command)
    end
end
