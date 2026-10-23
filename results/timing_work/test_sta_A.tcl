puts "===== READ TECHNOLOGY LEF ====="
read_lef $::env(STA_TECH_LEF)

puts "===== READ STANDARD CELL LEF ====="
read_lef $::env(STA_CELL_LEF)

puts "===== READ EF STANDARD CELL LEF ====="
read_lef $::env(STA_EF_CELL_LEF)

puts "===== READ LIBERTY ====="
read_liberty $::env(STA_LIB)

puts "===== READ DEF ====="
read_def $::env(STA_DEF)

puts "===== READ SDC ====="
read_sdc $::env(STA_SDC)

puts "===== READ SPEF ====="
read_spef $::env(STA_SPEF)

puts "===== CHECK TIMING ====="
check_setup

puts "===== REPORT CLOCKS ====="
report_clock_min_period

puts "===== REPORT SETUP PATH ====="
report_checks -path_delay max -group_count 3 -fields {slew cap fanout}

puts "===== REPORT HOLD PATH ====="
report_checks -path_delay min -group_count 3 -fields {slew cap fanout}

puts "===== STA TEST COMPLETE ====="

puts "===== OFFICIAL SETUP METRICS ====="
puts "SETUP_WNS_NS=[sta::worst_slack -max]"
puts "SETUP_TNS_NS=[sta::total_negative_slack -max]"

puts "===== OFFICIAL HOLD METRICS ====="
puts "HOLD_WNS_NS=[sta::worst_slack -min]"
puts "HOLD_TNS_NS=[sta::total_negative_slack -min]"

puts "===== METRICS COMPLETE ====="
