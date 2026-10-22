# Post-route STA for FIFO A/B
# Required environment variables:
# STA_TECH_LEF, STA_CELL_LEF, STA_EF_CELL_LEF
# STA_LIB, STA_DEF, STA_SDC, STA_SPEF

foreach name {
    STA_TECH_LEF
    STA_CELL_LEF
    STA_EF_CELL_LEF
    STA_LIB
    STA_DEF
    STA_SDC
    STA_SPEF
} {
    if {![info exists ::env($name)]} {
        error "Missing environment variable: $name"
    }

    if {![file isfile $::env($name)]} {
        error "Input file not found: $name = $::env($name)"
    }
}

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

puts "===== CHECK SETUP ====="
check_setup -verbose

puts "===== REPORT CLOCK MIN PERIOD ====="
report_clock_min_period

puts "===== REPORT SETUP PATHS ====="
report_checks -path_delay max -group_count 3 -fields {slew cap fanout}

puts "===== REPORT HOLD PATHS ====="
report_checks -path_delay min -group_count 3 -fields {slew cap fanout}

puts "===== SETUP METRICS ====="
puts "SETUP_WNS_NS=[sta::worst_slack -max]"
puts "SETUP_TNS_NS=[sta::total_negative_slack -max]"

puts "===== HOLD METRICS ====="
puts "HOLD_WNS_NS=[sta::worst_slack -min]"
puts "HOLD_TNS_NS=[sta::total_negative_slack -min]"

puts "===== POSTROUTE STA COMPLETE ====="
