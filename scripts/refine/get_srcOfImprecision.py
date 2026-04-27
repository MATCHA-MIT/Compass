
import os, sys, time

sys.path.append(os.getcwd())
from scripts.refine.Wave import Wave
from scripts.refine.Netlist import Netlist


## NOTE: Keep Me Default
MAX_DEPTH_OF_TEMPORAL_SIGNALS = 15


class NameMap:
  def __init__(self, waveSignals, taintSignals, MODULE_WRAPPER, is_reg):
    self.waveSignals    = waveSignals
    self.taintSignals   = taintSignals
    self.MODULE_WRAPPER = MODULE_WRAPPER
    self.is_reg         = is_reg

    self.toTaintNameCached = {}


  def addPrefix(self, name):
    return f"{self.MODULE_WRAPPER}.{name}"


  def addbitwidthSuffix(self, name, signals):
    candidates = list(filter(
      lambda x: x.startswith(name + "[") and x.endswith(":0]"),
      signals))
    assert len(candidates)<=1, \
           f"Cannot decide the bitwidth suffix for {name} becuase we have " + \
           f"many candidates: {candidates}."

    if len(candidates)==1:
      # print(f"[Naming - Add Bitwidth Suffix] Added a bitwidth suffix to",
      #       f"{name} and get {candidates[0]}.")
      return True, candidates[0]
    else:
      return False, None
  

  def getWaveNameInternal(self, netlistName):
    
    ## STEP: Try default.
    waveName = self.addPrefix(netlistName)
    if waveName in self.waveSignals:
      return True, waveName
    
    ## STEP: Try to add bitwidth suffix.
    succeed, waveName = self.addbitwidthSuffix(waveName, self.waveSignals)
    if succeed:
      return True, waveName

    ## STEP: Fail
    return False, None


  def getTaintNameInternal(self, netlistName):
    
    ## STEP: Cached.
    if netlistName in self.toTaintNameCached:
      return True, self.toTaintNameCached[netlistName]

    ## STEP: Module level taint bit.
    moduleTaintName = self.addPrefix(
      ".".join(netlistName.split(".")[:-1] + ["moduleLevel"]))
    if moduleTaintName in self.taintSignals and self.is_reg(netlistName):
      return True, moduleTaintName

    ## STEP: Try default.
    taintName = self.addPrefix(netlistName) + "_taint"
    if taintName in self.taintSignals:
      return True, taintName

    ## STEP: Try to add bitwidth suffix.
    succeed, taintName = self.addbitwidthSuffix(taintName, self.taintSignals)
    if succeed:
      return True, taintName

    ## STEP: Sometime, the signal is "xxx_0" and taint signal is "xxx_taint_0".
    taintName = self.addPrefix(netlistName)[:-2] + "_taint" + netlistName[-2:]
    if taintName in self.taintSignals:
      # print(f"[Naming - _0] {netlistName} -> {taintName}")
      return True, taintName

    ## STEP: Try to add bitwidth suffix.
    succeed, taintName = self.addbitwidthSuffix(taintName, self.taintSignals)
    if succeed:
      # print(f"[Naming - _0] {netlistName} -> {taintName}")
      return True, taintName

    return False, None


  ## PUBLIC:
  def hasWaveName(self, netlistName):
    succeed, waveName = self.getWaveNameInternal(netlistName)
    return succeed


  def getWaveName(self, netlistName):
    succeed, waveName = self.getWaveNameInternal(netlistName)

    if succeed:
      return waveName
    else:
      assert False, \
             f"Cannot find wave name for the netlist name {netlistName}."


  def hasTaintName(self, netlistName):
    succeed, taintName = self.getTaintNameInternal(netlistName)
    if succeed:
      self.toTaintNameCached[netlistName] = taintName
    return succeed


  def getTaintName(self, netlistName):
    succeed, taintName = self.getTaintNameInternal(netlistName)

    if succeed:
      return taintName
    else:
      assert False, \
             f"Cannot find taint name for the netlist name {netlistName}."




