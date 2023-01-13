#Read All Files
read_file -format verilog  lcd_ctrl.v
current_design lcd_ctrl
link

#Setting Clock Constraints
source -echo -verbose lcd_ctrl.sdc
check_design
set high_fanout_net_threshold 0
uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]

#Synthesis all design
#compile -map_effort high -area_effort high
#compile -map_effort high -area_effort high -inc
compile

write -format ddc     -hierarchy -output "lcd_ctrl_syn.ddc"
write_sdf -version 1.0  lcd_ctrl_syn.sdf
write -format verilog -hierarchy -output lcd_ctrl_syn.v
report_area > area.log
report_timing > timing.log
report_qor   >  lcd_ctrl_syn.qor
