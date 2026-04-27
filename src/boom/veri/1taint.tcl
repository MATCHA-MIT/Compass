
## STEP: Input design
analyze \
  -lib uArchLib -mfcu \
  -y src/boom/verilog_taint +libext+.sv +define+SYNTHESIS \
  -sv src/boom/verilog_taint/BoomTile.sv
analyze \
  -lib ISATaintLib -mfcu \
  -y src/boom/ISATaint/verilog +libext+.sv +define+SYNTHESIS \
  -sv src/boom/ISATaint/verilog/ISATaint.sv

elaborate -top cfg -bbox_mul 1024
clock clk
reset rst -non_resettable_regs 0




## STEP: Prefill ICache and DCache
## NOTE: Let's say ICache space is 0x80000000-0x8000003F
#                  DCache space is 0x800000C0-0x800000FF
abstract -init_value {uArch.frontend_taint.icache_taint.vb_array uArch.frontend_taint.icache_taint.tag_array_0_0}
assume {init -> uArch.frontend_taint.icache_taint.vb_array==2'h1}
assume {init -> uArch.frontend_taint.icache_taint.tag_array_0_0==25'h1000000}

## NOTE: dcache's tag_array uses special rst_cnt to reset. The reset value
#        cannot be overwritten by JasperGold's abstract -init_value. Thus, we
#        manually skip rst_cnt by setting it to 2'h2, meaning reset finished.
abstract -init_value {uArch.dcache_taint.meta_0_taint.rst_cnt}
assume {init -> uArch.dcache_taint.meta_0_taint.rst_cnt==2'h2}

abstract -init_value {uArch.dcache_taint.meta_0_taint.tag_array_1_0}
assume {init -> uArch.dcache_taint.meta_0_taint.tag_array_1_0[26:25]==2'h3}
assume {init -> uArch.dcache_taint.meta_0_taint.tag_array_1_0[24: 0]==25'h1000001}




## STEP: Symbolic states
abstract -init_value { \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_0 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_1 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_2 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_3 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_4 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_5 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_6 \
  uArch.frontend_taint.icache_taint.dataArrayWay_0_7 \
  uArch.dcache_taint.data_taint.array_0_0_8_0  \
  uArch.dcache_taint.data_taint.array_0_0_9_0  \
  uArch.dcache_taint.data_taint.array_0_0_10_0 \
  uArch.dcache_taint.data_taint.array_0_0_11_0 \
  uArch.dcache_taint.data_taint.array_0_0_12_0 \
  uArch.dcache_taint.data_taint.array_0_0_13_0 \
  uArch.dcache_taint.data_taint.array_0_0_14_0 \
  uArch.dcache_taint.data_taint.array_0_0_15_0 \
}




## STEP: Maybe there is a better way but I just want to reset them to 1.
abstract -init_value { \
  ISATaint.memd_taint_ext.Memory[56] \
  ISATaint.memd_taint_ext.Memory[57] \
  ISATaint.memd_taint_ext.Memory[58] \
  ISATaint.memd_taint_ext.Memory[59] \
  ISATaint.memd_taint_ext.Memory[60] \
  ISATaint.memd_taint_ext.Memory[61] \
  ISATaint.memd_taint_ext.Memory[62] \
  ISATaint.memd_taint_ext.Memory[63] \
  uArch.dcache_taint.data_taint.array_0_0_15_0_taint \
}
assume {tainted_init_secmemd}




## STEP: Avoid JasperGold does not output waveform for uArch.my_mem_addr
assume {(uArch.my_mem_addr ^ uArch.my_mem_addr) == 0}




## STEP: Concrete initial state.
## NOTE: This is for concrete simulation to identify source of imprecision.
assume {concrete_init_state}




## STEP: Simplification
assume {simplification}




## STEP: Contract assumption check
assume {contract_assumption}




## STEP: Leakage assertion check
assert {leakage_assertion}




## STEP: Prove
set_prove_orchestration off
set_engine_mode {Ht Mp AM I}
prove -all -dump_trace -dump_trace_type vcd

