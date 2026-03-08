

## NOTE: Customize me for batch run
CONFIG = "MySodor2StageAutoSandboxConfig"
TCL_PATH = "src/sodor2/veri/1taint_sandbox.tcl"




## NOTE: Keep Me Default
SRC_FOLDER_NAME = "sodor2"
SRC_FILELIST = [
  "generators/riscv-sodor/src/main/scala/sodor/common/*",
  "generators/riscv-sodor/src/main/scala/sodor/rv32_2stage/*",
  "generators/riscv-sodor/src/main/scala/annotations.scala",
  "generators/chipyard/src/main/scala/config/SodorConfigs.scala",
]
MODULE_TOP = "SodorInternalTile"
def changeFirTopModule_updateFlag(flag, line, words, module_top):
  if   flag==0:
    if len(words)==3 and words[0]=="module" and words[1]==module_top:
      flag = 1
  elif flag==1:
    flag = 2
  elif flag==2:
    line = line.replace(": Reset", ": UInt<1>")
    flag = 3
  elif flag==3:
    line = line.replace("hartid : UInt", "hartid : UInt<1>")
    line = line.replace("reset_vector : UInt", "reset_vector : UInt<32>")
    flag = -1
  else:
    assert False

  return flag, line

INITIAL_ABSTRACT_SIGNALS = []
for i in (list(range(0, 16)) + list(range(64, 80))):
  for j in range(3, -1, -1):
    INITIAL_ABSTRACT_SIGNALS.append(
      f"veri_1taint.uArch.memory_taint.mem_{i}_{j}[7:0]")
REVERTED_SIGNALS = ([
  "veri_1taint.uArch.memory_taint.mem_79_3[7:0]",
  "veri_1taint.uArch.memory_taint.mem_79_2[7:0]",
  "veri_1taint.uArch.memory_taint.mem_79_1[7:0]",
  "veri_1taint.uArch.memory_taint.mem_79_0[7:0]",
  ], 8)
MODULE_WRAPPER = "veri_1taint"
obsvSignal = "veri_1taint.uArch_obsv_taint"
obsvList = [
  "uArch.core_taint.d_taint.my_commit_valid",
  "uArch.core_taint.my_imem_valid",
  "uArch.core_taint.my_imem_addr",
  "uArch.core_taint.my_dmem_valid",
  "uArch.core_taint.my_dmem_addr",
]

