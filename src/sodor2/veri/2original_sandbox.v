
config cfg;
    design veri_2original_sandbox;
    instance veri_2original_sandbox.uArch_1 liblist uArchLib;
    instance veri_2original_sandbox.uArch_2 liblist uArchLib;
endconfig


module veri_2original_sandbox(
  input clk,
  input rst
);

  // STEP: Instantiate 2 uArch.
  SodorInternalTile uArch_1(
    .clock(stall_1? 0: clk),
    .reset(rst),
    .io_debug_port_req_valid(1'h0),
    .io_debug_port_req_bits_addr(32'h0),
    .io_debug_port_req_bits_data(32'h0),
    .io_debug_port_req_bits_fcn(1'h0),
    .io_debug_port_req_bits_typ(3'h0),
    .io_master_port_0_req_ready(1'h0),
    .io_master_port_0_resp_valid(1'h0),
    .io_master_port_0_resp_bits_data(32'h0),
    .io_master_port_1_req_ready(1'h0),
    .io_master_port_1_resp_valid(1'h0),
    .io_master_port_1_resp_bits_data(32'h0),
    .io_interrupt_debug(1'h0),
    .io_interrupt_mtip(1'h0),
    .io_interrupt_msip(1'h0),
    .io_interrupt_meip(1'h0),
    .io_hartid(1'h0),
    .io_reset_vector(32'h80000000)
  );
  SodorInternalTile uArch_2(
    .clock(stall_2? 0: clk),
    .reset(rst),
    .io_debug_port_req_valid(1'h0),
    .io_debug_port_req_bits_addr(32'h0),
    .io_debug_port_req_bits_data(32'h0),
    .io_debug_port_req_bits_fcn(1'h0),
    .io_debug_port_req_bits_typ(3'h0),
    .io_master_port_0_req_ready(1'h0),
    .io_master_port_0_resp_valid(1'h0),
    .io_master_port_0_resp_bits_data(32'h0),
    .io_master_port_1_req_ready(1'h0),
    .io_master_port_1_resp_valid(1'h0),
    .io_master_port_1_resp_bits_data(32'h0),
    .io_interrupt_debug(1'h0),
    .io_interrupt_mtip(1'h0),
    .io_interrupt_msip(1'h0),
    .io_interrupt_meip(1'h0),
    .io_hartid(1'h0),
    .io_reset_vector(32'h80000000)
  );




  // STEP: Simplification
  wire simplification =
    // Avoid any commands that will use CSR, including some exception
    uArch_1.core.my_csr_cmd == 3'h0 &&
    uArch_2.core.my_csr_cmd == 3'h0 &&

    // Separate instruction and data memory
    (uArch_1.core.my_imem_valid? uArch_1.core.my_imem_addr[31:6] == 26'h2000000 : 1'b1) &&
    (uArch_2.core.my_imem_valid? uArch_2.core.my_imem_addr[31:6] == 26'h2000000 : 1'b1) &&
    (uArch_1.core.my_dmem_valid? uArch_1.core.my_dmem_addr[31:6] == 26'h2000004 : 1'b1) &&
    (uArch_2.core.my_dmem_valid? uArch_2.core.my_dmem_addr[31:6] == 26'h2000004 : 1'b1)
  ;



  // STEP: Indicate init state.
  reg init;
  always @(posedge clk)
    if (rst)
      init <= 1'h1;
    else
      init <= 1'h0;




  // STEP: Same initial public state (memi & pubmemd).
  // NOTE: Memory[-1] is secret.
  wire same_pubmem =
    uArch_1.memory.mem_0_3 ==uArch_2.memory.mem_0_3  && uArch_1.memory.mem_0_2 ==uArch_2.memory.mem_0_2  && uArch_1.memory.mem_0_1 ==uArch_2.memory.mem_0_1  && uArch_1.memory.mem_0_0 ==uArch_2.memory.mem_0_0  &&
    uArch_1.memory.mem_1_3 ==uArch_2.memory.mem_1_3  && uArch_1.memory.mem_1_2 ==uArch_2.memory.mem_1_2  && uArch_1.memory.mem_1_1 ==uArch_2.memory.mem_1_1  && uArch_1.memory.mem_1_0 ==uArch_2.memory.mem_1_0  &&
    uArch_1.memory.mem_2_3 ==uArch_2.memory.mem_2_3  && uArch_1.memory.mem_2_2 ==uArch_2.memory.mem_2_2  && uArch_1.memory.mem_2_1 ==uArch_2.memory.mem_2_1  && uArch_1.memory.mem_2_0 ==uArch_2.memory.mem_2_0  &&
    uArch_1.memory.mem_3_3 ==uArch_2.memory.mem_3_3  && uArch_1.memory.mem_3_2 ==uArch_2.memory.mem_3_2  && uArch_1.memory.mem_3_1 ==uArch_2.memory.mem_3_1  && uArch_1.memory.mem_3_0 ==uArch_2.memory.mem_3_0  &&
    uArch_1.memory.mem_4_3 ==uArch_2.memory.mem_4_3  && uArch_1.memory.mem_4_2 ==uArch_2.memory.mem_4_2  && uArch_1.memory.mem_4_1 ==uArch_2.memory.mem_4_1  && uArch_1.memory.mem_4_0 ==uArch_2.memory.mem_4_0  &&
    uArch_1.memory.mem_5_3 ==uArch_2.memory.mem_5_3  && uArch_1.memory.mem_5_2 ==uArch_2.memory.mem_5_2  && uArch_1.memory.mem_5_1 ==uArch_2.memory.mem_5_1  && uArch_1.memory.mem_5_0 ==uArch_2.memory.mem_5_0  &&
    uArch_1.memory.mem_6_3 ==uArch_2.memory.mem_6_3  && uArch_1.memory.mem_6_2 ==uArch_2.memory.mem_6_2  && uArch_1.memory.mem_6_1 ==uArch_2.memory.mem_6_1  && uArch_1.memory.mem_6_0 ==uArch_2.memory.mem_6_0  &&
    uArch_1.memory.mem_7_3 ==uArch_2.memory.mem_7_3  && uArch_1.memory.mem_7_2 ==uArch_2.memory.mem_7_2  && uArch_1.memory.mem_7_1 ==uArch_2.memory.mem_7_1  && uArch_1.memory.mem_7_0 ==uArch_2.memory.mem_7_0  &&
    uArch_1.memory.mem_8_3 ==uArch_2.memory.mem_8_3  && uArch_1.memory.mem_8_2 ==uArch_2.memory.mem_8_2  && uArch_1.memory.mem_8_1 ==uArch_2.memory.mem_8_1  && uArch_1.memory.mem_8_0 ==uArch_2.memory.mem_8_0  &&
    uArch_1.memory.mem_9_3 ==uArch_2.memory.mem_9_3  && uArch_1.memory.mem_9_2 ==uArch_2.memory.mem_9_2  && uArch_1.memory.mem_9_1 ==uArch_2.memory.mem_9_1  && uArch_1.memory.mem_9_0 ==uArch_2.memory.mem_9_0  &&
    uArch_1.memory.mem_10_3==uArch_2.memory.mem_10_3 && uArch_1.memory.mem_10_2==uArch_2.memory.mem_10_2 && uArch_1.memory.mem_10_1==uArch_2.memory.mem_10_1 && uArch_1.memory.mem_10_0==uArch_2.memory.mem_10_0 &&
    uArch_1.memory.mem_11_3==uArch_2.memory.mem_11_3 && uArch_1.memory.mem_11_2==uArch_2.memory.mem_11_2 && uArch_1.memory.mem_11_1==uArch_2.memory.mem_11_1 && uArch_1.memory.mem_11_0==uArch_2.memory.mem_11_0 &&
    uArch_1.memory.mem_12_3==uArch_2.memory.mem_12_3 && uArch_1.memory.mem_12_2==uArch_2.memory.mem_12_2 && uArch_1.memory.mem_12_1==uArch_2.memory.mem_12_1 && uArch_1.memory.mem_12_0==uArch_2.memory.mem_12_0 &&
    uArch_1.memory.mem_13_3==uArch_2.memory.mem_13_3 && uArch_1.memory.mem_13_2==uArch_2.memory.mem_13_2 && uArch_1.memory.mem_13_1==uArch_2.memory.mem_13_1 && uArch_1.memory.mem_13_0==uArch_2.memory.mem_13_0 &&
    uArch_1.memory.mem_14_3==uArch_2.memory.mem_14_3 && uArch_1.memory.mem_14_2==uArch_2.memory.mem_14_2 && uArch_1.memory.mem_14_1==uArch_2.memory.mem_14_1 && uArch_1.memory.mem_14_0==uArch_2.memory.mem_14_0 &&
    uArch_1.memory.mem_15_3==uArch_2.memory.mem_15_3 && uArch_1.memory.mem_15_2==uArch_2.memory.mem_15_2 && uArch_1.memory.mem_15_1==uArch_2.memory.mem_15_1 && uArch_1.memory.mem_15_0==uArch_2.memory.mem_15_0 &&

    uArch_1.memory.mem_64_3==uArch_2.memory.mem_64_3 && uArch_1.memory.mem_64_2==uArch_2.memory.mem_64_2 && uArch_1.memory.mem_64_1==uArch_2.memory.mem_64_1 && uArch_1.memory.mem_64_0==uArch_2.memory.mem_64_0 &&
    uArch_1.memory.mem_65_3==uArch_2.memory.mem_65_3 && uArch_1.memory.mem_65_2==uArch_2.memory.mem_65_2 && uArch_1.memory.mem_65_1==uArch_2.memory.mem_65_1 && uArch_1.memory.mem_65_0==uArch_2.memory.mem_65_0 &&
    uArch_1.memory.mem_66_3==uArch_2.memory.mem_66_3 && uArch_1.memory.mem_66_2==uArch_2.memory.mem_66_2 && uArch_1.memory.mem_66_1==uArch_2.memory.mem_66_1 && uArch_1.memory.mem_66_0==uArch_2.memory.mem_66_0 &&
    uArch_1.memory.mem_67_3==uArch_2.memory.mem_67_3 && uArch_1.memory.mem_67_2==uArch_2.memory.mem_67_2 && uArch_1.memory.mem_67_1==uArch_2.memory.mem_67_1 && uArch_1.memory.mem_67_0==uArch_2.memory.mem_67_0 &&
    uArch_1.memory.mem_68_3==uArch_2.memory.mem_68_3 && uArch_1.memory.mem_68_2==uArch_2.memory.mem_68_2 && uArch_1.memory.mem_68_1==uArch_2.memory.mem_68_1 && uArch_1.memory.mem_68_0==uArch_2.memory.mem_68_0 &&
    uArch_1.memory.mem_69_3==uArch_2.memory.mem_69_3 && uArch_1.memory.mem_69_2==uArch_2.memory.mem_69_2 && uArch_1.memory.mem_69_1==uArch_2.memory.mem_69_1 && uArch_1.memory.mem_69_0==uArch_2.memory.mem_69_0 &&
    uArch_1.memory.mem_70_3==uArch_2.memory.mem_70_3 && uArch_1.memory.mem_70_2==uArch_2.memory.mem_70_2 && uArch_1.memory.mem_70_1==uArch_2.memory.mem_70_1 && uArch_1.memory.mem_70_0==uArch_2.memory.mem_70_0 &&
    uArch_1.memory.mem_71_3==uArch_2.memory.mem_71_3 && uArch_1.memory.mem_71_2==uArch_2.memory.mem_71_2 && uArch_1.memory.mem_71_1==uArch_2.memory.mem_71_1 && uArch_1.memory.mem_71_0==uArch_2.memory.mem_71_0 &&
    uArch_1.memory.mem_72_3==uArch_2.memory.mem_72_3 && uArch_1.memory.mem_72_2==uArch_2.memory.mem_72_2 && uArch_1.memory.mem_72_1==uArch_2.memory.mem_72_1 && uArch_1.memory.mem_72_0==uArch_2.memory.mem_72_0 &&
    uArch_1.memory.mem_73_3==uArch_2.memory.mem_73_3 && uArch_1.memory.mem_73_2==uArch_2.memory.mem_73_2 && uArch_1.memory.mem_73_1==uArch_2.memory.mem_73_1 && uArch_1.memory.mem_73_0==uArch_2.memory.mem_73_0 &&
    uArch_1.memory.mem_74_3==uArch_2.memory.mem_74_3 && uArch_1.memory.mem_74_2==uArch_2.memory.mem_74_2 && uArch_1.memory.mem_74_1==uArch_2.memory.mem_74_1 && uArch_1.memory.mem_74_0==uArch_2.memory.mem_74_0 &&
    uArch_1.memory.mem_75_3==uArch_2.memory.mem_75_3 && uArch_1.memory.mem_75_2==uArch_2.memory.mem_75_2 && uArch_1.memory.mem_75_1==uArch_2.memory.mem_75_1 && uArch_1.memory.mem_75_0==uArch_2.memory.mem_75_0 &&
    uArch_1.memory.mem_76_3==uArch_2.memory.mem_76_3 && uArch_1.memory.mem_76_2==uArch_2.memory.mem_76_2 && uArch_1.memory.mem_76_1==uArch_2.memory.mem_76_1 && uArch_1.memory.mem_76_0==uArch_2.memory.mem_76_0 &&
    uArch_1.memory.mem_77_3==uArch_2.memory.mem_77_3 && uArch_1.memory.mem_77_2==uArch_2.memory.mem_77_2 && uArch_1.memory.mem_77_1==uArch_2.memory.mem_77_1 && uArch_1.memory.mem_77_0==uArch_2.memory.mem_77_0 &&
    uArch_1.memory.mem_78_3==uArch_2.memory.mem_78_3 && uArch_1.memory.mem_78_2==uArch_2.memory.mem_78_2 && uArch_1.memory.mem_78_1==uArch_2.memory.mem_78_1 && uArch_1.memory.mem_78_0==uArch_2.memory.mem_78_0;
  wire same_init_pubstate = init? same_pubmem: 1'h1;




  // STEP: Shadow Logic to finish Phase1, i.e., uArch deviation found
  reg deviation_found;
  wire deviation =
    uArch_1.core.d.my_commit_valid!=uArch_2.core.d.my_commit_valid ||
    uArch_1.core.my_imem_valid!=uArch_2.core.my_imem_valid ||
    uArch_1.core.my_imem_valid && uArch_2.core.my_imem_valid && uArch_1.core.my_imem_addr!=uArch_2.core.my_imem_addr ||
    uArch_1.core.my_dmem_valid!=uArch_2.core.my_dmem_valid ||
    uArch_1.core.my_dmem_valid && uArch_2.core.my_dmem_valid && uArch_1.core.my_dmem_addr!=uArch_2.core.my_dmem_addr;
  always @(posedge clk)
    if (rst) begin
      deviation_found <= 0;
    end

    else if (!deviation_found) begin
      if (deviation) begin
        deviation_found <= 1'h1;
      end
    end




  // STEP: Synchronized simulation (in Phase2)
  reg ISA_just_compared, stall_1, stall_2;
  always @(posedge clk)
    if (rst) begin
      ISA_just_compared <= 0;
      stall_1 <= 0;
      stall_2 <= 0;
    end

    else begin

      // STEP.1: No stall.
      if (!stall_1 && !stall_2) begin
        if ( uArch_1.core.d.my_commit_valid &&  uArch_2.core.d.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
        end
        
        if ( uArch_1.core.d.my_commit_valid && !uArch_2.core.d.my_commit_valid) begin
          ISA_just_compared <= 1'h0;
          stall_1 = 1;
        end
        
        if (!uArch_1.core.d.my_commit_valid &&  uArch_2.core.d.my_commit_valid) begin
          ISA_just_compared <= 1'h0;
          stall_2 = 1;
        end
      end
    
      // STEP.2: Stall uArch_1.
      if ( stall_1 && !stall_2) begin
        if (uArch_2.core.d.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
          stall_1 = 0;
        end
      end
    
      // STEP.3: Stall uArch_2.
      if (!stall_1 &&  stall_2) begin
        if (uArch_1.core.d.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
          stall_2 = 0;
        end
      end
    end




  // STEP: Shadow Logic to finish Phase2, i.e., pipeline drained
  reg drained_1, drained_2;
  always @(posedge clk)
    if (rst) begin
      drained_1 <= 0;
      drained_2 <= 0;
    end

    else if (deviation_found) begin

      // NOTE: Our sodor2 constantly takes 1 cycle to drain.
      if (!stall_1)
        drained_1 <= 1'h1;
      
      if (!stall_2)
        drained_2 <= 1'h1;
    end




  // STEP: contract assumption
  wire contract_assumption =
    (uArch_1.core.d.my_commit_valid && uArch_2.core.d.my_commit_valid)?
      ((uArch_1.core.d.my_commit_wen && uArch_2.core.d.my_commit_wen)?
        uArch_1.core.d.my_commit_data==uArch_2.core.d.my_commit_data :
        1'h1
      ) :
      1'h1;




  // STEP: leakage assertion
  wire leakage_assertion = !(
    deviation_found &&         // STEP.1: Phase1 finished
    drained_1 && drained_2 &&  // STEP.2: Phase2 finished
    ISA_just_compared          // STEP.3: Synchronization finished
  );

endmodule

