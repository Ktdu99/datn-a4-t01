puts "===== READ TECHNOLOGY LEF ====="
read_lef $::env(STA_TECH_LEF)

puts "===== READ STANDARD CELL LEF ====="
read_lef $::env(STA_CELL_LEF)

puts "===== READ EF STANDARD CELL LEF ====="
read_lef $::env(STA_EF_CELL_LEF)

puts "===== READ LIBERTY ====="
read_liberty $::env(STA_LIB)

puts "===== READ POST-ROUTE DEF ====="
read_def $::env(STA_DEF)

puts "===== DEF LOADED ====="

puts "===== CHECK DESIGN ====="
set block [ord::get_db_block]
puts "DESIGN_NAME=[$block getName]"
puts "INSTANCE_COUNT=[llength [$block getInsts]]"

puts "===== TEST COMPLETE ====="
