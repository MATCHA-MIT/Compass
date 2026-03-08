
import os, sys
sys.path.append(os.getcwd())

from scripts.refine.get_srcOfImprecision import get_srcOfImprecision
from scripts.refine.lib                  import *
from scripts.genTaintLogic               import genTaintLogic
from scripts.jg.run                      import run
from scripts.jg.summary                  import summary, isCounterexample

def refineForSameCex( \
  CONFIG, TCL_PATH, SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP, \
  changeFirTopModule_updateFlag, INITIAL_ABSTRACT_SIGNALS, REVERTED_SIGNALS, \
  MODULE_WRAPPER, obsvSignal, obsvList):
  
  CONCRETE_TCL_PATH  = f"{TCL_PATH[:-4]}_concrete.tcl"
  projConcreteFolder = f"{TCL_PATH[:-4]}_concrete_{CONFIG}.jgproject"
  wave1              = f"src/{SRC_FOLDER_NAME}/temp/wave1.vcd"
  wave2              = f"src/{SRC_FOLDER_NAME}/temp/wave2.vcd"

  ## STEP: Generate new taint logic.
  genTaintLogic(CONFIG, SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP,
                changeFirTopModule_updateFlag)

  ## STEP: Extract concrete initial state from wave 1 and check property.
  gen_concrete_state(wave1, SRC_FOLDER_NAME, INITIAL_ABSTRACT_SIGNALS)
  run(CONFIG, CONCRETE_TCL_PATH, True)
  
  ## STEP: Check whether it is still a counterexample.
  result = summary(projConcreteFolder)
  if not isCounterexample(result):
    print("")
    print("*************************************************************")
    print("*********** The Same Counterexample is Eliminated ***********")
    print("*************************************************************")
    return False
  else:
    print("")
    print("*************************************************************")
    print("************** Same Counterexample Still Works **************")
    print("*************************************************************")

  ## STEP: Get the wave 1 of the cex.
  unzipCex(projConcreteFolder, wave1)

  ## STEP: Revert secret and get the wave 2 of the cex.
  modify_concrete_state(SRC_FOLDER_NAME, REVERTED_SIGNALS)
  run(CONFIG, CONCRETE_TCL_PATH, True)
  unzipCex(projConcreteFolder, wave2)

  ## STEP: Trace back for signal to refine.
  get_srcOfImprecision(SRC_FOLDER_NAME, MODULE_WRAPPER, obsvSignal, obsvList)

