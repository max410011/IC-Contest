ida_probe -log
ida_probe -wave -wave_probe_args="[scope -tops] -all -depth all -memories"
run
exit
