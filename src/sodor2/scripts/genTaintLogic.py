
import os, sys
sys.path.append(os.getcwd())

from scripts.genTaintLogic  import genTaintLogic as genTaintLogic_global
from src.sodor2.scripts.param import \
  SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP, changeFirTopModule_updateFlag


def genTaintLogic(CONFIG):
  genTaintLogic_global(CONFIG, SRC_FOLDER_NAME, SRC_FILELIST, MODULE_TOP, \
                  changeFirTopModule_updateFlag)




if __name__ == "__main__":
  from src.sodor2.scripts.param import CONFIG_ALL
  for CONFIG in CONFIG_ALL:
    genTaintLogic(CONFIG)

