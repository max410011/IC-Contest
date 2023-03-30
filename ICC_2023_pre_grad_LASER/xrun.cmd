#RTL simulation, single pattern
xrun tb.sv LASER.v +define+P1+USECOLOR +access+r  -clean -createdebugdb -input xrun.tcl 

#RTL simulation, all pattern
#xrun tb.sv LASER.v +define+USECOLOR +access+r  -clean -createdebugdb -input xrun.tcl

#Gate-Level simuation
#xrun tb.sv LASER_syn.v +define+USECOLOR+SDF  +access+r  -clean -createdebugdb -v /cad/CBDK/CBDK_IC_Contest_v2.5/Verilog/tsmc13_neg.v +ncmaxdelays
