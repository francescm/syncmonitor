#encoding: utf-8

class AccessReader
#  attr_reader :audits
  def initialize(conn, time_shift)
    @conn = conn
    @time_shift = time_shift
  end
  
  def read_audits
    audits = @conn.search2("cn=accesslog", LDAP::LDAP_SCOPE_SUBTREE, "(&(reqResult=0)(reqStart>=#{@time_shift}))", ["reqStart", "reqDn", "reqMod"])   
  end
end
