
import os, sys
sys.path.append(os.getcwd())

from scripts.refine.Wave import Wave


def unzipCex(projFolder, waveFile):
  sessionFolder = f"{projFolder}/sessionLogs/session_0"
  gzFile = None
  for f in os.listdir(sessionFolder):
    if f.endswith(".vcd.gz"):
      assert not gzFile, f"More than one .vcd.gz file in {sessionFolder}"
      gzFile = f
  assert gzFile, f"Cannot find .vcd.gz file in {sessionFolder}"

  cmd = f"gzip -cdv {sessionFolder}/{gzFile} > {waveFile}"
  print("[command to run]: ", cmd)
  os.system(cmd)


def gen_line(signal, value, REVERTED_SIGNALS):
  if signal in REVERTED_SIGNALS[0]:
    value = 2**REVERTED_SIGNALS[1] - 1 - value
  return f"&& {signal}==64'd{value}\n"


def gen_concrete_state(waveFile, SRC_FOLDER_NAME, signalList):
  output_file = f"src/{SRC_FOLDER_NAME}/temp/concrete_state.v"
  
  wave = Wave(waveFile)

  with open(output_file, "w") as f:
    f.writelines("wire concrete_state = 1'h1\n")
    for signal in signalList:
      initial_value = wave.get(1, f"{signal}")
      f.writelines(gen_line(signal, initial_value, ([], None)))
    f.writelines(";\n")


def modify_concrete_state(SRC_FOLDER_NAME, REVERTED_SIGNALS):
  output_file = f"src/{SRC_FOLDER_NAME}/temp/concrete_state.v"

  with open(output_file, "r",) as f: 
    lines = f.readlines() 
    
  for i, line in enumerate(lines[1:-1]):
    signal = line.split("==")[0][3:]
    value = int(line.split("==")[1].split("'d")[1])
    lines[i+1] = gen_line(signal, value, REVERTED_SIGNALS)
    
  with open(output_file, "w") as f: 
    f.writelines(lines)

