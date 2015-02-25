# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'rubygems'
require 'bundler/setup'
Bundler.require

#initial code
ENV['NLS_LANG'] = 'SIMPLIFIED CHINESE_CHINA.ZHS16GBK' if ENV['NLS_LANG'] == nil
# It is recommended to set time zone in TZ environment variable so that the same timezone will be used by Ruby and by Oracle session
ENV['TZ'] = 'UTC'


namespace :db  do
  
  desc "environment verification"
  task :environment do
    require 'active_record'
    #require 'activerecord-oracle_enhanced-adapter'
    #require 'oci8'

    require File::expand_path('../database', __FILE__)
    require File::expand_path('../model/tables_source', __FILE__)
    require File::expand_path('../model/tables_target', __FILE__)
    require File::expand_path('../model_dumper', __FILE__)
  end
  
  desc "dsl related definitions"
  task :dsl => :environment do
    require File::expand_path('../rule_dsl', __FILE__)
  end
  
  desc "generate schema.rb, the schema of source database"
  task :dump_schema => :dsl do
    puts "preparing to generate schema.rb, the schema of source database\n"
    ActiveRecord::Base.establish_connection(DataTransit::Database.source)
    #tables = DataTransit::Database.tables
    worker = DTWorker.new File::expand_path('../../rule.rb', __FILE__)
    worker.load_work
    tables = worker.tables
    
    print tables, "\n"
    
    dumper = DataTransit::ModelDumper.new tables
    dumper.dump_tables File.open(File::expand_path('../schema.rb', __FILE__), 'w');
    ActiveRecord::Base.remove_connection
    puts "schema.rb generated\n"
  end
  
  desc "use schema.rb to schema created in target database"
  task :create_tables => :environment do
    puts "\npreparing to create tables in the target database\n"
    ActiveRecord::Base.establish_connection(DataTransit::Database.target)
    require File.expand_path("../schema", __FILE__)
    ActiveRecord::Base.remove_connection
    puts "tables created in target database\n"
  end
  
  desc "data transit, copy rows from source db tables to target db tables\n it supports incremental copy by additional arguments"
  task :copy_data, [] => :dsl do
    worker = DTWorker.new File::expand_path('../../rule.rb', __FILE__)
    worker.do_work
  end
  
  #task :my, [:arg1, :arg2, :arg3, :arg4] => :environment do |t, args|
    #print t, args
    #tables = DataTransit::Database.tables
    #print tables
  #end
  
end
