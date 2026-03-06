
import os, sys
sys.path.append(os.getcwd())

from scripts.jg.run import run


def jg_run(CONFIG, TCL_PATH, STALL):
  run(CONFIG, TCL_PATH, STALL)




if __name__ == "__main__":
  from src.sodor2.scripts.param import CONFIG, TCL_PATH
  jg_run(CONFIG, TCL_PATH, True)

