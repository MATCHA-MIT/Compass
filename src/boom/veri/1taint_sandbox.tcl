
set_parallel_synthesis_mode on
set_parallel_synthesis_num_process 8

analyze -sv src/boom/veri/1taint.v

source src/boom/veri/1taint.tcl

