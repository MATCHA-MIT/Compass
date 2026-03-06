
import os, sys
sys.path.append(os.getcwd())


def push(SRC_FOLDER_NAME):
  from scripts.rsync.rsync  import rsync
  from scripts.rsync.server import server

  rsync(
    f".",
    f"{server['name']}:{server['path']}",
    [
      f"scripts",
      f"src/{SRC_FOLDER_NAME}/generators",
      f"src/{SRC_FOLDER_NAME}/scripts",
      f"src/{SRC_FOLDER_NAME}/ISATaint/src",
      f"src/{SRC_FOLDER_NAME}/ISATaint/build.sbt",
      f"src/{SRC_FOLDER_NAME}/ISATaint/scripts",
      f"src/{SRC_FOLDER_NAME}/veri",
    ],
    EXTRA_EXCLUDELIST=[
      "*.jgproject",
    ]
  )

