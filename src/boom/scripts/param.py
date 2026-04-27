

## NOTE: Customize me for batch run
CONFIG = "MyBoomSecureAutoSandboxConfig"
TCL_PATH = "src/boom/veri/1taint_sandbox.tcl"




## NOTE: Keep Me Default
SRC_FOLDER_NAME = "boom"
SRC_FILELIST = [
  "generators/boom/src/main/scala",
  "generators/rocket-chip/src/main/scala/annotations.scala",
  "generators/rocket-chip/src/main/scala/tilelink/Monitor.scala",
  "generators/rocket-chip/src/main/scala/rocket/CSR.scala",
  "generators/rocket-chip/src/main/scala/rocket/Multiplier.scala",
  "generators/rocket-chip/src/main/scala/rocket/PMP.scala",
  "generators/rocket-chip/src/main/scala/rocket/PTW.scala",
  "generators/rocket-chip/src/main/scala/rocket/TLB.scala",
  "generators/hardfloat/hardfloat/src/main/scala/annotations.scala",
  "generators/hardfloat/hardfloat/src/main/scala/DivSqrtRecF64.scala",
  "generators/hardfloat/hardfloat/src/main/scala/DivSqrtRecF64_mulAddZ31.scala",
  "generators/chipyard/src/main/scala/config/BoomConfigs.scala",
]
MODULE_TOP = "BoomTile"
def changeFirTopModule_updateFlag(flag, line, words, module_top):
  match flag:
    case 0:
      if len(words)==3 and words[0]=="module" and words[1]==module_top:
        flag = 1
    case 1:
      flag = 2
    case 2:
      line = line.replace(": Reset", ": UInt<1>")
      flag = -1
    case _:
      assert False
  return flag, line

INITIAL_ABSTRACT_SIGNALS = []
for i in range(8):
  INITIAL_ABSTRACT_SIGNALS.append(
    f"veri_1taint.uArch.frontend_taint.icache_taint.dataArrayWay_0_{i}" + \
    f"[63:0]")
for i in range(8, 16):
  INITIAL_ABSTRACT_SIGNALS.append(
    f"veri_1taint.uArch.dcache_taint.data_taint.array_0_0_{i}_0[63:0]")
REVERTED_SIGNALS = \
  (["veri_1taint.uArch.dcache_taint.data_taint.array_0_0_15_0[63:0]"], 64)
MODULE_WRAPPER = "veri_1taint"
obsvSignal = "veri_1taint.uArch_obsv_taint"
obsvList = [
  "uArch.core_taint.rob_taint.my_commit_valid",
  "uArch.my_mem_addr",
]

