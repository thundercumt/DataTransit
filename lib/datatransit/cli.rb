# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#require 'rubygems'
#require 'bundler/setup'
#Bundler.require

#initial code
ENV['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' if ENV['NLS_LANG'] == nil
# It is recommended to set time zone in TZ environment variable so that the same timezone will be used by Ruby and by Oracle session
ENV['TZ'] = 'UTC'


require 'active_record'
require File::expand_path('../database', __FILE__)
require File::expand_path('../model/tables_source', __FILE__)
require File::expand_path('../model/tables_target', __FILE__)
require File::expand_path('../model_dumper', __FILE__)
require File::expand_path('../rule_dsl', __FILE__)
  
def dump_schema schema_file, rule_file
  puts "preparing to generate schema.rb, the schema of source database\n"
  ActiveRecord::Base.establish_connection(DataTransit::Database.source)
  #tables = DataTransit::Database.tables
  worker = DTWorker.new rule_file
  worker.load_work
  tables = worker.tables

  print tables, "\n"

  dumper = DataTransit::ModelDumper.new tables
  dumper.dump_tables File.open(schema_file, 'w');
  ActiveRecord::Base.remove_connection
  puts "schema.rb generated\n"
end
  
def create_tables schema_file
  puts "\npreparing to create tables in the target database\n"
  ActiveRecord::Base.establish_connection(DataTransit::Database.target)
  require schema_file
  ActiveRecord::Base.remove_connection
  puts "tables created in target database\n"
end
  
  
def copy_data rule_file
  worker = DTWorker.new rule_file
  worker.do_work
end

