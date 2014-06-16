#encoding: utf-8

require 'yaml'
require 'ldap'
require 'time'

class InitFactory
  attr_reader :consumer, :producer, :timeshift

  def initialize
    raise "missing config.yaml" unless File.exists?("config.yaml")
    configs = YAML.load_file("config.yaml")
    prod = configs[:producer]
    @producer = LDAP::SSLConn.new(prod[:url], 389, true)
    @producer.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3) 
    @producer.bind(prod[:bind_dn], prod[:bind_pw])

    cons = configs[:consumer]
    @consumer = LDAP::SSLConn.new(cons[:url], 389, true)
    @consumer.set_option(LDAP::LDAP_OPT_PROTOCOL_VERSION, 3) 
    @consumer.bind(cons[:bind_dn], cons[:bind_pw])
    @timeshift = if configs.keys.include? :timeshift
                   configs[:timeshift]
                 else
                   # one hour ago
                   (Time.now - 3600).utc.strftime("%Y%m%d%H%M%S.000000Z")
                 end
  end
end
