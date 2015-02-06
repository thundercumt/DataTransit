# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module DataTransit

class RecordTransbaser
  attr_accessor :source, :target
  
  def initialize source, target
    @source = source
    @target = target
  end
  
  def transbase
    pre_work
    do_transbase
    post_work
  end
  
  protected
  def pre_work
    
  end
  
  def do_transbase
    
  end
  
  def post_work
    
  end
  
  private
  def check_db_conn
    
  end
  
end

end
