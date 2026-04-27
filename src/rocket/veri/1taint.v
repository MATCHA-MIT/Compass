
config cfg;
    design veri_1taint;
    instance veri_1taint.uArch    liblist uArchLib;
    instance veri_1taint.ISATaint liblist ISATaintLib;
endconfig


// NOTE: Enable macro in .tcl.
// `define CONCRETE_RUN


module veri_1taint(
  input clk,
  input rst
);
  
  // STEP: Instantiate uArch and ISATaint.
  RocketTile uArch(.clock(clk), .reset(rst),

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
    .auto_buffer_out_b_bits_source(2'h0),
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
    .auto_buffer_out_d_bits_source(2'h0),
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
  ISATaint ISATaint(.clock(clk), .reset(rst),
    .io_commit(uArch.core_taint.my_commit_valid),
    .io_inst(uArch.core_taint.my_commit_inst),
    .io_memaddr(uArch.core_taint.my_commit_memaddr)
  );




  // STEP: Concrete initial state.
  // NOTE: This is for concrete simulation to identify source of imprecision.
`ifdef CONCRETE_RUN
  `include "src/rocket/temp/concrete_state.v"
`else
  wire concrete_state = 1'b1;
`endif
  wire concrete_init_state = init? concrete_state: 1'h1;




  // STEP: Simplification
  wire simplification =
    ISATaint.simplificationAssumption &&
    (uArch.frontend_taint.icache_taint.my_icache_valid? uArch.frontend_taint.icache_taint.my_icache_addr[32:6] == 27'h2000000 : 1'b1) &&
    (uArch.dcache_taint.my_dcache_valid? uArch.dcache_taint.my_dcache_addr[33:6] == 28'h2000004 : 1'b1)
  ;




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
    uArch.dcache_taint.data_taint.data_arrays_0_7_0_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_1_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_2_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_3_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_4_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_5_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_6_taint==1'h1 &&
    uArch.dcache_taint.data_taint.data_arrays_0_7_7_taint==1'h1;
  wire tainted_init_secmemd = init? tainted_secmemd: 1'h1;




  // STEP: Shadow Logic to finish Phase1, i.e., uArch observation tained
  reg  uArch_obsv_tainted;
  wire uArch_obsv_taint =
    uArch.core_taint.my_commit_valid_taint ||
    uArch.frontend_taint.icache_taint.my_icache_valid_taint ||
    uArch.frontend_taint.icache_taint.my_icache_valid && uArch.frontend_taint.icache_taint.my_icache_addr_taint ||
    uArch.dcache_taint.my_dcache_valid_taint ||
    uArch.dcache_taint.my_dcache_valid && uArch.dcache_taint.my_dcache_addr_taint;
  always @(posedge clk)
    if (rst) begin
      uArch_obsv_tainted <= 0;
    end

    else if (!uArch_obsv_tainted) begin
      if (uArch_obsv_taint) begin
        uArch_obsv_tainted <= 1'h1;
      end
    end




  // STEP: Shadow Logic to finish Phase2, i.e., pipeline drained
  reg [2:0] draining_countdown;
  wire drained = draining_countdown==0;
  always @(posedge clk)
    if (rst)
      draining_countdown <= 3'h4;
    else if (uArch_obsv_tainted && draining_countdown!=0)
      draining_countdown <= draining_countdown - 1;




  // STEP: contract assumption
  wire contract_assumption = ISATaint.my_commit_data_taint==1'h0;



  // STEP: leakage assertion
  wire leakage_assertion = !(uArch_obsv_tainted && drained);

endmodule

