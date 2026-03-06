
import os, sys
sys.path.append(os.getcwd())


def push():
  from scripts.rsync.rsync  import rsync
  from scripts.rsync.server import server

  rsync(
    "env",
    f"{server['name']}:{server['path']}/env",
    [
      "install.sh",
      "setup.sh",
    ]
  )




if __name__ == "__main__":
  push()

