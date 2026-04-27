
import os, sys
sys.path.append(os.getcwd())

from scripts.rsync.push import push




if __name__ == "__main__":
  from src.boom.scripts.param import SRC_FOLDER_NAME
  push(SRC_FOLDER_NAME)

