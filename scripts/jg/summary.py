
import os


def summary(projFolder):
  with open(f"{projFolder}/sessionLogs/session_0/jg_session_0.log", "r") as f:
    all_lines = f.readlines()
    result = "".join(all_lines[-100:])

  print(result)
  return result


def isCounterexample(log):
  isCex    = None
  isProven = None
  isUndertermined = None
  
  for line in log.split("\n"):
    if   "- cex                       : 0" in line:
      isCex    = False
    elif "- cex                       : 1" in line:
      isCex    = True
    elif "- proven                    : 0" in line:
      isProven = False
    elif "- proven                    : 1" in line:
      isProven = True
    elif "- undetermined              : 1" in line:
      isUndertermined = True
    elif "- undetermined              : 0" in line:
      isUndertermined = False
    elif "covers                       : 0" in line:
      break

  assert isCex!=None and isProven!=None and isUndertermined!=None, \
         "Cannot parse JasperGold log."

  ## NOTE: When Proven, it will gives a cover property being violated, as cex,
  #        if the assumption is violated.
  ## NOTE: When has a max bound, undertermined means "property is proven for
  #        the bound".
  return not (isProven or isUndertermined)

