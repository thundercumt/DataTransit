# data_transit
data_transit is a ruby gem/app used to migrate between different relational 
databases, supporting customized migration procedure.


1 Introduction
data_transit relies on activerecord to generate database Models on the fly. 
Tt is executed within a database transaction, and should any error occur during
data transit, it will cause the transaction to rollback. So don't worry about
introducing dirty data into your target database.


2 Install
data_transit can be installed using gem
    gem install data_transit
or 
    download data_transit.gem
    gem install --local /where/you/put/data_transit.gem

In your command line, input data_transit, You can proceed to "how to use" if you
can see message prompt as below.
data_transit
usage: data_transit command args. 4 commands are listed below...


3 How to use

3.1 Config DataBase Connection
    data_transit setup_db_conn /your/yaml/database/config/file

Your db config file should be compatible with the activerecord adapter you are 
using and configured properly. As the name suggests, source designates which 
database you plan to copy data from, while target means the copy destination.
Note the key 'source' and 'target' should be kept unchanged!
For example, here is sample file for oracle dbms.
#database.yml
source:#don't change this line
  adapter: oracle_enhanced
  database: dbserver
  username: xxx
  password: secret

target:#don't change this line
  adapter: oracle_enhanced
  database: orcl
  username: copy1
  password: cipher


3.2 Create Database Schema(optional)
If you can have your target database schema created, move to 3.3 "copy data", 
otherwise use your database specific tools to generate an identical schema in 
your target database. Or if you don't have a handy tool to generate the schema, 
for instance when you need to migrate between different database systems, you 
can use data_transit to dump a schema description file based on your source 
database schema, and then use this file to create your target schema.

Note this gem is built on activerecord, so it should work well for the database 
schema compatible with rails conventions. Example, a single-column primary key  
rather than a compound primary key (primary key with more than one columns), 
primary key of integer type instead of other types like guid, timestamp etc.

In data_transit, I coded against the situation where non-integer is used, 
therefore resulting a minor problem that the batch-query feature provided by 
activerecord can not be used because of its dependency on integer primary key.
In this special case, careless selection of copy range might overburden network,
database server because all data in the specified range are transmitted from the
source database and then inserted into the target database.


3.2.1 Dump Source Database Schema
    data_transit dump_schema [schema_file] [rule_file]
[schema_file] will be used to contain dumped schema, [rule_file] describes how 
your want data_transit to copy your data.

Note if your source schema is somewhat a legacy, you might need some manual work
to adjust the generated schema_file to better meet your needs. 

For example, in my test, the source schema uses obj_id as id, and uses guid as 
primary key type, so I need to impede activerecord auto-generating "id" column 
by removing primary_key => "obj_id" and adding :id=>false, and then appending 
primary key constraint in the end of each table definition. See below.

#here is an example dumped schema file
ActiveRecord::Schema.define(:version => 0) do
  create_table "table_one", primary_key => "obj_id", :force => true do |t|
    #other fields
  end
  #other tables
end

#and I manually changed the schema definition to
ActiveRecord::Schema.define(:version => 0) do
  create_table "table_one", :id => false, :force => true do |t|
    t.string "obj_id",           :limit => 42  
    #other fields
  end
  execute "alter table table_one add primary key(obj_id)"
end

3.2.2 Create Target Database Schema
    data_transit create_table [schema_file]
If everything goes well, you will see a bunch of ddl execution history.


3.3 Copy Data
    data_transit copy_data [rule_file]
[rule_file] contains your copy logic. For security reasons, I changed table names
and it looks as follows.

#start of rule_all_in_one_file
start_date = "2015-01-01 00:00:00"
end_date = "2015-02-01 00:00:00"

migrate do
  choose_table "APP.TABLE1","APP.TABLE2","APP.TABLE3","APP.TABLE4","APP.TABLE5","APP.TABLE6"
  batch_by "ACQUISITION_TIME BETWEEN TO_DATE('#{start_date}','yyyy-mm-dd hh24:mi:ss') AND TO_DATE('#{end_date}', 'yyyy-mm-dd hh24:mi:ss')"
  register_primary_key 'OBJ_ID'
end

migrate do
  choose_table "APP.TABLE7","APP.TABLE8","APP.TABLE9","APP.TABLE10","APP.TABLE11","APP.TABLE12"
  batch_by "ACKTIME BETWEEN TO_DATE('#{start_date}','yyyy-mm-dd hh24:mi:ss') AND TO_DATE('#{end_date}', 'yyyy-mm-dd hh24:mi:ss')"
  register_primary_key 'OBJ_ID'
end

migrate do
  choose_table "APP.TABLE13","APP.TABLE14","APP.TABLE15","APP.TABLE16","APP.TABLE17","APP.TABLE18"
  batch_by "1>0" #query all data because these tables don't have a reasonable range
  register_primary_key 'OBJ_ID'
  pre_work do |targetCls| targetCls.delete_all("1>0")  end #delete all in target
  #post_work do |targetCls|  end
end
#end of rule_all_in_one_file

Each migrate block contains a data_transit task. 

"choose_table" describes which tables are included in this task. These tables 
share some nature in common, and can be processed with the same rule. 

"batch_by" is the query condition

"register_primary_key" describes the primary key of the tables.

"pre_work" is a block executed before each table is processed.

"post_work" is a block executed after each table is processed.