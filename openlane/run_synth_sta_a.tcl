set ::env(OPENLANE_ROOT) "/openlane"
lappend auto_path $::env(OPENLANE_ROOT)
package require openlane

set script_dir [file dirname [file normalize [info script]]]
set repo_root [file normalize [file join $script_dir ".."]]
set design_dir [file join $repo_root "openlane" "sync_fifo_count"]

set run_tag "SYNTH_A_50MHZ"

if {[info exists ::env(FIFO_RUN_TAG)] && $::env(FIFO_RUN_TAG) ne ""} {
    set run_tag $::env(FIFO_RUN_TAG)
}

puts "Design directory: $design_dir"
puts "Run tag: $run_tag"

prep -design $design_dir \
     -tag $run_tag \
     -overwrite

run_synthesis

puts "\[PASS\] Synthesis and STA A completed"
puts "RUN_DIR=$::env(RUN_DIR)"
