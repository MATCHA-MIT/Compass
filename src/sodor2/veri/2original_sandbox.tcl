

# STEP: Input design
analyze -sv src/sodor2/veri/2original_sandbox.v
analyze \
  -lib uArchLib -mfcu \
  -y src/sodor2/verilog_original +libext+.sv +define+SYNTHESIS \
  -sv src/sodor2/verilog_original/SodorInternalTile.sv

elaborate -top cfg
clock clk
reset rst -non_resettable_regs 0




# STEP: Symbolic states
abstract -init_value { \
  uArch_1.memory.mem_0_3  uArch_1.memory.mem_0_2  uArch_1.memory.mem_0_1  uArch_1.memory.mem_0_0  \
  uArch_1.memory.mem_1_3  uArch_1.memory.mem_1_2  uArch_1.memory.mem_1_1  uArch_1.memory.mem_1_0  \
  uArch_1.memory.mem_2_3  uArch_1.memory.mem_2_2  uArch_1.memory.mem_2_1  uArch_1.memory.mem_2_0  \
  uArch_1.memory.mem_3_3  uArch_1.memory.mem_3_2  uArch_1.memory.mem_3_1  uArch_1.memory.mem_3_0  \
  uArch_1.memory.mem_4_3  uArch_1.memory.mem_4_2  uArch_1.memory.mem_4_1  uArch_1.memory.mem_4_0  \
  uArch_1.memory.mem_5_3  uArch_1.memory.mem_5_2  uArch_1.memory.mem_5_1  uArch_1.memory.mem_5_0  \
  uArch_1.memory.mem_6_3  uArch_1.memory.mem_6_2  uArch_1.memory.mem_6_1  uArch_1.memory.mem_6_0  \
  uArch_1.memory.mem_7_3  uArch_1.memory.mem_7_2  uArch_1.memory.mem_7_1  uArch_1.memory.mem_7_0  \
  uArch_1.memory.mem_8_3  uArch_1.memory.mem_8_2  uArch_1.memory.mem_8_1  uArch_1.memory.mem_8_0  \
  uArch_1.memory.mem_9_3  uArch_1.memory.mem_9_2  uArch_1.memory.mem_9_1  uArch_1.memory.mem_9_0  \
  uArch_1.memory.mem_10_3 uArch_1.memory.mem_10_2 uArch_1.memory.mem_10_1 uArch_1.memory.mem_10_0 \
  uArch_1.memory.mem_11_3 uArch_1.memory.mem_11_2 uArch_1.memory.mem_11_1 uArch_1.memory.mem_11_0 \
  uArch_1.memory.mem_12_3 uArch_1.memory.mem_12_2 uArch_1.memory.mem_12_1 uArch_1.memory.mem_12_0 \
  uArch_1.memory.mem_13_3 uArch_1.memory.mem_13_2 uArch_1.memory.mem_13_1 uArch_1.memory.mem_13_0 \
  uArch_1.memory.mem_14_3 uArch_1.memory.mem_14_2 uArch_1.memory.mem_14_1 uArch_1.memory.mem_14_0 \
  uArch_1.memory.mem_15_3 uArch_1.memory.mem_15_2 uArch_1.memory.mem_15_1 uArch_1.memory.mem_15_0 \

  uArch_1.memory.mem_64_3 uArch_1.memory.mem_64_2 uArch_1.memory.mem_64_1 uArch_1.memory.mem_64_0 \
  uArch_1.memory.mem_65_3 uArch_1.memory.mem_65_2 uArch_1.memory.mem_65_1 uArch_1.memory.mem_65_0 \
  uArch_1.memory.mem_66_3 uArch_1.memory.mem_66_2 uArch_1.memory.mem_66_1 uArch_1.memory.mem_66_0 \
  uArch_1.memory.mem_67_3 uArch_1.memory.mem_67_2 uArch_1.memory.mem_67_1 uArch_1.memory.mem_67_0 \
  uArch_1.memory.mem_68_3 uArch_1.memory.mem_68_2 uArch_1.memory.mem_68_1 uArch_1.memory.mem_68_0 \
  uArch_1.memory.mem_69_3 uArch_1.memory.mem_69_2 uArch_1.memory.mem_69_1 uArch_1.memory.mem_69_0 \
  uArch_1.memory.mem_70_3 uArch_1.memory.mem_70_2 uArch_1.memory.mem_70_1 uArch_1.memory.mem_70_0 \
  uArch_1.memory.mem_71_3 uArch_1.memory.mem_71_2 uArch_1.memory.mem_71_1 uArch_1.memory.mem_71_0 \
  uArch_1.memory.mem_72_3 uArch_1.memory.mem_72_2 uArch_1.memory.mem_72_1 uArch_1.memory.mem_72_0 \
  uArch_1.memory.mem_73_3 uArch_1.memory.mem_73_2 uArch_1.memory.mem_73_1 uArch_1.memory.mem_73_0 \
  uArch_1.memory.mem_74_3 uArch_1.memory.mem_74_2 uArch_1.memory.mem_74_1 uArch_1.memory.mem_74_0 \
  uArch_1.memory.mem_75_3 uArch_1.memory.mem_75_2 uArch_1.memory.mem_75_1 uArch_1.memory.mem_75_0 \
  uArch_1.memory.mem_76_3 uArch_1.memory.mem_76_2 uArch_1.memory.mem_76_1 uArch_1.memory.mem_76_0 \
  uArch_1.memory.mem_77_3 uArch_1.memory.mem_77_2 uArch_1.memory.mem_77_1 uArch_1.memory.mem_77_0 \
  uArch_1.memory.mem_78_3 uArch_1.memory.mem_78_2 uArch_1.memory.mem_78_1 uArch_1.memory.mem_78_0 \
  uArch_1.memory.mem_79_3 uArch_1.memory.mem_79_2 uArch_1.memory.mem_79_1 uArch_1.memory.mem_79_0 \
  
  uArch_2.memory.mem_0_3  uArch_2.memory.mem_0_2  uArch_2.memory.mem_0_1  uArch_2.memory.mem_0_0  \
  uArch_2.memory.mem_1_3  uArch_2.memory.mem_1_2  uArch_2.memory.mem_1_1  uArch_2.memory.mem_1_0  \
  uArch_2.memory.mem_2_3  uArch_2.memory.mem_2_2  uArch_2.memory.mem_2_1  uArch_2.memory.mem_2_0  \
  uArch_2.memory.mem_3_3  uArch_2.memory.mem_3_2  uArch_2.memory.mem_3_1  uArch_2.memory.mem_3_0  \
  uArch_2.memory.mem_4_3  uArch_2.memory.mem_4_2  uArch_2.memory.mem_4_1  uArch_2.memory.mem_4_0  \
  uArch_2.memory.mem_5_3  uArch_2.memory.mem_5_2  uArch_2.memory.mem_5_1  uArch_2.memory.mem_5_0  \
  uArch_2.memory.mem_6_3  uArch_2.memory.mem_6_2  uArch_2.memory.mem_6_1  uArch_2.memory.mem_6_0  \
  uArch_2.memory.mem_7_3  uArch_2.memory.mem_7_2  uArch_2.memory.mem_7_1  uArch_2.memory.mem_7_0  \
  uArch_2.memory.mem_8_3  uArch_2.memory.mem_8_2  uArch_2.memory.mem_8_1  uArch_2.memory.mem_8_0  \
  uArch_2.memory.mem_9_3  uArch_2.memory.mem_9_2  uArch_2.memory.mem_9_1  uArch_2.memory.mem_9_0  \
  uArch_2.memory.mem_10_3 uArch_2.memory.mem_10_2 uArch_2.memory.mem_10_1 uArch_2.memory.mem_10_0 \
  uArch_2.memory.mem_11_3 uArch_2.memory.mem_11_2 uArch_2.memory.mem_11_1 uArch_2.memory.mem_11_0 \
  uArch_2.memory.mem_12_3 uArch_2.memory.mem_12_2 uArch_2.memory.mem_12_1 uArch_2.memory.mem_12_0 \
  uArch_2.memory.mem_13_3 uArch_2.memory.mem_13_2 uArch_2.memory.mem_13_1 uArch_2.memory.mem_13_0 \
  uArch_2.memory.mem_14_3 uArch_2.memory.mem_14_2 uArch_2.memory.mem_14_1 uArch_2.memory.mem_14_0 \
  uArch_2.memory.mem_15_3 uArch_2.memory.mem_15_2 uArch_2.memory.mem_15_1 uArch_2.memory.mem_15_0 \

  uArch_2.memory.mem_64_3 uArch_2.memory.mem_64_2 uArch_2.memory.mem_64_1 uArch_2.memory.mem_64_0 \
  uArch_2.memory.mem_65_3 uArch_2.memory.mem_65_2 uArch_2.memory.mem_65_1 uArch_2.memory.mem_65_0 \
  uArch_2.memory.mem_66_3 uArch_2.memory.mem_66_2 uArch_2.memory.mem_66_1 uArch_2.memory.mem_66_0 \
  uArch_2.memory.mem_67_3 uArch_2.memory.mem_67_2 uArch_2.memory.mem_67_1 uArch_2.memory.mem_67_0 \
  uArch_2.memory.mem_68_3 uArch_2.memory.mem_68_2 uArch_2.memory.mem_68_1 uArch_2.memory.mem_68_0 \
  uArch_2.memory.mem_69_3 uArch_2.memory.mem_69_2 uArch_2.memory.mem_69_1 uArch_2.memory.mem_69_0 \
  uArch_2.memory.mem_70_3 uArch_2.memory.mem_70_2 uArch_2.memory.mem_70_1 uArch_2.memory.mem_70_0 \
  uArch_2.memory.mem_71_3 uArch_2.memory.mem_71_2 uArch_2.memory.mem_71_1 uArch_2.memory.mem_71_0 \
  uArch_2.memory.mem_72_3 uArch_2.memory.mem_72_2 uArch_2.memory.mem_72_1 uArch_2.memory.mem_72_0 \
  uArch_2.memory.mem_73_3 uArch_2.memory.mem_73_2 uArch_2.memory.mem_73_1 uArch_2.memory.mem_73_0 \
  uArch_2.memory.mem_74_3 uArch_2.memory.mem_74_2 uArch_2.memory.mem_74_1 uArch_2.memory.mem_74_0 \
  uArch_2.memory.mem_75_3 uArch_2.memory.mem_75_2 uArch_2.memory.mem_75_1 uArch_2.memory.mem_75_0 \
  uArch_2.memory.mem_76_3 uArch_2.memory.mem_76_2 uArch_2.memory.mem_76_1 uArch_2.memory.mem_76_0 \
  uArch_2.memory.mem_77_3 uArch_2.memory.mem_77_2 uArch_2.memory.mem_77_1 uArch_2.memory.mem_77_0 \
  uArch_2.memory.mem_78_3 uArch_2.memory.mem_78_2 uArch_2.memory.mem_78_1 uArch_2.memory.mem_78_0 \
  uArch_2.memory.mem_79_3 uArch_2.memory.mem_79_2 uArch_2.memory.mem_79_1 uArch_2.memory.mem_79_0 \
}




# STEP: Simplification
assume {simplification}




# STEP: Same initial public state
assume {same_init_pubstate}




# STEP: Contract assumption check
assume {contract_assumption}




# STEP: Leakage assertion check
assert {leakage_assertion}




# STEP: Prove
set_prove_orchestration off
set_engine_mode {Ht Mp AM I}
set_prove_time_limit 7d
prove -all

