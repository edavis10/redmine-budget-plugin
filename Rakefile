#!/usr/bin/env ruby
require 'redmine_plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup do |plugin|
  plugin.project_name = 'budget_plugin'
  plugin.default_task = [:spec]
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "budget_plugin"
    s.summary = "A plugin for Redmine to manage the set of deliverables for each project, automatically calculating key performance indicators."
    s.email = "edavis@littlestreamsoftware.com"
    s.homepage = "https://projects.littlestreamsoftware.com/projects/redmine-budget"
    s.description = "A plugin for Redmine to manage the set of deliverables for each project, automatically calculating key performance indicators."
    s.authors = ["Eric Davis"]
    s.rubyforge_project = "budget_plugin" # TODO
    s.files =  FileList[
                        "[A-Z]*",
                        "init.rb",
                        "rails/init.rb",
                        "{bin,generators,lib,test,app,assets,config,lang}/**/*",
                        'lib/jeweler/templates/.gitignore'
                       ]
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
