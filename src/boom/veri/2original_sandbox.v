

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
  BoomTile uArch_1(
    .clock(stall_1? 0: clk),
    .reset(rst),
    .auto_buffer_out_a_ready(1'h0),
    .auto_buffer_out_b_valid(1'h0),
    .auto_buffer_out_b_bits_opcode(3'h0),
    .auto_buffer_out_b_bits_param(2'h0),
    .auto_buffer_out_b_bits_size(4'h0),
    .auto_buffer_out_b_bits_source(3'h0),
    .auto_buffer_out_b_bits_address(32'h0),
    .auto_buffer_out_b_bits_mask(8'h0),
    .auto_buffer_out_b_bits_data(64'h0),
    .auto_buffer_out_b_bits_corrupt(1'h0),
    .auto_buffer_out_c_ready(1'h0),
    .auto_buffer_out_d_valid(1'h0),
    .auto_buffer_out_d_bits_opcode(3'h0),
    .auto_buffer_out_d_bits_param(2'h0),
    .auto_buffer_out_d_bits_size(4'h0),
    .auto_buffer_out_d_bits_source(3'h0),
    .auto_buffer_out_d_bits_sink(3'h0),
    .auto_buffer_out_d_bits_denied(1'h0),
    .auto_buffer_out_d_bits_data(64'h0),
    .auto_buffer_out_d_bits_corrupt(1'h0),
    .auto_buffer_out_e_ready(1'h0),
    .auto_int_local_in_3_0(1'h0),
    .auto_int_local_in_2_0(1'h0),
    .auto_int_local_in_1_0(1'h0),
    .auto_int_local_in_1_1(1'h0),
    .auto_int_local_in_0_0(1'h0),
    .auto_reset_vector_in(32'h80000000),
    .auto_hartid_in(1'h0)
  );
  BoomTile uArch_2(
    .clock(stall_2? 0: clk),
    .reset(rst),
    .auto_buffer_out_a_ready(1'h0),
    .auto_buffer_out_b_valid(1'h0),
    .auto_buffer_out_b_bits_opcode(3'h0),
    .auto_buffer_out_b_bits_param(2'h0),
    .auto_buffer_out_b_bits_size(4'h0),
    .auto_buffer_out_b_bits_source(3'h0),
    .auto_buffer_out_b_bits_address(32'h0),
    .auto_buffer_out_b_bits_mask(8'h0),
    .auto_buffer_out_b_bits_data(64'h0),
    .auto_buffer_out_b_bits_corrupt(1'h0),
    .auto_buffer_out_c_ready(1'h0),
    .auto_buffer_out_d_valid(1'h0),
    .auto_buffer_out_d_bits_opcode(3'h0),
    .auto_buffer_out_d_bits_param(2'h0),
    .auto_buffer_out_d_bits_size(4'h0),
    .auto_buffer_out_d_bits_source(3'h0),
    .auto_buffer_out_d_bits_sink(3'h0),
    .auto_buffer_out_d_bits_denied(1'h0),
    .auto_buffer_out_d_bits_data(64'h0),
    .auto_buffer_out_d_bits_corrupt(1'h0),
    .auto_buffer_out_e_ready(1'h0),
    .auto_int_local_in_3_0(1'h0),
    .auto_int_local_in_2_0(1'h0),
    .auto_int_local_in_1_0(1'h0),
    .auto_int_local_in_1_1(1'h0),
    .auto_int_local_in_0_0(1'h0),
    .auto_reset_vector_in(32'h80000000),
    .auto_hartid_in(1'h0)
  );




  // STEP: Simplification
  wire simplification = 1'h1;



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
    uArch_1.frontend.icache.dataArrayWay_0_0 == uArch_2.frontend.icache.dataArrayWay_0_0 &&
    uArch_1.frontend.icache.dataArrayWay_0_1 == uArch_2.frontend.icache.dataArrayWay_0_1 &&
    uArch_1.frontend.icache.dataArrayWay_0_2 == uArch_2.frontend.icache.dataArrayWay_0_2 &&
    uArch_1.frontend.icache.dataArrayWay_0_3 == uArch_2.frontend.icache.dataArrayWay_0_3 &&
    uArch_1.frontend.icache.dataArrayWay_0_4 == uArch_2.frontend.icache.dataArrayWay_0_4 &&
    uArch_1.frontend.icache.dataArrayWay_0_5 == uArch_2.frontend.icache.dataArrayWay_0_5 &&
    uArch_1.frontend.icache.dataArrayWay_0_6 == uArch_2.frontend.icache.dataArrayWay_0_6 &&
    uArch_1.frontend.icache.dataArrayWay_0_7 == uArch_2.frontend.icache.dataArrayWay_0_7 &&
    uArch_1.dcache.data.array_0_0_8_0        == uArch_2.dcache.data.array_0_0_8_0  &&
    uArch_1.dcache.data.array_0_0_9_0        == uArch_2.dcache.data.array_0_0_9_0  &&
    uArch_1.dcache.data.array_0_0_10_0       == uArch_2.dcache.data.array_0_0_10_0 &&
    uArch_1.dcache.data.array_0_0_11_0       == uArch_2.dcache.data.array_0_0_11_0 &&
    uArch_1.dcache.data.array_0_0_12_0       == uArch_2.dcache.data.array_0_0_12_0 &&
    uArch_1.dcache.data.array_0_0_13_0       == uArch_2.dcache.data.array_0_0_13_0 &&
    uArch_1.dcache.data.array_0_0_14_0       == uArch_2.dcache.data.array_0_0_14_0;
  wire same_init_pubstate = init? same_pubmem: 1'h1;




  // STEP: Shadow Logic to finish Phase1, i.e., uArch deviation found
  reg deviation_found;
  wire deviation =
    uArch_1.core.rob.my_commit_valid!=uArch_2.core.rob.my_commit_valid ||
    uArch_1.my_mem_addr             !=uArch_2.my_mem_addr;
  reg [3:0] ROB_tail_1, ROB_tail_2;
  
  wire [3:0] ROB_next_tail_1, ROB_next_tail_2;
  assign ROB_next_tail_1 =
    (uArch_1.core.rob.my_ROB_squash &&
     (uArch_1.core.rob.my_ROB_squash_tail - uArch_1.core.rob.my_ROB_head <
                               ROB_tail_1 - uArch_1.core.rob.my_ROB_head))?
    uArch_1.core.rob.my_ROB_squash_tail : ROB_tail_1;
  assign ROB_next_tail_2 =
    (uArch_2.core.rob.my_ROB_squash &&
     (uArch_2.core.rob.my_ROB_squash_tail - uArch_2.core.rob.my_ROB_head <
                               ROB_tail_2 - uArch_2.core.rob.my_ROB_head))?
    uArch_2.core.rob.my_ROB_squash_tail : ROB_tail_2;
  
  always @(posedge clk)
    if (rst) begin
      deviation_found <= 0;
      ROB_tail_1 <= 0;
      ROB_tail_2 <= 0;
    end

    else if (!deviation_found) begin
      if (deviation) begin
        deviation_found <= 1'h1;
        ROB_tail_1 <= ROB_next_tail_1;
        ROB_tail_2 <= ROB_next_tail_2;
      end

      else begin
        ROB_tail_1 <= uArch_1.core.rob.my_ROB_tail;
        ROB_tail_2 <= uArch_2.core.rob.my_ROB_tail;
      end
    end

    else begin
      ROB_tail_1 <= ROB_next_tail_1;
      ROB_tail_2 <= ROB_next_tail_2;
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
        if ( uArch_1.core.rob.my_commit_valid &&  uArch_2.core.rob.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
        end
        
        if ( uArch_1.core.rob.my_commit_valid && !uArch_2.core.rob.my_commit_valid) begin
          ISA_just_compared <= 1'h0;
          stall_1 <= 1;
        end
        
        if (!uArch_1.core.rob.my_commit_valid &&  uArch_2.core.rob.my_commit_valid) begin
          ISA_just_compared <= 1'h0;
          stall_2 <= 1;
        end
      end
    
      // STEP.2: Stall uArch_1.
      if ( stall_1 && !stall_2) begin
        if (uArch_2.core.rob.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
          stall_1 <= 0;
        end
      end
    
      // STEP.3: Stall uArch_2.
      if (!stall_1 &&  stall_2) begin
        if (uArch_1.core.rob.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
          stall_2 <= 0;
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
      if (uArch_1.core.rob.my_commit_valid && uArch_1.core.rob.my_ROB_head==(ROB_next_tail_1-1)
          || uArch_1.core.rob.my_ROB_head==ROB_next_tail_1)
        drained_1 <= 1'h1;
      
      if (uArch_2.core.rob.my_commit_valid && uArch_2.core.rob.my_ROB_head==(ROB_next_tail_2-1)
          || uArch_2.core.rob.my_ROB_head==ROB_next_tail_2)
        drained_2 <= 1'h1;
    end




  // STEP: contract assumption
  wire contract_assumption =
    (uArch_1.core.rob.my_commit_valid && uArch_2.core.rob.my_commit_valid)?
    uArch_1.core.rob.my_commit_data==uArch_2.core.rob.my_commit_data : 1'h1;




  // STEP: leakage assertion
  wire leakage_assertion = !(
    deviation_found &&         // STEP.1: Phase1 finished
    drained_1 && drained_2 &&  // STEP.2: Phase2 finished
    ISA_just_compared          // STEP.3: Synchronization finished
  );

endmodule

