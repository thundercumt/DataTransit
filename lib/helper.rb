# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module TimeExt
  def fly_by_day days
    Time.at(self.to_i + days * 24 * 60 * 60)
  end
  
  def fly_by_week weeks
    Time.at(self.to_i + weeks * 7 * 24 * 60 * 60)
  end
  
  def fly_by_month months
    Time.at(self.to_i + months * 30 * 24 * 60 * 60)
  end
  
  def midnight
    Time.at(self.year, self.month, self.day, 24, 0, 0 )
  end
  
end

class Time
  include TimeExt
end
