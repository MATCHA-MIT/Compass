
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
  SodorInternalTile uArch(.clock(clk), .reset(rst),
    
    .io_debug_port_req_valid_taint(1'h0),
    .io_debug_port_req_valid(1'h0),
    .io_debug_port_req_bits_addr_taint(1'h0),
    .io_debug_port_req_bits_addr(32'h0),
    .io_debug_port_req_bits_data_taint(1'h0),
    .io_debug_port_req_bits_data(32'h0),
    .io_debug_port_req_bits_fcn_taint(1'h0),
    .io_debug_port_req_bits_fcn(1'h0),
    .io_debug_port_req_bits_typ_taint(1'h0),
    .io_debug_port_req_bits_typ(3'h0),
    
    .io_master_port_0_req_ready_taint(1'h0),
    .io_master_port_0_req_ready(1'h0),
    .io_master_port_0_resp_valid_taint(1'h0),
    .io_master_port_0_resp_valid(1'h0),
    .io_master_port_0_resp_bits_data_taint(1'h0),
    .io_master_port_0_resp_bits_data(32'h0),
    .io_master_port_1_req_ready_taint(1'h0),
    .io_master_port_1_req_ready(1'h0),
    .io_master_port_1_resp_valid_taint(1'h0),
    .io_master_port_1_resp_valid(1'h0),
    .io_master_port_1_resp_bits_data_taint(1'h0),
    .io_master_port_1_resp_bits_data(32'h0),
    
    .io_interrupt_debug_taint(1'h0),
    .io_interrupt_debug(1'h0),
    .io_interrupt_mtip_taint(1'h0),
    .io_interrupt_mtip(1'h0),
    .io_interrupt_msip_taint(1'h0),
    .io_interrupt_msip(1'h0),
    .io_interrupt_meip_taint(1'h0),
    .io_interrupt_meip(1'h0),
    .io_hartid_taint(1'h0),
    .io_hartid(1'h0),
    .io_reset_vector_taint(1'h0),
    .io_reset_vector(32'h80000000)
  );
  ISATaint ISATaint(.clock(clk), .reset(rst),
    .io_commit(uArch.core_taint.d_taint.my_commit_valid),
    .io_inst(uArch.core_taint.d_taint.my_commit_inst),
    .io_memaddr(uArch.core_taint.d_taint.my_commit_memaddr)
  );




  // STEP: Concrete initial state.
  // NOTE: This is for concrete simulation to identify source of imprecision.
`ifdef CONCRETE_RUN
  `include "src/sodor2/temp/concrete_state.v"
`else
  wire concrete_state = 1'b1;
`endif
  wire concrete_init_state = init? concrete_state: 1'h1;




  // STEP: Simplification
  wire simplification = 
    // Only use supported instructions
    ISATaint.simplificationAssumption &&

    // Avoid any commands that will use CSR, including some exception
    uArch.core_taint.my_csr_cmd == 3'h0 &&

    // Separate instruction and data memory
    (uArch.core_taint.my_imem_valid? uArch.core_taint.my_imem_addr[31:6] == 26'h2000000 : 1'b1) &&
    (uArch.core_taint.my_dmem_valid? uArch.core_taint.my_dmem_addr[31:6] == 26'h2000004 : 1'b1)
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
    ISATaint.memd_taint_ext.Memory[60]==1'h1 && uArch.memory_taint.mem_79_3_taint==1'h1 &&
    ISATaint.memd_taint_ext.Memory[61]==1'h1 && uArch.memory_taint.mem_79_2_taint==1'h1 &&
    ISATaint.memd_taint_ext.Memory[62]==1'h1 && uArch.memory_taint.mem_79_1_taint==1'h1 &&
    ISATaint.memd_taint_ext.Memory[63]==1'h1 && uArch.memory_taint.mem_79_0_taint==1'h1;
  wire tainted_init_secmemd = init? tainted_secmemd: 1'h1;




  // STEP: Shadow Logic to finish Phase1, i.e., uArch observation tained
  reg uArch_obsv_tainted;
  wire uArch_obsv_taint =
    uArch.core_taint.d_taint.my_commit_valid_taint ||
    uArch.core_taint.my_imem_valid_taint ||
    uArch.core_taint.my_imem_valid && uArch.core_taint.my_imem_addr_taint ||
    uArch.core_taint.my_dmem_valid_taint ||
    uArch.core_taint.my_dmem_valid && uArch.core_taint.my_dmem_addr_taint;
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
  // NOTE: Our sodor2 constantly takes 1 cycle to drain.
  reg [2:0] draining_countdown;
  wire drained = draining_countdown==0;
  always @(posedge clk)
    if (rst)
      draining_countdown <= 3'h1;
    else if (uArch_obsv_tainted && draining_countdown!=0)
      draining_countdown <= draining_countdown - 1;




  // STEP: contract assumption
  wire contract_assumption = ISATaint.my_commit_data_taint==1'h0;




  // STEP: leakage assertion
  wire leakage_assertion = !(uArch_obsv_tainted && drained);

endmodule

