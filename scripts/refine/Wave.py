
from vcdvcd import VCDVCD

CLOCK = 10


class Wave:
  def __init__(self, trace_file):
    self.vcd = VCDVCD(trace_file)

  
  ## PUBLIC:
  def get(self, cycle, signal):
    cycle = cycle * CLOCK - int(CLOCK/2)
    return int(self.vcd[signal][cycle], 2)


  def getSignals(self):
    return self.vcd.get_signals()

