
import json


def summarizeModules(fir_file, modules_file, module_top):

  ## STEP: Initialize the module list with the top module.
  modules = [module_top]

  ## STEP: Read the whole firrtl file.
  with open(fir_file, "r") as f:
    lines = f.readlines()

  ## STEP: Iteratively append module list until no more modules being added.
  more_module_just_added = True
  while (more_module_just_added):
    more_module_just_added = False
    line_belong_to_kept_module = False
    
    for line in lines:
      words = line.split()
      
      if len(words)==3 and words[0] in ["module", "extmodule"]:
        if words[1] in modules:
          line_belong_to_kept_module = True
        else:
          line_belong_to_kept_module = False
      
      elif line_belong_to_kept_module and \
           len(words)>=4 and words[0]=="inst" and words[2]=="of" and \
           words[3] not in modules:
        modules.append(words[3])
        more_module_just_added = True

  ## STEP: Write to the output file.
  with open(modules_file, "w") as f:
    json.dump({"module_top": module_top, "modules": modules}, f, indent=2)

