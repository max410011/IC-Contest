source .synopsys_dc.setup
read_file ISE.v
source ISE_DC.sdc
source ISE_APR.sdc
compile
write -format verilog -hierarchy -output ISE_syn.v
write -format ddc -hierarchy -output ISE_syn.ddc
write_sdf -version 2.1 ISE_syn.sdf
