package ISATaint

import chisel3._
import chisel3.util._
import _root_.circt.stage.ChiselStage

import Instructions.{IType, I32Type}


class ISATaintIo extends Bundle {
  val commit = Input(Bool())
  val inst = Input(UInt(32.W))
  val memaddr = Input(UInt(32.W))
}


class ISATaint(
  memdSize: Int = 16 * 4
) extends Module {

  // PART: IO
  val io = IO(new ISATaintIo())


  // PART: Architecte state
  val pc_taint      = Reg(Bool())
  val regfile_taint = Mem(32, Bool())
  val memd_taint    = Mem(memdSize, Bool())
  dontTouch(pc_taint)


  // PART: Fetch: use functionality date from uArch. 
  val inst = io.inst
  

  // PART: Decode
  val rs1 = inst(19, 15)
  val rs2 = inst(24, 20)
  val rd  = inst(11,  7)

  val immI = Cat(Fill(20, inst(31)), inst(31, 20))
  val immS = Cat(Fill(20, inst(31)), inst(31, 25), inst(11,7))
  val immB = Cat(Fill(20, inst(31)), inst(7), inst(30,25), inst(11,8), 0.U)
  val immU = Cat(                    inst(31, 12), Fill(12,0.U))
  val immJ = Cat(Fill(12, inst(31)), inst(19,12), inst(20), inst(30,21), 0.U)


  // PART: Extracted Signals
  // NOTE: pc_taint will be excluded from any taint propagation. Instead, it
  //       be propagated directly to these extracted signals (as well as pc
  //       itself).
  val simplification_legalInst = Wire(Bool())
  simplification_legalInst := true.B


  
  val my_commit_data_taint    = Wire(UInt())
  val my_commit_memaddr_taint = Wire(UInt())
  val simplificationAssumption   = Wire(Bool())
  dontTouch(my_commit_data_taint)
  dontTouch(my_commit_memaddr_taint)
  dontTouch(simplificationAssumption)
  my_commit_data_taint    := pc_taint
  my_commit_memaddr_taint := pc_taint
  simplificationAssumption := simplification_legalInst



  // PART: Execute and commit
  def rfRead_taint(rs : UInt) = Mux(rs===0.U, false.B, regfile_taint(rs))
  def rfWrite_taint(rd : UInt, data_taint : Bool) = {
    when (rd=/=0.U) {
      regfile_taint(rd) := data_taint
      my_commit_data_taint := data_taint | pc_taint
    }
  }
  
  when (io.commit) {
    when (inst===IType("LUI")) {
      rfWrite_taint(rd, false.B)
    }


    .elsewhen (inst===IType("AUIPC")) {
      rfWrite_taint(rd, false.B)
    }


    .elsewhen (inst===IType("JAL")) {
      rfWrite_taint(rd, false.B)
    }


    .elsewhen (inst===IType("JALR")) {
      rfWrite_taint(rd, false.B)
      pc_taint := pc_taint | rfRead_taint(rs1)
    }


    .elsewhen (inst===IType("BEQ")) {
      pc_taint := pc_taint | rfRead_taint(rs1) | rfRead_taint(rs2)
    }


    .elsewhen (inst===IType("BNE")) {
      pc_taint := pc_taint | rfRead_taint(rs1) | rfRead_taint(rs2)
    }


    .elsewhen (inst===IType("BLT")) {
      pc_taint := pc_taint | rfRead_taint(rs1) | rfRead_taint(rs2)
    }


    .elsewhen (inst===IType("BGE")) {
      pc_taint := pc_taint | rfRead_taint(rs1) | rfRead_taint(rs2)
    }


    .elsewhen (inst===IType("BLTU")) {
      pc_taint := pc_taint | rfRead_taint(rs1) | rfRead_taint(rs2)
    }


    .elsewhen (inst===IType("BGEU")) {
      pc_taint := pc_taint | rfRead_taint(rs1) | rfRead_taint(rs2)
    }


    .elsewhen (inst===IType("LW")) {
      val addr = io.memaddr
      val addr_taint = rfRead_taint(rs1)
      rfWrite_taint(rd, addr_taint | memd_taint(addr+3.U) | memd_taint(addr+2.U)
                                   | memd_taint(addr+1.U) | memd_taint(addr))

      my_commit_memaddr_taint := addr_taint | pc_taint
    }


    .elsewhen (inst===IType("SW")) {
      val addr = io.memaddr
      val addr_taint = rfRead_taint(rs1)
      val data_taint = rfRead_taint(rs2)

      when (addr_taint) {
        // NOTE: We do a short cut here. If store address is tainted, we
        //       directly taint pc.
        pc_taint := true.B
      }
      .otherwise {
        memd_taint(addr+3.U) := data_taint
        memd_taint(addr+2.U) := data_taint
        memd_taint(addr+1.U) := data_taint
        memd_taint(addr)     := data_taint
      }

      my_commit_memaddr_taint := addr_taint | pc_taint
    }


    .elsewhen (inst===IType("ADDI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===IType("SLTI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===IType("SLTIU")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===IType("XORI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===IType("ORI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===IType("ANDI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===I32Type("SLLI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===I32Type("SRLI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===I32Type("SRAI")) {
      rfWrite_taint(rd, rfRead_taint(rs1))
    }


    .elsewhen (inst===IType("ADD")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("SUB")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("SLL")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("SLT")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("SLTU")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("XOR")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("SRL")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("SRA")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("OR")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .elsewhen (inst===IType("AND")) {
      rfWrite_taint(rd, rfRead_taint(rs1) | rfRead_taint(rs2))
    }


    .otherwise {
      simplification_legalInst := false.B
    }
  }
}


object ISATaint extends App {
  ChiselStage.emitSystemVerilog(new ISATaint(), firtoolOpts = Array(
    "-disable-all-randomization",
    "-split-verilog",
    "-o", "verilog"
  ))
}

