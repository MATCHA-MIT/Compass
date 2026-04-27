
set_parallel_synthesis_mode on
set_parallel_synthesis_num_process 8

analyze +define+CONCRETE_RUN -sv src/boom/veri/1taint.v

set_max_trace_length 100
set_capture_elaborated_design on

source src/boom/veri/1taint.tcl

file delete -force src/boom/temp/my_db
save -dir src/boom/temp/my_db -elaborated_design src/boom/temp/my_design -force

