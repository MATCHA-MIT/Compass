
import os, sys
sys.path.append(os.getcwd())

from scripts.chipyard.run                 import run as cy_run
from scripts.chipyard.summarizeModules    import summarizeModules
from scripts.chipyard.changeFirTopModule  import changeFirTopModule
from scripts.chipyard.changeAnnoTopModule import changeAnnoTopModule
from scripts.circt.run                    import run as circt_run


def genTaintLogic(CONFIG, SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP, \
                  changeFirTopModule_updateFlag):

  ## STEP: Chipyard
  cy_run(CONFIG, SRC_FOLDER_NAME, SRC_FILELIST)


  ## STEP: Format
  os.makedirs(f"src/{SRC_FOLDER_NAME}/temp", exist_ok=True)
  cyOut  = f"env/chipyard/sims/verilator/generated-src/" + \
           f"chipyard.harness.TestHarness.{CONFIG}"
  firIn  = f"{cyOut}/chipyard.harness.TestHarness.{CONFIG}.fir"
  annoIn = f"{cyOut}/chipyard.harness.TestHarness.{CONFIG}.anno.json"
  module = f"src/{SRC_FOLDER_NAME}/temp/modules.json"

  ## STEP.1: Get top module and submodule names
  summarizeModules(firIn, module, MODULE_TOP)

  ## STEP.2: Change Fir file
  changeFirTopModule(module, firIn, f"src/{SRC_FOLDER_NAME}/temp/firrtl.fir", \
                     changeFirTopModule_updateFlag)

  ## STEP.3: Change Anno file
  changeAnnoTopModule(module, annoIn, f"src/{SRC_FOLDER_NAME}/temp/anno.json")


  ## STEP: Circt
  circt_run(SRC_FOLDER_NAME)

