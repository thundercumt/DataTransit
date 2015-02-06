# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'bundler/setup'
Bundler.require

#initial code
ENV['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' if ENV['NLS_LANG'] == nil

require 'yaml'
require 'activerecord-oracle_enhanced-adapter'
require 'active_record'
require 'oci8'


# It is recommended to set time zone in TZ environment variable so that the same timezone will be used by Ruby and by Oracle session
ENV['TZ'] = 'UTC'

#dbconfig = YAML::load(File.open('../database.yml'))





#load 'model/test.rb'
#tests = Test.all
#tests.each { |e| print e.cs_name, ' ', e.auth_name, ' ', e.srid, "\n"  }
#tests.each do |w| print w.cs_name, ' ', w.auth_name, ' ', w.srid, "\n" end

#ActiveRecord::SchemaDumper.dump ActiveRecord::Base.connection, File.open('schema.rb', 'w')

require_relative 'database'
require_relative 'model/tables_source'
require_relative 'model/tables_target'
require_relative 'model_dumper'



puts DataTransit::Source::Dept.count
###puts DataTransit::Target::Dept.count

puts "preparing to generate schema.rb, the schema of source database\n"
ActiveRecord::Base.establish_connection(DataTransit::Database.source)
tables = YAML::load(File.open('../SelectedTable.yml'))
dumper = DataTransit::ModelDumper.new tables
dumper.dump_tables File.open('schema.rb', 'w');
ActiveRecord::Base.remove_connection
puts "schema.rb generated\n"

puts "\npreparing to create schema in the target database\n"
ActiveRecord::Base.establish_connection(DataTransit::Database.target)

require File.expand_path("schema")
system 'type schema.rb'#schema.rb has not been created yet

print ActiveRecord::Base.connection.tables