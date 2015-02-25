# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'bundler/setup'
Bundler.require

=begin

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



=end

def choose_table(*tables)
  print tables.length, tables[0]
  tables.each {|tbl| print tbl, " "}
end


choose_table :hello, :world, "hi", "there", 2, 3.1415

def time_class
  "acquisitiontime"
end

#DIR.glob("*events.rb").each { |filename| load filename  }

all = proc { |ar_class| ar_class.method("find_each")  }
year = proc { |ar_class|  }
month = proc { |ar_class|  }
week = Proc.new { |ar_class|  }
day = Proc.new { |ar_class|  }

@scope_selector
def scope_by(&scope_selector)
  @scope_selector = scope_selector
end

@fitler
def filter_out_by(&filter)
  filter
end

@actions = []
def chain_action(action)
  @actions << action
end

def action
  @actions.each do |action|
    action.call(1,2)
  end
end

chain_action proc { |x,y| print "hello ", x,  y}
chain_action Proc.new { print "world"}

action

print "\n\n\n"

p1 = proc { |x, y| print x, y.call(x)}
p2 = proc { |x| print x}

p1.call('a', p2)

class Foo
  def bar
    print "Foo bar"
  end
  
  def call_method(proc, &block)
    puts proc.class if proc != nil
    puts proc.inspect if proc != nil
    proc.call if proc != nil
    puts block.class if block_given?
    puts block.inspect if block_given?
    block.call if block_given?
    yield if block_given?
  end
end

print "\nnew test starts\n"
foo = Foo.new
foo.call_method foo.method("bar") do print 'this is block' end

#foo.call_method foo.method("bar")

class Demo 
  def self.play
    puts "\nDemo#play\n"
  end
end


foo.call_method Demo.method("play")
