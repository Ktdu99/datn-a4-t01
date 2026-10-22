# Phân tích power streaming với Liberty TT và SPEF nominal.
# Activity lấy từ mô phỏng gate-level zero-delay.

if {[catch {
    foreach name {FIFO_ARCH FIFO_ACTIVITY_DIR} {
        if {![info exists ::env($name)]} {
            error "Missing environment variable: $name"
        }
    }

    set arch $::env(FIFO_ARCH)

    if {$arch eq "A"} {
        set top sync_fifo_count
        set group physical_a
    } elseif {$arch eq "B"} {
        set top sync_fifo_pointer
        set group physical_b
    } else {
        error "FIFO_ARCH must be A or B"
    }

    set base "/work/results/$group/PHYS_${arch}_50MHZ/final"

    set tech_lef "/pdk/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef"
    set cell_lef "/pdk/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef"
    set extra_lef "/pdk/libs.ref/sky130_fd_sc_hd/lef/sky130_ef_sc_hd.lef"
    set liberty "/pdk/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

    set def_file "$base/def/${top}.def"
    set sdc "$base/sdc/${top}.sdc"
    set spef "$base/spef/multicorner/${top}.nom.spef"

    set vcd "$::env(FIFO_ACTIVITY_DIR)/${arch}_streaming_zero.vcd"

    foreach path [list \
    $tech_lef \
    $cell_lef \
    $extra_lef \
    $liberty \
    $def_file \
    $sdc \
    $spef \
    $vcd \
    ] {
    if {![file isfile $path]} {
        error "File not found: $path"
    	}

    if {[file size $path] == 0} {
        error "Empty file: $path"
    	}
    }

    puts "=== EXPERIMENT ==="
    puts "Architecture: $arch"
    puts "Top: $top"
    puts "Corner: TT / 25 C / 1.80 V"
    puts "Parasitics: nominal"
    puts "Activity: streaming, gate-level zero-delay"
    puts "VCD: $vcd"

    puts "=== READ TECHNOLOGY ==="
    read_lef $tech_lef
    read_lef $cell_lef
    read_lef $extra_lef

    puts "=== READ LIBERTY ==="
    read_liberty $liberty

    puts "=== READ DESIGN ==="
    read_def $def_file

    puts "=== READ CONSTRAINTS ==="
    read_sdc $sdc

    puts "=== READ PARASITICS ==="
    read_spef $spef
    report_parasitic_annotation -report_unannotated

    puts "=== READ ACTIVITY ==="
    read_power_activities \
        -scope tb_fifo_power/dut \
        -vcd $vcd

    puts "=== UNITS ==="
    report_units

    puts "=== POWER ==="
    report_power -digits 6

    puts "=== LIMITATIONS ==="
    puts "No report_activity_annotation command in this build."
    puts "Zero-delay activity does not fully model timing glitches."
    puts "Result requires review before use in PPA conclusions."

    puts "POWER_REPORT_COMPLETED"

} message]} {
    puts stderr "POWER_ANALYSIS_FAILED: $message"
    exit 1
}

exit 0
