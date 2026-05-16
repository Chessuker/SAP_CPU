set_max_delay -from [all_inputs] -to [all_outputs] 10.000

create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]
set_switching_activity -toggle_rate 20.000 -static_probability 0.500 [get_ports {{a[*]} {b[*]} {alu_op[*]}}]
set_switching_activity -toggle_rate 100.000 -static_probability 0.500 [get_ports {{a[*]} {b[*]} {alu_op[*]}}]
create_clock -period 10.000 -name clk [get_ports clk]
