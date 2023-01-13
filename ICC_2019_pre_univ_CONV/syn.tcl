source synopsys_dc.setup
read_file CONV.v
source CONV.sdc
compile -exact_map
write -hierarchy -format verilog -output CONV_syn.v
write -hierarchy -format ddc -output CONV_syn.ddc
write_sdf -version 2.1 -context verilog CONV_syn.sdf
