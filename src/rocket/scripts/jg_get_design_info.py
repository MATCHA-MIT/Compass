
import os, sys

sys.path.append(os.getcwd())
from scripts.jg.get_design_info import get_design_info


def jg_get_design_info(SRC_FOLDER_NAME, CONFIG):
  get_design_info(SRC_FOLDER_NAME, CONFIG)




if __name__ == "__main__":
  from src.rocket.scripts.param import SRC_FOLDER_NAME, CONFIG
  jg_get_design_info(SRC_FOLDER_NAME, CONFIG)

