
## STEP: Input design
analyze \
  -lib uArchOriginalLib -mfcu \
  -y src/rocket/verilog_original +libext+.sv +define+SYNTHESIS \
  -sv src/rocket/verilog_original/RocketTile.sv
analyze \
  -lib uArchTaintLib -mfcu \
  -y src/rocket/verilog_taint +libext+.sv +define+SYNTHESIS \
  -sv src/rocket/verilog_taint/RocketTile.sv
analyze \
  -lib ISATaintLib -mfcu \
  -y src/rocket/ISATaint/verilog +libext+.sv +define+SYNTHESIS \
  -sv src/rocket/ISATaint/verilog/ISATaint.sv
analyze -sv src/rocket/veri/get_design_info.v

elaborate -top cfg -bbox_mul 1024
clock clk
reset rst -non_resettable_regs 0


## STEP: Get design info
get_design_info -instance uArchOriginal -file src/rocket/temp/uArchOriginal.txt -force
get_design_info -instance uArchTaint -file src/rocket/temp/uArchTaint.txt -force
get_design_info -instance ISATaint -file src/rocket/temp/ISATaint.txt -force


exit

