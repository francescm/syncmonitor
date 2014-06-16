#encoding: utf-8

require_relative '../consumer_reader'
require 'ldap'

describe ConsumerReader do
  before(:each) do
    @logger = double("logger")
  end

  it "inizializes with a conn and a logger" do
    conn = double("conn")
    consumer_reader = ConsumerReader.new(conn, @logger)
    expect consumer_reader
  end

  it "is able to check audit and returns true" do
    conn = double("conn")
    audits = [{"reqDN" => ["uid=200001,ou=people,dc=unimore,dc=it"],
               "reqMod" => ["sambaPwdLastSet:= 1402905645"]
             }]
    expect(conn).to receive(:search2).with("ou=people,dc=unimore,dc=it", LDAP::LDAP_SCOPE_SUBTREE, "uid=200001", ["sambaPwdLastSet"]).and_return([{"sambaPwdLastSet" => ["1402905645"]}])
    consumer_reader = ConsumerReader.new(conn, @logger)
    ret = consumer_reader.check_audit(audits.first)
    expect(ret).to be true
  end
end
