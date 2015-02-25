# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

print "\n\n!!!!!!!!!!!!!!load dsl!!!!!!!!!!!!!!!\n\n"

migrate do
  choose_table "SYS.AW$AWMD","SYS.AUDIT_ACTIONS" #:tbl1, :tbl2, :tbl3, :tbl4
  batch_by 'GEN#>0' #"created_at >= :start_date AND created_at <= :end_date"
  #filter_out_with {|row| }
  register_primary_key 'PS#','OBJID', 'action'
  batch_size = 1000
end


