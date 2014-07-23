# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubble/version'

Gem::Specification.new do |spec|
    spec.name = 'rubble'
    spec.version = Rubble::VERSION
    spec.authors = ['Jochen Seeber']
    spec.email = ['jochen@seeber.me']
    spec.summary = 'Lightweight convention over configuration deploy tool'
    spec.description = 'This tool allows you to easily deploy applications to servers. Though currently only Java WARs and Tomcat servers are supported ;-)'
    spec.homepage = 'https://github.com/jochenseeber/rubble'
    spec.license = 'AGPL-3.0'
    spec.metadata = {
        'issue_tracker' => 'https://github.com/jochenseeber/rubble/issues',
        'source_code' => 'https://github.com/jochenseeber/rubble',
        'documentation' => 'http://rubydoc.info/gems/rubble/frames',
        'wiki' => 'https://github.com/jochenseeber/rubble/wiki'
    }

    spec.files = Dir['README.md', 'LICENSE.txt', '.yardopts', 'lib/**/*.rb', 'demo/**/*.{md,rb}']
    spec.executables = ['rubble']
    spec.require_paths = ['lib']

    spec.required_ruby_version = '>= 1.9'

    spec.add_dependency 'commander', '~> 4.2'
    spec.add_dependency 'docile', '~> 1.1'
    spec.add_dependency 'rye', '~> 0.9'
    spec.add_dependency 'base32', '~> 0.3'
    spec.add_dependency 'logging', '~> 1.8'

    spec.add_development_dependency 'bundler', '~> 1.7'
    spec.add_development_dependency 'rake', '~> 10.3'
    spec.add_development_dependency 'qed', '~> 2.9'
    spec.add_development_dependency 'ae', '~> 1.8'
    spec.add_development_dependency 'yard', '~> 0.8'
    spec.add_development_dependency 'coveralls', '~> 0.7'
end
