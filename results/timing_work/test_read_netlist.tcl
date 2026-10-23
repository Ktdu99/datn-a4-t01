set tech_lef $::env(STA_TECH_LEF)
set cell_lef $::env(STA_CELL_LEF)
set lib      $::env(STA_LIB)
set netlist  $::env(STA_NETLIST)

puts "===== READ TECHNOLOGY LEF ====="
read_lef $tech_lef

puts "===== READ STANDARD CELL LEF ====="
read_lef $cell_lef

puts "===== READ EF STANDARD CELL LEF ====="
read_lef $::env(STA_EF_CELL_LEF)

puts "===== READ LIBERTY ====="
read_liberty $lib

puts "===== READ NETLIST ====="
read_verilog $netlist

puts "===== LINK DESIGN ====="
link_design sync_fifo_count

puts "===== DESIGN LINKED ====="

puts "===== READ POST-ROUTE DEF ====="
read_def $::env(STA_DEF)

puts "===== DEF LOADED ====="
