

## NOTE: Customize me for batch run
CONFIG_ALL = [
  "MySodor2StageAutoSandboxConfig",
]




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

