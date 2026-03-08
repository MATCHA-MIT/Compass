
import os, sys
sys.path.append(os.getcwd())

from scripts.refine.get_srcOfImprecision import get_srcOfImprecision
from scripts.refine.lib                  import unzipCex, gen_concrete_state, \
                                                modify_concrete_state
from scripts.jg.run                      import run


def refine(CONFIG, TCL_PATH, SRC_FOLDER_NAME, INITIAL_ABSTRACT_SIGNALS,
           REVERTED_SIGNALS, MODULE_WRAPPER, obsvSignal, obsvList):
  projFolder         = f"{TCL_PATH[:-4]}_{CONFIG}.jgproject"
  CONCRETE_TCL_PATH  = f"{TCL_PATH[:-4]}_concrete.tcl"
  projConcreteFolder = f"{TCL_PATH[:-4]}_concrete_{CONFIG}.jgproject"
  wave1              = f"src/{SRC_FOLDER_NAME}/temp/wave1.vcd"
  wave2              = f"src/{SRC_FOLDER_NAME}/temp/wave2.vcd"


  ## STEP: Get the wave 1 of the cex.
  unzipCex(projFolder, wave1)

  ## STEP: Extract concrete initial state from wave 1 with reverted secret and
  #        get the wave 2 of the cex.
  gen_concrete_state(wave1, SRC_FOLDER_NAME, INITIAL_ABSTRACT_SIGNALS)
  modify_concrete_state(SRC_FOLDER_NAME, REVERTED_SIGNALS)
  run(CONFIG, CONCRETE_TCL_PATH, True)
  unzipCex(projConcreteFolder, wave2)

  ## STEP: Trace back for signal to refine.
  get_srcOfImprecision(SRC_FOLDER_NAME, MODULE_WRAPPER, obsvSignal, obsvList)

