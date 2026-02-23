
import os, sys
sys.path.append(os.getcwd())


def pull(SRC_FOLDER_NAME):
  from scripts.rsync  import rsync
  from scripts.server import server

  rsync(
    f"{server['name']}:{server['path']}",
    f".",
    [
      f"src/{SRC_FOLDER_NAME}/temp",
      f"src/{SRC_FOLDER_NAME}/verilog_original",
      f"src/{SRC_FOLDER_NAME}/verilog_taint",
    ],
    EXTRA_EXCLUDELIST=[
    ]
  )




if __name__ == "__main__":
  from src.sodor2.scripts.param import SRC_FOLDER_NAME
  pull(SRC_FOLDER_NAME)

