# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'active_record'
require File::expand_path('../../database', __FILE__)

module DataTransit

module Source
  
    class SourceBase < ActiveRecord::Base
      self.abstract_class = true
      establish_connection DataTransit::Database.source
    end
  end

end