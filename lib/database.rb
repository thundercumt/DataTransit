# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module DataTransit

class Database
    
    @@dbconfig = YAML::load( File.open( File.expand_path('../../database.yml', __FILE__) ) )
    
    def self.source
      @@dbconfig['development2']
    end
    
    def self.target
      @@dbconfig['development_target']
    end
  
  end
  
end
