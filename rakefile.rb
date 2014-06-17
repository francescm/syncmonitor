#encoding: utf-8

$:.unshift "."

require 'rake'
require 'rspec/core/rake_task'
require 'access_reader'
require 'consumer_reader'
require 'logger'
require 'init_factory'
require 'date'

task :default => [:sync_monit]

RSpec::Core::RakeTask.new(:spec) 

desc "run spec"
task :rspec => :spec

desc "monit sync producer -> consumer"
task :sync_monit do
  logger = Logger.new('sync.log')
  factory = InitFactory.new
  producer_conn = factory.producer
  consumer_conn = factory.consumer
  timeshift = factory.timeshift
  ar = AccessReader.new(producer_conn, timeshift, logger)
  cr = ConsumerReader.new(consumer_conn, logger)
  audits = ar.read_audits
  res = true
  audits.each do |audit|
    res = cr.check_audit(audit)
    break unless res
  end
  if res
    factory.save_timeshift
    logger.debug("Success: timeshift updated at #{Time.now.utc.strftime('%Y-%m-%d %H:%M:%S')}")
  else
    logger.info("Failure: timeshift #{timeshift} not updated")
  end
  producer_conn.unbind
  consumer_conn.unbind
end
