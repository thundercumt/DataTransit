# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#chain_filter1 --> chain_filter2 --> chain_filter3

require 'singleton'

class Rule 
  include Singleton
  
  def initialize()
    
  end
  
  def rule(*args, &block) # :doc:
    define_task(*args, &block)
  end
  
protected
  def define_rule(*args, &block)
    
  end
  
end



rule :unwanted do |record| 

end