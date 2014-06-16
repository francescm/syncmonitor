#encoding: utf-8

$:.unshift "."

require 'rake'
require 'rspec/core/rake_task'
require 'access_reader'

task :default => [:inventory_charges]

RSpec::Core::RakeTask.new(:spec) 

desc "run spec"
task :rspec => :spec

desc "inventario degli incarichi U-GOV"
task :inventory_charges do
#  i = Inventory.new
#  charges = i.load_charges
#  pp charges
end
