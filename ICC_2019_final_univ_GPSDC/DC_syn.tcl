# Setup
source synopsys_dc.setup

# Read all Files
read_verilog GPSDC.v
current_design GPSDC
link

# Setting Clock Constraits
source -echo -verbose GPSDC.sdc

# Synthesis all design
compile -map_effort high -area_effort high
compile -map_effort high -area_effort high -inc

write -format ddc  -hierarchy -output "GPSDC_syn.ddc"
write_sdf GPSDC_syn.sdf
write_file -format verilog -hierarchy -output GPSDC_syn.v
report_area > area.log
report_timing > timing.log
report_qor > GPSDC_syn.qor

