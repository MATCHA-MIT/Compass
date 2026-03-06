
import os, sys

sys.path.append(os.getcwd())


def run(CONFIG, TCL_PATH, STALL, PROJECT_NAME="project"):
  projFolder = TCL_PATH[:-4] + f"_{CONFIG}.jgproject"

  command  = ""
  command += f"rm -rf {projFolder} && "
  if not STALL:
    command += "("
  command += f"/usr/bin/time -p jg -batch -proj {projFolder} {TCL_PATH} > /dev/null"
  if not STALL:
    command += " &)"
  
  print("[command to run]: ", command)
  os.system(command)

