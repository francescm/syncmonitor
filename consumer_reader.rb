#encoding: utf-8

class ConsumerReader
  def initialize(conn, logger)
    @conn = conn
    @logger = logger
  end
  
  def check_audit(audit)
    dn = audit["reqDN"].first
    rdn = dn.split(",").first
    basename = dn.split(",")[1..-1].join(",")

    audit["reqMod"].each do |mod|
      attr, op_target = mod.split(":")
      operation = op_target[0, 1]
      target = op_target[2..-1]
      value = @conn.search2(basename, LDAP::LDAP_SCOPE_SUBTREE, rdn, [ attr ]).first
      if ["=", "+"].include? operation
        if value[attr].include? target
          true
        else
          return fail(attr, target, value)
        end
      elsif operation.eql? "-"
        if value[attr].include? target
          return fail(attr, target, value)
        else
          true
        end
      end        
    end

    true
  end

  private
  def fail(attr, target, value)
#    @logger.info("")
    false
  end
end
