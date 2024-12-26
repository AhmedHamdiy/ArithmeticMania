# Define a virtual clock for I/O timing constraints
create_clock -name __VIRTUAL_CLK__ -period 20 
set_input_delay 1.0000 [all_inputs] -clock __VIRTUAL_CLK__
set_output_delay 0.5 [all_outputs] -clock __VIRTUAL_CLK__
set_load 0.01 [all_outputs]
set_clock_latency 0.2 [get_clocks __VIRTUAL_CLK__]