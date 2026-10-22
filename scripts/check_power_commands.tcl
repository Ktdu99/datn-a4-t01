puts "=== POWER COMMAND CHECK ==="

foreach cmd {
    read_liberty
    read_verilog
    link_design
    read_sdc
    read_spef
    read_vcd
    read_power_activities
    report_activity_annotation
    report_parasitic_annotation
    report_parasitics_annotation
    report_power
    report_units
} {
    if {[llength [info commands $cmd]] > 0} {
        puts "AVAILABLE: $cmd"

        if {[catch {help $cmd} message]} {
            puts "HELP_UNAVAILABLE: $message"
        }
    } else {
        puts "MISSING: $cmd"
    }
}

puts "=== CHECK COMPLETED ==="
exit
