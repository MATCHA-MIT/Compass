
analyze +define+CONCRETE_RUN -sv src/sodor2/veri/1taint.v

set_max_trace_length 100
set_capture_elaborated_design on

source src/sodor2/veri/1taint.tcl

file delete -force my_db
save -dir my_db -elaborated_design my_design -force

