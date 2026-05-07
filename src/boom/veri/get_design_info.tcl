
## STEP: Input design
analyze \
  -lib uArchOriginalLib -mfcu \
  -y src/boom/verilog_original +libext+.sv +define+SYNTHESIS \
  -sv src/boom/verilog_original/BoomTile.sv
analyze \
  -lib uArchTaintLib -mfcu \
  -y src/boom/verilog_taint +libext+.sv +define+SYNTHESIS \
  -sv src/boom/verilog_taint/BoomTile.sv
analyze \
  -lib ISATaintLib -mfcu \
  -y src/boom/ISATaint/verilog +libext+.sv +define+SYNTHESIS \
  -sv src/boom/ISATaint/verilog/ISATaint.sv
analyze -sv src/boom/veri/get_design_info.v

elaborate -top cfg -bbox_mul 1024
clock clk
reset rst -non_resettable_regs 0


## STEP: Get design info
get_design_info -instance uArchOriginal -file src/boom/temp/uArchOriginal.txt -force
get_design_info -instance uArchTaint -file src/boom/temp/uArchTaint.txt -force
get_design_info -instance ISATaint -file src/boom/temp/ISATaint.txt -force


exit

