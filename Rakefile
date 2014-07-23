require 'bundler/gem_tasks'
require 'yard'

desc "Run QED tests"
task :test do
    sh "qed -v -p coverage"
end

YARD::Rake::YardocTask.new(name = :doc)
