
import os


if __name__ == "__main__":
  command  = ""
  command += "cd src/boom/ISATaint && "
  command += "rm -rf verilog && "
  command += "sbt clean \"run\""

  print("[command to run]: ", command)
  os.system(command)

