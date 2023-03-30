#RTL simulation
verdi -sverilog tb.sv LASER.v -ssf LASER.fsdb

#Gate-Level simuation
#verdi -sverilog tb.sv LASER_syn.v -v /cad/CBDK/CBDK_IC_Contest_v2.5/Verilog/tsmc13_neg.v -ssf LASER.fsdb
