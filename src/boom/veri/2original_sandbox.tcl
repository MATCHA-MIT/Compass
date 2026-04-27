
## STEP: Parallel synthesis
set_parallel_synthesis_mode on
set_parallel_synthesis_num_process 8




## STEP: Input design
analyze -sv src/boom/veri/2original_sandbox.v
analyze \
  -lib uArchLib -mfcu \
  -y src/boom/verilog_original +libext+.sv +define+SYNTHESIS \
  -sv src/boom/verilog_original/BoomTile.sv

elaborate -top cfg -bbox_mul 1024
clock clk
reset rst -non_resettable_regs 0




## STEP: Prefill ICache and DCache
## NOTE: Let's say ICache space is 0x80000000-0x8000003F
#                  DCache space is 0x800000C0-0x800000FF
abstract -init_value {uArch_1.frontend.icache.vb_array uArch_1.frontend.icache.tag_array_0_0}
assume {init -> uArch_1.frontend.icache.vb_array==2'h1}
assume {init -> uArch_1.frontend.icache.tag_array_0_0==25'h1000000}

## NOTE: dcache's tag_array uses special rst_cnt to reset. The reset value
#        cannot be overwritten by JasperGold's abstract -init_value. Thus, we
#        manually skip rst_cnt by setting it to 2'h2, meaning reset finished.
abstract -init_value {uArch_1.dcache.meta_0.rst_cnt}
assume {init -> uArch_1.dcache.meta_0.rst_cnt==2'h2}
abstract -init_value {uArch_1.dcache.meta_0.tag_array_1_0}
assume {init -> uArch_1.dcache.meta_0.tag_array_1_0[26:25]==2'h3}
assume {init -> uArch_1.dcache.meta_0.tag_array_1_0[24: 0]==25'h1000001}

abstract -init_value {uArch_2.frontend.icache.vb_array uArch_2.frontend.icache.tag_array_0_0}
assume {init -> uArch_2.frontend.icache.vb_array==2'h1}
assume {init -> uArch_2.frontend.icache.tag_array_0_0==25'h1000000}

abstract -init_value {uArch_2.dcache.meta_0.rst_cnt}
assume {init -> uArch_2.dcache.meta_0.rst_cnt==2'h2}
abstract -init_value {uArch_2.dcache.meta_0.tag_array_1_0}
assume {init -> uArch_2.dcache.meta_0.tag_array_1_0[26:25]==2'h3}
assume {init -> uArch_2.dcache.meta_0.tag_array_1_0[24: 0]==25'h1000001}




## STEP: Symbolic states
abstract -init_value { \
  uArch_1.frontend.icache.dataArrayWay_0_0 \
  uArch_1.frontend.icache.dataArrayWay_0_1 \
  uArch_1.frontend.icache.dataArrayWay_0_2 \
  uArch_1.frontend.icache.dataArrayWay_0_3 \
  uArch_1.frontend.icache.dataArrayWay_0_4 \
  uArch_1.frontend.icache.dataArrayWay_0_5 \
  uArch_1.frontend.icache.dataArrayWay_0_6 \
  uArch_1.frontend.icache.dataArrayWay_0_7 \
  uArch_1.dcache.data.array_0_0_8_0  \
  uArch_1.dcache.data.array_0_0_9_0  \
  uArch_1.dcache.data.array_0_0_10_0 \
  uArch_1.dcache.data.array_0_0_11_0 \
  uArch_1.dcache.data.array_0_0_12_0 \
  uArch_1.dcache.data.array_0_0_13_0 \
  uArch_1.dcache.data.array_0_0_14_0 \
  uArch_1.dcache.data.array_0_0_15_0 \

  uArch_2.frontend.icache.dataArrayWay_0_0 \
  uArch_2.frontend.icache.dataArrayWay_0_1 \
  uArch_2.frontend.icache.dataArrayWay_0_2 \
  uArch_2.frontend.icache.dataArrayWay_0_3 \
  uArch_2.frontend.icache.dataArrayWay_0_4 \
  uArch_2.frontend.icache.dataArrayWay_0_5 \
  uArch_2.frontend.icache.dataArrayWay_0_6 \
  uArch_2.frontend.icache.dataArrayWay_0_7 \
  uArch_2.dcache.data.array_0_0_8_0  \
  uArch_2.dcache.data.array_0_0_9_0  \
  uArch_2.dcache.data.array_0_0_10_0 \
  uArch_2.dcache.data.array_0_0_11_0 \
  uArch_2.dcache.data.array_0_0_12_0 \
  uArch_2.dcache.data.array_0_0_13_0 \
  uArch_2.dcache.data.array_0_0_14_0 \
  uArch_2.dcache.data.array_0_0_15_0 \
}




## STEP: Simplification
assume {simplification}




## STEP: Same initial public state
assume {same_init_pubstate}




## STEP: Contract assumption check
assume {contract_assumption}




## STEP: Leakage assertion check
assert {leakage_assertion}




## STEP: Prove
set_prove_orchestration off
set_engine_mode {Ht Mp AM I}
set_prove_time_limit 7d
prove -all

