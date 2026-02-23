
import os


def run(CONFIG, SRC_FOLDER_NAME, SRC_FILELIST):

  ## STEP: Git clean reset.
  cmd  = f""
  cmd += f"cd env/chipyard && "
  cmd += f"git clean -fd > /dev/null && "
  cmd += f"git reset --hard > /dev/null && "
  cmd += f"git submodule foreach --recursive git clean -fd > /dev/null && "
  cmd += f"git submodule foreach --recursive git reset --hard > /dev/null"
  print("[command to run]:", cmd)
  os.system(cmd)


  ## STEP: Override updated chisel code.
  cmd  = f""
  cmd += f"cd src/{SRC_FOLDER_NAME} && "
  cmd += f"cp --parents"
  for file in SRC_FILELIST:
    cmd += f" {file}"
  cmd += f" ../../env/chipyard/"
  print("[command to run]:", cmd)
  os.system(cmd)
  

  ## STEP: Generate firrtl code.
  cmd  = f""
  cmd += f"cd env/chipyard/sims/verilator && "
  cmd += f"time -p conda run --no-capture-output make firrtl CONFIG={CONFIG}"
  cmd += f""
  print("[command to run]:", cmd)
  os.system(cmd)

