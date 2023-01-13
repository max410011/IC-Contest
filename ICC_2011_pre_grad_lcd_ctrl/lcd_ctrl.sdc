# operating conditions and boundary conditions #
set cycle  10          

### === Set Clocks Timing Contrants === ###
create_clock -name CLK -period $cycle [get_ports  clk]
set_dont_touch_network      [get_clocks CLK]
set_clock_uncertainty  1    [get_clocks CLK]
set_clock_latency      1    [get_clocks CLK]
set_fix_hold                [get_clocks CLK]
set_ideal_network           [get_ports clk]

### === Set Driving Strength & delay paramete === ###

set_input_delay -clock CLK  -max -rise 4.5 [remove_from_collection [all_inputs] [get_clocks ]]
set_input_delay -clock CLK  -max -fall 4.5 [remove_from_collection [all_inputs] [get_clocks ]]

set_output_delay -clock CLK -max -rise 4.5  [all_outputs]
set_output_delay -clock CLK -max -fall 4.5  [all_outputs]

set_load -pin_load 1  [all_outputs]
set_drive          1  [all_inputs]

set_operating_conditions -min_library fast -min fast -max_library slow -max slow
set_wire_load_model -name tsmc13_wl10 -library slow
