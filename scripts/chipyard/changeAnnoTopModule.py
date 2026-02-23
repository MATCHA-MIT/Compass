
import sys, os
import json
sys.path.append(os.getcwd())

from scripts.chipyard.getModules import getModules


def changeAnnoTopModule(modules_file, anno_inFile, anno_outFile):

  ## PART1: Collect the names of top instance.
  module_top, module_list = getModules(modules_file)

  # assert     os.path.exists(anno_inFile),  "anno_inFile not exists"
  # assert not os.path.exists(anno_outFile), "anno_outFile already exists"

  ## PART2
  with open(anno_inFile, "r") as f:
    anno_in = json.load(f)

  ## PART3
  anno_out = []
  for entry in anno_in:
    if "target" in entry:
      target = entry["target"]
      for module in module_list:
        if target.find(f"|{module}")==-1:
          continue
        path = target.split(f"|{module}")

        if entry["class"]=="chisel3.experimental.CircuitIFTConfigAnnotation":
          assert(module==module_top and path[1]=="")
          entry["class"] = "chisel3.experimental.IFTConfigAnnotation"
          entry["target"] = f"~{module_top}"
          anno_out.append(entry)
        
        else:
          entry["target"] = f"~{module_top}|{module}{path[1]}"
          anno_out.append(entry)
        
        break

  ## PART4
  with open(anno_outFile, "w") as f:
    json.dump(anno_out, f, indent=2)

