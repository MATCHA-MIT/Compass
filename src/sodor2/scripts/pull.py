
import os, sys
sys.path.append(os.getcwd())

from scripts.rsync.pull import pull




if __name__ == "__main__":
  from src.sodor2.scripts.param import SRC_FOLDER_NAME
  pull(SRC_FOLDER_NAME)

