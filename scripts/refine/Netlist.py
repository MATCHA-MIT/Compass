
import os, select, subprocess


class Netlist:
  def __init__(self, SRC_FOLDER_NAME):
    projectFolder = f"src/{SRC_FOLDER_NAME}/temp/traceback.jgproject"
    
    ## STEP: Delete old project folder.
    subprocess.run(["rm", "-rf", projectFolder])
    
    ## STEP: Launch Jasper Gold.
    print("Launching JasperGold...")
    self.p = subprocess.Popen(
      ["jg", "-no_gui", "-proj", projectFolder],
      stdin=subprocess.PIPE,
      stdout=subprocess.PIPE,
      stderr=subprocess.PIPE
    )
    os.set_blocking(self.p.stdout.fileno(), False)
    self.waitPrompt()
    
    ## STEP: Restore design saved.
    self.sendCmd(f"restore -elaborated_design src/{SRC_FOLDER_NAME}/temp/my_design\n")
    self.waitPrompt()
    self.sendCmd(f"restore -dir src/{SRC_FOLDER_NAME}/temp/my_db -db\n")
    self.waitPrompt()
    self.sendCmd(f"visualize -violation -property <embedded>::property:0 -batch\n")
    self.waitPrompt()
    print("   ...JasperGold Launched")


  def sendCmd(self, cmd):
    # print("[cmd]", cmd)
    self.p.stdin.write(cmd.encode("utf-8"))
    self.p.stdin.flush()


  def waitPrompt(self):
    out = b""

    while True:
      ready, _, _ = select.select([self.p.stdout], [], [], 1.0)
      if len(ready) > 0:
        chunk = self.p.stdout.read()
        # print("[out]", chunk)
        out += chunk
      if out.endswith(b"% "):
        break

    return out.decode("utf-8")




  ## PUBLIC:
  def is_reg(self, signal):
    self.sendCmd(f"get_signal_info -logic {signal}\n")
    type = self.waitPrompt().split("\n")[0]
    assert type in ["wire", "flop"], "Unrecognized signal type."
    return type=="flop"


  ## TODO: We currently do not consider which bits of a signal being used.
  #        This might have problem with 1 taint bit per bit.
  def get_relaventFanIn(self, signal, cycle):
    self.sendCmd(f"visualize -why {signal} {cycle}\n")
    lastLine = self.waitPrompt().split("\n")[-2]

    if lastLine=="":
      return []

    def rename(signal):
      assert signal[0]=="{", "Incorrect signal format."
      signal = signal[1:].split(" ")[0]
      name = signal
      if name[0]=="{" and name[-1]=="}":
        name = name[1:-1]
        assert name[-1]=="]", "Unexpected signal format."
        name = name.split("[")[0]
        # print(f"[Naming - Drop Bit Selection] {signal} -> {name}")
      return name
    
    fanIn = lastLine.split(" ")[::2]
    fanIn = list(map(rename, fanIn))
    fanIn = [e for e in fanIn if "reset" not in e]

    return fanIn
  

  def get_allFanIn(self, signal, cycle=None):
    self.sendCmd(f"get_fanin {signal}\n")
    rawText = self.waitPrompt().split("\n")
    if len(rawText) < 2:
      fanIn = []
    else:
      fanIn = rawText[0].split(" ")
    
    if "rst" in fanIn:
      fanIn.remove("rst")
    
    def rename(signal):
      name = signal
      if name[0]=="{" and name[-1]=="}":
        name = name[1:-1]
        assert name[-1]=="]", "Unexpected signal format."
        name = name.split("[")[0]
        # print(f"[Naming - Drop Bit Selection] {signal} -> {name}")
      return name

    fanIn = list(map(rename, fanIn))
    fanIn = [e for e in fanIn if "reset" not in e]

    return fanIn


  def print_logic(self, signal, hasWaveName, hasTaintName):
    def recureFunc(signal, depth):
      # assert depth>0, f"Fail to replace all temporal signals within" + \
      #                 f"5 iterations."
      if depth==0:
        return
      
      self.sendCmd(f"get_fanin -show_expr {signal}\n")
      print(f"{signal} =", self.waitPrompt().split("\n")[0])
      
      for s in self.get_allFanIn(signal):
        if not (hasWaveName(s) and hasTaintName(s)):
          recureFunc(s, depth-1)

    recureFunc(signal, 5)


  def close(self):
    self.sendCmd("exit\n")
    return self.p.wait()

