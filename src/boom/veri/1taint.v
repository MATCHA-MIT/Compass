

config cfg;
  design veri_1taint;
  instance veri_1taint.uArch    liblist uArchLib;
  instance veri_1taint.ISATaint liblist ISATaintLib;
endconfig


// NOTE: Enable these macro in .tcl.
// `define CONCRETE_RUN


`define robAddrSz 4
`define robAddrSz4


module veri_1taint(
  input clk,
  input rst
);
  genvar p;




  // STEP: Instantiate 2 ISA/uArch for self-composition.
  BoomTile uArch(.clock(clk), .reset(rst),
    .auto_buffer_out_a_ready_taint(1'h0),
    .auto_buffer_out_a_ready(1'h0),
    .auto_buffer_out_b_valid_taint(1'h0),
    .auto_buffer_out_b_valid(1'h0),
    .auto_buffer_out_b_bits_opcode_taint(1'h0),
    .auto_buffer_out_b_bits_opcode(3'h0),
    .auto_buffer_out_b_bits_param_taint(1'h0),
    .auto_buffer_out_b_bits_param(2'h0),
    .auto_buffer_out_b_bits_size_taint(1'h0),
    .auto_buffer_out_b_bits_size(4'h0),
    .auto_buffer_out_b_bits_source_taint(1'h0),
    .auto_buffer_out_b_bits_source(3'h0),
    .auto_buffer_out_b_bits_address_taint(1'h0),
    .auto_buffer_out_b_bits_address(32'h0),
    .auto_buffer_out_b_bits_mask_taint(1'h0),
    .auto_buffer_out_b_bits_mask(8'h0),
    .auto_buffer_out_b_bits_data_taint(1'h0),
    .auto_buffer_out_b_bits_data(64'h0),
    .auto_buffer_out_b_bits_corrupt_taint(1'h0),
    .auto_buffer_out_b_bits_corrupt(1'h0),
    .auto_buffer_out_c_ready_taint(1'h0),
    .auto_buffer_out_c_ready(1'h0),
    .auto_buffer_out_d_valid_taint(1'h0),
    .auto_buffer_out_d_valid(1'h0),
    .auto_buffer_out_d_bits_opcode_taint(1'h0),
    .auto_buffer_out_d_bits_opcode(3'h0),
    .auto_buffer_out_d_bits_param_taint(1'h0),
    .auto_buffer_out_d_bits_param(2'h0),
    .auto_buffer_out_d_bits_size_taint(1'h0),
    .auto_buffer_out_d_bits_size(4'h0),
    .auto_buffer_out_d_bits_source_taint(1'h0),
    .auto_buffer_out_d_bits_source(3'h0),
    .auto_buffer_out_d_bits_sink_taint(1'h0),
    .auto_buffer_out_d_bits_sink(3'h0),
    .auto_buffer_out_d_bits_denied_taint(1'h0),
    .auto_buffer_out_d_bits_denied(1'h0),
    .auto_buffer_out_d_bits_data_taint(1'h0),
    .auto_buffer_out_d_bits_data(64'h0),
    .auto_buffer_out_d_bits_corrupt_taint(1'h0),
    .auto_buffer_out_d_bits_corrupt(1'h0),
    .auto_buffer_out_e_ready_taint(1'h0),
    .auto_buffer_out_e_ready(1'h0),
    .auto_int_local_in_3_0_taint(1'h0),
    .auto_int_local_in_3_0(1'h0),
    .auto_int_local_in_2_0_taint(1'h0),
    .auto_int_local_in_2_0(1'h0),
    .auto_int_local_in_1_0_taint(1'h0),
    .auto_int_local_in_1_0(1'h0),
    .auto_int_local_in_1_1_taint(1'h0),
    .auto_int_local_in_1_1(1'h0),
    .auto_int_local_in_0_0_taint(1'h0),
    .auto_int_local_in_0_0(1'h0),
    .auto_reset_vector_in_taint(1'h0),
    .auto_reset_vector_in(32'h80000000),
    .auto_hartid_in_taint(1'h0),
    .auto_hartid_in(1'h0)
  );
`ifdef robAddrSz4
  wire [15:0][39:0] my_ROB_memaddr = {
    {uArch.lsu_taint.my_ROB_memaddr_15}, {uArch.lsu_taint.my_ROB_memaddr_14}, {uArch.lsu_taint.my_ROB_memaddr_13}, {uArch.lsu_taint.my_ROB_memaddr_12},
    {uArch.lsu_taint.my_ROB_memaddr_11}, {uArch.lsu_taint.my_ROB_memaddr_10}, {uArch.lsu_taint.my_ROB_memaddr_9} , {uArch.lsu_taint.my_ROB_memaddr_8} ,
    {uArch.lsu_taint.my_ROB_memaddr_7} , {uArch.lsu_taint.my_ROB_memaddr_6} , {uArch.lsu_taint.my_ROB_memaddr_5} , {uArch.lsu_taint.my_ROB_memaddr_4} ,
    {uArch.lsu_taint.my_ROB_memaddr_3} , {uArch.lsu_taint.my_ROB_memaddr_2} , {uArch.lsu_taint.my_ROB_memaddr_1} , {uArch.lsu_taint.my_ROB_memaddr_0}};
`endif
  ISATaint ISATaint(.clock(clk), .reset(rst),
    .io_commit(uArch.core_taint.rob_taint.my_commit_valid),
    .io_inst(uArch.core_taint.rob_taint.my_commit_inst),
    .io_memaddr(my_ROB_memaddr[uArch.core_taint.rob_taint.my_ROB_head])
  );




  // STEP: Concrete initial state.
  // NOTE: This is for concrete simulation to identify source of imprecision.
`ifdef CONCRETE_RUN
  `include "src/boom/temp/concrete_state.v"
`else
  wire concrete_state = 1'b1;
`endif
  wire concrete_init_state = init? concrete_state: 1'h1;




  // STEP: Simplification
  wire simplification = ISATaint.simplificationAssumption;




  // STEP: Indicate init state.
  reg init;
  always @(posedge clk)
    if (rst)
      init <= 1'h1;
    else
      init <= 1'h0;




  // STEP: Tainted init secret memd
  // NOTE: Memory[-1] is secret.
  wire tainted_secmemd =
    ISATaint.memd_taint_ext.Memory[56]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[57]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[58]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[59]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[60]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[61]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[62]==1'h1 &&
    ISATaint.memd_taint_ext.Memory[63]==1'h1 &&
    uArch.dcache_taint.data_taint.array_0_0_15_0_taint==1'h1;
  wire tainted_init_secmemd = init? tainted_secmemd: 1'h1;




  // STEP: Shadow Logic to finish Phase1, i.e., uArch observation tained
  reg uArch_obsv_tainted;
  wire uArch_obsv_taint = uArch.core_taint.rob_taint.my_commit_valid_taint ||
                          uArch.my_mem_addr_taint;
  reg  [`robAddrSz-1:0] ROB_tail;
  wire [`robAddrSz-1:0] ROB_next_tail;
  assign ROB_next_tail =
    (uArch.core_taint.rob_taint.my_ROB_squash &&
     (  uArch.core_taint.rob_taint.my_ROB_squash_tail
        - uArch.core_taint.rob_taint.my_ROB_head
      < ROB_tail
        - uArch.core_taint.rob_taint.my_ROB_head))?
    uArch.core_taint.rob_taint.my_ROB_squash_tail : ROB_tail;
  
  always @(posedge clk)
    if (rst) begin
      uArch_obsv_tainted <= 0;
      ROB_tail <= 0;
    end

    else if (!uArch_obsv_tainted) begin
      if (uArch_obsv_taint) begin
        uArch_obsv_tainted <= 1'h1;
        ROB_tail <= ROB_next_tail;
      end

      else begin
        ROB_tail <= uArch.core_taint.rob_taint.my_ROB_tail;
      end
    end

    else begin
      ROB_tail <= ROB_next_tail;
    end




  // STEP: Shadow Logic to finish Phase2, i.e., pipeline drained
  reg drained;
  always @(posedge clk)
    if (rst) begin
      drained <= 0;
    end

    else if (uArch_obsv_tainted) begin
      if (uArch.core_taint.rob_taint.my_commit_valid &&
          uArch.core_taint.rob_taint.my_ROB_head==(ROB_next_tail-1)
          || uArch.core_taint.rob_taint.my_ROB_head==ROB_next_tail)
        drained <= 1'h1;
    end




  // STEP: contract assumption
  wire contract_assumption = ISATaint.my_commit_data_taint==1'h0;




  // STEP: leakage assertion
  wire leakage_assertion = !(uArch_obsv_tainted && drained);

endmodule

