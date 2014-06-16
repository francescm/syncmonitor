#encoding: utf-8

require_relative '../access_reader'
require 'ldap'
require 'time'

describe AccessReader do
  before(:each) do
    @logger = double("logger")
  end

  it "inizializes with a conn and a time_shift" do
    conn = double("conn")
    access_reader = AccessReader.new(conn, "20140616061126.000002Z", @logger)
    expect access_reader
  end

  it "is able to read audits and return an array" do
    #five minutes ago
    timeshift = (Time.now - 300).utc.strftime("%Y%m%d%H%M%S.000000Z")
    conn = double("conn")
    expect(conn).to receive(:search2).with("cn=accesslog", LDAP::LDAP_SCOPE_SUBTREE, "(&(reqResult=0)(reqStart>=#{timeshift}))", ["reqStart", "reqDn", "reqMod"]).and_return([])
    access_reader = AccessReader.new(conn, timeshift, @logger)
    audits = access_reader.read_audits
    expect(audits).to be_a Array
  end
end
