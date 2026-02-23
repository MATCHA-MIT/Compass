package chipyard

import chisel3._

import org.chipsalliance.cde.config.{Config}




class MySodor2StageNaiveConfig extends Config(
  new sodor.common.WithMarkFor("naive") ++
  new MySodor2StageBaseConfig)

class MySodor2StageAutoSandboxConfig extends Config(
  new sodor.common.WithMarkFor("auto_sandbox") ++
  new MySodor2StageBaseConfig)

class MySodor2StageCelliftConfig extends Config(
  new sodor.common.WithMarkFor("cellift") ++
  new MySodor2StageBaseConfig)

class MySodor2StageBaseConfig extends Config(
  // NOTE: For 512B memory, 0-64 is inst, 256-320 is data, we leave some empty
  //       space so that the memory range can be consistent with rocket and boom
  new sodor.common.WithNSodorCores(
    1, internalTile = sodor.common.Stage2Factory, mem_size=512) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)




class Sodor1StageConfig extends Config(
  // Create a Sodor 1-stage core
  new sodor.common.WithNSodorCores(1, internalTile = sodor.common.Stage1Factory) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)

class Sodor2StageConfig extends Config(
  // Create a Sodor 2-stage core
  new sodor.common.WithNSodorCores(1, internalTile = sodor.common.Stage2Factory) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)

class Sodor3StageConfig extends Config(
  // Create a Sodor 1-stage core with two ports
  new sodor.common.WithNSodorCores(1, internalTile = sodor.common.Stage3Factory(ports = 2)) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)

class Sodor3StageSinglePortConfig extends Config(
  // Create a Sodor 3-stage core with one ports (instruction and data memory access controlled by arbiter)
  new sodor.common.WithNSodorCores(1, internalTile = sodor.common.Stage3Factory(ports = 1)) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)

class Sodor5StageConfig extends Config(
  // Create a Sodor 5-stage core
  new sodor.common.WithNSodorCores(1, internalTile = sodor.common.Stage5Factory) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)

class SodorUCodeConfig extends Config(
  // Construct a Sodor microcode-based single-bus core
  new sodor.common.WithNSodorCores(1, internalTile = sodor.common.UCodeFactory) ++
  new testchipip.soc.WithNoScratchpads ++                      // No scratchpads
  new testchipip.serdes.WithSerialTLWidth(32) ++
  new freechips.rocketchip.subsystem.WithScratchpadsOnly ++    // use sodor tile-internal scratchpad
  new freechips.rocketchip.subsystem.WithNoMemPort ++          // use no external memory
  new freechips.rocketchip.subsystem.WithNBanks(0) ++
  new chipyard.config.AbstractConfig)
