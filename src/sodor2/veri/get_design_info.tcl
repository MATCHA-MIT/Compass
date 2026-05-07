
## STEP: Input design
analyze \
  -lib uArchOriginalLib -mfcu \
  -y src/sodor2/verilog_original +libext+.sv +define+SYNTHESIS \
  -sv src/sodor2/verilog_original/SodorInternalTile.sv
analyze \
  -lib uArchTaintLib -mfcu \
  -y src/sodor2/verilog_taint +libext+.sv +define+SYNTHESIS \
  -sv src/sodor2/verilog_taint/SodorInternalTile.sv
analyze \
  -lib ISATaintLib -mfcu \
  -y src/sodor2/ISATaint/verilog +libext+.sv +define+SYNTHESIS \
  -sv src/sodor2/ISATaint/verilog/ISATaint.sv
analyze -sv src/sodor2/veri/get_design_info.v

elaborate -top cfg
clock clk
reset rst -non_resettable_regs 0


## STEP: Get design info
get_design_info -instance uArchOriginal -file src/sodor2/temp/uArchOriginal.txt -force
get_design_info -instance uArchTaint -file src/sodor2/temp/uArchTaint.txt -force
get_design_info -instance ISATaint -file src/sodor2/temp/ISATaint.txt -force


exit

