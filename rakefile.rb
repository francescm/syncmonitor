#encoding: utf-8

$:.unshift "."

require 'rake'
require 'rspec/core/rake_task'
require 'access_reader'
require 'logger'

task :default => [:sync_monit]

RSpec::Core::RakeTask.new(:spec) 

desc "run spec"
task :rspec => :spec

desc "monit sync producer -> consumer"
task :sync_monit do
  logger = Logger.new('sync.log')
  factory = InitFactory.new
  producer = factory.producer
  consumer = factory.consumer
  timeshift = factory.timeshift
  
end
