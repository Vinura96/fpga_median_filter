# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# XDC: new/basys3_constraints.xdc

# IP: ip/axi_uartlite_0/axi_uartlite_0.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==axi_uartlite_0 || ORIG_REF_NAME==axi_uartlite_0} -quiet] -quiet

# IP: ip/pad_conv_ram/pad_conv_ram.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==pad_conv_ram || ORIG_REF_NAME==pad_conv_ram} -quiet] -quiet

# IP: ip/input_output_ram/input_output_ram.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==input_output_ram || ORIG_REF_NAME==input_output_ram} -quiet] -quiet

# XDC: ip/axi_uartlite_0/axi_uartlite_0_board.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi_uartlite_0 || ORIG_REF_NAME==axi_uartlite_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: ip/axi_uartlite_0/axi_uartlite_0_ooc.xdc

# XDC: ip/axi_uartlite_0/axi_uartlite_0.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==axi_uartlite_0 || ORIG_REF_NAME==axi_uartlite_0} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: ip/pad_conv_ram/pad_conv_ram_ooc.xdc

# XDC: ip/input_output_ram/input_output_ram_ooc.xdc