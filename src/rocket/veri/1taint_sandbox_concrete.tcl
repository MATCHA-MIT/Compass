
analyze +define+CONCRETE_RUN -sv src/rocket/veri/1taint.v

set_max_trace_length 100
set_capture_elaborated_design on

source src/rocket/veri/1taint.tcl

file delete -force src/rocket/temp/my_db
save -dir src/rocket/temp/my_db -elaborated_design src/rocket/temp/my_design -force

