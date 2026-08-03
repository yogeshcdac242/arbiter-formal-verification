clear -all
analyze -sv arbiter.sv arbiter_props.sv
elaborate -top arbiter
clock clk
reset -expression {!rst_n}
prove -all
