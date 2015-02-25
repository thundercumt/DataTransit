# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "SYS.AW$AWMD", :id => false, :force => true do |t|
    t.integer "ps#",      :limit => 10,  :precision => 10, :scale => 0
    t.integer "gen#",     :limit => 10,  :precision => 10, :scale => 0
    t.integer "extnum",   :limit => 8,   :precision => 8,  :scale => 0
    t.binary  "awlob"
    t.string  "objname",  :limit => 256
    t.string  "partname", :limit => 256
  end

  add_index "SYS.AW$AWMD", ["ps#", "gen#", "extnum"], :name => "awmd_i$", :unique => true, :tablespace => "sysaux"

  create_table "SYS.AUDIT_ACTIONS", :id => false, :force => true do |t|
    t.decimal "action",               :null => false
    t.string  "name",   :limit => 28, :null => false
  end

  add_index "SYS.AUDIT_ACTIONS", ["action", "name"], :name => "i_audit_actions", :unique => true, :tablespace => "system"

end
