//**************************************************************************
// RISCV Processor
//--------------------------------------------------------------------------
//
// Christopher Celio
// 2011 Jul 30
//
// Describes a simple RISCV 2-stage processor
//   - Statically predict pc+4, kill instruction fetch
//   - Single-cycle memory
//   - No div/mul/rem
//   - No FPU
//   - No double-word nor sub-word memory access support

package sodor.stage2

import chisel3._
import chisel3.util._

import sodor.common._

import org.chipsalliance.cde.config.Parameters
import freechips.rocketchip.rocket.CoreInterrupts

class CoreIo(implicit val p: Parameters, val conf: SodorCoreParams) extends Bundle
{
  val imem = new MemPortIo(conf.xprlen)
  val dmem = new MemPortIo(conf.xprlen)
  val ddpath = Flipped(new DebugDPath())
  val dcpath = Flipped(new DebugCPath())
  val interrupt = Input(new CoreInterrupts(false))
  val hartid = Input(UInt())
  val reset_vector = Input(UInt())
}

class Core(implicit val p: Parameters, val conf: SodorCoreParams) extends AbstractCore
{
  val io = IO(new CoreIo())
  val c  = Module(new CtlPath())
  val d  = Module(new DatPath())

  c.io.ctl  <> d.io.ctl
  c.io.dat  <> d.io.dat

  io.imem <> c.io.imem
  io.imem <> d.io.imem

  io.dmem <> c.io.dmem
  io.dmem <> d.io.dmem
  io.dmem.req.valid := c.io.dmem.req.valid
  io.dmem.req.bits.typ := c.io.dmem.req.bits.typ
  io.dmem.req.bits.fcn := c.io.dmem.req.bits.fcn

  d.io.ddpath <> io.ddpath
  c.io.dcpath <> io.dcpath

  d.io.interrupt := io.interrupt
  d.io.hartid := io.hartid
  d.io.reset_vector := io.reset_vector

  val mem_ports = List(io.dmem, io.imem)
  val interrupt = io.interrupt
  val hartid = io.hartid
  val reset_vector = io.reset_vector




  val my_csr_cmd    = Wire(UInt())
  val my_imem_valid = Wire(Bool())
  val my_imem_addr  = Wire(UInt())
  val my_dmem_valid = Wire(Bool())
  val my_dmem_addr  = Wire(UInt())
  
  my_csr_cmd    := c.io.ctl.csr_cmd
  my_imem_valid := io.imem.req.valid
  my_imem_addr  := io.imem.req.bits.addr
  my_dmem_valid := io.dmem.req.valid
  my_dmem_addr  := io.dmem.req.bits.addr
  
  dontTouch(my_csr_cmd)
  dontTouch(my_imem_valid)
  dontTouch(my_imem_addr)
  dontTouch(my_dmem_valid)
  dontTouch(my_dmem_addr)
}
