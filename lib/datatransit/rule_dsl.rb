# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#chain_filter1 --> chain_filter2 --> chain_filter3

require 'singleton'
require 'progress_bar'

#require File::expand_path('../database', __FILE__)
require File::expand_path('../model/tables_source', __FILE__)
require File::expand_path('../model/tables_target', __FILE__)

module RULE_DSL
  
  def load_rule rule_file
    self.instance_eval File.read(rule_file), rule_file
  end
  
  def migrate &script
    yield 
  end
  
  def choose_table *tables
    @tables = tables.freeze
  end

  def batch_by search_cond
    @cond ||= {}
    @cond[:search_cond] ||= search_cond
  end
  
  def register_primary_key *key
    @cond ||= {}
    @cond[:primary_key] ||= key.map(&:downcase)
  end

  def filter_out_with &filter
    @filters ||= []
    @filters << filter
  end
end

class DTWorker
  include RULE_DSL
  
  attr_accessor :batch_size
  attr_reader :tables
  
  def initialize rule_file
    @rule_file = rule_file
    @batch_size = 500
  end
  
  def load_work
    load_rule @rule_file
  end
  
  def do_work
    load_work
    given_pk = @cond[:primary_key]#a context-free-variable in context switches
    
    @tables.each do |tbl|
      sourceCls = Class.new(DataTransit::Source::SourceBase) do
        self.table_name = tbl
        #self.primary_key= given_pk if given_pk
        #add support for dynamic pk verification
      end
      
      columns = sourceCls.columns.map(&:name).map(&:downcase)
      pk = get_pk(columns, given_pk)
      sourceCls.instance_eval( "self.primary_key = \"#{pk}\"")
      
      targetCls = Class.new(DataTransit::Target::TargetBase) do
        self.table_name = tbl
      end
      targetCls.instance_eval( "self.primary_key = \"#{pk}\"")
      
      print "\ntable ", tbl, ":\n"
      targetCls.transaction do
        do_batch_copy sourceCls, targetCls, pk
      end
    end
  end
  
  def do_batch_copy (sourceCls, targetCls, pk = nil)
    count = sourceCls.where(@cond[:search_cond]).size.to_f
    how_many_batch = (count / @batch_size).ceil
    
    if count <= 0 then
      return
    end
    
    #the progress bar
    bar = ProgressBar.new(count)
    
    0.upto (how_many_batch-1) do |i|  
      sourceCls.where(@cond[:search_cond]).find_each(
        start: i * @batch_size, batch_size: @batch_size) do |source_row|

        if @filters && @filters.length > 0
          next if do_filter_out source_row
        end
        target_row = targetCls.new source_row.attributes
        
        #activerecord would ignore pk field, and the above initialization will result nill primary key.
        #here the original pk is used in the target_row, it is what we need exactly.
        if pk 
          target_row.send( "#{pk}=", source_row.send("#{pk}") )
        end
        
        target_row.save
        
        #update progress
        bar.increment!
      end
    end
  end
  
  def do_filter_out row
    @filters.each do |filter|
      if filter.call row
        return true
      end
    end
    
    false
  end
  
  private
  def get_pk(columns, given_pk)
    pk = columns & given_pk
    if pk && pk.length > 0
      pk = pk[0]
    else
      pk = "id"
    end
  end
  
end