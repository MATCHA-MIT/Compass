
import sys, os
import json
sys.path.append(os.getcwd())

from scripts.chipyard.getModules import getModules


def changeFirTopModule(modules_file, Fir_inFile, Fir_outFile, updateFlag):

  ## PART1: Collect the names of modules we want to keep.
  module_top, module_list = getModules(modules_file)


  ## PART2: Move Firrtl file.
  # assert     os.path.exists(Fir_inFile),  "Fir_inFile not exists"
  # assert not os.path.exists(Fir_outFile), "Fir_outFile already exists"

  with open(Fir_inFile, "r") as f_in, open(Fir_outFile, "w") as f_out:

    ## PART.1: Version line
    line = f_in.readline()
    assert line.split()[0]=="FIRRTL", "version line miss"
    f_out.writelines(line)
    

    ## PART.2: Circuit line
    line = f_in.readline()
    assert line.split()[0]=="circuit", "circuit line miss"
    f_out.writelines(f"circuit {module_top} :\n")


    ## PART.3: Modules
    keep_line = True
    flag = 0
    while line:
      line = f_in.readline()

      ## PART..1: If a module line, check whether we want this module.
      words = line.split()
      if len(words)==3 and words[0] in ["module", "extmodule"]:
        if words[1] in module_list:
          keep_line = True
        else:
          keep_line = False

      ## PART..2: Move the line to output
      if keep_line:

        ## PART..3: Caller provide a function `updateFlag` to do some
        ##          core-specific modification.
        if flag!=-1:
          flag, line = updateFlag(flag, line, words, module_top)

        f_out.writelines(line)

