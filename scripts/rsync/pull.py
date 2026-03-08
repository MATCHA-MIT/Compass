
import os, sys
sys.path.append(os.getcwd())


def pull(SRC_FOLDER_NAME):
  from scripts.rsync.rsync  import rsync
  from scripts.rsync.server import server

  rsync(
    f"{server['name']}:{server['path']}",
    f".",
    [
      f"src/{SRC_FOLDER_NAME}/temp",
      f"src/{SRC_FOLDER_NAME}/verilog_original",
      f"src/{SRC_FOLDER_NAME}/verilog_taint",
      f"src/{SRC_FOLDER_NAME}/ISATaint/verilog",
      f"src/{SRC_FOLDER_NAME}/veri/*.jgproject",
    ],
    EXTRA_EXCLUDELIST=[
    ]
  )