def get_srcOfImprecision(
  SRC_FOLDER_NAME, MODULE_WRAPPER, obsvSignal, obsvList):

  def is_imprecise(signalDict):
    netlistName = signalDict["name"]
    cycle       = signalDict["cycle"]
    
    waveName  = nameMap.getWaveName(netlistName)
    taintName = nameMap.getTaintName(netlistName)

    print(f"[Check Imprecision] For {netlistName}, ",
          f"Wave1({hex(wave1.get(cycle, waveName))})",
          f"Wave2({hex(wave2.get(cycle, waveName))})",
          f"Taint({hex(taint.get(cycle, taintName))})")
    
    return (wave1.get(cycle, waveName)==wave2.get(cycle, waveName)) and \
           (taint.get(cycle, taintName)==1)
  
  def printValue(signalDict):
    netlistName = signalDict["name"]
    cycle       = signalDict["cycle"]
    
    waveName  = nameMap.getWaveName(netlistName)
    taintName = nameMap.getTaintName(netlistName)

    print(f"@Cycle {cycle}, {netlistName}:",
          f"Wave1({hex(wave1.get(cycle, waveName))})",
          f"Wave2({hex(wave2.get(cycle, waveName))})",
          f"Taint({hex(taint.get(cycle, taintName))})")


  ## NOTE: Some signal in the original verilog is temporal signals that do not
  ##       have a corresponding taint signal. In this case, we replace it with
  ##       its fanin signals.
  def getNamedFanIn(signalDict, get_fanIn):
    
    def recureFunc(signalDict):
      name  = signalDict["name"]
      cycle = signalDict["cycle"]
      depth = signalDict["depth"]

      assert depth>0, f"Fail to replace all temporal signals within" + \
                      f"{MAX_DEPTH_OF_TEMPORAL_SIGNALS} iterations."

      fanIn = []
      fanInCycle = cycle
      if netlist.is_reg(name):
        fanInCycle -= 1
    
      for n in get_fanIn(name, cycle):
        if nameMap.hasWaveName(n) and nameMap.hasTaintName(n):
          fanIn.append({
            "name" : n,
            "cycle": fanInCycle
          })
        else:
          fanIn += recureFunc({
            "name" : n,
            "cycle": fanInCycle,
            "depth": depth-1
          })

      return fanIn
  
    def removeDup(signalDictList):
      newList = []
      for s in signalDictList:
        if s not in newList:
          newList.append(s)
      return newList
      
    return removeDup(recureFunc({
      "name" : signalDict["name"],
      "cycle": signalDict["cycle"],
      "depth": MAX_DEPTH_OF_TEMPORAL_SIGNALS
    }))




  startTime = time.time()

  ## STEP: Constant
  verilog_folder = f"src/{SRC_FOLDER_NAME}/verilog_taint"
  wave1_file = f"src/{SRC_FOLDER_NAME}/temp/wave1.vcd"
  wave2_file = f"src/{SRC_FOLDER_NAME}/temp/wave2.vcd"
  taint_file = f"src/{SRC_FOLDER_NAME}/temp/wave1.vcd"


  ## STEP: Data structure
  netlist = Netlist(SRC_FOLDER_NAME)
  wave1 = Wave(wave1_file)
  wave2 = Wave(wave2_file)
  taint = Wave(taint_file)
  nameMap = NameMap(wave1.getSignals(), taint.getSignals(), MODULE_WRAPPER,
                    netlist.is_reg)


  ## STEP: Init `cycle`.
  cycle = 0
  for _ in range(100):
    cycle += 1
    if taint.get(cycle, obsvSignal)==1:
      break
  assert cycle < 100, "Cannot find tainted cycle."
  print(f"[Init - Tainted Cycle] {cycle}")


  ## STEP: Init `impreciseSignalDict`.
  for i, name in enumerate(obsvList):
    obsvList[i] = {"name": name, "cycle": cycle}
  impreciseObsvList = list(filter(is_imprecise, obsvList))
  assert len(impreciseObsvList)>0, "Cannot find tainted observation."
  impreciseSignalDict = impreciseObsvList[0]
  print(f"[Init - Tainted Observation] {impreciseSignalDict}")


  ## STEP: When there are multiple choices...
  decisionID = 0
  decisionList = [0 for _ in range(1000)]


  ## STEP: Cannot refine list -> so trace back even input is not observable
  cannotRefineSignals = [
    "uArch.tlMasterXbar_taint.portsAOI_filtered_0_ready",
    "uArch.widget_taint.auto_out_a_ready",
    "uArch.ptw_taint._r_pte_T_23",
    "uArch.frontend_taint.icache_taint.tag_array_0_0",
    "uArch.frontend_taint._tlb_taint_io_resp_pf_inst",
  ]
  

  ## STEP: Loop
  while True:
    print("[Cycle]", impreciseSignalDict["cycle"])


    ## STEP: Get fan in.
    if impreciseSignalDict["name"] in cannotRefineSignals:
      relaventFanIn = getNamedFanIn(
        impreciseSignalDict, netlist.get_allFanIn)
    else:
      relaventFanIn = getNamedFanIn(
        impreciseSignalDict, netlist.get_relaventFanIn)
    print("[All Fan In]", relaventFanIn)


    ## STEP: Filter for imprecise ones
    impreciseRelaventFanIn = list(filter(is_imprecise, relaventFanIn))
    print("[Imprecise Fan In]", impreciseRelaventFanIn)


    ## STEP: Terminate or trace back.
    if len(impreciseRelaventFanIn)==0:
      print("")
      print("********************************************************")
      print("********************** Logic To Refine *****************")
      print("********************************************************")
      netlist.print_logic(impreciseSignalDict["name"], nameMap.hasWaveName, \
                          nameMap.hasTaintName)
      printValue(impreciseSignalDict)
      for s in getNamedFanIn(impreciseSignalDict, netlist.get_allFanIn):
        printValue(s)
      print("********************************************************")
      print(f"Decisions made: {decisionID}")
      print(f"Execution time: real {time.time() - startTime:.2f}")
      return
    
    elif len(impreciseRelaventFanIn)==1:
      impreciseSignalDict = impreciseRelaventFanIn[0]
    
    else:
      if decisionID >= len(decisionList):
        print("[Input] Please enter the index of the signal that you wish to",
              "conitnue the back tracing: ")
        impreciseSignalDict = impreciseRelaventFanIn[int(input())]
        decisionID += 1
      else:
        impreciseSignalDict = impreciseRelaventFanIn[decisionList[decisionID]]
        decisionID += 1
  
  netlist.close()

