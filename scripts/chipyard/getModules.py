
import os
import json


def getModules(modules_file):
  with open(modules_file, "r") as f:
    modules = json.load(f)

  return modules["module_top"], modules["modules"]

