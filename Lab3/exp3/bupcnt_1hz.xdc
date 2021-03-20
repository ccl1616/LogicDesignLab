# 4bit q - led
set_property PACKAGE_PIN U16 [get_ports {q[0]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {q[0]}]
set_property PACKAGE_PIN E19 [get_ports {q[1]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {q[1]}]
set_property PACKAGE_PIN U19 [get_ports {q[2]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {q[2]}]
set_property PACKAGE_PIN V19 [get_ports {q[3]}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {q[3]}]

# clk - fcrystal W5
set_property PACKAGE_PIN W5 [get_ports {clk}]                            
    set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

# rst_n - V17 switch
set_property PACKAGE_PIN V17 [get_ports {rst_n}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]