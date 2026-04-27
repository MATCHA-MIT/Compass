

## NOTE: Customize me for batch run
CONFIG = "MyRocketAutoSandboxConfig"
TCL_PATH = "src/rocket/veri/1taint_sandbox.tcl"




## NOTE: Keep Me Default
SRC_FOLDER_NAME = "rocket"
SRC_FILELIST = [
  "generators/rocket-chip/src/main/scala/rocket",
  "generators/rocket-chip/src/main/scala/tile",
  "generators/rocket-chip/src/main/scala/subsystem/Configs.scala",
  "generators/rocket-chip/src/main/scala/annotations.scala",
  "generators/hardfloat/hardfloat/src/main/scala/DivSqrtRecFN_small.scala",
  "generators/hardfloat/hardfloat/src/main/scala/annotations.scala",
  "generators/chipyard/src/main/scala/config/RocketConfigs.scala",
]
MODULE_TOP = "RocketTile"
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
for i in range(2):
  for j in range(8):
    INITIAL_ABSTRACT_SIGNALS.append(
      f"veri_1taint.uArch.frontend_taint.icache_taint.data_arrays_{i}_{j}_0" + \
      f"[31:0]")
for i in range(8):
  for j in range(8):
    INITIAL_ABSTRACT_SIGNALS.append(
      f"veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_{i}_{j}[7:0]")
REVERTED_SIGNALS = \
  ([
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_0[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_1[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_2[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_3[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_4[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_5[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_6[7:0]",
    "veri_1taint.uArch.dcache_taint.data_taint.data_arrays_0_7_7[7:0]",
    ], 8)
MODULE_WRAPPER = "veri_1taint"
obsvSignal = "veri_1taint.uArch_obsv_taint"
obsvList = [
  "uArch.core_taint.my_commit_valid",
  "uArch.frontend_taint.icache_taint.my_icache_valid",
  "uArch.frontend_taint.icache_taint.my_icache_addr",
  "uArch.dcache_taint.my_dcache_valid",
  "uArch.dcache_taint.my_dcache_addr",
]

