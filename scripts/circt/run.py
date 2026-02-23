
import os


def run(SRC_FOLDER_NAME, PRESERVE_NAME=False):

  ## STEP: Remove old verilog code.
  cmd = f"rm -r src/{SRC_FOLDER_NAME}/verilog_{{original,taint}}"
  print("[command to run]:", cmd)
  # os.system(cmd)


  ## STEP: Firrtl options.
  opt  = ""
  opt += f"--export-module-hierarchy "
  opt += f"--verify-each=true "
  opt += f"--warn-on-unprocessed-annotations "
  opt += f"--disable-annotation-classless "
  opt += f"--disable-annotation-unknown "
  opt += f"--disable-all-randomization "
  opt += f"--lowering-options=emittedLineLength=2048,noAlwaysComb,"
  opt +=                    f"disallowLocalVariables,verifLabels,"
  opt +=                    f"disallowPackedArrays,"
  opt +=                    f"locationInfoStyle=wrapInAtSquareBracket "
  opt += f"--annotation-file=src/{SRC_FOLDER_NAME}/temp/anno.json "
  opt += f"--split-verilog"

  
  ## STEP: Generate new verilog code.
  cmd  = f""
  cmd += f"firtool {opt}"
  cmd += f" -o src/{SRC_FOLDER_NAME}/verilog_original"
  cmd += f" src/{SRC_FOLDER_NAME}/temp/firrtl.fir & "
  
  cmd += f"time -p"
  cmd += f" firtool {opt}"
  cmd += f" --ift-add-tracking-logic"
  if PRESERVE_NAME:
    cmd += f" --ift-preserve-name "
  cmd += f" -o src/{SRC_FOLDER_NAME}/verilog_taint"
  cmd += f" src/{SRC_FOLDER_NAME}/temp/firrtl.fir & "
  
  cmd += f"wait"
  
  print("[command to run]:", cmd)
  os.system(cmd)

