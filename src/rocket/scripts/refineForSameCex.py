
import os, sys
sys.path.append(os.getcwd())

from scripts.refine.refineForSameCex import refineForSameCex \
                                         as refineForSameCex_global


def refineForSameCex(CONFIG, TCL_PATH):
  from src.rocket.scripts.param import \
    SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP, changeFirTopModule_updateFlag, \
    INITIAL_ABSTRACT_SIGNALS, REVERTED_SIGNALS, MODULE_WRAPPER, obsvSignal, \
    obsvList
  
  refineForSameCex_global(
    CONFIG, TCL_PATH, SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP,
    changeFirTopModule_updateFlag, INITIAL_ABSTRACT_SIGNALS, REVERTED_SIGNALS,
    MODULE_WRAPPER, obsvSignal, obsvList)




if __name__ == "__main__":
  from src.rocket.scripts.param import CONFIG, TCL_PATH
  refineForSameCex(CONFIG, TCL_PATH)

