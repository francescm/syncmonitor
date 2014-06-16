#encoding: utf-8

class AccessReader
#  attr_reader :audits
  def initialize(conn, timeshift, logger)
    @conn = conn
    @timeshift = timeshift
    @logger = logger
  end
  
  def read_audits
    audits = @conn.search2("cn=accesslog", LDAP::LDAP_SCOPE_SUBTREE, "(&(reqResult=0)(reqStart>=#{@timeshift}))", ["reqStart", "reqDn", "reqMod"])   
  end
end
