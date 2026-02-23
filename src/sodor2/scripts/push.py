
import os, sys
sys.path.append(os.getcwd())


def push(SRC_FOLDER_NAME):
  from scripts.rsync  import rsync
  from scripts.server import server

  rsync(
    f".",
    f"{server['name']}:{server['path']}",
    [
      f"scripts",
      f"src/{SRC_FOLDER_NAME}/generators",
      f"src/{SRC_FOLDER_NAME}/scripts",
    ],
    EXTRA_EXCLUDELIST=[
    ]
  )


if __name__ == "__main__":
  from src.sodor2.scripts.param import SRC_FOLDER_NAME
  push(SRC_FOLDER_NAME)

