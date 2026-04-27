
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
  RocketTile uArch_1(
    .clock(stall_1? 0: clk),
    .reset(rst),

    .auto_buffer_out_a_ready(1'h0),

    .auto_buffer_out_b_valid(1'h0),
    .auto_buffer_out_b_bits_opcode(3'h0),
    .auto_buffer_out_b_bits_param(2'h0),
    .auto_buffer_out_b_bits_size(4'h0),
    .auto_buffer_out_b_bits_source(2'h0),
    .auto_buffer_out_b_bits_address(32'h0),
    .auto_buffer_out_b_bits_mask(8'h0),
    .auto_buffer_out_b_bits_data(64'h0),
    .auto_buffer_out_b_bits_corrupt(1'h0),

    .auto_buffer_out_c_ready(1'h0),

    .auto_buffer_out_d_valid(1'h0),
    .auto_buffer_out_d_bits_opcode(3'h0),
    .auto_buffer_out_d_bits_param(2'h0),
    .auto_buffer_out_d_bits_size(4'h0),
    .auto_buffer_out_d_bits_source(2'h0),
    .auto_buffer_out_d_bits_sink(3'h0),
    .auto_buffer_out_d_bits_denied(1'h0),
    .auto_buffer_out_d_bits_data(64'h0),
    .auto_buffer_out_d_bits_corrupt(1'h0),

    .auto_buffer_out_e_ready(1'h0),

    .auto_int_local_in_2_0(1'h0),
    .auto_int_local_in_1_0(1'h0),
    .auto_int_local_in_1_1(1'h0),
    .auto_int_local_in_0_0(1'h0),

    .auto_reset_vector_in(32'h80000000),
    .auto_hartid_in(1'h0)
  );
  RocketTile uArch_2(
    .clock(stall_2? 0: clk),
    .reset(rst),

    .auto_buffer_out_a_ready(1'h0),

    .auto_buffer_out_b_valid(1'h0),
    .auto_buffer_out_b_bits_opcode(3'h0),
    .auto_buffer_out_b_bits_param(2'h0),
    .auto_buffer_out_b_bits_size(4'h0),
    .auto_buffer_out_b_bits_source(2'h0),
    .auto_buffer_out_b_bits_address(32'h0),
    .auto_buffer_out_b_bits_mask(8'h0),
    .auto_buffer_out_b_bits_data(64'h0),
    .auto_buffer_out_b_bits_corrupt(1'h0),

    .auto_buffer_out_c_ready(1'h0),

    .auto_buffer_out_d_valid(1'h0),
    .auto_buffer_out_d_bits_opcode(3'h0),
    .auto_buffer_out_d_bits_param(2'h0),
    .auto_buffer_out_d_bits_size(4'h0),
    .auto_buffer_out_d_bits_source(2'h0),
    .auto_buffer_out_d_bits_sink(3'h0),
    .auto_buffer_out_d_bits_denied(1'h0),
    .auto_buffer_out_d_bits_data(64'h0),
    .auto_buffer_out_d_bits_corrupt(1'h0),

    .auto_buffer_out_e_ready(1'h0),

    .auto_int_local_in_2_0(1'h0),
    .auto_int_local_in_1_0(1'h0),
    .auto_int_local_in_1_1(1'h0),
    .auto_int_local_in_0_0(1'h0),

    .auto_reset_vector_in(32'h80000000),
    .auto_hartid_in(1'h0)
  );




  // STEP: Simplification
  wire simplification =
    uArch_1.core.my_csr_cmd == 3'h0 &&
    uArch_2.core.my_csr_cmd == 3'h0 &&
    (uArch_1.frontend.icache.my_icache_valid? uArch_1.frontend.icache.my_icache_addr[32:6] == 27'h2000000 : 1'b1) &&
    (uArch_2.frontend.icache.my_icache_valid? uArch_2.frontend.icache.my_icache_addr[32:6] == 27'h2000000 : 1'b1) &&
    (uArch_1.dcache.my_dcache_valid? uArch_1.dcache.my_dcache_addr[33:6] == 28'h2000004 : 1'b1) &&
    (uArch_2.dcache.my_dcache_valid? uArch_2.dcache.my_dcache_addr[33:6] == 28'h2000004 : 1'b1)
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
    uArch_1.frontend.icache.data_arrays_0_0_0==uArch_2.frontend.icache.data_arrays_0_0_0 &&
    uArch_1.frontend.icache.data_arrays_0_1_0==uArch_2.frontend.icache.data_arrays_0_1_0 &&
    uArch_1.frontend.icache.data_arrays_0_2_0==uArch_2.frontend.icache.data_arrays_0_2_0 &&
    uArch_1.frontend.icache.data_arrays_0_3_0==uArch_2.frontend.icache.data_arrays_0_3_0 &&
    uArch_1.frontend.icache.data_arrays_0_4_0==uArch_2.frontend.icache.data_arrays_0_4_0 &&
    uArch_1.frontend.icache.data_arrays_0_5_0==uArch_2.frontend.icache.data_arrays_0_5_0 &&
    uArch_1.frontend.icache.data_arrays_0_6_0==uArch_2.frontend.icache.data_arrays_0_6_0 &&
    uArch_1.frontend.icache.data_arrays_0_7_0==uArch_2.frontend.icache.data_arrays_0_7_0 &&
    uArch_1.frontend.icache.data_arrays_1_0_0==uArch_2.frontend.icache.data_arrays_1_0_0 &&
    uArch_1.frontend.icache.data_arrays_1_1_0==uArch_2.frontend.icache.data_arrays_1_1_0 &&
    uArch_1.frontend.icache.data_arrays_1_2_0==uArch_2.frontend.icache.data_arrays_1_2_0 &&
    uArch_1.frontend.icache.data_arrays_1_3_0==uArch_2.frontend.icache.data_arrays_1_3_0 &&
    uArch_1.frontend.icache.data_arrays_1_4_0==uArch_2.frontend.icache.data_arrays_1_4_0 &&
    uArch_1.frontend.icache.data_arrays_1_5_0==uArch_2.frontend.icache.data_arrays_1_5_0 &&
    uArch_1.frontend.icache.data_arrays_1_6_0==uArch_2.frontend.icache.data_arrays_1_6_0 &&
    uArch_1.frontend.icache.data_arrays_1_7_0==uArch_2.frontend.icache.data_arrays_1_7_0 &&

    uArch_1.dcache.data.data_arrays_0_0_0==uArch_2.dcache.data.data_arrays_0_0_0 &&
    uArch_1.dcache.data.data_arrays_0_0_1==uArch_2.dcache.data.data_arrays_0_0_1 &&
    uArch_1.dcache.data.data_arrays_0_0_2==uArch_2.dcache.data.data_arrays_0_0_2 &&
    uArch_1.dcache.data.data_arrays_0_0_3==uArch_2.dcache.data.data_arrays_0_0_3 &&
    uArch_1.dcache.data.data_arrays_0_0_4==uArch_2.dcache.data.data_arrays_0_0_4 &&
    uArch_1.dcache.data.data_arrays_0_0_5==uArch_2.dcache.data.data_arrays_0_0_5 &&
    uArch_1.dcache.data.data_arrays_0_0_6==uArch_2.dcache.data.data_arrays_0_0_6 &&
    uArch_1.dcache.data.data_arrays_0_0_7==uArch_2.dcache.data.data_arrays_0_0_7 &&
    uArch_1.dcache.data.data_arrays_0_1_0==uArch_2.dcache.data.data_arrays_0_1_0 &&
    uArch_1.dcache.data.data_arrays_0_1_1==uArch_2.dcache.data.data_arrays_0_1_1 &&
    uArch_1.dcache.data.data_arrays_0_1_2==uArch_2.dcache.data.data_arrays_0_1_2 &&
    uArch_1.dcache.data.data_arrays_0_1_3==uArch_2.dcache.data.data_arrays_0_1_3 &&
    uArch_1.dcache.data.data_arrays_0_1_4==uArch_2.dcache.data.data_arrays_0_1_4 &&
    uArch_1.dcache.data.data_arrays_0_1_5==uArch_2.dcache.data.data_arrays_0_1_5 &&
    uArch_1.dcache.data.data_arrays_0_1_6==uArch_2.dcache.data.data_arrays_0_1_6 &&
    uArch_1.dcache.data.data_arrays_0_1_7==uArch_2.dcache.data.data_arrays_0_1_7 &&
    uArch_1.dcache.data.data_arrays_0_2_0==uArch_2.dcache.data.data_arrays_0_2_0 &&
    uArch_1.dcache.data.data_arrays_0_2_1==uArch_2.dcache.data.data_arrays_0_2_1 &&
    uArch_1.dcache.data.data_arrays_0_2_2==uArch_2.dcache.data.data_arrays_0_2_2 &&
    uArch_1.dcache.data.data_arrays_0_2_3==uArch_2.dcache.data.data_arrays_0_2_3 &&
    uArch_1.dcache.data.data_arrays_0_2_4==uArch_2.dcache.data.data_arrays_0_2_4 &&
    uArch_1.dcache.data.data_arrays_0_2_5==uArch_2.dcache.data.data_arrays_0_2_5 &&
    uArch_1.dcache.data.data_arrays_0_2_6==uArch_2.dcache.data.data_arrays_0_2_6 &&
    uArch_1.dcache.data.data_arrays_0_2_7==uArch_2.dcache.data.data_arrays_0_2_7 &&
    uArch_1.dcache.data.data_arrays_0_3_0==uArch_2.dcache.data.data_arrays_0_3_0 &&
    uArch_1.dcache.data.data_arrays_0_3_1==uArch_2.dcache.data.data_arrays_0_3_1 &&
    uArch_1.dcache.data.data_arrays_0_3_2==uArch_2.dcache.data.data_arrays_0_3_2 &&
    uArch_1.dcache.data.data_arrays_0_3_3==uArch_2.dcache.data.data_arrays_0_3_3 &&
    uArch_1.dcache.data.data_arrays_0_3_4==uArch_2.dcache.data.data_arrays_0_3_4 &&
    uArch_1.dcache.data.data_arrays_0_3_5==uArch_2.dcache.data.data_arrays_0_3_5 &&
    uArch_1.dcache.data.data_arrays_0_3_6==uArch_2.dcache.data.data_arrays_0_3_6 &&
    uArch_1.dcache.data.data_arrays_0_3_7==uArch_2.dcache.data.data_arrays_0_3_7 &&
    uArch_1.dcache.data.data_arrays_0_4_0==uArch_2.dcache.data.data_arrays_0_4_0 &&
    uArch_1.dcache.data.data_arrays_0_4_1==uArch_2.dcache.data.data_arrays_0_4_1 &&
    uArch_1.dcache.data.data_arrays_0_4_2==uArch_2.dcache.data.data_arrays_0_4_2 &&
    uArch_1.dcache.data.data_arrays_0_4_3==uArch_2.dcache.data.data_arrays_0_4_3 &&
    uArch_1.dcache.data.data_arrays_0_4_4==uArch_2.dcache.data.data_arrays_0_4_4 &&
    uArch_1.dcache.data.data_arrays_0_4_5==uArch_2.dcache.data.data_arrays_0_4_5 &&
    uArch_1.dcache.data.data_arrays_0_4_6==uArch_2.dcache.data.data_arrays_0_4_6 &&
    uArch_1.dcache.data.data_arrays_0_4_7==uArch_2.dcache.data.data_arrays_0_4_7 &&
    uArch_1.dcache.data.data_arrays_0_5_0==uArch_2.dcache.data.data_arrays_0_5_0 &&
    uArch_1.dcache.data.data_arrays_0_5_1==uArch_2.dcache.data.data_arrays_0_5_1 &&
    uArch_1.dcache.data.data_arrays_0_5_2==uArch_2.dcache.data.data_arrays_0_5_2 &&
    uArch_1.dcache.data.data_arrays_0_5_3==uArch_2.dcache.data.data_arrays_0_5_3 &&
    uArch_1.dcache.data.data_arrays_0_5_4==uArch_2.dcache.data.data_arrays_0_5_4 &&
    uArch_1.dcache.data.data_arrays_0_5_5==uArch_2.dcache.data.data_arrays_0_5_5 &&
    uArch_1.dcache.data.data_arrays_0_5_6==uArch_2.dcache.data.data_arrays_0_5_6 &&
    uArch_1.dcache.data.data_arrays_0_5_7==uArch_2.dcache.data.data_arrays_0_5_7 &&
    uArch_1.dcache.data.data_arrays_0_6_0==uArch_2.dcache.data.data_arrays_0_6_0 &&
    uArch_1.dcache.data.data_arrays_0_6_1==uArch_2.dcache.data.data_arrays_0_6_1 &&
    uArch_1.dcache.data.data_arrays_0_6_2==uArch_2.dcache.data.data_arrays_0_6_2 &&
    uArch_1.dcache.data.data_arrays_0_6_3==uArch_2.dcache.data.data_arrays_0_6_3 &&
    uArch_1.dcache.data.data_arrays_0_6_4==uArch_2.dcache.data.data_arrays_0_6_4 &&
    uArch_1.dcache.data.data_arrays_0_6_5==uArch_2.dcache.data.data_arrays_0_6_5 &&
    uArch_1.dcache.data.data_arrays_0_6_6==uArch_2.dcache.data.data_arrays_0_6_6 &&
    uArch_1.dcache.data.data_arrays_0_6_7==uArch_2.dcache.data.data_arrays_0_6_7;
  wire same_init_pubstate = init? same_pubmem: 1'h1;




  // STEP: Shadow Logic to finish Phase1, i.e., uArch deviation found
  reg  deviation_found;
  wire deviation =
    uArch_1.core.my_commit_valid!=uArch_2.core.my_commit_valid ||
    uArch_1.frontend.icache.my_icache_valid!=uArch_2.frontend.icache.my_icache_valid ||
    uArch_1.frontend.icache.my_icache_valid && uArch_2.frontend.icache.my_icache_valid
      && uArch_1.frontend.icache.my_icache_addr!=uArch_2.frontend.icache.my_icache_addr ||
    uArch_1.dcache.my_dcache_valid!=uArch_2.dcache.my_dcache_valid ||
    uArch_1.dcache.my_dcache_valid && uArch_2.dcache.my_dcache_valid
      && uArch_1.dcache.my_dcache_addr!=uArch_2.dcache.my_dcache_addr;
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
        if ( uArch_1.core.my_commit_valid &&  uArch_2.core.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
        end
        
        if ( uArch_1.core.my_commit_valid && !uArch_2.core.my_commit_valid) begin
          ISA_just_compared <= 1'h0;
          stall_1 = 1;
        end
        
        if (!uArch_1.core.my_commit_valid &&  uArch_2.core.my_commit_valid) begin
          ISA_just_compared <= 1'h0;
          stall_2 = 1;
        end
      end
    
      // STEP.2: Stall uArch_1.
      if ( stall_1 && !stall_2) begin
        if (uArch_2.core.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
          stall_1 = 0;
        end
      end
    
      // STEP.3: Stall uArch_2.
      if (!stall_1 &&  stall_2) begin
        if (uArch_1.core.my_commit_valid) begin
          ISA_just_compared <= 1'h1;
          stall_2 = 0;
        end
      end
    end




  // STEP: Shadow Logic to finish Phase2, i.e., pipeline drained
  reg [2:0] draining_countdown;
  wire drained_1 = draining_countdown==0;
  wire drained_2 = draining_countdown==0;
  always @(posedge clk)
  if (rst)
    draining_countdown <= 3'h4;
  else if (deviation_found && draining_countdown!=0)
    draining_countdown <= draining_countdown - 1;




  // STEP: contract assumption
  wire contract_assumption =
    (uArch_1.core.my_commit_valid && uArch_2.core.my_commit_valid)?
      ((uArch_1.core.my_commit_wen && uArch_2.core.my_commit_wen)?
         uArch_1.core.my_commit_data==uArch_2.core.my_commit_data :
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

