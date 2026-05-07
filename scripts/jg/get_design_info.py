
import os, sys

sys.path.append(os.getcwd())
from scripts.jg.run import run


def get_design_info(SRC_FOLDER_NAME, CONFIG):
  
  ## STEP: Run get_design_info.tcl.
  TCL_PATH = f"src/{SRC_FOLDER_NAME}/veri/get_design_info.tcl"
  run(CONFIG, TCL_PATH, True)


  ## STEP: Copy results.
  tempFld = f"src/{SRC_FOLDER_NAME}/temp"
  infoFld = f"src/{SRC_FOLDER_NAME}/design_info"
  
  command = f"mkdir -p {infoFld}"
  print("[command to run]: ", command)
  os.system(command)

  command = f"cp -f {tempFld}/uArchOriginal.txt {infoFld}/"
  print("[command to run]: ", command)
  os.system(command)

  command = f"cp -f {tempFld}/uArchTaint.txt {infoFld}/uArchTaint_{CONFIG}.txt"
  print("[command to run]: ", command)
  os.system(command)

  command = f"cp -f {tempFld}/ISATaint.txt {infoFld}/"
  print("[command to run]: ", command)
  os.system(command)

