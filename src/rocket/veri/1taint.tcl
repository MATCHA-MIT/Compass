
## STEP: Input design
analyze \
  -lib uArchLib -mfcu \
  -y src/rocket/verilog_taint +libext+.sv +define+SYNTHESIS \
  -sv src/rocket/verilog_taint/RocketTile.sv
analyze \
  -lib ISATaintLib -mfcu \
  -y src/rocket/ISATaint/verilog +libext+.sv +define+SYNTHESIS \
  -sv src/rocket/ISATaint/verilog/ISATaint.sv

elaborate -top cfg -bbox_mul 1024
clock clk
reset rst -non_resettable_regs 0




## STEP: Prefill ICache valid and tag
## NOTE: ICache space is 0x80000000-0x8000003F
## NOTE: rocket's tag_array's highest (i.e., 26-th) bit is ECC, not sure how to remove it...
abstract -init_value {uArch.frontend_taint.icache_taint.vb_array uArch.frontend_taint.icache_taint.tag_array_0_0}
assume {init -> uArch.frontend_taint.icache_taint.vb_array==2'h1}
assume {init -> uArch.frontend_taint.icache_taint.tag_array_0_0==26'h1000000}




## STEP: Prefill DCache valid and tag
## NOTE: DCache space is 0x80000100-0x8000013F
## NOTE: dcache's tag_array uses special flushCounter to reset. The reset value
#        cannot be overwritten by JasperGold's abstract -init_value. Thus, we
#        manually skip the flushCounter by setting it to 1'h1, meaning skip
#        resetting the first cache set.
abstract -init_value {uArch.dcache_taint.flushCounter}
assume {init -> uArch.dcache_taint.flushCounter==1'h1}

abstract -init_value {uArch.dcache_taint.tag_array_0_0}
assume {init -> uArch.dcache_taint.tag_array_0_0[26:25]==2'h3}
assume {init -> uArch.dcache_taint.tag_array_0_0[24: 0]==25'h1000002}




## STEP: Symbolic states
abstract -init_value { \
  uArch.frontend_taint.icache_taint.data_arrays_0_0_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_1_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_2_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_3_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_4_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_5_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_6_0 \
  uArch.frontend_taint.icache_taint.data_arrays_0_7_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_0_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_1_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_2_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_3_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_4_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_5_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_6_0 \
  uArch.frontend_taint.icache_taint.data_arrays_1_7_0 \

  uArch.dcache_taint.data_taint.data_arrays_0_0_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_0_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_1_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_2_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_3_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_4_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_5_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_6_7 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_0 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_1 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_2 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_3 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_4 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_5 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_6 \
  uArch.dcache_taint.data_taint.data_arrays_0_7_7 \
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
  uArch.dcache_taint.data_taint.data_arrays_0_7_0_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_1_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_2_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_3_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_4_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_5_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_6_taint \
  uArch.dcache_taint.data_taint.data_arrays_0_7_7_taint \
}
assume {tainted_init_secmemd}




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

