# data_transit
data_transit is a ruby gem/app used to migrate between different databases, 
supporting customized migration procedure.


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

In your command line, input data_transit, You can proceed to "how to use" if you can see message prompt as below.
data_transit
usage: data_transit command args. 4 commands are listed below...


3 How to use

3.1 Config DataBase Connection
    data_transit setup_db_conn /your/yaml/database/config/file

Your db config file should be compatible with the activerecord adapter you are using and configured properly
#database.yml
source:
  adapter: 

3.2 Create Database Schema(optional)
If you can have your target database schema created, move to 3.3 "copy data", 
otherwise use your database specific tools to generate an identical schema in your target database.
Or if you don't have a handy tool to generate the schema, for instance when you need to migrate 
between different database systems, you can use data_transit to dump a schema description file based
on your source database schema, and then use this file to create your target schema.

3.2.1 Create Target Database Schema
    data_transit dump_schema [schema_file] [rule_file]
[schema_file] will be used to contain dumped schema, [rule_file] describes how your want data_transit 
to copy your data.

    data_transit create_table [schema_file]

3.2.2 Copy Data
    data_transit copy_data [rule_file]

