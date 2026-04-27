
import os, sys
sys.path.append(os.getcwd())

from scripts.refine.refine import refine as refine_global


def refine(CONFIG, TCL_PATH):
  from src.rocket.scripts.param import \
    SRC_FOLDER_NAME, INITIAL_ABSTRACT_SIGNALS, REVERTED_SIGNALS, \
    MODULE_WRAPPER, obsvSignal, obsvList
  
  refine_global(CONFIG, TCL_PATH, SRC_FOLDER_NAME, INITIAL_ABSTRACT_SIGNALS,
                REVERTED_SIGNALS, MODULE_WRAPPER, obsvSignal, obsvList)




if __name__ == "__main__":
  from src.rocket.scripts.param import CONFIG, TCL_PATH
  refine(CONFIG, TCL_PATH)

