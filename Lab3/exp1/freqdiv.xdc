# fout : U16
set_property PACKAGE_PIN U16 [get_ports {fout}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {fout}]

# clk : W5
set_property PACKAGE_PIN W5 [get_ports clk]                            
    set_property IOSTANDARD LVCMOS33 [get_ports clk]
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# rst_n : V17
set_property PACKAGE_PIN V17 [get_ports {rst_n}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]