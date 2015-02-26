# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module DataTransit
  class GivenTableDumper < ActiveRecord::SchemaDumper
    
    def self.give_tables tables
      @@tables = tables
    end
    
    def dump(stream)
=begin      
      if all_tables_exist?
        header(stream)
        tables(stream)
        trailer(stream)
      else
        print "No schema generated, because some table[s] do not exist!\n"
      end
=end
      header(stream)
      tables(stream)
      trailer(stream)
      
      stream
    end
    
    def tables(stream)
      @@tables.each do |tbl|
        table(tbl, stream)
      end
    end
    
  private
    def all_tables_exist?
      all_tables = @connection.tables
      print all_tables, '!!!!!!!!!!!!!!!!!!!!111'
      tables_all_exist = true
      
      @@tables.each do |tbl|
        unless all_tables.include? tbl
          print "table [", tbl, "] doesn't exist!\n" 
          tables_all_exist = false
        end
      end
      
      tables_all_exist
    end
  end
  
  
  class ModelDumper
    
    def initialize table_list
      @tables = table_list
    end
    
    def dump_tables (stream)
      GivenTableDumper.give_tables @tables
      GivenTableDumper.dump ActiveRecord::Base.connection, stream
    end
  end
  
end
